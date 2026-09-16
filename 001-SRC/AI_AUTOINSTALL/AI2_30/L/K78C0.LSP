
;;
;; K78C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 3/12/97
;;

;; hinsert: rotina para insercao de blocos com altura determinada
(defun c:hinsert()
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

  (setq oldech (acadvar "cmdecho" 0))
  (if (findfile (strcat (v:aid #BLCK) ".dwg"))
    (command ".insert" (v:aid #BLCK) "s" (/ 1.0 #UND) ".z" (list 0.0 0.0 #HBLK) )
    (prompt "\nERR: Arquivo nao encontrado.")
  ) ; end if
  (setvar "cmdecho" oldech)

  (princ)
) ; end defun

(princ)
