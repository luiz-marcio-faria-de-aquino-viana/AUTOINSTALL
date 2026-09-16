
/*
/* aci_str.h
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#ifndef __ACI_STR_H
#define __ACI_STR_H

/* declaracao das funcoes ADS externas
*/

int aci_strheader();
int aci_strtail();
int aci_strisnull();

/* definicao da tabela de funcoes ADS externas
*/
static extftbl_t str_functbl[] = {
	{ _T("aci_strheader"), aci_strheader },
	{ _T("aci_strtail"), aci_strtail },
	{ _T("aci_strisnull"), aci_strisnull }
};

/* declaracao das funcoes internas da aplicacao
*/

// strheader(): funcao que retorna a subcadeia que antecede o delimitador
// str1 - cadeia a ser pesquisada
// str2 - cadeia delimitadora
TCHAR* strheader(TCHAR* str1, TCHAR* str2);

// strtail(): funcao que retorna a subcadeia que sucede o delimitador
// str1 - cadeia a ser pesquisada
// str2 - cadeia delimitadora
TCHAR* strtail(TCHAR* str1, TCHAR* str2);

// strisnull(): funcao que retorna verdadeiro se a cadeia analisada for nula
// str - cadeia a ser analisada
int strisnull(TCHAR* str);

/* declaracao da funcao de inicializacao
*/
int init_aci_str();

#endif
