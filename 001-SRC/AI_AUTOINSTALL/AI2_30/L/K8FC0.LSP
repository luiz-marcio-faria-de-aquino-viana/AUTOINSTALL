
;;
;; COLBLK.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 4/18/96
;;

;; colblk_def(): troca as cores dos blocos na tabela de definicao
(defun colblk_def()
  (setq blk (tblnext "BLOCK" t))
  (while blk
    (if (/= (substr (cdr (assoc 2 blk)) 1 1) "*")
      (progn
        (prompt (strcat "\nBlock = " (cdr (assoc 2 blk))) )
        (setq enm1 (cdr (assoc -2 blk)))
        (setq enm enm1)
        (while (and enm (/= (cdr (assoc -2 (setq ent (entget enm)) )) enm1))
          (entmod (subst (cons 62 0) (assoc 62 ent) ent))
          (setq enm (entnext enm))
          (prompt ".")
        ) ; end while
      ) ; end progn
    ) ; end if
    (setq blk (tblnext "BLOCK"))
  ) ; end while
) ; end defun

;; colblk_ent(): troca as cores dos atributos dos blocos na base de dados de desenho
(defun colblk_ent()
  (if (setq ss (ssget "x" '((0 . "INSERT"))) )
    (progn
      (setq cnt (sslength ss))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq enm (entnext (ssname ss cnt)) )
        (while (and enm (= (enttype enm) "ATTRIB"))
          (setq ent (entget enm))
          (entmod (subst (cons 62 0) (assoc 62 ent) ent))
          (setq enm (entnext enm))
        ) ; end while
        (prompt ".")
      ) ; end while
    ) ; end progn
  ) ; end if
) ; end defun

;; c:colblk(): rotina de processamento das cores dos blocos
(defun c:colblk()
  (prompt "\nModificando as cores das entidades dos blocos no desenho... ")
  (colblk_def)
  (prompt "\nModificando as cores dos atributos para cada instancia dos blocos... ")
  (colblk_ent)
  (command ".regen")
  (princ)
) ; end defun

(princ)
