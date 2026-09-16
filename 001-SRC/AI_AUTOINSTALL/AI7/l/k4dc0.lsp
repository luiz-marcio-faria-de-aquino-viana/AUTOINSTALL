
;;
;; PLEXPL.lsp
;; Copyright (C) 1995 by Luiz Marcio F A Viana, 12/9/95
;;

;;
;; PLEXPL: rotina para explodir plines pertencentes a um layer
;;

(defun c:plexpl()
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (if (setq sel (entsel "\nSelecione um objeto do layer de referencia: "))
    (progn
      (setq ent (entget (car sel)))
      (setq lay (assoc 8 ent))
      (if (setq ss (ssget "x" (list '(0 . "POLYLINE") lay)))
        (progn
          (setq cnt (sslength ss))
          (while (not (zerop cnt))
            (setq cnt (- cnt 1))
            (command ".explode" (ssname ss cnt))
          ) ; end while
        ) ; end progn
      ) ; end if
    ) ; end progn
  ) ; end if
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
