;;
;; K1BC0.lsp
;; Copyright (C) 2015 by Luiz Marcio F A Viana, 13/07/2015
;;

(defun c:cotaeixo(/ x_label y_label x_eixo y_eixo x_eixo_ent x_eixo_pt0 x_eixo_pt1 y_eixo_ent 
					y_eixo_pt0 y_eixo_pt1 ptc x_eixo_vetor y_eixo_vetor x_unit y_unit pti ptd 
					vx vy dx dy v x y)
	(setvar "cmdecho" 0)
	
	(setq x_label (getstring "\nInforme o nome do eixo horizontal: "))
	(setq y_label (getstring "\nInforme o nome do eixo vertical: "))
	
	(setq x_eixo (car (entsel "\nSelecione o eixo horizontal: ")))
	(setq y_eixo (car (entsel "\nSelecione o eixo vertical: ")))
	
	(setq 
		x_eixo_ent (entget x_eixo)
		x_eixo_pt0 (cdr (assoc 10 x_eixo_ent))
		x_eixo_pt1 (cdr (assoc 11 x_eixo_ent))
	) ; end setq
	
	(setq 
		y_eixo_ent (entget y_eixo)
		y_eixo_pt0 (cdr (assoc 10 y_eixo_ent))
		y_eixo_pt1 (cdr (assoc 11 y_eixo_ent))
	) ; end setq
	
	(setq ptc (inters x_eixo_pt0 x_eixo_pt1 y_eixo_pt0 y_eixo_pt1 nil))
	
	(setq 
		x_eixo_vetor (mapcar '- x_eixo_pt1 ptc)
		y_eixo_vetor (mapcar '- y_eixo_pt1 ptc)
	) ; end setq

	(setq
		x_unit (vtunit x_eixo_vetor)
		y_unit (vtunit y_eixo_vetor)
	) ; end setq
	
	(prompt "\nInicio da marcacao dos pontos em relacao aos eixos...")
	(while (setq pti (getpoint "\nMarque o ponto ou ENTER para terminar: "))
		(progn
			(setq ptd (getpoint pti "\nMarque o local para insercao da cota: "))
			
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
	) ; end while
	
	(princ)
) ; end defun

(princ)
