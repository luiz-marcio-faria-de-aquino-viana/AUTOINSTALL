
;;
;; K8CC0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 5/14/98
;;

;; ai_propchk(): rotina de modificacao das propriedades dos objetos
(defun ai_propchk(/ a)
  (if (not (setq a (ssget "i"))) (setq a (ssget)) )

  (if (> (sslength a) 1)
    (progn
      (if (not ddchprop) (load "ddchprop"))
      (ddchprop a)
    ) ; end progn
    (progn
      (if (not ddmodify) (load "ddmodify"))
      (ddmodify (ssname a 0))
    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

;; c:ai_propchk(): rotina de acesso ao comando 'ai_propchk'
(defun c:ai_propchk()
  (m:savevars)
  (ai_propchk)
  (m:restorevars)
  (princ)
) ; end defun

(princ)
