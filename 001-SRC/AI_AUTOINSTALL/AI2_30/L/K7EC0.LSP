
;;
;; K7EC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 8/26/97
;;

;; carrega funcoes externas necessarias a rotina
(loadf"k6bc0")

;; EChDt_GetObject(): funcao que retorna um objeto eletrico selecionado
;;  msg - mensagem a ser apresentada ao usuario
(defun EChDt_GetObject(msg / flg enm)
  (setq flg 't)
  (while flg
    (if (setq enm (car (entsel msg)))
      (if (etipo enm 0)
        (setq flg nil)
        (prompt "\nERR: Objeto selecionado nao e um ponto eletrico.")
      ) ; end if
      (prompt "\nERR: Resposta nula nao e valida.")
    ) ; end if
  ) ; end while
  enm
) ; end defun

;; C:EChDt(): rotina que modifica a informacao de origem e destino atribuida a um eletroduto
(defun C:EChDt(/ enm ent lay enm1 enm2)
  (if (setq enm (car (entsel "\nSelecione o eletroduto que sera modificado: ")))
    (progn
      (setq ent (entget enm))
      (setq lay (cdr (assoc 8 ent)))
      (if (and (= (enttype enm) "POLYLINE")
               (or (= lay "EL-DT_TETO") (= lay "EL-DT_PISO") (= lay "EL-DT_APARENTE")) )
        (progn
          (setq enm1 (EChDt_GetObject "\nSelecione o ponto origem do eletroduto: "))
          (setq enm2 (EChDt_GetObject "\nSelecione o ponto destino do eletroduto: "))
          (edt_SetObjectData enm enm1 enm2)
        ) ; end progn
        (prompt "\nERR: Objeto selecionado nao e um eletroduto.")
      ) ; end if
    ) ; end progn
    (prompt "\nERR: Nenhum eletroduto foi selecionado.")
  ) ; end if
  (princ)
) ; end defun

(princ)
