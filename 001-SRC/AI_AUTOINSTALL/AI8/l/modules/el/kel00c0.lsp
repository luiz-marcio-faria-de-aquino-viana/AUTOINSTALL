
;;
;; KEL00C0.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 7/21/2000

;; c:ai_el_insertmega(): rotina para insercao dos blocos da mega
(defun c:ai_el_insertmega(/ FATORIG oldech blk pti)
  (m:savevars)

  (setq FATORIG (/ 25.0 1000.0))

  (if (or (null #BLCK) (= #BLCK ""))
    (progn
      (initget 1)
      (setq blk (getstring "\nNome do bloco: "))
    ) ;end progn
    (setq blk (getstring (strcat "\nNome do bloco <" #BLCK ">: ")) )
  ) ; end if
  (if (/= blk "") (setq #BLCK blk))

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (ai_insert (V:AID #BLCK) pti (/ (#SCL) FATORIG) 0.0)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
