; INSerir - Jan/92

; Variaveis:
;    Blck  - Nome do bloco a ser inserido                      - Entrada
;    #Blck - Valor default p/nome do bloco                     - Sistema
;    #Und  - Contem a unidade utilizada (mm=1)                 - Sistema

(defun C:INSERIR(/ blck)
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
  (command "insert")
  (command (V:AID #blck))
  (command (getpoint "\nInsert point: ") (/ 1.0 #und))
  (setvar "cmdecho" 1)
  (command "" pause)
  (setvar "cmdecho" 0)
  (princ)
);enddefun
