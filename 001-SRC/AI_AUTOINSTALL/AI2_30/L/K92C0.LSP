
;;
;; K92C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 11/10/98
;;

;; sol2hat(): rotina que transforma solidos em hachuras
;;  hattyp - tipo de hachura que sera aplicada
;;  hatscl - escala de insercao das hachuras
;;  hatrot - rotacao que sera aplicada as hachuras
;;  lay    - camada de pesquisa dos solidos
;;  nlay   - camada de criacao das hachuras
(defun sol2hat(hattyp hatscl hatrot lay nlay / oldecho oldhigh oldlay ss cnt pt1 pt2 pt3 pt4)
  (setq oldecho (acadvar "cmdecho" 0))
  (setq oldhigh (acadvar "highlight" 0))
  (if (setq ss (ssget "x" (list (cons 0 "SOLID") (cons 8 lay))) )
    (progn
      (setq oldlay (slay nlay))

      (setq cnt (sslength ss))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq ent (entget (ssname ss cnt)))
        (setq
          pt1 (cdr (assoc 10 ent))
          pt2 (cdr (assoc 11 ent))
          pt3 (cdr (assoc 12 ent))
          pt4 (cdr (assoc 13 ent))
        ) ; end setq
        (command ".pline" pt1 "w" 0 0 pt2 pt3 pt4 "c")
        (if (= hattyp "")
          (command ".hatch" "u" hatrot hatscl "n" (entlast) "")
          (command ".hatch" hattyp hatscl hatrot (entlast) "")
        ) ; end if
      ) ; end while
    ) ; end progn
    (prompt "\nERR: Nao foi encontrado solidos na camada informada.")
  ) ; end if
  (setvar "highlight" oldhigh)
  (setvar "cmdecho" oldecho)
) ; end defun

;; c:sol2hat(): rotina de interface com o usuario
(defun c:sol2hat(/ ss lay hattyp hatscl hatrot)
  (if (setq ss (entsel "\nSelecione um objeto da camada fonte (ou ENTER): "))
    (setq lay (cdr (assoc 8 (entget (car ss)))) )
    (progn
      (setq lay (getstring (strcat "\nInforme a camada fonte <" (getvar "clayer") ">: ")) )
      (if (= lay "") (setq lay (getvar "clayer")) )
    ) ; end progn
  ) ; end if

  (if (tblsearch "layer" lay)
    (progn
      (setq hattyp (getstring "Padrao de hachura <U>: "))

      (initget 6)
      (setq hatscl (getreal (strcat "\nEscala da hachura <" (rtos #SCL 2 2) ">: ")) )
      (if (null hatscl) (setq hatscl #SCL))

      (initget 6)
      (setq hatrot (getangle "\nRotacao <0>: "))
      (if (null hatrot) (setq hatrot 0.0))

      (sol2hat hattyp hatscl hatrot lay (strcat "$" (substr lay 1 30)) )
    ) ; end progn
    (prompt "ERR: Nao existe camada com o nome informado.")
  ) ; end if
  
  (princ)
) ; end defun

(princ)
