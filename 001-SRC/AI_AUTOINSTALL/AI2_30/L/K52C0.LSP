
;;
;; K52C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 1/26/96.
;;
;; XFRELOAD: rotina p/ recarregar e corrigir XREF definidos no arquivo (.xrf)

(defun c:xfreload(/ oldech oldlay ff f lxf dt xf lxf1)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (setvar "tilemode" 1)

  (setq oldlay (getvar "clayer"))
  (command ".layer" "t" "0" "s" "0" "")

  (if (findfile (setq ff (strcat (getvar "dwgname") ".xrf")))
    (progn
      (setq f (open ff "r"))
      (setq lxf '())
      (while (setq dt (read-line f))
        (setq xf (list (strpiece dt 1 "=") (strpiece dt 2 "=")))
        (setq lxf (append lxf (list xf)))
      ) ; end while
      (setq f (close f))
      (prompt "\nAnalisando XREF... ")
      (setq lxf1 '())
      (foreach xf lxf (setq lxf1 (append lxf1 (list (xfix xf t))) ))
      (setq f (open ff "w"))
      (foreach xf lxf1
        (write-line (strcat (car xf) "=" (cadr xf)) f)
      ) ; end foreach
      (setq f (close f))
    ) ; end progn
  ) ; end if

  (command ".layer" "s" oldlay "")

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
