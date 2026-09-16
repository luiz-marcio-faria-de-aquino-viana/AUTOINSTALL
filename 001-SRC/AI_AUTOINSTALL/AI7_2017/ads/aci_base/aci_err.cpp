
/*
/* aci_err.cpp
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#include"all.h"

str_t errtile;

/* implementacao das funcoes ADS externas
*/

int aci_errmsg()
{
	short err;
	str_t msg;

	struct resbuf* args = NULL;

	args = ads_getargs();
	if( (getargs(args, 0, RTSHORT, &err) != RTNORM) ||
		(getargs(args, 1, RTSTR, msg) != RTNORM) )
		return RTERROR;

	errmsg(err, msg);
	return RTNORM;
}

/* implementacao das funcoes internas da aplicacao
*/

// errmsg(): funcao que apresenta a mensagem de erro correspondente ao codigo informado
// err - codigo de ocorrencia do erro
// msg - mensagem adicional fornecida pelo usuario
void errmsg(int err, TCHAR* msg)
{
	if(err < ELEMENTS(err_msgtbl))
		ads_printf(_T("\nERR(%03d): %s %s\n"), err, err_msgtbl[err], msg);
	else
		ads_printf(_T("\nERR(%03d): Codigo de erro desconhecido.\n"), err);
	return;
}

/* implementacao da funcao de inicializacao
*/
int init_aci_err()
{
	return (funcload(err_functbl, ELEMENTS(err_functbl)));
}
