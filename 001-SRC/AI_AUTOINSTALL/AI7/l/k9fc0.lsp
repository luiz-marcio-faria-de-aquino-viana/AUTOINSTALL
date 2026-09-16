
;;
;; K9FC0.lsp
;; Copyright (C) 2014 by Luiz Marcio F A Viana, 2/19/14
;;

(defun V:DETLIB(f) (strcat "L:\\DETALHES_PADRONIZADOS\\AI-DET\\" f))

(setq id_blk 1)
(setq det_list '())

;; det_block(): funcao que cria ou modifica o bloco de detalhe
;; cat - sigla do catalogo
;; blk - nome do bloco
;; lay - nome da camada padrao
;; pt0 - ponto de insercao
;; pti - ponto inicial da janela de selecao
;; ptf - ponto final da janela de selecao
(defun det_block(cat blk pti ptf / oldlay oldecho oldblip oldhigh)
  (setq oldecho (acadvar "cmdecho" 0))

  ;;(command ".undo" "g")

  (setq ptc (mapcar '/ (mapcar '+ pti ptf) '(2.0 2.0 2.0)))
  
  (command
    ".zoom"
      "c" ptc (abs (- (cadr ptf) (cadr pti)))
    ".mslide"
      (V:DETLIB (strcat cat "/S/" blk))
  ) ; end command
  (if (findfile (V:DETLIB (strcat cat "/D/" blk ".dwg")))
    (command ".wblock" (V:DETLIB (strcat cat "/D/" blk)) "y" "" ptc "w" pti ptf "")
    (command ".wblock" (V:DETLIB (strcat cat "/D/" blk)) "" ptc "w" pti ptf "")
  ) ; end if
  (command
    ".oops"
  ) ; end command
  (command ".zoom" "p")

  ;;(command ".undo" "e")

  (setvar "cmdecho" oldecho)
) ; end defun

(defun det_nom(pti ptf / ss nom cnt enm ent it lsnom)
	(setq lsnom '())
				
	(if (setq ss (ssget "w" pti ptf))
		(progn
			(setq cnt (sslength ss))
			(while (>= (setq cnt (1- cnt)) 0)
				(setq 
				  enm (ssname ss cnt)
				  ent (entget enm)
				) ; end setq
				
				(if (or (= (enttype enm) "TEXT") (= (enttype enm) "MTEXT") )
					(progn
						(setq txt_height (cdr (assoc 40 ent)))
						(if (and (>= txt_height 3.5) (<= txt_height 5.5) )
							(setq lsnom (append lsnom (list (list (cadr (assoc 10 ent)) (cdr (assoc 1 ent))))))
						) ; end if
					) ; end progn
				) ; end if

			) ; end while
		) ; end progn
	) ; end if
	
	(setq lsnom (xsort lsnom))
	(setq nom "")
	(foreach it lsnom 
		(setq nom (strcat nom " " (cadr it)))
	) ; end foreach
	(setq nom (ltrim nom))
	
	nom
) ; end defun

(defun c:publishdet(/ cat ss cnt ent pt0 ptc pti ptf blk)
	(initget 1 "EL EE ES H INC G TE IE AR")
	(setq cat (getkword "\nPrefixo da camada (EL/EE/ES/H/INC/G/TE/IE ou AR): "))	

	(prompt "\nSelecione os detalhes a serem publicados...")
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
			(setq blk (strcat cat (lfill (rtos id_blk 2 0) 3 "0")))			
			(setq nom (det_nom pti ptf))
			(setq det_list (append det_list (list (list nom blk))))
			(det_block cat blk pti ptf)
			(setq id_blk (1+ id_blk))
		  ) ; end progn
		) ; end while
	  ) ; end progn
	) ; end if
	(fwrite (V:DETLIB (strcat cat "/detalhes.lst")) det_list "@")
    (princ)
) ; end defun

(defun c:ajustadet(/ pti ptf ss nom cnt enm ent it lsnom)
    (setq hmin (getreal "\nAltura minima do texto (em unidades de tela): "))
    (setq hmax (getreal "\nAltura maxima do texto (em unidades de tela): "))

    (setq htxt (getreal "\nAltura do texto (mm): "))
	
	(setq pti (getpoint "\nPonto inicial: "))
	(setq ptf (getcorner pti "\nPonto final: "))
	
	(if (setq ss (ssget "w" pti ptf))
		(progn
			(setq cnt (sslength ss))
			(while (>= (setq cnt (1- cnt)) 0)
				(setq 
				  enm (ssname ss cnt)
				  ent (entget enm)
				) ; end setq
				
				(if (or (= (enttype enm) "TEXT") (= (enttype enm) "MTEXT") )
					(progn
						(setq txt_height (cdr (assoc 40 ent)))
						(if (and (>= txt_height hmin) (<= txt_height hmax) )
							(progn
							  (setq ent (subst (cons 40 (* htxt (#SCL))) (assoc 40 ent) ent))
							  (entmod ent)
							) ; end progn
						) ; end if
					) ; end progn
				) ; end if

			) ; end while
		) ; end progn
	) ; end if
	
	(setq lsnom (xsort lsnom))
	(setq nom "")
	(foreach it lsnom 
		(setq nom (strcat nom " " (cadr it)))
	) ; end foreach
	(setq nom (ltrim nom))
	
	nom
) ; end defun

(princ)
