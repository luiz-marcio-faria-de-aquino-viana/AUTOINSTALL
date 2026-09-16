
#include<stdio.h>
#define _ACADR12_T
#include"io_file.h"
#include"prpff.h"
#include"bmpff.h"

#define NOT_DEF 0

#define RSLT_OK  0
#define RSLT_ERR 1

#define MAX_COLOR 2

#define BUFFSIZE 16*1024

typedef char str_t [256];

BITMAPFILEHEADER bmfh;
BITMAPINFOHEADER bmih;
RGBQUAD aColors [ MAX_COLOR ];

PRPFFHEADER prpfh;

void MainScr(void);

void InitBMPFileHeader(void);
void InitBMPInfoHeader(void);
void InitBMPRGBQuad(void);

int ReceiveParm(int argc, char *argv[], char *parm1, char *parm2);

long Fix(word p);

main(int argc, char *argv[])
{
  class io_file src, dst;
  str_t src_file, dst_file;

  byte *buff;
  word nbytes;
  ulong lcnt;

  int rst = RSLT_ERR;
  uint i;

  MainScr();

  InitBMPFileHeader();
  InitBMPInfoHeader();
  InitBMPRGBQuad();

  if((buff = (byte *) malloc(BUFFSIZE)) != NULL)
  {
    if(!ReceiveParm(argc, argv, src_file, dst_file))
    {
      src.io_open(src_file, RD_MODE);
      src.io_readfx(&prpfh, sizeof(PRPFFHEADER));
      if((prpfh.pfCode == PRPFF_BEGIN) && (prpfh.pfMode == PRPFF_MONO))
      {
	printf("Converting... ");
	dst.io_open(dst_file, WR_MODE);
	bmih.biWidth = ((long) Fix(prpfh.pfXDots + 1));
	bmih.biHeight =((long) prpfh.pfYDots + 1);
	bmfh.bfSize = (dword) bmih.biHeight * ((dword) bmih.biWidth / 8) + 62;
	dst.io_write(&bmfh, sizeof(BITMAPFILEHEADER));
	dst.io_write(&bmih, sizeof(BITMAPINFOHEADER));
	dst.io_write(aColors, MAX_COLOR * sizeof(RGBQUAD));

	lcnt = bmfh.bfSize - ((dword) bmih.biWidth / 8);
	src.io_readfx(&nbytes, sizeof(word));
	while(nbytes != PRPFF_END)
	{
	  src.io_readfx(buff, nbytes);
	  for(i = 0; i < nbytes; i++)
	  {
	    buff[i] = 0xff - buff[i];
	  }
	  dst.io_seek(lcnt);
	  dst.io_write(buff, nbytes);
	  for(i = 0; i < ((uint) bmih.biWidth / 8) - nbytes; i++)
	  {
	    buff[i] = 0xff;
	  }
	  dst.io_write(buff, ((uint) bmih.biWidth / 8) - nbytes);
	  src.io_readfx(&nbytes, sizeof(word));
	  lcnt = lcnt - ((dword) bmih.biWidth / 8);
	  switch((lcnt / bmih.biWidth) % 4)
	  {
	    case 3 : printf("-"); break;
	    case 2 : printf("\\"); break;
	    case 1 : printf("|"); break;
	    case 0 : printf("/");
	  }
	  gotoxy(wherex() - 1, wherey());
	}
	printf("Ok!\n\n");
	dst.io_close();
	rst = RSLT_OK;
      }
      else
      {
	printf("ERR: Invalid file format.\n");
      }
      src.io_close();
    }
    else
    {
      printf("ERR: Incorrect number of parameters.\n");
    }
    free(buff);
  }
  else
  {
    printf("ERR: Can't allocate memory.\n");
  }
  return rst;
}

void MainScr()
{
  printf("PRP2BMP: Convert printer plot file format to windows bit map.\n\n");

  printf("Copyright (C) 1995 by Luiz Marcio F A Viana, 2/25/95.\n");
  printf("All Rights Reserved.\n\n");
}

void InitBMPFileHeader(void)
{
  bmfh.bfType = 0x4d42;
  bmfh.bfSize = NOT_DEF;
  bmfh.bfReserved1 = 0;
  bmfh.bfReserved2 = 0;
  bmfh.bfOffBits = 62;
}

void InitBMPInfoHeader(void)
{
  bmih.biSize = 40;
  bmih.biWidth = NOT_DEF;
  bmih.biHeight = NOT_DEF;
  bmih.biPlanes = 1;
  bmih.biBitCount = 1;
  bmih.biCompression = BI_RGB;
  bmih.biSizeImage = 0;
  bmih.biXPelsPerMeter = 0;
  bmih.biYPelsPerMeter = 0;
  bmih.biClrUsed = 0;
  bmih.biClrImportant = 0;
}

void InitBMPRGBQuad(void)
{
  aColors[0].rgbBlue = 0;
  aColors[0].rgbGreen = 0;
  aColors[0].rgbRed = 0;
  aColors[0].rgbReserved = 0;
  aColors[1].rgbBlue = 255;
  aColors[1].rgbGreen = 255;
  aColors[1].rgbRed = 255;
  aColors[1].rgbReserved = 0;
}

int ReceiveParm(int argc, char *argv[], char *parm1, char *parm2)
{
  int rst = RSLT_ERR;
  if(argc >= 2)
  {
    strcpy(parm1, argv[1]);
    strcpy(parm2, argv[2]);
    rst = RSLT_OK;
  }
  return rst;
}

long Fix(word p)
{
  long q;

  if(!(p % 16))
    q = (long) p;
  else
    q = (long) (((p / 8) + 1) * 8);

  return(q);
}
