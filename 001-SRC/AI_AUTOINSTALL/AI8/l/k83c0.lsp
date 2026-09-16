
;;
;; K83C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 2/6/98
;;

;; c:fploter(): rotina de transmissao de um arquivo de plotagem para fila
(defun c:fploter()
  (m:savevars)

  (if (setq fn (getfiled "Select a Plotted File" (V:SPOOL "PLOT\\") "*" 2))
    (progn
      (prompt (strcat "\nFILE=" fn "\n"))
      (aci_xrun
        "ADDLIST.EXE" 
          "/Q=PLOTQ_0"
          (strcat "/FF=" fn)
          "/SZ=?"
          "/P=?"
          "/C=1"
          (strcat "/USR=" #USR)
      ) ; end aci_xrun
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

;; c:fprint(): rotina de transmissao de um arquivo de impressao para fila
(defun c:fprint()
  (m:savevars)

  (if (setq fn (getfiled "Select a Printed File" (V:SPOOL "PRINT\\") "zip" 2))
    (aci_xrun
      "ADDLIST.EXE" 
      "/Q=PRINTQ_0"
      (strcat "/FF=" fn)
      (strcat "/USR=" #USR)
    ) ; end aci_xrun
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

(princ)
