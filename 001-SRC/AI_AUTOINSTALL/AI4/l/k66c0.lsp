
;;
;; K66C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 7/1/96.
;;

;; noutblk: funcao para levantar a quantidade de um bloco no desenho
;;  enm - ename da entidade de insercao do bloco
(defun noutblk(enm / blk ss)
  (setq blk (cdr (assoc 2 (entget enm))))
  (if (setq ss (ssget "x" (list '(0 . "INSERT") (cons 2 blk))))
    (sslength ss)
    0
  ) ; end if
) ; end defun

;; ninblk: funcao para levantar a quantidade de um bloco em outro
;;  enm1 - ename da entidade de insercao do bloco a ser contabilizado
;;  enm2 - ename da entidade de insercao do bloco mais externo
(defun ninblk(enm1 enm2 / blk2 tbl2 enm cnt)
  (setq
    blk1 (cdr (assoc 2 (entget enm1)))
    blk2 (cdr (assoc 2 (entget enm2)))
  ) ; end setq
  (setq tbl2 (tblsearch "block" blk2))
  (setq
    enm (cdr (assoc -2 tbl2))
    cnt 0
  ) ; end setq
  (while enm
    (if (= (cdr (assoc 2 (entget enm))) blk1)
      (setq cnt (+ cnt 1))
    ) ; end if
    (setq enm (entnext enm))
  ) ; end while
  cnt
) ; end defun

;; c:numblk: rotina para levantar o total de um bloco na planta
(defun c:numblk(/ ss ls cnt)
  (if (setq ss (nentsel "\nSelecione um bloco para levantamento: "))
    (progn
      (setq ls (cadddr ss))
      (if ls
        (progn
          (setq cnt (noutblk (car (reverse ls))))
          (while (cdr ls)
            (setq cnt (* cnt (ninblk (car ls) (cadr ls))))
            (setq ls (cdr ls))
          ) ; end while
          (prompt (strcat "\nNumero total de blocos = " (itoa cnt)))
        ) ; end progn
        (prompt "\nERR: Entidade selecionada nao e um bloco.")
      ) ; end if
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

(princ)
