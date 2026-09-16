
;;
;; K60C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 1/26/96.
;;
;; XFUNLOAD: rotina p/ descarregar e corrigir XREF definidos no arquivo (.xrf)

(defun c:xfunload(/ oldech ff f lxf dt xf lxf1)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (if (findfile (setq ff (strcat (getvar "dwgname") ".xrf")))
    (progn
      (setq f (open ff "r"))
      (setq lxf '())
      (while (setq dt (read-line f))
        (setq lxf (append lxf (list (strpiece dt 1 "="))) )
      ) ; end while
      (setq f (close f))
      (prompt "\nDescarregando XREF... ")
      (foreach xf lxf (command ".xref" "d" xf))
    ) ; end progn
  ) ; end if
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
