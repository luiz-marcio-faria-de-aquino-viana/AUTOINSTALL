; K0fc0/Leader - Fev/92
  
; Variaveis:
;    Pti  - Ponto inicial          - Entrada
;    Pts  - Segundo ponto          - Entrada
;    Txt  - Menssagem              - Entrada
;    Pt3  - Ponto final da seta    - Interno
;    #Scl - Escala do desenho (mm) - Sistema

(defun C:LEADER(/ pti pts txt pt3)  
  
  (setvar "cmdecho" 0)
  (setq
    pti (getpoint "\nPonto inicial: ")
    pts (getpoint pti "\nPonto final: ")
    txt (getstring T "\nMenssagem: ")
    pt3
      (list
        (+ (car pti)
          (* (/ #scl (distance pti pts)) (- (car pts) (car pti)) 4.0)
        );endsoma
        (+ (cadr pti)
          (* (/ #scl (distance pti pts)) (- (cadr pts) (cadr pti)) 4.0)
        );endsoma
      );endlist
  );endsetq
  (setvar "blipmode" 0)
  (command
    "PLINE"
      pti "w" 0 #scl
      pt3 "w" 0 0
      pts
  );endcommand
  (if (< (car pti) (car pts))
    (command
      (polar pts 0 (* 4.0 #scl)) ""
      "text" (polar pts 0 (* 6.0 #scl))
             (* 1.5 #scl) 0 txt
    );endcommand
    (command
      (polar pts pi (* 4.0 #scl)) ""
      "text" "r" (polar pts pi (* 6.0 #scl))
             (* 1.5 #scl) 0 txt
    );endcommand
  );endif
  (setvar "blipmode" 1)
  (princ)
);enddefun
