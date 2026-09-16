
;;
;; C:INDIC:: indicador de equipamento

(defun C:INDIC(/ pti ptf)
  (m:savevars)

  (initget 1)
  (setq pti (getpoint "\nPonto inicial: "))
  (initget 1)
  (setq ptf (getpoint pti "\nPonto final: "))
  (setq txt (getstring t "\nTexto: "))
  (setvar "blipmode" 0)
  (command
    ".undo" "g"
    ".line" pti (polar pti (angle pti ptf) (- (distance pti ptf) (* 2.5 (#SCL))) ) ""
    ".circle" ptf (* 2.5 (#SCL))
    ".text" "m" ptf (* 1.5 (#SCL)) 0 txt
  ) ; end command
  (setvar "blipmode" 1)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
