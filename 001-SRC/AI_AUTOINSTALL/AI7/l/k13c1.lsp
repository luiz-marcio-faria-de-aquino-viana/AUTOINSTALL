
;;
;; K13C0.lsp
;; Copyright (C) 1992-98 by Luiz Marcio F A Viana, 1/3/97
;;

;; #WTYPE - variavel que contem o valor do alinhamento (0-esquerda/1-direita/2-centro)
(setq #WTYPE 1)

;; tgwtype(): funcao de controle do tipo de alinhamento da parede
(defun tgwtype()
  (setq #WTYPE (rem (+ #WTYPE 1) 3))
  (cond
    ( (= #WTYPE 0) (grtext 3 "[ESQUER]") )
    ( (= #WTYPE 1) (grtext 3 "[CENTRO]") )
    ( (= #WTYPE 2) (grtext 3 "[DIREIT]") )
  ) ; end cond
  (princ)
) ; end defun

;; drlin(): funcao que desenha duas linhas parelelas com alinhamento definido por #WTYPE
;;  pta  - ponto inicial da linha de referencia
;;  ptb  - ponto final da linha de referencia
;;  dist - distancia entre as linhas paralelas
(defun drlin(pta ptb dist)
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
  
;; drsubst(): funcao que substitui a funcao lisp 'subst'
;;  list1 - lista da entidade que sera modificada
;;  mode1 - identificador do grupo dxf que sera modificado
;;  item1 - novo valor que sera atribuido ao grupo dxf
(defun subr01(list1 mode1 item1) (subst (cons mode1 item1) (assoc mode1 list1) list1) )

;; c:parede(): comando para desenho de paredes com linhas duplas
(defun c:parede(/ espcp strpt endpt selca selcb selcl
                  ent1a ent2a ent1b ent2b ent1c ent2c
                  clpt i1a1b i2a2b i1b1c i2b2c)
  (setvar "cmdecho" 0)
  
  (or #espcp
    (setq
      #espcp (/ 100.0 (#UND))
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
    selcA (drlin strpt endpt #espcp)
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
      selcB (drlin strpt endpt #espcp)
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
          ent1B (drsubst ent1B 11 i1B1C)
          ent1C (drsubst ent1C 10 i1B1C)
          ent2B (drsubst ent2B 11 i2B2C)
          ent2C (drsubst ent2C 10 i2B2C)
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

(princ)
