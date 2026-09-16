; K15c0/PLOTer - Mai/92

(defun C:PLOTer()
;;(/ FORM fform larg alt n plscl plrot
;;                  pt1 pt2 pta ptb nfile file deltx delty)
  (setvar "cmdecho" 0)

  (setq
    FORM '(("A3 - HORIZ" . (440 278)) ("A3 - VERT" . (302  416))
           ("A2 - HORIZ" . (615 416)) ("A2 - VERT" . (440  591))
           ("A1 - HORIZ" . (890 591)) ("A1 - VERT" . (615  866))
                                      ("A0 - VERT" . (890 1216)) )
  ) ; end setq

  (cond
    ((= (getvar "ACADVER") "R11 c2")
      (setq
        NROT  "0"
        YROT "90"
    ) ) ; end setq, case
    ((= (getvar "ACADVER") "10 c2")
      (setq
        NROT  "Y"
        NROT  "N"    
    ) ) ; end setq, case
  ) ; end cond

  (or #plscl
      (setq #plscl (* (#SCL) (#UND)))
  ) ; end or

  (or #plrot
      (setq #plrot "No")
  ) ; end or
  
  (or #pltype
      (setq #pltype "Sulfite")
  ) ; end or

  (initget 1)
  (setq
    pt1 (getpoint "\nPrimeiro corner: ")
  ) ; end setq
  (initget 1)
  (setq
    pt2 (getcorner pt1 "\nSegundo corner: ")
  ) ; end setq
  (setq
    pta (list (+ (max (car pt1) (car pt2)) (#SCL)) (+ (max (cadr pt1) (cadr pt2)) (#SCL)))
    ptb (list (min (car pt1) (car pt2)) (min (cadr pt1) (cadr pt2)))
  ) ; end setq

  (initget "Yes No")
  (setq plrot (getkword (strcat "\nRodar desenho de 90d <" #plrot ">: ")))
  (if plrot (setq #plrot plrot))

  (initget 6 "Corrente")
  (setq
    plscl (getreal (strcat "\nEscala para plotagem/(C)orrente <"
                           (rtos #plscl 2 2) ">: "
          )        ) ; end strcat, real
  ) ; end setq
  (if (= plscl "Corrente")
    (setq
      plscl (* (#SCL) (#UND))
  ) ) ; end setq, if
  (if plscl (setq #plscl plscl))
  
  (setq
    nfile (getstring "\nNome do arquivo: ")
  ) ; end setq

  (initget "Sulfite Vegetal")
  (setq pltype (getkword (strcat "\nPapel utilizado <" #pltype ">: ")))
  (if pltype (setq #pltype pltype))  

  (initget 6)
  (setq ncpy (getint "\nNumero de copias < 1 >: "))
  (if (null ncpy) (setq ncpy 1))

  (if (= #plrot "Yes")
    (setq
      deltx (/ (abs (- (cadr pta) (cadr ptb))) (/ #plscl (#UND)))
      delty (/ (abs (- (car pta) (car ptb))) (/ #plscl (#UND)))
    ) ; end setq
    (setq
      deltx (/ (abs (- (car pta) (car ptb))) (/ #plscl (#UND)))
      delty (/ (abs (- (cadr pta) (cadr ptb))) (/ #plscl (#UND)))
    ) ; end setq
  ) ; end if

  (if (and (zerop (getvar "TILEMODE"))
           (null (ssget "x" '((0 . "INSERT") (2 . "SET0FC00"))))
      ) ; end and
    (setq
      deltx (* deltx (#SCL))
      delty (* delty (#SCL)) 
    ) ; end setq
  ) ; end if

  (setq fform nil)
  (foreach n FORM
    (progn
      (setq
        nform (car n)
        larg (car  (cdr n))
        alt  (cadr (cdr n))
      ) ; end setq
      (if (null fform)
        (if (or
              (and (< deltx larg) (< delty alt))
              (and (< deltx alt) (< delty larg))
            ) ; end or
          (setq fform n)
         ) ; end if
      ) ; end if
    ) ; end progn
  ) ; end foreach
  (if (null fform) (setq fform (cons "+A0" (list deltx delty))) )
  
  (prompt (strcat "\nFolha: < " (car fform) " >\t" (rtos deltx 2 2) " Larg\t\t" (rtos delty 2 2) " Alt"))
  (getstring "\nTecle enter p/prosseguir.")  

  (setq file (open (V:APPL "ploter.scr") "w"))

  (write-line "PLot" file)
  (write-line "Window" file)
  (write-line (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6)) file)
  (write-line (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6)) file)
  (write-line "Yes" file)
  (write-line "No" file)
  (write-line "Yes" file)
  (write-line "M" file)
  (write-line "0,0" file)
  (write-line (strcat (rtos deltx 2 6) "," (rtos delty 2 6)) file)
  (write-line #plrot file)
  (write-line "0.25" file)
  (write-line "No" file)
  (write-line "No" file)
  (if (and (zerop (getvar "tilemode"))
           (null (ssget "x" '((0 . "INSERT") (2 . "SET0FC00"))))
      ) ; end and
    (write-line (strcat "1=" (rtos (/ (/ #plscl (#UND)) (#SCL)) 2 6)) file)
    (write-line (strcat "1=" (rtos (/ #plscl (#UND)) 2 6)) file)
  ) ; end if
  (write-line (strcat "c:/spool/plot/" nfile) file)
  (write-line "" file)
  (write-line "Shell" file)
  (write-line (strcat "PLOTER " (strcase nfile) ".PLT" " " (substr (car fform) 1 2) " " #pltype " " (itoa ncpy)) file)

  (setq file (close file))

  (command "script" (V:APPL "ploter"))
  (princ)
);enddefun

(princ)
