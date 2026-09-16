
;;
;; K76C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 8/22/97
;;

;; c:everdt(): rotina que muda a camada de todos os eletrodutos que nao possuem dados associados
(defun c:everdt(/ SELCOLOR TABLAY ss cnt enm lay tab nlay nltp)
  (setq oldech (acadvar "cmdecho" 0))

  (setq SELCOLOR "1")  ;; define a cor aplicada a camada destino dos objetos encontrados

  (setq TABLAY '("EL-DT_TETO" "EL-DT_PISO" "EL-DT_APARENTE"))

  (prompt "\nSelecionando os eletrodutos...")

  (foreach lay TABLAY
    (if (setq ss (ssget "x" (list '(0 . "POLYLINE") (cons 8 lay))))
      (progn
        (setq
          cnt (sslength ss)
          nlay (strcat "ERR$" lay)
          nltp (cdr (assoc  6 (tblsearch "layer" lay)))
        ) ; end setq
        (prompt (strcat "\nProcessando " (itoa cnt) " objetos da camada " lay "... "))
        (while (>= (setq cnt (1- cnt)) 0)
          (setq enm (ssname ss cnt))
          (if (null (eedget enm "AI230EL"))
            (progn
              (if (null (tblsearch "layer" nlay)) (command ".layer" "n" nlay "c" SELCOLOR nlay "lt" nltp nlay ""))
              (command ".change" enm "" "p" "la" nlay "")
            ) ; end progn
          ) ; end if
          (if (zerop (rem cnt 10)) (prompt "."))
        ) ; end while
      ) ; end progn
      (prompt (strcat "\nERR: Nao existe nenhum objeto eletroduto na camada (=" lay ")."))
    ) ; end if
  ) ; end foreach

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;; c:erestdt(): rotina que muda a camada de todos os eletrodutos que nao possuem dados associados
(defun c:erestdt(/ ss1 ss2 ss3)
  (if (setq ss1 (ssget "x" '((8 . "ERR$EL-DT_TETO"))) )     (command ".change" ss1 "" "p" "la" "EL-DT_TETO" ""))
  (if (setq ss2 (ssget "x" '((8 . "ERR$EL-DT_PISO"))) )     (command ".change" ss2 "" "p" "la" "EL-DT_PISO" ""))
  (if (setq ss3 (ssget "x" '((8 . "ERR$EL-DT_APARENTE"))) ) (command ".chnage" ss3 "" "p" "la" "EL-DT_APARENTE" ""))
  (princ)
) ; end defun

(princ)
