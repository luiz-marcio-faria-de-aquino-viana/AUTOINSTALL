
;;
;; K32C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 6/7/96
;;

;; esave: rotina para a extracao de atributos para processamento externo
(defun c:esave(/ ss ff)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (setq ff (strcat (getvar "dwgname") ".DDB"))
  (command
    ".attext" "s" (v:ail "X32C0") (v:appl "$TEMP$")
    ".shell" (strcat "copy " (v:appl "$TEMP$") ".txt " ff " >" (v:appl "acad.err"))
  ) ; end command
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
