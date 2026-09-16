
;;
;; K6FC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 8/22/97
;;

;; c:copyattr(): funcao que copia os valores dos atributos de um bloco para outros
(defun c:copyattr(/ enm1 ss2 cnt)
  (setq enm1 (car (entsel "\nSelecione o bloco de referencia: ")))
  (prompt "\nSelecione o conjunto de blocos que serao modificados...")
  (setq ss2 (ssget))
  (setq cnt (sslength ss2))
  (prompt (strcat "\nProcessando " (itoa cnt) " entidades... "))
  (while (>= (setq cnt (1- cnt)) 0)
    (attcpval enm1 (ssname ss2 cnt))
    (if (zerop (rem cnt 10)) (prompt "."))
  ) ; end while
  (princ)
) ; end defun

(princ)
