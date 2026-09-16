
;;
;; sname.lsp
;;
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 5/13/96
;;

;;
;; name: funcao que renomeia os nomes de simbolos com mais de 20 caracteres

(defun name(s / ss nm)
  (setq MAX 20) ;; numero maximo de caracteres
  (setq cnt 0)
  (setq ss (tblnext s t))
  (while ss
    (setq nm (cdr (assoc 2 ss)))
    (if (> (strlen nm) MAX)
      (progn
        (command
          ".rename"
             s
             nm
             (strcat "$" (itoa cnt) (substr nm 1 (- MAX (strlen (itoa cnt)))) )
        ) ; end command
        (setq cnt (+ 1 cnt))
      ) ; end progn
    ) ; end if
    (setq ss (tblnext s))
  ) ; end while
) ; end defun

;;
;; sname: rotina que ajusta todos os nomes de simbolos com mais de 20 caracteres

(defun c:sname(/ SYMLST s)
  (setq SYMLST '("block"
                 "dimstyle"
                 "layer"
                 "ltype"
                 "style"
                 "ucs"
                 "view"
                 "vport") )
  (foreach s SYMLST (name s))
  (princ)
) ; end defun

(princ)
