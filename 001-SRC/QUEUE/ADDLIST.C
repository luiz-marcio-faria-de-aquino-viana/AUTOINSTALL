
#include<stdio.h>
#include<conio.h>
#include<io.h>
#include<fcntl.h>
#include<string.h>
#include<stdlib.h>
#include<dos.h>

#define RSLT_OK  1
#define RSLT_ERR 0

#define BUFFSIZE 16*1024

#define ENV_QUEUE_DIR "QUEUE"

#define PARM_FILENAME   "/F="
#define PARM_QUEUE_ID   "/Id="
#define PARM_QUEUENAME  "/Q="
#define PARM_PAPERSZ    "/Sz="
#define PARM_PAPER_TYPE "/P="
#define PARM_NCOPIES    "/C="
#define PARM_FAXNUM     "/Fn="
#define PARM_FAXTO      "/To="

#define QUEUE_LIST "QUEUE.DAT"
#define QUEUE_FILE "QUEUEFIL.DAT"

#define SHARE_FILE "SHAREFIL.DAT"

#define FILE_EXT ""

#define RADIX 10

typedef int HANDLE;

typedef char str_t [256];

typedef struct tagParm {
  int queueId;
  char queueName [13];
  char fName [13];
  char pType [2];
  char pSize [3];
  char nCopies [3];
  char faxNum  [17];
  char faxTo   [21];
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

void ClrStruct(void *struc, int len);

void GetCurrDate(char *cdate);
void GetCurrTime(char *ctime);

int GetPathName(char *pathName);
int GetParam(int argc, char *argv[], parm_t *Parm);
int GetQueueInfo(const char *pathName, const parm_t *Parm, queueInfo_t *queueInfo);
int GetCodeName(const char *queuePath, char *cdName);
int CopyFile(const char *srcFile, const char *dstFile);
int AddList(const char *queuePath, const queueData_t *queueData);

void InitScr(void);

main(int argc, char *argv[])
{
  parm_t Parm;
  queueInfo_t queueInfo;
  queueData_t queueData;

  str_t pathName;
  str_t queuePath;

  str_t fullCodeName;

  ClrStruct(&Parm, sizeof(parm_t));
  ClrStruct(&queueInfo, sizeof(queueInfo_t));
  ClrStruct(&queueData, sizeof(queueData_t));

  InitScr();

  if(GetPathName(pathName))
  {
    if(GetParam(argc, argv, &Parm))
    {
      if(GetQueueInfo(pathName, &Parm, &queueInfo))
      {
	strcat(strcat(strcpy(queuePath, pathName), queueInfo.queueDir), "\\");
	if(GetCodeName(queuePath, queueData.cdName))
	{
	  strcat(strcpy(fullCodeName, queuePath), queueData.cdName);
	  if(CopyFile(Parm.fName, fullCodeName))
	  {
	    strcpy(queueData.fName, Parm.fName);
	    strcpy(queueData.usrName, getenv("USR"));
	    GetCurrDate(queueData.cdate);
	    GetCurrTime(queueData.ctime);
	    strcpy(queueData.pType, Parm.pType);
	    strcpy(queueData.pSize, Parm.pSize);
	    strcpy(queueData.nCopies, Parm.nCopies);
	    strcpy(queueData.faxNum, Parm.faxNum);
	    strcpy(queueData.faxTo, Parm.faxTo);
	    if(AddList(queuePath, &queueData))
	      printf("Arquivo adicionado!\n");
	  }
	  else
	  {
	    printf("ERR: Can't copy the original file.");
	  }
	}
      }
    }
    else
    {
      printf("ERR: Invalid Parameters.\n");
    }
  }
  else
  {
    printf("ERR: Queue Directory not Find.\n");
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
  strcpy(Parm->pSize, "?");
  strcpy(Parm->pType, "?");
  strcpy(Parm->nCopies, "?");
  strcpy(Parm->faxNum, "?");
  strcpy(Parm->faxTo, "?");

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
    if(!strnicmp(PARM_FILENAME, argv[numParm], strlen(PARM_FILENAME)))
    {
      strncpy(Parm->fName, &argv[numParm][3], 12);
      contParm = contParm | 0x04;
    }
    if(!strnicmp(PARM_PAPERSZ, argv[numParm], strlen(PARM_PAPERSZ)))
    {
      strncpy(Parm->pSize, &argv[numParm][4], 2);
      contParm = contParm | 0x08;
    }
    if(!strnicmp(PARM_PAPER_TYPE, argv[numParm], strlen(PARM_PAPER_TYPE)))
    {
      strncpy(Parm->pType, &argv[numParm][3], 1);
      contParm = contParm | 0x10;
    }
    if(!strnicmp(PARM_NCOPIES, argv[numParm], strlen(PARM_NCOPIES)))
    {
      strncpy(Parm->nCopies, &argv[numParm][3], 1);
      contParm = contParm | 0x20;
    }
    if(!strnicmp(PARM_FAXNUM, argv[numParm], strlen(PARM_FAXNUM)))
    {
      strncpy(Parm->faxNum, &argv[numParm][4], 16);
      contParm = contParm | 0x40;
    }
    if(!strnicmp(PARM_FAXTO, argv[numParm], strlen(PARM_FAXTO)))
    {
      strncpy(Parm->faxTo, &argv[numParm][4], 20);
      contParm = contParm | 0x80;
    }
  }
  if((contParm & 0x05) || (contParm & 0x03)) rst = RSLT_OK;

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

int GetCodeName(const char *queuePath, char *cdName)
{
  HANDLE fileHandle;
  str_t fullFileName;

  int cdNum = 0;

  int rst = RSLT_ERR;

  strcat(strcpy(fullFileName, queuePath), SHARE_FILE);
  if((fileHandle = open(fullFileName, O_RDWR | O_EXCL | O_BINARY)) != -1)
  {
    if(read(fileHandle, &cdNum, sizeof(int)) > 0)
    {
      cdNum = (cdNum + 1) % 10000;
      lseek(fileHandle, 0, SEEK_SET);
      write(fileHandle, &cdNum, sizeof(int));
      rst = RSLT_OK;
    }
    close(fileHandle);
  }
  itoa(cdNum, cdName, RADIX);
  strcat(cdName, FILE_EXT);
  return rst;
}

int CopyFile(const char *srcFile, const char *dstFile)
{
  FILE *srcHandle, *dstHandle;

  char Sig [] = { '-', '\\', '|', '/' };

  char *buff;
  int numRead;

  int i = 0;

  int rst = RSLT_ERR;

  printf("Processando... ");
  if((buff = (char *) malloc(BUFFSIZE)) != NULL)
  {
    if((srcHandle = fopen(srcFile, "rb")) != NULL)
    {
      if((dstHandle = fopen(dstFile, "wb")) != NULL)
      {
	while((numRead = fread(buff, sizeof(char), BUFFSIZE, srcHandle)) > 0)
	{
	  fwrite(buff, sizeof(char), numRead, dstHandle);
	  i = (i + 1) % 4;
	  printf("%c", Sig[i]);
	  gotoxy(wherex() - 1, wherey());
	}
	rst = RSLT_OK;
	fclose(dstHandle);
      }
      printf("Ok!\n\n");
      fclose(srcHandle);
    }
    free(buff);
  }
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
    close(fileHandle);
    rst = RSLT_OK;
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
  strcat(strcat(cdate, "-"), MONTH [today.da_mon - 1]);
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

void InitScr(void)
{
  printf("ADD List V1.0 - by Luiz Marcio F A Viana, 9/5/95\n");
}
