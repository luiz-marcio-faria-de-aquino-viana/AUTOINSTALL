
;;
;; K08C0.lsp
;; Copyright (C) 1992 by Luiz Marcio F A Viana, 4/15/92
;;
  
;; c:cx(): rotina para desenho de caixa de gordura, sifonada e retentora especiais
(defun c:cx(/ esblk eslarg esalt blk)
  (setvar "cmdecho" 0)

  (command ".undo" "g")
  
  (if #ESBLK
    (progn
      (initget "CGE CSE CRE")
      (setq esblk (getkword (strcat "\nInserir CGE/CSE/CRE <" #ESBLK ">: ")) )
    ) ; end progn
    (progn
      (initget 1 "CGE CSE CRE")
      (setq esblk (getkword "\nInserir CGE/CSE/CRE: "))
    ) ; end progn
  ) ; end if
  (if esblk (setq #ESBLK esblk))
  
  (cond
   ( (= (strcase #ESBLK) "CGE") (setq blk (V:AID "ES/ES03C00")) )
   ( (= (strcase #ESBLK) "CSE") (setq blk (V:AID "ES/ES0BC00")) )
   ( (= (strcase #ESBLK) "CRE") (setq blk (V:AID "ES/ES08C00")) )
  ) ; end cond

  (if #ESLARG
    (setq eslarg (getdist (strcat "\nLargura da " #ESBLK " <" (rtos #ESLARG 2 2) ">: ")) )
    (progn
      (initget 1)
      (setq eslarg (getdist (strcat "\nLargura da " #ESBLK ": ")) )
    ) ; end progn
  ) ; end if
  (if eslarg (setq #ESLARG eslarg))
  
  (setq esalt (getdist (strcat "\nAltura da " #ESBLK " <Alt=Larg>: ")) )
  (if (null esalt) (setq esalt #ESLARG))

  (if (tblsearch "block" (getfilename blk))
    (command ".insert" (getfilename blk) "x" #ESLARG "y" esalt)
    (command ".insert" blk "x" #ESLARG "y" esalt)
  ) ; end if

  (princ)
) ; end defun

(princ)
