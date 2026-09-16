; K21c0/CutWall - Mai/92
  
; Variaveis:
;    pt1   - Ponto inicial da janela                      - Entrada
;    pt2   - Segundo ponto da janela                      - Entrada
;    obj1  - Objetos selecionados                         - Interna
;    ent0  - Entidade do primeiro objeto                  - Interna
;    ent1  - Entidade do segundo objeto                   - Interna
;    ent2  - Entidade do terceiro objeto                  - Interna
;    ent3  - Entidade do quarto objeto                    - Interna
;    int0  - Primeiro ponto de intercesao                 - Interna
;    int1  - Segundo ponto de intersecao                  - Interna
;    int2  - Variavel auxiliar ou terceiro ponto de int   - Interna
;    int3  - Quarto ponto de int (se houver)              - Interna
;    cont1 - Contador do primeiro looping                 - Interna
;    cont2 - Contador do numero de intersecoes            - Interna
;    cont3 - Contador do segundo looping                  - Interna
  
(defun c:CutWall(/ pt1 pt2 obj1 ent0 ent1 ent2 ent3
                   int0 int1 int2 int3 cont1 cont2 cont3)
  (m:savevars)

  (prompt "\nSelecione as paredes...")
  
  (initget 1)
  (setq
    pt1 (getpoint "\nPrimeiro corner: ")
  );endsetq
  (initget 1)
  (setq
    pt2 (getcorner pt1 "\nSegundo corner: ")
    obj1 (ssget "c" pt1 pt2)
  );endsetq

  (command ".undo" "g")  

  (if (or (= (sslength obj1) 3)
          (= (sslength obj1) 4)
      );endor
    (progn
      (setq
        ent0 (entget (ssname obj1 0))
        ent1 (entget (ssname obj1 1))
        ent2 (entget (ssname obj1 2))
      );endsetq
      (if (= (sslength obj1) 4)
        (setq
          ent3 (entget (ssname obj1 3))
      ) );endsetq,if
      (if (and
            (= (cdr (assoc 0 ent0)) "LINE")
            (= (cdr (assoc 0 ent1)) "LINE")
            (= (cdr (assoc 0 ent2)) "LINE")
            (or (null ent3)
                (= (cdr (assoc 0 ent3)) "LINE")
            );endor
          );endand
        (progn
          (setq cont1 0)
          (repeat (sslength obj1) (progn
                      (setq
                        cont2 0
                        cont3 0
                        pti (cdr (assoc 10
                                   (eval (read
                                           (strcat "ent" (itoa cont1))
                                   )     );endread,eval
                            )    );endassoc,cdr
                        ptf (cdr (assoc 11
                                   (eval (read
                                           (strcat "ent" (itoa cont1))
                                   )     );endread,eval
                            )    );endassoc,cdr
                      );endsetq
                      (repeat (sslength obj1)
                        (progn
                          (if (set
                                (read (strcat "int" (itoa cont2)))
                                (inters
                                  pti ptf
                                  (cdr (assoc 10
                                         (eval (read
                                                 (strcat "ent" (itoa cont3))
                                         )     );endread,eval
                                  )    );endassoc,cdr
                                  (cdr (assoc 11
                                         (eval (read
                                                 (strcat "ent" (itoa cont3))
                                         )     );endread,eval
                                  )    );endassoc,cdr
                              ) );endinters,endset
                            (setq cont2 (1+ cont2))
                          );endif
                        (setq cont3 (1+ cont3))
                      ) );endprogn,repeat
                      (cond
                       ((= cont2 2)
                         (progn (if (>
                                      (distance pti int0)
                                      (distance pti int1)
                                    );endtest
                                  (setq int2 int0
                                    int0 int1
                                    int1 int2
                                ) );endsetq,if
                                (command
                                  "erase"
                                    (cdr (assoc -1 (eval (read
                                                     (strcat "ent" (itoa cont1))
                                                   )     );endread,eval
                                    )    );endassoc,cdr
                                    ""
                                  "line" pti int0 ""
                                  "line" ptf int1 ""
                                );endcommand
                       ) );endprogn,case
                       ((= cont2 1)
                         (if (< (distance pti int0)
                                (distance ptf int0)
                             );endtest
                           (command
                             "erase"
                               (cdr (assoc -1 (eval (read
                                                (strcat "ent" (itoa cont1))
                                              )     );endread,eval
                               )    );endassoc,cdr
                               ""
                             "line" ptf int0 ""
                           );endcommand
                           (command
                             "erase"
                               (cdr (assoc -1 (eval (read
                                                (strcat "ent" (itoa cont1))
                                              )     );endread,eval
                               )    );endassoc,cdr
                               ""
                             "line" pti int0 ""
                           );endcommand
                       ) );endif,case
                      );endcond
                      (setq cont1 (1+ cont1))
          )         );endprogn,repeat
      ) );endprogn,if
  ) );endprogn,if

  (command ".undo" "e")

  (m:restorevars)
  (princ)
);enddefun
