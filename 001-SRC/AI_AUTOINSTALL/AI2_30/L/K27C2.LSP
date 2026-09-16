; K27c0/LogOFF - Jun/92

; Variaveis:
;   fname - Nome do arquivo de trabalho                      - Interna
;   fdata - Data de saida do sistema                         - Interna
;   fhora - Hora de saida do sistema                         - Interna
;   file  - Arquivo de trabalho                              - Interna
;   elog  - Entidade que contem atributo c/LogOFF do sistema - Interna

(defun logoff(/ elog fname fdata fhora file)
  (setvar "cmdecho" 0)

  (setq
    elog (entget (entnext
                   (ssname (ssget "x" '((0 . "insert") (2 . "SET0dc00"))) 0)
         )       );endentnext,entget
    fname (getvar "dwgname")
    fdata (strcat
            (substr (rtos (getvar "cdate") 2 6) 7 2) "/"
            (substr (rtos (getvar "cdate") 2 6) 5 2) "/"
            (substr (rtos (getvar "cdate") 2 6) 3 2)
          );endstrcat
    fhora (strcat
            (substr (rtos (getvar "cdate") 2 6) 10 2) ":"
            (substr (rtos (getvar "cdate") 2 6) 12 2)
          );endstrcat
    elog (subst
           (cons 1 (strcat
                     "Data: " fdata " - Hora: " fhora
           )       );endstrcat,cons
           (assoc 1 elog)
           elog
  )      );endsubst,setq
  (entmod elog)
  (entupd
    (cdr (car elog))
  );endentupd

  (setq
    file (open (strcat
                 (getenv "acadlog") "logoff.doc"
               );endstrcat
               "a"
  )      );endopen,setq
  (write-line "- LogOFF -------------------------------" file)
  (write-line (strcat "Arquivo: " fname) file)
  (write-line (strcat "Data: " fdata " - Hora: " fhora) file)
  (write-line (strcat "Projetista: " #id) file)
  (close file)

  (princ)
) ; end defun

(princ)
