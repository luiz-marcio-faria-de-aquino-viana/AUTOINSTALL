; K27c0/LogOFF - Jun/92

; Variaveis:
;   fname - Nome do arquivo de trabalho                      - Interna
;   fdata - Data de saida do sistema                         - Interna
;   fhora - Hora de saida do sistema                         - Interna
;   file  - Arquivo de trabalho                              - Interna
;   ent   - 
;   elog  - Entidade que contem atributo c/LogOFF do sistema - Interna

(defun logoff(/ fname fdata fhora hist ss enam ent f)
  (setvar "cmdecho" 0)

  (setq
    fname (getvar "dwgname")
    fdata (strcat
            (substr (rtos (getvar "cdate") 2 6) 7 2) "/"
            (substr (rtos (getvar "cdate") 2 6) 5 2) "/"
            (substr (rtos (getvar "cdate") 2 6) 3 2)
          ) ; end strcat
    fhora (strcat
            (substr (rtos (getvar "cdate") 2 6) 10 2) ":"
            (substr (rtos (getvar "cdate") 2 6) 12 2)
          ) ; end strcat
  ) ; end setq
  (prompt "\n\nEste arquivo sofreu/sofrera modificacoes no disco")
  (prompt "\nInforme as modificacoes realizadas (max = 2 linhas)")
  (while (= (setq hist (getstring t "\n:: ")) "")
    (prompt "\n* ERROR * Nao e valida resposta nula"))

  (if (setq ss (ssget "x" '((0 . "insert") (2 . "SET0dc02"))))
    (progn
      (setq enam (entnext (ssname ss 0)))
      (while (/= (cdr (assoc 0 (setq ent (entget enam)))) "SEQEND")
        (cond
          ((= (cdr (assoc 2 ent)) "LOGOFF") (entmod (subst (cons 1 (strcat "Data: " fdata " - Hora: " fhora)) (assoc 1 ent) ent)) )
          ((= (cdr (assoc 2 ent)) "HISTORIC") (entmod (subst (cons 1 hist) (assoc 1 ent) ent)) )
        ) ; end cond
        (setq enam (entnext enam))
      ) ; end while
    ) ; end progn
  ) ; end if

  (setq f (open (strcat (getenv "acadlog") "logoff.doc") "a"))
  (write-line "- LogOFF -------------------------------" f)
  (write-line (strcat "Arquivo: " fname) f)
  (write-line (strcat "Data: " fdata " - Hora: " fhora) f)
  (write-line (strcat "Projetista: " #ID) f)
  (write-line (strcat "Historico: " hist) f)
  (setq f (close f))

  (princ)
) ; end function

(princ)
