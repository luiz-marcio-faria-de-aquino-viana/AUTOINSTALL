; K04c0/Circuito - Jun/91

; +--------------------------- VARIAVEIS ---------------------------------+

;   P1   - Ponto inicial p/insercao dos circuitos               - Entrada
;   P2   - Ponto que determina a direcao de insercao dos circ   - Entrada
;   P3  --+
;   P4    |
;   X1    |
;   Y1    |
;   X2    |
;   Y2    |
;   X3    |- Variaveis auxiliares                               - Interna
;   Y3    |
;   X4    |
;   Y4    |
;   A1    |
;   A2  --+
;   N1   - Condutor ?                                           - Entrada
;   (#SCL) - Valor da escala de trabalho (mm=1)                   - Sistema

; +------------------------- DEFININDO ROTINA ----------------------------+

(defun C:CIRCUITO(/ p1 p2 p3 p4 x1 y1 x2 y2 x3 y3 x4 y4 a1 a2 n1)
  (setvar "cmdecho" 0)

; +------------------------- ENTRADA DE DADOS ----------------------------+

  (setq
    p1 (getpoint "\nPonto inicial: ")
    p2 (getpoint p1 "\nMarque direcao: ")
    p3 p1
    x1 (car p1)
    x2 (car p2)
    y1 (cadr p1)
    y2 (cadr p2)
    a1 (distance p1 p2)
    a2 (* 1.0 (#SCL))
    n1 ""
  );endsetq

; +--------------------------- ROTINA BASE -------------------------------+

  (while n1
    (setq
      x3 (car p3)
      y3 (cadr p3)
    );endsetq

    (initget "RTC FS NT TR RT BARRA")
    (setq
      n1 (getkword "\nCondutor: ")
    );endsetq

    (cond
      ((= n1 "RTC") (setq n1 "EL/EL22c00"))
      ((= n1 "FS") (setq n1 "EL/EL1fc00"))
      ((= n1 "RT") (setq n1 "EL/EL21c00"))
      ((= n1 "NT") (setq n1 "EL/EL20c00"))
      ((= n1 "TR") (setq n1 "EL/EL23c00"))
    );endcond

    (setq
      x4 (+ x3 (* (/ a2 a1) (- x2 x1)))
      y4 (+ y3 (* (/ a2 a1) (- y2 y1)))
      p4 (list x4 y4)
    );endsetq

    (if (and n1 (/= n1 "BARRA"))
      (command
        "INSERT" (V:AID n1) p3 (#SCL) "" p4
    ) );endcommand,if

    (setq p3 p4)
  );endwhile

; +--------------------------- FINALIZACAO -------------------------------+

  (princ)
);enddefun
