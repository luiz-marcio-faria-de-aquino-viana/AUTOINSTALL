/*  bmpff.h

    Definition for bitmap types and structures

    Copyright (C) 1995 by Luiz Marcio F A Viana
    All Rights Reserved.
*/

#ifndef __BMPFF_H
#define __BMPFF_H

#ifndef _DATA_T
#define _DATA_T
typedef unsigned char  byte;
typedef unsigned       word;
typedef unsigned long dword;
#endif

#ifndef _UNSIGNED_T
#define _UNSIGNED_T
typedef unsigned char uchar;
typedef unsigned      uint;
typedef unsigned long ulong;
#endif

#define BI_RGB  0
#define BI_RLE4 1
#define BI_RLE8 2

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

typedef struct {
  BITMAPFILEHEADER bmfh;
  BITMAPINFOHEADER bmih;
  RGBQUAD      *aColors;
  byte     *aBitmapBits;
} BITMAPFILEFORMAT;

#endif
