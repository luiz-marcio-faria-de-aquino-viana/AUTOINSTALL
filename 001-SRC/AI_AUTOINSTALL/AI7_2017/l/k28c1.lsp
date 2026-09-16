; K28c0/VLog - Jun/92

; Variaveis:
;   cod   - Contem codigo p/visualizacao do usuario         - Entrada
;   vlog  - Contem selecao dos blocos de LogON 'SET0dc00'   - Interna
;   cont  - Contador p/elementos da selecao                 - Interna
;   lpoff - Contem data/hora do LogOFF                      - Interna
;   lpon  - Contem data/hora do LogON                       - Interna
;   lpid  - Contem identificacao do usuario                 - Interna
;   cdg   - Contem codigo de LogON do usuario               - Interna
;   ename - Contem nome da entidade a ser visualizada       - Interna

;;(defun c:vlog (/ cod vlog cont lphist lpoff lpon lpid cdg ename enam ent)
(defun c:vlog()
  (setvar "cmdecho" 0)
  
  (setq
    ss1 (ssget "x" '((0 . "INSERT") (2 . "SET0DC01")))
    ss2 (ssget "x" '((0 . "INSERT") (2 . "SET0DC00")))
  ) ; end setq
  (if (and ss1 ss2)
    (command ".select" ss1 ss2 "")
    (if ss1
      (command ".select" ss1 "")
      (command ".select" ss2 "")
    ) ; end if
  ) ; end setq

  (setq
    vlog (ssget "p")
    cont (1- (sslength vlog))
  );endsetq
  
  (textscr)
  (prompt"\e[2J")
  (prompt"*VLog")
  (prompt"\n\nCDG PROJETISTA      ENTRADA                       SAIDA")
  (prompt"\n--- --------------- ----------------------------- -----------------------------")
  (while (>= cont 0)
    (setq lphist nil)
    (setq enam (entnext (ssname vlog cont)))
    (while (/= (cdr (assoc 0 (setq ent (entget enam)))) "SEQEND")
      (cond
        ((= (cdr (assoc 2 ent)) "ID") (setq lpid (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "LOGIN") (setq lpon (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "LOGON") (setq lpon (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "LOGOFF") (setq lpoff (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "HISTORIC") (setq lphist (cdr (assoc 1 ent))) )
      ) ; end cond
      (setq enam (entnext enam))
    ) ; end while

    (setq
      cdg (strcat
            (substr "000" 1 (- 3 (strlen (itoa (- (sslength vlog) cont)))))
            (itoa (- (sslength vlog) cont))
          ) ; end strcat
      cont (1- cont)
    );endsetq
    (prompt
      (strcat "\n" cdg " " lpid (substr "         " 1 (- 9 (strlen lpid))) lpon "  " lpoff)
    ) ; end prompt
    (if lphist
      (prompt (strcat "\n         =>  " (substr lphist 1 67)))
      (prompt "\n")
    ) ; end if

    (if (zerop
          (rem (- (sslength vlog) cont) 9)
        );endzerop
      (progn
        (getstring "\n\n* Tecle [ENTER] ")
        (prompt "\n")
    ) );endprogn,if
  );endwhile
  
  (prompt "\n\n")
  (setq cod 0)
  (while (and cod
              (or (< cod 1)
                  (> cod (sslength vlog))
         )    );endor,and
    (setq
      cod (getint "\nCodigo (ou ENTER): ")
  ) );endsetq,while
  (if cod
    (progn
      (setq
        cod (- (sslength vlog) cod)
        ename (ssname vlog cod)
      );endsetq
      (while (and ename
                  (or (zerop cod)
                      (not (eq
                             ename (ssname vlog (1- cod))
                      )    );endeq,not
             )    );endor,and
        (redraw ename 3)
        (setq
          ename (entnext ename)
        );endsetq
      );endwhile
  ) );endprogn,if
  (princ)
);enddefun
