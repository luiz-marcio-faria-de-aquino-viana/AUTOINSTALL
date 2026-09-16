; K9ac0/FViga - Mar/12
  
; Variaveis:
;    Ptbase  -   Ponto base p/constr do desenho                  - Entrada
;    Ptini   -   Ponto inicial p/contr do desenho                - Entrada
;    Fdim    -   Diametro do furo                                - Entrada
;    Falt    -   Altura do furo                                  - Entrada
;    Fespc   -   Especura da viga                                - Entrada
;    Obj1    -   Lista associada a parte da viga q passa p/Ptini - Interna
;    Ptstr   -+
;             +- Pontos que determinam a reta Obj1               - Interna
;    Ptsec   -+
;    Enivel  -   Lista associada ao layer F-furacao              - Interna
;    Ang1    -   Angulo formado p/reta Obj1 e o eixo OX          - Interna
;    Cnivel  -   Nome do layer corrente                          - Interna
;    #Fdim   -   Contem valor default p/diametro do furo         - Sistema
;    #Falt   -   Contem valor default p/altura do furo           - Sistema
;    #Fespec -   Contem valor default p/especura da viga         - Sistema

(defun C:FVIGA2(/ ptbase ptini ptaux pttxt fdim falt fespc obj1 ptstr ptsec enivel ang1 cnivel PTLEN)  
  (setvar "cmdecho" 0)
  
  (setq ptlen (* 30.0 #scl))
  
  (initget 1)
  (setq
    cnivel (getvar "clayer")
    ptbase (getpoint "\nPonto base (ou inicial): ")
    ptini (getpoint "\nPonto inicial (ou ENTER): ")
  );endsetq
  (if (null ptini) (setq ptini ptbase))

  (initget 1)
  (setq pttxt (getpoint ptini "\nPonto de inserção do texto: "))

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

  (if #falt
    (setq
      falt (getdist (strcat
                       "\nAltura do furo <"
                       (rtos #falt 2 2)
                       ">: "
           )         );endstrcat,get
    );endsetq
    (progn
      (initget 1)
      (setq
        falt (getdist "\nAltura do furo: ")
      );endsetq
    );endprogn
  );endif
  (if falt (setq #falt falt))

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
                       (car #fdim)
                );endpolar
                (polar (getvar "lastpoint")
                       (+ ang1 (/ pi 2.0))
                       #fespc
                );endpolar
                ptini "c"
        "pline" (setq ptaux (polar ptini ang1 (/ (car #fdim) 2.0))) "w" 0 ""
                pttxt
                (if (> (car pttxt) (car ptaux))
                  (polar pttxt ang1 ptlen)
                  (polar pttxt -ang1 ptlen)
                ) ; endif
                ""
         "text" (polar pttxt (+ ang1 (/ pi 2.0)) (* 6.0 #scl)) (* 2.0 #scl) 0 "FURO NA VIGA"
         "text" (polar pttxt (+ ang1 (/ pi 2.0)) (* 2.0 #scl)) (* 2.0 #scl) 0 
                (strcat 
                  (rtos (car fdim) 2 0) 
                  "x" 
                  (rtos (cadr fdim) 2 0)
                ); endstrcat
         "text" (polar pttxt (- ang1 (/ pi 2.0)) (* 4.0 #scl)) (* 2.0 #scl) 0 
                (strcat 
                  "H=" 
                  (rtos falt 2 0)
                ); endstrcat
        "layer" "s" cnivel ""
      );endcommand
    );endprogn
    (prompt "\n--- Objeto encontrado nao e uma linha ---")
  );endif
  
  (princ)
);enddefun
