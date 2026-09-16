
/*
 * aci_net.h
 * Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
 */

#ifndef __ACI_NET_H
#define __ACI_NET_H 120

/* declaracao das funcoes ADS externas
*/

int aci_getusername();
int aci_getcomputername();


/* definicao da tabela de funcoes ADS externas
*/
static extftbl_t net_functbl[] = {
	{ "aci_getusername", aci_getusername },
	{ "aci_getcomputername", aci_getcomputername }
};


/* declaracao das funcoes internas da aplicacao
*/

// getusername(): funcao que obtem o nome do usuario
// usrname - retorna o nome do usuario conectado a rede
int getusername(char* usrname);

// getcomputername(): funcao que obtem o nome do computador
// cpuname - retorna o nome do usuario conectado a rede
int getcomputername(char* cpuname);


/* declaracao da funcao de inicializacao
*/
int init_aci_net();

#endif
