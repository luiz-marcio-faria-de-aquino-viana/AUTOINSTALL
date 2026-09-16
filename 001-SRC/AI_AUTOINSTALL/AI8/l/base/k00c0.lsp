
;;
;; K00C0.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 1/6/2000
;;

;; c:ai_insert1p(): rotina para insercao de blocos por um ponto
(defun c:ai_insert1p(/ oldech blk pti rot)
  (m:savevars)

  (if (or (null #AI_BLCK) (= #AI_BLCK ""))
    (progn
      (initget 1)
      (setq blk (getstring "\nNome do bloco: "))
    ) ; end progn
    (setq blk (getstring (strcat "\nNome do bloco <" #AI_BLCK ">: ")))
  );endif
  (if (/= blk "") (setq #AI_BLCK blk))

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (setq rot (getangle pti "\nRotacao <0>: "))
  (if (null rot) (setq rot 0.0))

  (ai_insert (V:AID #AI_BLCK) pti (/ 1.0 (#UND)) rot)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
