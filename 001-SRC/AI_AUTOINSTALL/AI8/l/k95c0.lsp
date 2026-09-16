
;;
;; K95C0.lsp
;; Copyright (C) 1999 by Luiz Marcio F A Viana, 7/2/99
;;

;; c:aci_echkdt(): rotina de verificacao manual da consistencia dos eletrodutos de eletrica
(defun c:aci_echkdt(/ enm hnd hnd1 hnd2 enm1 enm2)
  (m:savevars)

  (setq enm (car (entsel "Selecione o eletroduto para verificacao: ")))
  (setq hnd (cdr (assoc 5 (entget enm))) )

  (if (setq eed (eedget enm "AI230EL"))
    (progn
      (setq eed (eedcdr (eedread eed)))
      (setq
        hnd1 (cdar (eedread (eedcdr (eedcar eed))) )
        hnd2 (cdar (eedread (eedcdr (eedread (eedcdr eed)))) )
      )
      (if (setq enm1 (handent hnd1)) (redraw enm1 3))
      (if (setq enm2 (handent hnd2)) (redraw enm2 3))
      (prompt (strcat "\nEletroduto: " hnd
		      "\nOrigem: " hnd1
		      "\nDestino: " hnd2) )
      (getstring "\nTecle [ENTER] para continuar.")
      (if (setq enm1 (handent hnd1)) (redraw enm1 4))
      (if (setq enm2 (handent hnd2)) (redraw enm2 4))
    )
    (prompt "\nERR: Objeto nao possui nenhuma informacao caracteristica de eletroduto.")
  )

  (m:restorevars)
  (princ)
)

(princ)
