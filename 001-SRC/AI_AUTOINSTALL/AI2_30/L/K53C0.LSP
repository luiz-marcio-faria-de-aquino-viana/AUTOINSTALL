
;;
;; K53C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 3/13/96.
;;
;; XFIN: rotina para associar um XREF ao desenho

(defun c:xfin(/ oldech ent tbl pth f)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (prompt "\nNome do arquivo: ")
  (command ".xref" "" "~")
  (initget 1)
  (command (getpoint "\nPonto de insercao: ") "" "" "")
  (setq ent (entget (entlast)) )
  (setq tbl (tblsearch "block" (cdr (assoc 2 ent))) )
  (setq pth (cdr (assoc 1 tbl)))
  (setq f (open (strcat (getvar "dwgname") ".xrf") "a"))
    (write-line (strcat (getfilename pth) "=@" pth) f)
  (setq f (close f))
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
