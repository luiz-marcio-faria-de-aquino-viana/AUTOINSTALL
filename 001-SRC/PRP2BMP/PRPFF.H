/*  prpff.h

    Definitions for print/plot types and structures

    Copyright (c) 1995 by Luiz Marcio F A Viana
    All Rights Reserved.
*/

#ifndef __PRPFF_H
#define __PRPFF_H

#ifndef _DATA_T
#define _DATA_T
typedef unsigned char  byte;
typedef unsigned       word;
typedef unsigned long dword;
#endif

/* Define byte for correct file format.
*/
#define PRPFF_BEGIN 0x8001
#define PRPFF_END   0x8002

#ifndef _ACADR12_T
#define PRPFF_LEVEL 0
#else
#define PRPFF_LEVEL 1
#endif

#define PRPFF_MONO  0
#define PRPFF_COLOR 1

/*  Define print/plot file header.
*/
typedef struct {
  word pfCode;
  word pfLevel;
  word pfXDots;
  word pfYDots;
  word pfMode;
} PRPFFHEADER;

#endif
