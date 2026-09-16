
/*
/* K85C0.dcl
/* Copyright (C) 1998 by Luiz Marcio F A Viana, 2/12/98
*/

ddgdet : dialog {
   initial_focus = "IDC_LISTA_DETALHES" ;
   label = "Gerenciador de Detalhes" ;
   : boxed_row {
      label = "Definicao da Categoria" ;
      : list_box {
         key = "IDC_CATEGORIA" ;
         label = "&Categoria:" ;
         width = 50 ;
	 height = 6 ;
      }
   }
   : boxed_column {
      label = "Lista de Detalhes" ;
      : row {
         : list_box {
            key = "IDC_LISTA_DETALHES" ;
            fixed_width = true ;
            fixed_height = true ;
            width = 40 ;
            height = 24 ;
         }
         : boxed_row {
            label = "Preview" ;
            : image {
               key = "IDC_IMAGEM_DETALHE" ;
               fixed_width = true ;
               width = 50 ;
               height = 20 ;
            }
         }
      }
   }
   spacer_1 ;
   : row {
      : button {
         key = "IDC_DETALHE_CRIAR" ;
         label = "&Criar..." ;
         fixed_width = true ;
         width = 15 ;
      }
      : button {
         key = "IDC_DETALHE_ALTERAR" ;
         label = "A&lterar..." ;
         fixed_width = true ;
         width = 15 ;
      }
      : button {
         key = "IDC_DETALHE_INSERIR" ;
         label = "&Inserir" ;
         fixed_width = true ;
         width = 15 ;
      }
      : button {
         key = "IDC_DETALHE_SAIR" ;
         label = "&Sair" ;
         fixed_width = true ;
         width = 15 ;
         is_default = true ;
      }
   }
   errtile ;
}
