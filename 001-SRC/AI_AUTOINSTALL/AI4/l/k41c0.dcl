
/*
/* K41C0.dcl
/* Copyright (C) 1998 by Luiz Marcio F A Viana, 1/23/98
*/

dfax : dialog {
   label = "DFax" ;
   initial_focus = "IDC_LISTA_CLIENTES" ;
   : row {
      : column {
        : concatenation {
          : text_part {
            label = "Nome do Cliente" ;
            width = 40 ;
          }
          : text_part {
            label = "Telefone" ;
            width = 15 ;
          }
        }
        : list_box {
  	   tabs = "38 55";
           width = 55;
           key = "IDC_LISTA_CLIENTES" ;
           fixed_width = true;
           tab_truncate = true;
        }
      }
      : column {
         spacer_1 ;
         : button {
            key = "IDC_ADICIONAR" ;
            label = "&Adicionar..." ;
         }
         : button {
            key = "IDC_ALTERAR" ;
            label = "A&lterar..." ;
         }
         : button {
            key = "IDC_ELIMINAR" ;
            label = "&Eliminar..." ;
         }
         : button {
            key = "IDC_DISCAR" ;
            label = "&Discar..." ;
         }
         spacer_1 ;
      }
   }
   ok_cancel ;
   errtile ;
}

dfax_cadastro : dialog {
   label = "Ficha de Cadastro" ;
   initial_focus = "IDC_NOME_CLIENTE" ;
   : boxed_column {
      : edit_box {
         key = "IDC_NOME_CLIENTE" ;
         label = "&Nome do cliente:" ;
         fixed_width = true ;
         width = 50 ;
      }
      : edit_box {
         key = "IDC_NUMERO_FAX" ;
         label = "N&umero do fax:" ;
         fixed_width = true ;
         width = 35 ;
      }
      spacer_1 ;
   }
   ok_cancel ;
   errtile ;
}

dfax_confirmacao : dialog {
  label = "Confirmacao de Eliminacao" ;
  initial_focus = "IDC_NAO" ;
  : column {
    : text {
      key = "IDC_MENSAGEM" ;
      alignment = centered ;
      width = 55 ;
    }
    : row {
      alignment = centered;
      fixed_width = true ;
      : button {
        label = "&Sim" ;
        is_default = true ;
        key = "IDC_SIM" ;
        fixed_width = true ;
        width = 15 ;
      }
      : spacer { width = 2; }
      : button {
        label = "&Nao" ;
        is_cancel = true ;
        key = "IDC_NAO" ;
        fixed_width = true ;
      }
    }
  }
}

dfax_discagem : dialog {
   label = "Parametros de Discagem" ;
   initial_focus = "IDC_DESTINATARIO" ;
   : edit_box {
      key = "IDC_DESTINATARIO" ;
      label = "&Destinatario:" ;
   }
   : boxed_column {
      : edit_box {
         key = "IDC_NOME_CLIENTE" ;
         label = "&Nome do cliente:" ;
         fixed_width = true ;
         width = 50 ;
      }
      : edit_box {
         key = "IDC_NUMERO_FAX" ;
         label = "N&umero do fax:" ;
         fixed_width = true ;
         width = 35 ;
      }
      spacer_1 ;
   }
   : column {
      : row {
         : edit_box {
             fixed_width = true ;
             width = 27 ;
             key = "IDC_ESCALA" ;
             label = "Escala de impressao:" ;
         }
         spacer_1 ;
         : boxed_radio_row {
            fixed_width = true ;
            width = 20 ;
            label = "Rotacao:" ;
            : radio_button {
              key = "IDC_0" ;
              label = "0d" ;
            }
            : radio_button {
              key = "IDC_90" ;
              label = "90d" ;
            }
         }
      }
      spacer_1 ;
      : edit_box {
          key = "IDC_NOME_ARQUIVO" ;
          label = "Nome do arquivo:" ;
      }
   }
   spacer_1 ;
   ok_cancel ;
   errtile ;
}
