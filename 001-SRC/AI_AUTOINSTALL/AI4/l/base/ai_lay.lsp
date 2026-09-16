
;;
;; AI_LAY.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 7/30/2000
;;

;; ai_slay(): funcao que ativa uma camada e retorna a anterior
;; lay - nome da camada que se tornara corrente
;; flg - indicador para criar camada caso nao exista no desenho
(defun ai_slay(lay flg / olay)
  (setq olay (getvat "clayer"))
  (if (tblsearch "layer" lay)
    (command ".layer" "t" lay "s" lay "")
    (if flg (command ".layer" "m" lay ""))
  ) ; end if
  olay
) ; end defun

;; ai_offlay(): funcao que desliga uma camada retornando a nova camada corrente
(defun ai_offlay(lay)
  (if (= (getvar "clayer") (strcase lay))
    (command ".layer" "s" "0" "off" lay "")
    (command ".layer" "off" lay "")
  ) ; end if
  (getvar "clayer")
) ; end defun

(princ)
