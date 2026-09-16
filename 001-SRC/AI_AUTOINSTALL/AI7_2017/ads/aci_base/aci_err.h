
/*
/* aci_err.h
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#ifndef __ACI_ERR_H
#define __ACI_ERR_H

/* declaracao das funcoes ADS externas
*/

int aci_errmsg();

/* definicao da tabela de funcoes ADS externas
*/
static extftbl_t err_functbl[] = {
	{ _T("aci_errmsg"), aci_errmsg }
};

/* definicao da tabela de codigos de erro
*/

enum err_code_t {
// manipulacao do arquivo de configuracao
	ERR_CFGFILENOTFOUND = 0,
	ERR_CFGCANTOPENFILE,
	ERR_CFGCANTRDFILE,
	ERR_CFGINVALIDINPUT,
// manipulacao de arquivo em geral
	ERR_CANTFINDFILE = 4,
	ERR_CANTOPENFILE,
// manipulacao de modulos do programa
	ERR_MODINVALID =6,
	ERR_MODINITFAIL,
// manipulacao dos argumentos passados a aplicacao
	ERR_ARGINVNUM = 8,
	ERR_ARGINVTYPE,
	ERR_ARGINVREQ,
// manipulacao de recursos de rede
    ERR_CANTGETUSRNAME = 11,
    ERR_CANTGETCPUNAME,
// manipulacao de memoria
	ERR_CANTALLOCMEM = 13
};

/* definicao da tabela de mensagens de erro
*/

static TCHAR* err_msgtbl[] = {
// manipulacao do arquivo de configuracao
	/* #000 */	_T("Nao foi possivel encontrar o arquivo de configuracao."),
				_T("Nao foi possivel abrir o arquivo de configuracao."),
				_T("Nao foi possivel ler o arquivo de configuracao."),
				_T("Entrada invalida no arquivo de configuracao."),
// manipulacao de arquivo em geral
	/* #004 */	_T("Nao foi possivel encontrar o arquivo."),
				_T("Nao foi possivel abrir o arquivo."),
// manipulacao de modulos do programa
	/* #006 */	_T("Tentativa de carregar um modulo invalido."),
				_T("Falha na inicializacao dos modulos."),
// manipulacao dos argumentos passados a aplicacao
	/* #008 */	_T("Numero de argumentos invalido."),
				_T("Tipo de argumento invalido."),
				_T("Tipo de argumento requerido invalido."),
// manipulacao de recursos de rede
    /* #011 */  _T("Nao foi possivel obter o nome do usuario."),
				_T("Nao foi possivel obter o nome do computador."),
// manipulacao de memoria
	/* #013 */	_T("Nao foi possivel alocar memoria.")
};

/* declaracao das funcoes internas da aplicacao
*/

// errmsg(): funcao que apresenta uma mensagem de erro correspondente ao codigo informado
// err - codigo de ocorrencia do erro
// msg - mensagem adicional fornecida pelo usuario
void errmsg(int err, TCHAR* msg);

/* declaracao da funcao de inicializacao
*/
int init_aci_err();

#endif
