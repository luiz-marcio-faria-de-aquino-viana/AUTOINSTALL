
;;
;; K66C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 7/1/96.
;;

;; numblk: funcao para levantar a quantidade de um determinado bloco na planta
;;  blk - nome do bloco a ser analisado
(defun numblk(blk / ss)
  (if (setq ss (ssget "x" (list '(0 . "INSERT") (cons 2 blk))))
    (sslength ss)
    0
  ) ; end if
) ; end defun

;; c:numblk: rotina para levantar a quantidade do bloco selecionado na planta
(defun c:numblk(/ enm ent)
  (if (setq enm (car (entsel "\nSelecione o bloco para levantamento: ")))
    (progn
      (setq ent (entget enm))
      (if (= (cdr (assoc 0 ent)) "INSERT")
        (prompt (strcat "\nNumero total de blocos = " (itoa (numblk (cdr (assoc 2 ent)))) ))
        (prompt "\nERR: Nenhum bloco foi selecionado.")
      ) ; end if
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

(princ)
