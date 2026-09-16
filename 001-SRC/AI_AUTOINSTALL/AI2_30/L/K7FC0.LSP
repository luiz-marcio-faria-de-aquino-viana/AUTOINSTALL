
;;
;; K7FC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 9/4/97
;;

;; EQPot_Depth(): funcao que analisa a dependencia de valores entre quadros
(defun EQPot_Depth(/ ls ss cnt enm att idx tip qdr org enm1 idx1 lst1 itm)
  (setq ls '())
  (if (setq ss (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))))
    (progn
      (setq cnt (sslength ss))
      (prompt (strcat "\nProcessando " (itoa cnt) " elementos... "))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq enm (ssname ss cnt))
        (setq att (attread enm))
        (setq idx 0)
        (while (setq tip (etipo enm idx))
          (if (= tip "EQUADRO")
            (progn
              (setq
                qdr (cadr (assoc (strcat "#NOME_QUADRO(" (itoa idx) ")") att))
                org (cadr (assoc (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") att))
              ) ; end setq
              ;; atualiza as informacoes referentes ao quadro origem
              (if (setq itm (assoc org ls))
                (progn
                  ;; quadro origem ja foi determinado
                  (setq
                    enm1 (cadr   itm)
                    idx1 (caddr  itm)
                    lst1 (cadddr itm)
                  ) ; end setq
                  (setq ls (subst (list org enm1 idx1 (cons qdr lst1)) (assoc org ls) ls))
                ) ; end progn
                (progn
                  ;; quadro origem ainda nao foi determinado
                  (setq ls (cons (list org nil -1 (list qdr)) ls))
                ) ; end progn
              ) ; end if
              ;; analisa informacoes referentes ao quadro
              (if (setq itm (assoc qdr ls))
                (progn
                  ;; quadro ja foi determinado
                  (setq
                    enm1 (cadr   itm)
                    idx1 (caddr  itm)
                    lst1 (cadddr itm)
                  ) ; end setq
                  (if enm1
                    (progn
                      ;; erro de duplicidade de informacoes
                      (prompt (strcat "\nERR: Duplicidade de informacoes: " qdr))
                      (prompt "\nContinuando o processamento... ")
                    ) ; end progn
                    (progn
                      ;; atualizacao das informacoes do quadro
                      (setq ls (subst (list qdr enm idx lst1) (assoc qdr ls) ls))
                    ) ; end progn
                  ) ; end if
                ) ; end progn
                (progn
                  ;; quadro ainda nao foi determinado
                  (setq ls (cons (list qdr enm idx '()) ls))
                ) ; end progn
              ) ; end if
            ) ; end progn
          ) ; end if
          (setq idx (1+ idx))
        ) ; end while
        (if (zerop (rem cnt 10)) (prompt "."))
      ) ; end while
    ) ; end progn
  ) ; end if
  ls
) ; end defun

;; EQPot_Calc(): comando que calcula a carga total associada a um quadro
;;  qdr - nome do quadro que sera calculado
(defun EQPot_Calc(qdr / pot ss cnt enm att idx tip val qdr1)
  (setq pot 0.0)
  (if (setq ss (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))) )
    (progn
      (setq cnt (sslength ss))
      (prompt (strcat "\nProcessando " (itoa cnt) " elementos... "))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq enm (ssname ss cnt))
        (setq att (attread enm))
        (setq idx 0)
        (while (setq tip (etipo enm idx))
          (if (= qdr (cadr (assoc (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") att)) )
            (cond
              ( (or (= tip "ECARGA") (= tip "EILUMINACAO"))
                (progn
                  (setq val (atof (cadr (assoc (strcat "#POTENCIA(" (itoa idx) ")") att))))
                  (setq pot (+ pot val))
                ) ; end progn
              ) ; end case
              ( (= tip "EQUADRO")
                (progn
                  (setq qdr1 (cadr (assoc (strcat "#NOME_QUADRO(" (itoa idx) ")") att)) )
                  (if (/= qdr1 qdr)
                    (progn
                      (setq val (atof (cadr (assoc (strcat "#POTENCIA_DEMANDADA(" (itoa idx) ")") att))) )
                      (if (equal val 0.0 0.000001)
                        (setq val (atof (cadr (assoc (strcat "#POTENCIA(" (itoa idx) ")") att))) )
                      ) ; end if
                      (setq pot (+ pot val))
                    ) ; end progn
                  ) ; end if
                ) ; end progn
              ) ; end case
            ) ; end cond
          ) ; end if
          (setq idx (1+ idx))
        ) ; end while
        (if (zerop (rem cnt 10)) (prompt "."))
      ) ; end while
    ) ; end progn
  ) ; end if
  pot
) ; end defun

;; EQPot(): funcao que calcula recursivamente a potencia total de um quadro
;;  qdr - nome do quadro que sera calculado
;;  lst - lista de dependencia dos quadros
(defun EQPot(qdr lst / itm enm idx ls1 pot it1)
  (setq itm (assoc qdr lst))
  (setq
    enm (cadr   itm)
    idx (caddr  itm)
    ls1 (cadddr itm)
  ) ; end setq
  (setq pot 0.0)
  (foreach it1 ls1
    (if (/= qdr it1)
      (setq pot (+ pot (EQPot it1 lst)) )
      (progn
        (prompt (strcat "\nERR: Quadro [" qdr "] tem como origem ele mesmo."))
        (getstring "\nTecle [ENTER] para continuar... ")
      ) ; end progn
    ) ; end if
  )  ; end foreach
  (setq pot (EQPot_Calc qdr))
  (attvalue enm (strcat "#POTENCIA(" (itoa idx) ")") (rtos pot 2 0) )
  pot
) ; end defun

;; C:EQPot(): comando que calcula a potencia de um determinado quadro
(defun C:EQPot(/ qdr)
  (setq qdr (strcase (getstring "\nNome do quadro: ")) )
  (prompt "\nAnalisando dependencia entre os quadros...")
  (setq lst (EQPot_Depth))    ;; analisa a dependencia entre os quadros
  (prompt "\nCalculando a carga total do quadro e derivados...")
  (if (setq itm (assoc qdr lst))
    (progn
      (setq
        dep (cadddr itm)
        num (length dep)
      ) ; end setq
      (prompt (strcat "\nPotencia = " (rtos (EQPot qdr lst) 2 0)))
    ) ; end progn
    (prompt "\nERR: Quadro de distribuicao inexistente.")
  ) ; end if
  (princ)
) ; end defun

(princ)
