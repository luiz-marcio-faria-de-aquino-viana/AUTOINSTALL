
/*
/* aci_xl.cpp
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 6/3/99
*/

#include<stdio.h>
#include<stdlib.h>    
#include<string.h>
#include<process.h>
#include"all.h"

/* implementacao das funcoes internas da aplicacao
*/

// validate(): funcao que valida a estacao de operacao
int validate()
{
	if ((!_wgetenv(_T("AIX"))) || (!wcsicmp(_wgetenv(_T("AIX")), _T("ENABLE"))))
  {
    ads_prompt(_T("\nERR: Invalid computer system.\n"));
	return RTERROR;
  }

  return RTNORM;
}

// xfload(): funcao que pesquisa por um arquivo no disco
// file_name - nome do arquivo a ser carregado
// file_pos - posicao de inicio para leitura do arquivo
int xfload(TCHAR *file_name, short file_pos)
{
	FILE *file_ptr;
	str_t s;
	int n;
  
	int i;

//	if(validate() == RTERROR)
//		return RTERROR;   /* check for system */

	if((file_ptr = _wfopen(file_name, _T("rb"))) == NULL) {
		ads_printf(_T("\nERR: Nao foi possivel carregar o comando solicitado."));
		return RTERROR;
	}

	fseek(file_ptr, file_pos, SEEK_SET);
	n = fread(s, sizeof(TCHAR), STRSZ - 1, file_ptr);
	for(i = 0; i < n; i++)
		s[i] = s[i] - ((file_pos + i + 1) % 128);
	s[n] = '\0';

	fclose(file_ptr);

	ads_retstr(s);
	return RTNORM;
}

int xrun(TCHAR* path, TCHAR** args)
{
	if(_wspawnv(_P_NOWAIT, path, args) == -1) {
		ads_prompt(_T("\nERR: Falha ao chamar o programa externo. "));
		return RTERROR;
	}
	return RTNORM;
}

/* implementacao das funcoes ADS externas
*/

int aci_xloadf()
{
	struct resbuf* args = NULL;

	str_t file_name;
	short file_pos;

	args = ads_getargs();
	if( (getargs(args, 0, RTSTR, file_name) != RTNORM) ||
		(getargs(args, 1, RTSHORT, &file_pos) != RTNORM) )
		return RTERROR;

	return xfload(file_name, file_pos);
}

int aci_xrun()
{
	struct resbuf* args = NULL;
	int argsnum;

	str_t s;
	TCHAR** argsarr;

	int i;

	args = ads_getargs();
	if((argsnum = getnumargs(args)) < 1) {
		errmsg(ERR_ARGINVNUM, _T(""));
		return RTERROR;
	}

	if((argsarr = (TCHAR**) malloc(argsnum + 1)) == 0) {
		errmsg(ERR_CANTALLOCMEM, _T(""));
		return RTERROR;
	}

	for(i = 0; i < argsnum; i++) {
		if(getargs(args, i, RTSTR, s) != RTNORM) return RTERROR;
		if((argsarr[i] = (TCHAR*) ads_calloc(wcslen(s) + 1, sizeof(TCHAR))) == 0) {
			errmsg(ERR_CANTALLOCMEM, _T(""));
			return RTERROR;
		}
		wcscpy(argsarr[i], s);
	}

	argsarr[argsnum] = NULL;

	return xrun(argsarr[0], argsarr);
}

/* implementacao da funcao de inicializacao
*/
int init_aci_xl()
{
	return (funcload(xl_functbl, ELEMENTS(xl_functbl)));
}
