/*  24pin.cc

    Definitions for epson 24pin graphic functions.

    Copyright (c) 1993, 1994 by TML Software, Inc.
    All Rights Reserved.
*/

#ifndef __24PIN_H
#define __24PIN_H

#include<stdio.h>
#include<alloc.h>
#include"misc.cc"
#include"file.cc"
#include"calc.cc"

/*  Define max number of dots per inches.
*/
#define MAXDPI 180

/*  Define max size of dots array.
*/
#define DOTARRSIZE (MAXDPI * 13.6)

/*  Define max size of data array.
*/
#define DATARRSIZE (MAXDPI * 13.6 / 8)

/*  Define max dot pitch array size.
*/
#define PITCHSIZE (MAXDPI * 13.6 * 3)

/*  Define correct head file format.
*/
#define BEGINPLOT 0x8001

#if !defined(ACADR12)
#define FILELEVEL 0x0001
#else
#define FILELEVEL 0x0002
#endif

#define MODEMONO  0x0000
#define ENDPLOT   0x8002

/*  Define code for horizontal resolution.
*/
#define H180DPI 39

/*  Define code for vertical resolution.
*/
#define V180DPI 24

/*  Define error and alternate code for printer.
*/
#define ERRCODE 0x1a
#define ALTCODE 0x0a

/*  Define finish page indicators.
*/
#define SINGLE 0
#define MULT   1

/*  Define printer direction set.
*/
#define ON  1
#define OFF 0

/*  Define printer functions code.
*/
#define ESC 0x1b
#define LF  0x0a
#define FF  0x0c
#define CR  0x0d

/*  Define type for head file code format.
*/
typedef struct {
  unsigned code;
  unsigned level;
  unsigned xdots, ydots;
  unsigned mode;
} head_dat;

/*  Declare pointer to dots pitch printer array.
*/
unsigned char *pt_dots;

/*  Declare function to reserve apace to dots pitch printer array.
*/
void AllocDotArray(void);

/*  Declare function to reserve space for array.
*/
void AllocArray(unsigned char *asc_arr[], unsigned char *dot_arr[]);


/*  Declare printer control functions.
*/
void Unidirectional(FILE *file_handle, int mode);
void LineSpace(FILE *file_handle, int n);
void SelectGraph(FILE *file_handle, int mode, int n);
void LineFeed(FILE *file_handle);
void FormFeed(FILE *file_handle);
void InitPrinter(FILE *file_handle);

/*  Declare print array function.
*/
void PrintArray(FILE *file_handle, int n, unsigned char *arr[]);

/*  Declare clear array function.
*/
void ClearArr(int n, unsigned char *dot_arr[]);

/*  Declare ascii to dot (array) conversion function.
*/
void Asc2Dot(int n, int value, unsigned char asc_arr[], unsigned char dot_arr[]);

/*  Declare principal function convert ascii file format to dot.
*/
void ConvertFile(int mode, unsigned *row, FILE *source_handle, FILE *target_handle, unsigned char *asc_arr[], unsigned char *dot_arr[]);

/*  Define functions.
*/
void AllocDotArray(void) {
  if((pt_dots = malloc(PITCHSIZE)) == NULL)
    WriteErr("24PIN_01");
}

void AllocArray(unsigned char *asc_arr[], unsigned char *dot_arr[]) {
  int i;
  for(i = 0; i < 3; i++) {
    if((dot_arr[i] = malloc(DOTARRSIZE)) == NULL)
      WriteErr("24PIN_02");
    if((asc_arr[i] = malloc(DATARRSIZE)) == NULL)
      WriteErr("24PIN_03");
  }
}

void Unidirectional(FILE *file_handle, int mode) {
  unsigned char arr[3] = { ESC, 'U' };
  arr[2] = mode;
  WriteFile(arr, sizeof(*arr), 3, file_handle);
}
void LineSpace(FILE *file_handle, int n) {
  unsigned char arr[3] = { ESC, '3' };
  arr[2] = n;
  WriteFile(arr, sizeof(*arr), 3, file_handle);
}
void SelectGraph(FILE *file_handle, int mode, int n) {
  unsigned char arr[5] = { ESC, '*' };
  arr[2] = mode;
  arr[3] = Lo(n);
  arr[4] = Hi(n);
  WriteFile(arr, sizeof(*arr), 5, file_handle);
}
void PrintArray(FILE *file_handle, int n, unsigned char *arr[]) {
  int i, j, k;
  k = 0;
  for(j = 0; j < n; j++)
    for(i = 0; i < 3; i++) {
      if(*(arr[i] + j) == ERRCODE)
	*(pt_dots + k) = ALTCODE;
      else
	*(pt_dots + k) = *(arr[i] + j);
      k++;
    }
  WriteFile(pt_dots, sizeof(*pt_dots), k, file_handle);
}
void LineFeed(FILE *file_handle) {
  unsigned char arr[2] = { CR, LF };
  WriteFile(arr, sizeof(*arr), 2, file_handle);
}
void FormFeed(FILE *file_handle) {
  unsigned char arr[1] = { FF };
  WriteFile(arr, sizeof(*arr), 1, file_handle);
}
void InitPrinter(FILE *file_handle) {
  unsigned char arr[2] = { ESC, '@' };
  WriteFile(arr, sizeof(*arr), 2, file_handle);
}

void ClearArray(int n, unsigned char *dot_arr[]) {
  int i, j;
  for(i = 0; i < 3; i++)
    for(j = 0; j < n; j++)
      *(dot_arr[i] + j) = 0;
}
void Asc2Dot(int n, int value, unsigned char asc_arr[], unsigned char dot_arr[]) {
  int i, j, k;
  for(i = j = 0; i < n; i++) {
    k = 128;
    do{
      if((asc_arr[i] & k) != 0)
	dot_arr[j] = dot_arr[j] + value;
      j++;
    } while((k /= 2) != 0);
  }
}

void ConvertFile(int mode, unsigned *row, FILE *source_handle, FILE *target_handle, unsigned char *asc_arr[], unsigned char *dot_arr[]) {
  head_dat argm;

  unsigned num, pos, lin;
  unsigned aux;

  int flag;

  ReadFile((unsigned char*) &argm, sizeof(argm), 1, source_handle);
  if((argm.code  != BEGINPLOT) || (argm.level != FILELEVEL) || (argm.mode != MODEMONO))
    WriteErr("ERR_06");
  argm.xdots = argm.xdots + 1;
  argm.ydots = argm.ydots + 1;

  flag = FALSE;

  ReadFile((unsigned char*) &aux, sizeof(aux), 1, source_handle);
  while(aux != ENDPLOT) {
    pos = *row % 8;
    lin = (*row % 24) / 8;
    num = aux;

    if(num != 0) {
      flag = TRUE;
      ReadFile(asc_arr[lin], sizeof(*asc_arr[lin]), num, source_handle);
      Asc2Dot(num, Mult(7 - pos), asc_arr[lin], dot_arr[lin]);
    }
    if((pos == 7) && (lin == 2)) {
      LineSpace(target_handle, V180DPI);
      if(flag) {
	flag = FALSE;
	SelectGraph(target_handle, H180DPI, argm.xdots);
	PrintArray(target_handle, argm.xdots, dot_arr);
	ClearArray(argm.xdots, dot_arr);
      }
      LineFeed(target_handle);
    }
    ReadFile((unsigned char*) &aux, sizeof(aux), 1, source_handle);
    (*row)++;
  }
  if(mode == SINGLE) {
    if((pos != 7) || (lin != 2)) {
	LineSpace(target_handle, V180DPI);
	if(flag) {
	  SelectGraph(target_handle, H180DPI, argm.xdots);
	  PrintArray(target_handle, argm.xdots, dot_arr);
	  ClearArray(argm.xdots, dot_arr);
	}
	LineFeed(target_handle);
    }
    FormFeed(target_handle);
  }
}

#endif  /* END OF FILE */
