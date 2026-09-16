;;
;; K1BC0.lsp
;; Copyright (C) 2015 by Luiz Marcio F A Viana, 13/07/2015
;;

(setq COTAEIXO_LISTA_EIXOS '())

(defun c:CotaEixo_selEixos(/ hlseixo vlseixo hlabel hcnt vlabel vcnt pos heixo veixo hpos he hent hpt0 hpt1 hlbl vpos ve vent vpt0 vpt1 vlbl ptc)
	(setvar "cmdecho" 0)
	
	(setq
	  hlseixo '()
	  vlseixo '()
	) ; end setq
	
	(setq hlabel (getstring "\nInforme os eixos horizontais separados por virgula: "))
	(setq hcnt (+ (strcnt hlabel ",") 1))
	
	(setq vlabel (getstring "\nInforme os eixos verticais separados por virgula: "))
	(setq vcnt (+ (strcnt vlabel ",") 1))
	
	(prompt "\nSelecione os eixos horizontais em sequencia")
	(setq pos 0)
	(while (< pos hcnt)
	  (setq heixo (car (entsel "\nSelecione um eixo horizontal: ")))
	  (setq hlseixo (cons heixo hlseixo))
	  (setq pos (+ 1 pos))
	) ; end while
	
	(prompt "\nSelecione os eixos verticais em sequencia")
	(setq pos 0)
	(while (< pos vcnt) 
      (setq veixo (car (entsel "\nSelecione um eixo vertical: ")))
	  (setq vlseixo (cons veixo vlseixo))
	  (setq pos (+ 1 pos))
	) ; end while
	
	(setq COTAEIXO_LISTA_EIXOS '())

	(setq hpos hcnt)
	(foreach he hlseixo
	  (progn
		(setq hent (entget he))

		(setq 
			hpt0 (cdr (assoc 10 hent))
			hpt1 (cdr (assoc 11 hent))
		) ; end setq
		
		(setq hlbl (strpiece hlabel hpos ",")) 
		
		(setq vpos vcnt)
	    (foreach ve vlseixo
		  (progn
			(setq vent (entget ve))
			
			(setq 
				vpt0 (cdr (assoc 10 vent))
				vpt1 (cdr (assoc 11 vent))
			) ; end setq		
			
		    (setq vlbl (strpiece vlabel vpos ",")) 

	        (setq ptc (inters hpt0 hpt1 vpt0 vpt1 nil))
			
			(setq COTAEIXO_LISTA_EIXOS (append (list (list ptc hlbl hpt0 hpt1 vlbl vpt0 vpt1)) COTAEIXO_LISTA_EIXOS))
			
		    (setq vpos (- vpos 1))
		  ) ; end progn
		) ; end foreach
		
		(setq hpos (- hpos 1))
	  ) ; end progn
	) ; end foreach

	(princ)
) ; end defun

(defun CotaEixo_nearestEixo(pt / dmin ptmin itmin ptc d)
    (setq 
	  dmin 999999999.0
	  ptmin nil
	  itmin nil
	) ; end setq
	(foreach it COTAEIXO_LISTA_EIXOS
	  (setq ptc (car it))
	  (setq d (distance ptc pt))
	  (if (< d dmin)
	    (progn
		  (setq ptmin ptc)
		  (setq dmin d)
		  (setq itmin it)
		) ; end progn
	  ) ; end if
    ) ; end foreach
	itmin
) ; end defun

(defun c:CotaEixo_InsCota(/ x_it y_it it x_label y_label x_eixo y_eixo x_eixo_ent x_eixo_pt0 x_eixo_pt1 y_eixo_ent 
					y_eixo_pt0 y_eixo_pt1 ptc x_eixo_vetor y_eixo_vetor x_unit y_unit pti ptd 
					vx vy dx dy v x y)
	(setvar "cmdecho" 0)
	
	(prompt "\nInicio da marcacao dos pontos em relacao aos eixos...")
	(while (setq pti (getpoint "\nMarque o ponto ou ENTER para terminar: "))
		(progn
			(setq ptd (getpoint pti "\nMarque o local para insercao da cota: "))

			(if (setq it (CotaEixo_nearestEixo pti))
			  (progn			
				(setq x_it (cdr it))
				(setq y_it (cdr (cdr (cdr (cdr it)))))

				(setq x_label (car x_it))
				(setq y_label (car y_it))

				(setq 
					x_eixo_pt0 (cadr x_it)
					x_eixo_pt1 (caddr x_it)
				) ; end setq

				(setq 
					y_eixo_pt0 (cadr y_it)
					y_eixo_pt1 (caddr y_it)
				) ; end setq
				
				(setq ptc (car it))
							
				(setq 
					x_eixo_vetor (mapcar '- x_eixo_pt1 ptc)
					y_eixo_vetor (mapcar '- y_eixo_pt1 ptc)
				) ; end setq

				(setq
					x_unit (vtunit x_eixo_vetor)
					y_unit (vtunit y_eixo_vetor)
				) ; end setq
				
				(setq
					vx (mapcar '- pti ptc)
					vy (mapcar '- pti ptc)
				) ; end setq
				
				(setq
					dx (abs (/ (* (vtprod vx x_unit) (#und)) 1000.0))
					dy (abs (/ (* (vtprod vy y_unit) (#und)) 1000.0))
				) ; end setq
				
				(setq 
					v (mapcar '- ptd pti)
					x (car v)
					y (cadr v)
				) ; end setq
				
				(if (and (>= x 0) (>= y 0))
					(progn
						(command 
							".pline" pti "w" 0 "" 
							ptd 
							(mapcar '+ ptd (list 0.0 (* (#scl) 5.0)))
							(mapcar '+ ptd (list (* (#scl) 20.0) (* (#scl) 5.0)))
							(mapcar '+ ptd (list (* (#scl) 20.0) (- (* (#scl) 5.0))))
							(mapcar '+ ptd (list 0.0 (- (* (#scl) 5.0))))
							ptd
							(mapcar '+ ptd (list (* (#scl) 20.0) 0.0))
							""
						) ; end command
						(command 
							".text" 
							(mapcar '+ ptd (list (* (#scl) 1.5) (* (#scl) 1.5))) 
							(* 1.5 (#scl)) 
							0.0 
							(strcat y_label " = " (rtos dx 2 2) "m")
						) ; end command
						(command 
							".text" 
							(mapcar '+ ptd (list (* (#scl) 1.5) (- (* (#scl) 3.5)))) 
							(* 1.5 (#scl)) 
							0.0 
							(strcat x_label " = " (rtos dy 2 2) "m")
						) ; end command
					) ; end progn
					(if (and (>= x 0) (< y 0))
						(progn
							(command 
								".pline" pti "w" 0 "" 
								ptd 
								(mapcar '+ ptd (list 0.0 (* (#scl) 5.0)))
								(mapcar '+ ptd (list (* (#scl) 20.0) (* (#scl) 5.0)))
								(mapcar '+ ptd (list (* (#scl) 20.0) (- (* (#scl) 5.0))))
								(mapcar '+ ptd (list 0.0 (- (* (#scl) 5.0))))
								ptd
								(mapcar '+ ptd (list (* (#scl) 20.0) 0.0))
								""
							) ; end command
							(command 
								".text" 
								(mapcar '+ ptd (list (* (#scl) 1.5) (* (#scl) 1.5))) 
								(* 1.5 (#scl)) 
								0.0 
								(strcat y_label " = " (rtos dx 2 2) "m")
							) ; end command
							(command 
								".text" 
								(mapcar '+ ptd (list (* (#scl) 1.5) (- (* (#scl) 3.5)))) 
								(* 1.5 (#scl)) 
								0.0 
								(strcat x_label " = " (rtos dy 2 2) "m")
							) ; end command
						) ; end progn
						(if (and (< x 0) (>= y 0))
							(progn
								(command 
									".pline" pti "w" 0 "" 
									ptd 
									(mapcar '- ptd (list 0.0 (* (#scl) 5.0)))
									(mapcar '- ptd (list (* (#scl) 20.0) (* (#scl) 5.0)))
									(mapcar '- ptd (list (* (#scl) 20.0) (- (* (#scl) 5.0))))
									(mapcar '- ptd (list 0.0 (- (* (#scl) 5.0))))
									ptd
									(mapcar '- ptd (list (* (#scl) 20.0) 0.0))
									""
								) ; end command
								(command 
									".text" 
									(mapcar '+ ptd (list (- (* (#scl) 18.5)) (* (#scl) 1.5))) 
									(* 1.5 (#scl)) 
									0.0 
									(strcat y_label " = " (rtos dx 2 2) "m")
								) ; end command
								(command 
									".text" 
									(mapcar '+ ptd (list (- (* (#scl) 18.5)) (- (* (#scl) 3.5)))) 
									(* 1.5 (#scl)) 
									0.0 
									(strcat x_label " = " (rtos dy 2 2) "m")
								) ; end command
							) ; end progn
							(if (and (< x 0) (< y 0))
								(progn
									(command 
										".pline" pti "w" 0 "" 
										ptd 
										(mapcar '- ptd (list 0.0 (* (#scl) 5.0)))
										(mapcar '- ptd (list (* (#scl) 20.0) (* (#scl) 5.0)))
										(mapcar '- ptd (list (* (#scl) 20.0) (- (* (#scl) 5.0))))
										(mapcar '- ptd (list 0.0 (- (* (#scl) 5.0))))
										ptd
										(mapcar '- ptd (list (* (#scl) 20.0) 0.0))
										""
									) ; end command
									(command 
										".text" 
										(mapcar '+ ptd (list (- (* (#scl) 18.5)) (* (#scl) 1.5))) 
										(* 1.5 (#scl)) 
										0.0 
										(strcat y_label " = " (rtos dx 2 2) "m")
									) ; end command
									(command 
										".text" 
										(mapcar '+ ptd (list (- (* (#scl) 18.5)) (- (* (#scl) 3.5)))) 
										(* 1.5 (#scl)) 
										0.0 
										(strcat x_label " = " (rtos dy 2 2) "m")
									) ; end command
								) ; end progn
							) ; end if
						) ; end if
					) ; end if
				) ; end if			
			  ) ; end progn
			) ; end if
		) ; end progn
	) ; end while
	
	(princ)
) ; end defun

(princ)
