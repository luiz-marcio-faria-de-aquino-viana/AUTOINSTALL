;;                                C D T (R)
;; ________________________________________________________________________
;;       Copyright (C) 1995 by TML Software, Inc. All Rights Reserved.
;;
;;  THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
;;  ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR PURPOSE AND OF
;;  MERCHANTABILITY ARE HEREBY DISCLAIMED.
;; ________________________________________________________________________
;;

;; BIBLIOGRAPH:
;;   Instalacoes Eletricas Industriais, Joao Mamede Filho - pg69/71

(defun C:CDT()
  (setq
    TAB '((   126.6 .   "3/8\"") ( 203.6 .   "1/2\"") ( 346.3 .   "3/4\"")
          (   564.1 .     "1\"") ( 962.1 . "1 1/4\"") (1244.1 . "1 1/2\"")
          (  1979.2 .     "2\"") (3327.0 . "2 1/2\"") (4488.8 .     "3\"")
          (  7043.5 . "3 1/2\"")
          (999999.0 . "\nERR: Valor nao encontrado na tabela"))
  ) ; end setq

  (setq flg t)
  (setq ls '())
  (while flg
    (if (null ls)
      (setq dm (getdist "\nDiametro do condutor em (mm): "))
      (progn
         (initget "Undo")
         (setq dm (getdist "\nUndo/<Diametro do condutor em (mm)>: "))
      ) ; end progn
    ) ; end if
    (if dm
      (if (= dm "Undo")
        (setq ls (cdr ls))
        (progn
          (initget 4)
          (if (setq nm (getint "\nNumero de condutores: "))
            (if ls
              (setq ls (append (list (cons dm nm)) ls))
              (setq ls (list (cons dm nm)))
            ) ; end if
            (setq flg nil)
          ) ; end if
        ) ; end progn
      ) ; end if
      (setq flg nil)
    ) ; end if
  ) ; end while

  (setq soma 0)
  (foreach elem ls (setq soma (+ soma (/ (* (cdr elem) pi (expt (car elem) 2.0)) 4.0))) )
  (setq Smin (/ soma 0.33))
  (if (not (zerop soma))
    (progn
      (setq flg nil)
      (foreach dat TAB
        (if (and (>= (car dat) Smin) (null flg))
          (setq 
            Se (cdr dat)
            flg t
          ) ; end setq
        ) ; end if
     ) ; end foreach
     (prompt (strcat "\nDiametro do eletroduto => " Se))
    ) ; end progn
  ) ; end if
  (princ)
) ; end function

(princ)

