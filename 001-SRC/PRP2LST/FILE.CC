/*  file.cc

    Definitions for extended input/output file rotines.

    Copyright (c) 1993, 1994 by TML Software, Inc.
    All Rights Reserved.
*/

#if !defined(__FILE_H)
#define __FILE_H

#include<stdio.h>
#include<alloc.h>
#include<string.h>
#include<mem.h>
#include"misc.cc"

/*  Define buffer size.
*/
#define BUFFSIZE 32 * 1024

/*  Define extension for input file.
*/
#define FILE_EXTIN  ".prp"
/*  Define extension for output file.
*/
#define FILE_EXTOUT ".lst"

/*  Define print output indicator.
*/
#define PRN_OUTPUT  "PRN"

/*  Define read mode for open and close file function.
*/
#ifndef RD_MODE
#define RD_MODE 0
#endif
/*  Define write mode for open and close file function.
*/
#ifndef WR_MODE
#define WR_MODE 1
#endif

/*  Declare pointers to read and write buffers.
*/
unsigned char *rd_buff;     /* buffer to read */
unsigned char *wr_buff;     /* buffer to write */

/*  Declare variables to control buffers.
*/
unsigned max_read;          /* max number of data read from buffer */
unsigned num_read;          /* number of data read from buffer */

unsigned max_write;         /* max number of data write on buffer */
unsigned num_write;         /* number of data write on buffer */

/*  Declare function to allocate memory for read/write buffers.
*/
void AllocBuff(void);
void ReAllocBuff(void);

/*  Declare open file function.
*/
FILE *OpenFile(int mode, char file_name[]);
/*  Declare read file functions.
*/
void ReadFile(unsigned char *pt_dat, unsigned size_dat, unsigned num_dat, FILE *file_handle);
/*  Declare write file function.
*/
void WriteFile(unsigned char *pt_dat, unsigned size_dat, unsigned num_dat, FILE *file_handle);
/*  Declare close file function.
*/
void CloseFile(int mode, FILE *file_handle);

/*  Define functions.
*/
void AllocBuff(void) {
  if((rd_buff = malloc(BUFFSIZE)) == NULL)
    WriteErr("FILE_01");
  if((wr_buff = malloc(BUFFSIZE)) == NULL)
    WriteErr("FILE_02");
}
void ReAllocBuff(void) {
  if(rd_buff != NULL) free(rd_buff);
  if(wr_buff != NULL) free(wr_buff);
}

FILE *OpenFile(int mode, char file_name[]) {
  FILE *file_handle;
  switch(mode) {
    case RD_MODE :
      strcat(file_name, FILE_EXTIN);
      if((file_handle = fopen(file_name, "rb")) == NULL)
	WriteErr("FILE_03");
      max_read = num_read = 0;
      break;
    case WR_MODE :
      if(strcmp(file_name, PRN_OUTPUT) == 0)
	file_handle = stdprn;
      else {
	strcat(file_name, FILE_EXTOUT);
	if((file_handle = fopen(file_name, "wb")) == NULL)
	  WriteErr("FILE_04");
      }
      max_write = BUFFSIZE;
      num_write = 0;
  }
  return file_handle;
}
void ReadFile(unsigned char *pt_dat, unsigned size_dat, unsigned num_dat, FILE *file_handle) {
  unsigned total_dat, total_read;
  total_dat = size_dat * num_dat;
  if((num_read + total_dat) > max_read) {
    memmove(pt_dat, rd_buff + num_read, max_read - num_read);
    total_read = max_read - num_read;
    total_dat = total_dat - (max_read - num_read);
    if((max_read = fread(rd_buff, sizeof(*rd_buff), BUFFSIZE, file_handle)) == NULL)
      WriteErr("FILE_05");
    memmove(pt_dat + total_read, rd_buff, total_dat);
    num_read = total_dat;
  }
  else {
    memmove(pt_dat, rd_buff + num_read, total_dat);
    num_read = num_read + total_dat;
  }
}
void WriteFile(unsigned char *pt_dat, unsigned size_dat, unsigned num_dat, FILE *file_handle) {
  unsigned total_dat, total_write;
  total_dat = size_dat * num_dat;
  if((num_write + total_dat) > max_write) {
    memmove(wr_buff + num_write, pt_dat, max_write - num_write);
    total_write = max_write - num_write;
    total_dat = total_dat - (max_write - num_write);
    if(fwrite(wr_buff, sizeof(*wr_buff), BUFFSIZE, file_handle) == NULL)
      WriteErr("FILE_06");
    memmove(wr_buff, pt_dat + total_write, total_dat);
    num_write = total_dat;
  }
  else {
    memmove(wr_buff + num_write, pt_dat, total_dat);
    num_write = num_write + total_dat;
  }
}
void CloseFile(int mode, FILE *file_handle) {
  if(mode == WR_MODE)
    if(fwrite(wr_buff, sizeof(*wr_buff), num_write, file_handle) == NULL)
      WriteErr("FILE_07");
  fclose(file_handle);
}
#endif  /* END OF FILE */
