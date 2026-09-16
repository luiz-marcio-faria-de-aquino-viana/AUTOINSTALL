
;;
;;  CUSTO.lsp: program to print the cust of drawing relatory
;; ======================================================================
;;              Copyright (C) 1995, by Luiz Marcio F A Viana
;;

(defun add_cust(elem lst)
  (if (null lst)
    (list elem)
    (if (= (car elem) (car (car lst)))
      (append (list (cons (car elem)
                          (list (car (cdr (car lst)))
                                (cadr (cdr elem))
                                (+ (caddr (cdr elem)) (caddr (cdr (car lst))))
              )     )     )
              (cdr lst)
      ) ; end append
      (append (list (car lst)) (add_cust elem (cdr lst)))
    ) ; end if
  ) ; end if
) ; end function

(defun c:custo()
  (setvar "cmdecho" 0)

  (prompt "\nRelatorio de Custos do Desenho")
  (prompt "\npor Luiz Marcio F A Viana, 8/18/95")
  (prompt "\nAnalisando o arquivo... ")

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
  ) ; end if
  (setq ss (ssget "p"))

  (setq lst '())
  (setq tot 0)

  (setq In 999999)
  (setq Fn      0)

  (prompt "\nProcessando... ")
  (setq cnt (- (sslength ss) 1))
  (while (> cnt 0) ;; if cnt = 0 then curr_time // not acept
    (setq enam (entnext (ssname ss cnt)))
    (while (/= (cdr (assoc 0 (setq ent (entget enam)))) "SEQEND")
      (cond
        ((= (cdr (assoc 2 ent)) "ID") (setq lpid (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "LOGIN") (setq lpon (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "LOGON") (setq lpon (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "LOGOFF") (setq lpoff (cdr (assoc 1 ent))) )
      ) ; end cond
      (setq enam (entnext enam))
    ) ; end while
    (setq
      h1 (atoi (substr lpon 24 2))
      m1 (atoi (substr lpon 27 2))
      tm1 (+ m1 (* h1 60))
    ) ; end setq
    (setq
      h2 (atoi (substr lpoff 24 2))
      m2 (atoi (substr lpoff 27 2))
      tm2 (+ m2 (* h2 60))
    ) ; end setq
    (if (zerop (- (atoi (substr lpoff 7 2)) (atoi (substr lpon 7 2))) )
      (setq tmin (- tm2 tm1))
      (setq tmin (- (+ 1440 tm2) tm1))
    ) ; end if
    (setq
      DTi (strcat (substr lpon 13 2) (substr lpon 10 2) (substr lpon 7 2))
      DTf (strcat (substr lpoff 13 2) (substr lpoff 10 2) (substr lpoff 7 2))
    ) ; end setq
    (setq tot (+ tot tmin))
    (setq lst (add_cust (cons lpid (list DTi DTf tmin)) lst))
    (if (< (atoi DTi) In) (setq In (atoi DTi)))
    (if (> (atoi DTf) Fn) (setq Fn (atoi DTf)))
    (prompt ".")
    (setq cnt (- cnt 1))
  ) ; end while

  (prompt "\nPreparando arquivo de saida... ");
  (setq f (open (strcat (getvar "DWGNAME") ".CST") "w"))
  (write-line (strcat "Arquivo: " (getvar "DWGNAME")) f)
  (write-line "" f)
  (write-line "PRJ      DTi    DTf    THr     (%)  " f)
  (write-line "-------- ------ ------ ------ ------" f)
  (foreach elem lst
    (progn
      (setq
        Id   (car elem)
        DTi  (car (cdr elem))
        DTf  (cadr (cdr elem))
        tmin (rtos (/ (caddr (cdr elem)) 60.0) 2 1)
        perc (rtos (* (/ (atof tmin) (/ tot 60.0)) 100.0) 2 1)
      ) ; end setq
      (write-line
        (strcat
          Id (substr "        " 1 (- 8 (strlen Id))) " "
          DTi " "
          DTf " "
          (substr "      " 1 (- 6 (strlen tmin))) tmin " "
          (substr "      " 1 (- 6 (strlen perc))) perc " %"
        ) ; end strcat
        f
      ) ; end write-line
    ) ; end progn
  ) ; end foreach
  (write-line "                       ------ ------" f)
  (write-line
    (strcat
      "                       "
      (substr "      " 1 (- 6 (strlen (rtos (/ tot 60.0) 2 1)))) (rtos (/ tot 60.0) 2 1) " "
      " 100.0 %"
    ) ; end strcat
    f
  ) ; end write-line
  (write-line "" f)
  (write-line "" f)
  (write-line "Grafico" f)
  (write-line "-------" f)
  (write-line "" f)
  (write-line (strcat "PRJ      " DTi "                                                           " DTf) f)
  (write-line "-------- -----------------------------------------------------------------------" f)
  (foreach elem lst
    (progn
      (setq
        Id   (car elem)
        DTi  (atof (car (cdr elem)))
        DTf  (atof (cadr (cdr elem)))
      ) ; end setq
      (if (zerop (- Fn In))
        (setq
          POSi 0
          POSf 0
        ) ; end setq
        (setq
          POSi (* (/ (- DTi In) (- Fn In)) 70.0)
          POSf (* (/ (- DTf In) (- Fn In)) 70.0)
        ) ; end setq
      ) ; end setq
      (setq OUT (strcat Id (substr "        " 1 (- 8 (strlen Id))) " "))
      (setq cnt 1)
      (while (< cnt POSi)
        (setq OUT (strcat OUT " "))
        (setq cnt (+ cnt 1))
      ) ; end while
      (setq OUT (strcat OUT "*"))
      (while (< cnt POSf)
        (setq OUT (strcat OUT "-"))
        (setq cnt (+ cnt 1))
      ) ; end while
      (setq OUT (strcat OUT "*"))
      (write-line OUT f)
    ) ; end progn
  ) ; end foreach
  (setq f (close f))

  (setq f (open (V:APPL "custo.scr") "w"))
  (write-line (strcat "READ " (getvar "DWGNAME") ".CST") f)
  (setq f (close f))

  (command ".script" (V:APPL "custo.scr"))
  (princ)
) ; end function
