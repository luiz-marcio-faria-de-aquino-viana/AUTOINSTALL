; K1fc0/T-SOBE - Mai/91

(defun c:T-Sobe(/ p1 p2 p3 p4 p5 a1 a2 n1 n2 x1 y1 x2 y2)
  (setvar "CMDECHO" 0)
  (setq P1 (getpoint "\nPonto inicial: "))
  (setq P2 (getpoint P1 "\nPonto suporte: "))
  (setq N1 (getstring "\nTipo de prumada (AP,TQ,...): "))
  (setq N2 (getstring T "\nDiametro da tubulacao: "))
  (setq X1 (car P1))
  (setq X2 (car P2))
  (setq Y1 (cadr P1))
  (setq Y2 (cadr P2))
  (command
  	"LINE" P1 P2 ""
  )
  (setq A2 (* 6.0 #scl))
  (if (> X2 X1)
  	(command
  		"LINE" P2 (strcat "@" (rtos (* 3.0 A2) 2 6) "<0") ""
  		"CIRCLE" (strcat "@" (rtos (* 1.5 A2) 2 6) "<180") A2
  		"PLINE" (strcat "@" (rtos (* 1.5 A2) 2 6) "<0") "W" (* 1.0 #scl) 0 (strcat "@" (rtos (* 4.0 #scl) 2 6) "<0") ""
  	)
  	(command
  		"LINE" P2 (strcat "@" (rtos (* 3.0 A2) 2 6) "<180") ""
  		"CIRCLE" (strcat "@" (rtos (* 1.5 A2) 2 6) "<0") A2
  		"PLINE" (strcat "@" (rtos (* 1.5 A2) 2 6) "<180") "W" (* 1.0 #scl) 0 (strcat "@" (rtos (* 4.0 #scl) 2 6) "<180") ""
  	)
  )
  (if (> X2 X1)
  	(setq P4 (mapcar '+ P2 (list (* 1.5 A2) 0)))
  	(setq P4 (mapcar '- P2 (list (* 1.5 A2) 0)))
  )
  (setq P5 (list (car P4) (- (cadr P4) (* 3.0 #scl))))
  (setq P4 (list (- (car P4) (* 3.0 #scl)) (+ (cadr P4) (* 2.0 #scl))))
  (command
  	"TEXT" "M" P4 (* 1.5 #scl) 0 N1
  	"TEXT" "M" P5 (* 1.5 #scl) 0 N2
  )
  (princ)
);enddefun
