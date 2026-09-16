; K00c0/APTO - Out/91

; +----------------------------- VARIAVEIS --------------------------------+

;   Ptini - Contem o ponto de insercao da figura                 - Entrada
;   Napto - Contem o numero do apartamento que desejamos indicar - Entrada

; +------------------------ DEFINICAO DA ROTINA ---------------------------+

(defun C:APTO(/ ptini napto)

; +------------------------- ENTRADA DE DADOS -----------------------------+

  (m:savevars)

  (initget 1)
  (setq ptini (getpoint "\nPonto inicial (Centro): "))
  (setq napto (getstring "\nNumero do apto: "))
  

; +------------------------- DESENHO DO SIMBOLO ---------------------------+

  (command
    "pline" (list (- (car ptini) (* 12.0 (#scl)))
                  (- (cadr ptini) (* 8.0 (#scl)))
            );endlist
            "w" 0 ""
            (polar (getvar "lastpoint")
                   (/ pi 2.0) (* 16.0 (#scl)) 
            );endpolar
            (polar (getvar "lastpoint")
                   0 (* 24.0 (#scl))
            );endpolar
            "w" (* 1.25 (#scl)) ""
            (polar (getvar "lastpoint")
                   (-(/ pi 2.0)) (* 16.0 (#scl))
            );endpolar
            "c"
   )    



;;  (command "fillet" "r" (* 5.0 (#scl)))


;;  (command "fillet" "p" (entlast))``

  (command "text" "m" (polar ptini
                      (/ pi 2.0) (* 2.5 (#scl))
               );endpolar
               (* 4.0 (#scl)) 0
               "APTO"
  )

  (command
    "text" "m" (polar ptini
                      (-(/ pi 2.0)) (* 2.5 (#scl))
               );endpolar
               (* 4.0 (#scl)) 0
               napto
  );endcommand

; +----------------------------- FINALIZACAO ------------------------------+

  (m:restorevars)
  (princ)
);enddefun
