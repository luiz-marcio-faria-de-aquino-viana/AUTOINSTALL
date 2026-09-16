
;;
;; K2FC0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana
;;

;; arquivo de definicao das funcoes de edicao de atributos e selecao

;; ssfilter: rotina que filtra a selecao retornando blocos do tipo especificado
;;  typ - tipo do bloco a ser retornado (EQUADRO, ECARGA ou ECOMANDO)
;;  ss  - selecao a ser filtrada
(defun ssfilter(typ ss / oldhigh flg1 cnt1 flg2 cnt2 typ2 enm)
  (setq oldhigh (getvar "highlight"))
  (setvar "highlight" 0)
  (setq flg1 nil)
  (command ".select")
  (setq cnt1 (sslength ss))
  (while (>= (setq cnt1 (- cnt1 1)) 0)
    (setq enm (ssname ss cnt1))
    (setq
      flg2 nil
      cnt2 0
    ) ; end setq
    (while (and (null flg2) (setq typ2 (etipo enm cnt2)) )
      (if (= typ2 typ)
        (progn
          (setq flg2 t)
          (command enm)
        ) ; end progn
      ) ; end if
      (if flg2 (setq flg1 t))
      (setq cnt2 (1+ cnt2))
    ) ; end while
  ) ; end while
  (command "")
  (setvar "highlight" oldhigh)
  (if flg1 (ssget "p") nil)
) ; end defun

;; etipo: retorna o valor do atributo que define o tipo do bloco
;;   enm   - ename do bloco que sera analisado
;;   idx   - index do elemento do bloco que sera analisado
(defun etipo(enm idx / ent enm1 ent1 blk val)
  (setq val nil)
  (setq ent (entget enm))
  (if (= (cdr (assoc 0 ent)) "INSERT")
    (progn
      (setq enm1 (entnext enm))
      (while (and enm1 (= (cdr (assoc 0 (setq ent1 (entget enm1)))) "ATTRIB"))
        (if (= (cdr (assoc 2 ent1)) (strcat "#TIPO(" (itoa idx) ")")) (setq val (cdr (assoc 1 ent1))) )
        (setq enm1 (entnext enm1))
      ) ; end while
    ) ; end progn
  ) ; end if
  val
) ; end defun

;; equadro: retorna true se o bloco analisado for um quadro de distribuicao
;;   enm   - ename do bloco que sera analisado
;;   idx   - index do elemento do bloco que sera analisado
(defun equadro(enm idx) (= (etipo enm idx) "EQUADRO"))

;; ecomando: retorna true se o bloco analisado for uma chave de comando
;;   enm   - ename do bloco que sera analisado
;;   idx   - index do elemento do bloco que sera analisado
(defun ecomando(enm idx) (= (etipo enm idx) "ECOMANDO"))

;; ecarga: retorna true se o bloco analisado for uma carga
;;   enm   - ename do bloco que sera analisado
;;   idx   - index do elemento do bloco que sera analisado
(defun ecarga(enm idx) (= (etipo enm idx) "ECARGA"))

;; ecampainha: retorna true se o bloco analisado for uma campainha
;;   enm   - ename do bloco que sera analisado
;;   idx   - index do elemento do bloco que sera analisado
(defun ecampainha(enm idx) (= (etipo enm idx) "ECAMPAINHA"))

;; ecaixa: retorna true se o bloco analisado for uma caixa de passagem
;;   enm   - ename do bloco que sera analisado
;;   idx   - index do elemento do bloco que sera analisado
(defun ecaixa(enm idx) (= (etipo enm idx) "ECAIXA"))

;; eiluminacao: retorna true se o bloco analisado for um ponto de luz
;;   enm   - ename do bloco que sera analisado
;;   idx   - index do elemento do bloco que sera analisado

;; attreset: ajusta altura e rotacao de todos os atributos de um bloco
;;   enm   - ename do bloco inserido
(defun attreset(enm / enm1 ent1)
  (setq enm1 (entnext enm))
  (while (and enm1 (= (cdr (assoc 0 (setq ent1 (entget enm1)))) "ATTRIB"))
    (setq ent1 (subst (cons 40 (* 1.5 #SCL)) (assoc 40 ent1) ent1))
    (entmod    (subst (cons 50          0.0) (assoc 50 ent1) ent1))
    (entupd enm1)
    (setq enm1 (entnext enm1))
  ) ; end while
) ; end defun

;; attvalue: troca os valores do atributo identificado
;;   enm   - ename do bloco inserido
;;   attid - identificador do atributo
;;   val   - valor a ser substituido
(defun attvalue(enm attid val / enm1 ent1)
  (setq enm1 (entnext enm))
  (while (and enm1 (= (cdr (assoc 0 (setq ent1 (entget enm1)))) "ATTRIB"))
    (if (= (cdr (assoc 2 ent1)) attid)
      (progn
        (entmod (subst (cons 1 val) (assoc 1 ent1) ent1))
        (entupd enm1)
      ) ; end progn
    ) ; end if
    (setq enm1 (entnext enm1))
  ) ; end while
) ; end defun

;; attmove: movimenta os atributos identificados
;;   enm   - ename do bloco inserido
;;   attid - identificador do atributo
(defun attmove(enm attid / enm1 ent1 pti ptf)
  (setq enm1 (entnext enm))
  (while (and enm1 (= (cdr (assoc 0 (setq ent1 (entget enm1)))) "ATTRIB"))
    (if (= (cdr (assoc 2 ent1)) attid)
      (progn
        (setq pti (cdr (assoc 10 ent1)) )
        (setq ptf (getpoint pti "\nPosicao do atributo (ou ENTER): "))
        (if ptf (progn
                  (entmod (subst (cons 10 ptf) (assoc 10 ent1) ent1))
                  (entupd enm1)
        )       ) ; end progn, if
      ) ; end progn
    ) ; end if
    (setq enm1 (entnext enm1))
  ) ; end while
) ; end defun

;; attread: devolve uma lista de valores dos atributos do bloco
;;   enm - ename do bloco que se deseja extrair os valores dos atributos
(defun attread(enm / enm1 ent1 ls)
  (setq ls '())
  (if (= (cdr (assoc 0 (entget enm))) "INSERT")
    (progn
      (setq enm1 (entnext enm))
      (while (and enm1 (= (cdr (assoc 0 (setq ent1 (entget enm1)))) "ATTRIB"))
        (setq ls (append ls (list (list (cdr (assoc 2 ent1)) (cdr (assoc 1 ent1)))) ))
        (setq enm1 (entnext enm1))
      ) ; end while
    ) ; end progn
  ) ; end if
  ls
) ; end defun

;; attcpval: copia todos os valores dos atributo de um bloco para outro
;;  enm1 - ename do bloco fonte dos valores
;;  enm2 - ename do bloco destino dos valores
(defun attcpval(enm1 enm2)
  (while (= (enttype (setq enm1 (entnext enm1))) "ATTRIB")
    (setq ent1 (entget enm1))
    (setq
      tag (cdr (assoc 2 ent1))
      val (cdr (assoc 1 ent1))
    ) ; end setq
    (attvalue enm2 tag val)
  ) ; end while
) ; end defun

;; readdef: le as caracteristicas do bloco no arquivo de configuracao
(defun readdef(blk / DATFIL ff f v flg)
  (setq blk (getfilename blk))
  (setq DATFIL "default.dat")
  ;; procura e abre o arquivo de definicoes do sistema
  (if (findfile (setq ff (strcat (getvar "dwgprefix") DATFIL)))
    (setq f (open ff "r"))   ;; utiliza o arquivo de definicoes da obra
    (if (findfile (setq ff (v:ai DATFIL)))
      (setq f (open ff "r")) ;; utiliza o arquivo de definicoes do sistema
      (prompt "\n* ATENCAO * Arquivo de definicoes nao foi encontrado.")
    ) ; end if
  ) ; end if
  ;; procura o registro correspondente
  (if f
    (progn
      (setq flg nil)
      (while (and (null flg) (setq s (read-line f)))
        (if (setq flg (= blk (strcase (substr s 1 8))))
          (setq v (list (rtrim (substr s 10 30)) (rtrim (substr s 51 11)) (rtrim (substr s 63 7)) (rtrim (substr s 71 6))) )
        ) ; end if
      ) ; end while
      (setq f (close f))
    ) ; end progn
  ) ; end if
  v                          ;; retorna resultado da procura
) ; end defun

(princ)
