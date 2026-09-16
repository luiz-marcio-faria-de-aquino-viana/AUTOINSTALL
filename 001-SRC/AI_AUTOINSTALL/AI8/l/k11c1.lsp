; K11c0/P-PASSA - Mai/91

(defun C:P-PASSA(/ p1 p2 p3 p4 X1 Y1 X2 Y2 A1 A2)
  (setvar "CMDECHO" 0)
  (setq P1 (getpoint "\nPonto inicial: "))
  (setq P2 (getpoint P1 "\nPonto final: "))
  (setq A1 (distance P1 P2))
  (setq A2 (* 4.0 (#SCL)))
  (setq X1 (car P1))
  (setq X2 (car P2))
  (setq Y1 (cadr P1))
  (setq Y2 (cadr P2))
  (setq P3 (list (+ X1 (* (/ A2 A1) (- X2 X1))) (+ Y1 (* (/ A2 A1) (- Y2 Y1)))))
  (setq P4 (list (- X2 (* (/ A2 A1) (- X2 X1))) (- Y2 (* (/ A2 A1) (- Y2 Y1)))))
  (command
    "PLINE" P1 "W" 0 (#SCL) P3 "W" 0 0 P4 "W" (#SCL) 0 P2 ""
  )
  (princ)
);enddefun
