IFIND : dialog {
       label = "Procurar e Substituir";
    : row {
        : row {
            : column {
                : edit_box {
                    label = "Procurar:";
                    key = "find";
                    mnemonic = "P";
                    edit_width = 30;
                }
                : edit_box {
                    label = "Substituir por:";
                    key = "replace";
                    mnemonic = "S";
                    edit_width = 30;
                }
                spacer_1;
                : boxed_column {
                    : toggle {
                        label = "Diferenciar Maiusculas/Minusculas";
                        key = "opt1";
                        mnemonic = "D";
                        alignment = left;
                    }
                    : toggle {
                        label = "Somente Palavras Inteiras";
                        key = "opt2";
                        mnemonic = "I";
                        alignment = left;
                    }
                    : toggle {
                        label = "Procurar em [ Text / MText ]";
                        key = "opt3";
                        mnemonic = "M";
                        alignment = right;
                    }

                    : toggle {
                        label = "Procurar em [ Attributes ]";
                        key = "opt4";
                        mnemonic = "M";
                        alignment = right;
                    }
                    spacer;
                    spacer;
                    : toggle {
                        label = "Substituir Apenas Palavra Procurada";
                        key = "opt5";
                        mnemonic = "M";
                        alignment = right;
                    }
                }
            }
            : row {
                : boxed_row {
                    label            = "Textos Encontrados: ";
                    : list_box {
                        key              = "TextosEncontrados" ;
                        tabs             = "30 35 40" ;
                        tab_truncate     = true ;
                        height           = 8 ;
                        width            = 25 ;
                        fixed_width_font = true ;
                        color = black;
                    }
                }
            }
        }
    }
    spacer_1 ;

    : row {
               : cancel_button
                {
                        label = "OK";
                        width = 10;
                        key   = "botaoOK";
                        fixed_width = true;
                }
                : button
                {
                        label = "Substituir";
                        width = 10;
                        key   = "botaoSubstituir";
                        fixed_width = true;
                }

                : button
                {
                        label = "Substituir Tudo";
                        width = 10;
                        key   = "botaoST";
                        fixed_width = true;
                }

                : button
                {
                        label = "Zoom";
                        width = 10;
                        key   = "botaoZoom";
                        fixed_width = true;
                }
                : button
                {
                        label = "Localizar";
                        width = 10;
                        key   = "botaoLocal";
                        fixed_width = true;
                }
               spacer;
               spacer;
               spacer;
               spacer;
   }
}
