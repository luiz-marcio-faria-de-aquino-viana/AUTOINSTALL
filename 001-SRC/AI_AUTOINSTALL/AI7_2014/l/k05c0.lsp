; K05c1/MkDET - Out/91

(defun C:MkDET(/ prj nlr arq txt cnt pt1 pt2 pti dcr ndt)
  (setvar "cmdecho" 0)
  (initget 1 "EL ES H G TE TI IE AR PC")
  (setq
    prj (getkword "\nDetalhe EL/ES/H/G/TE/TI/IE/AR/PC: ")
    nlr (strcat prj "-detalhe")
    arq (open (strcat (getenv "AIxDET") prj "/acad.blk") "r")
    txt "Thru"
    cnt 0
  );endsetq
  (while (and (/= arq nil) (/= txt nil))
    (setq
      txt (read-line arq)
      cnt (1+ cnt)
    );endsetq
  );endwhile
  (if (/= cnt 0)
      (setq
        arq (close arq)
      );endsetq
      (setq
        cnt 1
      );endsetq
  );endif
  (setq
    ndt (strcat prj (substr "000" 1 (- 3 (strlen (itoa cnt)))) (itoa cnt) "C")
    dcr (getstring T "\nDescricao do detalhe: ")
    pt1 (getpoint "\nPonto inicial (janela): ")
    pt2 (getcorner pt1 "\nSegundo canto (janela): ")
    pti (getpoint "\nPonto de insercao: ")
  );endsetq
    (setvar "blipmode" 0)
    (setvar "highlight" 0)
  (command
    "scale" "w" pt1 pt2 "" pti (/ 1.0 (#SCL))
    "change" "p" "" "p" "la" nlr ""
    "wblock" (strcat (getenv "AIxDET") prj "/" ndt) "" pti "p" ""
    "oops"
    "scale" "p" "" pti (#SCL)
  );endcommand
    (setvar "blipmode" 1)
    (setvar "highlight" 1)
  (setq
    arq (open (strcat (getenv "AIxDET") prj "/acad.blk") "a")
  );endsetq
  (write-line
    (strcat ndt " - " dcr) arq
  );endwrite
  (setq
    arq (close arq)
  ); end setq
) ; end defun
