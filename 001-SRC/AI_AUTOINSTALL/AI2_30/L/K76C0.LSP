
;;
;; K76C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 8/22/97
;;

;; C:EVerDt(): rotina que muda a camada de todos os eletrodutos que nao possuem dados associados
(defun C:EVerDt(/ SELCOLOR ss1 ss2 ss3 ss cnt enm lay tab nlay nltp)
  (setq oldech (acadvar "cmdecho" 0))

  (setq SELCOLOR "1")  ;; define a cor aplicada a camada destino dos objetos encontrados

  (prompt "\nSelecionando os eletrodutos...")

  (command ".select")
  (if (setq ss1 (ssget "x" '((0 . "POLYLINE")(8 . "EL-DT_TETO"))))     (command ss1))
  (if (setq ss2 (ssget "x" '((0 . "POLYLINE")(8 . "EL-DT_PISO"))))     (command ss2))
  (if (setq ss3 (ssget "x" '((0 . "POLYLINE")(8 . "EL-DT_APARENTE")))) (command ss3))
  (command "")

  (if (or ss1 ss2 ss3)
    (progn
      (setq ss (ssget "p"))
      (setq cnt (sslength ss))
      (prompt (strcat "\nProcessando " (itoa cnt) " objetos... "))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq enm (ssname ss cnt))
        (if (null (eedget enm "AI230EL"))
          (progn
            (setq lay (cdr (assoc 8 (entget enm))))
            (setq nlay (strcat "ERR$" lay))
            (if (null (tblsearch "layer" nlay))
              (progn
                (setq tab (tblsearch "layer" lay))
                (setq nltp (cdr (assoc  6 tab)))
                (command ".layer" "n" nlay "c" SELCOLOR nlay "lt" nltp nlay "")
              ) ; end progn
            ) ; end if
            (command ".change" enm "" "p" "la" nlay "")
          ) ; end progn
        ) ; end if
        (if (zerop (rem cnt 10)) (prompt "."))
      ) ; end while
    ) ; end progn
    (prompt "ERR: Nao existe nenhuma objeto eletroduto no desenho.")
  ) ; end if
  (acadvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
