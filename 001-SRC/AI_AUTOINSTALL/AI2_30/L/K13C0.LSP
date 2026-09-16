; PAREDE - Abr/92

; Variaveis:
;   espcp  - Especura da parede                               - Entrada
;   strpt  - Primeiro/proximo ponto                           - Entrada
;   endpt  - Segundo ponto                                    - Entrada
;   selcA  - Selecao do primeiro par de retas                 - Interno
;   selcB  - Selecao do segundo par de retas                  - Interno
;   selCL  - Selecao do par de retas p/comando Close          - Interno
;   ent1A  - Reta 1 do par de retas A                         - Interno
;   ent2A  - Reta 2 do par de retas A                         - Interno
;   ent1B  - Reta 1 do par de retas B                         - Interno
;   ent2B  - Reta 2 do par de retas B                         - Interno
;   ent1C  - Reta 1 do par de retas p/comando Close           - Interno
;   ent2C  - Reta 2 do par de retas p/comando Close           - Interno
;   CLpt   - Ponto inicial p/comando Close                    - Interno
;   i1A1B  - Ponto de intercesao retas 1A/1B                  - Interno
;   i2A2B  - Ponto de intercesao retas 2A/2B                  - Interno
;   i1B1C  - Ponto de intercesao retas 1B/1C                  - Interno
;   i2B2C  - Ponto de intercesao retas 2B/2C                  - Interno
;   #espcp - Valor default para a especura da parede          - Sistema
;   #wtype - Variavel de controle de constr da parede (E/C/D) - Sistema
  
(defun subr00(pta ptb dist)
  (setvar "cmdecho" 0)
  (setvar "highlight" 0)
  (setvar "blipmode" 0)

  (cond
    ((= #wtype 0)
     (command
       "line" pta ptb ""
    ));endcommand,case
    ((= #wtype 1)
     (command
       "line" (polar pta
                     (+ (angle pta ptb)
                        (/ pi 2)
                     );endsum
                     (/ dist 2.0)
              );endpolar
              (polar ptb
                     (+ (angle pta ptb)
                        (/ pi 2)
                     );endsum
                     (/ dist 2.0)
              );endpolar
              ""
    ));endcommand,case
    ((= #wtype 2)
     (command
       "line" (polar pta
                     (+ (angle pta ptb)
                        (/ pi 2)
                     );endsum
                     dist
              );endpolar
              (polar ptb
                     (+ (angle pta ptb)
                        (/ pi 2)
                     );endsum
                     dist
              );endpolar
              ""
    ));endcommand,case
  );endcond

  (command
    "select" "l" ""
  );endcommand

  (cond
    ((= #wtype 0)
     (command
       "line"
          (polar pta
                 (- (angle pta ptb)
                    (/ pi 2)
                 );endsum
                 dist
          );endpolar
          (polar ptb
                 (- (angle pta ptb)
                    (/ pi 2)
                 );endsum
                 dist
          );endpolar
          ""
    ));endcommand,case
    ((= #wtype 1)
     (command
       "line"
          (polar pta
                 (- (angle pta ptb)
                    (/ pi 2)
                 );endsum
                 (/ dist 2.0)
          );endpolar
          (polar ptb
                 (- (angle pta ptb)
                    (/ pi 2)
                 );endsum
                 (/ dist 2.0)
          );endpolar
          ""
    ));endcommand,case
    ((= #wtype 2)
     (command
       "line" pta ptb ""
    ));endcommand,case
  );endcond

  (command
     "select" "p" "l" ""
  );endcommand

  (setvar "highlight" 1)(setvar "blipmode" 1)
  (ssget "p")
);enddefun
  
(defun subr01(list1 mode1 item1)
  (subst (cons mode1 item1)
         (assoc mode1 list1)
         list1
) );endseubstr;enddefun

(defun c:parede(/ espcp strpt endpt selca selcb selcl
                  ent1a ent2a ent1b ent2b ent1c ent2c
                  clpt i1a1b i2a2b i1b1c i2b2c)
  (setvar "cmdecho" 0)
  
  (or #wtype
    (setq #wtype 1)
  );endor
  (or #espcp
    (setq
      #espcp (/ 100.0 #und)
  ) );endsetq,or
  
  (setq
    espcp (getdist (strcat
                    "\nEspecura da parede <"
                    (rtos #espcp 2 2) ">: "
         )        );endstrcat,dist
  );endsetq
  (if espcp (setq #espcp espcp))
  
  (initget 1)
  (setq
    strpt (getpoint "\nPrimeiro vertice: ")
  );endsetq
  
  (initget 1)
  (setq
    endpt (getpoint strpt "\nSegundo vertice: ")
  );endsetq
  
  (setq
    selcA (subr00 strpt endpt #espcp)
    ent1A (entget (ssname selcA 0))
    ent2A (entget (ssname selcA 1))
    CLpt  strpt
    selCL selcA
    strpt endpt
  );endsetq
  
  (while (and CLpt
              (progn (initget "Close")
                     (setq
                       endpt (getpoint strpt "\nProximo vertice: ")
              )      );endsetq,progn
         );endand
    (if (= endpt "Close") (setq
                            endpt CLpt
                            CLpt nil
    )                     );endsetq,if
    (setq
      selcB (subr00 strpt endpt #espcp)
      ent1B (entget (ssname selcB 0))
      ent2B (entget (ssname selcB 1))
      i1A1B (inters (cdr (assoc 10 ent1A)) (cdr (assoc 11 ent1A))
                    (cdr (assoc 10 ent1B)) (cdr (assoc 11 ent1B))
                    nil
            );endinters
      i2A2B (inters (cdr (assoc 10 ent2A)) (cdr (assoc 11 ent2A))
                    (cdr (assoc 10 ent2B)) (cdr (assoc 11 ent2B))
                    nil
            );endinters
      ent1A (subr01 ent1A 11 i1A1B)
      ent1B (subr01 ent1B 10 i1A1B)
      ent2A (subr01 ent2A 11 i2A2B)
      ent2B (subr01 ent2B 10 i2A2B)
    );endsetq
    (if (null CLpt)
      (progn
        (setq
          ent1C (entget (ssname selCL 0))
          ent2C (entget (ssname selCL 1))
          i1B1C (inters (cdr (assoc 10 ent1B)) (cdr (assoc 11 ent1B))
                        (cdr (assoc 10 ent1C)) (cdr (assoc 11 ent1C))
                        nil
                );endinters
          i2B2C (inters (cdr (assoc 10 ent2B)) (cdr (assoc 11 ent2B))
                        (cdr (assoc 10 ent2C)) (cdr (assoc 11 ent2C))
                        nil
                );endinters
          ent1B (subr01 ent1B 11 i1B1C)
          ent1C (subr01 ent1C 10 i1B1C)
          ent2B (subr01 ent2B 11 i2B2C)
          ent2C (subr01 ent2C 10 i2B2C)
        );endsetq
        (entmod ent1C)
        (entmod ent2C)
    ) );endprogn,if
    (entmod ent1B)
    (entmod ent2B)
    (entmod ent1A)
    (entmod ent2A)
    (setq
      ent1A ent1B
      ent2A ent2B
      strpt endpt
  ) );endsetq,while
  (princ)
);enddefun
