
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
#include"all.h"

extern str_t errtile;

/* declaracao das variaveis globais da aplicacao
*/

str_t pathname, thisfile;


/* implementacao das funcoes internas da aplicacao
*/

// getfirstdir(): funcao que retorna o primeiro subdiretorio no caminho de pesquisa
// i_pth - caminho de diretorio a ser analisado
// o_pth - caminho de diretorio encontrado
TCHAR *getfirstdir(TCHAR *i_pth, TCHAR *o_pth)
{
	TCHAR *q, *p;
	int n = 1;

	struct _finddata_t fileinfo;
	long hfile;

	wcscpy(o_pth, i_pth);

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
int filesea(const TCHAR *file_name)
{
  struct _wfinddata_t fileinfo;
  long hfile;

  int rst = RTERROR, optrst;

  if((hfile = _wfindfirst(_T("*.*"), &fileinfo)) != -1L)
  {
	do {
		if (!wcsicmp(file_name, fileinfo.name))
	  {
        _wgetcwd(pathname, STRSZ);
        ads_printf(_T("\nArquivo %s\\%s foi encontrado."), pathname, file_name);
        ads_initget(0, _T("Yes No"));
        optrst = ads_getkword(_T("\nUtilizar este arquivo <Yes>: "), thisfile);
        if((optrst == RTNORM) || (optrst == RTNONE))
          if((_wcsicmp(thisfile, _T("Yes")) == 0) || (thisfile[0] == '\0'))
            rst = RTNORM;
	  }
	  else if( (fileinfo.attrib & _A_SUBDIR) )
	  {
        if(( wcscmp(fileinfo.name, _T(".")) != 0 ) && ( wcscmp(fileinfo.name, _T("..")) != 0 ))
		{
          _wchdir(fileinfo.name);
          rst = filesea(file_name);
          _wchdir(_T(".."));
        }
      }
    } while((rst == RTERROR) && (_wfindnext(hfile, &fileinfo) == 0));

    _findclose(hfile);
  }
  return rst;
}

// fileread(): funcao que constroi uma lista a partir de um arquivo texto delimitado
// f - nome do arquivo de listagem
// c - caracter delimitador
int fileread(rbufdesc_t* desc, const TCHAR *f, const TCHAR* c)
{
	FILE* fp;

	str_t str;
	int strsz;

	str_t strtmp;

	if((fp = _wfopen(f, _T("r"))) == 0) {
		wprintf(errtile, _T("(=%s)"), f);
		errmsg(ERR_CANTOPENFILE, errtile);
		return RTERROR;
	}

	while(fgetws(str, STRSZ, fp) != NULL) {
		str[STRSZ - 1] = '\0';

		strsz = wcslen(str);
		if(str[strsz - 1] == '\n')
			str[strsz - 1] = '\0';

		rbnewitem(desc, RTLB);

		while((*str) != '\0') {
			wcscpy(strtmp, str);
			rbnewitem(desc, RTSTR, strheader(strtmp, _T("@")));
			wcscpy(str, strtail(str, _T("@")));
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

	_wcsupr(path_name);
	_wcsupr(file_name);

	_wgetcwd(olddir, STRSZ);
	if(getfirstdir(path_name, initdir) != NULL) ads_retnil();

	_wchdir(initdir);
	if(filesea(file_name) == RTNORM) {
		wcscat(wcscat(pathname, _T("\\")), file_name);
		ads_retstr(pathname);
	}
	else
		ads_retnil();

	_wchdir(olddir);
  
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
		ads_retnil();
	rbrelease(& desc);
	
	return RTNORM;
}

/* implementacao da funcao de inicializacao
*/
int init_aci_fil()
{
	return (funcload(fil_functbl, ELEMENTS(fil_functbl)));
}
