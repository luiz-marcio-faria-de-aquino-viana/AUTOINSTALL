; K17c3/PRinter R3 - Jun/93

(defun c:PRinter()
  (m:savevars)

  (setq
    MAXLETR 6
    CODGINIC 65
    HFOLHA 279.4
    LFOLHA 345.1
  )

  (or (#LARG)
    (setq (#LARG) LFOLHA))
  (or #prscl
    (setq #prscl(* (#SCL) (#UND))))

  (initget 1)
  (setq
    pt1 (getpoint"\nPonto inicial da janela: ")
  )
  (initget 1)
  (setq
    pt2 (getcorner pt1"\nPonto final da janela: ")
  )

  (initget 2)
  (setq
    larg (getdist
           (strcat "\nLargura da folha de impressao <"
                   (rtos (#LARG) 2 2) ">: "
         ) )
  )
  (if larg (setq (#LARG) larg))

  (initget 2)
  (setq
    prscl (getdist
            (strcat "\nEscala de impressao 1/<"
                    (rtos #prscl 2 2) ">: "
          ) )
  )
  (if prscl (setq #prscl prscl))

  (while
    (="" (setq
           fname (getstring "\nNome do arquivo (MAX=6LETRAS): ")
    )    )
  )
  (if (> (strlen fname) MAXLETR)
    (setq
      fname (substr fname 1 MAXLETR)
  ) )

  (setq
    ptmin (list
            (min (car pt1) (car pt2))
            (min (cadr pt1) (cadr pt2))
          )
    ptmax (list
            (max (car pt1) (car pt2))
            (max (cadr pt1) (cadr pt2))
  )       )

  (setq
    xarea (- (car ptmax) (car ptmin))
    yarea (- (cadr ptmax) (cadr ptmin))
  )

  (setq
    lmax (* (#LARG) (/ #prscl (#UND)))
    hmax (* HFOLHA (/ #prscl (#UND)))
  )

  (if (< yarea xarea)
    (progn
      (setq
        deltax xarea
        deltay lmax
      )
      (setq rot "90")
    )
    (progn
      (setq
        deltax lmax
        deltay yarea
      )
      (setq rot "0")
  ) )

  (setq nlinhas 0)
  (command".undo""g")
  (setq
    xpos (car ptmin)
    ypos (cadr ptmin)
  )
  (while (< xpos (car ptmax))
    (command
      "pline" (list xpos (cadr ptmin))
              (list xpos (cadr ptmax)) ""
    )
    (setq xpos (+ xpos deltax))
    (setq nlinhas (1+ nlinhas))
  )
  (while (< ypos (cadr ptmax))
    (command
      "pline" (list (car ptmin) ypos)
              (list (car ptmax) ypos) ""
    )
    (setq ypos (+ ypos deltay))
    (setq nlinhas (1+ nlinhas))
  )
  (command
    "pline" (list (car ptmin) (cadr ptmax)) ptmax ""
    "pline" (list (car ptmax) (cadr ptmin)) ptmax ""
    ".undo" "e"
  )
  (setq nlinhas (+ nlinhas 2))
  (getstring "\nTecle [ENTER] quando pronto... ")

  (if (= rot "90")
    (setq deltax hmax)
    (setq deltay hmax)
  )

  (setq
    file (open (V:APPL "printer.scr") "w")
  )

  (setq
    yi (cadr ptmin)
    yj (+ yi deltay)
  )
  (setq codY CODGINIC)
  (while (< yj (cadr ptmax))
    (setq
      xi (car ptmin)
      xj (+ xi deltax)
    )
    (setq codX CODGINIC)
    (while (< xj (car ptmax))
      (WrScript
        xi yi
        xj yj
        (strcat (chr codY) (chr codX))
      )
      (setq
        xi xj
        xj (+ xj deltax)
      )
      (setq codX (1+ codX))
    )
    (WrScript
      xi yi
      (car ptmax) yj
      (strcat (chr codY) (chr codX))
    )
    (setq
      yi yj
      yj (+ yj deltay)
    )
    (setq codY (1+ codY))
  )
  (setq
    xi (car ptmin)
    xj (+ xi deltax)
  )
  (setq codX CODGINIC)
  (while (< xj (car ptmax))
    (WrScript
      xi yi
      xj (cadr ptmax)
      (strcat (chr codY) (chr codX))
    )
    (setq
      xi xj
      xj (+ xj deltax)
    )
    (setq codX (1+ codX))
  )
  (WrScript
    xi yi
    (car ptmax) (cadr ptmax)
    (strcat (chr codY) (chr codX))
  )

  (repeat nlinhas
    (progn
      (write-line "ERASE" file)
      (write-line "Last" file)
      (write-line""file)
  ) )

  (setq file (close file))
  (command
    "script" (V:APPL "printer")
  )

  (m:restorevars)
  (princ)
)

(defun WrScript(xpta ypta xptb yptb codS)
  (write-line "PRPLOT" file)
  (write-line "Window" file)
  (write-line
    (strcat (rtos xpta 2 2) "," (rtos ypta 2 2)) file
  )
  (write-line
    (strcat (rtos xptb 2 2) "," (rtos yptb 2 2)) file
  )
  (write-line "Yes" file)
  (write-line "M" file)
  (write-line "0,0" file)
  (write-line
    (strcat (rtos (#LARG) 2 2) "," (rtos HFOLHA 2 2)) file
  )
  (write-line rot file)
  (write-line "No" file)
  (write-line
    (strcat "1=" (rtos (/ #prscl (#UND)) 2 2)) file
  )
  (write-line "Printer.$ac" file)
  (write-line "" file)
  (write-line "Shell" file)
  (write-line
    (strcat "PRinter " fname " " codS) file
  )
)

(princ)
