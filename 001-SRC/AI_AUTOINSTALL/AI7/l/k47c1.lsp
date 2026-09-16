
;;
;;  LOCK.lsp: program to control access to a file in use by another user
;; ======================================================================
;;              Copyright (C) 1995, by Luiz Marcio F A Viana
;;

(defun lockf(/ f file_name)
  (setq file_name (strcat (getvar "dwgname") ".lck"))
  (if (not (findfile file_name))
    (progn
      (if (setq f (open file_name "w"))
        (progn
          (write-line "AI2.25 Lock File" f)
          (write-line (strcat
                        (substr (rtos (getvar "cdate") 2 2) 3 2) "/"
                        (substr (rtos (getvar "cdate") 2 2) 5 2) "/"
                        (substr (rtos (getvar "cdate") 2 2) 7 2)
                      ) ; end strcat
                      f
          ) ; end write-line
          (write-line (strcat (getenv "xCADR11") ", " (getenv "USR")) f)
          (setq f (close f))
          (setq #LOCK "DISABLE")
        ) ; end progn
        (set #LOCK "ENABLE")
      ) ; end if
    ) ; end progn
    (progn
      (prompt (strcat "\n\n* ATENCAO *\nArquivo em uso por = " (verf)))
      (setq #LOCK "ENABLE")
    ) ; end progn
  ) ; end if
  (princ)
) ; end function

(defun verf(/ s f file_name)
  (setq file_name (strcat (getvar "dwgname") ".lck"))
  (if (findfile file_name)
    (progn
      (prompt "\nRequerendo acesso... ")
      (while (null (setq f (open file_name "r"))) (prompt "."))
      (read-line f)
      (read-line f)
      (setq s (read-line f))
      (setq f (close f))
    ) ; end progn
  ) ; end if
  s
) ; end function

(defun unlockf(/ f file_name)
  (setq file_name (strcat (getvar "dwgname") ".lck"))
  (if (= (verf) (strcat (getenv "xCADR11") ", " (getenv "USR")))
    (command "del" file_name)
  ) ; end if
  (princ)
) ; end function

(defun c:vlock(/ f file_name)
  (prompt (strcat "\nArquivo em uso por = " (verf)))
  (princ)
) ; end defun
