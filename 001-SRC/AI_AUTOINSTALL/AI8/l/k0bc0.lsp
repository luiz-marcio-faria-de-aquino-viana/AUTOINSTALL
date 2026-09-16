
;;
;; K0BC0.lsp
;; Copyright (C) 1992-2000 by Luiz Marcio F A Viana, 11/9/2000

;; c:inserir(): rotina que insere um bloco no desenho convertendo a unidade
(defun c:inserir(/ blck pti rot)
  (m:savevars)

  (if (or (null #BLCK) (= #BLCK "") )
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

  (ai_insertpt (V:AID #BLCK) pti (/ 1.0 (#UND)) rot)

  (m:restorevars)
  (princ)
) ; end defun

;; c:inserirsimb(): rotina que insere um bloco no desenho usando o fator de escala
(defun c:inserirsimb(/ blck pti rot)
  (m:savevars)

  (if (or (null #BLCK) (= #BLCK "") )
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

  (m:restorevars)
  (princ)
) ; end defun

(princ)
