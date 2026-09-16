
#include<stdio.h>

#define ARQVREFL "IL_REFL.DAT"
#define ARQVDIST "IL_DIST.DAT"

#define ARQVPRJ   "PRJTRS"
#define ARQVIXPRJ "IXPRJTRS"
#define ARQVIYPRJ "IYPRJTRS"

typedef char str_t [256]

typedef struct {
  long Codigo;
  char Fabricante [16];
  char Modelo     [16];
  char Lampadas   [41];
} t_refl;

typedef struct {
  long Codigo;
  float CD_Angulo;
  float CD_Iluminancia;
  float CD_Angulo;
  float CD_Iluminancia;
} t_dist;

int LeRefletor(long cod, t_refl* crefl, t_disp* cdisp);

main()
{
  FILE *fp_refl, *fp_disp;

  t_refl CRefl;
  t_dist CDist;

  long n;

  if( ((fp_refl = fopen(ARQVREFL, "wb")) == NULL) ||
      ((fp_dist = fopen(ARQVDIST, "wb")) == NULL) ) {
    printf("\nERR: Nao foi possivel abrir os arquivos de saida.");
    exit(1);
  }

  n = 0;
  while( LeRefletor(n, &CRefl, &CDist) > 0 ) {
    fwrite(&CRefl, sizeof(t_refl), 1, fp_refl);
    fwrite(&CDist, sizeof(t_dist), 1, fp_dist);
    n += 1;
  }

  fcloseall();
}

int LeRefletor(long cod, t_refl* crefl, t_disp* cdisp)
{
  FILE *fp_prj, *fp_ixprj, *fp_iyprj;
  str_t sbuf;

  if( ((fp_prj = fopen(ARQVPRJ, "r") == NULL) ||
      ((fp_ixprj = fopen(ARQVIXPRJ, "r") == NULL) ||
      ((fp_iyprj = fopen(ARQVIYPRJ, "r") == NULL) ) {
    printf("\nERR: Nao foi possivel abrir o arquivo de saida.");
    exit(1);
  }


}
