; K2cc0/Dutos - Jul/92

; Variaveis:
;    Sub00   - Subrotina p/tracamento do duto                - Subrotina
;    dt      - Dimensao do duto                              - Entrada
;    pta     - Ponto inicial do duto                         - Entrada/Interna
;    ptb     - Ponto final do duto                           - Entrada
;    ent1    - Selecao do primeiro duto                      - Interna
;    ent2    - Selecao do segundo duto                       - Interna
;    pt10a   - Ponto inicial p/reta ENT1 0                   - Interna
;    pt10b   - Ponto final p/reta ENT1 0                     - Interna
;    pt11a   - Ponto inicial p/reta ENT1 1                   - Interna
;    pt11b   - Ponto final p/reta ENT1 1                     - Interna
;    pt20a   - Ponto inicial p/reta ENT2 0                   - Interna
;    pt20b   - Ponto final p/reta ENT2 0                     - Interna
;    pt21a   - Ponto inicial p/reta ENT2 1                   - Interna
;    pt21b   - Ponto final p/reta ENT2 1                     - Interna
;    obj1a   - Reta ENT1 0                                   - Interna
;    obj1b   - Reta ENT1 1                                   - Interna
;    obj2a   - Reta ENT2 0                                   - Interna
;    obj2b   - Reta ENT2 1                                   - Interna
;    inta1   - Intersecao ENT1 0-ENT2 0                      - Interna
;    inta2   - Intersecao ENT1 0-ENT2 0 (com indeterminacao) - Interna
;    intb1   - Intersecao ENT1 1-ENT2 1                      - Interna
;    intb2   - Intersecao ENT1 1-ENT2 1 (com indeterminacao) - Interna
;    ptc0  -+
;    ptc1   +- Pontos de suporte aos calculos                - Interna
;    ptc2  -+
;    pt10c  - Novo valor p/PT10B                             - Interna
;    pt11c  - Novo valor p/PT11B                             - Interna
;    pt20c  - Novo valor p/PT20A                             - Interna
;    pt21c  - Novo valor p/PT21A                             - Interna
;    #duto  - Valor default p/dimensao do duto               - Sistema
;    #dtype - Eixo de insercao do duto                       - Sistema
;    (#UND)   - Sistema de unidade em uso (mm=1)               - Sistema

; SUB00 - Subrotina p/tracamento de dutos

; Variaveis:
;    ptx    - Ponto inicial na colocacao do duto             - Entrada
;    pty    - Ponto final na colocacao do duto               - Entrada
;    #duto  - Valor default da dimensao do duto              - Sistema
;    #dtype - Eixo guia para insercao do duto                - Sistema

(defun SUB00(ptx pty)
  (setvar "cmdecho" 0)
  (setvar "blipmode" 0)
  (setvar "highlight" 0)
  (cond
    ((= #dtype 0)(command
                   "line" ptx pty ""
                   "select" "l" ""
                   "line" (polar ptx (- (angle ptx pty)
                                        (/ pi 2.0)
                                     );endif
                                 #duto
                          );endpolar
                          (polar pty (- (angle ptx pty)
                                        (/ pi 2.0)
                                     );endif
                                 #duto
                          );endpolar
                          ""
    )            );endcommand,case
    ((= #dtype 1)(command
                   "line" (polar ptx (+ (angle ptx pty)
                                        (/ pi 2.0)
                                     );endif
                                 (* #duto 0.5)
                          );endpolar
                          (polar pty (+ (angle ptx pty)
                                        (/ pi 2.0)
                                     );endif
                                 (* #duto 0.5)
                          );endpolar
                          ""
                   "select" "l" ""
                   "line" (polar ptx (- (angle ptx pty)
                                        (/ pi 2.0)
                                     );endif
                                 (* #duto 0.5)
                          );endpolar
                          (polar pty (- (angle ptx pty)
                                        (/ pi 2.0)
                                     );endif
                                 (* #duto 0.5)
                          );endpolar
                          ""
    )            );endcommand,case
    ((= #dtype 2)(command
                   "line" (polar ptx (+ (angle ptx pty)
                                        (/ pi 2.0)
                                     );endif
                                 #duto
                          );endpolar
                          (polar pty (+ (angle ptx pty)
                                        (/ pi 2.0)
                                     );endif
                                 #duto
                          );endpolar
                          ""
                   "select" "l" ""
                   "line" ptx pty ""
    )            );endcommand,case
  );endcond
  (command
    "select" "p" "l" ""
  );endcommand
  (setvar "blipmode" 1)
  (setvar "highlight" 1)
  (ssget "p")
);enddefun


; K2cc0/Dutos - Base do programa

(defun c:Dutos(/ dt pta ptb ent1 ent2 pt10a pt10b pt11a pt11b
                 pt20a pt20b pt21a pt21b obj1a obj1b obj2a obj2b
                 inta1 inta2 intb1 intb2 ptca ptc1 ptc2 pt10c
                 pt11c pt20c pt21c)
  (m:savevars)
  
  (or #duto
      (setq
        #duto (/ 300.0 (#UND))
  )   );endsetq,or
  (or #dtype
      (setq
        #dtype 1
  )   );endsetq,or
  
  (setq
    dt (getdist (strcat "\nLargura do duto <"
                        (rtos #duto 2 2) ">: "
       )        );endstrcat,dist
  );endsetq
  (if dt (setq #duto dt))
  
  (initget 1)
  (setq
    pta (getpoint "\nPonto inicial: ")
  );endsetq
  (initget 1)
  (setq
    ptb (getpoint pta "\nSegundo ponto: ")
    ent1 (sub00 pta ptb)
    pta ptb
  );endsetq
  (while (setq
           ptb (getpoint pta "\nProximo vertice: ")
         );endsetq
    (setq
      ent2 (sub00 pta ptb)
      pt10a (cdr (assoc 10
                   (setq
                     obj1a (entget (ssname ent1 0))
                   );endsetq
            )    );endassoc,cdr
      pt10b (cdr (assoc 11 obj1a))
      pt20a (cdr (assoc 10
                   (setq
                     obj2a (entget (ssname ent2 0))
                   );endsetq
            )    );endassoc,cdr
      pt20b (cdr (assoc 11 obj2a))
      pt11a (cdr (assoc 10
                   (setq
                     obj1b (entget (ssname ent1 1))
                   );endsetq
            )    );endassoc,cdr
      pt11b (cdr (assoc 11 obj1b))
      pt21a (cdr (assoc 10
                   (setq
                     obj2b (entget (ssname ent2 1))
                   );endsetq
            )    );endassoc,cdr
      pt21b (cdr (assoc 11 obj2b))
      inta1 (inters pt10a pt10b pt20a pt20b)
      inta2 (inters pt10a pt10b pt20a pt20b nil)
      intb1 (inters pt11a pt11b pt21a pt21b)
      intb2 (inters pt11a pt11b pt21a pt21b nil)
    );endsetq
    (cond
      ((and
         inta1 (or (null intb1)
                   (equal intb1 pta)
       )       );endor,and
       (setq
         ptc0 (polar inta2 (angle intb2 inta2)
                           (/ (distance inta2 intb2) 2.0)
              );endpolar
         ptc1 (polar ptc0 (angle inta2 intb2)
                          (* #duto 0.5)
              );endpolar
         ptc2 (polar ptc0 (angle inta2 intb2)
                          (* #duto 1.5)
              );endpolar
         pt11c (polar ptc0 (angle pt10b pt11b)
                           (* #duto 1.5)
               );endpolar
         pt21c (polar ptc0 (angle pt20a pt21a)
                           (* #duto 1.5)
               );endpolar
         pt10c (polar ptc0 (angle pt10a pt11a)
                           (* #duto 0.5)
               );endpolar
         pt20c (polar ptc0 (angle pt20b pt21b)
                           (* #duto 0.5)
               );endpolar
      ));endsetq,case
      ((and
         intb1 (or (null inta1)
                   (equal inta1 pta)
       )       );endor,and
       (setq
         ptc0 (polar intb2 (angle inta2 intb2)
                           (/ (distance inta2 intb2) 2.0)
              );endpolar
         ptc2 (polar ptc0 (angle intb2 inta2)
                          (* #duto 0.5)
              );endpolar
         ptc1 (polar ptc0 (angle intb2 inta2)
                          (* #duto 1.5)
              );endpolar
         pt10c (polar ptc0 (angle pt11b pt10b)
                           (* #duto 1.5)
               );endpolar
         pt20c (polar ptc0 (angle pt21a pt20a)
                           (* #duto 1.5)
               );endpolar
         pt11c (polar ptc0 (angle pt11a pt10a)
                           (* #duto 0.5)
               );endpolar
         pt21c (polar ptc0 (angle pt21b pt20b)
                           (* #duto 0.5)
               );endpolar
      ));endsetq,case
    );endcond
    (entmod
      (subst (cons 11 pt10c) (assoc 11 obj1a) obj1a)
    );endentmod
    (entmod
      (subst (cons 11 pt11c) (assoc 11 obj1b) obj1b)
    );endentmod
    (entmod
      (subst (cons 10 pt20c) (assoc 10 obj2a) obj2a)
    );endentmod
    (entmod
      (subst (cons 10 pt21c) (assoc 10 obj2b) obj2b)
    );endentmod
    (setvar "blipmode" 0)
    (command "arc" pt10c ptc1 pt20c
             "arc" pt11c ptc2 pt21c
             "line" (polar pt10c (angle pt10b pt10a)
                                 (/ 100.0 (#UND))
                    );endpolar
                    (polar pt11c (angle pt11b pt11a)
                                 (/ 100.0 (#UND))
                    );endpolar
                    ""
             "line" (polar pt20c (angle pt20a pt20b)
                                 (/ 100.0 (#UND))
                    );endpolar
                    (polar pt21c (angle pt21a pt21b)
                                 (/ 100.0 (#UND))
                    );endpolar
                    ""
    );endcommand
    (setvar "blipmode" 1)
    (setq
      ent1 ent2
      pta ptb
    );endsetq
  );endwhile
  (command
    "line" (cdr (assoc 11
                  (entget (ssname ent1 0))
           )    );endassoc,cdr
           (cdr (assoc 11
                  (entget (ssname ent1 1))
           )    );endassoc,cdr
           ""
  );endcommand

  (m:restorevars)
  (princ)
);enddefun
