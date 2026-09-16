
;;
;; K02C0.lsp
;; Copyright (C) 1999 by Luiz Marcio F A Viana, 3/15/99
;;

;; updcarimbo(): funcao que atualiza as informacoes no carimbo
;; ins - opcao de instalacao selecionada (EL, ES, H, G, TE, TI, IE, INC, AR ou EX)
;; enm - ename do carimbo que sera atualizado
(defun updcarimbo(ins enm / CFG_PROJETO CFG_CARIMBO $COMMA $SCALE
  cfprj cfcar it att dat s v enm)

  (setq
    CFG_PROJETO (strcat (getprjdir) "\\" (getprjname) ".prj")
    CFG_CARIMBO (v:ai "carimbo.dat")
  ) ; end setq

  (setq
    $COMMA ", "
    $SCALE (strcat "1/" (rtos #ESCL 2 0))
  ) ; end setq

  (if (and (setq cfprj (cdr (readcfgfile CFG_PROJETO)))
           (setq cfcar (cdr (readcfgfile CFG_CARIMBO))) )
    (progn
      (foreach it cfprj
        (set (car it) (cadr it)) ) 

      (foreach it (cdr (assoc ins cfcar))
        (progn
          (setq
            att (car it)
            dat (cdr it)
          ) ; end setq  
          (setq s "")
          (foreach v dat
            (setq s (strcat s (eval v))) )
          (attvalue enm att s)
        ) ; end progn
      ) ; end foreach

      (foreach it cfprj
        (set (car it) nil) )
    ) ; end progn
    (prompt "\nERR: Nao foi possivel abrir o arquivo de dados.")
  ) ; end if
) ; end defun

;; c:carimbo(): funcao que insere um carimbo no desenho
(defun c:carimbo(/ FORM oldech oldlay px py opc resp blk lay ss)
  (setq oldech (acadvar "cmdecho" 0))

  (setq
    FORM '( ("EL"  "EL/EL00C04"   "EL-TEXTOS")
            ("ES"  "ES/ES00C04"   "ES-TEXTOS")
            ("H"   "H/H00C04"     "H-TEXTOS")
            ("INC" "INC/INC00C04" "INC-TEXTOS")
            ("G"   "G/G00C04"     "G-TEXTOS")
            ("TE"  "TE/TE00C04"   "TE-TEXTOS")
            ("TI"  "TI/TI00C04"   "TI-TEXTOS")
            ("IE"  "IE/IE00C04"   "IE-TEXTOS")
            ("AR"  "AR/AR00C04"   "AR-TEXTOS")
            ("PC"  "PC/PC00C04"   "PC-TEXTOS")
            ("EX"  "EX/EX00C04"   "EX-TEXTOS") )
  ) ; end setq

  (initget 1 "EL PC ES IE TE TI AR G H INC EX")
  (setq opc (getkword "\nCarimbo (EL,PC,ES,H,INC,G,TE,TI,IE,AR ou EX): "))

  (initget "Yes No")
  (setq resp (getkword "\nCarimbo para anteprojeto <Yes>? "))

  (setq
    blk (cadr  (assoc opc FORM))
    lay (caddr (assoc opc FORM))
    px (car (getvar "limmax"))
    py (cadr (getvar "limmin"))
  ) ; end setq

  (setq oldlay (slay lay))

  (command
    ".insert" (v:aid "SET/SET20C00") (list px py) #SCL "" 0
    ".insert" (v:aid blk) (list px py) #SCL "" 0
  ) ; end setq

  (setq ss (entlast))

  (if (/= resp "No")
    (command
      ".insert"
        (v:aid "SET/SET30C00")
        (list (- px (*  97.5 #SCL)) (+ py (* 153.5 #SCL)) )
        #SCL
        ""
        60
    ) ; end command
  ) ; end if

  (slay oldlay)

  (updcarimbo opc ss)
  (command ".ddatte" ss)

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
