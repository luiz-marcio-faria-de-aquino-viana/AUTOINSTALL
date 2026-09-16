
;;
;; K7BC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 5/6/97
;;

;; c:chgmargem: rotina para mudar o tipo de plotagem definido na margem
(defun c:chgmargem()
  (m:savevars)

  (prompt "\nSelecione as margens...")
  (if (setq ss (ssget))
    (progn
      (initget 1 "Estudo Anteprojeto Projeto")
      (setq opt (getkword "\nEtapa do projeto (E)studo preliminar/(A)nteprojeto/(P)rojeto definitivo: ") )
      (cond
        ((= opt "Estudo")      (setq col 1))
        ((= opt "Anteprojeto") (setq col 3))
        ((= opt "Projeto")     (setq col 5))
      ) ; end cond
      (setq
        cnt (sslength ss)
        flg nil
      ) ; end setq
      (command ".change")
      (while (>= (setq cnt (1- cnt)) 0)
        (setq enm (ssname ss cnt))
        (setq ent (entget enm))
        (setq
          tip (cdr (assoc 0 ent))
          blk (cdr (assoc 2 ent))
        ) ; end setq
        (if (and (= tip "INSERT")
                 (or (= blk "SET01C03") (= blk "SET02C03") (= blk "SET03C03")
                     (= blk "SET04C03") (= blk "SET05C03") (= blk "SET06C03")
                     (= blk "SET07C03") (= blk "SET08C03") (= blk "SET09C03")
                     (= blk "SET0AC03") ) )
          (progn
            (command enm)
            (setq flg 't)
          ) ; end progn
        ) ; end if
      ) ; end while
      (if flg
        (command "" "p" "c" col "")
        (progn
          (command "")
          (prompt "\nERR: Nenhuma margem foi encontrada ou selecionada.")
        ) ; end progn
      ) ; end if
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

(princ)
