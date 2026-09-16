
;;
;; K84C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 2/9/98
;;

;; definicao das variaveis globais
(or #DIST1 (setq #DIST1 (/ 1000.0 (#UND))) )
(or #DIST2 (setq #DIST2 (/ 1000.0 (#UND))) )

;; boneca_linha(): funcao que constroi bonecas a partir de duas linhas
(defun boneca_linha(ss1 ss2 ptx / oldblip oldhigh enm1 enm2 enm1a enm2a pt1 pt2 ent1 ent2 pt1i pt1f pt2i pt2f pt3i pt3f pt4i pt4f typ1 typ2 v1a v2a v1b v2b u1a u2a pt1x pt2x n1x n2x pto pt1o pt2o)

  (setq
    enm1 (car ss1)
    pt1 (cadr ss1)
  ) ; end setq

  (setq
    enm2 (car ss2)
    pt2 (cadr ss2)
  ) ; end setq

  (setq ent1 (entget enm1))
  (if (= (setq typ1 (enttype enm1)) "LINE")
    (setq
      pt1i (cdr (assoc 10 ent1))
      pt1f (cdr (assoc 11 ent1))
    ) ; end setq
    (setq
      pt1i (cdr (assoc 10 ent1))
      pt1f (cdr (assoc 10 (entget (entnext enm1))) )
    ) ; end setq
  ) ; end if

  (setq ent2 (entget enm2))
  (if (= (setq typ2 (enttype enm2)) "LINE")
    (setq
      pt2i (cdr (assoc 10 ent2))
      pt2f (cdr (assoc 11 ent2))
    ) ; end setq
    (setq
      pt2i (cdr (assoc 10 ent2))
      pt2f (cdr (assoc 10 (entget (entnext enm2))) )
    ) ; end setq
  ) ; end if

  ;; calcula pontos iniciais e finais da reta paralela a primeira selecao
  (setq
    v1a (mapcar '- pt1f pt1i)
    v1b (mapcar '- ptx  pt1i)
  ) ; end setq
  (setq u1a (vtunit v1a))
  (setq pt1x (mapcar '+ pt1i (vtmul (vtprod v1b u1a) u1a)) )
  (setq n1x (vtunit (mapcar '- ptx pt1x)) )      ;; direcao normal a reta selecionada

  ;; pontos iniciais e finais da nova reta criada
  (setq
    pt3i (mapcar '+ pt1i (vtmul #DIST1 n1x))
    pt3f (mapcar '+ pt1f (vtmul #DIST1 n1x))
  ) ; end setq

  ;; calcula pontos iniciais e finais da reta paralela a segunda selecao
  (setq
    v2a (mapcar '- pt2f pt2i)
    v2b (mapcar '- ptx  pt2i)
  ) ; end setq
  (setq u2a (vtunit v2a))
  (setq pt2x (mapcar '+ pt2i (vtmul (vtprod v2b u2a) u2a)) )
  (setq n2x (vtunit (mapcar '- ptx pt2x)) )      ;; direcao normal a reta selecionada

  ;; pontos iniciais e finais da nova reta criada
  (setq
    pt4i (mapcar '+ pt2i (vtmul #DIST2 n2x))
    pt4f (mapcar '+ pt2f (vtmul #DIST2 n2x))
  ) ; end setq

  ;; ponto de intersecao entre as retas selecionadas e as que formarao a boneca
  (if (setq pto (inters pt3i pt3f pt4i pt4f nil))    ;; ponto de insercao das retas que formarao a boneca
    (progn
      (setq
        pt1o (inters pt1i pt1f pt4i pt4f nil)
        pt2o (inters pt2i pt2f pt3i pt3f nil)
      ) ; end setq

      (command ".undo" "g")

      (setq oldblip (acadvar "blipmode" 0))
      (setq oldhigh (acadvar "highlight" 0))

      (command ".line" pt1o pto "")
      (setq enm1a (entlast))
      (command ".line" pt2o pto "")
      (setq enm2a (entlast))
      (if (= (getvar "trimmode") 1)
        (command ".trim" enm1a enm2a "" pt1 pt2 "")
      ) ; end if

      (setvar "blipmode" oldblip)
      (setvar "highlight" oldhigh)

      (command ".undo" "e")
    ) ; end progn
    (prompt "\nERR: Entidades selecionadas sao paralelas ou coincidentes.")
  ) ; end if

) ; end defun

;; c:boneca(): rotina que permite a construcao de bonecas
(defun c:boneca(/ oldech ss1 ss2 ptx dist1 dist2)
  (setq oldech (acadvar "cmdecho" 0))

  (if (= (getvar "trimmode") 1)
    (prompt (strcat "\n(TRIM mode) Dimensoes corrente da boneca: Dist1 = " (rtos #DIST1 2 2) ", Dist2 = " (rtos #DIST2 2 2)) )
    (prompt (strcat "\n(NOTRIM mode) Dimensoes corrente da boneca: Dist1 = " (rtos #DIST1 2 2) ", Dist2 = " (rtos #DIST2 2 2)) )
  ) ; end if

  (initget "Distancia Trim")
  (setq ss1 (nentsel "\nDistancia/Trim mode/<Selecione primeira linha>: "))

  (cond
    ( (= ss1 "Distancia")
      (progn
        (initget 6)
        (setq dist1 (getdist (strcat "\nDistancia da primeira linha <" (rtos #DIST1 2 2) ">: ")) )
        (if dist1 (setq #DIST1 dist1))
        (initget 6)
        (setq dist2 (getdist (strcat "\nDistancia da segunda linha <" (rtos #DIST2 2 2) ">: ")) )
        (if dist2 (setq #DIST2 dist2))
      ) ; end progn
    ) ; end case
    ( (= ss1 "Trim")
      (setvar "trimmode" (- 1 (getvar "trimmode")) )
    ) ; end case
    ( (or (= (enttype (car ss1)) "LINE") (= (enttype (car ss1)) "VERTEX") )
      (progn
        (setq ss2 (nentsel "\nSelecione segunda linha: "))
        (if (or (= (enttype (car ss2)) "LINE") (= (enttype (car ss2)) "VERTEX") )
          (progn
            (initget 1)
            (setq ptx (getpoint "\nSentido de construcao: "))
            (boneca_linha ss1 ss2 ptx)
          ) ; end progn
          (prompt "\nERR: Entidade selecionada nao e linha nem polilinha.")
        ) ; end if
      ) ; end progn
    ) ; end case
    ( 't (prompt "\nERR: Entidade selecionada nao e linha nem polilinha."))
  ) ; end cond

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
