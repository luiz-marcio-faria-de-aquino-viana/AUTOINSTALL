
;;
;; INSLUM.lsp
;; Copyright (C) 1995 by Luiz Marcio F A Viana, 12/9/95
;;

;;
;; SETLUM: procedimento que inicializa variaveis de controle pela
;; identificacao do ultimo tipo de luminaria inserido no desenho

(defun setlum(/ ss ff cnt blk)
  (setq
    #TLUM "2x40W"
    #TCIRC "NORMAL"
  ) ; end setq
  (if (setq ss (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))))
    (progn
      (setq ff nil)
      (setq cnt 0)
      (while (and (< cnt (sslength ss)) (null ff))
        (setq blk (substr (cdr (assoc 2 (entget (ssname ss cnt)))) 1 5) )
        (cond
          ((or (= blk "EL0CC") (= blk "EL0DC") (= blk "EL0EC"))
           (setq
             ff t
             #TLUM "2x20W"
             #TCIRC "NORMAL"
          )) ; end setq, case
          ((or (= blk "EL24C") (= blk "EL25C") (= blk "EL26C"))
           (setq
             ff t
             #TLUM "2x20W"
             #TCIRC "VIGIA"
          )) ; end setq, case
          ((or (= blk "EL2BC") (= blk "EL2CC") (= blk "EL2DC"))
           (setq
             ff t
             #TLUM "2x40W"
             #TCIRC "NORMAL"
          )) ; end setq, case
          ((or (= blk "EL2EC") (= blk "EL2FC") (= blk "EL30C"))
           (setq
             ff t
             #TLUM "2x40W"
             #TCIRC "VIGIA"
          )) ; end setq, case
          ((or (= blk "EL36C") (= blk "EL37C") (= blk "EL38C"))
           (setq
             ff t
             #TLUM "2x20W"
             #TCIRC "EMERGENCIA"
          )) ; end setq, case
          ((or (= blk "EL39C") (= blk "EL3AC") (= blk "EL3BC"))
           (setq
             ff t
             #TLUM "2x40W"
             #TCIRC "EMERGENCIA"
          )) ; end setq, case
        ) ; end cond
        (setq cnt (+ cnt 1))
      ) ; end while
    ) ; end progn
  ) ; end if
) ; end defun

;;
;; INSLUM: procedimento para insercao de pontos com luminarias

(defun inslum(blk / ublk ptb pti)
  (setvar "cmdecho" 0)
  (prompt (strcat "\nLuminaria = " #TLUM ", Circuito = " #TCIRC))
  (setq ublk (getstring (strcat "\nInsert block name <" blk ">: ")))
  (if (/= ublk "") (setq blk ublk))
  (initget 1)
  (setq
    ptb (getpoint "\nFirst point (or Insert point): ")
    pti (getpoint ptb "\nSecound point (or ENTER): ")
  ) ; end setq
  (if (null pti)
    (setq pti ptb)
    (setq pti (mapcar '/ (mapcar '+ pti ptb) '(2.0 2.0)) )
  ) ; end if
  (command ".insert" (V:AID blk) pti (/ 1.0 (#UND)))
  (setvar "cmdecho" 1)
  (command "" pause)
  (setvar "cmdecho" 0)
) ; end defun

;;
;; LUMEMBT: procedimento para insercao de luminarias de embutir

(defun c:lumembt(/ TABL blk)
  (setq
    TABL '(("2x20W NORMAL"     . "EL/EL0CC00")
           ("2x20W VIGIA"      . "EL/EL24C00")
           ("2x20W EMERGENCIA" . "EL/EL36C00")
           ("2x40W NORMAL"     . "EL/EL2BC00")
           ("2x40W VIGIA"      . "EL/EL2EC00")
           ("2x40W EMERGENCIA" . "EL/EL39C00"))
  ) ; end setq
  (if (or (null #TLUM) (null #TCIRC)) (setlum))
  (setq blk (cdr (assoc (strcat #TLUM " " #TCIRC) TABL)) )
  (inslum blk)
  (princ)
) ; end defun

;;
;; LUMPEND: procedimento para insercao de luminarias pendentes

(defun c:lumpend(/ TABL blk)
  (setq
    TABL '(("2x20W NORMAL"     . "EL/EL0DC00")
           ("2x20W VIGIA"      . "EL/EL25C00")
           ("2x20W EMERGENCIA" . "EL/EL37C00")
           ("2x40W NORMAL"     . "EL/EL2DC00")
           ("2x40W VIGIA"      . "EL/EL2FC00")
           ("2x40W EMERGENCIA" . "EL/EL3BC00"))
  ) ; end setq
  (if (or (null #TLUM) (null #TCIRC)) (setlum))
  (setq blk (cdr (assoc (strcat #TLUM " " #TCIRC) TABL)) )
  (inslum blk)
  (princ)
) ; end defun

;;
;; LUMSOBR: procedimento para insercao de luminarias de sobrepor

(defun c:lumsobr(/ TABL blk)
  (setq
    TABL '(("2x20W NORMAL"     . "EL/EL0EC00")
           ("2x20W VIGIA"      . "EL/EL26C00")
           ("2x20W EMERGENCIA" . "EL/EL38C00")
           ("2x40W NORMAL"     . "EL/EL2CC00")
           ("2x40W VIGIA"      . "EL/EL30C00")
           ("2x40W EMERGENCIA" . "EL/EL3AC00"))
  ) ; end setq
  (if (or (null #TLUM) (null #TCIRC)) (setlum))
  (setq blk (cdr (assoc (strcat #TLUM " " #TCIRC) TABL)) )
  (inslum blk)
  (princ)
) ; end defun
