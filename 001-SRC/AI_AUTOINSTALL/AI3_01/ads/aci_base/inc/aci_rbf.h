
/*
/* aci_rbf.h
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/22/99
*/

#ifndef __ACI_RBF_H
#define __ACI_RBF_H

/* definicao do descritor de listas simples de buffer de resultado
*/
typedef struct {
	struct resbuf* fstitem;
	struct resbuf* lstitem;
	int numitem;
} rbufdesc_t;

/* definicao do elemento da lista dupla de buffer de resultado
*/
struct resbufdb {
	struct resbufdb* rbprev;
	short restype;
	union ads_u_val resval;
	struct resbufdb* rbnext;
};

/* definicao do descritor de listas duplas de buffer de resultado
*/
typedef struct {
	struct resbufdb* fstitem;
	struct resbufdb* lstitem;
	int numitem;
} rbufdbdesc_t;

/* declaracao das funcoes para manipulacao de listas de buffers de resultado
*/

// rbinit(): funcao de inicializacao do descritor da lista
// desclst - descritor da lista
////// operacao sobre lista de encadeamento simples
void rbinit(rbufdesc_t* desclst);
////// operacao sobre lista de encadeamento duplo
void rbinit(rbufdbdesc_t* desclst);

// rbnewitem(): funcao de adicao de um novo elemento a lista
// desclst - descritor da lista
// restype - tipo de dado armazenado (RTNONE, RTREAL, RTPOINT, ...)
// resval - valor do dado a ser armazenado (opcional)
////// operacao sobre lista de encadeamento simples
struct resbuf* rbnewitem(rbufdesc_t* desclist, int restype);
struct resbuf* rbnewitem(rbufdesc_t* desclist, int restype, ads_real resval);
struct resbuf* rbnewitem(rbufdesc_t* desclist, int restype, ads_real* resval);
struct resbuf* rbnewitem(rbufdesc_t* desclist, int restype, short resval);
struct resbuf* rbnewitem(rbufdesc_t* desclist, int restype, char* resval);
struct resbuf* rbnewitem(rbufdesc_t* desclist, int restype, long* resval);
struct resbuf* rbnewitem(rbufdesc_t* desclist, int restype, long resval);
struct resbuf* rbnewitem(rbufdesc_t* desclist, int restype, struct ads_binary* resval);
////// operacao sobre lista de encadeamento duplo
struct resbufdb* rbnewitem(rbufdbdesc_t* desclist, int restype);
struct resbufdb* rbnewitem(rbufdbdesc_t* desclist, int restype, ads_real resval);
struct resbufdb* rbnewitem(rbufdbdesc_t* desclist, int restype, ads_real* resval);
struct resbufdb* rbnewitem(rbufdbdesc_t* desclist, int restype, short resval);
struct resbufdb* rbnewitem(rbufdbdesc_t* desclist, int restype, char* resval);
struct resbufdb* rbnewitem(rbufdbdesc_t* desclist, int restype, long* resval);
struct resbufdb* rbnewitem(rbufdbdesc_t* desclist, int restype, long resval);
struct resbufdb* rbnewitem(rbufdbdesc_t* desclist, int restype, struct ads_binary* resval);

// rbdelitem(): funcao que elimina um elemento indicado da lista
// itemptr - ponteiro para o item da lista a ser eliminado
////// operacao sobre lista de encadeamento simples
struct resbuf* rbdelitem(rbufdesc_t* desclst, resbuf* itemptr);
////// operacao sobre lista de encadeamento duplo
struct resbufdb* rbdelitem(rbufdbdesc_t* desclst, resbufdb* itemptr);

// rbrelease(): funcao que elimina todos os elementos da lista
// desclst - descritor da lista
////// operacao sobre lista de encadeamento simples
void rbrelease(struct resbuf* fstitem);
void rbrelease(rbufdesc_t* desclst);
////// operacao sobre lista de encadeamento duplo
void rbrelease(struct resbufdb* fstitem);
void rbrelease(rbufdbdesc_t* desclst);

// rbappend(): funcao que concatena duas listas
// desclst1 - descritor da primeira lista (mantido apos concatenacao)
// desclst2 - descritor da segunda lista (inutilizado apos concatenacao)
////// operacao sobre lista de encadeamento simples
int rbappend(rbufdesc_t* desclst1, rbufdesc_t* desclst2);
////// operacao sobre lista de encadeamento duplo
int rbappend(rbufdbdesc_t* desclst1, rbufdbdesc_t* desclst2);

#endif
