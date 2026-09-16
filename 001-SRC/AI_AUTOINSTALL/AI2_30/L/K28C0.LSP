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

(defun c:vlog (/ cod vlog cont lpnm lphist lpoff lpon lpid cdg ename enam ent)
  (setvar "cmdecho" 0)
  
  (setq
    vlog (ssget "x" '((0 . "INSERT") (2 . "SET0DC02")))
    cont (1- (sslength vlog))
  );end setq
  
  (textscr)
  (prompt"\e[2J")
  (prompt  "CDG PROJETISTA      ENTRADA                       SAIDA")
  (prompt"\n--- --------------- ----------------------------- -----------------------------")
  (while (>= cont 0)
    (setq enam (entnext (ssname vlog cont)))
    (while (/= (cdr (assoc 0 (setq ent (entget enam)))) "SEQEND")
      (cond
        ((= (cdr (assoc 2 ent)) "DWGNAME")  (setq lpnm   (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "ID")       (setq lpid   (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "LOGIN")    (setq lpon   (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "LOGON")    (setq lpon   (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "LOGOFF")   (setq lpoff  (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "HISTORIC") (setq lphist (cdr (assoc 1 ent))) )
      ) ; end cond
      (setq enam (entnext enam))
    ) ; end while

    (setq cdg (lfill (itoa (- (sslength vlog) cont)) 3 "0"))
    (prompt (strcat "\n" cdg " " (rfill lpid 16 " ") lpon "  " lpoff) )
    (prompt (strcat "\n         =>  "      (substr lphist 1 67) "\n") )
    (if (and (>= cont 0) (zerop (rem (- (sslength vlog) cont) 7) ) )
      (progn
        (getstring "\n\n*** TECLE [ ENTER ] ***")
        (prompt"\n\nCDG PROJETISTA      ENTRADA                       SAIDA")
        (prompt"\n--- --------------- ----------------------------- -----------------------------")
      ) ; end progn
    ) ; end if
    (setq cont (- cont 1))
  );endwhile

  (setq cod 0)
  (while (and cod (or (< cod 1) (> cod (sslength vlog)) ) )
    (setq cod (getint "\n\nCodigo (ou ENTER): "))
  ) ; end while

  (if cod
    (progn
      (setq
        cod (- (sslength vlog) cod)
        ename (ssname vlog cod)
      ) ; end setq
      (while (and ename
                  (or (zerop cod)
                      (not (eq
                             ename (ssname vlog (1- cod))
                      )    ) ; endeq, not
             )    ) ; endor, and
        (redraw ename 3)
        (setq
          ename (entnext ename)
        ) ; end setq
      ) ; end while
  ) ) ; end progn, if
  (princ)
);enddefun
