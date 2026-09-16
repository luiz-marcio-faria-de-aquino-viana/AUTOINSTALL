
;;
;; UNILINE.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 3/8/96
;;

(defun c:uniline(/ oldech ss1 ss2 ent1 ent2 pti1 ptf1 pti2 ptf2 pti ptf)
  (m:savevars)

  (if (setq ss1 (entsel "\nSelecione a primeira linha: "))
    (if (setq ss2 (entsel "\nSelecione a segunda linha: "))
      (progn
        (setq ent1 (entget (car ss1)))
        (setq ent2 (entget (car ss2)))
        (setq
          pti1 (cdr (assoc 10 ent1))
          ptf1 (cdr (assoc 11 ent1))
        ) ; endsetq
        (setq
          pti2 (cdr (assoc 10 ent2))
          ptf2 (cdr (assoc 11 ent2))
        ) ; end setq
        (if (inters pti1 ptf1 pti2 ptf2 nil)
           (command ".fillet" "r" 0 ".fillet" ss1 ss2)
           (if (inters pti1 ptf1 pti1 pti2 nil)
             (prompt "\n* ERROR * As linhas selecionadas sao paralelas.")
             (progn
               (if (> (distance pti1 pti2) (distance ptf1 pti2))
                 (setq pti pti1)
                 (setq pti ptf1)
               ) ; end if
               (if (> (distance pti2 pti1) (distance ptf2 pti1))
                 (setq ptf pti2)
                 (setq ptf ptf2)
               ) ; end if
               (setq oldlay (getvar "clayer"))
               (setq cnivel (cdr (assoc 8 ent1))) 
               (command
                 ".erase" (car ss1) (car ss2) ""
		 ".layer" "s" cnivel ""
                 ".line" pti ptf ""
                 ".layer" "s" oldlay ""
               ) ; end command
             ) ; end progn
           ) ; end if
        ) ; end if
      ) ; end progn
    ) ; end if
  ) ; end if

  (m:restorevars)
  (princ)
) ; end function

(princ)
