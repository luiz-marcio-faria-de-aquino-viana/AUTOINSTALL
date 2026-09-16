
;;
;; K3BC0.lsp
;; Copyright (C) 1994-98 by Luiz Marcio F A Viana, 1/22/98
;;

;; definicao das variaveis globais
(or #PRLARG (setq #PRLARG (* 13.6 25.4)) )  ;; largura da folha
(or #PRALT  (setq #PRALT  (* 11.0 25.4)) )  ;; altura da folha
(or #PRROT  (setq #PRROT           "No") )  ;; rotacao do papel
(or #PRSCL  (setq #PRSCL  (* (#SCL) (#UND))) )  ;; escala de impressao

;; c:dprint(): programa de impressao dinamica
(defun c:dprint()
  (setq oldech (acadvar "cmdecho" 0))

  (setq larg (getdist (strcat "\nLargura da folha <" (rtos #PRLARG 2 2) ">: ")) )
  (if larg (setq #PRLARG larg))

  (setq alt (getdist (strcat "\nAltura da folha <" (rtos #PRALT 2 2) ">: ")) )
  (if alt (setq #PRALT alt))

  (initget "Yes No")
  (setq rot (getkword (strcat "\nRodar desenho de 90d <" #PRROT ">: ")) )
  (if rot (setq #PRROT rot))

  (initget 2)
  (setq scl (getdist (strcat "\nEscala para impressao 1/<" (rtos #PRSCL 2 2) ">: ")) )
  (if scl (setq #PRSCL scl))

  (while (> (strlen (setq fname (getstring (strcat "\nNome do arquivo <" (getdwgname) ">: "))) ) 8)
    (prompt "\nERR: Entre no maximo com 8 caracteres") )
  (if (= fname "") (setq fname (getdwgname)) )

  (setq
    pt1 (cadr (grread T))
    fat (/ #PRSCL (#UND))
  ) ; end setq

  (if (= #prrot "Yes")
    (setq
      deltax (/ (* #pralt  fat) 2.0)
      deltay (/ (* #prlarg fat) 2.0)
    ) ; end setq
    (setq
      deltax (/ (* #prlarg fat) 2.0)
      deltay (/ (* #pralt  fat) 2.0)
    ) ; end setq
  ) ; end if

  (setq
    olddrag (acadvar "dragmode"  2)
    oldhigh (acadvar "highlight" 0)
    oldblip (acadvar "blipmode"  0)
  ) ; end setq

  (setq cnivel (slay "$PRINT"))
  (command
    "pline"
      (list (- (car pt1) deltax) (- (cadr pt1) deltay)) "w" 0 ""
      (list (+ (car pt1) deltax) (- (cadr pt1) deltay))
      (list (+ (car pt1) deltax) (+ (cadr pt1) deltay))
      (list (- (car pt1) deltax) (+ (cadr pt1) deltay))
      "c"
    "move" (setq enm1 (entlast)) "" pt1
  ) ; end command
  (redraw enm1 2)

  (prompt "\nSelecione area para impressao...")
  (command pause "erase" enm1 "")

  (setvar "dragmode"  olddrag)
  (setvar "highlight" oldhigh)
  (setvar "blipmode"  oldblip)

  (slay cnivel)

  (setq pt (getvar "lastpoint"))
  (setq
    pta (list (- (car pt) deltax) (- (cadr pt) deltay))
    ptb (list (+ (car pt) deltax) (+ (cadr pt) deltay))
  ) ; end setq

  (setvar "plotid" "print")
  (command
    ".plot"
      "Window"
      (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6))
      (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6))
      "Yes"
      "No"
      "M"
      "0,0"
      (strcat (rtos #PRLARG 2 6) "," (rtos #PRALT 2 6))
  ) ; end command
  (if (= #PRROT "No") (command "0") (command "90"))
  (command
      "No"
      (strcat "1=" (rtos fat 2 6))
  ) ; end command

  (setq fn (V:SPOOL (strcat "PRINT\\" fname)) )
  (if (findfile (strcat fn ".prp"))
    (command fn "Yes")
    (command fn)
  ) ; end if

  (command
    ".shell"
    (strcat
      "dprint "
      fn
    ) ; end strcat
  ) ; end command

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
