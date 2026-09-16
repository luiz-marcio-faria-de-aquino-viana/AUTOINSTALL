#include<stdio.h>
#include<stdlib.h>    
#include<string.h>
#include"adslib.h"

#define STRSZ 256

typedef unsigned char str_t [STRSZ];

int loadfunc(void);
int execfunc(int val);

/* ads_external functions */
int validate(void);
int xloadf(void);

main(int argc, char *argv[])
{
  int stat;
  short scode = RSRSLT;
  
  ads_init(argc, argv);
  while((stat = ads_link(scode)) >= 0)
  {    
    scode = RSRSLT;
    switch(stat)
    {
      /* Find the value of stat and act on it */
      case RQXLOAD :
        scode = loadfunc() ? RSRSLT : RSERR;
        break;
      case RQSUBR  :
        scode = execfunc(ads_getfuncode()) ? RSRSLT : RSERR;
    }
  }
  printf("Loader: bad status from ads_link() = %d\n", stat);
  fflush(stdout);
  
  return(0);
}

int loadfunc(void)
{
  int rst = RTERROR;
  if( (rst = ads_defun("xloadf", 0)) != RTNORM )
  {
    ads_prompt("ERR: ADS (xl) application error\n");
  }
  return rst;
}

int execfunc(int val)
{
  int rst = RTERROR;
  switch(val)
  {
    case 0 :
      rst = xloadf();
  }
  return rst;
}

int validate(void)
{
  if(strcmp(getenv("AIx"), "Enable") != 0)
  {
    ads_prompt("\nERR: Invalid computer system.");
    ads_prompt("\nSYSTEM HALT");
    for(;;);
  }

  return RTNORM;
}

int xloadf(void)
{
  struct resbuf *args;

  FILE *file_ptr;
  str_t file_name;
  int file_pos;

  str_t s;
  int n, i;

  int rst = RTERROR;

  validate();   /* check for system */
  if((args = ads_getargs()) != NULL)
  {
    if (args->restype == RTSTR)
    {
      strcpy(file_name, args->resval.rstring);
      args = args->rbnext;
      if(args->restype == RTSHORT)
      {
        file_pos = args->resval.rint;
        if((file_ptr = fopen(file_name, "rb")) != NULL)
        {
          fseek(file_ptr, file_pos, SEEK_SET);
          n = fread(s, sizeof(char), STRSZ, file_ptr);
          for(i = 0; i < n; i++)
          {
            s[i] = s[i] - ((file_pos + i + 1) % 128);
          }
          s[n] = EOS;
          fcloseall();
          ads_retstr(s);
          rst = RTNORM;
        }
        else
        {
          ads_prompt("\nERR: Can't open source file.");
        }
      }
      else
      {
        ads_prompt("\nERR: Invalid parameter type.");
      }
    }
    else
    {
      ads_prompt("\nERR: Invalid parameter type.");
    }
  }
  else
  {
    ads_prompt("\nERR: This function need arguments.");
  }
  return rst;
}
