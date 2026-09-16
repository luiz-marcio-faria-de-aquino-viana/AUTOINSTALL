; K09c0/FLaje - Mar/92

; Variaveis:
;    Ptbase -   Ponto base p/constr do furo                - Entrada
;    Ptini  -   Ponto inicial p/constr do furo             - Entrada
;    Fdim   -   Contem as dimensoes do furo                - Entrada
;    Opcao  -   Contem a opcao p/constr a partir do Centro - Entrada/Interna
;    Enivel -   Lista associada ao layer F-furacao         - Interna
;    Cnivel -   Nome do layer corrente                     - Interna
;    Pttwo  -+
;    Ptthre  +- Variaveis usadas no desenho do furo        - Interna
;    Ptfour -+
;    #Fdim  -   Contem as dimensoes default p/o furo       - Sistema

(defun C:FLAJE(/ ptbase ptini fdim opcao enivel cnivel pttwo ptthre ptfour) 
  (setvar "cmdecho" 0)
  
  (initget 1 "Centro")
  (setq
    cnivel (getvar "clayer")
    ptbase (getpoint "\nPonto base ou (C)entro: ")
  );endsetq
  (if (= ptbase "Centro")
    (progn
      (initget 1)
      (setq
        opcao ptbase
        ptbase (getpoint "\nPonto base: ")
      );endsetq
    );endprogn
    (setq opcao nil)
  );if
  (setq
    ptini (getpoint ptbase "\nPonto inicial (ou ENTER): ")
  );endsetq
  (if (null ptini) (setq ptini ptbase))
  (if #fdim
    (setq
      fdim (getpoint (strcat
                       "\nDimensoes do furo (base,alt) <"
                       (rtos (car #fdim) 2 2) ","
                       (rtos (cadr #fdim) 2 2) ">: "
           )         );endstrcat,get
    );endsetq
    (progn
      (initget 1)
      (setq
        fdim (getpoint "\nDimensoes do furo (base,alt): ")
      );endsetq
    );endprogn
  );endif
  (if fdim (setq #fdim fdim))
  
  (if opcao
    (setq
      ptini (polar (polar ptini
                          (getvar "angbase")
                          (- (/ (car #fdim) 2.0))
                   );endpolar
                   (+ (getvar "angbase") (/ pi 2.0))
                   (- (/ (cadr #fdim) 2.0))
    )       );endpolar,setq
  );endif
  
  (setq
    enivel (tblsearch "LAYER" "F-FURACAO")
  );endsetq
  
  (setvar "blipmode" 0)
  (command "layer")
  (if enivel
    (if (zerop (rem (cdr (assoc 70 enivel)) 2.0))
      (command "s" "F-furacao" "")
      (command "l" "t" "F-furacao" "s" "F-furacao" "")
    );endif
    (command "m" "F-furacao" "")
  );endif
  (command
    "pline" ptini "w" 0 ""
            (setq
              pttwo
                (polar ptini
                       (getvar "angbase")
                       (car #fdim)
            )   );endpolar,setq
            (setq
              ptthre
                (polar (getvar "lastpoint")
                       (+ (getvar "angbase") (/ pi 2.0))
                       (cadr #fdim)
            )   );endpolar,setq
            (setq
              ptfour
                (polar (getvar "lastpoint")
                       (- (getvar "angbase") pi)
                       (car #fdim)
            )   );endpolar;setq
            "c"
    "pline" ptini ptthre ""
    "pline" pttwo ptfour ""
    "layer" "s" cnivel ""
  );endcommand
  (setvar "blipmode" 1)
  (princ)
);enddefun
