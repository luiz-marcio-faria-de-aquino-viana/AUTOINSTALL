
/*
/* aci_str.cpp
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#include<string.h>
#include"all.h"

/* implementacao das funcoes internas da aplicacao
*/

// strheader(): funcao que retorna a subcadeia que antecede o delimitador
// str1 - cadeia a ser pesquisada
// str2 - cadeia delimitadora
char* strheader(char* str1, char* str2)
{
	char* p = str1;
	while((*p) != K_NUL) {
		if( !strncmp(p, str2, strlen(str2)) ) {
			(*p) = K_NUL;
			return str1;
		}
		p++;
	}
	return str1;
}

// strtail(): funcao que retorna a subcadeia que sucede o delimitador
// str1 - cadeia a ser pesquisada
// str2 - cadeia delimitadora
char* strtail(char* str1, char* str2)
{
	char* p = str1;
	while((*p) != K_NUL) {
		if( !strncmp(p, str2, strlen(str2)) )
			return &p[strlen(str2)];
		p++;
	}
	return p;
}

// strisnull(): funcao que retorna verdadeiro se a cadeia analisada for nula
// str - cadeia a ser analisada
int strisnull(char* str)
{
	while( ((*str) == K_SPC) || ((*str) == K_TAB) ||
		   ((*str) == K_LF)  || ((*str) == K_CR) )
		str++;
	if((*str) == K_NUL)
		return TRUE;
	return FALSE;
}

/* implementacao das funcoes ADS externas
*/

int aci_strheader()
{
	str_t str1;
	str_t str2;

	struct resbuf* args = NULL;

	args = ads_getargs();
	if( (getargs(args, 0, RTSTR, str1) != RTNORM) ||
		(getargs(args, 1, RTSTR, str2) != RTNORM) )
		return RTERROR;

	ads_retstr(strheader(str1, str2));
	return RTNORM;
}

int aci_strtail()
{
	str_t str1;
	str_t str2;

	struct resbuf* args = NULL;

	args = ads_getargs();
	if( (getargs(args, 0, RTSTR, str1) != RTNORM) ||
		(getargs(args, 1, RTSTR, str2) != RTNORM) )
		return RTERROR;

	ads_retstr(strtail(str1, str2));
	return RTNORM;
}

int aci_strisnull()
{
	str_t str;
	struct resbuf* args = NULL;

	args = ads_getargs();
	if(getargs(args, 0, RTSTR, str) != RTNORM)
		return RTERROR;

	if( strisnull(str) == TRUE )
		ads_rett();
	else
		ads_retnil();

	return RTNORM;
}

/* implementacao da funcao de inicializacao
*/
int init_aci_str()
{
	return (funcload(str_functbl, ELEMENTS(str_functbl)));
}
