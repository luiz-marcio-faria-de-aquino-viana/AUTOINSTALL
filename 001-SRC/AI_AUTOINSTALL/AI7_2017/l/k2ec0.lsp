; K2ec0/ChCOPY - Ago/92

; Variaveis:
;    Object - Entidades selecionadas                     - Entrada
;    Nnivel - Nome do layer destino p/entidades          - Entrada

(defun c:ChCOPY(/ object nnivel)
  (setvar "cmdecho" 0)
  
  (setq
    object (ssget)
    nnivel (strcase (getstring "\nLayer to change <Current>: "))
  );endsetq
  
  (cond
    ((= nnivel "")
     (command
       "copy" object "" "0,0" "0,0"
       "change" "p" "" "p" "la" (getvar "clayer") ""
    ));endcommand,case
    ((tblsearch "layer" nnivel)
     (command
       "copy" object "" "0,0" "0,0"
       "change" "p" "" "p" "la" nnivel ""
    ));endcommand,case
    ((prompt
       (strcat "\nLayer <" nnivel "> not found")
    ));endprompt,othercase
  );endcond
  (princ)
);enddefun
