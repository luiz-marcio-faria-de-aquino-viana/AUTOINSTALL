
;;
;; K34c0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 12/16/96
;;

;;
;; definicao das rotinas de edicao de atributos do programa de fiacao
;;

;; echorg: rotina que troca o quadro origem dos objetos selecionados
(defun c:echorg(/ oldech ss org enm cnt att idx)
  (setq oldech (acadvar "cmdecho" 0))
  (prompt "\nSelecione os objetos para modificacao do quadro de origem...")
  (if (setq ss (ssget))
    (progn
      (if (= (setq org (getstring "\nNova identificacao para o quadro de origem: ")) "")
        (progn
          (setq flg 't)
          (while flg
            (if (setq enm1 (car (entsel "Selecione o objeto de referencia: ")) )
              (if (etipo enm1 0)
                (progn
                  (if (equadro enm1 0)
                    (setq org1 (cadr (assoc "#NOME_QUADRO(0)" (attread enm1))) )
                    (setq org1 (cadr (assoc "#QUADRO_ORIGEM(0)" (attread enm1))) )
                  ) ; end if
                  (setq flg nil)
                ) ; end progn
                (prompt "\nERR: Elemento selecionado nao e um objeto eletrico.")
              ) ; end if
              (prompt "\nERR: Resposta nula nao e valida.")
            ) ; end if
          ) ; end while
        ) ; end progn
      ) ; end if
      (setq cnt (sslength ss))
      (while (>= (setq cnt (- cnt 1)) 0)
        (setq enm (ssname ss cnt))
        (setq att (attread enm))
        (setq idx 0)
        (while (assoc (strcat "#TIPO(" (itoa idx) ")") att)
          (attvalue enm (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") org)
          (setq idx (1+ idx))
        ) ; end while
      ) ; end while
    ) ; end progn
  ) ; end if
  (setvar "cmdecho" 0)
  (princ)
) ; end defun

;; echcirc: rotina que troca o circuito dos objetos selecionados
(defun c:echcirc(/ oldech ss cir enm cnt att idx)
  (setq oldech (acadvar "cmdecho" 0))
  (prompt "\nSelecione os objetos para modificacao do circuito...")
  (if (setq ss (ssget))
    (progn
      (while (= (setq cir (getstring "\nNova identificacao para o circuito: ")) "")
        (prompt "\nERR: Resposta nula nao e valida."))
      (setq cnt (sslength ss))
      (while (>= (setq cnt (- cnt 1)) 0)
        (setq enm (ssname ss cnt))
        (setq att (attread enm))
        (setq idx 0)
        (while (assoc (strcat "#TIPO(" (itoa idx) ")") att)
          (attvalue enm (strcat "#CIRCUITO(" (itoa idx) ")") cir)
          (setq idx (1+ idx))
        ) ; end while
      ) ; end while
    ) ; end progn
  ) ; end if
  (setvar "cmdecho" 0)
  (princ)
) ; end defun

;; echcmd: rotina que troca os comandos dos objetos selecionados
(defun c:echcmd(/ oldech ss cmd cnt enm cmd1 cmd2 cmd3 idx att)
  (setq oldech (acadvar "cmdecho" 0))
  (prompt "\nSelecione os objetos para modificacao do comando...")
  (if (setq ss (ssget))
    (progn
      (while (= (setq cmd (getstring "\nNova identificacao para o comando: ")) "")
        (prompt "\nERR: Resposta nula nao e valida."))
      (setq cnt (sslength ss))
      (while (>= (setq cnt (- cnt 1)) 0)
        (setq enm (ssname ss cnt))
        (setq att (attread enm))
        (setq idx 0)
        (while (assoc (strcat "#TIPO(" (itoa idx) ")") att)
          (setq tag (strcat "#COMANDO(" (itoa idx) ")"))
          (if (ecomando enm idx)
            (progn
              (setq cmd1 (cadr (assoc tag (attread enm))) )
              (if (= cmd1 "")
                (attvalue enm tag cmd)
                (progn
                  (setq flg t)
                  (setq cmd2 cmd1)
                  (while (and flg (/= (setq cmd3 (strhead cmd2 ",")) ""))
                    (if (= cmd cmd3) (setq flg nil))
                    (setq cmd2 (strtail cmd2 ","))
                  ) ; end while
                  (if flg (attvalue enm tag (strcat cmd1 "," cmd)) )
                ) ; end progn
              ) ; end if
            ) ; end progn
            (attvalue enm tag cmd)
          ) ; end if
          (setq idx (1+ idx))
        ) ; end while
      ) ; end while
    ) ; end progn
  ) ; end if
  (setvar "cmdecho" 0)
  (princ)
) ; end defun

;; epckorg: iguala o quadro origem dos objetos selecao com o de outro
(defun c:epckorg(/ oldech ss enm1 org1 cnt enm)
  (setq oldech (acadvar "cmdecho" 0))
  (prompt "\nSelecione os objetos para modificacao do quadro de origem...")
  (if (setq ss (ssget))
          (setq cnt (sslength ss))
          (while (>= (setq cnt (- cnt 1)) 0)
            (setq enm (ssname ss cnt))
            (setq att (attread enm))
            (setq idx 0)
            (while (assoc (strcat "#TIPO(" (itoa idx) ")") att)
              (attvalue enm (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") org1)
              (setq idx (1+ idx))
            ) ; end while
          ) ; end while
        ) ; end progn
        (prompt "ERR: Objeto de referencia nao possui definicao de quadro origem.")
      ) ; end if
      (prompt "\nERR: Nenhum objeto de referencia selecionado.")
    ) ; end if
  ) ; end if
  (setvar "cmdecho" 0)
  (princ)
) ; end defun

;; epckcirc: iguala o circuito dos objetos selecao com o circuito de outro
(defun c:epckcirc(/ oldech ss enm1 cir1 cnt enm)
  (setq oldech (acadvar "cmdecho" 0))
  (prompt "\nSelecione os objetos para modificacao do circuito...")
  (if (setq ss (ssget))
    (if (setq enm1 (car (entsel "Selecione o objeto de referencia: ")))
      (if (not (or (ecomando enm1 0) (ecaixa enm1 0)) )
        (progn
          (setq cir1 (cadr (assoc "#CIRCUITO(0)" (attread enm1))) )
          (setq cnt (sslength ss))
          (while (>= (setq cnt (- cnt 1)) 0)
            (setq enm (ssname ss cnt))
            (setq att (attread enm))
            (setq idx 0)
            (while (assoc (strcat "#TIPO(" (itoa idx) ")") att)
              (attvalue enm (strcat "#CIRCUITO(" (itoa idx) ")") cir1)
              (setq idx (1+ idx))
            ) ; end while
          ) ; end while
        ) ; end progn
        (prompt "ERR: Objeto de referencia nao possui definicao de circuito.")
      ) ; end if
      (prompt "\nERR: Nenhum objeto de referencia selecionado.")
    ) ; end if
  ) ; end if
  (setvar "cmdecho" 0)
  (princ)
) ; end defun

;; epckcmd: iguala o comando dos objetos selecao com o comando de outro
(defun c:epckcmd(/ oldech ss enm1 cmd1 cmd2 cmd3 cmd4 cnt enm)
  (setq oldech (acadvar "cmdecho" 0))
  (prompt "\nSelecione os objetos para modificacao do comando...")
  (if (setq ss (ssget))
    (if (setq enm1 (car (entsel "Selecione o objeto de referencia: ")))
      (if (not (or (equadro enm1 0) (ecaixa enm1 0)) )
        (progn
          (setq cmd1 (cadr (assoc "#COMANDO(0)" (attread enm1))) )
          (if (> (strcnt cmd1 ",") 0)
            (progn
              (prompt "\nATT: Objeto de referencia possui multiplos comandos.")
              (while (= (setq cmd1 (getstring "\nInforme a nova identificacao para o comando: ")) "")
                (prompt "\nERR: Resposta nula nao e valida."))
            ) ; end progn
          ) ; end if
          (setq cnt (sslength ss))
          (while (>= (setq cnt (- cnt 1)) 0)
            (setq enm (ssname ss cnt))
            (setq att (attread enm))
            (setq idx 0)
            (while (assoc (strcat "#TIPO(" (itoa idx) ")") att)
              (setq tag (strcat "#COMANDO(" (itoa idx) ")"))
              (if (ecomando enm idx)
                (progn
                  (setq cmd2 (cadr (assoc tag (attread enm))) )
                  (if (= cmd2 "")
                    (attvalue enm tag cmd1)
                    (progn
                      (setq flg t)
                      (setq cmd3  cmd2)
                      (while (and flg (/= (setq cmd4 (strhead cmd3 ",")) ""))
                        (if (= cmd1 cmd4) (setq flg nil))
                        (setq cmd3 (strtail cmd3 ","))
                      ) ; end while
                      (if flg (attvalue enm tag (strcat cmd2 "," cmd1)) )
                    ) ; end progn
                  ) ; end if
                ) ; end progn
                (attvalue enm tag cmd1)
              ) ; end if
              (setq idx (1+ idx))
            ) ; end while
          ) ; end while
        ) ; end progn
        (prompt "ERR: Objeto de referencia nao possui definicao de comando.")
      ) ; end if
      (prompt "\nERR: Nenhum objeto de referencia selecionado.")
    ) ; end if
  ) ; end if
  (setvar "cmdecho" 0)
  (princ)
) ; end defun

(princ)
