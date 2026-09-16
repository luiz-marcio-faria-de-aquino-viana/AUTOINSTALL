
/*
/* aci_filter.cpp
/* Copyright (C) 1999-2013 by Luiz Marcio F A Viana, 23/09/2013
*/

#include<stdio.h>
#include<conio.h>
#include<string.h>
#include<stdlib.h>    
#include<sys\types.h>
#include<direct.h>
#include<dos.h>
#include<io.h>
#include"all.h"


/* implementacao das funcoes ADS externas
*/

int aci_filter_layerfilter()
{
	struct resbuf *args;
	str_t enttype;
	str_t layername;

	args = ads_getargs();
	if(getargs(args, 0, RTSTR, enttype) != RTNORM)
		return RTERROR;
	if(getargs(args, 0, RTSTR, layername) != RTNORM)
		return RTERROR;

	return filter_layerfilter(enttype, layername);
}

int aci_filter_layerfilter_cmd()
{
	struct resbuf *ent = NULL;
	struct resbuf* dxf_enttype;
	struct resbuf* dxf_layer;
	ads_name enm;
	ads_point pt;
	int rscode;

	rscode = ads_entsel(_T("\nSelecione um objeto de referencia: "), enm, pt);
	if(rscode == RTNORM)
	{
		if(enm != NULL)
		{
			ent = ads_entget(enm);

			dxf_enttype = rbassoc(ent, (short)0);
			dxf_layer = rbassoc(ent, (short)8);
			if((dxf_enttype != NULL) && (dxf_layer != NULL)) {
				rscode = filter_layerfilter(dxf_enttype->resval.rstring, dxf_layer->resval.rstring);
			}
		}
	}

	if(ent != NULL) ads_relrb(ent);

	return rscode;
}

/* implementacao das funcoes internas da aplicacao
*/

// filter_layerfilter(): funcao que seleciona os objetos de mesmo tipo pertencentes a camada
// enttype - tipo de entidade
// layname - nome da camada
int filter_layerfilter(TCHAR* enttype, TCHAR* layername)
{
	struct resbuf *resb;
	struct resbuf *filter;
	ads_name setname;
	int rscode;

	filter = ads_buildlist(RTDXF0, enttype, 8, layername, RTNONE);

	rscode = ads_ssget(_T("X"), NULL, NULL, filter, setname);
	if(rscode != RTERROR)
		ads_retname(setname, RTPICKS);
	else
		ads_retnil();

	ads_relrb(filter);

	return RTNORM;
}

/* implementacao da funcao de inicializacao
*/
int init_aci_filter()
{
	return (funcload(filter_functbl, ELEMENTS(filter_functbl)));
}
