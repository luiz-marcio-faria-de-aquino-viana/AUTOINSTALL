;;
;; K9DC0.lsp
;; Copyright (C) 1991 by Luiz Marcio F A Viana, 3/20/98
;;

;; c:allsp2pl(): rotina para conversao de spline em pline
(defun c:allsp2pl(/ oldecho ss enm ent it itnew itold itatu itfin ang step_ang)
  (setq oldecho (acadvar "cmdecho" 0))
  
  (setq step_ang (* (/ 3.141592 180.0) 5.0))
  
  (prompt "\nSelecione a SPLINE que sera convertida: ")
  (if (setq ss (ssget '((0 . "SPLINE"))))
    (progn
	  (setq cnt (sslength ss))
	  (while (>= (setq cnt (1- cnt)) 0)
	    (progn
  	      (setq enm (ssname ss cnt))
	      (if (= (enttype enm) "SPLINE")
	        (progn
		      (setq ent (entget enm))
		      (setq lay (cdr (assoc 8 ent)))
		      (setq it (assoc 10 ent))
		      (setq itfin (assoc 10 (reverse ent)))
		      (setq oldlay (getvar "clayer"))
		      (command ".layer" "m" lay "")
		      (command ".pline" (cdr it) "w" 0 0)
			  (setq itatu it)
			  (setq itold nil)
		      (while it
		        (progn
				  (setq ent (cdr (member it ent)))
				  (setq it (assoc 10 ent))
				  (setq itnew it)
				  (if itnew
				    (progn
  				      (if itold
				        (setq ang (abs (- (angle (cdr itatu) (cdr itnew)) (angle (cdr itold) (cdr itatu)))))
					    (setq ang 3.141592)
				      ) ; end if
				      (if (> ang step_ang)
				        (progn
    				      (command (cdr itnew))
					      (setq itold itatu)
					      (setq itatu itnew)
					    ) ; end progn
				      ) ; end if
					) ; end progn
				  ) ; end if
			    ) ; end progn
		      ) ; end while
		      (command (cdr itfin) "")
		      (command ".layer" "m" oldlay "")
		      (command ".erase" enm "")
			) ; end progn
	      ) ; end if
		) ; end progn
	  ) ; end if
	) ; end progn
  ) ; end if
  
  (princ)
) ; end defun

;; c:sp2pl(): rotina para conversao de spline em pline
(defun c:sp2pl(/ oldecho ss enm ent it itatu itnew itold itfin ang)
  (setq oldecho (acadvar "cmdecho" 0))
  
  (setq step_ang (* (/ 3.141592 180.0) 5.0))

  (if (setq ss (entsel "\nSelecione a SPLINE que sera convertida: "))
    (progn
	  (setq enm (car ss))
	  (if (= (enttype enm) "SPLINE")
        (progn
          (setq ent (entget enm))
		  (setq lay (cdr (assoc 8 ent)))
		  (setq it (assoc 10 ent))
		  (setq itfin (assoc 10 (reverse ent)))
		  (setq oldlay (getvar "clayer"))
		  (command ".layer" "m" lay "")
		  (command ".pline" (cdr it) "w" 0 0)
		  (setq itatu it)
		  (setq itold nil)
		  (while it
		    (progn
			  (setq ent (cdr (member it ent)))
			  (setq it (assoc 10 ent))
			  (setq itnew it)
			  (if itnew
				(progn
  				  (if itold
				    (setq ang (abs (- (angle (cdr itatu) (cdr itnew)) (angle (cdr itold) (cdr itatu)))))
					(setq ang 3.141592)
				  ) ; end if
				  (if (> ang step_ang)
				    (progn
    				  (command (cdr itnew))
					  (setq itold itatu)
					  (setq itatu itnew)
				    ) ; end progn
				  ) ; end if
			    ) ; end progn
			  ) ; end if
			) ; end progn
		  ) ; end while
		  (command (cdr itfin) "")
		  (command ".layer" "m" oldlay "")
		  (command ".erase" enm "")
	    ) ; end progn
		(prompt "\nERR: Objeto selecionado nao e' uma SPLINE.")
	  ) ; end if
	) ; end progn
  ) ; end if
  
  (princ)
) ; end defun

;; c:lum2ai(): rotina para conversao de spline em pline
(defun c:lum2ai(/ oldecho ss enm ent it)
  (setq oldecho (acadvar "cmdecho" 0))
  
  (prompt "\nSelecione as SPLINEs para alteracao de camada: ")
  (if (setq ss (ssget '((0 . "SPLINE")(8 . "EL-Condutos"))))
    (progn
	  (setq cnt (sslength ss))
	  (while (>= (setq cnt (1- cnt)) 0)
	    (progn
  	      (setq enm (ssname ss cnt))
	      (if (= (enttype enm) "SPLINE")
	        (progn
		      (setq ent (entget enm))
		      (setq lay (cdr (assoc 8 ent)))
		      (setq ltype (cdr (assoc 6 ent)))
			  (if (= (strcase ltype) "DASHED")
			    (entmod (subst (cons 8 "EL-DT_PISO") (assoc 8 ent) ent))
				(entmod (subst (cons 8 "EL-DT_TETO") (assoc 8 ent) ent))
		      ) ; end if
			) ; end progn
	      ) ; end if
		) ; end progn
	  ) ; end if
	) ; end progn
  ) ; end if
  
  (princ)
) ; end defun

;; c:lumdiag2ai(): rotina para conversao de diagramas do lumine para o ai
(defun c:lumdiag2ai(/ oldecho ss enm ent it)
  (setq oldecho (acadvar "cmdecho" 0))
  
  (setq lslay '( ("DI-Linhas_do_quadro" "EL-DET-P1")
                 ("DI-Textos_do_quadro" "EL-DET-P2")
				 ("DI-T_tulo_do_quadro" "EL-DET-P3")
				 ("DI-T_tulo_do_diagrama" "EL-DET-P3")
				 ("DI-Linhas_do_diagrama" "EL-DET-P1")
  				 ("DI-Textos_do_diagrama" "EL-DET-P3")
  				 ("DI-Fios" "EL-DET-P2")
  				 ("DI-Barramento" "EL-DET-P3")
  				 ("DI-Disjuntor" "EL-DET-P2") ) ) ; end setq

  (prompt "\nSelecione o diagrama para alteracao de camada: ")
  (if (setq ss (ssget))
    (progn
	  (setq cnt (sslength ss))
	  (while (>= (setq cnt (1- cnt)) 0)
	    (progn
  	      (setq enm (ssname ss cnt))
		  (setq ent (entget enm))
		  (setq lay (filterchr (cdr (assoc 8 ent))))
		  (setq it (assoc lay lslay))
		  (setq newlay (cadr it))
		  (if (= newlay nil)
		    (command ".erase" enm "")
			(progn
		      (setq ent (entmod (subst (cons 8 newlay) (assoc 8 ent) ent)))
			  (setq etype (cdr (assoc 0 ent)))
			  (if (or (= etype "MTEXT") (= etype "TEXT"))
			    (entmod (subst (cons 7 "ROMANS") (assoc 7 ent) ent))
			  ) ; end if
			) ; end progn
		  ) ; end if
		) ; end progn
	  ) ; end while
	) ; end progn
  ) ; end if
  
  (princ)
) ; end defun

(princ)

  