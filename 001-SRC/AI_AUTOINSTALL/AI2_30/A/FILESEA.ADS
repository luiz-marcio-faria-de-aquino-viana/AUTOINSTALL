
#include<stdio.h>
#include<sys\types.h>
#include<direct.h>
#include<dos.h>
#include"adslib.h"

#define STRSZ 256

typedef char str_t[STRSZ];

str_t fullfilename;
str_t thisfile;

int loadfunc(void);
int execfunc(int val);

/* ads_external functions */
int initfilesea(void);
int getdrvnum(char *pth);
int filesea(const char *file_name);

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
  if( (rst = ads_defun("filesea", 0)) != RTNORM )
  {
    ads_prompt("ERR: ADS (filesea) application error\n");
  }
  return rst;
}

int execfunc(int val)
{
  int rst = RTERROR;
  switch(val)
  {
    case 0 : rst = initfilesea();
  }
  return rst;
}

int initfilesea(void)
{
  struct resbuf *args;
  str_t path_name, file_name;

  str_t olddir;
  unsigned totaldrv;

  int rst = RTERROR;
  if((args = ads_getargs()) != NULL)
  {
    if(args->restype == RTSTR)
    {
      strupr(strcpy(path_name, args->resval.rstring));
      if((args->rbnext != NULL) && ((args->rbnext)->restype == RTSTR))
      {
        strupr(strcpy(file_name, (args->rbnext)->resval.rstring));
        getcwd(olddir, STRSZ);
        _dos_setdrive(getdrvnum(path_name), &totaldrv);
        chdir("\\");
        if(filesea(file_name) == RTNORM)
        {
          strcat(strcat(fullfilename, "\\"), file_name);
          ads_retstr(fullfilename);
        }
        else {
          ads_retnil();
        }
        _dos_setdrive(getdrvnum(olddir), &totaldrv);
        chdir(olddir);
      }
    }
  }
  return rst;
}

int getdrvnum(char *pth)
{
  int drvnum = 0;
  if((pth[0] >= 'A') && (pth[0] <= 'Z'))
    drvnum = (pth[0] - 'A') + 1;
  return drvnum;
}

int filesea(const char *file_name)
{
  DIR *dird;
  struct dirent *dirp;

  int rst = RTERROR, optrst;
  if((dird = opendir("*.*")) != NULL)
  {
    while((rst == RTERROR) && ((dirp = readdir(dird)) != NULL)) {
      if(dirp->d_attr == _A_SUBDIR) {
        if((strcmp(dirp->d_name, ".")!= 0) && (strcmp(dirp->d_name, "..") != 0)) {
          chdir(dirp->d_name);
          rst = filesea(file_name);
          chdir("..");
        }
      }
      else if(strcmpi(dirp->d_name, file_name) == 0) {
        getcwd(fullfilename, STRSZ);
        ads_printf("\nArquivo %s\\%s foi encontrado.", fullfilename, file_name);
        ads_initget(0, "Yes No");
        optrst = ads_getkword("\nUtilizar este arquivo <Yes>: ", thisfile);
        if((optrst == RTNORM) || (optrst == RTNONE))
          if((strcmp(thisfile, "Yes") == 0) || (thisfile[0] == '\0'))
            rst = RTNORM;
      }
    }
    closedir(dird);
  }
  return rst;
}
