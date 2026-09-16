
;;
;; K63C0.lsp
;;
;; Copyright (C) 1996 by Paulo Lincoln de Oliveira, 5/13/96
;;

;; mvertex: funcao que movimenta o vertice de uma pline
;;   vertx - ename do vertice correspondente
;;   pt    - ponto para onde o vertice se deslocara
(defun mvertex(vertx pt)
  (setq ent (entget vertx))
  (entmod (subst (cons 10 pt) (assoc 10 ent) ent))
  (entupd vertx)
) ; end defun

;; brkpline: funcao para quebrar polilinhas em segmentos de polilinhas
;;   enm1  - ename da entidade a ser quebrada
(defun brkpline (enm1 / enm2 enm3 ent2 ent3)
  (setq ent1 (entget enm1))

  (setq ls  '())
  (setq enm2 (entnext enm1))
  (while (and enm2 (/= (cdr (assoc 0 (setq ent2 (entget enm2)))) "SEQEND"))
    (setq enm3 (entnext enm2))
    (setq ent3 (entget  enm3))
    (if (/= (cdr (assoc 0 ent3)) "SEQEND")
      (progn
        (entmake ent1)
        (entmake ent2)
        (entmake ent3)
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
(defun joinpline (ss1 ss2)
  (setq
    enm1 (car  ss1)
    pts1 (cadr ss1)
  ) ; end setq
  (setq
    enm2 (car  ss2)
    pts2 (cadr ss2)
  ) ; end setq
  (setq
    p1i (cdr (assoc 10 (entget (entnext           enm1) )))
    p1f (cdr (assoc 10 (entget (entnext (entnext enm1)) )))
    p2i (cdr (assoc 10 (entget (entnext           enm2) )))
    p2f (cdr (assoc 10 (entget (entnext (entnext enm2)) )))
  ) ; end setq 
  (if (setq pt (inters p1i p1f p2i p2f nil))
    (progn
      (if (< (distance p1i pt) (distance p1i pts1))
        (mvertex (entnext           enm1) pt)
        (if (< (distance p1i pt) (distance p1f pt))
          (mvertex (entnext           enm1) pt)
          (mvertex (entnext (entnext enm1)) pt)
        ) ; end if
      ) ; end if
      (if (< (distance p2i pt) (distance p2i pts2))
        (mvertex (entnext           enm2) pt)
        (if (< (distance p2i pt) (distance p2f pt))
          (mvertex (entnext           enm2) pt)
          (mvertex (entnext (entnext enm2)) pt)
        ) ; end if
      ) ; end if
    ) ; end progn
    (if (inters p1i p1f p1i p2i nil)
      (prompt "\n* ERROR * As linhas selecionadas sao paralelas.")
      (progn
        (if (> (distance p1i p2i) (distance p1f p2i))
          (setq pti p1i)
          (setq pti p1f)
        );end if
        (if (> (distance p2i p1i) (distance p2f p1i))
          (setq ptf p2i)
          (setq ptf p2f)
        );end if
        (command ".erase" enm2 "")
        (mvertex (entnext           enm1) pti)
        (mvertex (entnext (entnext enm1)) ptf)
      );end progn
    );end if
  );end if
); end defun

;; unipline: comando para unir polilinhas
(defun c:unipline(/ ss1 ss2 selc1 selc2)
  (m:savevars)
  (setq ss1 (entsel "\nSelecione um segmento de polilinha: "))
  (setq ss2 (entsel "\nSelecione outro segmento de polilinha: "))
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
  (m:restorevars)
  (princ)
) ; end defun

(princ)
