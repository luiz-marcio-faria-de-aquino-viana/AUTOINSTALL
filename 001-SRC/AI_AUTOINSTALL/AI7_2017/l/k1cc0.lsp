
;;
;; K1CC0.lsp
;; Copyright (C) 1992-98 by Luiz Marcio F A Viana, 3/23/98
;;

(defun setlayer(prf / oldecho oldlay NNIVEL lay)

  (setq
    NNIVEL '( ("ARQ" (  "ARQ-ALVENARIA"
						"ARQ-ALVENARIA_VISTA"
						"ARQ-ARQUITETURA"
						"ARQ-INDICACAO_AGUA"
						"ARQ-INDICACAO_GRAMA"
						"ARQ-MOBILIARIO"
						"ARQ-PECAS_FIXAS"
						"ARQ-PILAR_ESTRUTURAL"
						"ARQ-PONTOS"
						"ARQ-TEXTOS")
              )
              ("F"   (  "F-FURACAO"
						"F-PL_TETO"
						"F-PL_PISO"
						"F-TEXTOS"
						"F-VG_PISO"
						"F-VG_TETO")
			  )
              ("EE"  (  "EE-FURACAO"
						"EE-DET-C1"
						"EE-DET-C3"
						"EE-DET-C4"
						"EE-DET-C5"
						"EE-DET-P1"
						"EE-DET-P2"
						"EE-DET-P3"
						"EE-DET-P5"
						"EE-DT_APARENTE"
						"EE-DT_PISO"
						"EE-DT_TETO"
						"EE-ELETROC-BT"
						"EE-ELETROC-BT_F"
						"EE-ELETROC-BUS1"
						"EE-ELETROC-BUS2"
						"EE-ELETROC-MT"
						"EE-FURACAO"
						"EE-PONTOS"
						"EE-PRUMADAS"
						"EE-TEXTOS")
			  )
              ("EL"  (  "EL-CIRCUITOS"
						"EL-DETALHE"
						"EL-DET-C1"
						"EL-DET-C3"
						"EL-DET-C4"
						"EL-DET-C5"
						"EL-DET-P1"
						"EL-DET-P2"
						"EL-DET-P3"
						"EL-DET-P5"
						"EL-DT_APARENTE"
						"EL-DT_C-CRITICAS"
						"EL-DT_PISO"
						"EL-DT_ROTA-FUGA"
						"EL-DT_TETO"
						"EL-ELETROC-BT"
						"EL-ELETROC-BT_F"
						"EL-ELETROC-BUS1"
						"EL-ELETROC-BUS2"
						"EL-ELETROC-MT"
						"EL-FURACAO"
						"EL-PONTOS"
						"EL-PRUMADAS"
						"EL-TEXTOS"
						"EL-VIGAS")
              )
              ("ES"  (  "ES-APLUVIAL"
						"ES-APLUV-RET"
						"ES-APLUV-REUSO"
						"ES-BUJAO"
						"ES-COLUNAS"
						"ES-DETALHE"
						"ES-DET-C1"
						"ES-DET-C3"
						"ES-DET-C4"
						"ES-DET-C5"
						"ES-DET-P1"
						"ES-DET-P2"
						"ES-DET-P3"
						"ES-DET-P5"
						"ES-FURACAO"
						"ES-PONTOS"
						"ES-PRIMARIO"
						"ES-SECUNDARIO"
						"ES-SECUND-GORD"
						"ES-SECUND-MLR"
						"ES-TEXTOS"
						"ES-VENTILACAO"
						"ES-VIGAS")
              )
              ("G"   (  "G-DETALHE"
						"G-DET-C1"
						"G-DET-C3"
						"G-DET-C4"
						"G-DET-C5"
						"G-DET-P1"
						"G-DET-P2"
						"G-DET-P3"
						"G-DET-P5"
						"G-FURACAO"
						"G-PONTOS"
						"G-PRUMADAS"
						"G-TB_PISO-FGALV"
						"G-TB_PISO-PEAD"
						"G-TB_P-MULTICAM"
						"G-TB_TETO-FGALV"
						"G-TB_T-MULTICAM"
						"G-TEXTOS"
						"G-VIGAS")
              )
              ("H"   (  "H-COLUNAS"
						"H-DETALHE"
						"H-DET-C1"
						"H-DET-C3"
						"H-DET-C4"
						"H-DET-C5"
						"H-DET-P1"
						"H-DET-P2"
						"H-DET-P3"
						"H-DET-P5"
						"H-FURACAO"
						"H-PONTOS"
						"H-TB_AFRIA"
						"H-TB_AFRIA-PEX"
						"H-TB_AQUENTE"
						"H-TB_AQUENTE-PEX"
						"H-TB_INCENDIO"
						"H-TB_REUSO"
						"H-TB_TRATADA"
						"H-TEXTOS"
						"H-VIGAS")
              )
              ("INC"  ( "INC-COLUNAS"
						"INC-DETALHE"
						"INC-DET-C1"
						"INC-DET-C3"
						"INC-DET-C4"
						"INC-DET-C5"
						"INC-DET-P1"
						"INC-DET-P2"
						"INC-DET-P3"
						"INC-DET-P5"
						"INC-FURACAO"
						"INC-PONTOS"
						"INC-TB_DRENO"
						"INC-TB_INC"
						"INC-TB_SPK"
						"INC-TEXTOS"
						"INC-VIGAS")
              )
              ("IE"  (  "IE-AUTOMACAO"
						"IE-CIRC_TV"
						"IE-DETALHE"
						"IE-DET-C1"
						"IE-DET-C3"
						"IE-DET-C4"
						"IE-DET-C5"
						"IE-DET-P1"
						"IE-DET-P2"
						"IE-DET-P3"
						"IE-DET-P5"
						"IE-ELETROC-AUTOM"
						"IE-ELETROC-COM-SEG"
						"IE-ELETROC-TEL_TV"
						"IE-FURACAO"
						"IE-PARARAIO_A"
						"IE-PARARAIO_C"
						"IE-PONTOS"
						"IE-PRUMADAS"
						"IE-SEGURANCA"
						"IE-SINAL_TV"
						"IE-SOM"
						"IE-TEXTOS"
						"IE-TVFM"
						"IE-VIGAS")
              )
              ("TE"  (  "TE-DETALHE"
						"TE-DET-C1"
						"TE-DET-C3"
						"TE-DET-C4"
						"TE-DET-C5"
						"TE-DET-P1"
						"TE-DET-P2"
						"TE-DET-P3"
						"TE-DET-P5"
						"TE-FURACAO"
						"TE-PONTOS"
						"TE-PRUMADAS"
						"TE-TB_PISO"
						"TE-TB_TETO"
						"TE-TEXTOS"
						"TE-VIGAS")
              )
              ("TI"  (  "TI-DET-C1"
						"TI-DET-C3"
						"TI-DET-C4"
						"TI-DET-C5"
						"TI-DET-P1"
						"TI-DET-P2"
						"TI-DET-P3"
						"TI-DET-P5"
						"TI-DETALHE"
						"TI-FURACAO"
						"TI-PONTOS"
						"TI-PRUMADAS"
						"TI-TB_PISO"
						"TI-TB_TETO"
						"TI-TEXTOS"
						"TI-VIGAS")
              )
              ("AR"  (  "AR-DET-C1"
						"AR-DET-C3"
						"AR-DET-C4"
						"AR-DET-C5"
						"AR-DET-P1"
						"AR-DET-P2"
						"AR-DET-P3"
						"AR-DET-P5"
						"AR-COLUNAS"
						"AR-PONTOS"
						"AR-TEXTOS"
						"AR-FURACAO"
						"AR-AGELADA"
						"AR-DUTOS"
						"AR-VIGAS"
						"AR-DETALHE")
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
