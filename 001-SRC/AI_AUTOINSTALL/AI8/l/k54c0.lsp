
;;
;; K54C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 3/13/96.
;;
;; XFOUT: rotina para desassociar um XREF do desenho

(defun c:xfout(/ oldech flg xfb tbl ls f dt xf)
  (m:savevars)
  (command ".xref" "?" "")
  (setq flg nil)
  (while (null flg)
    (while (= (setq xfb (getstring "\nNome do XREF: ")) ""))
    (if (setq tbl (tblsearch "block" xfb))
      (setq flg (= (logand (cdr (assoc 70 tbl)) 4) 4))
    ) ; end if
  ) ; end while
  (command ".xref" "d" xfb)
  (setq ls '())
  (setq f (open (strcat (getvar "dwgname") ".xrf") "r"))
  (while (setq dt (read-line f))
    (setq xf (list (strpiece dt 1 "=") (strpiece dt 2 "=")))
    (setq ls (append ls (list xf)))
  ) ; end while
  (setq f (close f))
  (setq f (open (strcat (getvar "dwgname") ".xrf") "w"))
  (foreach xf ls
    (if (/= (strcase xfb) (strcase (car xf)))
      (write-line (strcat (car xf) "=" (cadr xf)) f)
    ) ; end if
  ) ; end foreach
  (setq f (close f))
  (m:restorevars)
  (princ)
) ; end defun

(princ)
