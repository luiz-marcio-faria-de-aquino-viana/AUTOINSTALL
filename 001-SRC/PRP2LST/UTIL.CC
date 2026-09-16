/*  util.cc

    Definitions for multiple utility routine.

    Copyright (c) 1994 by TML Software, Inc.
    All Rights Reserved.
*/

#ifndef __UTIL_H
#define __UTIL_H

#include<stdio.h>
#include<conio.h>

/*  Define type string.
*/
typedef char str_t[256];

/*  Declare writexy function.
*/
void writexy(int x, int y, str_t s)
{
  gotoxy(x, y); puts(s);
}

#endif  /*  END OF FILE */
