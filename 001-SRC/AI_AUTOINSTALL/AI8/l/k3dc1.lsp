
;;
;;  K3Dc0/C:INFO: display file information to screen
;; ==========================================================================
;;

;; STRSUFIX: get sufix from string
;;

(defun STRSUFIX(s / cont)
  (setq cont (strlen s) )
  (while (and (> (setq cont (1- cont)) 0) (/= (substr s cont 1) "\\") )
    (substr s cont)
  ) ; end while
) ; end defun

;; VIEWINF: read and display informations from file
;;

(defun VIEWINF(s / cont file)
  (if (findfile s)
    (progn
      (textscr)
      (prompt (strcat "\e[2J* INFO: " s))
      (prompt "\n=======================================\n")
      (setq file (open s "r"))
      (setq cont 0)
      (while (setq dat (read-line file))
        (progn
          (prompt (strcat dat "\n"))
          (if (= cont 20)
            (progn
              (getstring "\n- MAIS -")
              (setq cont 0)
            ) ; end progn
          ) ; end if
          (setq cont (1+ cont))
        ) ; end progn
      ) ; end while
      (setq dat (close file))
      (getstring "\n\n- FIM -")
    ) ; end progn
  ) ; end if
) ; end defun

;; C:INFO: display information files on screen
;;

(defun C:INFO(/ infdes infprj)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (setq
    infdes (strcat (getvar "dwgprefix") "_info_\\" (strsufix (getvar "dwgname")) ".inf")
    infprj (strcat (getvar "dwgprefix") "_info_\\" (strsufix (substr (getvar "dwgprefix") 1 (- (strlen (getvar "dwgprefix")) 1))) ".inf")
  ) ; end setq

  (viewinf infprj)
  (viewinf infdes)

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
