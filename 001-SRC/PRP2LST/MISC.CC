/*  misc.cc

    Definitions for multiple utility routine.

    Copyright (c) 1993, 1994 by TML Software, Inc.
    All Rights Reserved.
*/

#ifndef __MISC_H
#define __MISC_H

#include<stdio.h>
#include<conio.h>
#include<string.h>
#include<stdlib.h>

/* Define string size.
*/
#define STRSIZE 80

/*  Define message command data.
*/
#define BEGINMSG "%%BEGIN="
#define ENDMSG   "%%END"

/*  Define message file.
*/
#if !defined(MSGFILE)
#define MSGFILE "PRP2LST.MSG"
#endif

/*  Define TRUE/FALSE constants
*/
#define FALSE 0
#define TRUE  1

/*  Define type string.
*/
typedef char str_t[STRSIZE];

/*  Declare write message function.
*/
int WriteMsg(char msg[]);
/*  Declare write error function.
*/
void WriteErr(char err[]);

/*  Define functions.
*/
int WriteMsg(char msg[]) {
  FILE *file_handle;
  str_t s1, s2;
  int flag;

  strcat(strcpy(s1, BEGINMSG), msg);
  if((file_handle = fopen(MSGFILE, "r")) == NULL)
    return FALSE;
  else {
    flag = FALSE;
    while(fgets(s2, STRSIZE, file_handle) != NULL)
      if(strnicmp(s1, s2, strlen(s1)) == 0) {
	flag = TRUE;
	if(fgets(s2, STRSIZE, file_handle) == NULL)
	  return FALSE;
	while(strnicmp(s2, ENDMSG, strlen(ENDMSG)) != 0) {
	  printf("%s", s2);
	  if(fgets(s2, STRSIZE, file_handle) == NULL)
	    return FALSE;
	}
      }
    fclose(file_handle);
  }
  return flag;
}

void WriteErr(char err[]) {
  clrscr();
  if(WriteMsg(err) == FALSE)
    printf("ERROR LEVEL < %s >\n", err);
  printf("TCHAU...\n");
  exit(1);
}

#endif  /*  END OF FILE */
