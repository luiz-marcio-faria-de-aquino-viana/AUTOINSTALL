
;;
;; K91C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 11/10/98
;;

;; blexpl(): rotina que explode todos os blocos de uma camada
;;  lay - nome da camada que sera pesquisada
(defun blexpl(lay / oldecho oldhigh ss cnt)
  (setq oldecho (acadvar "cmdecho" 0))
  (setq oldhigh (acadvar "highlight" 0))
  (if (setq ss (ssget "x" (list (cons 0 "INSERT") (cons 8 lay))))
    (progn
      (setq cnt (sslength ss))
      (while (>= (setq cnt (1- cnt)) 0)
        (command ".explode" (ssname ss cnt))
      ) ; end while
    ) ; end progn
    (prompt "\nERR: Nao foi encontrado blocos na camada.")
  ) ; end if
  (setvar "highlight" oldhigh)
  (setvar "cmdecho" oldecho)
) ; end defun

;; c:blexpl(): rotina que explode todos os blocos de uma camada
(defun c:blexpl(/ ss lay)
  (if (setq ss (entsel "\nSelecione um objeto da camada fonte (ou ENTER): "))
    (setq lay (cdr (assoc 8 (entget (car ss)))) )
    (progn
      (setq lay (getstring (strcat "\nNome da camada fonte <" (getvar "clayer") ">: ")) )
      (if (= lay "") (setq lay (getvar "clayer")) )
    ) ; end progn
  ) ; end if

  (if (tblsearch "layer" lay)
    (blexpl lay)
    (prompt "ERR: Nao existe nenhuma camada com o nome informado.")
  ) ; end if

  (princ)
) ; end defun

(princ)
