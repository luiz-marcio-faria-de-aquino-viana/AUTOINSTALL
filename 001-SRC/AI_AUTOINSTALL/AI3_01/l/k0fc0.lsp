
;;
;; K0FC0.lsp
;; Copyright (C) 1992-98 by Luiz Marcio F A Viana, 3/19/98
;;

;; c:leader1(): rotina para desenho de indicadores
(defun c:leader1(/ pti pts txt pt0 pt1 pt3 align)

  (initget 1)
  (setq pti (getpoint "\nPonto inicial: "))

  (initget 1)
  (setq pts (getpoint pti "\nPonto final: "))

  (setq txt (getstring 't "\nMenssagem: "))

  (setq
    pt3 (list
          (+ (car  pti) (* (/ (#SCL) (distance pti pts)) (- (car  pts) (car  pti)) 4.0))
          (+ (cadr pti) (* (/ (#SCL) (distance pti pts)) (- (cadr pts) (cadr pti)) 4.0))
        ) ; end list
  ) ; end setq

  (if (< (car pti) (car pts))
    (setq
      align "ml"
      pt0   (polar pts 0 (* 4.0 (#SCL)))
      pt1   (polar pts 0 (* 6.0 (#SCL)))
    ) ; end setq
    (setq
      align "mr"
      pt0   (polar pts pi (* 4.0 (#SCL)))
      pt1   (polar pts pi (* 6.0 (#SCL)))
    ) ; end setq
  ) ; end if

  (command ".undo" "g")

  (setq
    oldecho (acadvar "cmdecho"  0)
    oldblip (acadvar "blipmode" 0)
  ) ; end setq
  (command
    ".pline" pti "w" 0 (#SCL) pt3 "w" 0 0 pts pt0 ""
    ".text" align pt1 (* 1.5 (#SCL)) 0 txt
  ) ; end command
  (setvar "blipmode" oldblip)
  (setvar "cmdecho"  oldecho)

  (command ".undo" "e")
  (princ)
) ; end defun

(princ)
