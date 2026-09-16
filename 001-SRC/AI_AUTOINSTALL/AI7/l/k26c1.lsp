; K26c0/LogON - Jun/92

; Variaveis:
;   fdata - Data de entrada no sistema                   - Interna
;   fhora - Hora de entrada no sistema                   - Interna
;   #ID   - Identificacao do usuario                     - Entrada/Sistema

(setvar "cmdecho" 0)

(setq #FLSAVE "NOT SAVED")

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
          "\n\nLogON\n-----"
          "\n\nData: " fdata " - Hora: " fhora
)       );endstrcat,progn

(setq #ID (getenv "USR"))
(prompt (strcat "\nNome: " #ID))
(getstring "\n\n[ ENTER ] P/ PROSSEGUIR")
(graphscr)

(setvar "blipmode" 0)
(command
  "insert" "set0dc01" "0,0" 1 "" 0
           #ID (strcat "Data: " fdata " - Hora: " fhora) "" ""
);endcommand
(setvar "blipmode" 1)
(princ)
