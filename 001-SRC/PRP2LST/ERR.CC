/*  err.cc

    Definitions for error utility routine.

    Copyright (c) 1994 by TML Software, Inc.
    All Rights Reserved.
*/

#ifndef __ERR_H
#define __ERR_H

#include<stdio.h>
#include<conio.h>
#include<stdlib.h>
#include"util.cc"

/*  Define error printer function.
*/
void prinerr(str_t s)
{
  clrscr();
  printf("ERR.: %s\n", s);
  printf("TCHAU...\n");
  fcloseall();              /* close all opened file */
  exit(1);                  /* exit to DOS */
}

/*  Table of error definitions.
*/
#define ERR_01 "Can't open file to read."
#define ERR_02 "Can't open file to write."
#define ERR_03 "Can't read data from disk."
#define ERR_04 "Can't write data to disk."
#define ERR_05 "Can't allocate memory."
#define ERR_06 "Invalid number of parameters."
#define ERR_07 "Invalid parameter."

#endif  /* END OF FILE */
