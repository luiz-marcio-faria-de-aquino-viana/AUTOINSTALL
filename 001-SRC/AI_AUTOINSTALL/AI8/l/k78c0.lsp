
;;
;; K78C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 3/12/97
;;

;; hinsert: rotina para insercao de blocos com altura determinada
(defun c:hinsert()
  (m:savevars)
  (if (null #BLCK)
    (while (= (setq blk (getstring "Nome do bloco: ")) "")
      (prompt "\nERR: Resposta nula nao e valida.") )
    (setq blk (getstring (strcat "Nome do bloco <" #BLCK ">: ")))
  ) ; end if
  (if (/= blk "") (setq #BLCK (strcase blk)) )

  (if (null #HBLK)
    (progn
      (initget 1)
      (setq alt (getdist "\nAltura em relacao ao piso: "))
    ) ; end progn
    (setq alt (getdist (strcat "\nAltura em relacao ao piso <" (rtos #HBLK 2 2) ">: ")) )
  ) ; end if
  (if alt (setq #HBLK alt))

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (setq pt0 (list (car pti) (cadr pti) #HBLK))

  (setq rot (getangle pti "\nRotacao <0>: "))
  (if (null rot) (setq rot 0.0))

  (setq oldech (acadvar "cmdecho" 0))
  (ai_insert (v:aid #BLCK) pt0 (/ 1.0 (#UND)) rot)
  (setvar "cmdecho" oldech)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
