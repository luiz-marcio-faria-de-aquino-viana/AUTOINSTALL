; K26c0/LogON - Jun/92

; Variaveis:
;   fdata - Data de entrada no sistema                   - Interna
;   fhora - Hora de entrada no sistema                   - Interna
;   #id   - Identificacao do usuario                     - Entrada/Sistema

(setvar "cmdecho" 0)

(setq
  fdata (strcat
          (substr (rtos (getvar "cdate") 2 6) 7 2) "/"
          (substr (rtos (getvar "cdate") 2 6) 5 2) "/"
          (substr (rtos (getvar "cdate") 2 6) 3 2)
        );endstrcat
  fhora (strcat
          (substr (rtos (getvar "cdate") 2 6) 10 2) ":"
          (substr (rtos (getvar "cdate") 2 6) 12 2)
        );endstrcat
);endsetq

(textscr)
(prompt (strcat
          "\nLogON\n-----"
          "\n\nData: " fdata " - Hora: " fhora
)       );endstrcat,progn

(while (= (setq
            #id (strcase
                  (getstring "\nNome: ")
          )     );endcase,setq
          ""
)      );endeq,while
(graphscr)

(setvar "blipmode" 0)
(command
  "insert" "set0dc00" "0,0" 1 "" 0
           "" (strcat "Data: " fdata " - Hora: " fhora) #id
);endcommand
(setvar "blipmode" 1)
(princ)
