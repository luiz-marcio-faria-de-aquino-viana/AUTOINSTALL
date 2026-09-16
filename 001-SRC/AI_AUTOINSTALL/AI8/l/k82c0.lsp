
;;
;; K82C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 1/3/98
;;

;; definicao das variaveis globais utilizadas pela aplicacao
;;  #ESPCP       - variavel global que contem a espesura da parede
;;  #DIST  - distancia interna relativa a terceira face de parede
;;  #DIST1 - distancia interna relativa a primeira face de parede
;;  #DIST2 - distancia interna relativa a segunda face de parede
(or #ESPCP (setq #ESPCP (/  100.0 (#UND))) )
(or #DIST  (setq #DIST  (/ 1000.0 (#UND))) )
(or #DIST1 (setq #DIST1 (/ 1000.0 (#UND))) )
(or #DIST2 (setq #DIST2 (/ 1000.0 (#UND))) )

;; ambiente_esp0(): funcao que apresenta o valor da espesura da parede em uma linha do menu
(defun ambiente_esp0(/ v)
  (setq v (rtos #ESPCP 2 1))
  (if (<= (strlen v) 4)
    (grtext 3 (strcat "[e=" (rfill v 4 " ") "]"))
    (progn
      (grtext 3 (strcat "[e=????]"))
      (prompt (strcat "\nEspesura da parede = " v))
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

;; ambiente_esp(): funcao que permite trocar a espesura da parede
(defun ambiente_esp(/ esp)
  (if (setq esp (getdist (strcat "\nEspesura da parede <" (rtos #ESPCP 2 2) ">: ")))
    (progn
      (setq #ESPCP esp)
      (ambiente_esp0)
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

;; ambiente_1p(): funcao para desenho de ambiente a partir de uma parede
;;  pt   - ponto de referencia para o sentido de copia da parede
;;  enm1 - ename da parede que sera utilizada na motagem do ambiente
;;  d1   - distancia entre as parentes internas do ambiente
;;  esp  - espesura da parede que sera criada
(defun ambiente_1p(pt enm1 d1 esp / ent1 pti ptf ui uj)
  (setq ent1 (entget enm1))
  (setq
    pti (cdr (assoc 10 ent1))
    ptf (cdr (assoc 11 ent1))
  ) ; end setq
  (setq
    ui (vtunit (mapcar '- ptf pti))
    uj (vtnorm ui)
  ) ; end setq
  (if (< (vtprod (mapcar '- pt pti) uj) 0) (setq uj (vtmul -1.0 uj)) )
  (command
    ".line" (mapcar '+ pti (vtmul d1 uj)) (mapcar '+ ptf (vtmul d1 uj)) ""
    ".line" (mapcar '+ pti (vtmul (+ d1 esp) uj)) (mapcar '+ ptf (vtmul (+ d1 esp) uj)) ""
  ) ; end command
) ; end defun

;; ambiente_2p(): funcao para desenho de ambiente composto por duas paredes
;;  pt   - ponto de referencia do interior do compartimento
;;  e1   - ename da primeira parede utilizada na montagem do ambiente
;;  e2   - ename da segunda parede utilizada na montagem do ambiente
;;  d1   - distancia interna do ambiente relativo a primeira parede
;;  d2   - distancia interna do ambiente relativo a segunda parede
;;  esp  - espesura das paredes que serao criadas
(defun ambiente_2p(pt e1 e2 d1 d2 esp / ent1 ent2 pti1 ptf1 u1 pti2 ptf2 u2 pt0 pti1a pti2a
  pti1b pti2b pt0a pt0b oldlay)
  (setq
    ent1 (entget e1)
    ent2 (entget e2)
  ) ; end setq

  (setq
    pti1 (cdr (assoc 10 ent1))
    ptf1 (cdr (assoc 11 ent1))
  ) ; end setq
  (setq u1 (vtunit (mapcar '- ptf1 pti1)))

  (setq
    pti2 (cdr (assoc 10 ent2))
    ptf2 (cdr (assoc 11 ent2))
  ) ; end setq
  (setq u2 (vtunit (mapcar '- ptf2 pti2)))

  (setq pt0 (inters pti1 ptf1 pti2 ptf2 nil))

  (if (< (vtprod (mapcar '- pt pt0) u1) 0)
    (setq u1 (vtmul -1.0 u1)) )

  (if (< (vtprod (mapcar '- pt pt0) u2) 0)
    (setq u2 (vtmul -1.0 u2)) )

  (setq
    pti1a (mapcar '+ pt0 (vtmul d1 u2))
    pti2a (mapcar '+ pt0 (vtmul d2 u1))
  ) ; end setq
  (setq pt0a  (mapcar '+ pt0 (vtmul d1 u2) (vtmul d2 u1)) )

  (setq
    pti1b (mapcar '+ pt0 (vtmul (+ d1 esp) u2))
    pti2b (mapcar '+ pt0 (vtmul (+ d2 esp) u1))
  ) ; end setq
  (setq pt0b (mapcar '+ pt0 (vtmul (+ d1 esp) u2) (vtmul (+ d2 esp) u1)) )

  (setq oldlay (getvar "clayer"))

;; #RCTASK 02/05/2010  k82c.lsp:  (command ".undo" "g") p/ IntelliCAD 2007, foi trocado para    (command ".undo" "m")

  (command ".undo" "m")


  (command ".erase" enm1 enm2 "")

  (slay (cdr (assoc 8 ent1)))
  (if (< (distance pti1 pti2a) (distance pti1 pti2b))
    (command
      ".line" pti1 pti2a ""
      ".line" pti2b ptf1 ""
    ) ; end command
    (command
      ".line" pti1 pti2b ""
      ".line" pti2a ptf1 ""
    ) ; end command
  ) ; end if

  (slay (cdr (assoc 8 ent2)))
  (if (< (distance pti2 pti1a) (distance pti2 pti1b))
    (command
      ".line" pti2 pti1a ""
      ".line" pti1b ptf2 ""
    ) ; end command
    (command
      ".line" pti2 pti1b ""
      ".line" pti1a ptf2 ""
    ) ; end command
  ) ; end if

  (slay oldlay)
  (command
    ".line" pti1a pt0a pti2a ""
    ".line" pti1b pt0b pti2b ""
  ) ; end command

  (command ".undo" "e")
) ; end defun

;; ambiente_3p(): funcao para desenho de ambiente composto por tres paredes
;;  pt   - ponto de referencia do interior do compartimento
;;  e1   - ename da primeira parede utilizada como base na montagem do ambiente
;;  e2   - ename da segunda parede utilizada na montagem do ambiente
;;  d    - distancia de referencia da parede inicial a primeira parede
;;  d1   - distancia interna do ambiente relativo a parede inicial
;;  d2   - distancia interna do ambiente relativo a parede da base
;;  esp  - espesura das paredes que serao criadas
(defun ambiente_3p(pt e1 e2 d d1 d2 esp / ent1 ent2 pti1 ptf1 u1 pti2 ptf2 u2 pt0
  pti1a pti2a ptf1a ptf2a pti1b pti2b ptf1b ptf2b oldlay)

  (setq
    ent1 (entget e1)
    ent2 (entget e2)
  ) ; end setq

  (setq
    pti1 (cdr (assoc 10 ent1))
    ptf1 (cdr (assoc 11 ent1))
  ) ; end setq
  (setq u1 (vtunit (mapcar '- ptf1 pti1)))

  (setq
    pti2 (cdr (assoc 10 ent2))
    ptf2 (cdr (assoc 11 ent2))
  ) ; end setq
  (setq u2 (vtunit (mapcar '- ptf2 pti2)))

  (setq pt0 (inters pti1 ptf1 pti2 ptf2 nil))

  (if (< (vtprod (mapcar '- pt pt0) u1) 0)
    (setq u1 (vtmul -1.0 u1)) )

  (if (< (vtprod (mapcar '- pt pt0) u2) 0)
    (setq u2 (vtmul -1.0 u2)) )

  (setq
    pti1a (mapcar '+ pt0 (vtmul d u1))
    pti2a (mapcar '+ pt0 (vtmul d u1) (vtmul (+ d1 (* 2.0 esp)) u1))
  ) ; end setq

  (setq
    ptf1a (mapcar '+ pti1a (vtmul (+ d esp) u2))
    ptf2a (mapcar '+ pti2a (vtmul (+ d esp) u2))
  ) ; end setq

  (setq
    pti1b (mapcar '+ pt0 (vtmul (+ d esp) u1))
    pti2b (mapcar '+ pt0 (vtmul (+ d esp) u1) (vtmul d1 u1))
  ) ; end setq

  (setq
    ptf1b (mapcar '+ pti1b (vtmul d u2))
    ptf2b (mapcar '+ pti2b (vtmul d u2))
  ) ; end setq

  (setq oldlay (getvar "clayer"))

;; #RCTASK 02/05/2010  k82c.lsp:  (command ".undo" "g") p/ IntelliCAD 2007, foi trocado para    (command ".undo" "m")
  (command ".undo" "m")

  (command ".erase" e1 "")

  (slay (cdr (assoc 8 ent1)))
  (if (< (distance pti1 pti1a) (distance pti1 pti2a))
    (command
      ".line" pti1 pti1a ""
      ".line" pti1b pti2b ""
      ".line" pti2a ptf1 ""
    ) ; end command
    (command
      ".line" ptf1 pti1a ""
      ".line" pti1b pti2b ""
      ".line" pti2a pti1 ""
    ) ; end command
  ) ; end if

  (slay oldlay)
  (command
    ".line" pti1a ptf1a ptf2a pti2a ""
    ".line" pti1b ptf1b ptf2b pti2b ""
  ) ; end command

  (command ".undo" "e")

) ; end defun

;; c:ambiente_1p(/ pt d1 enm1): comando que constroi ambientes utilizando uma parede
(defun c:ambiente_1p()
  (m:savevars)

  (setq d1 (getdist (strcat "\nDistancia interna relativa a primeira parede <" (rtos #DIST1 2 2) ">: ")) )
  (if d1 (setq #DIST1 d1))
  (while (setq enm1 (car (entsel "\nSelecione a primeira parede: ")))
    (initget 1)
    (setq pt (getpoint "\nSelecione um ponto interior ao ambiente: "))

;; #RCTASK 02/05/2010  k82c.lsp:  (command ".undo" "g") p/ IntelliCAD 2007, foi trocado para    (command ".undo" "m")
    (command ".undo" "m")

    (setq
      oldech (acadvar "cmdecho" 0)
      oldhigh (acadvar "highlight" 0)
    ) ; end setq
    (ambiente_1p pt enm1 #DIST1 #ESPCP)
    (setvar "cmdecho" oldech)
    (setvar "highlight" oldhigh)
    (command ".undo" "e")
  ) ; end while
  (princ)
) ; end defun

;; c:ambiente_2p(): comando que constroi ambientes utilizando duas paredes
(defun c:ambiente_2p(/ pt d1 d2 enm1 enm2 flg)
  (setq d1 (getdist (strcat "\nDistancia interna relativa a primeira parede <" (rtos #DIST1 2 2) ">: ")) )
  (if d1 (setq #DIST1 d1))

  (setq d2 (getdist (strcat "\nDistancia interna relativa a segunda parede <" (rtos #DIST2 2 2) ">: ")) )
  (if d2 (setq #DIST2 d2))

  (setq flg 't)
  (while flg
    (if (and (setq enm1 (car (entsel "\nSelecione a primeira parede: ")))
             (setq enm2 (car (entsel "\nSelecione a segunda parede: "))) )
      (progn
        (initget 1)
        (setq pt (getpoint "\nSelecione um ponto interior ao ambiente: "))

;; #RCTASK 02/05/2010  k82c.lsp:  (command ".undo" "g") p/ IntelliCAD 2007, foi trocado para    (command ".undo" "m")
        (command ".undo" "m")
        (setq
          oldech (acadvar "cmdecho" 0)
          oldhigh (acadvar "highlight" 0)
        ) ; end setq
        (ambiente_2p pt enm1 enm2 #DIST1 #DIST2 #ESPCP)
        (setvar "cmdecho" oldech)
        (setvar "highlight" oldhigh)
        (command ".undo" "e")
      ) ; end progn
      (setq flg nil)
    ) ; end if
  ) ; end while

  (m:restorevars)
  (princ)
) ; end defun

;; c:ambiente_3p(): comando que constroi ambientes utilizando tres paredes
(defun c:ambiente_3p(/ pt d1 d2 enm1 enm2 flg)
  (m:savevars)

  (setq d (getdist (strcat "\nDistancia a parede inicial do ambiente <" (rtos #DIST 2 2) ">: ")) )
  (if d (setq #DIST d))

  (setq d1 (getdist (strcat "\nDistancia interna relativa a parede inicial <" (rtos #DIST1 2 2) ">: ")) )
  (if d1 (setq #DIST1 d1))

  (setq d2 (getdist (strcat "\nDistancia interna relativa a parede da base <" (rtos #DIST2 2 2) ">: ")) )
  (if d2 (setq #DIST2 d2))

  (setq flg 't)
  (while flg
    (if (and (setq enm1 (car (entsel "\nSelecione a parede de referencia: ")))
             (setq enm2 (car (entsel "\nSelecione a parede da base: "))) )
      (progn
        (initget 1)
        (setq pt (getpoint "\nSelecione o sentido de construcao do ambiente: "))

;; #RCTASK 02/05/2010  k82c.lsp:  (command ".undo" "g") p/ IntelliCAD 2007, foi trocado para    (command ".undo" "m")
        (command ".undo" "m")
        (setq
          oldech (acadvar "cmdecho" 0)
          oldhigh (acadvar "highlight" 0)
        ) ; end setq
        (ambiente_3p pt enm2 enm1 #DIST #DIST1 #DIST2 #ESPCP)
        (setvar "cmdecho" oldech)
        (setvar "highlight" oldhigh)
        (command ".undo" "e")
      ) ; end progn
      (setq flg nil)
    ) ; end if
  ) ; end while

  (m:restorevars)
  (princ)
) ; end defun

(princ)
