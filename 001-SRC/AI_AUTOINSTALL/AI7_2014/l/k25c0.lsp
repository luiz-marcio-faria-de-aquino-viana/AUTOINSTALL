; K25c0/CORRetor - Abr/92

; Variaveis:
;    obj1 - Var que adquire ENAME de todos os elementos do arq  - Interna
;    ent1 - Var que adquire ENTITY LIST de todos os elem do arq - Interna

(setvar "cmdecho" 0)

(if (null (or (tblsearch "block" "ES-crrt")
              (tblsearch "block" "SET0cc00")
    )     );endor,null
  (progn
    (prompt "\n--- Executando programa CORRetor ---\nAguarde... ")
    (setq obj1 (entnext))
    (while obj1
      (setq ent1 (entget obj1))
        (if (and
              (= (cdr (assoc 0 ent1)) "POLYLINE")
              (or
                (= (cdr (assoc 8 ent1)) "ES-PRIMARIO")
                (= (cdr (assoc 8 ent1)) "ES-SECUNDARIO")
                (= (cdr (assoc 8 ent1)) "ES-VENTILACAO")
                (= (cdr (assoc 8 ent1)) "ES-APLUVIAL")
              );endor
            );endand
              (progn
                (setq
                  ent1 (subst
                         (cons 40 (/ (cdr (assoc 40 ent1)) 2.0))
                         (assoc 40 ent1)
                         ent1
                       );endsubst
                  ent1 (subst
                         (cons 41 (/ (cdr (assoc 41 ent1)) 2.0))
                         (assoc 41 ent1)
                         ent1
                       );endsubst
                );endsetq
                (entmod ent1)
              );endprogn
        );endif
      (setq obj1 (entnext obj1))
    );endwhile
    (command "insert" (V:AID "SET/SET0cc00") "0,0" 1 1 0)
    (setq
      obj1 nil
      ent1 nil
    );endsetq
    (prompt "Ok.")
  );endprogn
);endif
(princ)
