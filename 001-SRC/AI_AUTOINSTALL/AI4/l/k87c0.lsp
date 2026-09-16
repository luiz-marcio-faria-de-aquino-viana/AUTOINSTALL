
;;
;; K87C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 3/20/98
;;

;; c:edelfios(): rotina para apagar a fiacao eletrica
(defun c:edelfios(/ ss oldecho oldhigh ss1)

  (prompt "\nSelecione objetos ou ENTER para todos os fios...")
  (setq ss (ssget '((8 . "EL-CIRCUITOS"))) )

  (setq oldecho (acadvar "cmdecho" 0))
  (command ".undo" "g")

  (setq oldhigh (acadvar "highlight" 0))

  (if ss
    (command ".erase" ss "")
    (progn
      (prompt "\nEliminando toda fiacao do desenho...")
      (if (setq ss (ssget "x" '((8 . "EL-CIRCUITOS"))) )
        (command ".erase" ss "")
        (prompt "\nERR: Nenhum fiacao encontrada.")
      ) ; end if
    ) ; end progn
  ) ; end if

  (setvar "highlight" oldhigh)

  (command ".undo" "e")
  (setvar "cmdecho" oldecho)

  (princ)
) ; end defun

;; c:ecopfios(): rotina para copiar a fiacao eletrica
(defun c:ecopfios(/ ss oldecho oldhigh ss1 pti ptf)

  (if (setq ss (ssget '((8 . "EL-CIRCUITOS"))) )
    (progn
      (initget 1)
      (setq pti (getpoint "\nPonto base: "))

      (initget 1)
      (setq ptf (getpoint pti "\nPonto de insercao: "))

      (setq oldecho (acadvar "cmdecho" 0))
      (command ".undo" "g")

      (setq oldhigh (acadvar "highlight" 0))

      (if ss (command ".copy" ss "" pti ptf))

      (setvar "highlight" oldhigh)

      (command ".undo" "e")
      (setvar "cmdecho" oldecho)

    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

;; c:emovfios(): rotina para movimentar a fiacao eletrica
(defun c:emovfios(/ ss oldecho oldhigh ss1 pti ptf)

  (if (setq ss (ssget '((8 . "EL-CIRCUITOS"))) )
    (progn
      (initget 1)
      (setq pti (getpoint "\nPonto base: "))

      (initget 1)
      (setq ptf (getpoint pti "\nPonto de insercao: "))

      (setq oldecho (acadvar "cmdecho" 0))
      (command ".undo" "g")

      (setq oldhigh (acadvar "highlight" 0))

      (if ss (command ".move" ss "" pti ptf))

      (setvar "highlight" oldhigh)

      (command ".undo" "e")
      (setvar "cmdecho" oldecho)

    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

;; c:erotfios(): rotina para rotacionar a fiacao eletrica
(defun c:erotfios(/ ss oldecho oldhigh oldaunits ss1 pti ptd ptref ptang)

  (if (setq ss (ssget '((8 . "EL-CIRCUITOS"))) )
    (progn
      (initget 1)
      (setq pti (getpoint "\nPonto base: "))

      (initget 1 "Referencia")
      (setq ptd (getpoint pti "\n<Angulo de rotacao>/Referencia: "))

      (if (= ptd "Referencia")
        (progn
          (setq ptref (getangle pti "\nAngulo de referencia <0>: "))
          (if (null ptref) (setq ptref 0.0))

          (initget 1)
          (setq ptang (getangle pti "\nNovo angulo: "))
        ) ; end progn
      ) ; end if

      (setq oldecho   (acadvar "cmdecho" 0))
      (command ".undo" "g")

      (setq
        oldhigh   (acadvar "highlight" 0)
        oldaunits (acadvar "aunits" 3)
      ) ; end setq

      (if ss
        (if (= ptd "Referencia")
          (command ".rotate" ss "" pti "r" (angtos ptref) (angtos ptang))
          (command ".rotate" ss "" pti ptd)
        ) ; end if
      ) ; end if

      (setvar "aunits" oldaunits)
      (setvar "highlight" oldhigh)

      (command ".undo" "e")
      (setvar "cmdecho" oldecho)

    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

(princ)
