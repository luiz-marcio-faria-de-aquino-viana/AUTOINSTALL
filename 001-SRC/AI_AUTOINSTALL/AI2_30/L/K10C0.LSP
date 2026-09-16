; K10c0/P-Desce - MAI/91

(defun C:P-DESCE(/ p1 p2 p3 x1 y1 x2 y2 a1 a2)
  (setvar "CMDECHO" 0)
  (setq
    P1 (getpoint "\nPonto inicial: ")
    P2 (getpoint P1 "\nPonto final: ")
    A1 (distance P1 P2)
    A2 (* 4.0 #scl)
    X1 (car P1)
    X2 (car P2)
    Y1 (cadr P1)
    Y2 (cadr P2)
    P3 (list
         (+ X1 (* (/ A2 A1) (- X2 X1)))
         (+ Y1 (* (/ A2 A1) (- Y2 Y1)))
  )    );endlist,setq
  (command
    "PLINE" P1 "W" 0 #scl P3 "W" 0 0 P2 ""
  );endcommand
  (princ)
);enddefun
