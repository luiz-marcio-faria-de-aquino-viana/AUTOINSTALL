;                                F A X L O G (R)
;   ________________________________________________________________________
;         Copyright (C) 1994 by TML Software, Inc. All Rights Reserved.


;    THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
;    ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR PURPOSE AND OF
;    MERCHANTABILITY ARE HEREBY DISCLAIMED.
;   ________________________________________________________________________


;    DESCRIPTION:

;    LISP FAXLOG application - by Luiz Marcio Viana - 3/22/95

(defun pad(s n)
  (repeat (- n (strlen s)) (setq s (strcat s " ")))
) ; end function

(defun nodot(s / cnt)
  (setq cnt (strlen s))
  (while (not (zerop cnt))
    (if (= (substr s cnt 1) ".")
      (setq s (strcat (substr s 1 (- cnt 1)) " " (substr s (+ cnt 1))))
    ) ; end if
    (setq cnt (- cnt 1))
  ) ; end while
  s
) ; end function

(defun c:faxlog()
  (textscr)
  (prompt "\e[2J")
  (prompt "\t          RELACAO DOS FAX ENVIADOS       \n\n")
  (prompt "\tSTATUS     DATA       HORA      ARQV  \n")
  (prompt "\t------  ----------  --------  --------\n")

  (setq cnt 1)
  (setq flag nil)

  (setq src_file (open "u:\\ql2fax\\faxsend.log" "r"))
  (while (and (null flag) (setq data_read (read-line src_file)))
    (setq data_read (read (strcat "(" (nodot data_read) ")")))
    (prompt "\t  ") (prin1 (nth 10 data_read)) (prompt "   ")
    (prompt   "  ") (prin1 (nth  0 data_read))
    (prompt   "  ") (prin1 (nth  1 data_read))
    (prompt   "  ") (prin1 (nth  2 data_read))
    (prompt "\n")
    (if (zerop (rem cnt 20))
        (if (null (setq flag (= (strcase (getstring "\n* (P) Para/(ENTER) Continua...")) "P")))
          (progn
            (prompt "\e[2J")
            (prompt "\t          RELACAO DOS FAX ENVIADOS       \n\n")
            (prompt "\tSTATUS     DATA       HORA      ARQV  \n")
            (prompt "\t------  ----------  --------  --------\n")
          ) ; end progn
        ) ; end if
    ) ; end if    
    (setq cnt (+ cnt 1))
  ) ; end while
  (princ)
) ; end function

(princ)
