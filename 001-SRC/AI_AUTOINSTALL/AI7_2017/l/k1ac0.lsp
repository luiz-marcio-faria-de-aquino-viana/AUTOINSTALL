; Pilar Redondo - Fev/92

; Variavel:
;   Cnivel - Nome do layer de trabalho do usuario - Interno
;   Ptbase - Ponto base p/colocacao do pilar      - Entrada
;   Ptini  - Ponto inicial (insercao) do pilar    - Entrada
;   #Diam  - Diametro do pilar                    - Sistema
;   (#SCL)   - Escala do desenho (mm)               - Sistema

(defun c:Redondo(/ cnivel ptbase ptini)
  (setvar "cmdecho" 0)
  (if (null #diam) (setq #diam 0))
  (setq cnivel (getvar "clayer"))
  
  (initget 1)
  (setq
    ptbase (getpoint "\nPonto base (ou inicial): ")
    ptini (getpoint ptbase "\nPonto inicial (ou ENTER): ")
  );endsetq
  (if (null ptini) (setq ptini ptbase))
  (setq
    diam (getdist
           ptini
           (strcat "\nDiametro do pilar <" (rtos #diam 2 2) ">: ")
         );endget
  );endsetq
  (if (not (null diam)) (setq #diam diam))
  (command
    "layer" "t" "F-pl_teto" "m" "F-pl_teto" ""
    "circle" ptini "d" #diam
    "hatch" "u" 45 (#SCL) "n" "l" ""
    "layer" "s" cnivel ""
  );endcommand
  (princ)
);enddefun
