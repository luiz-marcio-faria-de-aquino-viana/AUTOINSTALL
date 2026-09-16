
;;
;; K0DC0.lsp
;; Copyright (C) 1992-2000 by Luiz Marcio F A Viana, 11/9/2000
;;

;; c:insert3(): rotina que insere blocos de vistas e detalhes no desenho
(defun c:insert3(/ blck pti rot)
  (setvar "cmdecho" 0)

  (if (or (null #BLCK) (= #BLCK ""))
    (progn
      (initget 1)
      (setq blck (getstring "\nNome do bloco: "))
    ) ; end progn
    (setq blck (getstring (strcat "\nNome do bloco <" #BLCK ">: ")) )
  ) ; end if
  (if (/= blck "") (setq #BLCK blck))

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (setq rot (getpoint pti "\nRotacao <0>: "))
  (if (null rot) (setq rot 0.0))

  (ai_insertpt (V:AID #BLCK) pti (#SCL) rot)

  (princ)
) ; end defun

(princ)
