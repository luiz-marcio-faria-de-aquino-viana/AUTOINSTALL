
;;
;; K5FC0.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 5/16/2000
;;

;; sname_correct(): funcao que troca os caracteres invalidos nos nomes dos simbolos
;; s - cadeia com o nome do simbolo a ser corrigido
(defun sname_correct(s / s1 c)
  (setq s1 "")
  (while (/= (setq c (substr s 1 1)) "")
    (if (or (= c "$") (= c "-") (= c "_") (and (>= c "A") (<= c "Z")) (and (>= c "0") (<= c "9")) )
      (setq s1 (strcat s1 c))
      (setq s1 (strcat s1 "_"))
    ) ; end if
    (setq s (substr s 2))
  ) ; end while
  s1
) ; end defun

;; sname(): funcao que renomeia os nomes dos simbolos com mais de vinte caracteres
;; sim - tipo de simbolo a ser pesquisado
(defun sname(sim / MAX enm nm)
  (setq MAX 20)		 ;; numero maximo de caracteres

  (setq enm (tblnext sim 't))

  (setq n 0)
  (while enm
    (setq
      oldnm (cdr (assoc 2 enm))
      newnm (sname_correct (strcase oldnm))
    ) ; end setq

    (if (> (strlen oldnm) MAX)
      (progn
        (setq newnm (substr (strcat "$" (itoa n) "$" newnm) 1 MAX))
        (setq n (+ 1 n))
      ) ; end progn
    ) ; end if

    (if (/= oldnm newnm) (command ".rename" sim oldnm newnm))

    (setq enm (tblnext sim))
  ) ; end while
) ; end defun

;; c:sname(): rotina que renomeia todos os nomes de simbolos com mais de vinte caracteres
(defun c:sname(/ SIMLS itm)
  (m:savevars)
  (setq SIMLS '("block" "dimstyle" "layer" "ltype" "style" "ucs" "view" "vport"))
  (foreach itm SIMLS (sname itm))
  (m:restorevars)
  (princ)
) ; end defun

(princ)
