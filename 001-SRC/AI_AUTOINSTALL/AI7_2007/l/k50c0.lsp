
;;
;; K50C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 1/26/96.
;;
;; XFSPLIT: rotina para separar instalacoes e criar XREF

(defun xlay(ls / act)
  (setvar "cmdecho" 0)
  (command ".layer")
  (foreach act ls (command act))
  (command "")
) ; end defun

(defun xfil(ff ls sfx / fp elem)
  (if (setq fp (open (strcat ff ".xrf") "w"))
    (progn
      (foreach elem ls (write-line (strcat elem sfx "=\\xref\\" elem "\\" elem sfx) fp))
      (setq fp (close fp))
    ) ; end progn
  ) ; end if
) ; end defun

(defun xblk(ff / ss)
  (if (findfile (strcat ff ".dwg"))
    (command ".wblock" ff "y")
    (command ".wblock" ff)
  ) ; end if
  (command "" "0,0")
  (if (setq ss (ssget "x" '((0 . "INSERT") (2 . "SET0EC00"))) ) (command ss))
  (command "c" (getvar "extmin") (getvar "extmax") "")
  (command ".oops")
) ; end defun

(defun c:xfsplit(/ oldech rpl LLAY sfx ls ff cmd opt)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (setq rpl "No")
  (setq
    LLAY '( ("ARQ"  ("s" "ARQ-ARQUITETURA"
                     "f" "0"
                     "f" "el-*"
                     "f" "es-*"
                     "f" "h-*"
                     "f" "g-*"
                     "f" "te-*"
                     "f" "ti-*"
                     "f" "ie-*"
                     "f" "ar-*")
                     nil
            )
            ("EL"   ("t" "0"
                     "s" "0"
                     "f" "*"
                     "t" "EL-*")
                    ("ARQ")
            )
            ("ES"   ("f" "EL-*"
                     "t" "ES-*")
                    ("ARQ")
            )
            ("H"    ("f" "ES-*"
                     "t" "H-*")
                    ("ARQ")
            )
            ("G"    ("f" "H-*"
                     "t" "G-*")
                    ("ARQ")
            )
            ("AR"   ("f" "G-*"
                     "t" "AR-*")
                    ("ARQ")
            )
            ("IE"   ("f" "IE-*"
                     "t" "TE-*"
                     "t" "TI-*"
                     "t" "IE-*")
                    ("ARQ")
            )
          )
  ) ; end setq

  (setq sfx (getstring (strcat "\nPrefixo do arquivo (MAX=5) <" (substr (getdwgname) 1 5) ">: ")))
  (if (= sfx "") (setq sfx (substr (getdwgname) 1 5)) (setq sfx (substr sfx 1 5)))

  (initget "Yes No")
  (setq spc (getkword "\nEfetuar a separacao do paper space <Yes>? "))
  (if (null spc) (setq spc "Yes"))

  (command ".shell" (strcat "xsplit " (getdwgdrive) " " (getdwgpath)) )

  (setvar "tilemode" 1)
  (command
    ".layer" "t" "*" ""
    ".ucs" ""
    ".plan" ""
  ) ; end command

  (foreach ls LLAY
    (setq ff (strcat (getdwgdrive) (getdwgpath) "\\xref\\" (car ls) "\\" (car ls) sfx))
    (command ".layer")
    (foreach cmd (cadr ls) (command cmd))
    (command "")
    (if (and (/= rpl "All") (findfile (strcat ff ".dwg")) )
      (progn
        (initget "Yes No All")
        (setq opt (getkword (strcat "\nSobrescrever o arquivo " ff " (Yes/<No>/All)? ")))
        (if (null opt) (setq rpl "No") (setq rpl opt))
        (if (not (= rpl "No"))
          (progn
            (xblk ff)
            (if (caddr ls) (xfil ff (caddr ls) sfx))
          ) ; end progn
        ) ; end if
      ) ; end progn
      (progn
        (xblk ff)
        (if (caddr ls) (xfil ff (caddr ls) sfx))
      ) ; end progn
    ) ; end if
  ) ; end foreach

  (command ".layer" "t" "*" "")

  (if (= spc "Yes")
    (progn
      ;; efetua a separacao do pspace
      (setq ff (strcat (getdwgdrive) (getdwgpath) "\\xref\\pspc\\P" sfx))
      (if (setq ss (ssget "x" '((0 . "INSERT") (2 . "SET0EC00"))) )
        (command ".erase" (ssget "x") "r" ss "")
        (command ".erase" (ssget "x") "")
      ) ; end if
      (if (and (/= rpl "All") (findfile (strcat ff ".dwg")) )
        (progn
          (initget "Yes No All")
          (setq opt (getkword (strcat "\nSobrescrever o arquivo " ff " (Yes/<No>/All)? ")))
          (if (null opt) (setq rpl "No") (setq rpl opt))
          (if (not (= rpl "No"))
            (progn
              (if (findfile (strcat ff ".dwg"))
                (command ".wblock" ff "y" "*")
                (command ".wblock" ff "*")
              ) ; end if 
              (xfil ff '("ARQ" "EL" "ES" "H" "G" "AR" "IE") sfx)
            ) ; end progn
          ) ; end if
        ) ; end progn
        (progn
          (if (findfile (strcat ff ".dwg"))
            (command ".wblock" ff "y" "*")
            (command ".wblock" ff "*")
          ) ; end if 
          (xfil ff '("ARQ" "EL" "ES" "H" "G" "AR" "IE") sfx)
        ) ; end progn
      ) ; end if
      (command ".oops")
    ) ; end progn
  ) ; end if

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
