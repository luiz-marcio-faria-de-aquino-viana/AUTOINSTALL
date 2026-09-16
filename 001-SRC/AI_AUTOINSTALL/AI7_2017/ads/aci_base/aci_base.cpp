
/*
/* aci_base.cpp
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#include<stdio.h>
#include"all.h"

/* implementacao da funcao principal ponto de entrada da aplicacao
*/

extern "C" AcRx::AppRetCode 
acrxEntryPoint(AcRx::AppMsgCode msg, void* appId)
{
	switch (msg) {
		case AcRx::kInitAppMsg:
		case AcRx::kLoadDwgMsg:
			evLoadApp();
			break;
		case AcRx::kUnloadAppMsg:
		case AcRx::kUnloadDwgMsg:
			evUnloadApp();
			break;
		case AcRx::kInvkSubrMsg:
			evInvkSubr();
			break;
        default :
			break;
    }
	return AcRx::kRetOK;
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
