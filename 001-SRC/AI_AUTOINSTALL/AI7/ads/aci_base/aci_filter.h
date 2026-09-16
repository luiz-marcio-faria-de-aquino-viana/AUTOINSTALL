
/*
/* aci_filter.h
/* Copyright (C) 1999-2013 by Luiz Marcio F A Viana, 23/09/2013
*/

#ifndef __ACI_FILTER_H
#define __ACI_FILTER_H

/* declaracao das funcoes ADS externas
*/

int aci_filter_layerfilter();
int aci_filter_layerfilter_cmd();

/* definicao da tabela de funcoes ADS externas
*/
static extftbl_t filter_functbl[] = {
	{ "aci_filter_layerfilter", aci_filter_layerfilter },
	{ "aci_filter_layerfilter_cmd", aci_filter_layerfilter_cmd }
};

/* declaracao das funcoes internas da aplicacao
*/

// filter_layerfilter(): funcao que seleciona os objetos de mesmo tipo pertencentes a camada
// enttype - tipo de entidade
// layname - nome da camada
int filter_layerfilter(char* enttype, char* layername);

/* declaracao da funcao de inicializacao
*/
int init_aci_filter();

#endif
