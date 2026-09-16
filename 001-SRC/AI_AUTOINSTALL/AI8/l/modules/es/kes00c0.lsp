
;;
;; KES00C0.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 1/5/2000
;;

;; c:ai_es_bujao(): rotina para inserir um simbolo de bujao
(defun c:ai_es_bujao(/ blk opt pti scl rot)
  (m:savevars)

  (setq blk "ES/ES01C00")

  (initget "40mm 50mm 75mm 100mm 150mm")
  (setq opt (getkword "\nDimensao do bujao (40mm, 50mm, 75mm, 100mm, 150mm) <100mm>: "))
  (if (null opt) (setq opt "100mm"))

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (initget 1)
  (setq rot (getangle pti "\nRotacao <0>: "))
  (if (null rot) (setq rot 0.0))

  (cond
    ( (= opt  "40mm") (setq scl (/ 1.5 (#UND))) )
    ( (= opt  "50mm") (setq scl (/ 3.0 (#UND))) )
    ( (= opt  "75mm") (setq scl (/ 4.0 (#UND))) )
    ( (= opt "100mm") (setq scl (/ 5.0 (#UND))) )
    ( (= opt "150mm") (setq scl (/ 6.0 (#UND))) )
  ) ; end cond

  (ai_insert (V:AID blk) pti scl rot)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
