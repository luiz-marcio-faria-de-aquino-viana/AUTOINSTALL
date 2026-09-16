
;;
;; K1BC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 12/28/97
;;

(defun c:setup(/ ss ename ent tag fpapel dpapel npapel fescl funid)
  (setvar "cmdecho" 0)

  (command
    ".vslide" (V:AIS "SET-00C")
    ".layer"  "t" "0" "s" "0" ""
  ) ; end command

  (initget 1 "A0 A1 A2 A3 2A2 2A3 A2A3A4 A1A2 A2A3 A3A4 Outro")
  (setq
    fpapel (getkword "\nFormato do papel: ")
    dpapel '((    "A0" . ("SET/SET01C03" 1189  841))
             (    "A1" . ("SET/SET02C03"  841  594))
             (    "A2" . ("SET/SET03C03"  594  420))
             (    "A3" . ("SET/SET04C03"  420  297))
             (   "2A2" . ("SET/SET05C03" 1189  420))
             (   "2A3" . ("SET/SET06C03"  841  297))
             (  "A1A2" . ("SET/SET07C03" 1189  594))
             (  "A2A3" . ("SET/SET08C03"  891  420))
             (  "A3A4" . ("SET/SET09C03"  630  297))
             ("A2A3A4" . ("SET/SET0AC03" 1050  297)) )
  ) ; end setq

  (if (= fpapel "Outro")
    (progn
      (initget 7)
      (setq #XPAPEL (getint "\nLargura da folha (mm): ") )
      (initget 7)
      (setq #YPAPEL (getint "\nAltura da folha (mm): ") )
    ) ; end progn
    (progn
      (setq
        npapel  (cadr   (assoc fpapel dpapel))
        #XPAPEL (caddr  (assoc fpapel dpapel))
        #YPAPEL (cadddr (assoc fpapel dpapel))
      ) ; end setq
    ) ; end progn
  ) ; endif

  (command "redraw")
  (menucmd "s=escala")

  (initget 7)
  (setq fescl (getreal "\nEscala do desenho: ") )

  (menucmd "s=unidade")
  (initget 1 "MM CM M Outro")
  (setq funid (getkword "\nUnidade de trabalho: ") )

  (if (= funid "Outro")
    (progn
      (initget 7)
      (setq (#UND) (* (getreal "\nRelacao com a unidade (m): ") 1000.0) )
    ) ; end progn
    (progn
      (cond
        ((= funid "MM") (setq (#UND)    1.0))
        ((= funid "CM") (setq (#UND)   10.0))
        ((= funid  "M") (setq (#UND) 1000.0))
      ) ; end cond
    ) ; end progn
  );endif

  (setq (#VER) "AI3.00")

  (setvar "userr1" fescl)
  (setvar "userr2" (#UND))

  (setq (#SCL) (/ fescl (#UND)) )
  (setvar "dimscale" (#SCL))

  (setvar "ltscale" (* 10.0 (#SCL)))
  (setvar "textsize" (* (#SCL) 2.0))

  (setvar "snapunit" (list (/  25.0 (#UND)) (/  25.0 (#UND))) )
  (setvar "gridunit" (list (/ 250.0 (#UND)) (/ 250.0 (#UND))) )

  (command
    ".layer" "s" 0 ""
    ".limits" "0,0" (list (* (#SCL) #XPAPEL) (* (#SCL) #YPAPEL))
    ".zoom" "a"
  ) ; end command

  (setq oldatt (acadvar "attreq" 0))
  (if (= fpapel "Outro")
    (command
      ".pline" "0,0" "w" 0 ""
              (list (* (#SCL) #XPAPEL) 0)
              (list (* (#SCL) #XPAPEL) (* (#SCL) #YPAPEL))
              (list 0 (* (#SCL) #YPAPEL)) "c"
      ".pline" (list (* 20.0 (#SCL)) (* 10.0 (#SCL)))
              (list (* (- #XPAPEL 10.0) (#SCL)) (* 10.0 (#SCL)))
              (list (* (- #XPAPEL 10.0) (#SCL)) (* (- #YPAPEL 10.0) (#SCL)))
              (list (* 20.0 (#SCL)) (* (- #YPAPEL 10.0) (#SCL))) "c"
      ".copy" "l" "" "m" "0,0"
              (list (* (#SCL) 0.5) (* (#SCL) 0.5))
              (list (#SCL) (#SCL)) ""
      ".insert" (V:AID "SET00c01")
              (list (* (- #XPAPEL 10.0) (#SCL)) (* 10.0 (#SCL)))
              (#SCL) "" 0
    ) ; end command
    (command ".insert" (V:AID npapel) "0,0" (#SCL) "" 0)
  ) ; end if

  (setq
    (#VER) "AI3.00"
    (#ESCL) fescl
    (#OWNER) (getenv "USR")
    (#DATE) (strcat
            (substr (rtos (getvar "cdate") 2 6) 7 2) "/"
            (substr (rtos (getvar "cdate") 2 6) 5 2) "/"
            (substr (rtos (getvar "cdate") 2 6) 3 2)
          ) ; end strcat
  ) ; end setq

  (if (null (setq ss (ssget "x" '((0 . "INSERT") (2 . "SET0EC00")))))
    (command ".insert" (V:AID "SET/SET0EC00") "0,0" "" "" "" (#VER) #XPAPEL #YPAPEL (#ESCL) (#UND) (#OWNER) (#DATE))
    (progn
      (setq ename (entnext (ssname ss (- (sslength ss) 1))) )
      (while (/= (cdr (assoc 0 (setq ent (entget ename)))) "SEQEND")
        (progn
          (setq tag (cdr (assoc 2 ent)))
          (cond
            ((= tag "(#VER)") (setq ent (subst (cons 1 (#VER)) (assoc 1 ent) ent)) )
            ((= tag "(#LARG)") (setq ent (subst (cons 1 (rtos #XPAPEL 2 2)) (assoc 1 ent) ent)) )
            ((= tag "(#ALT)") (setq ent (subst (cons 1 (rtos #YPAPEL 2 2)) (assoc 1 ent) ent)) )
            ((= tag "(#ESCL)") (setq ent (subst (cons 1 (rtos (#ESCL) 2 2)) (assoc 1 ent) ent)) )
            ((= tag "#UNID") (setq ent (subst (cons 1 (rtos (#UND) 2 2)) (assoc 1 ent) ent)) )
            ((= tag "(#OWNER)") (setq ent (subst (cons 1 (#OWNER)) (assoc 1 ent) ent)) )
            ((= tag "(#DATE)") (setq ent (subst (cons 1 (#DATE)) (assoc 1 ent) ent)) )
          ) ; end cond
          (entmod ent)
          (setq ename (entnext ename))
        ) ; end progn
      ) ; end while
    ) ; end progn
  ) ; end if

  (setvar "attreq" oldatt)

  (command ".menu" (V:AIM "arqmenu"))

  (princ)
) ; end function

(princ)
