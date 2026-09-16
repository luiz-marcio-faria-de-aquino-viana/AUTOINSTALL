; Janela - Nov/91 
  
; Variaveis:
;    Ptb  -   Ponto base (ou inicial)                     - Entrada
;    Pti  -   Ponto inicial                               - Entrada
;    Pt1  -   Marcacao da largura da porta                - Entrada
;    Pt2  -   Marcacao da espessura da parede             - Entrada
;    Pt3  -+
;          +- Ponto p/constr auxiliar na constr da janela - Interna
;    Pt4  -+
;    (#UND) -   Valor da unidade em uso (mm=1)              - Sistema

(defun C:JANELA(/ ptb pti pt1 pt2 pt3 pt4)  
  (m:savevars)
  (setq
    ptb (getpoint "\nPonto base (ou inicial): ")
    pti (getpoint ptb "\nPonto inicial (ou ENTER): ")
  );endsetq
  (if (null pti)
    (setq pti ptb)
  );endif
  (setq
    pt1 (getpoint pti "\nMarque largura da janela: ")
    pt2 (getpoint pti "\nMarque espessura da parede: ")
    pt3 (polar pti (angle pti pt2) (+ (/ (distance pti pt2) 2) (/ 15.0 (#UND))))
    pt4 (polar pti (angle pti pt2) (- (/ (distance pti pt2) 2) (/ 15.0 (#UND))))
  );endsetq
  (command
    "line" pti pt2 ""
    "line" pt1 (polar pt1 (angle pti pt2) (distance pti pt2)) ""
    "line" pt3 (polar pt3 (angle pti pt1) (distance pti pt1)) ""
    "line" pt4 (polar pt4 (angle pti pt1) (distance pti pt1)) ""
  );endcommand
  (m:restorevars)
  (princ)
);enddefun