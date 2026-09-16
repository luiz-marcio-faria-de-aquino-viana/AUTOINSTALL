#include<stdio.h>
#include<process.h>
#include<io.h>
#include<fcntl.h>
#include<string.h>
#include<stdlib.h>
#include<dos.h>
#include<conio.h>

#define RSLT_OK  1
#define RSLT_ERR 0

#define CNTL_ACTIVE    1
#define CNTL_DESACTIVE 0

#define BUFFSIZE 8*1024

#define ENV_QUEUE_DIR "QUEUE"

#define PARM_QUEUE_ID   "/id="
#define PARM_QUEUENAME  "/Q="
#define PARM_AUTOMODE   "/a"

#define QUEUE_LIST "QUEUE.DAT"
#define QUEUE_FILE "QUEUEFIL.DAT"

#define K_CR     13
#define K_ESC    27
#define K_ALT_X 173
#define K_F5    191
#define K_F6    192
#define K_UP    200
#define K_LEFT  203
#define K_RIGHT 205
#define K_DOWN  208
#define K_DEL   211

#define FAX_SUCCESSFULLY 5
#define FAX_FAILURE      1
#define FAX_ABORT        0

#define RADIX 10

#define MAXLN 20

typedef int HANDLE;

typedef char str_t [256];

typedef struct tagParm {
  int queueId;
  char queueName [13];
  int autoMode;
} parm_t;

typedef struct tagInfo {
  int queueId;
  char queueName [13];
  char queueDir [48];
} queueInfo_t;

typedef struct tagData {
  char dataFlag;
  char cdName  [9];
  char fName   [13];
  char usrName [9];
  char cdate   [7];
  char ctime   [6];
  char pType   [2];
  char pSize   [3];
  char nCopies [3];
  char faxNum  [17];
  char faxTo   [21];
} queueData_t;

struct tagList {
  struct tagList *prevElem;
  long dataPos;
  queueData_t queueData;
  struct tagList *nextElem;
};

void ClrStruct(void *struc, int len);

void GetCurrDate(char *cdate);
void GetCurrTime(char *ctime);

int GetPathName(char *pathName);
int GetParam(int argc, char *argv[], parm_t *Parm);
int GetQueueInfo(const char *pathName, const parm_t *Parm, queueInfo_t *queueInfo);

int SendFilePos(const char *queuePath, int Pos);

int ConstructList(const char *queuePath);
int RefreshList(const char *queuePath);
int InsertInList(struct tagList *Elem);
int GetElem(int Pos, struct tagList **listElem);
int GetNextElem(struct tagList **listElem);
int GetPrevElem(struct tagList **listElem);
int RemoveFromList(int Pos);
int DelElem(const char *queuePath, struct tagList *listElem);
int DelElemPos(const char *queuePath, int Pos);
int MoveElemPos(const char *queuePath, int Pos);
int AddList(const char *queuePath, const queueData_t *queueData);
void DestructList(void);

void InvScr(void);
void NormScr(void);
void InitScr(void);
void InitCpyScr(int x, int y);
void ClrWin(int x1, int y1, int x2, int y2);
int DisplayList(int In);
void DisplayElem(int x, int y, struct tagList *listElem);
void DisplayElemPos(int x, int y, int Pos);

int DelConf(int x, int y);
int ReadChar(void);

struct tagList *firstElem = NULL;
struct tagList *lastElem = NULL;

int cntlFlag = CNTL_DESACTIVE;

main(int argc, char *argv[])
{
  parm_t Parm;
  queueInfo_t queueInfo;

  str_t pathName;
  str_t queuePath;

  int InElem, FnElem;
  int CurElem;

  int max;
  int Ch;

  long Cnt = 0;

  ClrStruct(&Parm, sizeof(parm_t));
  ClrStruct(&queueInfo, sizeof(queueInfo_t));
  if(GetPathName(pathName))
  {
    if(GetParam(argc, argv, &Parm))
    {
      if(GetQueueInfo(pathName, &Parm, &queueInfo))
      {
	strcat(strcat(strcpy(queuePath, pathName), queueInfo.queueDir), "\\");
	max = ConstructList(queuePath);
	if( Parm.autoMode ) cntlFlag = CNTL_ACTIVE;
	InitScr();
	InElem = FnElem = CurElem = 0;
	if(max > 0)
	{
	  FnElem = DisplayList(InElem);
	  InvScr();
	  DisplayElemPos(3, CurElem - InElem + 5, CurElem);
	  NormScr();
	}
	do {
	  Ch = ReadChar();
	  switch (Ch) {
	    case K_UP:
	    case K_LEFT:
	      if(CurElem > InElem)
	      {
		DisplayElemPos(3, CurElem - InElem + 5, CurElem);
		CurElem = CurElem - 1;
		InvScr();
		DisplayElemPos(3, CurElem - InElem + 5, CurElem);
		NormScr();
	      }
	      else
	      {
		if(InElem > 0)
		{
		  InElem = InElem - 1;
		  FnElem = DisplayList(InElem);
		  CurElem = CurElem - 1;
		  InvScr();
		  DisplayElemPos(3, CurElem - InElem + 5, CurElem);
		  NormScr();
		}
	      }
	      break;
	    case K_DOWN:
	    case K_RIGHT:
	      if(CurElem < FnElem - 1)
	      {
		DisplayElemPos(3, CurElem - InElem + 5, CurElem);
		CurElem = CurElem + 1;
		InvScr();
		DisplayElemPos(3, CurElem - InElem + 5, CurElem);
		NormScr();
	      }
	      else
	      {
		if(FnElem < max)
		{
		  InElem = InElem + 1;
		  FnElem = DisplayList(InElem);
		  CurElem = CurElem + 1;
		  InvScr();
		  DisplayElemPos(3, CurElem - InElem + 5, CurElem);
		  NormScr();
		}
	      }
	      break;
	    case K_F5:
	      ClrWin(2, 5, 78, 24);
	      if((max = RefreshList(queuePath)) != 0)
	      {
		InElem = CurElem = 0;
		FnElem = DisplayList(InElem);
		InvScr();
		DisplayElemPos(3, CurElem - InElem + 5, CurElem);
		NormScr();
	      }
	      break;
	    case K_F6:
	      cntlFlag = (cntlFlag + 1) % 2;
	      switch (cntlFlag) {
		case CNTL_ACTIVE :
		  gotoxy(3, 25);
		  printf(" AUTO =  ON ");
		  break;
		case CNTL_DESACTIVE :
		  gotoxy(3, 25);
		  printf(" AUTO = OFF ");
		  break;
	      }
	      break;
	    case K_DEL:
	      if((max > 0) && DelConf(32, 10))
	      {
		if(DelElemPos(queuePath, CurElem))
		{
		  ClrWin(2, 5, 78, 24);
		  if((max = RefreshList(queuePath)) != 0)
		  {
		    InElem = CurElem = 0;
		    FnElem = DisplayList(InElem);
		    InvScr();
		    DisplayElemPos(3, CurElem - InElem + 5, CurElem);
		    NormScr();
		  }
		}
	      }
	      break;
	    case K_CR:
	      switch(SendFilePos(queuePath, CurElem)) {
		case FAX_SUCCESSFULLY :
		  DelElemPos(queuePath, CurElem);
		  break;
		case FAX_FAILURE :
		  MoveElemPos(queuePath, CurElem);
		  break;
		case FAX_ABORT :
		  cntlFlag = CNTL_DESACTIVE;
		  switch (cntlFlag) {
		    case CNTL_ACTIVE :
		      gotoxy(3, 25);
		      printf(" AUTO =  ON ");
		      break;
		    case CNTL_DESACTIVE :
		      gotoxy(3, 25);
		      printf(" AUTO = OFF ");
		      break;
		  }
	      }
	      ClrWin(2, 5, 78, 24);
	      if((max = RefreshList(queuePath)) != 0)
	      {
		InElem = CurElem = 0;
		FnElem = DisplayList(InElem);
		InvScr();
		DisplayElemPos(3, CurElem - InElem + 5, CurElem);
		NormScr();
	      }
	      break;
	  };
	  if((max > 0) && (cntlFlag == CNTL_ACTIVE))
	  {
	    switch(SendFilePos(queuePath, CurElem)) {
	      case FAX_SUCCESSFULLY :
		DelElemPos(queuePath, CurElem);
		break;
	      case FAX_FAILURE :
		MoveElemPos(queuePath, CurElem);
		break;
	      case FAX_ABORT :
		cntlFlag = CNTL_DESACTIVE;
		switch (cntlFlag) {
		  case CNTL_ACTIVE :
		    gotoxy(3, 25);
		    printf(" AUTO =  ON ");
		    break;
		  case CNTL_DESACTIVE :
		    gotoxy(3, 25);
		    printf(" AUTO = OFF ");
		    break;
		}
	    }
	    ClrWin(2, 5, 78, 24);
	    if((max = RefreshList(queuePath)) != 0)
	    {
	      InElem = CurElem = 0;
	      FnElem = DisplayList(InElem);
	      InvScr();
	      DisplayElemPos(3, CurElem - InElem + 5, CurElem);
	      NormScr();
	    }
	  }
	  if((Cnt = (Cnt + 1) % 30000) == 0)
	  {
	    ClrWin(2, 5, 78, 24);
	    if((max = RefreshList(queuePath)) != 0)
	    {
	      FnElem = DisplayList(InElem);
	      InvScr();
	      DisplayElemPos(3, CurElem - InElem + 5, CurElem);
	      NormScr();
	    }
	  }
	} while(Ch != K_ALT_X);
	clrscr();
	printf("TCHAU...");
      }
    }
  }
  return(0);
}

int GetPathName(char *pathName)
{
  int rst = RSLT_ERR;
  if(getenv(ENV_QUEUE_DIR) != NULL)
  {
    strcpy(pathName, getenv(ENV_QUEUE_DIR));
    rst = RSLT_OK;
  }
  return rst;
}

int GetParam(int argc, char *argv[], parm_t *Parm)
{
  int numParm, contParm = 0;
  int rst = RSLT_ERR;

  Parm->queueId = -1;
  strcpy(Parm->queueName, "?");

  Parm->autoMode = 0;

  numParm = argc;
  while((numParm = numParm - 1) > 0)
  {
    if(!strnicmp(PARM_QUEUE_ID, argv[numParm], strlen(PARM_QUEUE_ID)))
    {
      Parm->queueId = atoi(&argv[numParm][4]);
      contParm = contParm | 0x01;
    }
    if(!strnicmp(PARM_QUEUENAME, argv[numParm], strlen(PARM_QUEUENAME)))
    {
      strncpy(Parm->queueName, &argv[numParm][3], 12);
      contParm = contParm | 0x02;
    }
    if(!strnicmp(PARM_AUTOMODE, argv[numParm], strlen(PARM_AUTOMODE)))
      Parm->autoMode = 1;
  }
  if((contParm & 0x01) || (contParm & 0x02)) rst = RSLT_OK;

  return rst;
}

int GetQueueInfo(const char *pathName, const parm_t *Parm, queueInfo_t *queueInfo)
{
  HANDLE fileHandle;
  str_t fullFileName;

  int rst = RSLT_ERR;

  strcat(strcpy(fullFileName, pathName), QUEUE_LIST);
  if((fileHandle = open(fullFileName, O_RDONLY | O_BINARY)) != -1)
  {
    while(read(fileHandle, queueInfo, sizeof(queueInfo_t)) > 0)
    {
      if((Parm->queueId != -1) && (Parm->queueId == queueInfo->queueId))
      {
	rst = RSLT_OK;
	break;
      }
      if(!stricmp(Parm->queueName, queueInfo->queueName))
      {
	rst = RSLT_OK;
	break;
      }
    }
    close(fileHandle);
  }
  return rst;
}

int SendFilePos(const char *queuePath, int Pos)
{
  struct tagList *Elem;
  str_t fullFileName;
  str_t faxFrom, faxTo;

  int rst = 0;

  if(GetElem(Pos, &Elem))
  {
    clrscr();
    strcat(strcpy(faxFrom, "/Fr="), (Elem->queueData).usrName);
    strcat(strcpy(faxTo, "/To="), (Elem->queueData).faxTo);
    strcat(strcat(strcpy(fullFileName, queuePath), (Elem->queueData).cdName), ".");
    rst = spawnl(P_WAIT, "U:\\COMM\\BGFAX\\BGFAX", "", "/SEND", fullFileName, (Elem->queueData).faxNum, faxFrom, faxTo, NULL);
    InitScr();
  }
  return rst;
}

void GetCurrDate(char *cdate)
{
  char MONTH [12] [4] = { "JAN", "FEV", "MAR", "ABR", "MAI", "JUN",
			  "JUL", "AGO", "SET", "OUT", "NOV", "DEZ"  };
  struct date today;
  getdate(&today);
  itoa((int) today.da_day, cdate, RADIX);
  strcat(strcat(cdate, "-"), MONTH [today.da_mon]);
}

void GetCurrTime(char *ctime)
{
  struct time now;
  str_t hr, min;
  gettime(&now);
  itoa((unsigned) now.ti_hour, hr, RADIX);
  itoa((unsigned) now.ti_min, min, RADIX);
  strcat(strcat(strcpy(ctime, hr), ":"), min);
}

void ClrStruct(void *struc, int len)
{
  char *ptr;
  ptr = (char *) struc;
  while(len > 0)
  {
    len = len - 1;
    ptr [len] = '\0';
  }
}

int ConstructList(const char *queuePath)
{
  HANDLE fileHandle;
  struct tagList Elem;
  str_t fullFileName;
  int cnt = 0;

  strcat(strcpy(fullFileName, queuePath), QUEUE_FILE);
  if((fileHandle = open(fullFileName, O_RDONLY | O_EXCL | O_BINARY)) != -1)
  {
    while(read(fileHandle, &Elem.queueData, sizeof(queueData_t)) > 0)
    {
      if(Elem.queueData.dataFlag != '*')
      {
	Elem.dataPos = tell(fileHandle) - sizeof(queueData_t);
	if(!InsertInList(&Elem)) break;
	cnt = cnt + 1;
      }
    }
    close(fileHandle);
  }
  return cnt;
}

int RefreshList(const char *queuePath)
{
  DestructList();
  return ConstructList(queuePath);
}

int InsertInList(struct tagList *Elem)
{
  struct tagList *Ptr;
  int rst = RSLT_ERR;
  if((Ptr = (struct tagList *) malloc(sizeof(struct tagList))) != NULL)
  {
    if(firstElem == NULL)
      firstElem = Ptr;
    else
      lastElem->nextElem = Ptr;
    Ptr->prevElem = lastElem;
    memcpy(Ptr, Elem, sizeof(struct tagList));
    Ptr->nextElem = NULL;
    lastElem = Ptr;
    rst = RSLT_OK;
  }
  return rst;
}

int GetElem(int Pos, struct tagList **listElem)
{
  int rst = RSLT_ERR;
  *listElem = firstElem;
  while((Pos = Pos - 1) >= 0)
  {
    if(!GetNextElem(listElem)) break;
  }
  if(*listElem != NULL) rst = RSLT_OK;
  return rst;
}

int GetPrevElem(struct tagList **listElem)
{
  int rst = RSLT_ERR;
  if((*listElem)->prevElem != NULL)
  {
    *listElem = (*listElem)->prevElem;
    rst = RSLT_OK;
  }
  return rst;
}

int GetNextElem(struct tagList **listElem)
{
  int rst = RSLT_ERR;
  if((*listElem)->nextElem != NULL)
  {
    *listElem = (*listElem)->nextElem;
    rst = RSLT_OK;
  }
  return rst;
}

int RemoveFromList(int Pos)
{
  struct tagList *Elem = NULL;
  int rst = RSLT_ERR;
  if(GetElem(Pos, &Elem))
  {
    if(Elem->prevElem != NULL) (Elem->prevElem)->nextElem = Elem->nextElem;
    if(Elem->nextElem != NULL) (Elem->nextElem)->prevElem = Elem->prevElem;
    free(Elem);
    rst = RSLT_OK;
  }
  return rst;
}

int DelElem(const char *queuePath, struct tagList *listElem)
{
  HANDLE fileHandle;
  queueData_t queueData;
  str_t fullFileName;
  int rst = RSLT_ERR;

  strcat(strcpy(fullFileName, queuePath), QUEUE_FILE);
  if((fileHandle = open(fullFileName, O_RDWR | O_EXCL | O_BINARY)) != -1)
  {
    lseek(fileHandle, listElem->dataPos, SEEK_SET);
    if(read(fileHandle, &queueData, sizeof(queueData_t)) > 0)
    {
      queueData.dataFlag = '*';
      lseek(fileHandle, listElem->dataPos, SEEK_SET);
      write(fileHandle, &queueData, sizeof(queueData_t));
      rst = RSLT_OK;
    }
    close(fileHandle);
  }
  return rst;
}

int DelElemPos(const char *queuePath, int Pos)
{
  struct tagList *Elem;
  int rst = RSLT_ERR;
  if(GetElem(Pos, &Elem))
    if(DelElem(queuePath, Elem)) rst = RSLT_OK;
  return rst;
}

void DestructList(void)
{
  struct tagList *Ptr;
  while(firstElem != NULL)
  {
    Ptr = firstElem->nextElem;
    free(firstElem);
    firstElem = Ptr;
  }
  lastElem = NULL;
}

void InvScr()
{
  textcolor(BLACK);
  textbackground(LIGHTGRAY);
}

void NormScr()
{
  textcolor(LIGHTGRAY);
  textbackground(BLACK);
}

void InitScr(void)
{
  int i;
  clrscr();
  InvScr();
  cprintf("ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป\r\n");
  cprintf("บ                     G E R E N C I A D O R   D E   F A X                     บ\r\n");
  cprintf("ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ\r\n");
  NormScr();
  cprintf("ษอ NUM อ USUARIO ออ ARQUIVO ออออ DESTINATARIO อออออ FAX # ออออ DATA อออ HORA อป\r\n");
  for(i = 0; i < MAXLN; i++)
    cprintf("บ                                                                             บ\r\n");
  cprintf("ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ");
  gotoxy(3, 25);
  switch (cntlFlag) {
    case CNTL_ACTIVE :
      gotoxy(3, 25);
      printf(" AUTO =  ON ");
      break;
    case CNTL_DESACTIVE :
      gotoxy(3, 25);
      printf(" AUTO = OFF ");
      break;
  }
}

int DisplayList(int In)
{
  struct tagList *Ptr = NULL;
  int Cnt = 0;

  if(GetElem(In, &Ptr))
  {
    while(Cnt < MAXLN)
    {
      DisplayElem(3, Cnt + 5, Ptr);
      Cnt = Cnt + 1;
      if(!GetNextElem(&Ptr)) break;
    }
  }
  return (In + Cnt);
}

void DisplayElemPos(int x, int y, int Pos)
{
  struct tagList *Elem;
  GetElem(Pos, &Elem);
  DisplayElem(x, y, Elem);
}

void DisplayElem(int x, int y, struct tagList *listElem)
{
  gotoxy(x, y); cprintf("                                                                      ");
  gotoxy(x +  0, y); cprintf("%4s", listElem->queueData.cdName);
  gotoxy(x +  6, y); cprintf(" %s", listElem->queueData.usrName);
  gotoxy(x + 17, y); cprintf(" %s", listElem->queueData.fName);
  gotoxy(x + 30, y); cprintf(" %s", listElem->queueData.faxTo);
  gotoxy(x + 44, y); cprintf(" %13s", listElem->queueData.faxNum);
  gotoxy(x + 58, y); cprintf(" %7s", listElem->queueData.cdate);
  gotoxy(x + 68, y); cprintf(" %6s", listElem->queueData.ctime);
}

int ReadChar(void)
{
  int Ch = 0;
  if(kbhit())
  {
    if((Ch = getch()) == 0) Ch = 128 + getch();
  }
  return Ch;
}

void ClrWin(int x1, int y1, int x2, int y2)
{
  window(x1, y1, x2, y2);
  clrscr();
  window(1, 1, 80, 25);
}

int DelConf(int x, int y)
{
  int ptr[ 52 ];
  char arrOpt [2] [4] = { "Nao", "Sim" };
  int Opt = 0;

  int Ch;

  gettext(x, y, x + 12, y + 3, ptr);
  gotoxy(x,     y); printf("ษอ Apagar? อป");
  gotoxy(x, y + 1); printf("บ    Nao    บ");
  gotoxy(x, y + 2); printf("บ    Sim    บ");
  gotoxy(x, y + 3); printf("ศอออออออออออผ");
  InvScr();
  gotoxy(x + 2, y + Opt + 1);
  cprintf("   %s   ", arrOpt[Opt]);
  NormScr();
  do {
    Ch = ReadChar();
    switch(Ch) {
      case K_UP:
      case K_LEFT:
	gotoxy(x + 2, y + Opt + 1);
	cprintf("   %s   ", arrOpt[Opt]);
	Opt = (Opt - 1) % 2;
	InvScr();
	gotoxy(x + 2, y + Opt + 1);
	cprintf("   %s   ", arrOpt[Opt]);
	NormScr();
	break;
      case K_DOWN:
      case K_RIGHT:
	gotoxy(x + 2, y + Opt + 1);
	cprintf("   %s   ", arrOpt[Opt]);
	Opt = (Opt + 1) % 2;
	InvScr();
	gotoxy(x + 2, y + Opt + 1);
	cprintf("   %s   ", arrOpt[Opt]);
	NormScr();
	break;
    }
  } while((Ch != K_ESC) && (Ch != K_CR));
  if(Ch == K_ESC) Opt = 0;
  puttext(x, y, x + 12, y + 3, ptr);
  gotoxy(1, 1);
  return Opt;
}

int MoveElemPos(const char *queuePath, int Pos)
{
  struct tagList *Elem;
  int rst = RSLT_ERR;
  if(GetElem(Pos, &Elem))
    if(DelElem(queuePath, Elem))
      if(AddList(queuePath, &(Elem->queueData)))
	rst = RSLT_OK;
  return rst;
}

int AddList(const char *queuePath, const queueData_t *queueData)
{
  HANDLE fileHandle;
  str_t fullFileName;

  int rst = RSLT_ERR;

  strcat(strcpy(fullFileName, queuePath), QUEUE_FILE);
  if((fileHandle = open(fullFileName, O_WRONLY | O_EXCL | O_BINARY)) != -1)
  {
    lseek(fileHandle, 0, SEEK_END);
    write(fileHandle, queueData, sizeof(queueData_t));
    rst = RSLT_OK;
    close(fileHandle);
  }
  return rst;
}
