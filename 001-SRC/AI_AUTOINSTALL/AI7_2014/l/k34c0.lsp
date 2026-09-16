
;;
;; K34c0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 12/16/96
;;

;; c:echorg(): rotina que troca o quadro origem dos objetos selecionados
(defun c:echorg(/ flg enm1 org1 ss oldecho cnt enm att idx)

  (setq flg 't)
  (while flg
    (if (setq enm1 (car (entsel "\nSelecione um objeto de referencia (ou ENTER): ")) )
      (progn
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
      ) ; end progn
      (progn
        (while (= (setq org1 (getstring "\nNova identificacao do quadro de origem: ")) "")
          (prompt "\nERR: Resposta nula nao e valida.") )
        (setq flg nil)
      ) ; end progn
    ) ; end if
  ) ; end while

  (prompt "\nSelecione objetos para modificacao do quadro de origem...")
  (if (setq ss (ssget))
    (progn
      (command ".undo" "g")
      (setq oldecho (acadvar "cmdecho" 0))
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
      (setvar "cmdecho" oldecho)
      (command ".undo" "e")
    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

;; c:echcir: rotina que troca o circuito dos objetos selecionados
(defun c:echcir(/ flg enm1 cir1 ss oldecho cnt enm att idx)

  (setq flg 't)
  (while flg
    (if (setq enm1 (car (entsel "\nSelecione um objeto de referencia (ou ENTER): ")) )
      (progn
        (if (etipo enm1 0)
          (if (setq cir1 (cadr (assoc "#CIRCUITO(0)" (attread enm1))) )
            (setq flg nil)
            (prompt "\nERR: Objeto selecionado nao possui identificacao de circuito.")
          ) ; end if
          (prompt "\nERR: Elemento selecionado nao e um objeto eletrico.")
        ) ; end if
      ) ; end progn
      (progn
        (while (= (setq cir1 (getstring "\nNova identificacao de circuito: ")) "")
          (prompt "\nERR: Resposta nula nao e valida.") )
        (setq flg nil)
      ) ; end progn
    ) ; end if
  ) ; end while

  (prompt "\nSelecione objetos para modificacao do circuito...")
  (if (setq ss (ssget))
    (progn
      (setq oldecho (acadvar "cmdecho" 0))
      (command ".undo" "g")
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
      (setvar "cmdecho" oldecho)
      (command ".undo" "e")
    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

;; echcmd: rotina que troca os comandos dos objetos selecionados
(defun c:echcmd(/ flg enm1 cmd1 ss oldecho cnt enm att idx tag cmd lop1 cmd2 lop2)

  (setq flg 't)
  (while flg
    (if (setq enm1 (car (entsel "\nSelecione um objeto de referencia (ou ENTER): ")) )
      (progn
        (if (etipo enm1 0)
          (if (setq cmd1 (cadr (assoc "#COMANDO(0)" (attread enm1))) )
            (setq flg nil)
            (prompt "\nERR: Objeto selecionado nao possui identificacao de comando.")
          ) ; end if
          (prompt "\nERR: Elemento selecionado nao e um objeto eletrico.")
        ) ; end if
      ) ; end progn
      (progn
        (while (= (setq cmd1 (getstring "\nNova identificacao de comando: ")) "")
          (prompt "\nERR: Resposta nula nao e valida.") )
        (setq flg nil)
      ) ; end progn
    ) ; end if
  ) ; end while

  (prompt "\nSelecione os objetos para modificacao do comando...")
  (if (setq ss (ssget))
    (progn
      (setq oldecho (acadvar "cmdecho" 0))
      (command ".undo" "g")
      (setq cnt (sslength ss))
      (while (>= (setq cnt (- cnt 1)) 0)
        (setq enm (ssname ss cnt))
        (setq att (attread enm))
        (setq idx 0)
        (while (assoc (strcat "#TIPO(" (itoa idx) ")") att)
          (setq tag (strcat "#COMANDO(" (itoa idx) ")"))
          (if (ecomando enm idx)
            (progn
              (setq cmd (cadr (assoc tag (attread enm))) )
              (if (= cmd "")
                (attvalue enm tag cmd1)
                (progn
                  (while (/= (setq lop1 (strhead cmd1 ",")) "")
                    (setq flg 't)
                    (setq cmd2 cmd)
                    (while (and flg (/= (setq lop2 (strhead cmd2 ",")) ""))
                      (if (= lop1 lop2) (setq flg nil))
                      (setq cmd2 (strtail cmd2 ","))
                    ) ; end while
                    (if flg (setq cmd (strcat cmd "," lop1)) )
                    (setq cmd1 (strtail cmd1 ","))
                  ) ; end while
                  (attvalue enm tag cmd)
                ) ; end progn
              ) ; end if
            ) ; end progn
            (attvalue enm tag (strhead cmd1 ","))
          ) ; end if
          (setq idx (1+ idx))
        ) ; end while
      ) ; end while
      (setvar "cmdecho" oldecho)
      (command ".undo" "e")
    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

(princ)
