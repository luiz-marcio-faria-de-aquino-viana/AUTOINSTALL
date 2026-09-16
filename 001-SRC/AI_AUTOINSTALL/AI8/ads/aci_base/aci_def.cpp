
/*
/* aci_def.cpp
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#include<string.h>
#include"all.h"

/* implementacao das funcoes para manipulacao da tabela de funcoes externas
*/

// addftbl(): funcao que adiciona um novo vetor de funcoes externas
// functbl - tabela das funcoes ADS externas que serao definidas
// nfunc - numero de funcoes ADS externas que serao definidas
int addftbl(extftbl_t* functbl, int nfunc)
{
	ftbllist_t* p;

	if((p = (ftbllist_t*) malloc(sizeof(ftbllist_t))) == NULL)
		return RTERROR;

	p->functbl = functbl;
	p->nfunc = nfunc;
	p->next = NULL;

	if(tbllist.fsttbl == NULL)
		tbllist.fsttbl = p;

	if(tbllist.lsttbl != NULL)
		(tbllist.lsttbl)->next = p;
	tbllist.lsttbl = p;

	return RTNORM;
}

// remftbl(): funcao que remove todas as tabelas de funcoes externas da lista
int remftbl()
{
	ftbllist_t *p, *q;

	p = tbllist.fsttbl;
	while(p != NULL) {
		q = p->next;
		free(p);
		p = q;
	}

	tbllist.fsttbl = NULL;
	tbllist.lsttbl = NULL;
	tbllist.nfunc = 0;

	return RTNORM;
}

/* implementacao das funcoes para manipulacao de argumentos
*/

// getnumargs(): funcao que retorna o numero de argumentos passados a funcao externa
// args - lista de argumentos passados a funcao externa
int getnumargs(resbuf* args)
{
	int n = 0;
	while(args != NULL) {
		args = args->rbnext;
		n += 1;
	}
	return n;
}

// getargs(): funcao que retorna o n-esimo argumento passado a uma funcao externa
// args - lista de argumentos passados a funcao externa
// pos - posicao do elemento na lista de argumentos
// typ - tipo experado para o argumento
// ptr - endereco da variavel de retorno do argumento
int getargs(resbuf* args, int pos, short typ, void* ptr)
{

	if(args == NULL) {
		errmsg(ERR_ARGINVNUM, "");
		return RTERROR;
	}

	while(pos > 0) {
		if((args = args->rbnext) == NULL) {
			errmsg(ERR_ARGINVNUM, "");
			return RTERROR;
		}
		pos -= 1;
	}

	if(args->restype == typ) {
		switch(args->restype) {
			case RTREAL:
			case RTANG:
				(* ((ads_real*) ptr)) = args->resval.rreal;
				break;
			case RTPOINT:
				ads_point_set(args->resval.rpoint, (ads_real*) ptr);
				break;
			case RTSHORT:
			case RTDXF0:
				(* ((short*) ptr)) = args->resval.rint;
				break;
			case RTSTR:
			case RTT:
			case RTNIL:
				strncpy((char*) ptr, args->resval.rstring, STRSZ - 1);
				((char*) ptr)[STRSZ - 1] = '\0';
				break;
			case RTENAME:
			case RTPICKS:
				memcpy(ptr, args->resval.rlname, sizeof(longlong));
				break;
			case RTLONG:
				(* ((long*) ptr)) = args->resval.rlong;
				break;
			default:
				errmsg(ERR_ARGINVREQ, "");
				return RTERROR;
		}
	}
	else {
		errmsg(ERR_ARGINVTYPE, "");
		return RTERROR;
	}
	return RTNORM;
}

/* implementacao das funcoes de controle das funcoes ADS externas
*/

// funcload(): funcao de definicao das funcoes ADS externas
// functbl - tabela das funcoes ADS externas que serao definidas
// nfunc - numero de funcoes ADS externas que serao definidas
int funcload(extftbl_t* functbl, int nfunc)
{
	int rst;
	int i;

	for(i = 0; i < nfunc; i++) {
		if((rst = ads_defun(functbl[i].name, tbllist.nfunc)) != RTNORM)
			return rst;
		tbllist.nfunc += 1;
	}
	return (addftbl(functbl, nfunc));
}

// funcunload(): funcao de eliminacao da definicao das funcoes ADS externas
int funcunload()
{
	int rst;
	int i;

	ftbllist_t* p = tbllist.fsttbl;
	int nfunc = 0;

	while(p != NULL) {
		for(i = 0; i < p->nfunc; i++) {
			if((rst = ads_undef((p->functbl)[i].name, nfunc)) != RTNORM)
				return rst;
			nfunc += 1;
		}
		p = p->next;
	}
	return (remftbl());
}

// dofun(): funcao de lancamento das funcoes ADS externas
int dofun()
{
	ftbllist_t *p;
	int val;

	if(((val = ads_getfuncode()) < 0) || (val > tbllist.nfunc))
		return RTERROR;

	p = tbllist.fsttbl;
	while(p != NULL) {
		if(val < p->nfunc)
			return (*(p->functbl)[val].ptr)();
		val -= p->nfunc;
		p = p->next;
	}

	return RTERROR;
}
