
;;
;; K01C0.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 1/7/2000
;;

;; c:ai_insertvs1p(): rotina para insercao de blocos em vista frontal sem rotacao
(defun c:ai_insertvs1p(/ oldech blk pti)
  (setq oldech (ai_svar "cmdecho" 0))

  (if (or (null #BLCK) (= #BLCK ""))
    (progn
      (initget 1)
      (setq blk (getstring "\nNome do bloco: "))
    ) ;end progn
    (setq blk (getstring (strcat "\nNome do bloco <" #BLCK ">: ")) )
  ) ; end if
  (if (/= blk "") (setq #BLCK blk))

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (ai_insert (V:AID #BLCK) pti (#SCL) 0.0)

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
