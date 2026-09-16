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

(defun c:vlog (/ cod vlog cont lpoff lpon lpid cdg ename)
  (setvar "cmdecho" 0)
  
  (setq
    vlog (ssget "x" '((0 . "INSERT") (2 . "SET0DC00")))
    cont (1- (sslength vlog))
  );endsetq
  
  (textscr)
  (prompt"\e[2J")
  (prompt"*VLog")
  (prompt"\n\nCDG PROJETISTA      ENTRADA                       SAIDA")
  (prompt"\n--- --------------- ----------------------------- -----------------------------")
  (while (>= cont 0)
    (setq
      lpoff (cdr (assoc 1 (entget
                            (entnext (ssname vlog cont))
            )    )        );endentget,assoc,cdr
      lpon (cdr (assoc 1 (entget
                           (entnext (entnext (ssname vlog cont)))
           )    )        );endentget,assoc,cdr
      lpid (cdr (assoc 1 (entget
                           (entnext (entnext (entnext (ssname vlog cont))))
           )    )        );endentget,assoc,cdr
      cdg (strcat (substr "000" 1 (- 3 (strlen
                                         (itoa
                                           (- (sslength vlog) cont)
                                         );enditoa
                                  )    );endstrlen,dif
                  );endsubstr
                  (itoa
                    (- (sslength vlog) cont)
          )       );enditoa,strcat
      cont (1- cont)
    );endsetq
    (prompt (strcat "\n" cdg " " lpid (substr "                "
                                    1 (- 16 (strlen lpid))
                                  );endsubstr
                    lpon "  " lpoff
    )       );endstrcat,prompt
    (if (zerop
          (rem (- (sslength vlog) cont) 18)
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
