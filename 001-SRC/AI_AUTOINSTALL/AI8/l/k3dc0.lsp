
;;
;;  K3Dc0/C:INFO: display file information to screen
;; ==========================================================================
;;

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

(defun C:INFO(/ infprj)
  (m:savevars)

  (setq infprj (strcat (getvar "dwgprefix") "DIRINFO"))
  (viewinf infprj)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
