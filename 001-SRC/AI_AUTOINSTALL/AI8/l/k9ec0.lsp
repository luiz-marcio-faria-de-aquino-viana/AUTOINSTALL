
;;
;; K9EC0.lsp
;; Copyright (C) 1991-2013 by Luiz Marcio F A Viana, 24/09/2013
;;

;;(setq default_plotter "PDF995")
(setq default_plotter "HP Deskjet 4620 series (Rede)")

(defun plotdet_out(pti ptf)
  (command "-plot" "y" "Model" default_plotter "A4" "m" "Landscape" "N" "Window" pti ptf "Fit" "0,0" "N" "Monochrome.ctb" "N" "N" "N" "N" "Y")
) ; end defun  

;; c:plotdet(): rotina para impressao automatica dos detalhes
(defun c:plotdet()
    (m:savevars)
	(prompt "\nSelecione os detalhes as serem impressos...")
	(if (setq ss (ssget '((0 . "INSERT") (2 . "LIMITE")) ) )
	  (progn
	    (setq cnt (sslength ss))
		(while (>= (setq cnt (1- cnt)) 0)
		  (progn
		    (setq ent (entget (ssname ss cnt)))
		    (setq pt0 (cdr (assoc 10 ent)))
			(setq ptc (mapcar '+ pt0 '(210.0 148.5 0.0)))
			(setq pti (mapcar '- ptc '(209.0 147.5 0.0)))
			(setq ptf (mapcar '+ ptc '(209.0 147.5 0.0)))
			(plotdet_out pti ptf)
			;;(getstring "\nTecle [ENTER] para prosseguir...")
		  ) ; end progn
		) ; end while
	  ) ; end progn
	) ; end if
    (m:savevars)
    (princ)
) ; end defun

(defun c:ss()
    (m:savevars)
	(setq pt1 (getpoint "\nPonto inicial: "))
	(setq pt2 (getpoint pt1 "\nPonto final: "))
	
	(setq ptc (mapcar '/ (mapcar '+ pt1 pt2) '(2.0 2.0 2.0)))
	
	(command ".scale" "w" pt1 pt2 "" ptc 2.0)
    (m:restorevars)	
) ; end defun


(princ)
