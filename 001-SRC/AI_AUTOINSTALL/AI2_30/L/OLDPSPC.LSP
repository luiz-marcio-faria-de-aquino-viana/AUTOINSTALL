
;;
;;  PSPACE.lsp
;; --------------------------------------------------------------------------
;;


(defun C:OLDPSMARG()
  (setvar "cmdecho" 0)

  (setq
    FORM '((    "A0" "SET01C01") (  "A1" "SET02C01") (  "A2" "SET03C01")
           (    "A3" "SET04C01") ( "2A2" "SET05C01") ( "2A3" "SET06C01")
           (  "A1A2" "SET07C01") ("A2A3" "SET08C01") ("A3A4" "SET09C01")
           ("A2A3A4" "SET0AC01"))
  ) ; end setq

  (if (findfile "set-00c.sld") (command "vslide" "set-00c"))
  (initget 1 "A0 A1 A2 A3 2A2 2A3 A1A2 A2A3 A3A4 A2A3A4")
  (setq frm (getkword "\nFormato do papel: "))
  (setq blk (cadr (assoc frm FORM)))

  (command ".undo" "g")
  (setvar "tilemode" 0)
  (if (tblsearch "layer" "_PSMARG_")
    (command ".layer" "t" "_PSMARG_" "")
  ) ; end if
  (setq cnivel (getvar "clayer"))
  (command
    ".layer" "m" "_PSMARG_" ""
    ".pspace"
  ) ; end command
  (setq pti (getpoint "\nPonto de insercao <0,0>: "))
  (if (null pti) (setq pti '(0.0 0.0)))
  (command
    ".insert" blk pti "" "" ""
    ".zoom" "a"
    ".layer" "s" cnivel ""
    ".undo" "e"
  ) ; end command
  (setvar "tilemode" 1)

  (princ)
) ; end defun


(defun C:OLDPSWIN()
  (setvar "cmdecho" 0)

  (initget 1)
  (setq pt1 (getpoint "\nPrimeiro canto: "))
  (initget 1)
  (setq pt2 (getcorner pt1 "\nSegundo canto: "))
  (setq
    dx (/ (abs (- (car pt1) (car pt2))) #SCL)
    dy (/ (abs (- (cadr pt1) (cadr pt2))) #SCL)
  ) ; end setq

  (command
    ".undo" "g"
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
  (command
    ".layer" "m" "_PS0_" ""
    ".mview" pti (list (+ (car pti) dx) (+ (cadr pti) dy))
    ".mspace"
    ".ucs" "r" "$PSWIN"
    ".plan" ""
    ".zoom" "w" pt1 pt2
    ".pspace"
    ".layer" "s" cnivel ""
    ".undo" "e"
  ) ; end command

  (princ)
) ; end defun


(defun C:OLDPSCAR(/ pti opcao)
  (setvar "cmdecho" 0)

  (initget 1 "EL ES IE TE TI AR G H")
  (setq opcao (getkword "\nCarimbo (EL,ES,H,G,TE,TI,IE ou AR): "))
  (setvar "tilemode" 0)
  (command ".pspace")
  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))
  (command "insert" (strcat opcao "00c02") pti "" "" 0)

  (princ)
);end defun


(princ)
