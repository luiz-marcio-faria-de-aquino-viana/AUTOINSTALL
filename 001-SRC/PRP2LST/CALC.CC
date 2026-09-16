/*  calc.cc

    Definitions for extended math functions and variables.

    Copyright (c) 1993, 1994 by TML Software, Inc.
    All Rights Reserved.
*/

#ifndef __CALC_H
#define __CALC_H

/*  Declare function to get lower significant byte from integer.
*/
int Lo(int a);

/*  Declare function to get must significant byte from integer.
*/
int Hi(int a);

/*  Declare function to get power of two.
*/
int Mult(int a);

/*  Define functions.
*/
int Lo(int a) {
  return a % 256;
}
int Hi(int a) {
  return a / 256;
}

int Mult(int a) {
  int mult;
  mult = 1;
  while(a--)
    mult = mult * 2;
  return mult;
}

#endif  /* END OF FILE */
