; K05c0/ChDET - Mai/94

(defun C:ChDET()
  (setvar "cmdecho" 0)

  (initget 1 "EL ES H G TE TI IE AR PC")
  (setq inst (getkword "\nDetalhe EL/ES/H/G/TE/TI/IE/AR/PC: "))
  (setq
    ddir (strcat (getenv "AIxDET") inst)
    nlay (strcat inst "-detalhe")
  ) ; end setq

  (while (= (setq ndet (strcase (getstring "\nNome do detalhe <ou ?>: "))) ""))

  (if (= ndet "?")
    (progn
      (textscr)
      (prompt "\e[2J*DETALHES")
      (prompt "\n\nDETALHE    DESCRICAO")
      (prompt "\n------   ------------------------------------------------------------\n")
      (setq file (open (strcat ddir "\\acad.blk") "r"))
      (setq yp 1)
      (while (setq ndet1 (read-line file))
        (prompt (strcat ndet1 "\n"))
        (if (zerop (rem yp 18)) (getstring "\n* Tecle [ENTER]\n"))
        (setq yp (1+ yp))
      ) ; end while
      (setq file (close file))
    ) ; end progn
    (progn
      (setq file (open (strcat ddir "\\acad.blk") "r"))
      (setq flag nil)
      (while (and (not flag) (setq ndet1 (read-line file)))
        (setq flag (= (strcase (substr ndet1 1 (strlen ndet))) ndet))
      ) ; end while
      (setq file (close file))
      (if flag
        (progn
          (prompt "\n\nDETALHE    DESCRICAO")
          (prompt "\n------   ------------------------------------------------------------\n")
          (prompt ndet1)
          (setq desc (getstring t "\n\nNova descricao <ou ENTER>: "))
          (if (= desc "") (setq desc (substr desc (+ (strlen ndet) 4))))
          (initget 1)
          (setq pt1 (getpoint "\nPrimeiro canto: "))
          (initget 1)
          (setq pt2 (getcorner pt1 "\nSegundo canto: "))
          (initget 1)
          (setq pti (getpoint "\nPonto de insercao: "))
          (setvar "blipmode" 0)
          (setvar "highlight" 0)
          (command
            "scale" "w" pt1 pt2 "" pti (/ 1.0 (#SCL))
            "change" "p" "" "p" "la" nlay ""
          ) ; end command
          (if (tblsearch "block" ndet)
            (command "block" ndet "y" pti "p" "")
            (command "block" ndet pti "p" "")
          ) ; end if
          (command
            "wblock" (strcat ddir "\\" ndet) "y" ndet
            "oops"
            "scale" "p" "" pti (#SCL)
          ) ; end command
          (setvar "highlight" 1)
          (setvar "blipmode" 1)
          (setq
            fileA (open (strcat ddir "\\acad.blk") "r")
            fileB (open (strcat ddir "\\acad.$$$") "w")
          ) ; end setq
          (while (setq dat (read-line fileA))
            (if (= dat ndet1)
              (write-line
                (strcat (substr ndet1 1 (strlen ndet)) " - " desc) fileB
              ) ; end write-line
              (write-line dat fileB)
            ) ; end if
          ) ; end while
          (setq
            fileA (close fileA)
            fileB (close fileB)
          ) ; end setq
          (command "sh" (strcat "chdet " inst))
        ) ; end progn
        (prompt "\n*ATENCAO* arquivo de detalhe inexistente ou nao cadastrado.")
      ) ; end if
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

(princ)
