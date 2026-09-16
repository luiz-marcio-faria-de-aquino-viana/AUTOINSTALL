
/*
/* aci_base.cpp
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#include<stdio.h>
#include"all.h"

/* implementacao da funcao principal ponto de entrada da aplicacao
*/

int main(int argc, char **argv)
{
	short linkstat;

    sds_init(argc, argv); 

    for(;;) {
		if ((linkstat = sds_link(RSRSLT)) < 0) {
             sds_printf("\nERR: Falha na comunicacao com aplicacao sds (=%d).", linkstat);
             sds_exit(-1);
        }
        
        switch(linkstat) {
            case RQXLOAD: 
				evLoadApp();
				break;
            case RQXUNLD: 
				evUnloadApp();
				break;
            case RQSUBR :
				evInvkSubr();
				break;
            case RQEND  : 
            case RQQUIT : 
            case RQSAVE :
            default     :
				break;
        }
    }
    return(0);
}

/* implementacao das funcoes de controle da aplicacao
*/

// evLoadApp(): funcao de resposta ao evento de carga da aplicacao
void evLoadApp()
{
	init_aci_err();
	init_aci_str();
    init_aci_fil();
	init_aci_il();
	init_aci_xl();
	init_aci_net();
	init_aci_filter();
	init_aci_tools();
}

// evUnloadApp(): funcao de resposta ao evento de finalizacao da aplicacao
void evUnloadApp()
{
	funcunload();
}

// evInvkSubr(): funcao de resposta ao evento de execucao de funcao externa
void evInvkSubr()
{
	dofun();
}
