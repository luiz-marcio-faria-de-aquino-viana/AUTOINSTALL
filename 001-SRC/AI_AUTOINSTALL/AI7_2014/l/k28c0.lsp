
;;
;; K28C0.lsp
;; Copyrigh (C) 1997 by Luiz Marcio F A Viana, 1/2/97
;;

;; c:vlog(): comando que retorna os usuarios que trabalharam no desenho
(defun c:vlog (/ cod vlog cont lpnm lphist lpoff lpon lpid cdg ename enam ent)
  (setvar "cmdecho" 0)
  
  (setq
    vlog (ssget "x" '((0 . "INSERT") (2 . "SET0DC02")))
    cont (1- (sslength vlog))
  );end setq
  
  (textscr)
  (prompt  "\nCDG PROJETISTA         ENTRADA                      SAIDA                       ")
  (prompt  "\n=== ================== ============================ ============================")
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
    (prompt (strcat "\n" cdg " " (rfill (substr lpid 1 18) 19 " ") lpon " " lpoff) )
    (prompt (strcat "\n    => " (substr lphist 1 67) "\n") )
    (if (and (>= cont 0) (zerop (rem (- (sslength vlog) cont) 7) ) )
      (progn
        (getstring "\n\nTecle [ ENTER ] para prosseguir")
        (prompt  "\n\nCDG PROJETISTA         ENTRADA                      SAIDA                       ")
        (prompt    "\n=== ================== ============================ ============================")
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
