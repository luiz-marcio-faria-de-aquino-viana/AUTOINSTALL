
;;
;; K40C0.lsp
;; Copyright (C) 1993-98 by Luiz Marcio F A Viana, 1/23/98
;;

;; definicao das variaveis globais
(or #PRLARG (setq #PRLARG (* 13.6 25.4)) )  ;; largura da folha
(or #PRALT  (setq #PRALT  (* 11.0 25.4)) )  ;; altura da folha
(or #PRROT  (setq #PRROT           "No") )  ;; rotacao do papel
(or #PRSCL  (setq #PRSCL  (* (#SCL) (#UND))) )  ;; escala de impressao

;; c:mprint(): rotina de impressao dinamica com multiplas paginas
(defun c:mprint(/ oldech olddrag oldhigh oldblip larg alt rot scl npx npy fname fat xpapel ypapel
  deltx delty cnivel pti pt1 pt2 enm1 pt ptmin ptmax n xpos ypos pfx1 pfx2 pta fn lpfx1 lpfx2)

  (m:savevars)

  (setq larg (getdist (strcat "\nLargura da folha <" (rtos #PRLARG 2 2) ">: ")) )
  (if larg (setq #PRLARG larg))

  (setq alt (getdist (strcat "\nAltura da folha <" (rtos #PRALT 2 2) ">: ")) )
  (if alt (setq #PRALT alt))

  (initget "Yes No")
  (setq rot (getkword (strcat "\nRodar desenho de 90d <" #PRROT ">: ")) )
  (if rot (setq #PRROT rot))

  (initget 2)
  (setq scl (getdist (strcat "\nEscala para impressao 1/<" (rtos #PRSCL 2 2) ">: ")) )
  (if scl (setq #PRSCL scl))

  (initget 7)
  (setq npx (getint "\nNumero de folhas na horizontal: "))

  (initget 7)
  (setq npy (getint "\nNumero de folhas na vertical: "))

  (while (> (strlen (setq fname (getstring (strcat "\nNome do arquivo <" (substr (getdwgname) 1 6) ">: "))) ) 6)
    (prompt "\nERR: Entre com no maximo 6 caracteres.") )
  (if (= fname "") (setq fname (substr (getdwgname) 1 6)) )

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

  (setq
      xpapel (* npx deltx)
      ypapel (* npy delty)
  ) ; end setq

  (setq
    olddrag (acadvar "dragmode"  2)
    oldhigh (acadvar "highlight" 0)
    oldblip (acadvar "blipmode"  0)
  ) ; end setq

  (setq cnivel (slay "$PRINT"))

  (setq pti (cadr (grread t)))
  (setq
    pt1 (list (- (car pti)  (/ xpapel 2.0)) (- (cadr pti) (/ ypapel 2.0)) )
    pt2 (list (+ (car pti)  (/ xpapel 2.0)) (+ (cadr pti) (/ ypapel 2.0)) )
  ) ; end setq

  (command
    ".pline"
      pt1 "w" 0 0
      (list (car pt2) (cadr pt1))
      pt2
      (list (car pt1) (cadr pt2))
      "c"
    ".move"
      (setq enm1 (entlast)) "" pti
  ) ; end command
  (redraw enm1 2)
  (prompt "\nSelecione area para impressao...")
  (command pause)

  (setq pt (getvar "lastpoint"))
  (setq
    ptmin (list (- (car pt) (/ xpapel 2.0)) (- (cadr pt) (/ ypapel 2.0)) )
    ptmax (list (+ (car pt) (/ xpapel 2.0)) (+ (cadr pt) (/ ypapel 2.0)) )
  ) ; end setq

  (setq n 1)
  (setq
    xpos (car  ptmin)
    ypos (cadr ptmax)
  ) ; end setq
  (if (= #PRROT "No")
    (while (< (setq xpos (+ xpos deltx)) (car ptmax))
      (command
        ".pline"
          (list xpos (cadr ptmin)) "w" 0 0
          (list xpos (cadr ptmax))
          ""
      ) ; end command
      (setq n (1+ n))
    ) ; end while
    (while (> (setq ypos (- ypos delty)) (cadr ptmin))
      (command
        ".pline"
          (list (car ptmin) ypos) "w" 0 0
          (list (car ptmax) ypos)
          ""
      ) ; end command
      (setq n (1+ n))
    ) ; end while
  ) ; end if

  (setvar "dragmode"  olddrag)
  (setvar "highlight" oldhigh)
  (setvar "blipmode"  oldblip)

  (slay cnivel)

  (getstring "\nTecle [ENTER] para prosseguir... ")

  (setq
    pfx1 65
    pfx2 65
  ) ; end setq

  (setq
    pta  (list (car ptmin) (cadr ptmax))
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

      (setq fn (V:SPOOL (strcat "PRINT\\" fname (chr pfx1) (chr pfx2))) )
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
      (setq pfx1 65 pfx2 (1+ pfx2))
      (setq pfx1 (1+ pfx1) pfx2 65)
    ) ; end if
  ) ; end while

  (repeat n (command ".erase" "l" ""))

  (command
    ".shell"
    (strcat
      "mprint "
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
