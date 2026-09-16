; K2ac0/MQ2S - Out/91

; Variaveis:
;    ptini - Contem o ponto de insercao da maq AR CONDICIONADO - Entrada
;    ang   - Contem o angulo de rotacao da maq AR CONDICIONADO - Entrada
;    prof  - Contem prof da maq                                - Entrada
;    larg  - Contem larg da maq                                - Entrada
;    flag  - 'Flag' Usado p/det entr no loop                   - Interna
;    pi2   - Contem o valor de pi/2                            - Interna
;    ptx  -+
;    ptk1  |
;    ptk2  +- Pontos auxiliares na criacao do desenho          - Interna
;    ptk3  |
;    ptk4 -+
;    #k29a - Valor default p/prof                              - Sistema
;    #k29b - Valor default p/larg                              - Sistema
;    (#UND)  - Unidade a ser utilizada (mm=1)                    - Sistema

(defun c:MQ2S(/ ptini ang prof larg flag pi2 ptx ptk1 ptk2 ptk3 ptk4)
  (m:savevars)
  
  (or #k29a (setq
              #k29a (/ 350.0 (#UND))
  )         );endsetq,or
  (or #k29b (setq
              #k29b (/ 800.0 (#UND))
  )         );endsetq,or
  
  (initget 1)
  (setq
    ptini (getpoint "\nInsert point: ")
  );endsetq
  
  (initget 1)
  (setq
    ang (getangle ptini "\nRotacao angle: ")
    flag t
    pi2 (/ pi 2.0)
  );endsetq
  
  (while (or flag
             (< #k29a (/ 350.0 (#UND)))
             (< #k29b (/ 800.0 (#UND)))
         );endor
    (setq
      flag nil
      prof (getdist ptini (strcat "\nProfundidade (min=35cm) <"
                                  (rtos #k29a 2 2) ">: "
           )              );endstrcat,dist
      larg (getdist ptini (strcat "\nLargura (min=80cm) <"
                                  (rtos #k29b 2 2) ">: "
           )              );endstrcat,dist
    );endsetq
    (if prof (setq #k29a prof))
    (if larg (setq #k29b larg))
  );endwhile
  
  (setvar "blipmode" 0)
  (command
    "pline" ptini "w" 0 ""
            (polar ptini
                   (- ang pi2)
                   (/ #k29b 2.0)
            );endpolar
            (setq
              ptx (polar (getvar "lastpoint")
                         ang #k29a
            )     );endpolar,setq
            (polar (getvar "lastpoint")
                   (+ ang pi2) #k29b
            );endpolar
            (polar (getvar "lastpoint")
                   (+ ang pi) #k29a
            );endpolar
            "c"
    "pline" (polar ptx
                   ang (/ 25.0 (#UND))
            );endpolar
            (polar (getvar "lastpoint")
                   (+ ang pi2) #k29b
            );endpolar
            ""
  );endcommand
  (setq
    ptk1 (polar
           (polar (polar ptini
                         ang (- (/ #k29a 2.0)
                                (/ 150.0 (#UND))
                  )          );enddif,polar
                  (- ang pi2) (/ 150.0 (#UND))
           );endpolar
           (- ang pi2) (/ 200.0 (#UND))
  )      );endpolar,setq
  (repeat 2
   (progn
    (command
      "linetype" "s" "hidden" ""
      "pline" ptk1
              (setq
                ptk2 (polar (getvar "lastpoint")
                            ang (/ 300.0 (#UND))
              )      );endpolar,setq
              (setq
                ptk3 (polar (getvar "lastpoint")
                            (+ ang pi2) (/ 300.0 (#UND))
              )      );endpolar,setq
              (setq
                ptk4 (polar (getvar "lastpoint")
                            (+ ang pi) (/ 300.0 (#UND))
              )      );endpolar,setq
              "c"
      "pline" ptk1 ptk3 ""
      "pline" ptk2 ptk4 ""
      "linetype" "s" "bylayer" ""
    );endcommand
    (setq
      ptk1 (polar ptk1
                  (+ ang pi2) (/ 400.0 (#UND))
    )      );endpolar,setq
  ));endprogn,repeat

  (m:restorevars)
  (princ)
);enddefun
