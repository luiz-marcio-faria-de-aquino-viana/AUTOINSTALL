
;                               P R I N T - C (R)
;    ________________________________________________________________________
;          Copyright (C) 1993 by TML Software, Inc. All Rights Reserved.


;     THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
;     ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR PURPOSE AND OF
;     MERCHANTABILITY ARE HEREBY DISCLAIMED.
;    ________________________________________________________________________


;     DESCRIPTION:

;     LISP PRINTC application - by Luiz Marcio Viana - 12/20/93


(defun c:printc(/ larg alt rot scl pt1 pt2 fname ptmax ptmin
                  xpapel ypapel deltx delty cnivel xpos ypos
                  n file pfx1 pfx2 pta NROT YROT prfile
                  lpfx1 lpfx2)

  (setvar "cmdecho" 0)

  (if (> (substr (getvar "acadver") 1 2) "10")
    (setq
      NROT "0"
      YROT "90"
    )
    (setq
      NROT "No"
      YROT "Yes"
  ) )

  (or #prlarg (setq
                #prlarg 345.44
  )           )
  (or #pralt (setq
               #pralt 279.4
  )          )
  (or #prrot (setq
               #prrot "No"
  )          )
  (or #prscl (setq
               #prscl 50.0
  )          )
  (setq #prund #und)

  (setq
    larg (getdist
           (strcat "\nLargura da folha <" (rtos #prlarg 2 2) ">: ")
  )      )
  (if larg (setq #prlarg larg))

  (setq
    alt (getdist
          (strcat "\nAltura da folha <" (rtos #pralt 2 2) ">: ")
  )     )
  (if alt (setq #pralt alt))

  (initget "Yes No")
  (setq
    rot (getkword
          (strcat "\nRodar desenho de 90d <" #prrot ">: ")
  )     )
  (if rot (setq #prrot rot))

  (initget 2)
  (setq
    scl (getdist
          (strcat "\nEscala para impressao 1/<" (rtos #prscl 2 2) ">: ")
  )     )
  (if scl (setq #prscl scl))

  (initget 1)
  (setq
    pt1 (getpoint "\nPrimeiro corner: ")
  )
  (initget 1)
  (setq
    pt2 (getcorner pt1 "\nSegundo corner: ")
  )

  (while (< 6 (strlen
                (setq fname (getstring "\nNome do arquivo: "))
  )      )    )

  (setq
    ptmax (list
            (max (car pt1) (car pt2))
            (max (cadr pt1) (cadr pt2))
          )
    ptmin (list
            (min (car pt1) (car pt2))
            (min (cadr pt1) (cadr pt2))
  )       )

  (setq
    xpapel (- (car ptmax) (car ptmin))
    ypapel (- (cadr ptmax) (cadr ptmin))
  )

  (if (= #prrot "No")
    (setq
      deltx (* #prlarg (/ #prscl #prund))
      delty (* #pralt (/ #prscl #prund))
    )
    (setq
      deltx (* #pralt (/ #prscl #prund))
      delty (* #prlarg (/ #prscl #prund))
  ) )

  (setq
    cnivel (getvar "clayer")
  )
  (if (tblsearch "layer" "_PRINTC_")
    (command
      "layer" "t" "_PRINTC_" "m" "_PRINTC" ""
    )
    (command
      "layer" "m" "_PRINTC_" ""
    )
  )

  (command
    "pline"
      ptmin "w" 0 0
      (list (car ptmax) (cadr ptmin)) ptmax
      (list (car ptmin) (cadr ptmax)) "c"
  )

  (setq n 1)
  (setq
    xpos (car ptmin)
    ypos (cadr ptmax)
  )
  (if (= #prrot "No")
    (while (< (setq xpos (+ xpos deltx)) (car ptmax))
      (command
        "pline"
          (list xpos (cadr ptmin)) "w" 0 0
          (list xpos (cadr ptmax)) ""
      )
      (setq n (1+ n))
    )
    (while (> (setq ypos (- ypos delty)) (cadr ptmin))
      (command
        "pline"
          (list (car ptmin) ypos) "w" 0 0
          (list (car ptmax) ypos) ""
      )
      (setq n (1+ n))
    )
  )

  (command
    "layer" "s" cnivel ""
  )

  (getstring "\nTecle [ENTER] para prosseguir... ")

  (setq
    file (open (V:APPL "printc.scr") "w")
  )

  (setq
    pfx1 65
    pfx2 65
  )

  (setq
    pta (list (car ptmin) (cadr ptmax))
    ypos (cadr ptmax)
  )
  (while (> ypos (cadr ptmin))
    (setq
      xpos (car ptmin)
      ypos (- ypos delty)
    )
    (if (< ypos (cadr ptmin))
      (setq
        ypos (cadr ptmin)
    ) )
    (while (< xpos (car ptmax))
      (setq
        xpos (+ xpos deltx)
      )
      (if (> xpos (car ptmax))
        (setq
          xpos (car ptmax)
      ) )

      (write-line "PRPLOT" file)
      (write-line "Window" file)
      (write-line (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6)) file)
      (write-line (strcat (rtos xpos 2 6) "," (rtos ypos 2 6)) file)
      (write-line "Yes" file)
      (write-line "M" file)
      (write-line "0,0" file)
      (write-line (strcat (rtos #prlarg 2 6) "," (rtos #pralt 2 6)) file)
      (if (= #prrot "No")
        (write-line NROT file)
        (write-line YROT file)
      )
      (write-line "No" file)
      (write-line (strcat "1=" (rtos (/ #prscl #prund) 2 6)) file)
      (write-line (strcat (getenv "PRPDIR") fname (chr pfx1) (chr pfx2)) file)
      (write-line "" file)
      (setq
        lpfx1 pfx1
        lpfx2 pfx2
      )

      (setq
        pta (list xpos (cadr pta))
      )
      (if (= #prrot "No")
        (setq pfx1 (1+ pfx1))
        (setq pfx2 (1+ pfx2))
      )
    )

    (setq
      pta (list (car ptmin) ypos)
    )
    (if (= #prrot "No")
      (setq pfx1 65 pfx2 (1+ pfx2))
      (setq pfx1 (1+ pfx1) pfx2 65)
    )
  )

  (repeat n
    (progn
      (write-line "ERASE L" file)
      (write-line "" file)
  ) )

  (write-line
    (strcat
      "prp2lst"
        " -f" (getenv "PRPDIR") fname
        " -o" (getenv "PRPDIR") fname 
        " -raa.." (chr lpfx1) (chr lpfx2)
        " "
    ) file
  )

  (write-line "shell" file)
  (write-line (strcat "printer " fname) file)
  (write-line (strcat "script " (v:appl "nulscr")) file)

  (setq
    file (close file)
  )

  (command "script" (V:APPL "printc"))
  (princ)
)
(princ)
