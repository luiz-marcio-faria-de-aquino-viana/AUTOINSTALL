
/*
/* aci_def.h
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/11/99
*/

#ifndef __ACI_DEF_H
#define __ACI_DEF_H

#define STRSZ 256				// tamanho maximo de uma cadeia

#define K_NUL	0x00			// codigos de controle ascii
#define K_TAB	0x09
#define	K_LF	0x0A
#define K_FF	0x12
#define K_CR	0x13
#define K_SPC	0x20

#define BUFFSZ 128

#define ELEMENTS(array) (sizeof(array) / sizeof((array)[0]))

#define REFLFILE "C:\\ACADAPPL\\AI7_2017\\LUMENS\\PRJTRS"

/* definicao do tipo de dados cadeia
*/
typedef TCHAR str_t [STRSZ];

/* definicao do tipo de dados longlong
*/
typedef long longlong [2];

/* definicao da estrutura da tabela de funcoes ADS externas
*/
typedef struct {
	TCHAR*	name;
	int		(*ptr)();
} extftbl_t;

/* definicao da estrutura da lista de tabelas de funcoes ADS externas
*/
typedef struct ftbllist {
	extftbl_t* functbl;
	int nfunc;				// total de funcoes externas definidas na tabela
	struct ftbllist* next;
} ftbllist_t;

typedef struct {
	ftbllist_t* fsttbl;
	ftbllist_t* lsttbl;
	int nfunc;				// total de funcoes externas definidas no geral
} ftbldesc_t;

/* definicao da tabelas de funcoes ADS externas
*/
static ftbldesc_t tbllist = { NULL, NULL, 0 };

/* declaracao das funcoes para manipulacao da tabela de funcoes externas
*/

// addftbl(): funcao que adiciona uma nova tabela de funcoes externas a lista
// functbl - tabela das funcoes ADS externas que serao definidas
// nfunc - numero de funcoes ADS externas que serao definidas
int addftbl(extftbl_t* functbl, int nfunc);

// remftbl(): funcao que remove todas as tabelas de funcoes externas da lista
int remftbl();

/* declaracao das funcoes para manipulacao de argumentos
*/

// getnumargs(): funcao que retorna o numero de argumentos passados a funcao externa
// args - lista de argumentos passados a funcao externa
int getnumargs(resbuf* args);

// getargs(): funcao que retorna o n-esimo argumento passado a uma funcao externa
// args - lista de argumentos passados a funcao externa
// pos - posicao do elemento na lista de argumentos
// typ - tipo experado para o argumento
// ptr - endereco da variavel de retorno do argumento
int getargs(resbuf* args, int pos, short typ, void* ptr);

/* declaracao das funcoes de controle das funcoes ADS externas
*/

// funcload(): funcao de definicao das funcoes ADS externas
// functbl - tabela das funcoes ADS externas que serao definidas
// nfunc - numero de funcoes ADS externas que serao definidas
int funcload(extftbl_t* functbl, int nfunc);

// funcunload(): funcao de eliminacao da definicao das funcoes ADS externas
int funcunload();

// dofun(): funcao de lancamento das funcoes ADS externas
int dofun();

#endif
