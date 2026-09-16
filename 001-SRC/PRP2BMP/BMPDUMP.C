#include<stdio.h>
#include<string.h>
#include<alloc.h>

typedef unsigned char byte;
typedef unsigned      word;
typedef unsigned long dword;

typedef unsigned char uchar;
typedef unsigned      uint;
typedef unsigned long ulong;

typedef char str_t [256];

typedef struct {
  uint bfType;
  dword bfSize;
  uint bfReserved1;
  uint bfReserved2;
  dword bfOffBits;
} BITMAPFILEHEADER;

typedef struct {
  dword biSize;
  long  biWidth;
  long  biHeight;
  word  biPlanes;
  word  biBitCount;
  dword biCompression;
  dword biSizeImage;
  long  biXPelsPerMeter;
  long  biYPelsPerMeter;
  dword biClrUsed;
  dword biClrImportant;
} BITMAPINFOHEADER;

typedef struct {
  byte rgbBlue;
  byte rgbGreen;
  byte rgbRed;
  byte rgbReserved;
} RGBQUAD;

BITMAPFILEHEADER bmfh;
BITMAPINFOHEADER bmfi;
RGBQUAD *aColors;

dword Pow(word exp);

void FileHeaderDump(void);
void InfoHeaderDump(void);
void RGBQuadDump(void);

main(int argc, char *argv[])
{
  FILE *file_ctrl;
  str_t file_name;

  if(argc)
  {
    strcpy(file_name, argv[1]);
    if((file_ctrl = fopen(file_name, "rb")) != NULL)
    {
      if(fread(&bmfh, sizeof(BITMAPFILEHEADER), 1, file_ctrl))
      {
	if(fread(&bmfi, sizeof(BITMAPINFOHEADER), 1, file_ctrl))
	{
	  if(bmfi.biBitCount)
	  {
	    FileHeaderDump();
	    InfoHeaderDump();
	    if((aColors = (RGBQUAD *) malloc(Pow(bmfi.biBitCount) * sizeof(RGBQUAD))) != NULL)
	    {
	      if(fread(aColors, Pow(bmfi.biBitCount) * sizeof(RGBQUAD), 1, file_ctrl))
	      {
		RGBQuadDump();
	      }
	      else
	      {
		printf("ERR: File is corrupted, or wrong file format.\n");
	      }
	      free(aColors);
	    }
	    else
	    {
	      printf("ERR: Can't allocate memory for color table.\n");
	    }
	  }
	  else
	  {
	    printf("ERR: Invalid file format.\n");
	  }
	}
	else
	{
	  printf("ERR: File is corrupted, or wrong file format.\n");
	}
      }
      else
      {
	printf("ERR: File is corrupted, or wrong file format.\n");
      }
      fclose(file_ctrl);
    }
    else
    {
      printf("ERR: Can't open bitmap file.\n");
    }
  }
  else
  {
    printf("ERR: File name not informed.\n");
  }
  return(0);
}

dword Pow(word exp)
{
  if(!exp)
    return(1);
  return(2 * Pow(exp - 1));
}

void FileHeaderDump(void)
{
  printf("BitmapFileHeader\n");
  printf("  Type = %x\n", bmfh.bfType);
  printf("  Size = %lu\n", bmfh.bfSize);
  printf("  Reserved1 = %u\n", bmfh.bfReserved1);
  printf("  Reserved2 = %u\n", bmfh.bfReserved2);
  printf("  OffsetBits = %lu\n", bmfh.bfOffBits);
}

void InfoHeaderDump(void)
{
  printf("BitmapInfoHeader\n");
  printf("  Size = %lu\n", bmfi.biSize);
  printf("  Width = %ld\n", bmfi.biWidth);
  printf("  Height = %ld\n", bmfi.biHeight);
  printf("  Planes = %u\n", bmfi.biPlanes);
  printf("  BitCount = %u\n", bmfi.biBitCount);
  printf("  Compression = %lu\n", bmfi.biCompression);
  printf("  SizeImage = %lu\n", bmfi.biSizeImage);
  printf("  XPelsPerMeter = %ld\n", bmfi.biXPelsPerMeter);
  printf("  YPelsPerMeter = %ld\n", bmfi.biYPelsPerMeter);
  printf("  ColorsUsed = %lu\n", bmfi.biClrUsed);
  printf("  ColorsImportant = %lu\n", bmfi.biClrImportant);
}

void RGBQuadDump(void)
{
  uint i;
  printf("ColorTable\n");
  printf("         Blue  Green    Red Unused\n");
  for(i = 0; i < Pow(bmfi.biBitCount); i++)
    printf("[%04x]    %3hu    %3hu    %3hu    %3hu\n", i, aColors[i].rgbBlue, aColors[i].rgbGreen, aColors[i].rgbRed, aColors[i].rgbReserved);
}
