
/*
/* aci_tools.h
/* Copyright (C) 1999-2013 by Luiz Marcio F A Viana, 23/09/2013
*/

#ifndef __ACI_TOOLS_H
#define __ACI_TOOLS_H

/* declaracao das funcoes ADS externas
*/

int aci_tools_explodeattr();

/* definicao da tabela de funcoes ADS externas
*/
static extftbl_t tools_functbl[] = {
	{ _T("c:aci_tools_explodeattr"), aci_tools_explodeattr }
};

/* declaracao das funcoes internas da aplicacao
*/

// tools_explodeattr(): funcao que transforma os atributos dos blocos em textos
// ss - entidades selecionadas para processamento
int tools_explodeattr(ads_name ss);

// tools_explodeattr_copytext(): funcao que transforma os atributos dos blocos em textos
// enm - nome da entidade que sera transformada
int tools_explodeattr_copytext(ads_name enm);

// tools_explodeattr_explodeblock(): funcao que explode o bloco e remove os atributos
// enm - nome da entidade que sera transformada
int tools_explodeattr_explodeblock(ads_name enm);

/* declaracao da funcao de inicializacao
*/
int init_aci_tools();

#endif
