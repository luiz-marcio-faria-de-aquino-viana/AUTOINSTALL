
;;
;; K01C0.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 5/13/2000
;;

;; definicao das variaveis globais
(setq #COLDIA 100.0)       ;; valor padrao para o diametro da coluna

;; c:ccd(): rotina que desenha uma coluna fornecendo centro e diametro
(defun c:ccd(/ p1 d)
  (setq oldech (ai_svar "cmdecho" 0))

  (initget 1)
  (setq p1 (getpoint "\nPonto de insercao: "))

  (initget 6)
  (setq d (getdist (strcat "\nDiametro da coluna <" (rtos #COLDIA 2) ">: ")) )
  (if d (setq #COLDIA d))

  (command ".circle" p1 (/ (/ #COLDIA 2.0) (#UND)))

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;; c:c2td(): rotina que desenha uma coluna de esgoto tangente a duas retas
(defun c:c2td(/ p1 p2 d)
  (setq oldech (ai_svar "cmdecho" 0))

  (initget 1)
  (setq p1 (entsel "\nPrimeira reta tangente: "))

  (initget 2)
  (setq p2 (entsel "\nSegunda reta tangente: "))

  (initget 6)
  (setq d (getdist (strcat "\nDiametro da coluna <" (rtos #COLDIA 2) ">: ")) )
  (if d (setq #COLDIA d))

  (command ".circle" "ttr" p1 p2 (/ (/ #COLDIA 2.0) (#UND)))

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;; c:c2p(): rotina que desenha colunas de esgoto por dois pontos
(defun c:c2p(/ p1 p2 d p3 p4 p5 p6 a1 a2 a3 x1 y1 x2 y2 x3 y3)
  (setvar "cmdecho" 0)

  (initget 1)
  (setq p1 (getpoint "\nPonto de contato: "))
  (setq p1 (osnap p1 "near"))

  (initget 1)
  (setq p2 (getpoint "\nIndique o sentido: "))

  (initget 6)
  (setq d (getdist (strcat "\nDiametro da coluna <" (rtos #COLDIA 2) ">: ")) )
  (if d (setq #COLDIA d))

  (setq
    a2 (/ #COLDIA (#UND))
    p3 (osnap p1 "end")
    a1 (angle p3 p1)
    x2 (car p2)
    y2 (cadr p2)
  ) ; end setq

  (if (= (cos a1) 0)
    (setq p4 (list (+ (car p1) (- (car p1) x1)) y1))
    (setq p4 (list (+ x2 (* y2 (/ (sin a1) (cos a1)))) 0.0))
  ) ; end if

  (setq
    p5 (inters p1 p3 p2 p4 nil)
    a3 (distance p2 p5)
    x1 (car p1)
    x3 (car p5)
    y1 (cadr p1)
    y3 (cadr p5)
    p6 (list (+ x1 (* (/ a2 a3) (- x2 x3))) (+ y1 (* (/ a2 a3) (- y2 y3))) )
  ) ; end setq

  (command "circle" "2p" p1 p6)

  (princ)
) ; end defun

(princ)
