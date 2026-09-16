
#include<stdio.h>
#include<string.h>
#include<conio.h>
#include<stdlib.h>
#define ACADR12
#include"misc.cc"
#include"24pin.cc"

#define HELPPARM   "-?"
#define SOURCEPARM "-f"
#define TARGETPARM "-o"
#define RANGEPARM  "-r"
#define ACESSPARM  "-pw"

typedef struct {
  str_t source_file;
  str_t target_file;
  int row_range;
  int col_range;
} parm_dat;

void GetParm(int argc, char *argv[], parm_dat *parm);

main(int argc, char *argv[]) {
  FILE *source_handle;
  FILE *target_handle;

  unsigned char *asc_arr[3];
  unsigned char *dot_arr[3];

  parm_dat parm;

  unsigned aux, row;

  int i, j;

  source_handle = NULL;
  target_handle = NULL;

  AllocBuff();
  AllocDotArray();
  AllocArray(asc_arr, dot_arr);

  GetParm(argc, argv, &parm);

  clrscr();
  if(WriteMsg("MSG_02") == FALSE)
    WriteErr("ERR_01");

  ClearArray(DOTARRSIZE, dot_arr);

  target_handle = OpenFile(WR_MODE, parm.target_file);

  Unidirectional(target_handle, ON);
  if((parm.row_range == 0) && (parm.col_range == 0)) {
    row = 0;
    source_handle = OpenFile(RD_MODE, parm.source_file);
    ConvertFile(SINGLE, &row, source_handle, target_handle, asc_arr, dot_arr);
    CloseFile(RD_MODE, source_handle);
  }
  else {
    aux = strlen(parm.source_file);
    for(i = 0; i < parm.row_range; i++) {
      row = 0;
      for(j = 0; j < parm.col_range; j++) {
	parm.source_file[aux] = 'A' + i;
	parm.source_file[aux + 1] = 'A' + j;
	parm.source_file[aux + 2] = NULL;
	source_handle = OpenFile(RD_MODE, parm.source_file);
	if(j != (parm.col_range - 1))
	  ConvertFile(MULT, &row, source_handle, target_handle, asc_arr, dot_arr);
	else
	  ConvertFile(SINGLE, &row, source_handle, target_handle, asc_arr, dot_arr);
      }
      CloseFile(RD_MODE, source_handle);
    }
  }
  InitPrinter(target_handle);
  CloseFile(WR_MODE, target_handle);

  clrscr();
  printf("TCHAU...");

  return 0;
}

void GetParm(int argc, char *argv[], parm_dat *parm) {
  int i;
  str_t s;

  if(argc == 0)
    WriteErr("ERR_02");

  strcpy(parm->source_file, "");
  strcpy(parm->target_file, "");

  parm->row_range = 0;
  parm->col_range = 0;

  for(i = 0; i < argc; i++) {
    strcpy(s, argv[i]);
    if(strnicmp(s, ACESSPARM, strlen(ACESSPARM)) == 0) {
      printf("\nERR: Invalid parameter.");
      exit(0);
    }
    if(strnicmp(s, HELPPARM, strlen(HELPPARM)) == 0) {
      WriteMsg("MSG_01");
      exit(0);
    }
    if(strnicmp(s, SOURCEPARM, strlen(SOURCEPARM)) == 0)
      strupr(strcpy(parm->source_file, s + strlen(SOURCEPARM)));
    if(strnicmp(s, TARGETPARM, strlen(TARGETPARM)) == 0)
      strupr(strcpy(parm->target_file, s + strlen(TARGETPARM)));
    if(strnicmp(s, RANGEPARM, strlen(RANGEPARM)) == 0) {
      strupr(s);
      parm->row_range = s[strlen(RANGEPARM) + 4] - s[strlen(RANGEPARM)] + 1;
      parm->col_range = s[strlen(RANGEPARM) + 5] - s[strlen(RANGEPARM) + 1] + 1;
    }
  }
  if(strlen(parm->source_file) == 0)
    WriteErr("ERR_03");
  if(strlen(parm->target_file) == 0)
    strcpy(parm->target_file, PRN_OUTPUT);
}
