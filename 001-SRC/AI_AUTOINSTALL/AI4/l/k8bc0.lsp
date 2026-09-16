
;;
;; K8BC0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 5/14/98
;;

;; c:rectang(): rotina para desenho de retangulos
(defun c:rectang ( / oldecho pt1 pt2)
  (setq oldecho (acadvar "cmdecho" 0))

  (setq
    pt1 (getpoint "\nFirst corner: ")
    pt2 (getcorner pt1 "\nOther corner: ")
  ) ; end setq

  (command
    ".pline"
      "non" pt1 "w" "0" ""
      "non" (list (car pt1) (cadr pt2))
      "non" pt2
      "non" (list (car pt2) (cadr pt1))
      "c"
  ) ; end command
  (setvar "cmdecho" oldecho)
  (princ)
) ; end defun

(princ)

