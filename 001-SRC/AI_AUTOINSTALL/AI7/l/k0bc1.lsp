
;;
;; K0BC0.lsp
;; Copyright (C) 1992-2000 by Luiz Marcio F A Viana, 11/9/2000

;; c:inserir(): rotina que insere um bloco no desenho convertendo a unidade
(defun C:INSERIR(/ blck)
  (setvar "cmdecho" 0)

  (if (or (null #BLCK) (= #BLCK "") )
    (progn
      (initget 1)
      (setq blck (getstring "\nNome do bloco: "))
    ) ; end progn
    (setq blck (getstring (strcat "\nNome do bloco <" #BLCK ">: ")) )
  ) ; end if
  (if (/= blck "") (setq #BLCK blck))

  (if (tblsearch "block" (getfilename #blck))
    (command ".insert" (getfilename #blck) "s" (/ 1.0 (#UND)))
    (command ".insert" (V:AID #blck) "s" (/ 1.0 (#UND)))
  ) ; end if

  (princ)
) ; end defun

(princ)
