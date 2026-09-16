
/*
/* aci_tools.cpp
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

int aci_tools_explodeattr()
{
	struct resbuf* filter = NULL;
	ads_name setname;
	int rscode;

	filter = ads_buildlist(RTDXF0, "INSERT");

	ads_prompt("\nSelecione os blocos para processamento...");
	rscode = ads_ssget(NULL, NULL, NULL, filter, setname);
	if(rscode == RTNORM)
	{
		rscode = tools_explodeattr(setname);
		ads_ssfree(setname);
	}

	ads_relrb(filter);

	return rscode;
}

/* implementacao das funcoes internas da aplicacao
*/

// tools_explodeattr(): funcao que transforma os atributos dos blocos em textos
// ss - entidades selecionadas para processamento
int tools_explodeattr(ads_name ss)
{
	ads_name enm;
	struct sds_resbuf *ent;
	struct sds_resbuf *dxf_enttype;
	struct sds_resbuf oldlay;
	long len;

	str_t str;
	int rscode;

	ads_getvar("CLAYER", &oldlay);

	ads_command(RTSTR, ".ucs", RTSTR, "", RTNONE);

	ads_sslength(ss, &len);
	sprintf(str, "\nProcessando %ld blocos... ", len);
	ads_prompt(str);
	for(long i = 0; i < len; i++)
	{
		if((i % 100) == 0) {
			sprintf(str, "%ld.", i);
			ads_prompt(str);
		}

		rscode = ads_ssname(ss, i, enm);
		if (rscode == RTNORM) {
			ent = ads_entget(enm);

			dxf_enttype = rbassoc(ent, (short)0);
			if(dxf_enttype != NULL) {
				if(strcmp(dxf_enttype->resval.rstring, "INSERT") == 0) {
					tools_explodeattr_copytext(enm);
					tools_explodeattr_explodeblock(enm);
				}
			}

			ads_relrb(ent);
		}
	}

	ads_command(RTSTR, ".layer", RTSTR, "s", RTSTR, oldlay.resval.rstring, RTSTR, "", RTNONE);
	ads_command(RTSTR, ".redraw", RTNONE);

	return RTNORM;
}

// tools_explodeattr_copytext(): funcao que transforma os atributos dos blocos em textos
// enm - nome da entidade que sera transformada
int tools_explodeattr_copytext(ads_name enm)
{
	struct sds_resbuf *ent;
	struct sds_resbuf *dxf_currlayer;

	ads_name curr_enm;
	ads_name next_enm;
	struct sds_resbuf *next_ent;

	struct sds_resbuf *dxf_enttype;
	struct sds_resbuf *dxf_text;
	struct sds_resbuf *dxf_layer;
	struct sds_resbuf *dxf_point;
	struct sds_resbuf *dxf_endpoint;
	struct sds_resbuf *dxf_height;
	struct sds_resbuf *dxf_rot;
	struct sds_resbuf *dxf_align;

	bool seqend = false;
	int rscode;

	str_t str;

	ent = ads_entget(enm);
	dxf_currlayer = rbassoc(ent, (short)8);

	ads_command(RTSTR, ".layer", RTSTR, "s", RTSTR, dxf_currlayer->resval.rstring, RTSTR, "", RTNONE);

	ads_name_set(enm, curr_enm);
	while( !seqend && (ads_entnext(curr_enm, next_enm) == RTNORM) ) {
		next_ent = ads_entget(next_enm);
		
		dxf_enttype = rbassoc(next_ent, (short)0);
		if(dxf_enttype != NULL)
		{
			if(strcmp(dxf_enttype->resval.rstring, "SEQEND") == 0) {
				seqend = true;
			}
			else {
				dxf_text = rbassoc(next_ent, (short)1);
				dxf_layer = rbassoc(next_ent, (short)8);
				dxf_point = rbassoc(next_ent, (short)10);
				dxf_endpoint = rbassoc(next_ent, (short)11);
				dxf_height = rbassoc(next_ent, (short)40);
				dxf_rot = rbassoc(next_ent, (short)50);
				dxf_align = rbassoc(next_ent, (short)72);

				if( (dxf_point != NULL) &&
					(dxf_endpoint != NULL) &&
					(dxf_text != NULL) &&
					(dxf_layer != NULL) &&
					(dxf_height != NULL) &&
					(dxf_rot != NULL) &&
					(dxf_align != NULL) )
				{
					if(strlen(dxf_text->resval.rstring) > 0)
					{
						if(dxf_align->resval.rint == 1) //Center
						{
							ads_command(RTSTR, ".text", RTSTR, "c", RT3DPOINT, dxf_endpoint->resval.rpoint, RTREAL, dxf_height->resval.rreal, RTREAL, dxf_rot->resval.rreal, RTSTR, dxf_text->resval.rstring, RTNONE);
						}
						else if(dxf_align->resval.rint == 2) //Right
						{
							ads_command(RTSTR, ".text", RTSTR, "r", RT3DPOINT, dxf_endpoint->resval.rpoint, RTREAL, dxf_height->resval.rreal, RTREAL, dxf_rot->resval.rreal, RTSTR, dxf_text->resval.rstring, RTNONE);
						}
						else //Left
						{
							ads_command(RTSTR, ".text", RT3DPOINT, dxf_point->resval.rpoint, RTREAL, dxf_height->resval.rreal, RTREAL, dxf_rot->resval.rreal, RTSTR, dxf_text->resval.rstring, RTNONE);
						}
					}
				}
			}
		}

		ads_relrb(next_ent);

		ads_name_set(next_enm, curr_enm);
	}

	ads_relrb(ent);

	return RTNORM;
}

// tools_explodeattr_explodeblock(): funcao que explode o bloco e remove os atributos
// enm - nome da entidade que sera transformada
int tools_explodeattr_explodeblock(ads_name enm)
{
	ads_name last_enm;
	ads_name curr_enm;
	ads_name next_enm;
	
	struct sds_resbuf *ent;
	struct sds_resbuf *next_ent;
	
	struct sds_resbuf *dxf_enttype;
	struct sds_resbuf *dxf_layer;

	struct sds_resbuf *old_dxf_layer;

	ads_entlast(last_enm);
	
	ent = ads_entget(enm);
	dxf_layer = rbassoc(ent, (short)8);
	if(dxf_layer != NULL) {
		ads_command(RTSTR, ".explode", RTENAME, enm, RTNONE);

		ads_name_set(last_enm, curr_enm);
		while(ads_entnext(curr_enm, next_enm) == RTNORM) {
			next_ent = ads_entget(next_enm);

			dxf_enttype = rbassoc(next_ent, (short)0);
			if(dxf_enttype != NULL)
			{
				if(strcmp(dxf_enttype->resval.rstring, "ATTDEF") == 0) {
					ads_entdel(next_enm);
				}
				else {
					old_dxf_layer = rbassoc(next_ent, (short)8);
					if(old_dxf_layer != NULL) {
						sds_free(old_dxf_layer->resval.rstring);
						old_dxf_layer->resval.rstring = (char*)sds_malloc(strlen(dxf_layer->resval.rstring) + 1);
						strcpy(old_dxf_layer->resval.rstring, dxf_layer->resval.rstring);
						ads_entmod(next_ent);
					}
				}
			}

			ads_relrb(next_ent);

			ads_name_set(next_enm, curr_enm);
		}

		ads_relrb(ent);
	}
	
	return RTNORM;
}

/* implementacao da funcao de inicializacao
*/
int init_aci_tools()
{
	return (funcload(tools_functbl, ELEMENTS(tools_functbl)));
}
