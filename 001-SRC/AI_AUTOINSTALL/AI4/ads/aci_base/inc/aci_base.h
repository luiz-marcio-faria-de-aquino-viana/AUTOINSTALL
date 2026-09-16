
/*
/* aci_base.h
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#ifndef __ACI_BASE_H
#define __ACI_BASE_H

/* declaracao das funcoes de controle da aplicacao
*/

// evInitApp(): funcao de resposta ao evento de inicializacao da aplicacao
void evLoadApp();

// evUnloadApp(): funcao de resposta ao evento de finalizacao da aplicacao
void evUnloadApp();

// evInvkSubr(): funcao de resposta ao evento de execucao de funcao externa
void evInvkSubr();

#endif
