; K0ac0/FViga - Mar/92
  
; Variaveis:
;    Ptbase  -   Ponto base p/constr do desenho                  - Entrada
;    Ptini   -   Ponto inicial p/contr do desenho                - Entrada
;    Fdiam   -   Diametro do furo                                - Entrada
;    Fespc   -   Especura da viga                                - Entrada
;    Obj1    -   Lista associada a parte da viga q passa p/Ptini - Interna
;    Ptstr   -+
;             +- Pontos que determinam a reta Obj1               - Interna
;    Ptsec   -+
;    Enivel  -   Lista associada ao layer F-furacao              - Interna
;    Ang1    -   Angulo formado p/reta Obj1 e o eixo OX          - Interna
;    Cnivel  -   Nome do layer corrente                          - Interna
;    #Fdiam  -   Contem valor default p/diametro do furo         - Sistema
;    #Fespec -   Contem valor default p/especura da viga         - Sistema

(defun C:FVIGA(/ ptbase ptini fdiam fespc obj1 ptstr ptsec enivel ang1 cnivel)  
  (m:savevars)
  
  (initget 1)
  (setq
    cnivel (getvar "clayer")
    ptbase (getpoint "\nPonto base (ou inicial): ")
    ptini (getpoint "\nPonto inicial (ou ENTER): ")
  );endsetq
  (if (null ptini) (setq ptini ptbase))
  (if (null #fdiam)
    (progn
      (initget 3)
      (setq
        fdiam (getdist "\nDiametro do furo: ")
      );endsetq
    );endprogn
    (progn
      (initget 2)
      (setq
        fdiam (getdist
                (strcat
                  "\nDiametro do furo <"
                  (rtos #fdiam 2 2) ">: "
              ) );endstrcat,dist
      );endsetq
    );endprogn
  );endif
  (if (null #fespc)
    (progn
      (initget 3)
      (setq
        fespc (getdist "\nEspecura da viga: ")
      );endsetq
    );endprogn
    (progn
      (initget 2)
      (setq
        fespc (getdist
                (strcat
                  "\nEspecura da viga <"
                  (rtos #fespc 2 2) ">: "
              ) );endstrcat,dist
      );endsetq
    );endprogn
  );endif
  (if fdiam (setq #fdiam fdiam))
  (if fespc (setq #fespc fespc))
  (setq
    obj1 (entget
           (ssname (ssget ptini) 0)
         );endsetq
  );endsetq
  (if (= (cdr (assoc 0 obj1)) "LINE")
    (progn
      (setq
        ptstr (cdr (assoc 10 obj1))
        ptsec (cdr (assoc 11 obj1))
      );endsetq
      (if (> (car ptstr) (car ptsec))
        (setq ang1 (angle ptsec ptstr))
        (setq ang1 (angle ptstr ptsec))
      );endif
      (setq enivel (tblsearch "LAYER" "F-FURACAO"))
      (command "layer")
      (if enivel
        (if (zerop (rem (cdr (assoc 70 enivel)) 2.0))
          (command "s" "F-furacao" "")
          (command "t" "F-furacao" "s" "F-furacao" "")
        );endif
        (command "m" "F-furacao" "")
      );endif
      (command
        "pline" ptini "w" 0 ""
                (polar (getvar "lastpoint")
                       (+ ang1 (/ pi 2.0))
                       #fespc
                );endpolar,setq
                (polar ptini
                       ang1
                       #fdiam
                );endpolar
                (polar (getvar "lastpoint")
                       (+ ang1 (/ pi 2.0))
                       #fespc
                );endpolar
                ptini "c"
        "layer" "s" cnivel ""
      );endcommand
    );endprogn
    (prompt "\n--- Objeto encontrado nao e uma linha ---")
  );endif
  (m:restorevars)
  (princ)
);enddefun
