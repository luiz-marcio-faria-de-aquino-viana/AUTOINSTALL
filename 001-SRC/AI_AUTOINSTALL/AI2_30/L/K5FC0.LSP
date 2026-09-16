
;;
;; sname.lsp
;; Copyright (C) 1999 by Luiz Marcio F A Viana, 12/13/99
;;

;; sn_filter(): funcao que elimina caracteres invalidos dos nomes dos simbolos
;; s - nome do simbolo a ser processado
(defun sn_filter(s / s1 c)
  (setq s1 "")
  (while (/= (setq c (substr s 1 1)) "")
    (if (or (and (>= c "A") (<= c "Z")) (= c "$") (= c "_") (= c "-"))
      (setq s1 (strcat s1 c))
      (setq s1 (strcat s1 "$"))
    ) ; end if
    (setq s (substr s 2))
  ) ; end while
  s1
) ; end defun

;; sn_rename(): funcao que renomeia os nomes de simbolos com mais de MAXCHR caracteres
;; s - nome do simbolo a ser processado
(defun sn_rename(s / SN_MAX ss nm)
  (setq
    SN_MAX 20		;; numero maximo de caracteres permitido a cada simbolo
    SN_PFX "A$"
    SN_SFX "$"
  ) ; end setq

  (setq cnt 0)

  (setq ss (tblnext s 't))
  (while ss
    (setq nm (sn_filter (cdr (assoc 2 ss))) )
    (if (> (strlen nm) SN_MAX)
      (setq nm (substr (strcat SN_PFX (itoa cnt) SN_SFX nm) 1 SN_MAX))
    ) ; end if
    (entmod (subst (cons 2 nm) (assoc 2 ss) ss))
    (setq cnt (+ 1 cnt))
    (setq ss (tblnext s))
  ) ; end while
) ; end defun

;; c:sname(): rotina que ajusta todos os nomes de simbolos improprios para trabalhar com referencia externa
(defun c:sname(/ SN_TAB s)
  (setq SN_TAB '("block" "dimstyle" "layer" "ltype" "style" "ucs" "view" "vport"))
  (foreach s SN_TAB (sn_rename s))
  (princ)
) ; end defun

(princ)
