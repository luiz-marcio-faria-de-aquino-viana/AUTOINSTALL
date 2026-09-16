
;;
;; K4fc0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 1/25/96.
;;

(defun fixtxt(s)
  (if (/= s "")
    (if (>= (substr s 1 1) "\200")
      (fixtxt (substr s 2))
      (strcat (substr s 1 1) (fixtxt (substr s 2)))
    ) ; endif
    s
  ) ; endif
) ; end defun

(defun c:ft(/ ss cnt ent txt)
  (if (setq ss (ssget "x" '((0 . "TEXT"))))
    (progn
      (setq cnt (sslength ss))
      (while (not (minusp (setq cnt (- cnt 1)) ) )
        (setq ent (entget (ssname ss cnt)) )
        (setq txt (fixtxt (cdr (assoc 1 ent))) )
        (entmod (subst (cons 1 txt) (assoc 1 ent) ent) )
      ) ; endwhile
    ) ; end progn
  ) ; endif
  (princ)
) ; enddefun
