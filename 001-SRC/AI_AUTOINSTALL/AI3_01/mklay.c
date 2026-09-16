
#include<stdio.h>
#include<string.h>

#define RSLT_OK  0
#define RSLT_ERR 1

typedef char str_t [256];

char *Piece(char *s, int in, int fn);

main(int argc, char *argv[])
{
  FILE *src_ptr;
  FILE *dst_ptr;

  str_t src_file, dst_file;
  str_t s1, s2;

  int rst = RSLT_ERR;

  printf("                þþþ MkLay v1.0 þþþ\n");
  printf("Copyright (C) 1995 by Luiz Marcio F A Viana, 3/15/95.\n\n");

  if(argc)
  {
    strcat(strcpy(src_file, argv[1]), ".PRN");
    strcat(strcpy(dst_file, argv[1]), ".SCR");
    if((src_ptr = fopen(src_file, "r")) != NULL)
    {
      if((dst_ptr = fopen(dst_file, "w")) != NULL)
      {
	if((fgets(s1, sizeof(str_t), src_ptr) != NULL) && (fgets(s1, sizeof(str_t), src_ptr) != NULL))
	{
	  printf("Processing... ");
	  fprintf(dst_ptr, "LAYER\n");
	  while(fgets(s1, sizeof(str_t), src_ptr) != NULL)
	  {
	    strcpy(s2, s1);
	    fprintf(dst_ptr, "M %s\n", Piece(s1, 0, 15));
	    strcpy(s1, s2);
	    fprintf(dst_ptr, "LT %s", Piece(s1, 16, 31));
	    fprintf(dst_ptr, "  C %s\n", Piece(s2, 32, 47));
	    printf(".");
	  }
	  fprintf(dst_ptr, "S 0\n");
	  fprintf(dst_ptr, "\n");
	  fcloseall();
	  rst = RSLT_OK;
	}
	else
	{
	  printf("ERR: Invalid file format.\n");
	}
      }
      else
      {
	printf("ERR: Can't open destination file.\n");
      }
    }
    else
    {
      printf("ERR: Can't open source file.\n");
    }
  }
  else
  {
    printf("ERR: Invalid number of parameters.\n");
  }
  return(rst);
}

char *Piece(char *s, int in, int fn)
{
  int i;

  for(i = in; i <= fn; i++)
  {
    if((s[i] == ' ') || (s[i] == '\0'))
    {
      s[i] = '\0';
      break;
    }
  }

  return(&s[in]);
}
