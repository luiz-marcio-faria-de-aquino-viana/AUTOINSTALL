
;;
;; K96C0.lsp
;; Copyright (C) 1999 by Luiz Marcio F A Viana, 1/5/2000
;;

;; c:inser0(): rotina para insercao de pontos com rotacao (=0)
(defun c:inser0(/ blk pti)
  (if (or (null #BLCK) (= #BLCK ""))
    (progn
      (initget 1)
      (setq blk (getstring "\nNome do bloco: "))
    ) ; end progn
    (setq blk (getstring (strcat "\nNome do bloco <" #BLCK ">: ")))
  ) ; end if
  (if (/= blk "") (setq #BLCK blk))

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (setq blk (getfilename #BLCK))
  (ai_insert (V:AID #BLCK) pti (/ 1.0 (#UND)) 0.0)

  (princ)
) ; end defun

(princ)
