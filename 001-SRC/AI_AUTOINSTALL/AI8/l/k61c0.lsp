
;;
;; K61C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 5/16/96
;;

;; XFPRUNE: elimina arquivo (.xrf) e todas os XREF do arquivo

(defun c:xfprune()
  (m:savevars)

  (initget 1 "Yes No")
  (setq opt1 (getkword "\nEliminar XREFs referenciados no arquivo (.xrf)? "))
  (initget 1 "Yes No")
  (setq opt2 (getkword "\nEliminar XREFs nao referenciados no arquivo (.xrf)? "))
  (initget "PRUNE")
  (if (= (getkword "\nDigite a palavra PRUNE para continuar: ") "PRUNE")
    (progn
      (cond
        ((and (= opt1  "No") (= opt2  "No")) (prompt "\nNada a fazer.")                                )
        ((and (= opt1 "Yes") (= opt2  "No")) (prompt "\nEliminando apenas XREFs referenciados... ")    )
        ((and (= opt1 "Yes") (= opt2 "Yes")) (prompt "\nEliminando todos os XREFs do desenho... ")     )
        ((and (= opt1  "No") (= opt2 "Yes")) (prompt "\nEliminando apenas XREFs nao referenciados... "))
      ) ; end cond

      ;; construindo lista de XREF referenciado
      (setq lxf '())
      (if (findfile (setq ff (strcat (getvar "dwgname") ".xrf")) )
        (progn
          (setq f (open ff "r"))
          (while (setq s (read-line f))
            (setq lxf (append lxf (list (strpiece s 1 "="))) )
          ) ; end while
          (setq f (close f))
        ) ; end progn
      ) ; end if

      (if (= opt1 "Yes")  
        (progn
          ;; eliminacao dos XREFs referenciados no arquivo (.xrf)
          (foreach xf lxf (command ".xref" "d" xf))
          (if lxf (command "del" ff))
        ) ; end progn
      ) ; end if
      (if (= opt2 "Yes")
        (progn
          ;; eliminacao dos XREFs nao referenciados no arquivo (.xrf)
          (setq ent (tblnext "block" t))
          (while ent
            (setq xfn (cdr (assoc  2 ent)))
            (setq flg (cdr (assoc 70 ent)))
            (if (and (= (logand flg 4) 4) (/= xfn xf)) (command ".xref" "d" xf))
            (setq ent (tblnext "block"))
          ) ; end while
        ) ; end progn
      ) ; end if
    ) ; end progn
    (prompt "\nExecucao cancelada a palavra PRUNE nao foi digitada.")
  ) ; end if
  (m:restorevars)
  (princ)
) ; end defun

(princ)
