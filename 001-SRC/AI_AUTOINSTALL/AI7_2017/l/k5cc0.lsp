
;;
;; K5CC0.lsp
;; Copyright (C) 1996 by Paulo Lincoln de Oliveira, 4/17/96
;;

;; CCALHA: Calculo de dimensionamento de calhas

(defun dimnt ( df dn dt grup )
  (cond 
    ((= grup "F+N")(progn
                       (setq w (+ df dn))
                       (setq h df)
                     ); end progn 
    )
    ((= grup "2F")(progn
                       (setq w (* df 2))
                       (setq h df)
                    ); end progn 
    )
    ((= grup "2F+N")(progn
                       (setq w (+ (* df 2) dt))
                       (setq h df)
                      ); end progn 
    )
    ((= grup "3F")(progn
                      (setq w (* df 3))
                      (setq h df)
                    ); end progn 
    )
    ((= grup "3F+N")(progn
                        (setq w (+ (* df 3) dn))
                        (setq h df)
                      ); end progn 
    )
    ((= grup "F+N+T")(progn
                         (setq w (+ dt df dn))
                         (setq h df)
                       ); end progn 
    )
    ((= grup "2F+T")(progn
                        (setq w (+ dt (* df 2)))
                        (setq h df)
                      ); end progn 
    )
    ((= grup "2F+N+T")(progn
                          (setq w (+ dt dn (* df 2)))
                          (setq h df)
                        ); end progn 
    )
    ((= grup "3F+T")(progn
                        (setq w (+ dt (* df 3)))
                        (setq h df)
                      ); end progn 
    )
    ((= grup "3F+N+T")(progn
                          (setq w (+ dt dn (* df 3)))
                          (setq h df)
                        ); end progn 
    )
  ); end cond
  (list w h)
); end defun

(defun dimt ( df dn dt grup )
  (cond 
    ((= grup "F+N")(progn
                       (setq w (+ df dn))
                       (setq h df)
                     ); end progn 
    )
    ((= grup "2F")(progn
                      (setq w (* df 2))
                      (setq h df)
                    ); end progn 
    )
    ((= grup "2F+N")(progn
                        (setq w (* df 2))
                        (setq h (+ df dn))
                      ); end progn 
    )
    ((= grup "3F")(progn
                      (setq w (* df 2))
                      (setq h (* df 2))
                    ); end progn 
    )
    ((= grup "3F+N")(progn
                        (setq w (* df 3))
                        (setq h (+ df dn))
                      ); end progn 
    )
    ((= grup "F+N+T")(progn
                         (setq w (+ df dn))
                         (setq h (+ df dt))
                       ); end progn 
    )
    ((= grup "2F+T")(progn
                        (setq w (* df 2))
                        (setq h (+ df dt))
                      ); end progn 
    )
    ((= grup "2F+N+T")(progn
                          (setq w (+ dn (* df 2)))
                          (setq h (+ df dt))
                        );end progn 
    )
    ((= grup "3F+T")(progn
                        (setq w (* df 3))
                        (setq h (+ df dt))
                      ); end progn 
    )
    ((= grup "3F+N+T")(progn
                          (setq w (* df 3))
                          (setq h (+ df dn))
                        ); end progn 
    )
  ); end cond
   (list w h)
); end defun
  
(defun c:ccalha (/ oldmnu oldech PIRAST SINTEN conta contb cam tc sec n op elem v a b d v)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (setq oldmnu (ai_svar "promptmenu" 1))

  (setq TAB '(("1.5" "1.5" "1.5") ("2.5" "2.5" "2.5") ("4.0" "4.0" "4.0") ("6.0" "6.0" "6.0") ("10.0" "10.0" "10.0") ("16.0" "16.0" "16.0") ("25.0" "25.0" "25.0") ("35.0" "25.0" "16.0") ("50.0" "25.0" "25.0") ("70.0" "35.0" "35.0") ("95.0" "50.0" "50.0") ))

  (setq 
    CLARG '(   50    75 100 110 125 140 150 185 200 250 300 350 400 500 600 700 800)
    CALT  '(25 50 60 75 100     125 140 150     200 250 300)
  ) ; end setq

  (setq PIRAST '(("1.5" 3.0) ("2.5" 3.7) ("4.0" 4.2) ("6.0" 4.8) ("10.0" 5.9) ("16.0" 6.9)
                 ("25.0" 8.5) ("35.0" 9.5) ("50.0" 11.0) ("70.0" 13.0) ("95.0" 15.0)))
  (setq SINTEN '(("1.5" 5.1) ("2.5" 5.6) ("4.0" 6.7) ("6.0" 7.3) ("10.0" 8.0) ("16.0" 9.0) 
                 ("25.0" 11.0) ("35.0" 12.0) ("50.0" 14.0) ("70.0" 15.5) ("95.0" 18.0)))

  (initget 1)
  (setq cam (getint "\nNumero de camadas: "))

  (initget 1 "Pirastic Sintenax")
  (setq tc (getkword "\n(P)irastic/(S)intenax: "))

  (setq ls '())
  (while (progn
           (initget "F+N 2F 2F+N 3F 3F+N F+N+T 2F+T 2F+N+T 3F+T 3F+N+T")
           (setq tagrup (getkword "\nTipo de agrupamento (F+N 2F 2F+N ... 3F+N+T):"))
         ); end progn
    (initget 1  "1.5 2.5 4.0 6.0 10.0 16.0 25.0 35.0 50.0 70.0 95.0") 
    (setq secf (getkword "\nSecao do condutor fase (mm2): "))
    (initget 1)
    (setq num (getint "\nNumero de grupamentos iguais: "))
    (setq ls (append ls (list (list tagrup secf num))))
  ); end while

  (initget 1 "Sim Nao")
  (setq op (getkword "\nTrifolio (S)Sim/(N)Nao: "))
  (setq mdf 0)
  (setq larg 0)
  (setq alt 0)
  (foreach elem ls
    (progn
      (setq tagrup (car elem))
      (setq secf (cadr elem))
      (setq num (caddr elem))
      (setq 
           secn (cadr (assoc secf tab))
           sect (caddr (assoc secf tab))
      ); end setq

      (if (= tc "Pirastic")
        (progn
          (setq
               df (cadr (assoc secf PIRAST))
               dn (cadr (assoc secn PIRAST))
               dt (cadr (assoc sect PIRAST))
          ); end setq
        ); end progn
        (progn
          (setq
               df (cadr (assoc secf SINTEN))
               dn (cadr (assoc secn SINTEN))
               dt (cadr (assoc sect SINTEN))
          ); end setq
        ); end progn
      ); end if

      (if (> df mdf) (setq mdf df))
      (if (= op "Sim")
        (setq listdim (dimt df dn dt tagrup))
        (setq listdim (dimnt df dn dt tagrup))
      ); end if
      (setq v (- num 1))
      (setq a (+ (* (car listdim) num) (* v df)))
      (setq b (* (cadr listdim) (* cam 2)))
      (setq larg (+ larg a))
      (if (> b alt) (setq alt b))
    ); end progn
  ); end foreach

  (setq larg (+ larg (* (+ (length ls) 1) mdf)))  

  (setq ls CLARG)
  (while (and (setq conta (car ls))
              (>= larg conta) )
    (setq ls (cdr ls))
  ) ; end while
  (if (null conta)
    (progn
      (setq conta (* (/ (fix larg) 100) 100))
      (while (>= larg conta) (setq conta (+ conta 50)))
    ) ; end progn
  ) ; end if

  (setq ls CALT)
  (while (and (setq contb (car ls))
              (>= alt  contb) )
    (setq ls (cdr ls))
  ) ; end while
  (if (null contb)
    (progn
      (setq contb (* (/ (fix alt) 100) 100))
      (while (>= alt contb) (setq contb (+ contb 50)))
    ) ; end progn
  ) ; end if

  (prompt (strcat "\nA = " (rtos larg 2 1) " - B = " (rtos alt 2 1)))
  (prompt (strcat "\nCalha tipo: " (itoa conta) "/" (itoa contb)))

  (setvar "promptmenu" oldmnu)

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
