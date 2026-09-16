
;;
;; K97C0.lsp
;; Copyright (C) 2000 by Igor Romero Tavares, 7/19/2000
;;

;; c:ai_ellipse(): rotina que desenha uma elipse fornecendo a largura e metade altura
(defun c:ai_ellipse(/ oldech p1 p2 p0 p3 d v m u n p01 p02)

  (initget 1)
  (setq p1 (getpoint "\nPrimeiro Ponto: "))

  (initget 1)
  (setq p2 (getpoint p1 "\nSegundo Ponto: "))

  (setq p0 (mapcar '/ (mapcar '+ p1 p2) '(2 2 2)))
  (setq p3 (getpoint p0 "\nTerceiro Ponto: "))

  (setq d (distance p0 p3))

  (setq
    v (mapcar '- p2 p1)
    m (sqrt (+ (* (car v) (car v)) (* (cadr v) (cadr v)) (* (caddr v) (caddr v))))
    u (mapcar '/ v (list m m m))
  ) ; end setq

  (setq n (list (-(cadr u)) (car u ) (caddr u)))

  (setq
    p01 (mapcar '+ p0 (mapcar '* n (list d d d)))
    p02 (mapcar '+ p0 (mapcar '* n (list (- d) (- d) (- d))))
  ) ; end setq

  (setq oldech (ai_svar "cmdecho" 0))

  (command ".undo" "g")
  (command
    ".pline" p01 p1 p02 p2 "c"
    ".pedit" (entlast) "f" ""
  ) ; end command
  (command ".undo" "e")

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
