/*  io_file.h

    Definition for input/output file class.

    Copyright (c) 1995 by Luiz Marcio F A Viana
    All Rights Reserved.
*/

#ifndef __IO_FILE_H
#define __IO_FILE_H

#if !defined(__STDIO_H)
#include <stdio.h>
#endif

#if !defined(__STRING_H)
#include <string.h>
#endif

#if !defined(__CONIO_H)
#include <conio.h>
#endif

#if !defined(__STDLIB_H)
#include <stdlib.h>
#endif

#ifndef IO_BUFFSIZE
#define IO_BUFFSIZE (16*1024)
#endif

/* Definition of file mode
*/
#define RD_MODE 0
#define WR_MODE 1

/* Definition of unsigned types
*/
#ifndef _UNSIGNED_T
#define _UNSIGNED_T
typedef unsigned char uchar;
typedef unsigned      uint;
typedef unsigned long ulong;
#endif

/* Definition of input/output file class
*/
class io_file {
  FILE *file_ptr;
  uchar *buff;
  uint p_rd, p_wr;
  uint max_dt;
  int mode;
public:
  io_file(void);
  ~io_file(void);
  void io_open(char *fname, int fmode);
  uint io_read(void *ptr, uint n);
  uint io_readfx(void *ptr, uint n);
  uint io_write(void *ptr, uint n);
  void io_seek(ulong p);
  void io_close(void);
};

/* Definition of input/output file functions
*/
io_file::io_file(void)
{
  if((buff = (uchar *) malloc(IO_BUFFSIZE)) == NULL)
  {
    clrscr();
    printf("ERR: Can't allocate memory.\n");
    exit(1);
  }
}

io_file::~io_file(void)
{
  if(buff != NULL) free(buff);
  fcloseall();
}

void io_file::io_open(char *fname, int fmode)
{
  switch ((mode = fmode)) {
    case RD_MODE :
      if((file_ptr = fopen(fname, "rb")) == NULL)
      {
	clrscr();
	printf("ERR: Can't open file to read.\n");
	exit(1);
      }
      p_rd = 0;
      max_dt = 0;
      break;
    case WR_MODE :
      if((file_ptr = fopen(fname, "wb")) == NULL)
      {
	clrscr();
	printf("ERR: Can't open file to write.\n");
	exit(1);
      }
      p_wr = 0;
      max_dt = IO_BUFFSIZE;
  }
}

uint io_file::io_read(void *ptr, uint n)
{
  uint num_rd;
  uint rd_spc;

  rd_spc = max_dt - p_rd;
  if(n < rd_spc)
  {
    memcpy((uchar *) ptr, &(buff[p_rd]), (num_rd = n));
    p_rd += n;
  }
  else
  {
    memcpy((uchar *) ptr, &(buff[p_rd]), (num_rd = rd_spc));
    n -= rd_spc;
    max_dt = fread(buff, sizeof(uchar), IO_BUFFSIZE, file_ptr);
    rd_spc = max_dt;
    p_rd = 0;
    if(n < rd_spc)
    {
      memcpy(&((uchar *) ptr)[num_rd], &(buff[p_rd]), n);
      num_rd += n;
      p_rd += n;
    }
    else
    {
      memcpy(&((uchar *) ptr)[rd_spc], &(buff[p_rd]), rd_spc);
      num_rd += rd_spc;
      p_rd += rd_spc;
    }
  }
  return num_rd;
}

uint io_file::io_readfx(void *ptr, uint n)
{
  uint num_rd;
  if((num_rd = io_read(ptr, n)) != n)
  {
    clrscr();
    printf("ERR: Can't read from file.\n");
    exit(1);
  }
  return num_rd;
}

uint io_file::io_write(void *ptr, uint n)
{
  uint num_wr;
  uint wr_spc;

  wr_spc = max_dt - p_wr;
  if(n < wr_spc)
  {
    memcpy(&(buff[p_wr]), (uchar *) ptr, (num_wr = n));
    p_wr += n;
  }
  else
  {
    memcpy(&(buff[p_wr]), (uchar *) ptr, (num_wr = wr_spc));
    n -= num_wr;
    if(fwrite(buff, sizeof(uchar), IO_BUFFSIZE, file_ptr) == 0)
    {
      clrscr();
      printf("ERR: Can't write to file.\n");
      exit(1);
    }
    wr_spc = IO_BUFFSIZE;
    p_wr = 0;
    if(n < wr_spc)
    {
      memcpy(&(buff[p_wr]), &((uchar *) ptr)[num_wr], n);
      num_wr += n;
      p_wr = n;
    }
    else
    {
      clrscr();
      printf("ERR: Buffer overflow.\n");
      exit(1);
    }
  }
  return num_wr;
}

void io_file::io_seek(ulong p)
{
  switch(mode) {
    case RD_MODE :
      if(fseek(file_ptr, p, SEEK_SET))
      {
	clrscr();
	printf("ERR: Can't move file pointer.\n");
	exit(1);
      }
      p_rd = 0;
      max_dt = 0;
      break;
    case WR_MODE :
      if(fwrite(buff, sizeof(uchar), p_wr, file_ptr) == 0)
      {
	clrscr();
	printf("ERR: Can't write to file.\n");
	exit(1);
      }
      if(fseek(file_ptr, p, SEEK_SET))
      {
	clrscr();
	printf("ERR: Can't move file pointer.\n");
	exit(1);
      }
      p_wr = 0;
      max_dt = IO_BUFFSIZE;
  }
}

void io_file::io_close(void)
{
  switch(mode) {
    case RD_MODE :
      fclose(file_ptr);
      break;
    case WR_MODE :
      if(fwrite(buff, sizeof(uchar), p_wr, file_ptr) == 0)
      {
	clrscr();
	printf("ERR: Can't write to file.\n");
	exit(1);
      }
      fclose(file_ptr);
  }
}

#endif
