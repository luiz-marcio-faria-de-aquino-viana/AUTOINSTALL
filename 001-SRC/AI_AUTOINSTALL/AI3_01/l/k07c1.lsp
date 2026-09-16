
;;
;; K07C0.lsp
;; Copyright (C) 1991-99 by Luiz Marcio F A Viana, 8/1/91
;;

;; c:editext(): rotina para ajuste da altura dos textos do desenho
(defun c:editext(/ selc alt cont qselc entd dim1 aux1 aux2)
  (setvar "cmdecho" 0)

  (setq ss (ssget))

  (initget "Micro Normal Super")
  (setq alt (getdist "\nAltura do texto (ou Super/<Normal>/Micro): "))
  (if (null alt) (setq alt "Normal"))
  
  (cond
    ( (= alt "Micro")  (setq alt (* 1.5 (#SCL))) )
    ( (= alt "Normal") (setq alt (* 2.0 (#SCL))) )
    ( (= alt "Super")  (setq alt (* 4.0 (#SCL))) )
  )

  (initget "MAiuscula MInuscula Indiferente")
  (setq diml (getkword "\nMAiuscula/MInuscula/<Indiferente>: "))
  (if (null diml) (setq diml "Indiferente"))
  
  (setq cnt (sslength ss))
  (while (>= (setq cnt (1- cnt)) 0)
    (setq ent (entget (ssname ss cnt)))
    (if (= (cdr (assoc 0 ent)) "TEXT")
      (progn
        (setq ent (subst (cons 40 alt) (assoc 40 ent) ent))
        (setq txt (cdr (assoc 1 ent)) )
        (cond
	  ( (= diml "MAiuscula") (setq ent (subst (cons 1 (strcase txt)) (assoc 1 ent) ent)) )
	  ( (= diml "MInuscula") (setq ent (subst (cons 1 (strcase txt 't)) (assoc 1 ent) ent)) )
        )
        (entmod ent)
      )
    )
  )
  (princ)
)

(princ)
