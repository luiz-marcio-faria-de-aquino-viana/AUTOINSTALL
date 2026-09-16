
;;
;; K55C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 1/26/96.
;;
;; XFIX: rotina para inserir/atualizar XREFs

(defun xfix(xf rl / oldech xfb xff xtb xfl fn p nm)
  (m:savevars)

  (setq
    xfb (car xf)
    xff (cadr xf)
  ) ; end setq

  (prompt (strcat "\nResolvendo " xfb "..."))
  (if (setq xtb (tblsearch "BLOCK" xfb)) ;; existe o bloco xfb?
    (progn
      (setq xfl (cdr (assoc 70 xtb)))
      (if (= (logand xfl 4) 4)           ;; bloco xfb e xref?
        (if (zerop (logand xfl 32))      ;; bloco xfb nao resolvido?
          (progn
            (setq fn nil)
            (if (= (substr xff 1 1) "@")
              (setq fn (substr xff 2))
              (if (or (> (setq p (strsearch "\\XREF" (getdwgpath))) 0)
                      (> (setq p (strsearch "/XREF"  (getdwgpath))) 0) )
                (setq fn (strcat (getdwgdrive) (substr (getdwgpath) 1 p) xff) )
              ) ; end if
            ) ; end if
            (if (and fn (findfile (strcat fn ".dwg")) )
              (command ".xref" "p" xfb fn)                ;; se xref encontrado
              (progn
                (prompt (strcat "\nProcurando arquivo " (getfilename xff) " no drive corrente..."))
                (if (setq fn (aci_filesea (getdwgfullname) (strcat (getfilename xff) ".dwg"))) ;; senao procura xref
                  (progn
                    (command ".xref" "p" xfb fn)
                    (setq xff (strcat "@" (substr fn 1 (- (strsearch ".DWG" fn) 1)) ))
                  ) ; end progn
                  (prompt (strcat "\n* ATENCAO * Xref (" xfb ") nao foi resolvido."))
                ) ; end if
              ) ; end progn
            ) ; end if
          ) ; end progn
          (if rl
            (progn
              (prompt (strcat "\nRecarregando " xfb "..."))
              (command ".xref" "r" xfb)
            ) ; end if
          ) ; end if
        ) ; end if
        (progn
          (setq nm xfb)
          (while (tblsearch "BLOCK" nm)
            (prompt  (strcat    "\n* ATENCAO * Ja existe um bloco de nome " nm " no desenho."))
            (while (= (setq nm (getstring "\nInforme outro nome para o xref: ")) "") )
          ) ; end while
          (setq xfb nm)
          (setq fn nil)
          (if (= (substr xff 1 1) "@")
            (setq fn (substr xff 2))
            (if (or (> (setq p (strsearch "\\XREF" (getdwgpath))) 0)
                    (> (setq p (strsearch "/XREF"  (getdwgpath))) 0) )
              (setq fn (strcat (getdwgdrive) (substr (getdwgpath) 1 p) xff) )
            ) ; end if
          ) ; end if
          (if (and fn (findfile (strcat fn ".dwg")) )              ;; existe o arquivo xref?
            (command ".xref" "" (strcat nm "=" fn) "0,0" "" "" "") ;; se xref encontrado
            (progn
              (prompt (strcat "\nProcurando arquivo " (getfilename xff) " no drive corrente..."))
              (if (setq fn (aci_filesea (getdwgfullname) (strcat (getfilename xff) ".dwg")))            ;; senao procura xref
                (progn
                  (command ".xref" "" (strcat nm "=" fn) "0,0" "" "" "")
                  (setq xff (strcat "@" (substr fn 1 (- (strsearch ".DWG" fn) 1)) ))
                ) ; end progn
                (prompt (strcat "\n* ATENCAO * Xref (" xfb ") nao foi resolvido."))
              ) ; end if
            ) ; end progn
          ) ; end if
        ) ; end progn
      ) ; end if
    ) ; end progn
    (progn
      (setq fn nil)
      (if (= (substr xff 1 1) "@")
        (setq fn (substr xff 2))
        (if (or (> (setq p (strsearch "\\XREF" (getdwgpath))) 0)
                (> (setq p (strsearch "/XREF"  (getdwgpath))) 0))
          (setq fn (strcat (getdwgdrive) (substr (getdwgpath) 1 p) xff))
        ) ; end if
      ) ; end if
      (if (and fn (findfile (strcat fn ".dwg"))) ;; existe o arquivo xref?
        (command ".xref" "" fn "0,0" "" "" "")   ;; se xref encontrado
        (progn
          (prompt (strcat "\nProcurando arquivo " (getfilename xff) " no drive corrente..."))
          (if (setq fn (aci_filesea (getdwgfullname) (strcat (getfilename xff) ".dwg"))) ;; senao procura xref
            (progn
              (command ".xref" "" (strcat xfb "=" fn) "0,0" "" "" "")
              (setq xff (strcat "@" (substr fn 1 (- (strsearch ".DWG" fn) 1)) ))
            ) ; end progn
            (prompt (strcat "\n* ATENCAO * Xref (" xfb ") nao foi associado."))
          ) ; end if
        ) ; end progn
      ) ; end if
    ) ; end progn
  ) ; end if
  (m:restorevars)
  (list xfb xff)
) ; end defun

(princ)
