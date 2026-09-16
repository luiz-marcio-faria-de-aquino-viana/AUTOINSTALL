
;;
;; OLDDET.lsp
;; 27-NOV-95
;;

(defun C:OLDDET(/ txt cnt arq pti nlr prj ndt)
  (setvar "cmdecho" 0)
  (initget 1 "EL ES H G TE TI IE AR PC")
  (setq
    prj (getkword "\nDetalhe EL/ES/H/G/TE/TI/IE/AR/PC: ")
    nlr (strcat prj "-detalhe")
    ndt (getstring "Nome do detalhe <ou ?>: ")
  );endsetq
  (if (= ndt "?") (progn
    (textscr)
    (setq
      arq (open (strcat "C:\\AI-DET\\" prj "/acad.blk") "r")
      txt "Thru"
      cnt 0
    );endsetq
    (if (/= arq nil) (progn
      (prompt "\e[2J")
      (prompt "*DETALHES")
      (prompt "\n\nDETALHE    DESCRICAO")
      (prompt "\n------   ------------------------------------------------------------")
      (prompt "\n")
      (while (/= txt nil)
        (setq
          txt (read-line arq)
          cnt (1+ cnt)
        );endsetq
        (if (/= txt nil) (progn
          (prompt "\n")
          (princ txt)
          );endprogn
        );endif
        (if (zerop (rem cnt 18)) (progn
            (getstring "\n\n* Tecle [ENTER] ")
            (prompt "\n")
          );endprogn
        );endif
      );endwhile
      (setq
        arq (close arq)
      );endsetq
      );endprogn
    );endif
    (prompt "\n")
    );endprogn
  );endif
  (if (/= ndt "?") (progn
    (setq
      pti (getpoint "\nPonto de insercao: ")
    )
      (setvar "blipmode" 0)
    (command
      "layer" "m" nlr ""
      "insert" (strcat "C:\\AI-DET" prj "/" ndt) pti (#SCL) "" 0
    );endcommand
      (setvar "blipmode" 1)
    );endprogn
  );endif
);enddefun
