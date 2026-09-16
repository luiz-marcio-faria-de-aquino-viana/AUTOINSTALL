
;;
;; SERIE.lsp
;;
;; Copyright (C) 1994 by Luiz Marcio F A Viana
;; All Rights Reserved.
;;

(defun c:serie(/ oldech p1 p2 d1 h1 rot i1 s1 f1 cond1 i2)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (initget 1)
  (setq p1 (getpoint "\nPonto inicial: ") )
  (initget 1)
  (setq p2 (getpoint p1 "\nDistancia: ") )
  (setq d1 (distance p1 p2) )

  (initget "Micro Normal Super")
  (setq h1 (getdist "\nAltura do texto <Normal>: ") )
  (if (null h1) (setq h1 "Normal"))
  (cond
    ((= h1 "Micro") (setq h1 (* 1.5 #SCL)) )
    ((= h1 "Normal")(setq h1 (* 2.0 #SCL)) )
    ((= h1 "Super") (setq h1 (* 4.0 #SCL)) )
  ) ; end cond

  (initget "No Yes")
  (setq Rot (getkword "\nRodar o texto de 90d <No>: "))
  (if (null Rot) (setq Rot "No"))
  (cond
    ((= Rot "No") (setq Rot 0.0))
    ((= Rot "Yes")(setq Rot 90.0))
  ) ; end cond

  (setq i1 (getint "\nValor inicial do contador <1>: ") )
  (if (null i1) (setq i1 1))
  (setq s1 (getint "\nValor do incremento <1>: ") )
  (if (null s1) (setq s1 1))
  (initget 1)
  (setq f1 (getint "\nValor final do contador: ") )
  (if (< i1 f1)
    (defun cond1(a b) (<= a b))
    (defun cond1(a b) (>= a b))
  ) ; end if

  (setq c (getstring "\nTexto (inserido antes do numero): "))

  (command
    ".ucs" "or" p1
    ".ucs" "z" p1 p2
  ) ; end command

  (setq i2 0)
  (while (cond1 i1 f1)
    (command ".text" "c" (list (* d1 i2) 0.0) h1 Rot (strcat c (itoa i1)))
    (setq
      i1 (+ i1 s1)
      i2 (1+ i2)
    ) ; end setq
  ) ; end while

  (command ".ucs" "w")

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
