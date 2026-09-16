
/*
/* aci_fil.h
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#ifndef __ACI_FIL_H
#define __ACI_FIL_H

/* declaracao das funcoes ADS externas
*/

int aci_filesea();
int aci_fileread();

/* definicao da tabela de funcoes ADS externas
*/
static extftbl_t fil_functbl[] = {
	{ _T("aci_filesea"), aci_filesea },
	{ _T("aci_fileread"), aci_fileread }
};

/* declaracao das funcoes internas da aplicacao
*/

// getinitdir(): funcao que retorna a letra do drive em um caminho de diretorio
// pth - caminho de diretorio a ser analisado
char* getfirstdir(TCHAR *i_pth, TCHAR* *o_pth);

// filesea(): funcao que pesquisa por um arquivo no disco
// file_name - nome do arquivo a ser pesquisado
int filesea(const TCHAR *file_name);

// fileread(): funcao que constroi uma lista a partir de um arquivo texto delimitado
// f - nome do arquivo de listagem
// c - caracter delimitador
int fileread(rbufdesc_t* desc, const TCHAR *f, const TCHAR* c);

/* declaracao da funcao de inicializacao
*/
int init_aci_fil();

#endif
