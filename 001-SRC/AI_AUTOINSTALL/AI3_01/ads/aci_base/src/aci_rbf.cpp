
/*
/* aci_rbf.cpp
/* Copyright (C) 1999 by Luiz Marcio F A Viana, 2/22/99
*/

#include<string.h>
#include"..\inc\all.h"

/* implementacao das funcoes para manipulacao de listas de buffers de resultado
*/

// rbinit(): funcao de inicializacao do descritor da lista
// desclst - descritor da lista
////// operacao sobre lista de encadeamento simples
void rbinit(rbufdesc_t* desclst)
{
	desclst->fstitem = NULL;
	desclst->lstitem = NULL;
	desclst->numitem = 0;
}
////// operacao sobre lista de encadeamento duplo
void rbinit(rbufdbdesc_t* desclst)
{
	desclst->fstitem = NULL;
	desclst->lstitem = NULL;
	desclst->numitem = 0;
}

// rbnewitem(): funcao de adicao de um novo elemento a lista
// desclst - descritor da lista
// restype - tipo de dado armazenado (RTNONE, RTREAL, RTPOINT, ...)
// resval - valor do dado a ser armazenado (opcional)
////// operacao sobre lista de encadeamento simples
struct resbuf* rbnewitem(rbufdesc_t* desclst, int restype)
{
	struct resbuf* p;

	if((p = (struct resbuf*) malloc(sizeof(struct resbuf))) == NULL)
		return NULL;

	p->rbnext = NULL;
	p->restype = restype;
	if(desclst->fstitem == NULL) desclst->fstitem = p;
	if(desclst->lstitem != NULL) (desclst->lstitem)->rbnext = p;
	desclst->lstitem = p;

	desclst->numitem += 1;
	return p;
}

struct resbuf* rbnewitem(rbufdesc_t* desclst, int restype, ads_real resval)
{
	struct resbuf* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	(p->resval).rreal = resval;
	return p;
}

struct resbuf* rbnewitem(rbufdesc_t* desclst, int restype, ads_real* resval)
{
	struct resbuf* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	(p->resval).rpoint[X] = resval[X];
	(p->resval).rpoint[Y] = resval[Y];
	(p->resval).rpoint[Z] = resval[Z];
	return p;
}

struct resbuf* rbnewitem(rbufdesc_t* desclst, int restype, short resval)
{
	struct resbuf* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	(p->resval).rint = resval;
	return p;
}

struct resbuf* rbnewitem(rbufdesc_t* desclst, int restype, char* resval)
{
	struct resbuf* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	if(((p->resval).rstring = (char*) malloc(strlen(resval) + 1)) == NULL) {
		rbdelitem(desclst, p);
		return NULL;
	}
	strcpy((p->resval).rstring, resval);
	return p;
}

struct resbuf* rbnewitem(rbufdesc_t* desclst, int restype, long* resval)
{
	struct resbuf* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	(p->resval).rlname[0] = resval[0];
	(p->resval).rlname[1] = resval[1];
	return p;
}

struct resbuf* rbnewitem(rbufdesc_t* desclst, int restype, long resval)
{
	struct resbuf* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	(p->resval).rlong = resval;
	return p;
}

struct resbuf* rbnewitem(rbufdesc_t* desclst, int restype, struct ads_binary* resval)
{
	struct resbuf* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	((p->resval).rbinary).clen = resval->clen;
	((p->resval).rbinary).buf = resval->buf;
	return p;
}

////// operacao sobre lista de encadeamento duplo
struct resbufdb* rbnewitem(rbufdbdesc_t* desclst, int restype)
{
	struct resbufdb* p;

	if((p = (struct resbufdb*) malloc(sizeof(struct resbufdb))) == NULL)
		return NULL;

	p->restype = restype;

	p->rbprev = desclst->lstitem;
	p->rbnext = NULL;
	if(desclst->fstitem == NULL) desclst->fstitem = p;
	if(desclst->lstitem != NULL) (desclst->lstitem)->rbnext = p;
	desclst->lstitem = p;

	desclst->numitem += 1;
	return p;
}

struct resbufdb* rbnewitem(rbufdbdesc_t* desclst, int restype, ads_real resval)
{
	struct resbufdb* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	(p->resval).rreal = resval;
	return p;
}

struct resbufdb* rbnewitem(rbufdbdesc_t* desclst, int restype, ads_real* resval)
{
	struct resbufdb* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	(p->resval).rpoint[X] = resval[X];
	(p->resval).rpoint[Y] = resval[Y];
	(p->resval).rpoint[Z] = resval[Z];
	return p;
}

struct resbufdb* rbnewitem(rbufdbdesc_t* desclst, int restype, short resval)
{
	struct resbufdb* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	(p->resval).rint = resval;
	return p;
}

struct resbufdb* rbnewitem(rbufdbdesc_t* desclst, int restype, char* resval)
{
	struct resbufdb* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	if(((p->resval).rstring = (char*) malloc(strlen(resval) + 1)) == NULL) {
		// rbdelitem(desclist, p);
		return NULL;
	}
	strcpy((p->resval).rstring, resval);
	return p;
}

struct resbufdb* rbnewitem(rbufdbdesc_t* desclst, int restype, long* resval)
{
	struct resbufdb* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	(p->resval).rlname[0] = resval[0];
	(p->resval).rlname[1] = resval[1];
	return p;
}

struct resbufdb* rbnewitem(rbufdbdesc_t* desclst, int restype, long resval)
{
	struct resbufdb* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	(p->resval).rlong = resval;
	return p;
}

struct resbufdb* rbnewitem(rbufdbdesc_t* desclst, int restype, struct ads_binary* resval)
{
	struct resbufdb* p;
	if((p = rbnewitem(desclst, restype)) == NULL)
		return NULL;
	((p->resval).rbinary).clen = resval->clen;
	((p->resval).rbinary).buf = resval->buf;
	return p;
}

// rbdelitem(): funcao que elimina um elemento indicado da lista
// itemptr - ponteiro para o item da lista a ser eliminado
////// operacao sobre lista de encadeamento simples
struct resbuf* rbdelitem(rbufdesc_t* desclst, resbuf* itemptr)
{
	struct resbuf* p;

	if((p = desclst->fstitem) != itemptr)
		while((p != NULL) && (p->rbnext != itemptr));

	if(p != NULL)
		p->rbnext = itemptr->rbnext;
	else
		desclst->fstitem = itemptr->rbnext;
	if(itemptr->rbnext == NULL)
		desclst->lstitem = p;

	if((itemptr->restype == RTSTR) && ((itemptr->resval).rstring != NULL))
		free((itemptr->resval).rstring);

	p = itemptr->rbnext;
	free(itemptr);

	return p;
}
////// operacao sobre lista de encadeamento duplo
struct resbufdb* rbdelitem(rbufdbdesc_t* desclst, resbufdb* itemptr)
{
	struct resbufdb* p;

	if(itemptr->rbprev != NULL)
		(itemptr->rbprev)->rbnext = itemptr->rbnext;
	else
		desclst->fstitem = itemptr->rbnext;

	if(itemptr->rbnext != NULL)
		(itemptr->rbnext)->rbprev = itemptr->rbprev;
	else
		desclst->lstitem = itemptr->rbprev;

	if((itemptr->restype == RTSTR) && ((itemptr->resval).rstring != NULL))
		free((itemptr->resval).rstring);

	p = itemptr->rbnext;
	free(itemptr);

	return p;
}

// rbrelease(): funcao que elimina todos os elementos da lista
// desclst - descritor da lista
////// operacao sobre lista de encadeamento simples
void rbrelease(struct resbuf* fstitem)
{
	struct resbuf *p, *q;
	p = fstitem;
	while((q = p) != NULL) {
		if((q->restype == RTSTR) && ((q->resval).rstring != NULL))
			free((q->resval).rstring);
		p = q->rbnext;
		free(q);
	}
}

void rbrelease(rbufdesc_t* desclst)
{
	rbrelease(desclst->fstitem);
	rbinit(desclst);
}

////// operacao sobre lista de encadeamento duplo
void rbrelease(struct resbufdb* fstitem)
{
	struct resbufdb *p, *q;
	p = fstitem;
	while((q = p) != NULL) {
		if((q->restype == RTSTR) && ((q->resval).rstring != NULL))
			free((q->resval).rstring);
		if(q->rbprev != NULL) (q->rbprev)->rbnext = q->rbnext;
		if(q->rbnext != NULL) (q->rbnext)->rbprev = q->rbprev;
		p = q->rbnext;
		free(q);
	}
}

void rbrelease(rbufdbdesc_t* desclst)
{
	rbrelease(desclst->fstitem);
	rbinit(desclst);
}

// rbappend(): funcao que concatena duas listas
// desclst1 - descritor da primeira lista (mantido apos concatenacao)
// desclst2 - descritor da segunda lista (inutilizado apos concatenacao)
////// operacao sobre lista de encadeamento simples
int rbappend(rbufdesc_t* desclst1, rbufdesc_t* desclst2)
{
	if(desclst1->fstitem == NULL) desclst1->fstitem = desclst2->fstitem;
	if(desclst1->lstitem != NULL) (desclst1->lstitem)->rbnext = desclst2->fstitem;
	desclst1->lstitem = desclst2->lstitem;
	return (desclst1->numitem += desclst2->numitem);
}
////// operacao sobre lista de encadeamento duplo
int rbappend(rbufdbdesc_t* desclst1, rbufdbdesc_t* desclst2)
{
	if(desclst1->fstitem == NULL) desclst1->fstitem = desclst2->fstitem;
	if(desclst1->lstitem != NULL) (desclst1->lstitem)->rbnext = desclst2->fstitem;
	if(desclst2->fstitem != NULL) (desclst2->fstitem)->rbprev = desclst1->lstitem;
	desclst1->lstitem = desclst2->lstitem;
	return (desclst1->numitem += desclst2->numitem);
}
