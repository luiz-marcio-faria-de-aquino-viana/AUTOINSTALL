; K14c0/Pilar - Fev/91

; Variaveis:
;    Cnivel - Nome do layer de trabalho do usuario         - Entrada
;    Ptchv1 - Selecao do tipo de pilar Retangulo/Inclinado - Entrada
;    Ptbase - Ponto base para colocacao do pilar           - Entrada
;    Ptini  - Ponto inicial (insercao) do pilar            - Entrada
;    Angox  - Angulo com relacao a base do pilar           - Entrada/Interno
;    Dist1  - Comprimento da lateral do pilar              - Interno
;    Enivel - Lista associada ao layer F-pilar             - Interno
;    #Scl   - Escala do desenho (mm)                       - Sistema

(defun C:Pilar(/ cnivel ptchv1 ptbase ptini angox dist1 enivel)
  (setvar "cmdecho" 0)
  (setq cnivel (getvar "clayer"))
  
  (initget 1 "Inclinado")
  (setq
    ptchv1 (getpoint "\nPonto base (ou inicial)/Pilar (I)nclinado: ")
  );endsetq
  (if (= ptchv1 "Inclinado")
    (progn
      (initget 1)
      (setq
        ptbase (getpoint "\nPonto base (ou inicial): ")
      );endsetq
    );endprogn
    (setq ptbase ptchv1)
  );endif
  (setq
    ptini (getpoint ptbase "\nPonto inicial (ou ENTER): ")
  );endsetq
  (if (null ptini) (setq ptini ptbase))
  (if #ptdim
    (setq
      ptdim (getpoint
              (strcat "\nDimensoes do pilar (base,alt) <"
                      (rtos (car #ptdim) 2 2) ","
                      (rtos (cadr #ptdim) 2 2) ">: "
            ) );endstrcat,get
    );endsetq
    (progn
      (initget 1)
      (setq
        ptdim (getpoint "\nDimensoes do pilar (base,alt): ")
    ) );endsetq,progn
  );endif
  (if ptdim (setq #ptdim ptdim))
  (if (= ptchv1 "Inclinado")
    (progn
      (initget 1)
      (setq
        angox (getangle ptini "\nInclinacao do pilar (relativo ao ANGbase): ")
      );endsetq
    );endprogn
    (setq angox (/ pi 2.0))
  );endif
  (if (zerop (rem angox pi))
    (progn
      (prompt "\n--- Valor de inclinacao invalido ---")
      (princ)
    );endprogn
    (progn
      (setq
        dist1 (/ (cadr #ptdim) (sin angox))
      );endsetq
      (setq enivel (tblsearch "LAYER" "F-PL_TETO"))
      (command "layer")
      (if enivel
        (if (zerop (rem (cdr (assoc 70 enivel)) 2.0))
          (command "s" "F-pl_teto" "")
          (command "t" "F-pl_teto" "s" "F-pilar" "")
        );endif
        (command "m" "F-pl_teto" "")
      );endif
      (command
        "pline"
          ptini "w" 0 ""
          (polar ptini (getvar "angbase") (car #ptdim))
          (polar (getvar "lastpoint") (+ (getvar "angbase") angox) dist1)
          (polar (getvar "lastpoint") (- (getvar "angbase") pi) (car #ptdim))
          "c"
        "hatch" "u" 45 #scl "n" "l" ""
        "layer" "s" cnivel ""
      );endcommand
    );endprogn
  );endif
  (princ)
);enddefun
