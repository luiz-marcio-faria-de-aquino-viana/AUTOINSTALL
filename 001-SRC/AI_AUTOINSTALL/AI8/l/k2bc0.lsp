; K2bc0/TORRE - Out/91

; Variaveis:
;    ptini - Ponto de insercao p/torre                   - Entrada
;    dimt  - Contem as dimensoes da torre                - Entrada
;    flag  - 'Flag' p/determinar entrada no loop         - Interna
;    #k2ba - Valor default p/dimensoes da torre          - Sistema
;    (#UND)  - Unidade a ser utilizada (mm=1)              - Sistema

(defun c:TORRE(/ ptini dimt flag)
  (m:savevars)
  
  (or #k2ba
      (setq
        #k2ba (/ 600.0 (#UND))
  )   );endor,setq
  
  (initget 1)
  (setq
    ptini (getpoint "\nPonto inicial (Centro): ")
    flag t
  );endsetq
  
  (while (or flag
             (< #k2ba (/ 600.0 (#UND)))
         );endor
    (setq
      flag nil
      dimt (getdist ptini (strcat "\nDimensao (LARG=PROF) <"
                                  (rtos #k2ba 2 2) ">: "
           )              );endstrcat,dist
    );endsetq
    (if dimt (setq #k2ba dimt))
  );endwhile
  (setq
    dimt (/ #k2ba 2.0)
  );endsetq
  
  (setvar "blipmode" 0)
  (command
  	"polygon" 4 ptini "c" dimt
  	"insert" (v:aid "AR/AR07c00") ptini (/ dimt 1.5) "" 0
  );endcommand

  (m:restorevars)
  (princ)
);enddefun
