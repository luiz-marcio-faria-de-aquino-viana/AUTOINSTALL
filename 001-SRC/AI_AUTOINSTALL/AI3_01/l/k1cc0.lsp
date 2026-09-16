
;;
;; K1CC0.lsp
;; Copyright (C) 1992-98 by Luiz Marcio F A Viana, 3/23/98
;;

(defun setlayer(prf / oldecho oldlay NNIVEL lay)

  (setq
    NNIVEL '( ("ARQ" ("arq-arquitetura"
                      "arq-textos"
                      "arq-projecao"
                      "arq-banheiro")
              )
              ("F"   ("f-pl_teto"
                      "f-vg_teto"
                      "f-vg_piso"
                      "f-furacao"
                      "f-textos"
                      "f-pl_piso")
              )
              ("EL"  ("el-prumadas"
                      "el-dt_teto"
                      "el-dt_piso"
                      "el-dt_aparente"
                      "el-pontos"
                      "el-furacao"
                      "el-vigas"
                      "el-textos"
                      "el-detalhe"
                      "el-setas"
                      "el-circuitos"
                      "el-qd_carga"
                      "el-diagramas"
                      "el-carimbo")
              )
              ("ES"  ("es-colunas"
                      "es-primario"
                      "es-secundario"
                      "es-ventilacao"
                      "es-apluvial"
                      "es-bujao"
                      "es-pontos"
                      "es-furacao"
                      "es-vigas"
                      "es-textos"
                      "es-detalhe"
                      "es-setas"
                      "es-conexao"
                      "es-carimbo")
              )
              ("H"   ("h-colunas"
                      "h-tb_afria"
                      "h-tb_aquente"
                      "h-tb_incendio"
                      "h-pontos"
                      "h-furacao"
                      "h-vigas"
                      "h-Textos"
                      "h-detalhe"
                      "h-setas"
                      "h-conexao"
                      "h-carimbo")
              )
              ("G"   ("g-prumadas"
                      "g-tb_teto"
                      "g-tb_piso"
                      "g-pontos"
                      "g-furacao"
                      "g-vigas"
                      "g-textos"
                      "g-detalhe"
                      "g-setas"
                      "g-tubulacao"
                      "g-esquemas"
                      "g-conexao"
                      "g-carimbo")
              )
              ("TE"  ("te-prumadas"
                      "te-tb_teto"
                      "te-tb_piso"
                      "te-pontos"
                      "te-furacao"
                      "te-vigas"
                      "te-textos"
                      "te-detalhe"
                      "te-setas"
                      "te-carimbo")
              )
              ("TI"  ("ti-prumadas"
                      "ti-tb_teto"
                      "ti-tb_piso"
                      "ti-pontos"
                      "ti-furacao"
                      "ti-vigas"
                      "ti-textos"
                      "ti-detalhe"
                      "ti-setas"
                      "ti-carimbo")
              )
              ("IE"  ("ie-prumadas"
                      "ie-tvfm"
                      "ie-som"
                      "ie-circ_tv"
                      "ie-pararaio"
                      "ie-pontos"
                      "ie-furacao"
                      "ie-vigas"
                      "ie-textos"
                      "ie-detalhe"
                      "ie-dt_continuous"
                      "ie-dt_tr-pt"
                      "ie-dt_tr-2pt"
                      "ie-dt_2tr-pt"
                      "ie-dt_3tr"
                      "ie-setas")
              )
              ("AR"  ("ar-colunas"
                      "ar-agelada"
                      "ar-dutos"
                      "ar-pontos"
                      "ar-furacao"
                      "ar-vigas"
                      "ar-textos"
                      "ar-detalhe")
              )
            )
  ) ; end setq

  (setq oldecho (acadvar "cmdecho" 0))
  (command ".undo" "g")

  (setq oldlay (slay "0"))

  (foreach lay (cadr (assoc (strcase prf) NNIVEL))
    (if (setq ent (tblsearch "layer" lay))
      (if (= (logand (cdr (assoc 70 ent)) 1) 1)
        (command ".layer" "t" lay "")
        (command ".layer" "f" lay "")
      ) ; end if
    ) ; end if
  ) ; end foreach

  (slay oldlay)

  (command ".undo" "e")
  (setvar "cmdecho" oldecho)

  (princ)
) ; end defun

(princ)
