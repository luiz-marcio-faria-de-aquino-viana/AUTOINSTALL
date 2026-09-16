; INSert2 - Mai/92

; Variaveis:
;    Blck  - Nome do bloco a ser inserido                      - Entrada
;    #Blck - Valor default p/nome do bloco                     - Sistema
;    (#UND)  - Contem a unidade utilizada (mm=1)                 - Sistema

(defun C:INSert2(/ blck ptini ptbase)
  (setvar "cmdecho" 0)
  (if (or (null #blck)
          (= #blck "")
      );endor
    (progn
      (initget 1)
      (setq
        blck (getstring "\nInsert block name: ")
    ) );endsetq,progn
    (setq
      blck (getstring (strcat
                        "\nInsert block name <"
                        #blck ">: "
           )          );endstrcat,get
    );endsetq
  );endif
  (if (/= blck "") (setq #blck blck))
  (initget 1)
  (setq
    ptbase (getpoint "\nFirst point (or Insert point): ")
    ptini (getpoint ptbase "\nSecound point (or ENTER): ")
  );endsetq
  (if (null ptini) (setq ptini ptbase)
                   (setq ptini (mapcar
                                 '/ (mapcar '+ ptini ptbase)
                                 '(2.0 2.0)
                   )           );endsetq,mapcar
  );endif
  (if (tblsearch "block" (getfilename #blck))
    (command ".insert" (getfilename #blck) "s" (/ 1.0 (#UND)) ptini)
    (command ".insert" (V:AID #blck) "s" (/ 1.0 (#UND)) ptini)
  ) ; end if
  (princ)
);enddefun
