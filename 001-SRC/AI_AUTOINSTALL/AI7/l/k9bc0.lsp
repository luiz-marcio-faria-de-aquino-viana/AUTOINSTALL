
;;
;; K9BC0.lsp
;; Copyright (C) 2013 by Luiz Marcio F A Viana, 28/08/2013
;;

;; definicao das variaveis globais
(setq #ESPEC (/ 1000.0 (#UND)))  ;; espesura inicial da calha
(setq #ESPCH (/ 250.0 (#UND)))   ;; tamanho do chamfro

;; eletrocalha_lado(): funcao que retorna o lado de criacao da eletrocalha (-1=esquerda, 0=centro, 1=direita)
;;  pti - ponto inicial da reta que caracteriza a linha guia para o desenho da eletrocalha
;;  ptf - ponto final da reta que caracteriza a linha guia para o desenho da eletrocalha
;;  pt  - ponto que indica o sentido de criacao da eletrocalha
(defun eletrocalha_lado(pti ptf pt / v v1)
  (if pt
    (progn
      (setq
        v  (mapcar '- ptf pti)
        v1 (mapcar '- pt  pti)
      ) ; end setq
      (if (>= (caddr (vtvet v1 v)) 0)
        1        ;; retorna (=1) se resultado do produto vetorial tiver o sentido positivo do eixo z
        -1       ;; retorna (=-1) se resultado do produto vetorial tiver o sentido negativo do eixo z
      ) ; end if
    ) ; end progn
    0        ;; retorna (=0) se ponto indicador de sentido igual a nil
  ) ; end if
) ; end defun

;; eletrocalha_desenha(): funcao desenha as faces da eletrocalha e retorna lista com ename das entidades
;;  pti - ponto inicial da eletrocalha
;;  ptf - ponto final da eletrocalha
;;  dir - sentido de criacao da eletrocalha (-1=esquerda, 0=centro, 1=direita)
(defun eletrocalha_desenha(pti ptf dir / oldblip u ne nd de dd pt1i pt1f pt2i pt2f e1 e2)

  (setq u (vtunit (mapcar '- ptf pti)) )
  (setq
    ne (vtnorm u)
    nd (vtmul -1 ne)
  ) ; end setq

  (cond
    ( (= dir -1)
      (setq
        de #ESPEC
        dd 0
      ) ; end setq
    ) ; end case
    ( (= dir 0)
      (setq
        de (/ #ESPEC 2.0)
        dd (/ #ESPEC 2.0)
      ) ; end setq
    ) ; end case
    ( (= dir 1)
      (setq
        de 0
        dd #ESPEC
      ) ; end setq
    ) ; end case
  ) ; end cond

  (setq
    pt1i (mapcar '+ pti (vtmul de ne))
    pt1f (mapcar '+ ptf (vtmul de ne))
  ) ; end setq

  (setq
    pt2i (mapcar '+ pti (vtmul dd nd))
    pt2f (mapcar '+ ptf (vtmul dd nd))
  ) ; end setq

  (setq oldblip (acadvar "blipmode" 0))
  (command ".line" pt1i pt1f "")
  (setq e1 (entlast))
  (command ".line" pt2i pt2f "")
  (setq e2 (entlast))
  (setvar "blipmode" oldblip)

  (list e1 e2)
) ; end if

(defun eletrocalha_fecha(enm1 enm2 flg / ent1 ent2 pti1 ptf1 pti2 ptf2 e1)

  (setq
    ent1 (entget enm1)
	ent2 (entget enm2)
  ) ; end setq
  
  (setq 
    pti1 (cdr (assoc 10 ent1))
	ptf1 (cdr (assoc 11 ent1))
  ) ; end setq

  (setq 
    pti2 (cdr (assoc 10 ent2))
	ptf2 (cdr (assoc 11 ent2))
  ) ; end setq

  (if flg
	  (if (<= (distance pti1 pti2) (distance pti1 ptf2))
		(progn
		  (command ".line" pti1 pti2 "")
		  (setq e1 (entlast))
		) ; end progn
		(progn
		  (command ".line" pti1 ptf2 "")
		  (setq e1 (entlast))
		) ; end progn
	   ) ; end if
	  (if (<= (distance ptf1 ptf2) (distance ptf1 pti2))
		(progn
		  (command ".line" ptf1 ptf2 "")
		  (setq e1 (entlast))
		) ; end progn
		(progn
		  (command ".line" ptf1 pti2 "")
		  (setq e1 (entlast))
		) ; end progn
	   ) ; end if
  ) ; end if
  
  e1
) ; end if

;; eletrocalha_une(): funcao que une as faces de eletrocalhas adjacentes
;;  e1 - ename da primeira eletrocalha
;;  e2 - ename da segunda eletrocalha
;;  lado - lado da curva (0=sem curva/-1=interno/1=externo)
;;(defun eletrocalha_une(e1 e2 lado)
;;  (eletrocalha_une_chamfro e1 e2 lado)
;;) ; end defun

;; eletrocalha_une_simples(): funcao que une as faces de eletrocalhas adjacentes
;;  e1 - ename da primeira eletrocalha
;;  e2 - ename da segunda eletrocalha
(defun eletrocalha_une_simples(e1 e2 / ent1 ent2 pt1i pt1f pt2i pt2f pt0)
  (setq ent1 (entget e1))
  (setq
    pt1i (cdr (assoc 10 ent1))
    pt1f (cdr (assoc 11 ent1))
  ) ; end setq
  (setq ent2 (entget e2))
  (setq
    pt2i (cdr (assoc 10 ent2))
    pt2f (cdr (assoc 11 ent2))
  ) ; end setq
  (if (setq pt0 (inters pt1i pt1f pt2i pt2f nil))
    (progn
      (entmod (subst (cons 11 pt0) (assoc 11 ent1) ent1))
      (entmod (subst (cons 10 pt0) (assoc 10 ent2) ent2))
    ) ; end progn
    (entmod (subst (cons 10 pt1f) (assoc 10 ent2) ent2))
  ) ; end if
) ; end defun

;; eletrocalha_une_chamfro(): funcao que une as faces de eletrocalhas adjacentes
;;  e1 - ename da primeira eletrocalha
;;  e2 - ename da segunda eletrocalha
;;  lado - lado da curva (0=sem curva/-1=interno/1=externo)
(defun eletrocalha_une_chamfro(e1 e2 lado / ent1 ent2 pt1i pt1f pt2i pt2f pt0 w0 fator larg ent1_mod ent2_mod pt1f_mod pt2i_mod)
  (setq ent1 (entget e1))
  (setq
    pt1i (cdr (assoc 10 ent1))
    pt1f (cdr (assoc 11 ent1))
  ) ; end setq
  (setq u1 (vtunit (mapcar '- pt1i pt1f)))  
  
  (setq ent2 (entget e2))
  (setq
    pt2i (cdr (assoc 10 ent2))
    pt2f (cdr (assoc 11 ent2))
  ) ; end setq
  (setq u2 (vtunit (mapcar '- pt2f pt2i)))  

  (if (setq pt0 (inters pt1i pt1f pt2i pt2f nil))
    (progn
	  (setq 
	    ent1_mod (subst (cons 11 pt0) (assoc 11 ent1) ent1)
        ent2_mod (subst (cons 10 pt0) (assoc 10 ent2) ent2)
	  ) ; end setq

	  (entmod ent_mod1)
      (entmod ent_mod2)
    ) ; end progn
    (entmod (subst (cons 10 pt1f) (assoc 10 ent2) ent2))
  ) ; end if

  (if (< lado 0.0)
    (progn
	  (setq 
	    pt1f_mod (mapcar '+ pt0 (vtmul #ESPCH u1))
		pt2i_mod (mapcar '+ pt0 (vtmul #ESPCH u2))
	  ) ; end setq
	  (entmod (subst (cons 11 pt1f_mod) (assoc 11 ent1_mod) ent1_mod))
      (entmod (subst (cons 10 pt2i_mod) (assoc 10 ent2_mod) ent2_mod))	  
	  (command ".line" pt1f_mod pt2i_mod "")
	) ; end progn
	(if (> lado 0.0)
	  (progn
	    (setq 
		  w0 (/ 1000.0 (#UND))
		  fator (/ #ESPEC w0)
        ) ; end setq
        (setq larg (/ (+ #ESPCH (* fator 41.421356) (* fator 41.421356)) (sqrt 2.0)))		
	    (setq 
	      pt1f_mod (mapcar '+ pt0 (vtmul larg u1))
		  pt2i_mod (mapcar '+ pt0 (vtmul larg u2))
	    ) ; end setq
	    (entmod (subst (cons 11 pt1f_mod) (assoc 11 ent1_mod) ent1_mod))
        (entmod (subst (cons 10 pt2i_mod) (assoc 10 ent2_mod) ent2_mod))	  
	    (command ".line" pt1f_mod pt2i_mod "")
	  ) ; end progn
	) ; end if
  ) ; end if
  (entlast)
) ; end defun

;; eletrocalha_conecta(): funcao que conecta uma eletrocalha a face de outra
;;  enm1 - ename da primeira face da eletrocalha que sera conectada
;;  enm2 - ename da segunda face da eletrocalha que sera conectada
;;  enm  - ename da face da eletrocalha destino da conexao
;;  ext  - indicador da extremidade de conexao (0=inicial, 1=final)
(defun eletrocalha_conecta(enm1 enm2 enm ext / oldblip oldhigh ent1 ent2 ent pt1i pt1f pt2i pt2f pti ptf pt1x pt2x enm1x enm2x)
  (setq ent1 (entget enm1))
  (setq
    pt1i (cdr (assoc 10 ent1))
    pt1f (cdr (assoc 11 ent1))
  ) ; end setq

  (setq ent2 (entget enm2))
  (setq
    pt2i (cdr (assoc 10 ent2))
    pt2f (cdr (assoc 11 ent2))
  ) ; end setq

  (setq ent (entget enm))
  (setq
    pti (cdr (assoc 10 ent))
    ptf (cdr (assoc 11 ent))
  ) ; end setq

  (setq
    pt1x (inters pt1i pt1f pti ptf nil)
    pt2x (inters pt2i pt2f pti ptf nil)
  ) ; end setq

  (if (and pt1x pt2x)
    (progn
      (if (= ext 0)
        (progn
          (entmod (subst (cons 10 pt1x) (assoc 10 ent1) ent1))
          (entmod (subst (cons 10 pt2x) (assoc 10 ent2) ent2))
        ) ; end progn
        (progn
          (entmod (subst (cons 11 pt1x) (assoc 11 ent1) ent1))
          (entmod (subst (cons 11 pt2x) (assoc 11 ent2) ent2))
        ) ; end progn
      ) ; end if
      (setq oldhigh (acadvar "highlight" 0))
      (setq oldblip (acadvar "blipmode" 0))
      (command ".erase" enm "")
      (if (<= (distance pti pt1x) (distance pti pt2x))
	    (progn
          (command ".line" pt1x pti "")
	      (setq enm1x (entlast))
          (command ".line" pt2x ptf "")
	      (setq enm2x (entlast))
	    ) ; end progn
	    (progn
          (command ".line" pt2x pti "")
          (setq enm2x (entlast))
          (command ".line" pt1x ptf "")
          (setq enm1x (entlast))
	    ) ; end progn
	  ) ; end if
	  (eletrocalha_une_chamfro enm1 enm1x -1)
	  (eletrocalha_une_chamfro enm2 enm2x -1)
      (setvar "highlight" oldhigh)
      (setvar "blipmode" oldblip)
    ) ; end progn
    (prompt "\nERR: Nao ha conexao possivel com a eletrocalha selecionada.")
  ) ; end if

) ; end defun

;; c:eletrocalha(): rotina para desenho de eletrocalhas com linhas duplas
(defun c:eletrocalha(/ oldech enmi enmf pti ptf ss esp dir ls1 ls2 ptls enmls flg ls lsent lsch cmd cmd0 v v0 u0 vdir enmi1 enmi2 enmf1 enmf2)
  (setq oldech (acadvar "cmdecho" 0))

  (prompt (strcat "\nLargura da eletrocalha = " (rtos #ESPEC 2 2)) )

  (setq enmi nil)      ;; ename da face de contato do primeiro vertice (nil=s/conexao)
  (setq enmf nil)      ;; ename da face de contato do ultimo vertice (nil=s/conexao)

  (setq lsent nil)     ;; lista de entidades para converter em polyline
  
  (setq 
    cmd nil
    cmd0 nil
  ) ; end setq
  
  (initget "Conectar")
  (setq cmd0
    (setq pti (getpoint "\nConectar/<Primeiro vertice>: "))
  ) ; end setq
  (cond
    ( (null pti)
      (setq pti (getvar "lastpoint"))
    ) ; end case
    ( (= pti "Conectar")
      (progn
        (initget 1 "Primeiro")
        (while (null (setq ss (entsel "\nSelecione uma eletrocalha (ou P para primeiro ponto): ")) )
          (prompt "\nERR: Resposta nula nao e valida.") )
        (if (= ss "Primeiro")
          (progn
            (while (null (setq enmi (car (entsel "\nSelecione uma eletrocalha: "))) )
              (prompt "\nERR: Resposta nula nao e valida.") )
            (initget 1)
            (setq pti (getpoint "\nInforme o ponto de contato: "))
          ) ; end progn
          (progn
            (setq enmi (car ss))
            (setq pti (cadr ss))
          ) ; end progn
        ) ; end if
      ) ; end progn
    ) ; end case
  ) ; end cond

  (while (= (progn
              (initget 1 "Largura Conectar")
              (setq cmd
			    (setq ptf (getpoint pti "\nLargura/Conectar/<Proximo vertice>: "))
			  ) ; end setq
            ) ; end progn
            "Largura"
         ) ; end eq
    (initget 6)
    (setq esp (getdist pti (strcat "\nLargura da eletrocalha <" (rtos #ESPEC 2 2) ">: ")) )
    (if esp (setq #ESPEC esp))
  ) ; end while
  
  (if (= ptf "Conectar")
    (progn
      (initget 1 "Primeiro")
      (while (null (setq ss (entsel "\nSelecione uma eletrocalha (ou P para primeiro ponto): ")) )
        (prompt "\nERR: Resposta nula nao e valida.") )
      (if (= ss "Primeiro")
        (progn
          (while (null (setq enmf (car (entsel "\nSelecione uma eletrocalha: "))) )
            (prompt "\nERR: Resposta nula nao e valida.") )
          (initget 1)
          (setq ptf (getpoint pti "\nInforme o ponto de contato: "))
        ) ; end progn
        (progn
          (setq enmf (car ss))
          (setq ptf (cadr ss))
        ) ; end progn
      ) ; end if
    ) ; end progn
  ) ; end if

  ;; obtem o lado de construcao da eletrocalha (-1=esquerda, 0=centro, 1=direita)
  (setq dir (eletrocalha_lado pti ptf (getpoint pti "\nInforme o lado de construcao da eletrocalha (ENTER=centro): ")) )

;; #RCTASK 02/05/2010  (command ".undo" "g") p/ IntelliCAD 2007, foi trocado para    (command ".undo" "m")

;   (command ".undo" "m")

  (setq ls1 (eletrocalha_desenha pti ptf dir))

  (if enmi (eletrocalha_conecta (car ls1) (cadr ls1) enmi 0))   ;; 0=conecta extremidade inicial

  (setq
    ptls  (list ptf pti)
    enmls (list ls1)
  ) ; end setq

  (setq pti ptf)

  (if (null enmf)
    (progn
      (setq flg 't)
      (while flg
        (initget "Largura Fechar Conectar Undo")
        (setq cmd 
		  (setq ptf (getpoint pti "\nLargura/Fechar/Conectar/Undo/<Proximo vertice>: "))
		) ; end setq
		
        (cond
          ( (= ptf "Largura")
            (progn
              (initget 6)
              (setq esp (getdist pti (strcat "\nLargura da eletrocalha <" (rtos #ESPEC 2 2) ">: ")) )
              (if esp (setq #ESPEC esp))
            ) ; end progn
          ) ; end case
          ( (= ptf "Conectar")
            (progn
              (initget 1 "Primeiro")
              (while (null (setq ss (entsel "\nSelecione uma eletrocalha (ou P para primeiro ponto): ")) )
                (prompt "\nERR: Resposta nula nao e valida.") )
              (if (= ss "Primeiro")
                (progn
                  (while (null (setq enmf (car (entsel "\nSelecione uma eletrocalha: "))) )
                    (prompt "\nERR: Resposta nula nao e valida.") )
                  (initget 1)
                  (setq ptf (getpoint pti "\nInforme o ponto de contato: "))
                ) ; end progn
                (progn
                  (setq enmf (car ss))
                  (setq ptf (cadr ss))
                ) ; end progn
              ) ; end if
              (setq ls2 (eletrocalha_desenha pti ptf dir))
			  (setq 
			    v (mapcar '- ptf pti)
			    v0 (mapcar '- pti (cadr ptls))
				u0 (vtunit v0)
		      ) ; end setq
			  (setq vdir (caddr (vtvet v u0)))
			  (if (> vdir 0.0)
			    (progn
				  (setq lsch 
			        (list
			          (eletrocalha_une_chamfro (car ls1) (car ls2) 1)
			          (eletrocalha_une_chamfro (cadr ls1) (cadr ls2) -1)
					) ; end list
				  ) ; end setq
				 (setq enmls (cons lsch enmls))
 				) ; end progn
				(if (< vdir 0)
			      (progn
				    (setq lsch 
					  (list
			            (eletrocalha_une_chamfro (car ls1) (car ls2) -1)
			            (eletrocalha_une_chamfro (cadr ls1) (cadr ls2) 1)
					  ) ; end list
			        ) ; end setq
					(setq enmls (cons lsch enmls))
				  ) ; end progn
				  (progn
			        (eletrocalha_une_simples (car ls1) (car ls2))
			        (eletrocalha_une_simples (cadr ls1) (cadr ls2))
				  ) ; end progn
				) ; end if
		      ) ; end if
			  (eletrocalha_conecta (car ls1) (cadr ls1) enmf 1)
              (setq
                ptls  (cons ptf ptls)
                enmls (cons ls2 enmls)
              ) ; end setq
              (setq
                ls1 ls2
                pti ptf
              ) ; end setq
              (setq flg nil)
            ) ; end progn
          ) ; end case
          ( (= ptf "Undo")
            (progn
              (if (> (length ptls) 1)
                (progn
                  (command ".erase" (car (car enmls)) (cadr (car enmls)) "")
                  (setq
                    ptls (cdr ptls)
                    enmls (cdr enmls)
                  ) ; end setq
                  (setq
                    ls1 (car enmls)
                    pti (car ptls)
                  ) ; end setq
                ) ; end progn
              ) ; end if
            ) ; end progn
          ) ; end case
          ( (null ptf) (setq flg nil) )
          ( (= ptf "Fechar")
            (progn
              (setq
                ptf (car (reverse ptls))
                ls (car (reverse enmls))
              ) ; end setq
              (setq ls2 (eletrocalha_desenha pti ptf dir))
			  (eletrocalha_une_simples (car ls1) (car ls2))
			  (eletrocalha_une_simples (cadr ls1) (cadr ls2))
			  (eletrocalha_une_simples (car ls2) (car ls))
			  (eletrocalha_une_simples (cadr ls2) (cadr ls))
              (setq
                ptls  (cons ptf ptls)
                enmls (cons ls2 (cons lsch2 (cons lsch1 enmls)))
              ) ; end setq
              (setq
                ls1 ls2
                pti ptf
              ) ; end setq
              (setq flg nil)
            ) ; end progn
          ) ; end case
          ( 't
            (progn
              (setq ls2 (eletrocalha_desenha pti ptf dir))
			  (setq 
			    v (mapcar '- ptf pti)
			    v0 (mapcar '- pti (cadr ptls))
				u0 (vtunit v0)
		      ) ; end setq
			  (setq vdir (caddr (vtvet v u0)))
			  (if (> vdir 0.0)
			    (progn
				  (setq lsch 
			        (list
			          (eletrocalha_une_chamfro (car ls1) (car ls2) 1)
			          (eletrocalha_une_chamfro (cadr ls1) (cadr ls2) -1)
					) ; end list
				  ) ; end setq
				 (setq enmls (cons lsch enmls))
 				) ; end progn
				(if (< vdir 0)
			      (progn
				    (setq lsch 
					  (list
			            (eletrocalha_une_chamfro (car ls1) (car ls2) -1)
			            (eletrocalha_une_chamfro (cadr ls1) (cadr ls2) 1)
					  ) ; end list
			        ) ; end setq
					(setq enmls (cons lsch enmls))
				  ) ; end progn
				  (progn
			        (eletrocalha_une_simples (car ls1) (car ls2))
			        (eletrocalha_une_simples (cadr ls1) (cadr ls2))
				  ) ; end progn
				) ; end if
		      ) ; end if
              (setq
                ptls  (cons ptf ptls)
                enmls (cons ls2 (cons lsch1 enmls))
              ) ; end setq
              (setq
                ls1 ls2
                pti ptf
              ) ; end setq
            ) ; end progn
          ) ; end case
        ) ; end cond

      ) ; end while
	  
    ) ; end progn
  ) ; end if

  (setq
    enmi1 (car (car enmls))
    enmi2 (cadr (car enmls))
  ) ; end setq

  (setq
    enmf1 (car (car (reverse enmls)))
    enmf2 (cadr (car (reverse enmls))) 
  ) ; end setq

  (if (/= cmd0 "Conectar")
    (eletrocalha_fecha enmf1 enmf2 't)
  ) ; end if
	  
  (if (/= cmd "Conectar")
    (eletrocalha_fecha enmi1 enmi2 nil)
  ) ; end if
	     
  (if enmf (eletrocalha_conecta (car ls1) (cadr ls1) enmf 1))    ;; 1=conecta extremidade final
;;  (command ".undo" "e")

) ; end defun

(princ)
