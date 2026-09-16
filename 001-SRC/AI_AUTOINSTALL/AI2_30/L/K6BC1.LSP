
;;
;; K6BC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 7/3/97
;;

;; edt_getobject(): funcao de entrada de dados da rotina de desenho de eletrodutos
;;  ptb - ponto base de desenho dos eletrodutos
(defun edt_getobject(ptb)
  (setq
    rst nil
    flg 't
  ) ; end setq
  (while flg
    (if ptb
      (setq pti (getpoint ptb "\nSelecione objeto/Proximo ponto: "))
      (setq pti (getpoint     "\nSelecione objeto: "))
    ) ; end if
    (if pti
      (if (setq ss (ssget pti))
        (progn
          (if (etipo (setq enm (ssname ss 0)) 0)
            (setq
              rst (list enm pti)
              flg nil
            ) ; end setq
            (prompt "\nERR: Objeto selecionado nao e um aparelho eletrico.")
          ) ; end if
        ) ; end progn
        (setq rst (list nil pti))
      ) ; end if
      (setq flg nil)
    ) ; end if
  ) ; end while
  rst
) ; end defun

;; c:edt(): rotina para desenho dos eletrodutos
(defun c:edt()
  (setq oldech (acadvar "cmdecho" 0))
  (if (car (setq ss1 (edt_getobject nil)) )
    (progn
      (setq
        enm1 (car ss1)
        pt1  (osnap (cadr ss1) "node")
      ) ; end setq
      (if (null pt1) (setq pt1 (cadr ss1)) )
      (command ".pline" pt1 "w" (/ 15.0 #UND) "")
      (while (car (setq ss2 (edt_getobject pt1)) )
        (setq
          enm2 (car ss2)
          pt2  (osnap (cadr ss2) "node")
        ) ; end setq
        (if (null pt1) (setq pt1 (cadr ss1)) )
        (command pt2)
      ) ; end while
      (command "")
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

(princ)
