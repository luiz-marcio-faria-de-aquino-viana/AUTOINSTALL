
;;
;; K59C0.LSP
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 3/18/96.
;;

;;
;; DBLSCR: duplica a area da tela utilizando o comando vports
;;

(defun c:dblscr(/ p1 p2 p3 p4)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (prompt "\nSelecione a area de visao da nova janela...")

  (initget 1)
  (setq p1 (getpoint "\nFirst corner: "))

  (initget 1)
  (setq p2 (getcorner p1 "\nSecond corner: "))

  (command
    ".view" "s" "$view"
    ".vports" "2" "h"
    ".zoom" "w" p1 p2
  ) ; end command

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;;
;; SISCR: retorna ao estado original uma vports ativa
;;

(defun c:siscr()
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (command ".vports" "si")
  (command ".view" "r" "$view" "y")
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
