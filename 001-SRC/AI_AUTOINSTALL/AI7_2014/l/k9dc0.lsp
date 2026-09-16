;;
;; K9DC0.lsp
;; Copyright (C) 1991 by Luiz Marcio F A Viana, 3/20/98
;;

;; c:sp2pl(): rotina para desenho da fiacao eletrica
(defun c:sp2pl(/ oldecho ss enm ent it)
  (setq oldecho (acadvar "cmdecho" 0))
  
  (if (setq ss (entsel "\nSelecione a SPLINE que sera convertida: "))
    (progn
	  (setq enm (car ss))
	  (if (= (enttype enm) "SPLINE")
	    (progn
		  (setq ent (entget enm))
		  (setq lay (cdr (assoc 8 ent)))
		  (setq it (assoc 10 ent))
		  (setq oldlay (getvar "clayer"))
		  (command ".layer" "m" lay "")
		  (command ".pline" (cdr it) "w" 0 0)
		  (while it
		    (progn
		      (command (cdr it))
		      (setq ent (cdr (member it ent)))
		      (setq it (assoc 10 ent))
			) ; end progn
		  ) ; end while
		  (command "")
		  (command ".layer" "m" oldlay "")
		  (command ".erase" enm "")
		) ; end progn
		(prompt "\nERR: Objeto selecionado nao e' uma SPLINE.")
	  ) ; end if
	) ; end progn
  ) ; end if
  
  (princ)
) ; end defun

(princ)

  