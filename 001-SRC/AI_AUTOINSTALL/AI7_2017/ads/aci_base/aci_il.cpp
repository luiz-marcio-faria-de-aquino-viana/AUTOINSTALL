
/*
/* aci_il.cpp
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 6/3/99
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

int aci_il_dsprefl()
{
	return il_dsprefl();
}

int aci_il_getrefl()
{
	struct resbuf *args;
	short cdg;

	args = ads_getargs();
	if(getargs(args, 0, RTSHORT, &cdg) != RTNORM)
		return RTERROR;

	return il_getrefl(cdg);
}


/* implementacao das funcoes internas da aplicacao
*/

// il_dsprefl(): funcao que apresenta a lista de refletores cadastrados
int il_dsprefl()
{
	FILE *file_ptr;
	int n = 0;

	char buff [BUFFSZ];

	if((file_ptr = fopen(REFLFILE, "rb")) == NULL) {
		ads_printf(_T("\nERR: Nao foi possivel abrir o arquivo de refletores."));
		return RTERROR;
	}

	ads_printf(_T("\n\nCOD   FABRICANTE        MODELO                     LAMPADA(S)               "));
	ads_printf(_T("\n=== =============== =============== ========================================"));
	while(fread(buff, sizeof(char), BUFFSZ, file_ptr) != 0) {
		buff[15] = buff[31] = buff[72] = '\0';
		ads_printf(_T("\n%3d %15s %15s %40s"), (n += 1), &buff[0], &buff[16], &buff[32]);
		if((n % 20) == 0) {
			ads_printf(_T("\n\nTecle qq tecla para prosseguir."));
			getch();
			ads_printf(_T("\n\nCOD   FABRICANTE        MODELO                     LAMPADA(S)               "));
			ads_printf(_T("\n=== =============== =============== ========================================"));
		}
	}
    fclose(file_ptr);
    ads_retint(n);
	return RTNORM;
}

// il_getrefl(): funcao que retorna o refletor selecionado
// cdg - codigo do refletor
int il_getrefl(short cdg)
{
	FILE *file_ptr;
	char buff[BUFFSZ];

	struct resbuf *resb;

	if((file_ptr = fopen(REFLFILE, "rb")) == NULL) {
		ads_printf(_T("\nERR: Nao foi possivel abrir o arquivo de refletores."));
		return RTERROR;
	}

	while(	(cdg > 0) &&
			(fread(buff, sizeof(char), BUFFSZ, file_ptr) != 0)	)
		cdg -= 1;

	fclose(file_ptr);

	if(cdg == 0) {
		buff[15] = buff[31] = buff[72] = '\0';
		if((resb = ads_buildlist(RTSTR, &buff[0], RTSTR, &buff[16], RTSTR, &buff[32], 0)) != NULL) {
			ads_retlist(resb);
			ads_relrb(resb);
		}
		return RTNORM;
	}
	return RTERROR;
}

/* implementacao da funcao de inicializacao
*/
int init_aci_il()
{
	return (funcload(il_functbl, ELEMENTS(il_functbl)));
}
