#include<stdio.h>
#include<stdlib.h>    
#include<string.h>
#include"adslib.h"

#define BUFFSZ 128

#define REFLFILE "\\lumens\\prjtrs"

int loadfunc(void);
int execfunc(int val);

/* ads_external functions */
int il_dsprefl(void);
int il_getrefl(void);

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
  if( ads_defun("il_dsprefl", 0) != RTNORM )
  {
    ads_prompt("ERR: ADS (il_dsprefl) application error\n");
  }
  if( ads_defun("il_getrefl", 1) != RTNORM )
  {
    ads_prompt("ERR: ADS (il_getrefl) application error\n");
  }
  return RTNORM;
}

int execfunc(int val)
{
  switch(val)
  {
    case 0 :
      il_dsprefl(); break;
    case 1 :
      il_getrefl();
  }
  return RTNORM;
}

int il_dsprefl(void)
{
  struct resbuf *args;

  FILE *file_ptr;
  int n = 0;

  char buff [BUFFSZ];

  if((file_ptr = fopen(REFLFILE, "rb")) != NULL)
  {
    ads_printf("\n\nCOD   FABRICANTE        MODELO                     LAMPADA(S)               ");
    ads_printf(  "\n=== =============== =============== ========================================");
    while(fread(buff, sizeof(char), BUFFSZ, file_ptr) != 0)
    {
       buff[15] = buff[31] = buff[72] = '\0';
       ads_printf("\n%3d %15s %15s %40s", (n += 1), &buff[0], &buff[16], &buff[32]);
       if((n % 20) == 0) {
         ads_printf("\n\nTecle qq tecla para prosseguir.");
         getch();
         ads_printf("\n\nCOD   FABRICANTE        MODELO                     LAMPADA(S)               ");
         ads_printf(  "\n=== =============== =============== ========================================");
       }
    }
    fclose(file_ptr);
    ads_retint(n);
  }
  else
  {
    ads_printf("\n* ERROR * Nao foi possivel abrir o arquivo de refletores.");
  }
  return RTNORM;
}

int il_getrefl(void)
{
  FILE *file_ptr;
  struct resbuf *args, *resb;
  char buff[BUFFSZ];
  int cdg;

  if((args = ads_getargs()) != NULL)
  {
    if(args->restype == RTSHORT) {
      cdg = args->resval.rint;
      if((file_ptr = fopen(REFLFILE, "rb")) != NULL)
      {
        while((cdg > 0) && (fread(buff, sizeof(char), BUFFSZ, file_ptr) != 0)) cdg -= 1;
        fclose(file_ptr);
      }
      if(cdg == 0) {
        buff[15] = '\0';
        buff[31] = '\0';
        buff[72] = '\0';
        if((resb = ads_buildlist(RTSTR, &buff[0], RTSTR, &buff[16], RTSTR, &buff[32], 0)) != NULL)
        {
          ads_retlist(resb);
          ads_relrb(resb);
        }
      }
    }
  }
  return RTNORM;
}
