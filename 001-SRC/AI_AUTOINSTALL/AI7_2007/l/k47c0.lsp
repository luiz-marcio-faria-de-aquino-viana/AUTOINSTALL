
;;
;; K47C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 10/28/97
;;

;; lockf(): funcao que assegura a exclusao mutua no compartilhamento dos desenhos
(defun lockf(/ f file_name cpu usr)
  (if (= (getvar "dwgtitled") 1)
    (progn
      (setq
        usr (getuser)
        cpu (getcpu)
      ) ; end setq

      (setq file_name (strcat (getvar "dwgname") ".lck"))

      (if (not (findfile file_name))
        (progn
          (if (setq f (open file_name "w"))
            (progn
              (write-line "AI3.00 Lock File" f)
              (write-line (strcat
                            (substr (rtos (getvar "cdate") 2 2) 3 2) "/"
                            (substr (rtos (getvar "cdate") 2 2) 5 2) "/"
                            (substr (rtos (getvar "cdate") 2 2) 7 2)
                          ) ; end strcat
                          f
              ) ; end write-line
              (write-line (strcat cpu ", " usr) f)
              (setq f (close f))
              (setvar "dwgwrite" 1)
            ) ; end progn
            (setvar "dwgwrite" 0)
          ) ; end if
        ) ; end progn
        (progn
          (if (= (verf) (strcat cpu ", " usr))
            (progn
              (setvar "dwgwrite" 1)
              (textscr)
              (prompt "\n\nATT: Restaurado o arquivo de acesso.")
              (getstring "\nTecle [ENTER] para continuar...")
            ) ; end progn
            (progn
              (setvar "dwgwrite" 0)
              (textscr)
              (prompt (strcat "\n\nATT: Arquivo em uso por " (verf) ".") )
              (getstring "\nTecle [ENTER] para continuar...")
            ) ; end progn
          ) ; end if
        ) ; end progn
      ) ; end if

    ) ; end progn
  ) ; end if

  (princ)
) ; end function

(defun verf() (verfile (getvar "dwgname")) )

(defun verfile(file_name / s f)
  (setq file_name (strcat file_name ".lck"))
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
  (if s s "")
) ; end function

(defun unlockf(/ usr cpu file_name)
  (setq
    usr (getuser)
    cpu (getcpu)
  ) ; end setq
  (setq file_name (strcat (getvar "dwgname") ".lck"))
  (if (= (verf) (strcat cpu ", " usr)) (command "dos_erase" file_name))
  (princ)
) ; end function

(defun c:vlock(/ s)
  (if (/= (setq s (verf)) "")
    (prompt (strcat "\nArquivo em uso por = " s) ".")
    (if (= (getvar "dwgtitled") 0)
      (prompt "\nATT: O desenho nao possui titulo.")
      (prompt "\nATT: O desenho nao possui um arquivo de tranca '.lck'.")
    ) ; end if
  ) ; end if
  (princ)
) ; end defun

(defun c:unlock(/ f usr cpu)
  (initget "Yes No")
  (if (= (getkword "\nDeseja REALMENTE ABRIR o arquivo <No>? ") "No")
    (if (setq f (open file_name "w"))
      (progn
        (if (null (setq usr (getenv "usr")))   (setq usr "USR_UNKNOW"))
        (if (null (setq cpu (getenv "micro"))) (setq cpu "CPU_UNKNOW"))

        (write-line "AI3.00 Lock File" f)
        (write-line (strcat
                      (substr (rtos (getvar "cdate") 2 2) 3 2) "/"
                      (substr (rtos (getvar "cdate") 2 2) 5 2) "/"
                      (substr (rtos (getvar "cdate") 2 2) 7 2)
                    ) ; end strcat
                    f
        ) ; end write-line
        (write-line (strcat cpu ", " usr) f)
        (setq f (close f))
        (setvar "dwgwrite" 1)
      ) ; end progn
      (progn
        (prompt "\nERR: Nao foi possivel abrir o arquivo.")
        (setvar "dwgwrite" 0)
      ) ; end progn
    ) ; end if
  ) ; end if
  (princ)
) ; end function

(princ)
