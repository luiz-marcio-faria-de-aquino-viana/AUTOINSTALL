
;;
;; K90C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 10/22/98
;;

;; c:copyrot(): comando de edicao que mistura os comandos de copia e rotacao
(defun c:copyrot()
  (setq oldech (acadvar "cmdecho" 0))
  (prompt "\nSelecione os objeto para o comando...")
  (if (setq ss (ssget))
    (progn
      (command
        ".undo" "g"
        ".copy" ss "" "0,0" "0,0"
        ".move" ss ""
      ) ; end command
      (prompt "\nPonto base: ")
      (command pause)
      (prompt "\nSegundo ponto: ")
      (command pause)
      (command ".rotate" "p" "" (getvar "lastpoint"))
      (prompt "\nRotacao")
      (command pause)
      (command ".undo" "e")
    ) ; end progn
    (prompt "\nERR: Nenhum objeto foi selecionado.")
  ) ; end if
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
