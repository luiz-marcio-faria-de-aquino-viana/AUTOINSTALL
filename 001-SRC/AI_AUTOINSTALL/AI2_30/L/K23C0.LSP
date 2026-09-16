; K23c0/GBox - Abr/92

; Variaveis:
;   Ptini  - Ponto inicial (ou Base) para insercao do box  - Entrada
;   Ptbase - Ponto Base p/insercao do box                  - Entrada
;   Ptdesc - Descricao do ponto de gas                     - Entrada
;   Ptkcal - Potencia do ponto que se deseja indicar       - Entrada
;   Numpi  - Valor do numero pi                            - Interna
;   Ang    - Sentido angular do GBox                       - Interna
;   #scl   - Variavel do sistema que contem a escala (mm)  - Sistema

(defun c:GBox(/ ptini ptbase ptdesc ptkcal numpi ang)
  (setvar "cmdecho" 0)
  
  (initget 1)(setq
               ptini (getpoint "\nPonto inicial: ")
             );endsetq
  (initget 1)
  (setq
    ptbase (getpoint "\nPonto suporte: " ptini)
    ptdesc (getstring "\nDescricao do ponto (F0,F4,A0,AA,Axx): ")
    ptkcal  (getstring "\nPotencia (Kcal): ")
    numpi (/ pi 2.0)
  );endsetq
  (if (< (car ptini) (car ptbase))
    (setq ang pi)
    (setq ang 0)
  );endif
  (command
    "pline" ptini "w" 0 ""
            ptbase
            (polar ptbase (setq
                           ang (- ang numpi)
                         );endsetq
                   (* 6.0 #scl)
            );endpolar
            (polar (getvar "lastpoint")
                   (setq
                     ang (- ang numpi)
                   );endsetq
                   (* 12.0 #scl)
            );endpolar
            (polar (getvar "lastpoint")
                   (setq
                     ang (- ang numpi)
                   );endsetq
                   (* 12.0 #scl)
            );endpolar
            (polar (getvar "lastpoint")
                   (setq
                     ang (- ang numpi)
                   );endsetq
                   (* 12.0 #scl)
            );endpolar
            ptbase
            (polar ptbase
                   (+ ang pi)
                   (* 12.0 #scl)
            );endpolar
            ""
    "text" "m" (polar
                 (polar ptbase
                        (+ ang pi)
                        (* 6.0 #scl)
                 );endpolar
                 (/ pi 2.0)
                 (* 3.0 #scl)
               );endpolar
               (* 1.5 #scl) 0 ptdesc
    "text" "m" (polar (getvar "lastpoint")
                      (/ pi -2.0)
                      (* 6.0 #scl)
               );endpolar
               (* 1.5 #scl) 0 ptkcal
  );endcommand
  (princ)
);enddefun
