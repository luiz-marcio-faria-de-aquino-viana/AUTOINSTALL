
;                                dF A X (R)
;   ________________________________________________________________________
;         Copyright (C) 1994 by TML Software, Inc. All Rights Reserved.


;    THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
;    ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR PURPOSE AND OF
;    MERCHANTABILITY ARE HEREBY DISCLAIMED.
;   ________________________________________________________________________


;    DESCRIPTION:

;    LISP dFAX application - by Luiz Marcio Viana - 2/20/95


(defun c:dfax()

  (setvar "cmdecho" 0)

  (defun *error*(msg)
    (prompt msg)
    (setvar "blipmode" 1)
    (setvar "highlight" 1)
    (setq *error* nil)
    (princ)
  )

  (setq
    NROT "0"
    YROT "90"
  )

  (setq
    LARG 210.0
    ALT 279.0
  )

  (setq FAT (/ 100.0 180.0))    ;; 180dpi to 100dpi

  (or #prrot (setq
               #prrot "No"
  )          )
  (or #prscl (setq
               #prscl (* (#SCL) (#UND))
  )          )

  (initget "Yes No")
  (setq rot (getkword (strcat "\nRodar desenho de 90d <" #prrot ">: ")) )
  (if rot (setq #prrot rot))

  (initget 2)
  (setq
    scl (getdist
          (strcat "\nEscala para impressao 1/<" (rtos #prscl 2 2) ">: ")
  )     )
  (if scl (setq #prscl scl))

  (setq fname (getstring (strcat "\nNome do arquivo <" (getdwgname) ">: ")))
  (if (/= fname "")
    (setq fname (strcat "C:\\SPOOL\\FAX\\" fname))
    (setq fname (strcat "C:\\SPOOL\\FAX\\" (getdwgname)))
  ) ; end if

  (while (= (setq faxn (getstring "\nInforme o numero do fax: ")) "")
    (prompt "\n* ERRO * O numero do fax nao foi informado.")
  )

  (setq
    pt1 (cadr (grread T))
  )

  (if (= #prrot "Yes")
    (setq
      deltax (/ (* ALT (/ #prscl (#UND))) 2.0)
      deltay (/ (* LARG (/ #prscl (#UND))) 2.0)
    )
    (setq
      deltax (/ (* LARG (/ #prscl (#UND))) 2.0)
      deltay (/ (* ALT (/ #prscl (#UND))) 2.0)
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
  (if (tblsearch "layer" "_DFAX_")
    (command "layer" "t" "_DFAX_" "m" "_DFAX_" "")
    (command "layer" "m" "_DFAX_" "")
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
  (prompt "\n--- Selecione area para o fax ---\n")
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

  (setq file (open "dfax.scr" "w"))

    (write-line "PRplot" file)
    (write-line "Window" file)
    (write-line (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6)) file)
    (write-line (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6)) file)
    (write-line "Yes" file)
    (write-line "M" file)
    (write-line "0,0" file)
    (write-line (strcat (rtos LARG 2 6) "," (rtos ALT 2 6)) file)
    (write-line #prrot file)
    (write-line "No" file)
    (write-line (strcat (rtos FAT 2 6) "=" (rtos (/ #prscl (#UND)) 2 6)) file)
    (write-line fname file)
    (write-line "" file)

    (write-line "shell" file) 
    (write-line (strcat "dfax " fname " " faxn) file)

  (setq file (close file))

  (command "script" "dfax")

  (setq *error* nil)
  (princ)
)
(princ)
