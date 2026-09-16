
/*
 * aci_net.cpp
 * Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
 */

#include<windows.h>
#include<stdio.h>
#include<string.h>
#include<stdlib.h>    
#include"all.h"


/* implementacao das funcoes ADS externas
*/

int aci_getusername()
{
	str_t usrname;

	wcscpy(usrname, _T(""));
	if(getusername(usrname) == RTERROR) {
		errmsg(ERR_CANTGETUSRNAME, _T(""));
		return RTERROR;
	}
	ads_retstr(usrname);
	return RTNORM;
}

int aci_getcomputername()
{
	str_t cpuname;

	wcscpy(cpuname, _T(""));
	if(getcomputername(cpuname) == RTERROR) {
		errmsg(ERR_CANTGETCPUNAME, _T(""));
		return RTERROR;
	}
	ads_retstr(cpuname);
	return RTNORM;
}


/* implementacao das funcoes internas da aplicacao
*/

// getusername(): funcao que obtem o nome do usuario
// usrname - retorna o nome do usuario conectado a rede
int getusername(TCHAR* usrname)
{
	unsigned long sz = STRSZ;
	return( GetUserName(usrname, & sz) ? RTNORM : RTERROR);
}

// getcomputername(): funcao que obtem o nome do computador
// cpuname - retorna o nome do usuario conectado a rede
int getcomputername(TCHAR* cpuname)
{
	unsigned long sz = STRSZ;
	return( GetComputerName(cpuname, & sz) ? RTNORM : RTERROR);
}


/* implementacao da funcao de inicializacao
*/
int init_aci_net()
{
	return (funcload(net_functbl, ELEMENTS(net_functbl)));
}
