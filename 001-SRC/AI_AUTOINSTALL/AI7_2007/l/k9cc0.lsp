
;;
;; K9CC0.lsp
;; Copyright (C) 2013 by Luiz Marcio F A Viana, 28/08/2013
;;

(defun c:detajusta(/ ss cnt enm ent lay prefix lay_dest enm txt_height pl_width ent1 ent2)
	(initget 1 "EL EE ES H INC G TE IE AR")
	(setq prefix (getkword "\nPrefixo da camada (EL/EE/ES/H/INC/G/TE/IE ou AR): "))	

	(prompt "\nSelecione o detalhe:")
	(if (setq ss (ssget))
		(progn
			(setq cnt (sslength ss))
			(prompt (strcat "\nProcessando " (itoa cnt) " elementos... "))
			(while (>= (setq cnt (1- cnt)) 0)
				(setq 
				  enm (ssname ss cnt)
				  ent (entget enm)
				) ; end setq
				
				(setq lay_dest (strcat prefix "-DET-P1"))

				(if (or (= (enttype enm) "TEXT") (= (enttype enm) "MTEXT") )
					(progn
						(setq txt_height (cdr (assoc 40 ent)))
						(if (> txt_height (* 2.5 (#SCL)))
							(setq lay_dest (strcat prefix "-DET-P5"))
							(setq lay_dest (strcat prefix "-DET-P2"))
						) ; end if
					) ; end progn
				) ; end if

				(if (= (enttype enm) "POLYLINE") 
					(progn
						(setq pl_width (cdr (assoc 40 ent)))
						(if (> pl_width 0.0)
							(setq lay_dest (strcat prefix "-DET-P5"))
							(setq lay_dest (strcat prefix "-DET-P2"))
						) ; end if
					) ; end progn
				) ; end if
				
				(setq ent1 (subst (cons 8 lay_dest) (assoc 8 ent) ent))
				(setq ent2 (subst (cons 62 256) (assoc 62 ent1) ent1))
				
				(entmod ent2)
			) ; end while
		) ; end progn
	) ; end if
	(princ)
) ; end defun

(defun c:dettrocacamada(/ prefix sufix lay_dest ss cnt enm ent ent1 ent2)
	(initget 1 "EL EE ES H INC G TE IE AR")
	(setq prefix (getkword "\nPrefixo da camada (EL/EE/ES/H/INC/G/TE/IE ou AR): "))	

	(initget 1 "C1 C3 C4 C5 P1 P2 P3 P5")
	(setq sufix (getkword "\nCamada de detalhe (C1/C3/C4/C5/P1/P2/P3 ou P5): "))	

	(setq lay_dest (strcat prefix "-DET-" sufix))

	(prompt "\nSelecione o detalhe: ")
	(if (setq ss (ssget))
		(progn
			(setq cnt (sslength ss))
			(prompt (strcat "\nProcessando " (itoa cnt) " elementos... "))
			(while (>= (setq cnt (1- cnt)) 0)
				(setq 
				  enm (ssname ss cnt)
				  ent (entget enm)
				) ; end setq
				
				(setq ent1 (subst (cons 8 lay_dest) (assoc 8 ent) ent))
				(setq ent2 (subst (cons 62 256) (assoc 62 ent1) ent1))
				
				(entmod ent2)
			) ; end while
		) ; end progn
	) ; end if
	(princ)
) ; end defun

(defun c:detajustatexto(/ ss cnt enm ent lay prefix lay_dest enm txt_newheigth txt_height pl_width ent1 ent2)
	(prompt "\nSelecione o detalhe:")
	(if (setq ss (ssget))
		(progn
			(setq cnt (sslength ss))
			(prompt (strcat "\nProcessando " (itoa cnt) " elementos... "))
			(while (>= (setq cnt (1- cnt)) 0)
				(setq 
				  enm (ssname ss cnt)
				  ent (entget enm)
				) ; end setq
				
				(setq txt_newheight (* 2.0 (#SCL)))
				
				(if (or (= (enttype enm) "TEXT") (= (enttype enm) "MTEXT") )
					(progn
						(setq txt_height (cdr (assoc 40 ent)))
						(if (< txt_height (* 1.75 (#SCL)))
							(setq txt_newheight (* 1.5 (#SCL)))
							(if (< txt_height (* 2.5 (#SCL)))
								(setq txt_newheight (* 2.0 (#SCL)))
								(if (< txt_height (* 4.0 (#SCL)))
									(setq txt_newheight (* 3.0 (#SCL)))
									(setq txt_newheight (* 5.0 (#SCL)))
								) ; end if
							) ; end if
						) ; end if
						
						(setq ent1 (subst (cons 40 txt_newheight) (assoc 40 ent) ent))
						(setq ent2 (subst (cons 7 "ROMANS") (assoc 7 ent) ent1))
						
						(entmod ent2)
					) ; end progn
				) ; end if

			) ; end while
		) ; end progn
	) ; end if
	(princ)
) ; end defun

(princ)
