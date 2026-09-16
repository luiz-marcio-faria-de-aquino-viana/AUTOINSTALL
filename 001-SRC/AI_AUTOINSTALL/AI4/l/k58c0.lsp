
;;
;; K58C0.lsp
;; Copyright (C) by Paulo Lincoln de Oliveira, 3/15/96
;;
;; OFFCHG: rotina para tracar offset de um objeto trocando layer

(setq #OFFDIST "Through")   ;; valor default distancia do offset

(defun c:offchg(/ oldech oldhigh dist nnivel ent pt entl listent)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (setq oldhigh (getvar "highlight"))
  (initget "Through")
  (if (= #OFFDIST "Through")
    (setq dist (getdist (strcat "\nOffset distance or Through <" #OFFDIST ">: ")))
    (setq dist (getdist (strcat "\nOffset distance or Through <" (rtos #OFFDIST 2 2) ">: ")))
  ) ; end if
  (if dist (setq #OFFDIST dist))
  (if (setq ss1 (entsel "\nPick object to select layer or ENTER: "))
    (setq nnivel (cdr (assoc 8 (entget (car ss1)))) )
    (progn   
      (setq nnivel (getstring (strcat "\nNew layer <" (getvar "clayer") ">: ")))
      (if (= nnivel "") (setq nnivel (getvar "clayer")) )
    ) ; end progn 
  ) ; end if
  (while (setq ent (entsel "\nSelect object to offset: "))
    (initget 1)
    (setq pt (getpoint "\nSide to offset? "))
    (setvar "highlight" 0)
    (command
      ".offset" #OFFDIST ent pt ""
      ".change" "l" "" "p" "la" nnivel ""
    ) ; end command
    (setvar "highlight" oldhigh)
  ) ; end while
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
