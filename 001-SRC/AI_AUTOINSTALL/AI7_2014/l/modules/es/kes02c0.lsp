
;;
;; KES02C0.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 1/6/2000
;;

;; ai_es_rs45(): funcao para obtencao do ponto de entrada no ralo sifonado a 45d
(defun ai_es_rs45(/ pt1 pt2 pt3 pt4 pt0 v31 u32 d)

  (setq pt1 (getvar "lastpoint"))

  (initget 1)
  (setq pt2 (getpoint pt1 "\nSelecione uma entrada no ralo sifonado ou coluna: "))

  (setq pt3 (osnap pt2 "cen"))

  (setq
    v31 (mapcar '- pt1 pt3)
    u32 (vtunit (mapcar '- pt2 pt3))
  ) ; end setq

  (setq pt4 (mapcar '+ pt3 (vtmul (vtprod v31 u32) u32)) )

  (setq d (distance pt1 pt4))

  (setq pt0 (mapcar '+ pt4 (vtmul (- d) u32)) )

  pt0
) ; end defun

;; ai_es_rs90(): funcao para obtencao do ponto de entrada no ralo sifonado a 90d
(defun ai_es_rs90(/ pt1 pt2 pt3 pt0 v31 u32 d)

  (setq pt1 (getvar "lastpoint"))

  (initget 1)
  (setq pt2 (getpoint pt1 "\nSelecione uma entrada no ralo sifonado ou coluna: "))

  (setq pt3 (osnap pt2 "cen"))

  (setq
    v13 (mapcar '- pt1 pt3)
    u23 (vtunit (mapcar '- pt2 pt3))
  ) ; end setq

  (setq d (vtprod v13 u23))

  (setq pt0 (mapcar '+ pt3 (vtmul d u23)))

  pt0
) ; end defun
