
;;
;; K02C0.lsp
;; Copyright (C) 1999 by Luiz Marcio F A Viana, 3/15/99
;;

;; updcarimbo(): funcao que atualiza as informacoes no carimbo
;; ins - opcao de instalacao selecionada (EL, ES, H, G, TE, TI, IE, INC, AR ou EX)
;; enm - ename do carimbo que sera atualizado
(defun updcarimbo(ins enm / CFG_PROJETO CFG_CARIMBO $COMMA $SCALE cfprj cfcar it att dat s v enm)

  (if (getprjname)
    (progn
      (setq
        CFG_PROJETO (strcat (getprjdir) (getprjname) ".prj")
        CFG_CARIMBO (v:ai "carimbo.dat")
      ) ; end setq

      (setq
        $COMMA ", "
        $SCALE (strcat "1/" (rtos (#ESCL) 2 0))
      ) ; end setq

      (if (and (setq cfprj (cdr (readcfgfile CFG_PROJETO)))
               (setq cfcar (cdr (readcfgfile CFG_CARIMBO))) )
        (progn
          (foreach it cfprj (set (car it) (cadr it)) ) 

          (foreach it (cdr (assoc ins cfcar))
            (progn
              (setq
                att (car it)
                dat (cdr it)
              ) ; end setq  
              (setq s "")
              (foreach v dat (setq s (strcat s (eval v))) )
              (attvalue enm att s)
            ) ; end progn
          ) ; end foreach

          (foreach it cfprj (set (car it) nil) )
        ) ; end progn
        (prompt "\nERR: Nao foi possivel abrir o arquivo de dados.")
      ) ; end if
    ) ; end progn
    (prompt "\nERR: Arquivo de projeto nao encontrado.")
  ) ; end if
) ; end defun

;; c:carimbo(): funcao que insere um carimbo no desenho
(defun c:carimbo(/ FORM oldmnu oldech oldlay px py opc resp blk lay ss)
  (m:savevars)

  (setq
    BL_REVISAO     "SET/SET20C00"
    BL_ANTEPROJETO "SET/SET30C00"
  ) ; end setq

  (setq
    FORM '( ("F"   "F/F00C06"     "F-TEXTOS")
    	    ("EL"  "EL/EL00C06"   "EL-TEXTOS")
            ("ES"  "ES/ES00C06"   "ES-TEXTOS")
            ("H"   "H/H00C06"     "H-TEXTOS")
            ("INC" "INC/INC00C06" "INC-TEXTOS")
            ("G"   "G/G00C06"     "G-TEXTOS")
            ("TE"  "TE/TE00C06"   "TE-TEXTOS")
            ("TI"  "TI/TI00C06"   "TI-TEXTOS")
            ("IE"  "IE/IE00C06"   "IE-TEXTOS")
            ("AR"  "AR/AR00C06"   "AR-TEXTOS")
            ("PC"  "PC/PC00C06"   "PC-TEXTOS")
	    ("PRE" "PRE/PRE00C06" "PRE-TEXTOS")
            ("EX"  "EX/EX00C06"   "EX-TEXTOS") )
  ) ; end setq

  ;;(setq oldmnu (ai_svar "promptmenu" 1))

  (initget 1 "F EL PC ES IE TE TI AR G H INC EX PRE")
  (setq opc (getkword "\nCarimbo (F,EL,PC,ES,H,INC,G,TE,TI,IE,PRE,AR ou EX): "))

  (initget "Yes No")
  (setq resp (getkword "\nCarimbo para anteprojeto <Yes>? "))

  ;;(setvar "promptmenu" oldmnu)

  (setq
    blk (cadr  (assoc opc FORM))
    lay (caddr (assoc opc FORM))
    px (car (getvar "limmax"))
    py (cadr (getvar "limmin"))
  ) ; end setq

  (setq oldlay (slay lay))

  (if (tblsearch "block" (getfilename BL_REVISAO))
    (command ".insert" (getfilename BL_REVISAO) (list px py) (#SCL) "" 0)
    (command ".insert" (v:aid       BL_REVISAO) (list px py) (#SCL) "" 0)
  ) ; end if

  (if (tblsearch "block" (getfilename blk))
    (command ".insert" (getfilename blk) (list px py) (#SCL) "" 0)
    (command ".insert" (v:aid       blk) (list px py) (#SCL) "" 0)
  ) ; end setq

  (setq ss (entlast))

  (if (/= resp "No")
    (if (tblsearch "block" (getfilename BL_ANTEPROJETO))
      (command ".insert" (getfilename BL_ANTEPROJETO) (list (- px (*  97.5 (#SCL))) (+ py (* 153.5 (#SCL))) ) (#SCL) "" 60)
      (command ".insert" (v:aid       BL_ANTEPROJETO) (list (- px (*  97.5 (#SCL))) (+ py (* 153.5 (#SCL))) ) (#SCL) "" 60)
    ) ; end if
  ) ; end if

  (slay oldlay)

  (updcarimbo opc ss)
  (command ".ddatte" ss)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
