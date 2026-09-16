
;;
;; K53C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 3/13/96.
;;

;; c:xfin(): rotina para associar um arquivo de referencia externa ao desenho
(defun c:xfin(/ oldech blk ffn fil pt0 f)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (if (= (getvar "dwgtitled") 1)
    (progn
      (setq ffn (getfiled "Selecione o arquivo de referencia..." (V:PRJ "*.dwg") "dwg" 2))
      (if (setq ffn (findfile ffn))
        (progn
          (setq
            ffn (strhead ffn ".")
            blk (getfilename ffn)
          ) ; end setq

          (setq fil (strcat (getdwgdrive) (getdwgpath) "\\" (getdwgname) ".xrf") )

          (setq pt0 (getpoint "\nPonto de insercao <Origem>: "))
          (if (null pt0) (setq pt0 '(0.0 0.0 0.0)) )

          (command ".xref" "a" ffn pt0 "" "" "")

          (setq f (open fil "a"))
          (write-line (strcat blk "=@" ffn) f)
          (setq f (close f))
        ) ; end progn
      ) ; end if
    ) ; end progn
    (prompt "\nERR: Este arquivo ainda nao foi gravado.")
  ) ; end if

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
