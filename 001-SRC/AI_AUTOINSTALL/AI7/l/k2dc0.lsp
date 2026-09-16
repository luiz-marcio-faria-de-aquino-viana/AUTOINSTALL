; K2dc0/TRansf - Ago/92

; Variaveis:
;    Ptbase - Ponto de colocacao da transformacao          - Entrada
;    Duto   - Diametro final da transformacao              - Entrada
;    Pt1    - Ponto da reta de referencia                  - Entrada/Interna
;    Pt2    - Ponto da reta de referencia                  - Entrada/Interna
;    Pt3    - Ponto final da transformacao                 - Interna
;    Ft1    - Fator de transformacao (1/4)                 - Entrada
;    Ft2    - Fator de transformacao (1/7)                 - Entrada
;    #ttype - Eixo de insercao da transformacao            - Sistema
;    #duto  - Diametro inicial da transformacao            - Sistema
;    #ft1   - Valor default p/fator de transformacao (1/4) - Sistema
;    #ft2   - Valor default p/fator de transformacao (1/7) - Sistema
;    (#UND)   - Sistema de unidade em uso (mm=1)             - Sistema

(defun c:TRansf(/ ptbase duto pt1 pt2 pt3 ft1 ft2)
  (setvar "cmdecho" 0)
  
  (or #ttype
    (setq #ttype 1)
  );endor
  (or #duto
    (setq
      #duto (/ 300.0 (#UND))
  ) );endsetq,or
  (or #ft1
    (setq #ft1 4.0)
  );endor
  (or #ft2
    (setq #ft2 7.0)
  );endor
  
  (initget 1)
  (setq
    ptbase (getpoint "\nPrimeiro ponto: ")
  );endsetq
  
  (initget 1)
  (setq
    duto (getdist ptbase (strcat "\nDimensao final do duto <"
                                 (rtos #duto 2 2) ">: "
         )               );endstrcat,dist
  );endsetq
  
  (initget 1 "Referencia")
  (setq
    pt1 (getpoint ptbase "\nReferencia/<Direcao>: ")
  );endsetq
  
  (if (= pt1 "Referencia")
    (progn
      (prompt "\n--- Informe reta de referencia ---")
      (initget 1)
      (setq
        pt1 (getpoint "\nPrimeiro ponto: ")
      );endsetq
      (initget 1)
      (setq
        pt2 (getpoint pt1 "\nOutro ponto: ")
      );endsetq
    );endprogn
    (setq
      pt2 pt1
      pt1 ptbase
  ) );endsetq,if
  
  (cond
    ((= #ttype 1)
     (progn
       (setq
         ft1 (getdist (strcat "\nFator de transformacao 1/<"
                              (rtos #ft1 2 2) ">: "
             )        );endstrcat,dist
       );endsetq
       (if ft1 (setq #ft1 ft1))
    ));endprogn,case
    ((or (= #ttype 0)
         (= #ttype 2)
     );endor
     (progn
       (setq
         ft2 (getdist (strcat "\nFator de transformacao 1/<"
                              (rtos #ft2 2 2) ">: "
             )        );endstrcat,dist
       );endsetq
       (if ft2 (setq #ft2 ft2))
    ));endprogn,case
  );endcond
  
  (cond
    ((= #ttype 1)
     (progn
       (setq
         pt3 (polar ptbase (angle pt1 pt2)
                           (* #ft1 (abs
                                     (- #duto duto)
                           )       );endabs,prod
       )     );endpolar,setq
       (command
         "line" (polar ptbase (+ (angle pt1 pt2)
                                 (/ pi 2.0)
                              );endsoma
                              (/ #duto 2.0)
                );endpolar
                (polar pt3 (+ (angle pt1 pt2)
                              (/ pi 2.0)
                           );endsoma
                           (/ duto 2.0)
                );endpolar
                (polar pt3 (- (angle pt1 pt2)
                              (/ pi 2.0)
                           );endsoma
                           (/ duto 2.0)
                );endpolar
                (polar ptbase (- (angle pt1 pt2)
                                 (/ pi 2.0)
                              );endsoma
                              (/ #duto 2.0)
                );endpolar
                ""
       );endcommand
    ));endprogn,case
    ((= #ttype 0)
     (progn
       (setq
         pt3 (polar ptbase (angle pt1 pt2)
                           (* #ft2 (abs
                                     (- #duto duto)
                           )       );endabs,prod
       )     );endpolar,setq
       (command
         "line" ptbase pt3
                (polar pt3 (- (angle pt1 pt2)
                              (/ pi 2.0)
                           );endsoma
                           duto
                );endpolar
                (polar ptbase (- (angle pt1 pt2)
                                 (/ pi 2.0)
                              );endsoma
                              #duto
                );endpolar
                ""
       );endcommand
    ));endprogn,case
    ((= #ttype 2)
     (progn
       (setq
         pt3 (polar ptbase (angle pt1 pt2)
                           (* #ft2 (abs
                                     (- #duto duto)
                           )       );endabs,prod
       )     );endpolar,setq
       (command
         "line" ptbase pt3
                (polar pt3 (+ (angle pt1 pt2)
                              (/ pi 2.0)
                           );endsoma
                           duto
                );endpolar
                (polar ptbase (+ (angle pt1 pt2)
                                 (/ pi 2.0)
                              );endsoma
                              #duto
                );endpolar
                ""
       );endcommand
    ));endprogn,case
  );endcond
  (setq #duto duto)
  (princ)
);enddefun
