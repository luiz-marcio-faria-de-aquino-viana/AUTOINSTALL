
;;
;; K64C0.lsp
;;
;; Copyright (C) 1996 by Paulo Lincoln de Oliveira, 5/13/96
;;

;; mvertex: funcao que movimenta o vertice de uma pline
;;   vertx - ename do vertice correspondente
;;   pt    - ponto para onde o vertice se deslocara
(defun mvertex (vertx pt / ent)
  (setq ent (entget vertx))
  (entmod (subst (cons 10 pt) (assoc 10 ent) ent))
  (entupd vertx)
) ; end defun

;; brkpline: funcao para quebrar polilinhas em segmentos de polilinhas
;;   enm1  - ename da entidade a ser quebrada
(defun brkpline (enm1 / enm2 enm3 ent1 ent2 ent3 ls)
  (setq ent1 (entget enm1))
  (setq ls  '())
  (setq enm2 (entnext enm1))
  (while (and enm2 (/= (cdr (assoc 0 (setq ent2 (entget enm2)))) "SEQEND"))
    (setq enm3 (entnext enm2))
    (setq ent3 (entget  enm3))
    (if (/= (cdr (assoc 0 ent3)) "SEQEND")
      (progn
        (entmake (cdr ent1))
        (entmake (cdr ent2))
        (entmake (cdr ent3))
        (entmake '((0 . "SEQEND")))
        (setq ls (append ls (list (ssname (ssget "l") 0))))
      ) ; end progn
    ) ; end if
    (setq enm2 enm3)
  ) ; end while
  (command ".erase" enm1 "")
  (foreach enm ls (redraw enm 1))
) ; end defun

;; joinpline: funcao para unir polilinhas
;;   ss1 - lista com ename e ponto de selecao da primeira entidade
;;   ss2 - lista com ename e ponto de selecao da segunda entidade
(defun joinpline (ss1 ss2 / enm1 enm2 p1i p1f p2i p2f pts1 pts2 pt pti ptf)
  (setq
    enm1 (car  ss1)
    pts1 (trans (cadr ss1) 1 0)
  ) ; end setq
  (setq
    enm2 (car  ss2)
    pts2 (trans (cadr ss2) 1 0)
  ) ; end setq
 
  (setq
    p1i (cdr (assoc 10 (entget (entnext enm1))))
    p1f (cdr (assoc 10 (entget (entnext (entnext enm1)))))
    p2i (cdr (assoc 10 (entget (entnext enm2))))
    p2f (cdr (assoc 10 (entget (entnext (entnext enm2)))))
  ) ; end setq 

  (if (setq pt (inters p1i p1f p2i p2f nil))
    (progn
      (setq ppt (vtprod (mapcar '- pt p1i) (mapcar '- p1f p1i)) )
      (setq ppts (vtprod (mapcar '- ptS1 p1i) (mapcar '- p1f p1i)) )

      (if (or (< ppt 0) (< ppt ppts))
        (mvertex (entnext enm1) pt)
        (mvertex (entnext (entnext enm1)) pt)
      ) ; end if

      (setq ppt (vtprod (mapcar '- pt p2i) (mapcar '- p2f p2i)) )
      (setq ppts (vtprod (mapcar '- ptS2 p2i) (mapcar '- p2f p2i)) )

      (if (or (< ppt 0) (< ppt ppts))
        (mvertex (entnext enm2) pt)
        (mvertex (entnext (entnext enm2)) pt)
      ) ; end if
    ) ; end progn

    (if (inters p1i p1f p1i p2i nil)
      (prompt "\nERR: As linhas selecionadas sao paralelas.")
      (progn
        (if (> (distance p1i p2i) (distance p1f p2i))
          (setq pti p1i)
          (setq pti p1f)
        ) ; end if
        (if (> (distance p2i p1i) (distance p2f p1i))
          (setq ptf p2i)
          (setq ptf p2f)
        ) ; end if

        (command ".erase" enm2 "")

        (mvertex (entnext enm1) pti)
        (mvertex (entnext (entnext enm1)) ptf)
      );end progn
    );end if
  );end if
); end defun

;; pltopl: comando para unir polilinhas
;;   ss1 - lista contendo ename e ponto de selecao para a primeira entidade
;;   ss2 - lista contendo ename e ponto de selecao para a segunda entidade
(defun pltopl (ss1 ss2 / selc1 selc2)
  (if (and ss1 ss2)
    (if (and (= (cdr (assoc 0 (entget (car ss1)))) "POLYLINE")
             (= (cdr (assoc 0 (entget (car ss2)))) "POLYLINE") )
      (progn
        (if (eq (car ss1) (car ss2))
          (brkpline (car ss1))
          (progn
            (brkpline (car ss1))
            (brkpline (car ss2))
          ) ; end progn
        ) ; end if
        (if (and (setq selc1 (ssget (cadr ss1)))
                 (setq selc2 (ssget (cadr ss2))) )
          (joinpline (list (ssname selc1 0) (cadr ss1))
                     (list (ssname selc2 0) (cadr ss2)) )
        ) ; end if
      ) ; end progn
    ) ; end if
  ) ; end if
) ; end defun

;; lntoln: rotina para unir duas linhas
;;   ss1 - lista contendo ename e ponto de selecao para a primeira entidade
;;   ss2 - lista contendo ename e ponto de selecao para a segunda entidade
(defun lntoln (ss1 ss2 / oldlay ent1 ent2 pti1 ptf1 pti2 ptf2 pti ptf)
  (setq ent1 (entget (car ss1)))
  (setq ent2 (entget (car ss2)))
  (setq
    pti1 (cdr (assoc 10 ent1))
    ptf1 (cdr (assoc 11 ent1))
  ) ; endsetq
  (setq
    pti2 (cdr (assoc 10 ent2))
    ptf2 (cdr (assoc 11 ent2))
  ) ; end setq
  (if (inters pti1 ptf1 pti2 ptf2 nil)
    (command ".fillet" "r" 0 ".fillet" ss1 ss2)
    (if (inters pti1 ptf1 pti1 pti2 nil)
      (prompt "\nERR: As linhas selecionadas sao paralelas.")
        (progn
          (if (> (distance pti1 pti2) (distance ptf1 pti2))
            (setq pti pti1)
            (setq pti ptf1)
          ) ; end if
          (if (> (distance pti2 pti1) (distance ptf2 pti1))
            (setq ptf pti2)
            (setq ptf ptf2)
          ) ; end if
          (setq oldlay (getvar "clayer"))
          (setq cnivel (cdr (assoc 8 ent1))) 
          (command
            ".erase" (car ss1) (car ss2) ""
            ".layer" "s" cnivel ""
            ".line" pti ptf ""
            ".layer" "s" oldlay ""
          ) ; end command
        );end progn
      ) ; end if
    ) ; end if
) ; end defun

;; lntopl: rotina para unir linha e polilinha
;;   lin - lista contendo entidade linha selecionada e ponto de selecao
;;   pol - lista contendo entidade polilinha selecionada e ponto de selecao
(defun lntopl (lin pol / enm1 enm2 pts1 pts2 selc p1i p1f p2i p2f pt)
  (brkpline (car pol))
  (if (setq selc (ssget (cadr pol)))
    (progn
      (setq enm1 (ssname selc 0))
      (setq
        pts1 (cadr pol)
        enm2 (car  lin)
        pts2 (cadr lin)
      ) ; end setq
      (setq
        p1i (cdr (assoc 10 (entget (entnext enm1))))
        p1f (cdr (assoc 10 (entget (entnext (entnext enm1)))))
      ) ; end setq
      (setq ent2 (entget enm2))
      (setq
        p2i (cdr (assoc 10 ent2))
        p2f (cdr (assoc 11 ent2))
      ) ; end setq 
      (if (setq pt (inters p1i p1f p2i p2f nil))
        (progn
          (setq ppt (vtprod (mapcar '- pt p1i) (mapcar '- p1f p1i)) )
          (setq ppts (vtprod (mapcar '- ptS1 p1i) (mapcar '- p1f p1i)) )

          (if (or (< ppt 0) (< ppt ppts) )
            (mvertex (entnext enm1) pt)
            (mvertex (entnext (entnext enm1)) pt)
          ) ; end if

          (setq ppt (vtprod (mapcar '- pt p2i) (mapcar '- p2f p2i)) )
          (setq ppts (vtprod (mapcar '- ptS2 p2i) (mapcar '- p2f p2i)) )

          (if (or (< ppt 0) (< ppt ppts) )
            (setq ent2 (subst (cons 10 pt) (assoc 10 ent2) ent2))
            (setq ent2 (subst (cons 11 pt) (assoc 11 ent2) ent2))
          ) ; end if

          (entmod ent2)
        ) ; end progn

        (if (inters p1i p1f p1i p2i nil)
          (prompt "\nERR: As linhas selecionadas sao paralelas.")
          (progn
            (if (> (distance p1i p2i) (distance p1f p2i))
              (setq pti p1i)
              (setq pti p1f)
            ) ; end if
            (if (> (distance p2i p1i) (distance p2f p1i))
              (setq ptf p2i)
              (setq ptf p2f)
            ) ; end if
            (command ".erase" enm2 "")
            (mvertex (entnext enm1) pti)
            (mvertex (entnext (entnext enm1)) ptf)
          ) ; end progn
        ) ; end if
      ) ; end if
    ) ; end progn
  );end if
);end defun

;; uniline: selecao das entidades e uniao atraves do uniline/unipline
(defun c:uniline (/ oldico oldech ss1 ss2)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (command ".undo" "g")

  (setq ss1 (entsel "\nSelecione um segmento: "))
  (setq ss2 (entsel "\nSelecione outro segmento: "))
  
  (if (and (= (cdr (assoc 0 (entget (car ss1)))) "POLYLINE")  (= (cdr (assoc 0 (entget (car ss2)))) "POLYLINE"))
    (pltopl ss1 ss2)
    (if (and (= (cdr (assoc 0 (entget (car ss1)))) "LINE")  (= (cdr (assoc 0 (entget (car ss2)))) "LINE"))
      (lntoln ss1 ss2)
      (if (and (= (cdr (assoc 0 (entget (car ss1)))) "LINE")  (= (cdr (assoc 0 (entget (car ss2)))) "POLYLINE"))
        (lntopl ss1 ss2)
        (if (and (= (cdr (assoc 0 (entget (car ss1)))) "POLYLINE") (= (cdr (assoc 0 (entget (car ss2)))) "LINE"))
          (lntopl ss2 ss1)
          (prompt "\nERR: Selecione linhas ou polilinhas para efetuar a uniao dos segmentos.")
        ) ; end if 
      ) ;end if
    ) ; end if
  ) ; end if

  (command ".undo" "e")

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
