
#include<stdio.h>
#include<conio.h>
#include<dir.h>
#include<string.h>

#define QUEUE_LIST  "QUEUE.DAT"
#define QUEUE_FILE  "QUEUEFIL.DAT"

#define SHARE_FILE  "SHAREFIL.DAT"

#define RSLT_OK  1
#define RSLT_ERR 0

typedef char str_t[256];

typedef struct tagInfo {
  int queueId;
  char queueName [13];
  char queueDir [48];
} queueInfo_t;

int AddQueue(queueInfo_t* queueInfo);

int CreateQueueFile(const char *queueDir);

int CreateShareFile(const char *queueDir);

main()
{
  queueInfo_t queueInfo;

  clrscr();
  printf("ADD Queue (R)\n");
  printf("ßßßßßßßßßßßßß\n");
  printf(" - Queue name = ");
  scanf("%s", &queueInfo.queueName);
  strupr(queueInfo.queueName);
  printf(" - Queue directory = ");
  scanf("%s", &queueInfo.queueDir);
  strupr(queueInfo.queueDir);
  printf("\n");
  if(AddQueue(&queueInfo))
  {
	 if(!mkdir(queueInfo.queueDir))
	 {
		if(CreateQueueFile(queueInfo.queueDir))
		{
	if(CreateShareFile(queueInfo.queueDir))
	{
	  printf("Queue added!\n");
	}
	else
	{
	  printf("ERR: Can't create share file.\n");
	}
		}
		else
		{
	printf("ERR: Can't create queue file.\n");
		}
	 }
	 else
	 {
		printf("ERR: Can't create directory.\n");
	 }
  }
  else
  {
	 printf("ERR: Can't add queue information.\n");
  }
  return(0);
}

int AddQueue(queueInfo_t* queueInfo)
{
  FILE *filePtr;
  fpos_t fpos;

  int rst = RSLT_ERR;

  if((filePtr = fopen(QUEUE_LIST, "ab")) != NULL)
  {
	 fseek(filePtr, 0, SEEK_END);
	 fgetpos(filePtr, &fpos);
	 queueInfo->queueId = ((int) fpos) / sizeof(queueInfo_t);
	 fwrite(queueInfo, sizeof(queueInfo_t), 1, filePtr);
	 fclose(filePtr);
	 rst = RSLT_OK;
  }
  return rst;
}

int CreateQueueFile(const char *queueDir)
{
  FILE *filePtr;
  str_t fileName;

  int rst = RSLT_ERR;

  strcat(strcat(strcpy(fileName, queueDir), "\\"), QUEUE_FILE);
  if((filePtr = fopen(fileName, "wb")) != NULL)
  {
    fclose(filePtr);
    rst = RSLT_OK;
  }
  return rst;
}

int CreateShareFile(const char *queueDir)
{
  FILE *filePtr;
  str_t fileName;

  int idNum = 0x0000;

  int rst = RSLT_ERR;

  strcat(strcat(strcpy(fileName, queueDir), "\\"), SHARE_FILE);
  if((filePtr = fopen(fileName, "wb")) != NULL)
  {
    fwrite(&idNum, sizeof(int), 1, filePtr);
    fclose(filePtr);
    rst = RSLT_OK;
  }
  return rst;
}
