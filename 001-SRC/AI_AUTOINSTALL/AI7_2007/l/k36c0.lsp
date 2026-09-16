
;;
;; K36C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 2/7/97
;;

;; mon: funcao de monitoracao de rotinas
;;  monflg - sinalizador de pausa apos apresentacao no video
;;  monlst - lista de variaveis para monitoracao
(defun mon(monflg monlst / monitm)
  (foreach monitm monlst
    (prompt (strcat "\n" monitm "="))
    (princ (eval (read monitm)))
  ) ; end foreach
  (if monflg (getstring "\n= ENTER =========================================="))
) ; end defun

(defun dbg(dbg_foo / dbg_step)
  (setq dbg_prog (cdr dbg_foo))
  (foreach dbg_step dbg_prog
    (progn
      (prompt    "\n => ") (princ dbg_step)
      (prompt    "\n => ") (princ (eval dbg_step))
      (getstring "\n= ENTER ==========================================")
    ) ; end progn
  ) ; end foreach
) ; end defun

(princ)
