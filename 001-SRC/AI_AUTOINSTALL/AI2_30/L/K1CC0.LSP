; SETlayer - JAN/92

; Variaveis:
;   Cnivel - Variavel que contem inf do usuario - Entrada
;   Nnivel - Tabela com nome dos layers         - Interna
;   Snivel - Nome do layer selecionado          - Interna
;   Enivel - Entidade com o layer selecionado   - Interna

(defun SETlayer(cnivel / nnivel snivel enivel)
  (setvar "cmdecho" 0)
  (setq
    nnivel '("ARQ-arquitetura" "ARQ-textos"
             "F-pl_teto" "F-vg_teto" "F-vg_piso" "F-furacao" "F-textos"
             "EL-prumadas" "EL-dt_teto" "EL-dt_piso" "EL-dt_aparente" "EL-pontos" "EL-furacao" "EL-vigas" "EL-textos" "EL-detalhe"
             "ES-colunas" "ES-primario" "ES-secundario" "ES-ventilacao" "ES-apluvial" "ES-bujao" "ES-pontos" "ES-furacao" "ES-vigas" "ES-textos" "ES-detalhe"
             "H-colunas" "H-tb_afria" "H-tb_aquente" "H-tb_incendio" "H-pontos" "H-furacao" "H-vigas" "H-Textos" "H-detalhe"
             "G-prumadas" "G-tb_teto" "G-tb_piso" "G-pontos" "G-furacao" "G-vigas" "G-textos" "G-detalhe"
             "TE-prumadas" "TE-tb_teto" "TE-tb_piso" "TE-pontos" "TE-furacao" "TE-vigas" "TE-textos" "TE-detalhe"
             "TI-prumadas" "TI-tb_teto" "TI-tb_piso" "TI-pontos" "TI-furacao" "TI-vigas" "TI-textos" "TI-detalhe"
             "IE-prumadas" "IE-tvfm" "IE-som" "IE-circ_tv" "IE-pararaio" "IE-pontos" "IE-furacao" "IE-vigas" "IE-textos" "IE-detalhe"
             "AR-colunas" "AR-agelada" "AR-dutos" "AR-pontos" "AR-furacao" "AR-vigas" "AR-textos" "AR-detalhe"

             "ARQ-projecao" "ARQ-banheiro"
             "F-pl_piso"
             "EL-setas" "EL-circuitos" "EL-qd_carga" "EL-diagramas" "EL-carimbo"
             "ES-setas" "ES-conexao" "ES-carimbo"
             "H-setas" "H-conexao" "H-carimbo"
             "G-setas" "G-tubulacao" "G-esquemas" "G-conexao" "G-carimbo"
             "TE-setas" "TE-carimbo"
             "TI-setas" "TI-carimbo"
             "IE-dt_continuous" "IE-dt_tr-pt" "IE-dt_tr-2pt" "IE-dt_2tr-pt" "IE-dt_3tr" "IE-setas")
  );endsetq
  (command "layer" "s" "0")
  (foreach snivel nnivel
    (if (= (substr snivel 1 (strlen cnivel)) cnivel)
      (progn
        (setq enivel (tblsearch "LAYER" (strcase snivel)))
        (if (not (null enivel))
          (if (zerop (rem (cdr (assoc 70 enivel)) 2.0))
            (command "f" snivel)
            (command "t" snivel)
          );endif
        );endif
      );endprogn
    );endif
  );endforeach
  (command "")
  (princ)
);enddefun

(princ)
