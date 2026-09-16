
;                           dP R I N T (R)
;   ________________________________________________________________________
;         Copyright (C) 1994 by TML Software, Inc. All Rights Reserved.


;    THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
;    ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR PURPOSE AND OF
;    MERCHANTABILITY ARE HEREBY DISCLAIMED.
;   ________________________________________________________________________


;    DESCRIPTION:

;    LISP dPRINT application - by Luiz Marcio Viana - 3/5/94


(defun c:dprint()

  (setvar "cmdecho" 0)

  (defun *error*(msg)
    (prompt msg)
    (setvar "blipmode" 1)
    (setvar "highlight" 1)
    (setq *error* nil)
    (princ)
  )

  (cond
    ((= (getvar "acadver") "R11 c2")
     (setq
       NROT "0"
       YROT "90"
    ))
    ((= (getvar "acadver") "10 c2")
     (setq
       NROT "N"
       YROT "Y"
    ))
  )

  (or #prfile (setq
                #prfile "No"
  )           )
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
               #prscl (* (#SCL) (#UND))
  )          )

  (initget "Yes No")
  (setq
    prfile (getkword
             (strcat "\nImprimir em um arquivo <" #prfile ">: ")
  )        )
  (if prfile (setq #prfile prfile))

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

  (if (= #prfile "Yes")
    (while (< 6 (strlen
                  (setq fname (getstring "\nNome do arquivo: "))
    )      )    )
    (setq fname "$pr")
  )

  (setq
    pt1 (cadr (grread T))
  )

  (if (= #rot "Yes")
    (setq
      deltax (/ (* #pralt (/ #prscl (#UND))) 2.0)
      deltay (/ (* #prlarg (/ #prscl (#UND))) 2.0)
    )
    (setq
      deltax (/ (* #prlarg (/ #prscl (#UND))) 2.0)
      deltay (/ (* #pralt (/ #prscl (#UND))) 2.0)
    )
  )

  (setq
    drmode (getvar "dragmode")
  )
  (setvar "dragmode" 2)

  (setvar "highlight" 0)
  (setvar "blipmode" 0)

  (setq
    cnivel (getvar "clayer")
  )
  (if (tblsearch "layer" "_PRINTC_")
    (command "layer" "t" "_PRINTC_" "m" "_PRINTC_" "")
    (command "layer" "m" "_PRINTC_" "")
  )

  (command
    "pline" (list
              (- (car pt1) deltax)
              (- (cadr pt1) deltay)
            )
            "w" 0 ""
            (list
              (+ (car pt1) deltax)
              (- (cadr pt1) deltay)
            )
            (list
              (+ (car pt1) deltax)
              (+ (cadr pt1) deltay)
            )
            (list
              (- (car pt1) deltax)
              (+ (cadr pt1) deltay)
            )
            "c"
    "move" (setq
             ent1 (ssget "l")
           )
           "" pt1
  )
  (redraw (ssname ent1 0) 2)
  (prompt "\n--- Selecione area para impressao ---\n")
  (command
            pause
    "erase" ent1 ""
  )

  (command
    "layer" "s" cnivel ""
  )

  (setvar "highlight" 1)
  (setvar "blipmode" 1)

  (setvar "dragmode" drmode)

  (setq
    pta (list
          (- (car (getvar "lastpoint")) deltax)
          (- (cadr (getvar "lastpoint")) deltay)
        )
    ptb (list
          (+ (car (getvar "lastpoint")) deltax)
          (+ (cadr (getvar "lastpoint")) deltay)
        )
  )

  (setq
    file (open "dprint.scr" "w")
  )

  (write-line "PRplot" file)
  (write-line "Window" file)
  (write-line (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6)) file)
  (write-line (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6)) file)
  (write-line "Yes" file)
  (write-line "M" file)
  (write-line "0,0" file)
  (write-line (strcat (rtos #prlarg 2 6) "," (rtos #pralt 2 6)) file)
  (write-line #prrot file)
  (write-line "No" file)
  (write-line (strcat "1=" (rtos (/ #prscl (#UND)) 2 6)) file)
  (write-line (strcat (getenv "PRPDIR") fname) file)
  (write-line "" file)

  (if (= #prfile "Yes")
    (write-line
      (strcat
        "prp2lst"
          " -f" (getenv "PRPDIR") fname
          " -o" (getenv "PRPDIR") fname
      ) file
    )
    (write-line
      (strcat
        "prp2lst" 
          " -f" (getenv "PRPDIR") fname
      ) file
  ) )

  (write-line
    (strcat
      "del " (getenv "PRPDIR") fname "*.prp"
    ) file
  )

  (if (= #prfile "Yes")
    (progn
      (write-line
        (strcat
          "pkzip -es " (getenv "PRPDIR") fname " " (getenv "PRPDIR") fname "*.lst"
        ) file
      )
      (write-line
        (strcat
          "del " (getenv "PRPDIR") fname "*.lst"
        ) file
      )
  ) )

  (setq
    file (close file)
  )

  (command "script" "dprint")

  (setq *error* nil)
  (princ)
)
(princ)
