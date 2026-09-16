
/*
/* K1BC0.dcl
/* Copyright (C) 1997 by Luiz Marcio F A Viana, 12/29/97
*/

ddsetup : dialog {
  label = "Configuracao do Desenho" ;
  : column {
    : boxed_row {
      : column {
        : edit_box {
          key = "IDC_ESCALA" ;
          label = "Escala:" ;
          edit_width = 10 ;
        }
        : list_box {
          key = "IDC_LISTA_ESCALAS" ;
        }
      }
      : column {
        : list_box {
          key = "IDC_PADRAO" ;
          label = "Padrao:" ;
          height = 7 ;
        }
        spacer_1;
        : toggle {
          key = "IDC_OUTRO" ;
          label = "Outro" ;
        }
        : boxed_column {
          : edit_box {
            key = "IDC_LARGURA" ;
            label = "Largura:" ;
            alignment = centered ;
            fixed_width = true ;
            edit_width = 10 ;
          }
          : edit_box {
            key = "IDC_ALTURA" ;
            label = "Altura:   " ;
            alignment = centered ;
            fixed_width = true ;
            edit_width = 10 ;
          }
          spacer_1;
        }
        spacer_1;
      }
    }
    : boxed_radio_row {
      key = "IDC_UNIDADE" ;
      label = "Unidade:" ;
      width = 60 ;
      spacer_1 ;
      : radio_button {
        key = "IDC_METRO" ;
        label = "m" ;
      }
      : radio_button {
        key = "IDC_CENTIMETRO" ;
        label = "cm" ;
      }
      : radio_button {
        key = "IDC_MILIMETRO" ;
        label = "mm" ;
      }
    }
  }
  ok_cancel;
  errtile;
}
