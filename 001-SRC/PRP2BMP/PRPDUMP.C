
#include<stdio.h>
#include<conio.h>

#define PRPFF_BEGIN 0x8001
#define PRPFF_END   0x8002

#define PRPFF_ACADR11 1
#define PRPFF_ACADR12 2

#define PRPFF_MONO  0
#define PRPFF_COLOR 1

#define RSLT_OK  0
#define RSLT_ERR 1

typedef unsigned char  byte;
typedef unsigned       word;
typedef unsigned long dword;

typedef struct {
  word pfCode;
  word pfLevel;
  word pfXDots;
  word pfYDots;
  word pfMode;
} PRPFFHEADER;

main(int argc, char *argv[])
{
  FILE *file_ptr;

  PRPFFHEADER prpfh;
  int rst = RSLT_ERR;

  clrscr();
  if(argc)
  {
    if((file_ptr = fopen(argv[1], "rb")) != NULL)
    {
      if(fread(&prpfh, sizeof(PRPFFHEADER), 1, file_ptr) != 0)
      {
	printf("InitialCode = %2x\n", prpfh.pfCode);
	printf("FileLevel = %2x    ", prpfh.pfLevel);
	switch(prpfh.pfLevel)
	{
	  case PRPFF_ACADR11 : printf("[ ACADR11 ]\n"); break;
	  case PRPFF_ACADR12 : printf("[ ACADR12 ]\n");
	}
	printf("XDots = %5u\n", prpfh.pfXDots);
	printf("YDots = %5u\n", prpfh.pfYDots);
	printf("Mode = %2x    ", prpfh.pfMode);
	if(prpfh.pfMode)
	  printf("[ Color ]\n");
	else
	  printf("[ Mono ]\n");

	rst = RSLT_OK;
      }
      else
      {
	printf("ERR: Can't read printer file.\n");
      }
    }
    else
    {
      printf("ERR: Can't open printer file.\n");
    }
  }
  else
  {
    printf("ERR: Parameter not defined.\n");
  }
  return(rst);
}
