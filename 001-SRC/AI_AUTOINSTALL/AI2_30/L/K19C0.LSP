
;; K19c0/QdTEXTO - Mai/91
;;
;; modificado em - Nov/95

(defun c:QdTEXTO(/ m1 p1 p2 b1 d1 d2 dx dy n1 n2 px py nx ny ay ax a1) 
  (setvar "CMDECHO" 0)
  (initget 1 "D C E")
  (setq M1 (getkword "Modo de Alinhamento: (D)ireita/(C)entro/(E)squerda: "))
  (setq P1 (getpoint "\nCanto superior esquerdo da tabela: "))
  (setq B1 (getdist P1 "\nAltura da letra: "))
  (setq B1 (* #scl B1))
  (setq D1 (getdist P1 "\nDistancia entre linhas: "))
  (setq D1 (* #scl D1))
  (setq D2 (getdist P1 "\nDistancia entre colunas: "))
  (setq D2 (* #scl D2))
  (cond
    ((= M1 "D") (setq DX (* (/ D2 3) 2)))
    ((= M1 "C") (setq DX (/ D2 2)))
    ((= M1 "E") (setq DX (/ D2 3)))
  ) ; end cond
  (setq DY (* (/ D1 3) 2))
  (setq N1 (getint "\nNumero de linhas: "))
  (setq N2 (getint "\nNumero de colunas: "))
  (setq PX (car P1))
  (setq NX 1)
  (while (and (<= NX N2) (/= A1 "*X"))
  	(setq NY 1)
  	(setq PY (cadr P1))
  	(while (and (<= NY N1) (/= A1 "*X"))
  		(setq A1 (strcase (getstring T ">> Texto (ou *M=MOVE/*E=ERASE/*X=EXIT): ")))
  		(if (= A1 "*M") (progn
                        (setq P2 (getpoint "\nSelecione uma celula: "))
  			(setq AY (+ (fix (/ (abs (- (cadr P1) (cadr P2))) D1)) 1))
  			(setq AX (+ (fix (/ (abs (- (car P1) (car P2))) D2)) 1))
  			(if (and (<= AX N2) (<= AY N1)) (progn
  				(setq PX (+ (car P1) (* (- AX 1) D2)))
  				(setq PY (- (cadr P1) (* (- AY 1) D1)))
  				(setq NY AY)
  				(setq NX AX)
  				))
  			))
                (if (= A1 "*E")
                  (if (and
                        (setq E1 (getpoint "\nPrimeiro canto: "))
                        (setq E2 (getcorner E1 "\nSegundo canto: "))
                      ) ; end and
                      (command ".erase" "w" E1 E2 "")
                  ) ; end if
                ) ; end if
  		(if (and (/= A1 "*M") (/= A1 "*E") (/= A1 "*X"))
                  (progn
  			(cond
                          ((= M1 "D") (command "TEXT" "R" (list (+ PX DX) (- PY DY)) B1 0 A1))
                          ((= M1 "C") (command "TEXT" "C" (list (+ PX DX) (- PY DY)) B1 0 A1))
                          ((= M1 "E") (command "TEXT" (list (+ PX DX) (- PY DY)) B1 0 A1))
                        ) ; end cond
  			(setq PY (- PY D1))
  			(setq NY (+ NY 1))
  		) )
  	)
  	(setq PX (+ PX D2))
  	(setq NX (+ NX 1))
  	)
  (princ)
);enddefun
