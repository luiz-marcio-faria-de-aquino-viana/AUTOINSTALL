; K01c0/C2P - MAI/91

; +------------------------------- VARIAVEIS -------------------------------+

;  P1 - Ponto de contado da coluna c/parede                      - Entrada
;  P2 - Ponto indicador do sentido de insercao da coluna         - Entrada
;  A2 - Diametro da coluna                                       - Entrada
;  P3 -+
;  P4  |- Pontos auxiliares                                      - Interna
;  P5 -+  
;  P6 - Ponto diametralmente oposto a P1 (ponto chave)           - Interna
;  A1 - Angulo de determinacao da direcao da parede              - Interna
;  A3 - Distancia entre dois pontos (auxiliar)                   - Interna
;  X1 - Absisa do ponto P1                                       - Interna
;  Y1 - Ordenada do ponto P1                                     - Interna
;  X2 - Absisa do ponto P2                                       - Interna
;  Y2 - Ordenada do ponto P2                                     - Interna
;  X3 - Absisa do ponto P3                                       - Interna
;  Y3 - Ordenada do ponto P3                                     - Interna

; +--------------------------- DEFINICAO DA ROTINA -------------------------+

(defun C:C2P(/ p1 p2 p3 p4 p5 p6 a1 a2 a3 x1 y1 x2 y2 x3 y3)

  (setvar "cmdecho" 0)

; +---------------------------- ENTRADA DE DADOS ---------------------------+

  (setq
    p1 (getpoint "\nPonto de contato: ")
    p2 (getpoint "\nIndique o sentido: ")
    a2 (getdist "\nDiametro da coluna: ")
    a2 (/ a2 #und)
    p3 (osnap p1 "end")
    a1 (angle p3 p1)
    x2 (car p2)
    y2 (cadr p2)
  );endsetq

; +------------------------------- CALCULOS --------------------------------+

  (if (= (cos a1) 0)
    (setq
      p4 (list
           (+ (car p1) (- (car p1) x1)) y1
    )    );endlist,setq
    (setq
      p4 (list
           (+ x2 (* y2 (/ (sin a1) (cos a1)))) 0.0
    )    );endlist,setq
  )
  (setq
    p5 (inters p1 p3 p2 p4 nil)
    a3 (distance p2 p5)
    x1 (car p1)
    x3 (car p5)
    y1 (cadr p1)
    y3 (cadr p5)
    p6 (list
         (+ x1 (* (/ a2 a3) (- x2 x3)))
         (+ y1 (* (/ a2 a3) (- y2 y3)))
  )    );endlist,setq

; +--------------------------- DESENHO DA COLUNA ---------------------------+

  (command
    "circle" "2p" p1 p6
  );endcommand

; +------------------------------ FINALIZACAO ------------------------------+

  (princ)
);enddefun
