
;;
;; K12C0.lsp
;; Copyright (C) 1991-98 by Luiz Marcio F A Viana, 3/24/98
;;

;; c:p-sobe(): rotina para desenho de seta indicadora de prumada que sobe
(defun c:p-sobe(/ oldecho oldblip AWIDTH AHEIGHT MINHEIGHT NORMHEIGHT pti ptf dst vt0 vt)
  (m:savevars)

  (setq
    AWIDTH     (*  1.0 (#SCL))
    AHEIGHT    (*  4.0 (#SCL))
    MINHEIGHT  (*  2.5 AHEIGHT)
    NORMHEIGHT (* 15.0 (#SCL))
  ) ; end setq

  (initget 1)
  (setq pti (getpoint "\nPonto inicial: "))

  (initget 1 "Padrao")
  (setq ptf (getpoint pti "\n<Ponto final>/Padrao: "))

  (if (= ptf "Padrao")
    (progn
      (initget 1)
      (setq ptf (getpoint pti "\nDirecao da seta: "))
      (setq dst (- NORMHEIGHT AHEIGHT))
    ) ; end progn
    (progn
      (setq dst (distance pti ptf))
      (if (< dst MINHEIGHT)
        (setq dst (- MINHEIGHT AHEIGHT))
        (setq dst (- dst AHEIGHT))
      ) ; end if
    ) ; end progn
  ) ; end if

  (setq
    vt0 (vtmul AHEIGHT (vtunit (mapcar '- ptf pti)) )
    vt  (vtmul dst     (vtunit (mapcar '- ptf pti)) )
  ) ; end setq

  (setq oldecho (acadvar "cmdecho" 0))

;  (command ".undo" "g")

  (setq oldblip (acadvar "blipmode" 0))
  (command
    ".pline"
      pti "w" 0 0
      (mapcar '+ pti vt) "w" (#SCL) 0
      (mapcar '+ pti vt vt0) ""
  ) ; end command
  (setvar "blipmode" oldblip)

;;  (command ".undo" "e")

  (m:restorevars)
  (princ)
) ; end defun

(princ)
