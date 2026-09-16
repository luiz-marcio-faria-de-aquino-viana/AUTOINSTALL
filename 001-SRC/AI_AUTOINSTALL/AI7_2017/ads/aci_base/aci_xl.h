
/*
/* aci_xl.h
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#ifndef __ACI_XL_H
#define __ACI_XL_H

/* declaracao das funcoes ADS externas
*/

int aci_xloadf();
int aci_xrun();

/* definicao da tabela de funcoes ADS externas
*/
static extftbl_t xl_functbl[] = {
	{ _T("aci_xloadf"), aci_xloadf },
	{ _T("aci_xrun"), aci_xrun }
};

/* declaracao das funcoes internas da aplicacao
*/

// validate(): funcao que valida a estacao de operacao
int validate();

// xfload(): funcao que pesquisa por um arquivo no disco
// file_name - nome do arquivo a ser carregado
// file_pos - posicao de inicio para leitura do arquivo
int xfload(const char *file_name, short file_pos);

// xrun(): funcao que executa um programa externo
// path - caminho de pesquisa do programa externo
// args - lista de parametros passados ao programa
int xrun(const char* path, char** args);

/* declaracao da funcao de inicializacao
*/
int init_aci_xl();

#endif
