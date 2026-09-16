
;;
;; K56C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 1/26/96.
;;

;; vmodif: rotina para visualizar o responsavel por uma modificacao
(defun c:vmodif(/ oldech obj enm ss cnt flg ent rst)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (if (setq obj (entsel "\nSelecione um objeto: "))
    (progn
      (setq enm (car obj))
      (setq ss (ssget "x"))
      (setq cnt (sslength ss))
      (setq
        flg t
        rst nil
      ) ; end setq
      (while (and flg (>= (setq cnt (- cnt 1)) 0) )
        (setq ent (entget (ssname ss cnt)) )
        (if (setq flg (not (eq enm (cdr (assoc -1 ent)))) )
          (if (and (= (cdr (assoc 0 ent)) "INSERT")
                   (= (cdr (assoc 2 ent)) "SET0DC02") )
            (setq rst (cdr (assoc -1 ent)))
          ) ; end if
        ) ; end if
      ) ; end while
    ) ; end progn
  ) ; end if
  (if rst (progn
            (setq enm1 (entnext rst))
            (while (/= (cdr (assoc 0 (setq ent1 (entget enm1)))) "SEQEND")
              (cond
                ((= (cdr (assoc 2 ent1)) "DWGNAME")  (setq lpnm   (cdr (assoc 1 ent1))) )
                ((= (cdr (assoc 2 ent1)) "ID")       (setq lpid   (cdr (assoc 1 ent1))) )
                ((= (cdr (assoc 2 ent1)) "LOGIN")    (setq lpon   (cdr (assoc 1 ent1))) )
                ((= (cdr (assoc 2 ent1)) "LOGON")    (setq lpon   (cdr (assoc 1 ent1))) )
                ((= (cdr (assoc 2 ent1)) "LOGOFF")   (setq lpoff  (cdr (assoc 1 ent1))) )
                ((= (cdr (assoc 2 ent1)) "HISTORIC") (setq lphist (cdr (assoc 1 ent1))) )
              ) ; end cond
              (setq enm1 (entnext enm1))
            ) ; end while
            (textscr)
            (prompt"\e[2J")
            (prompt  "PROJETISTA      ENTRADA                       SAIDA")
            (prompt"\n--------------- ----------------------------- -----------------------------")
            (prompt (strcat "\n" (rfill lpid 16 " ") lpon "  " lpoff) )
            (prompt (strcat "\n=> "        (substr lphist 1 67) "\n") )
          ) ; end progn
          (prompt "\nERR: Nao foi encontrada a informacao desejada.")
  ) ; end if
  (setvar "cmdecho" 1)
  (princ)
) ; end defun

(princ)
