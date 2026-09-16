
/*
/* aci_il.h
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#ifndef __ACI_IL_H
#define __ACI_IL_H

/* declaracao das funcoes ADS externas
*/

int aci_il_dsprefl();
int aci_il_getrefl();

/* definicao da tabela de funcoes ADS externas
*/
static extftbl_t il_functbl[] = {
	{ "aci_il_dsprefl", aci_il_dsprefl },
	{ "aci_il_getrefl", aci_il_getrefl }
};

/* declaracao das funcoes internas da aplicacao
*/

// il_dsprefl(): funcao que apresenta a lista de refletores cadastrados
int il_dsprefl();

// il_getrefl(): funcao que retorna o refletor selecionado
// cdg - codigo do refletor
int il_getrefl(short cdg);

/* declaracao da funcao de inicializacao
*/
int init_aci_il();

#endif
