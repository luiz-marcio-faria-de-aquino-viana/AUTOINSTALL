; K12c0/P-SOBE - Mai/91

(defun c:p-sobe(/ p1 p2 a1 a2 x1 y1 x2 y2 p3)
  (setvar "CMDECHO" 0)
  (setq P1 (getpoint "\nPonto inicial: "))
  (setq P2 (getpoint P1 "\nPonto final: "))
  (setq A1 (distance P1 P2))
  (setq A2 (* 4.0 #scl))
  (setq X1 (car P1))
  (setq X2 (car P2))
  (setq Y1 (cadr P1))
  (setq Y2 (cadr P2))
  (setq P3 (list (- X2 (* (/ A2 A1) (- X2 X1))) (- Y2 (* (/ A2 A1) (- Y2 Y1)))))
  (command
  	"PLINE" P1 "W" 0 0 P3 "W" #scl 0 P2 ""
  )
  (princ)
);enddefun
