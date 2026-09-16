
;;
;; PSPACE.lsp
;; Copyright (C) 1995 by Luiz Marcio F A Viana, 12/6/95
;;

;;
;; XLIST: add real number to list

(defun XLIST(lst xi / dx)
  (setq dx (#SCL))
  (if (null lst)
    (list xi)
    (if (> (abs (- xi (car lst))) dx)
      (append
        (list (car lst))
        (xlist (cdr lst) xi)
      ) ; end append
      lst
    ) ; end if
  ) ; end if
) ; end defun

;;
;; PSMARG: procedure to insert array of margins on pspace

(defun C:PSMARG(/ FORM dx dy frm lst blk xm ym cnivel pti NX NY)
  (setvar "cmdecho" 0)

  (setq
    FORM '((    "A0" . ("SET/SET01C03" 1189.0  841.0))
           (    "A1" . ("SET/SET02C03"  841.0  594.0))
           (    "A2" . ("SET/SET03C03"  594.0  420.0))
           (    "A3" . ("SET/SET04C03"  420.0  297.0))
           (   "2A2" . ("SET/SET05C03" 1189.0  420.0))
           (   "2A3" . ("SET/SET06C03"  841.0  297.0))
           (  "A1A2" . ("SET/SET07C03" 1189.0  594.0))
           (  "A2A3" . ("SET/SET08C03"  891.0  420.0))
           (  "A3A4" . ("SET/SET09C03"  630.0  297.0))
           ("A2A3A4" . ("SET/SET0AC03" 1050.0  297.0)))
  ) ; end setq

  (setq
    dx 0.0
    dy 0.0
  ) ; end setq

  (if (findfile (V:AIS "set-00c.sld")) (command "vslide" (V:AIS "set-00c")))
  (initget 1 "A0 A1 A2 A3 2A2 2A3 A1A2 A2A3 A3A4 A2A3A4")
  (setq frm (getkword "\nFormato do papel: "))
  (setq lst (cdr (assoc frm FORM)))

  (setq
    blk (car lst)
    xm  (+ (cadr lst) dx)
    ym  (+ (caddr lst) dy)
  ) ; end setq

;  (command ".undo" "g")
  (setvar "tilemode" 0)

  (if (tblsearch "layer" "_PSMARG_")
    (command ".layer" "t" "_PSMARG_" "")
  ) ; end if
  (setq cnivel (getvar "clayer"))
  (command
    ".layer" "m" "_PSMARG_" ""
    ".pspace"
  ) ; end command

  (setq pti (getpoint "\nPonto de insercao (default = 0,0): "))
  (if (null pti) (setq pti '(0.0 0.0)))
  (initget "Yes No")
  (if (= (getkword "\nEfetuar array da margem <No>: ") "Yes")
    (progn
      (initget 6)
      (setq NX (getint "\nNumero de colunas <1>: "))
      (if (null NX) (setq NX 1))
      (initget 6)
      (setq NY (getint "\nNumero de linhas <1>: "))
      (if (null NY) (setq NY 1))
    ) ; end progn
    (setq
      NX 1
      NY 1
    ) ; end setq
  ) ; end if

  (command ".insert" (V:AID blk) pti (#SCL) "" "")
  (cond
    ( (and (> NX 1) (> NY 1))
      (command ".array" "l" "" "r" NY NX (* ym (#SCL)) (* xm (#SCL)))
    ) ; end case
    ( (> NX 1) (command ".array" "l" "" "r" NY NX (* xm (#SCL))) )
    ( (> NY 1) (command ".array" "l" "" "r" NY NX (* ym (#SCL))) )
  ) ; end cond
  (command
    ".zoom" "a"
    ".layer" "s" cnivel ""
;    ".undo" "e"
  ) ; end command
  (setvar "tilemode" 1)

  (princ)
) ; end defun

;;
;; PSWIN: procedure to create mviews from drawing

(defun C:PSWIN(/ pta ptb pt1 pt2 xl yl ss cnt pti NX NY deltx delty cnivel pti1 pta1 N)
  (setvar "cmdecho" 0)

;  (command ".undo" "g")

  (prompt "Selecione a janela...")

  (initget 1)
  (setq pta (getpoint "\nPrimeiro canto: "))
  (initget 1)
  (setq ptb (getcorner pta "\nSegundo canto: "))
  (initget "Yes No")
  (setq
    pt1 (list (min (car pta) (car ptb)) (min (cadr pta) (cadr ptb)))
    pt2 (list (max (car pta) (car ptb)) (max (cadr pta) (cadr ptb)))
  ) ; end setq

  (initget 6)
  (setq ft (getreal (strcat "\nEscala para apresentacao <" (rtos (#ESCL) 2 2) ">: ")))
  (if (null ft) (setq ft (#ESCL)))

  (initget "Yes No")
  (if (= (getkword "\nSubdividir a area selecionada <No>: ") "Yes")
    (progn
      (initget "Yes No")
      (if (= (getkword "\nExecutar processo automaticamente <No>: ") "Yes")
        (progn
          (setvar "tilemode" 0)
          (command ".pspace")
          (setq
            xl nil
            yl nil
          ) ; end setq
          (if (setq ss (ssget "x" '((0 . "INSERT") (8 . "_PSMARG_"))))
            (progn
              (setq cnt (sslength ss))
              (while (not (zerop cnt))
                (setq cnt (- cnt 1))
                (setq pti (cdr (assoc 10 (entget (ssname ss cnt)))) )
                (setq xl (xlist xl (car pti)))
                (setq yl (xlist yl (cadr pti)))
              ) ; end while
              (setq
                NX (length xl)
                NY (length yl)
              ) ; end setq
            ) ; end progn
            (setq
              NX 1
              NY 1
            ) ; end setq
          ) ; end if
        ) ; end progn
        (progn
          (initget 6)
          (setq NX (getint "\nNumero de colunas <1>: "))
          (if (null NX) (setq NX 1))
          (initget 6)
          (setq NY (getint "\nNumero de linhas <1>: "))
          (if (null NY) (setq NY 1))
        ) ; end progn
      ) ; end if
    ) ; end progn
    (setq
      NX 1
      NY 1
    ) ; end setq
  ) ; end if

  (setq
    deltx (/ (abs (- (car pt1) (car pt2))) NX)
    delty (/ (abs (- (cadr pt1) (cadr pt2))) NY)
  ) ; end setq

  (command
    ".ucs" "d" "$PSWIN"
    ".ucs" "s" "$PSWIN"
  ) ; end command
  (setvar "tilemode" 0)
  (command ".pspace")

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (if (tblsearch "layer" "_PS0_")
    (command ".layer" "t" "_PS0_" "")
  ) ; end if
  (setq cnivel (getvar "clayer"))
  (command ".layer" "m" "_PS0_" "")
  (setq
    pti1 pti
    pta1 pt1
    N NX
  ) ; end setq
  (while (not (zerop NY))
    (while (not (zerop NX))
      (command
        ".mview" pti1 (list (+ (car pti1) (* deltx (/ (#ESCL) ft))) (+ (cadr pti1) (* delty (/ (#ESCL) ft))))
        ".mspace"
        ".ucs" "r" "$PSWIN"
        ".plan" ""
        ".zoom" "w" pta1 (list (+ (car pta1) deltx) (+ (cadr pta1) delty))
        ".pspace"
      ) ; end command
      (setq pti1 (list (+ (car pti1) (* deltx (/ (#ESCL) ft))) (cadr pti1)))
      (setq pta1 (list (+ (car pta1) deltx) (cadr pta1)))
      (setq NX (- NX 1))
    ) ; end while
    (setq pti1 (list (car pti) (+ (cadr pti1) (* delty (/ (#ESCL) ft)))))
    (setq pta1 (list (car pt1) (+ (cadr pta1) delty)))
    (setq NX N)
    (setq NY (- NY 1))
  ) ; end while

  (command
    ".layer" "s" "0" ""
    ".insert" (V:AID "SET/SET0FC00") "0,0" "" "" ""
  ) ; end command
  (command
    ".layer" "s" cnivel ""
;    ".undo" "e"
  ) ; end command

  (princ)
) ; end defun

;;
;; PSCAR: routine to insert stamps in pspace mode

(defun C:PSCAR(/ oldech oldlay FORM CARM pti px py opcao ss ent ff pti larg alt)
  (setq oldech (acadvar "cmdecho" 0))

  (setq
    FORM '(("SET01C03" 1189.0  841.0)
           ("SET02C03"  841.0  594.0)
           ("SET03C03"  594.0  420.0)
           ("SET04C03"  420.0  297.0)
           ("SET05C03" 1189.0  420.0)
           ("SET06C03"  841.0  297.0)
           ("SET07C03" 1189.0  594.0)
           ("SET08C03"  891.0  420.0)
           ("SET09C03"  630.0  297.0)
           ("SET0AC03" 1050.0  297.0)
           ("SET01C02" 1189.0  841.0)
           ("SET02C02"  841.0  594.0)
           ("SET03C02"  594.0  420.0)
           ("SET04C02"  420.0  297.0)
           ("SET05C02" 1189.0  420.0)
           ("SET06C02"  841.0  297.0)
           ("SET07C02" 1189.0  594.0)
           ("SET08C02"  891.0  420.0)
           ("SET09C02"  630.0  297.0)
           ("SET0AC02" 1050.0  297.0))
  ) ; end setq

  (setq
    CARM '(("EL" "EL/EL00C04" "EL-TEXTOS")
           ("ES" "ES/ES00C04" "ES-TEXTOS")
           ("H"  "H/H00C04"    "H-TEXTOS")
           ("G"  "G/G00C04"    "G-TEXTOS")
           ("TE" "TE/TE00C04" "TE-TEXTOS")
           ("TI" "TI/TI00C04" "TI-TEXTOS")
           ("IE" "IE/IE00C04" "IE-TEXTOS")
           ("AR" "AR/AR00C04" "AR-TEXTOS")
           ("PC" "PC/PC00C04" "PC-TEXTOS")
           ("EX" "EX/EX00C04" "EX-TEXTOS") )
  ) ; end setq

  (setvar "tilemode" 0)
  (command
;    ".undo" "g"
    ".pspace"
  ) ; end command

  (initget 1 "EL ES H G TE TI IE AR PC EX")
  (setq opcao (getkword "\nCarimbo (EL, ES, H, G, TE, TI, IE, AR, PC ou EX): "))
  (setq
    blk (cadr  (assoc opcao CARM))
    lay (caddr (assoc opcao CARM))
  ) ; end setq

  (initget "Yes No")
  (setq resp (getkword "\nCarimbo para ante-projeto <Yes>? "))

  (if (setq ss (entsel "\nSelecione uma margem: "))
    (progn
      (setq ent (entget (car ss)))
      (setq ff (cdr (assoc 2 ent)))
      (setq pti (cdr (assoc 10 ent)))
      (setq
        larg (* (cadr  (assoc ff FORM)) (#SCL))
        alt  (* (caddr (assoc ff FORM)) (#SCL))
      ) ; end setq
      (setq
        px (+ (car pti) larg)
        py (cadr         pti)
      ) ; end setq
      (setq oldlay (slay lay))
      (command
        ".insert" (v:aid "SET/SET20C00") (list px py) (#SCL) "" 0
        ".insert" (v:aid blk)            (list px py) (#SCL) "" 0
      ) ; end command
      (setq ss (entlast))
      (if (/= resp "No")
        (command
          ".text"
            "m"
            (list (- px (*  97.5 (#SCL))) (+ py (* 153.5 (#SCL))) )
            (* 15.0 (#SCL))
            45
            "ANTEPROJETO"
        ) ; end command
      ) ; end if
      (slay oldlay)
      (command ".ddatte" ss)
    ) ; end progn
  ) ; end if

  (setvar "cmdecho" oldech)
  (princ)
);end defun

(princ)
