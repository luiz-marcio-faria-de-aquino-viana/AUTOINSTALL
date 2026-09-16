
/*
/* aci_fil.cpp
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 6/3/99
*/

#include<stdio.h>
#include<string.h>
#include<sys\types.h>
#include<direct.h>
#include<dos.h>
#include<io.h>
#include"..\inc\all.h"

extern str_t errtile;

/* declaracao das variaveis globais da aplicacao
*/

str_t pathname, thisfile;


/* implementacao das funcoes internas da aplicacao
*/

// getfirstdir(): funcao que retorna o primeiro subdiretorio no caminho de pesquisa
// i_pth - caminho de diretorio a ser analisado
// o_pth - caminho de diretorio encontrado
char *getfirstdir(char *i_pth, char *o_pth)
{
	char *q, *p;
	int n = 1;

	struct _finddata_t fileinfo;
	long hfile;

	strcpy(o_pth, i_pth);

	for( p = o_pth; (*p) != '\0'; p++) {
		if( ((*p) == '\\') || ((*p) == '/') ) {
			if(n != 0) {
				q = p;
				n -= 1;
			} else {
				(*p) = '\0';
				break;
			}
		}
	}

	if((hfile = _findfirst("*.*", & fileinfo)) != -1L) {
		if(fileinfo.attrib == _A_SUBDIR)
			return o_pth;
		else {
			(*q) = '\\';
			(* ++q) = '\0';
			return o_pth;
		}
	}

	return NULL;
}

// filesea(): funcao que pesquisa por um arquivo no disco
// file_name - nome do arquivo a ser pesquisado
int filesea(const char *file_name)
{
  struct _finddata_t fileinfo;
  long hfile;

  int rst = RTERROR, optrst;

  if((hfile = _findfirst("*.*", &fileinfo)) != -1L)
  {
	do {
      if( !_stricmp(file_name, fileinfo.name) )
	  {
        getcwd(pathname, STRSZ);
        ads_printf("\nArquivo %s\\%s foi encontrado.", pathname, file_name);
        ads_initget(0, "Yes No");
        optrst = ads_getkword("\nUtilizar este arquivo <Yes>: ", thisfile);
        if((optrst == RTNORM) || (optrst == RTNONE))
          if((strcmp(thisfile, "Yes") == 0) || (thisfile[0] == '\0'))
            rst = RTNORM;
	  }
	  else if( (fileinfo.attrib & _A_SUBDIR) )
	  {
        if(( strcmp(fileinfo.name, ".") != 0 ) && ( strcmp(fileinfo.name, "..") != 0 ))
		{
          chdir(fileinfo.name);
          rst = filesea(file_name);
          chdir("..");
        }
      }
    } while((rst == RTERROR) && (_findnext(hfile, &fileinfo) == 0));

    _findclose(hfile);
  }
  return rst;
}

// fileread(): funcao que constroi uma lista a partir de um arquivo texto delimitado
// f - nome do arquivo de listagem
// c - caracter delimitador
int fileread(rbufdesc_t* desc, const char *f, const char* c)
{
	FILE* fp;

	str_t str;
	int strsz;

	str_t strtmp;

	if((fp = fopen(f, "r")) == 0) {
		sprintf(errtile, "(=%s)", f);
		errmsg(ERR_CANTOPENFILE, errtile);
		return RTERROR;
	}

	while(fgets(str, STRSZ, fp) != NULL) {
		str[STRSZ - 1] = '\0';

		strsz = strlen(str);
		if(str[strsz - 1] == '\n')
			str[strsz - 1] = '\0';

		rbnewitem(desc, RTLB);

		while((*str) != '\0') {
			strcpy(strtmp, str);
			rbnewitem(desc, RTSTR, strheader(strtmp, "@"));
			strcpy(str, strtail(str, "@"));
		}

		rbnewitem(desc, RTLE);
	}

	fclose(fp);

	return RTNORM;
}

/* implementacao das funcoes ADS externas
*/

int aci_filesea()
{
	struct resbuf* args = NULL;

	str_t path_name, file_name;
	str_t olddir, initdir;

	int rst = RTERROR;

	args = ads_getargs();
	if( (getargs(args, 0, RTSTR, path_name) != RTNORM) ||
		(getargs(args, 1, RTSTR, file_name) != RTNORM) )
		return RTERROR;

	_strupr(path_name);
	_strupr(file_name);

	getcwd(olddir, STRSZ);
	if(getfirstdir(path_name, initdir) != NULL) ads_retnil();

	chdir(initdir);
	if(filesea(file_name) == RTNORM) {
		strcat(strcat(pathname, "\\"), file_name);
		ads_retstr(pathname);
	}
	else
		ads_retnil();

	chdir(olddir);
  
	return RTNORM;
}

int aci_fileread()
{
	struct resbuf* args = NULL;
	rbufdesc_t desc;

	str_t file_name, c;
	int rst = RTERROR;

	args = ads_getargs();
	if( (getargs(args, 0, RTSTR, file_name) != RTNORM) ||
		(getargs(args, 1, RTSTR, c) != RTNORM) )
		return RTERROR;

	rbinit(& desc);
	if(fileread(& desc, file_name, c) != RTERROR)
		ads_retlist(desc.fstitem);
	else
		sds_retnil();
	rbrelease(& desc);
	
	return RTNORM;
}

/* implementacao da funcao de inicializacao
*/
int init_aci_fil()
{
	return (funcload(fil_functbl, ELEMENTS(fil_functbl)));
}
