
;;
;; K3AC0.lsp
;; Copyright (C) 1993-98 by Luiz Marcio F A Viana, 1/16/98
;;

;; definicao das variaveis globais
(or #PRLARG (setq #PRLARG (* 13.6 25.4)) )  ;; largura da folha
(or #PRALT  (setq #PRALT  (* 11.0 25.4)) )  ;; altura da folha
(or #PRROT  (setq #PRROT           "No") )  ;; rotacao do papel
(or #PRSCL  (setq #PRSCL  (* (#SCL) (#UND))) )  ;; escala de impressao

;; c:printc(): programa de impressao continua
(defun c:printc(/ oldech larg alt rot scl pt1 pt2 fname ptmax ptmin xpapel ypapel
  fat deltx delty cnivel n xpos ypos pfx1 pfx2 pta lpfx1 lpfx2)

  (m:savevars)

  (initget 6)
  (setq larg (getdist (strcat "\nLargura da folha <" (rtos #PRLARG 2 2) ">: ")) )
  (if larg (setq #PRLARG larg))

  (initget 6)
  (setq alt (getdist (strcat "\nAltura da folha <" (rtos #PRALT 2 2) ">: ")) )
  (if alt (setq #PRALT alt))

  (initget "Yes No")
  (setq rot (getkword (strcat "\nRodar desenho de 90d <" #PRROT ">: ")) )
  (if rot (setq #PRROT rot))

  (initget 2)
  (setq scl (getdist (strcat "\nEscala para impressao 1/<" (rtos #PRSCL 2 2) ">: ")) )
  (if scl (setq #PRSCL scl))

  (initget 1)
  (setq pt1 (getpoint "\nPrimeiro corner: "))

  (initget 1)
  (setq pt2 (getcorner pt1 "\nSegundo corner: "))

  (while (> (strlen (setq fname (getstring (strcat "\nNome do arquivo <" (substr (getdwgname) 1 6) ">: "))) ) 6)
    (prompt "\nERR: Entre com no maximo seis caracteres.") )
  (if (= fname "") (setq fname (substr (getdwgname) 1 6)) )

  (setq
    ptmax (list
            (max (car pt1) (car pt2))
            (max (cadr pt1) (cadr pt2))
          ) ; end list
    ptmin (list
            (min (car pt1) (car pt2))
            (min (cadr pt1) (cadr pt2))
          ) ; end list
  ) ; end setq

  (setq
    xpapel (- (car  ptmax) (car  ptmin))
    ypapel (- (cadr ptmax) (cadr ptmin))
  ) ; end setq

  (setq fat (/ #PRSCL (#UND)))
  (if (= #PRROT "No")
    (setq
      deltx (* #PRLARG fat)
      delty (* #PRALT  fat)
    ) ; end setq
    (setq
      deltx (* #PRALT  fat)
      delty (* #PRLARG fat)
    ) ; end setq
  ) ; end if

  (setq cnivel (slay "$PRINT"))

  (command
    "pline"
      ptmin "w" 0 0
      (list (car ptmax) (cadr ptmin))
      ptmax
      (list (car ptmin) (cadr ptmax))
      "c"
  ) ; end command

  (setq n 1)
  (setq
    xpos (car  ptmin)
    ypos (cadr ptmax)
  ) ; end setq

  (if (= #PRROT "No")
    (while (< (setq xpos (+ xpos deltx)) (car ptmax))
      (command "pline" (list xpos (cadr ptmin)) "w" 0 0 (list xpos (cadr ptmax)) "")
      (setq n (1+ n))
    ) ; end while
    (while (> (setq ypos (- ypos delty)) (cadr ptmin))
      (command "pline" (list (car ptmin) ypos) "w" 0 0 (list (car ptmax) ypos) "")
      (setq n (1+ n))
    ) ; end while
  ) ; end if

  (slay cnivel)

  (getstring "\nTecle [ENTER] para prosseguir... ")

  (setq
    pfx1 65
    pfx2 65
  ) ; end setq

  (setq
    pta (list (car ptmin) (cadr ptmax))
    ypos (cadr ptmax)
  ) ; end setq

  (setvar "plotid" "print")
  (while (> ypos (cadr ptmin))
    (setq
      xpos (car ptmin)
      ypos (- ypos delty)
    ) ; end setq
    (if (< ypos (cadr ptmin)) (setq ypos (cadr ptmin)) )
    (while (< xpos (car ptmax))
      (setq xpos (+ xpos deltx))
      (if (> xpos (car ptmax)) (setq xpos (car ptmax)) )

      (command
        ".plot"
          "Window"
          (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6))
          (strcat (rtos xpos 2 6) "," (rtos ypos 2 6))
          "Yes"
          "No"
          "M"
          "0,0"
          (strcat (rtos #PRLARG 2 6) "," (rtos #PRALT 2 6))
      ) ; end command

      (if (= #PRROT "No") (command  "0") (command "90") )

      (command
        "No"
        (strcat "1=" (rtos fat 2 6))
      ) ; end command

      (setq fn (V:SPOOL (strcat "PRINT/" fname (chr pfx1) (chr pfx2))) )
      (if (findfile (strcat fn ".prp"))
        (command fn "Yes")
        (command fn)
      ) ; end if

      (setq
        lpfx1 pfx1
        lpfx2 pfx2
      ) ; end setq
      (setq pta (list xpos (cadr pta)) )
      (if (= #PRROT "No")
        (setq pfx1 (1+ pfx1))
        (setq pfx2 (1+ pfx2))
      ) ; end if
    ) ; end while

    (setq pta (list (car ptmin) ypos))
    (if (= #PRROT "No")
      (setq
        pfx1 65
        pfx2 (1+ pfx2)
      ) ; end setq
      (setq
        pfx1 (1+ pfx1)
        pfx2 65
      ) ; end setq
    ) ; end if
  ) ; end while

  (repeat n (command ".erase" "l" ""))

  (command
    ".shell"
    (strcat
      "printc "
      (V:SPOOL (strcat "PRINT\\" fname))
      " "
      (chr lpfx1)
      (chr lpfx2)
    ) ; end strcat
  ) ; end command

  (m:restorevars)
  (princ)
) ; end defun

(princ)
