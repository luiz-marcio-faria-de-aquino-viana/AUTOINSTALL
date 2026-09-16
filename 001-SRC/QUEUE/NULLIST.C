#include<stdio.h>
#include<io.h>
#include<fcntl.h>
#include<string.h>
#include<stdlib.h>
#include<dos.h>

#define RSLT_OK  1
#define RSLT_ERR 0

#define BUFFSIZE 16*1024

#define ENV_QUEUE_DIR "QUEUE"

#define PARM_QUEUE_ID   "/Id="
#define PARM_QUEUENAME  "/Q="

#define QUEUE_LIST "QUEUE.DAT"
#define QUEUE_FILE "QUEUEFIL.DAT"

#define SHARE_FILE "SHAREFIL.DAT"

#define BATCH_FILE "c:\\killfil.bat"

#define FILE_EXT ""

#define RADIX 10

typedef int HANDLE;

typedef char str_t [256];

typedef struct tagParm {
  int queueId;
  char queueName [13];
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
  queueData_t queueData;
  struct tagList *nextElem;
};

struct tagList *firstElem = NULL, *lastElem = NULL;

void ClrStruct(void *struc, int len);

int ConstructList(const char *queuePath);
int InsertInList(struct tagList *Elem);
void DestructList(void);

int GetPathName(char *pathName);
int GetParam(int argc, char *argv[], parm_t *Parm);
int GetQueueInfo(const char *pathName, const parm_t *Parm, queueInfo_t *queueInfo);

void UpdateQueueFile(const char *queuePath);

void InitScr(void);

main(int argc, char *argv[])
{
  parm_t Parm;
  queueInfo_t queueInfo;
  queueData_t queueData;

  str_t queuePath, pathName;

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
	printf("\n\nProcessando a fila -> %s...", queueInfo.queueName);
	strcat(strcat(strcpy(queuePath, pathName), queueInfo.queueDir), "\\");
	ConstructList(queuePath);
	/*************************************
	/* UpdateQueueFile(queuePath);
	/*************************************/
	DestructList();
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
  }
  if(contParm) rst = RSLT_OK;

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
  printf("\nNULL List V1.0 - by Luiz Marcio F A Viana, 5/30/96");
}

int ConstructList(const char *queuePath)
{
  HANDLE fileHandle, batchHandle;
  struct tagList Elem;
  str_t fullFileName;
  int cnt = 0;

  str_t s;

  strcat(strcpy(fullFileName, queuePath), QUEUE_FILE);
  if((fileHandle = open(fullFileName, O_RDONLY | O_BINARY)) != -1)
  {
    if((batchHandle = open(BATCH_FILE, O_CREAT | O_TRUNC | O_RDWR | O_TEXT)) != -1)
    {
      sprintf(s, "@ECHO OFF\n");
      write(batchHandle, s, strlen(s));
      while(read(fileHandle, &Elem.queueData, sizeof(queueData_t)) > 0)
      {
	if(Elem.queueData.dataFlag != '*')
	{
	  if(!InsertInList(&Elem)) break;
	  cnt = cnt + 1;
	}
	else
	{
	  sprintf(s, "DEL %s%s\n", queuePath, Elem.queueData.cdName);
	  write(batchHandle, s, strlen(s));
	}
      }
      close(batchHandle);
    }
    close(fileHandle);
  }
  return cnt;
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

void UpdateQueueFile(const char *queuePath)
{
  HANDLE fileHandle;
  struct tagList *Ptr;

  str_t fullFileName;

  strcat(strcpy(fullFileName, queuePath), QUEUE_FILE);
  if((fileHandle = open(fullFileName, O_TRUNC | O_WRONLY | O_EXCL | O_BINARY)) != -1)
  {
    Ptr = firstElem;
    while(Ptr != NULL) {
      write(fileHandle, &(Ptr->queueData), sizeof(queueData_t));
      Ptr = Ptr->nextElem;
    }
    close(fileHandle);
  }
}
