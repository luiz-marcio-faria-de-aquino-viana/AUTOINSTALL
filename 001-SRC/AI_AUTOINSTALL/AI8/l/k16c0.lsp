
;;
;; K16C0.lsp
;; Copyright (C) 1992-98 by Luiz Marcio F A Viana, 3/15/98
;;

;; declaracao das variaveis globais
(or #PORTA_FOLHA (setq #PORTA_FOLHA (/  30.0 (#UND))) )      ;; espesura da folha da porta
(or #PORTA_DIST  (setq #PORTA_DIST  (/ 100.0 (#UND))) )      ;; distancia ao ponto de insercao
(or #PORTA_LARG  (setq #PORTA_LARG  (/ 700.0 (#UND))) )      ;; largura do vao da porta

;; c:porta(): rotina para desenho de portas simples
(defun c:porta(/ oldecho oldblip oldhigh ptb pti dist larg ss1 ss2 ptx pt1i pt1f pt2i u1 u2 ent1 ent2 pt1 pt2 pt3 ui uj)
  (m:savevars)

  (initget 1 "Dimensoes")
  (setq ptb (getpoint "\nDimensoes/<Ponto base>: "))

  (if (= ptb "Dimensoes")
    (progn
      (setq dist (getdist (strcat "\nDistancia ao ponto inicial <" (rtos #PORTA_DIST 2 2) ">: ")) )
      (if dist (setq #PORTA_DIST dist))

      (setq larg (getdist (strcat "\nLargura do vao <" (rtos #PORTA_LARG 2 2) ">: ")) )
      (if larg (setq #PORTA_LARG larg))

      (initget 1)
      (setq ptb (getpoint "\nPonto base: "))

      (while (null (setq ss1 (entsel "\nSelecione a face de abertura da porta: ")))
        (prompt "\nERR: Resposta nula nao e valida.") )

      (while (null (setq ss2 (entsel "\nSelecione a face oposta da parede: ")))
        (prompt "\nERR: Resposta nula nao e valida.") )

      ;;
      ;; processamento e tratamento dos dados de entrada
      ;;

      (setq ptx  (cadr ss1))

      (setq ent1 (entget (car ss1)) )
      (setq
        pt1i (cdr (assoc 10 ent1))
        pt1f (cdr (assoc 11 ent1))
      ) ; end setq
      (setq u1 (vtunit (mapcar '- pt1f pt1i)) )
      (if (< (vtprod (mapcar '- ptx ptb) u1) 0) (setq u1 (vtmul (- 1) u1)) )

      (setq ent2 (entget (car ss2)) )
      (setq pt2i (cdr (assoc 10 ent2)) )
      (setq u2 (vtnorm u1))

      (setq
        pti (mapcar '+ ptb (vtmul #PORTA_DIST u1))
        pt1 (mapcar '+ pti (vtmul #PORTA_LARG u1))
        pt2 (mapcar '+ pti (vtmul (vtprod (mapcar '- pt2i pt1i) u2) u2) )
      ) ; end setq

    ) ; end progn
    (progn
      (setq pti (getpoint ptb "\nPonto inicial (ENTER=ponto base): "))
      (if (null pti) (setq pti ptb))

      (initget 1)
      (setq pt1 (getpoint pti "\nMarque a largura do vao: "))

      (initget 1)
      (setq pt2 (getpoint pti "\nMarque a espesura da parede: "))
    ) ; end progn

  ) ; end if

  (setq pt3 (mapcar '+ pt2 (mapcar '- pt1 pti)) )

  (setq
    ui (vtunit (mapcar '- pt1 pti))     ;; vetor unitario da direcao do vao
    uj (vtunit (mapcar '- pti pt2))     ;; vetor unitario da direcao de abertura da porta
  ) ; end setq

  (command ".undo" "m")

  (setq
    oldecho (acadvar "cmdecho" 0)
    oldblip (acadvar "blipmode" 0)
    oldhigh (acadvar "highlight" 0)
  ) ;  end setq

  (command
    ".break" (mapcar '/ (mapcar '+ pti pt1) '(2.0 2.0)) "f" pti pt1
    ".break" (mapcar '/ (mapcar '+ pt2 pt3) '(2.0 2.0)) "f" pt2 pt3
    ".line" pti pt2 ""
    ".line" pt1 pt3 ""
    ".line"
      pti
      (setq tmp (mapcar '+ pti (vtmul (distance pti pt1) uj)) )
      (setq tmp (mapcar '+ tmp (vtmul #PORTA_FOLHA ui)) )
      (mapcar '+ tmp (vtmul (- (distance pti pt1)) uj))
      "c"
  ) ; end command

  (setvar "cmdecho" oldecho)
  (setvar "blipmode" oldblip)
  (setvar "highlight" oldhigh)

  (command ".undo" "e")

  (m:restorevars)
  (princ)
) ; end defun

;; c:porta2x(): rotina para desenho de portas duplas
(defun c:porta2x(/ oldecho oldblip oldhigh ptb pti dist larg ss1 ss2 ptx pt1i pt1f pt2i u1 u2 ent1 ent2 pt1 pt2 pt3 ui uj)
  (m:savevars)

  (initget 1 "Dimensoes")
  (setq ptb (getpoint "\nDimensoes/<Ponto base>: "))

  (if (= ptb "Dimensoes")
    (progn
      (setq dist (getdist (strcat "\nDistancia ao ponto inicial <" (rtos #PORTA_DIST 2 2) ">: ")) )
      (if dist (setq #PORTA_DIST dist))

      (setq larg (getdist (strcat "\nLargura do semi-vao <" (rtos #PORTA_LARG 2 2) ">: ")) )
      (if larg (setq #PORTA_LARG larg))

      (initget 1)
      (setq ptb (getpoint "\nPonto base: "))

      (while (null (setq ss1 (entsel "\nSelecione a face de abertura da porta: ")))
        (prompt "\nERR: Resposta nula nao e valida.") )

      (while (null (setq ss2 (entsel "\nSelecione a face oposta da parede: ")))
        (prompt "\nERR: Resposta nula nao e valida.") )

      ;;
      ;; processamento e tratamento dos dados de entrada
      ;;

      (setq ptx  (cadr ss1))

      (setq ent1 (entget (car ss1)) )
      (setq
        pt1i (cdr (assoc 10 ent1))
        pt1f (cdr (assoc 11 ent1))
      ) ; end setq
      (setq u1 (vtunit (mapcar '- pt1f pt1i)) )
      (if (< (vtprod (mapcar '- ptx ptb) u1) 0) (setq u1 (vtmul (- 1) u1)) )

      (setq ent2 (entget (car ss2)) )
      (setq pt2i (cdr (assoc 10 ent2)) )
      (setq u2 (vtnorm u1))

      (setq
        pti (mapcar '+ ptb (vtmul #PORTA_DIST u1))
        pt1 (mapcar '+ pti (vtmul (* #PORTA_LARG 2.0) u1))
        pt2 (mapcar '+ pti (vtmul (vtprod (mapcar '- pt2i pt1i) u2) u2) )
      ) ; end setq

    ) ; end progn
    (progn
      (setq pti (getpoint ptb "\nPonto inicial (ENTER=ponto base): "))
      (if (null pti) (setq pti ptb))

      (initget 1)
      (setq pt1 (getpoint pti "\nMarque a largura do vao: "))

      (initget 1)
      (setq pt2 (getpoint pti "\nMarque a espesura da parede: "))
    ) ; end progn

  ) ; end if

  (setq pt3 (mapcar '+ pt2 (mapcar '- pt1 pti)) )

  (setq
    ui (vtunit (mapcar '- pt1 pti))     ;; vetor unitario da direcao do vao
    uj (vtunit (mapcar '- pti pt2))     ;; vetor unitario da direcao de abertura da porta
  ) ; end setq

  (command ".undo" "m")

  (setq
    oldecho (acadvar "cmdecho" 0)
    oldblip (acadvar "blipmode" 0)
    oldhigh (acadvar "highlight" 0)
  ) ;  end setq

  (command
    ".break" (mapcar '/ (mapcar '+ pti pt1) '(2.0 2.0)) "f" pti pt1
    ".break" (mapcar '/ (mapcar '+ pt2 pt3) '(2.0 2.0)) "f" pt2 pt3
    ".line" pti pt2 ""
    ".line" pt1 pt3 ""
    ".line"
      pti
      (setq tmp (mapcar '+ pti (vtmul (/ (distance pti pt1) 2.0) uj)) )
      (setq tmp (mapcar '+ tmp (vtmul #PORTA_FOLHA ui)) )
      (mapcar '+ tmp (vtmul (- (/ (distance pti pt1) 2.0)) uj))
      "c"
    ".line"
      pt1
      (setq tmp (mapcar '+ pt1 (vtmul (/ (distance pti pt1) 2.0) uj)) )
      (setq tmp (mapcar '+ tmp (vtmul (- #PORTA_FOLHA) ui)) )
      (mapcar '+ tmp (vtmul (- (/ (distance pti pt1) 2.0)) uj))
      "c"
  ) ; end command

  (setvar "cmdecho" oldecho)
  (setvar "blipmode" oldblip)
  (setvar "highlight" oldhigh)

  (command ".undo" "e")

  (m:restorevars)
  (princ)
) ; end defun

;; c:pcorrer(): rotina para desenho de portas de correr
(defun c:pcorrer (/ oldecho oldblip oldhigh ptb pti pt1 pt2 pt3 ui uj)
  (m:savevars)

  (initget 1)
  (setq ptb (getpoint "\nPonto base (ou inicial): "))

  (setq pti (getpoint ptb "\nPonto inicial (ENTER=ponto base): "))
  (if (null pti) (setq pti ptb))

  (initget 1)
  (setq pt1 (getpoint pti "\nMarque a largura do vao: "))

  (initget 1)
  (setq pt2 (getpoint pti "\nMarque a espesura da parede: "))

  (setq pt3 (mapcar '+ pt2 (mapcar '- pt1 pti)) )

  (setq
    ui (vtunit (mapcar '- pt1 pti))     ;; vetor unitario da direcao do vao
    uj (vtunit (mapcar '- pti pt2))     ;; vetor unitario da direcao de abertura da porta
  ) ; end setq

  (command ".undo" "m")

  (setq
    oldecho (acadvar "cmdecho" 0)
    oldblip (acadvar "blipmode" 0)
    oldhigh (acadvar "highlight" 0)
  ) ;  end setq

  (command
    ".break" (mapcar '/ (mapcar '+ pti pt1) '(2.0 2.0)) "f" pti pt1
    ".break" (mapcar '/ (mapcar '+ pt2 pt3) '(2.0 2.0)) "f" pt2 pt3
    ".line" pti pt2 ""
    ".line" pt1 pt3 ""
    ".line"
      pti
      (setq tmp (mapcar '+ pti (vtmul (+ (/ (distance pti pt1) 2.0) #PORTA_FOLHA) ui)) )
      (mapcar '+ tmp (vtmul (- #PORTA_FOLHA) uj))
      ""
    ".line"
      (setq tmp (mapcar '+ pti (vtmul (- #PORTA_FOLHA) uj)) )
      (setq tmp (mapcar '+ tmp (vtmul (distance pti pt1) ui)) )
      ""
    ".line"
      (setq tmp (mapcar '+ tmp (vtmul (- #PORTA_FOLHA) uj)) )
      (setq tmp (mapcar '+ tmp (vtmul (- (+ (/ (distance pti pt1) 2.0) #PORTA_FOLHA)) ui)) )
      (mapcar '+ tmp (vtmul #PORTA_FOLHA uj))
      ""
  ) ; end command
  (getstring "\nTecle [ENTER]")

  (setvar "cmdecho" oldecho)
  (setvar "blipmode" oldblip)
  (setvar "highlight" oldhigh)

  (command ".undo" "e")

  (m:restorevars)
  (princ)
) ; end defun

(princ)
