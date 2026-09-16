
;;
;; K0CC0.lsp
;; Copyright (C) 1992-2000 by Luiz Marcio F A Viana, 11/9/2000
;;

;; c:insert2(): rotina que insere um bloco fornecendo um ponto base e deslocamento
(defun c:insert2(/ blck ptini ptbase rot)
  (m:savevars)

  (if (or (null #BLCK) (= #blck ""))
    (progn
      (initget 1)
      (setq blck (getstring "\nNome do bloco: "))
    ) ; end progn
    (setq blck (getstring (strcat "\nNome do bloco <" #BLCK ">: ")))
  ) ; end if
  (if (/= blck "") (setq #BLCK blck))

  (initget 1)
  (setq
    ptbase (getpoint "\nPrimeiro ponto: ")
    ptini (getpoint ptbase "\nSegundo ponto (ou ENTER): ")
  ) ; end setq

  (if (null ptini)
    (setq ptini ptbase)
    (setq ptini (mapcar '/ (mapcar '+ ptini ptbase) '(2.0 2.0)))
  ) ; end if

  (setq rot (getpoint ptini "\nRotacao <0>: "))
  (if (null rot) (setq rot 0.0))

  (ai_insertpt (V:AID #BLCK) pti (/ 1.0 (#UND)) rot)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
