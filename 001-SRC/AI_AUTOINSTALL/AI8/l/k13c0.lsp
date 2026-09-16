
;;
;; K13C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 2/11/98
;;

;; definicao das variaveis globais
(or #ESPCP (setq #ESPCP (/ 100.0 (#UND))) )

;; parede_lado(): funcao que retorna o lado de criacao da parede (-1=esquerda, 0=centro, 1=direita)
;;  pti - ponto inicial da reta que caracteriza a linha guia para o desenho da parede
;;  ptf - ponto final da reta que caracteriza a linha guia para o desenho da parede
;;  pt  - ponto que indica o sentido de criacao da parede
(defun parede_lado(pti ptf pt / v v1)
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

;; parede_desenha(): funcao desenha as faces da parede e retorna lista com ename das entidades
;;  pti - ponto inicial da parede
;;  ptf - ponto final da parede
;;  dir - sentido de criacao da parede (-1=esquerda, 0=centro, 1=direita)
(defun parede_desenha(pti ptf dir / oldblip u ne nd de dd pt1i pt1f pt2i pt2f e1 e2)

  (setq u (vtunit (mapcar '- ptf pti)) )
  (setq
    ne (vtnorm u)
    nd (vtmul -1 ne)
  ) ; end setq

  (cond
    ( (= dir -1)
      (setq
        de #ESPCP
        dd 0
      ) ; end setq
    ) ; end case
    ( (= dir 0)
      (setq
        de (/ #ESPCP 2.0)
        dd (/ #ESPCP 2.0)
      ) ; end setq
    ) ; end case
    ( (= dir 1)
      (setq
        de 0
        dd #ESPCP
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

;; parede_une(): funcao que une as faces de paredes adjacentes
;;  e1 - ename da primeira parede
;;  e2 - ename da segunda parede
(defun parede_une(e1 e2 / ent1 ent2 pt1i pt1f pt2i pt2f pt0)
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

;; parede_conecta(): funcao que conecta uma parede a face de outra
;;  enm1 - ename da primeira face da parede que sera conectada
;;  enm2 - ename da segunda face da parede que sera conectada
;;  enm  - ename da face da parede destino da conexao
;;  ext  - indicador da extremidade de conexao (0=inicial, 1=final)
(defun parede_conecta(enm1 enm2 enm ext / oldblip oldhigh ent1 ent2 ent pt1i pt1f pt2i pt2f pti ptf pt1x pt2x)
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
      (command ".break" enm pt1x pt2x)
      (setvar "highlight" oldhigh)
      (setvar "blipmode" oldblip)
    ) ; end progn
    (prompt "\nERR: Nao ha conexao possivel com a parede selecionada.")
  ) ; end if

) ; end defun

;; c:parede(): rotina para desenho de paredes com linhas duplas
(defun c:parede(/ oldech enmi enmf pti ptf ss esp dir ls1 ls2 ptls enmls flg ls)
  (m:savevars)

  (prompt (strcat "\nEspesura da parede = " (rtos #ESPCP 2 2)) )

  (setq enmi nil)      ;; ename da face de contato do primeiro vertice (nil=s/conexao)
  (setq enmf nil)      ;; ename da face de contato do ultimo vertice (nil=s/conexao)

  (initget "Conectar")
  (setq pti (getpoint "\nConectar/<Primeiro vertice>: "))
  (cond
    ( (null pti)
      (setq pti (getvar "lastpoint"))
    ) ; end case
    ( (= pti "Conectar")
      (progn
        (initget 1 "Primeiro")
        (while (null (setq ss (entsel "\nSelecione uma parede (ou P para primeiro ponto): ")) )
          (prompt "\nERR: Resposta nula nao e valida.") )
        (if (= ss "Primeiro")
          (progn
            (while (null (setq enmi (car (entsel "\nSelecione uma parede: "))) )
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
              (initget 1 "Espesura Conectar")
              (setq ptf (getpoint pti "\nEspesura/Conectar/<Proximo vertice>: "))
            ) ; end progn
            "Espesura"
         ) ; end eq
    (initget 6)
    (setq esp (getdist pti (strcat "\nEspesura da parede <" (rtos #ESPCP 2 2) ">: ")) )
    (if esp (setq #ESPCP esp))
  ) ; end while
  
  (if (= ptf "Conectar")
    (progn
      (initget 1 "Primeiro")
      (while (null (setq ss (entsel "\nSelecione uma parede (ou P para primeiro ponto): ")) )
        (prompt "\nERR: Resposta nula nao e valida.") )
      (if (= ss "Primeiro")
        (progn
          (while (null (setq enmf (car (entsel "\nSelecione uma parede: "))) )
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

  ;; obtem o lado de construcao da parede (-1=esquerda, 0=centro, 1=direita)
  (setq dir (parede_lado pti ptf (getpoint pti "\nInforme o lado de construcao da parede (ENTER=centro): ")) )


;; #RCTASK 02/05/2010  (command ".undo" "g") p/ IntelliCAD 2007, foi trocado para    (command ".undo" "m")

;   (command ".undo" "m")

  (setq ls1 (parede_desenha pti ptf dir))

  (if enmi (parede_conecta (car ls1) (cadr ls1) enmi 0))   ;; 0=conecta extremidade inicial

  (setq
    ptls  (list ptf pti)
    enmls (list ls1)
  ) ; end setq

  (setq pti ptf)

  (if (null enmf)
    (progn
      (setq flg 't)
      (while flg
        (initget "Espesura Fechar Conectar Undo")
        (setq ptf (getpoint pti "\nEspesura/Fechar/Conectar/Undo/<Proximo vertice>: "))

        (cond
          ( (= ptf "Espesura")
            (progn
              (initget 6)
              (setq esp (getdist pti (strcat "\nEspesura da parede <" (rtos #ESPCP 2 2) ">: ")) )
              (if esp (setq #ESPCP esp))
            ) ; end progn
          ) ; end case
          ( (= ptf "Conectar")
            (progn
              (initget 1 "Primeiro")
              (while (null (setq ss (entsel "\nSelecione uma parede (ou P para primeiro ponto): ")) )
                (prompt "\nERR: Resposta nula nao e valida.") )
              (if (= ss "Primeiro")
                (progn
                  (while (null (setq enmf (car (entsel "\nSelecione uma parede: "))) )
                    (prompt "\nERR: Resposta nula nao e valida.") )
                  (initget 1)
                  (setq ptf (getpoint pti "\nInforme o ponto de contato: "))
                ) ; end progn
                (progn
                  (setq enmf (car ss))
                  (setq ptf (cadr ss))
                ) ; end progn
              ) ; end if
              (setq ls2 (parede_desenha pti ptf dir))
              (parede_une (car ls1) (car ls2))
              (parede_une (cadr ls1) (cadr ls2))
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
              (setq ls2 (parede_desenha pti ptf dir))
              (parede_une (car ls1) (car ls2))
              (parede_une (cadr ls1) (cadr ls2))
              (parede_une (car ls2) (car ls))
              (parede_une (cadr ls2) (cadr ls))
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
          ( 't
            (progn
              (setq ls2 (parede_desenha pti ptf dir))
              (parede_une (car ls1) (car ls2))
              (parede_une (cadr ls1) (cadr ls2))
              (setq
                ptls  (cons ptf ptls)
                enmls (cons ls2 enmls)
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

  (if enmf (parede_conecta (car ls1) (cadr ls1) enmf 1))    ;; 1=conecta extremidade final
;;  (command ".undo" "e")

  (m:restorevars)
) ; end defun

(princ)
