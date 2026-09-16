
;;
;; K8EC0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 5/27/98
;;

;; definicao das variaveis globais
(setq
  #TBCONS_HTT (*  3.5 (#SCL))	;; altura do texto de titulo da tabela
  #TBCONS_HTC (*  2.0 (#SCL))	;; altura do texto de titulo das colunas
  #TBCONS_HTD (*  2.0 (#SCL))     ;; altura do texto de dados
  #TBCONS_HTS (*  2.0 (#SCL))     ;; altura do texto de total sumario
  #TBCONS_HLT (* 10.0 (#SCL))     ;; altura da linha de titulo da tabela
  #TBCONS_HLC (*  7.5 (#SCL))     ;; altura da linha de titulo das colunas
  #TBCONS_HLD (*  4.0 (#SCL))     ;; altura da linha de dado
  #TBCONS_HLS (*  7.5 (#SCL))     ;; altura da linha total sumario
  #TBCONS_WCL (* 20.0 (#SCL))     ;; largura das colunas
) ; end setq

;; c:tbcons(): rotina para construcao de tabelas parametrizadas
(defun c:tbcons(/ oldecho oldblip nl nc tt ls cnt nc tc ls cnt pti pt0 pt1 it)

  (initget 7)
  (setq nl (getint "\nNumero de linhas: "))

  (initget 7)
  (setq nc (getint "\nNumero de colunas: "))

  (setq tt (getstring 't "\nTitulo da tabela: "))

  (setq
    ls '()
    cnt 1
  ) ; end setq
  (repeat nc
    (setq tc (getstring (strcat "\nTitulo da coluna (" (itoa cnt) "): ")) )
    (setq ls (cons tc ls))
    (setq cnt (1+ cnt))
  ) ; end repeat

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (setq oldecho (acadvar "cmdecho" 0))

  (command ".undo" "g")
  (setq oldblip (acadvar "blipmode" 0))

  (setq
    pt0 (list (car pti) (cadr pti))
    pt1 (list (car pti) (+ (cadr pti) #TBCONS_HLS (* nl #TBCONS_HLD) #TBCONS_HLC))
  ) ; end setq
  (command ".line" pt0 (list (car pt1) (+ (cadr pt1) #TBCONS_HLT)) "")
  (repeat (- nc 1)
    (setq
      pt0 (list (+ (car pt0) #TBCONS_WCL) (cadr pt0))
      pt1 (list (+ (car pt1) #TBCONS_WCL) (cadr pt1))
    ) ; end setq
    (command ".line" pt0 pt1 "")
  ) ; end repeat
  (command
    ".line"
      (list (+ (car pt0) #TBCONS_WCL) (cadr pt0))
      (list (+ (car pt1) #TBCONS_WCL) (+ (cadr pt1) #TBCONS_HLT))
      ""
  ) ; end command

  (setq
    pt0 (list (car pti) (cadr pti))
    pt1 (list (+ (car pti) (* nc #TBCONS_WCL)) (cadr pti))
  ) ; end setq
  (command ".line" pt0 pt1 "")

  (setq
    pt0 (list (car pt0) (+ (cadr pt0) #TBCONS_HLS))
    pt1 (list (car pt1) (+ (cadr pt1) #TBCONS_HLS))
  ) ; end setq
  (command ".line" pt0 pt1 "")
  (repeat nl
    (setq
      pt0 (list (car pt0) (+ (cadr pt0) #TBCONS_HLD))
      pt1 (list (car pt1) (+ (cadr pt1) #TBCONS_HLD))
    ) ; end setq
    (command ".line" pt0 pt1 "")
  ) ; end repeat

  (setq
    pt0 (list (car pt0) (+ (cadr pt0) #TBCONS_HLC))
    pt1 (list (car pt1) (+ (cadr pt1) #TBCONS_HLC))
  ) ; end setq
  (command ".line" pt0 pt1 "")

  (setq
    pt0 (list (car pt0) (+ (cadr pt0) #TBCONS_HLT))
    pt1 (list (car pt1) (+ (cadr pt1) #TBCONS_HLT))
  ) ; end setq
  (command ".line" pt0 pt1 "")

  (setq pt0 (list (+ (car pti) (/ #TBCONS_WCL 2.0)) (+ (cadr pti) #TBCONS_HLS (* nl #TBCONS_HLD) (/ #TBCONS_HLC 2.0)) ) )
  (foreach it (reverse ls)
    (command ".text" "m" pt0 #TBCONS_HTC 0 it)
    (setq pt0 (list (+ (car pt0) #TBCONS_WCL) (cadr pt0)) )
  ) ; end foreach

  (setq pt0 (list (+ (car pti) (/ (* nc #TBCONS_WCL) 2.0)) (+ (cadr pti) #TBCONS_HLS (* nl #TBCONS_HLD) #TBCONS_HLC (/ #TBCONS_HLT 2.0)) ) )
  (command ".text" "m" pt0 #TBCONS_HTT 0 tt)

  (setvar "blipmode" oldblip)
  (command ".undo" "e")

  (setvar "cmdecho" oldecho)

  (princ)
) ; end defun

(princ)
