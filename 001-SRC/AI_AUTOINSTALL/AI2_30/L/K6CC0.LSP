
;;
;; K6CC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 7/8/97
;;

;;
;; exemplo de uma lista de itens com grupos delimitadores
;;
;; '((1002 . "{")		;; grupo delimitador marcando inicio de dados
;;    (1000 . "#CAMPO_A")		;; identificacao do campo de dados
;;    (1010 . '(10.0 10.0 10.0))	;; sequencia de dados
;;		:
;;		:
;;    (1070 . 12345)
;;   (1002 . "}"))		;; grupo delimitador marcando final de dados
;;

;; eedlistp(): funcao que retorna verdadeiro se a lista analisada for uma lista de itens
;;  lst - lista que sera analisada
(defun eedlistp(lst)
  (and (listp lst) (equal (car lst) '(1002 . "{")) (equal (car (reverse lst)) '(1002 . "}")) )
) ; end defun

;; eedread(): funcao que retorna a lista sem os grupos delimitadores
;;  lst - lista de dados de entidade extendidos
(defun eedread(lst)
  (if (eedlistp lst) (reverse (cdr (reverse (cdr lst)) )) )
) ; end defun

;; eedcar(): funcao que retorna o primeiro elemento de uma lista de itens
;;  lst - lista de dados de entidade extendidos
(defun eedcar(lst / n lst1 flg itm)
  (if (eedlistp lst)
    (progn
      (setq n 0)
      (setq lst1 '())
      (if (setq lst (eedread lst))
        (progn
          (setq flg 't)
          (while (and flg lst)
            (setq itm (car lst))
            (setq lst1 (append lst1 (list itm)) )
            (if (listp itm)
              (if (equal itm '(1002 . "{"))
                (setq n (1+ n))
                (if (equal itm '(1002 . "}"))
                  (setq n (1- n))
                ) ; end if
              ) ; end if
            ) ; end if
            (if (<= n 0) (setq flg nil))
            (setq lst (cdr lst))
          ) ; end while
        ) ; end progn
      ) ; end if
      lst1
    ) ; end progn
    nil
  ) ; end if
) ; end defun

;; eedcdr(): funcao que retorna uma lista de itens sem o primeiro elemento
;;  lst - lista de dados de entidade extendidos
(defun eedcdr(lst / n lst1 flg itm)
  (if (eedlistp lst)
    (progn
      (setq n 0)
      (setq lst1 '())
      (if (setq lst (eedread lst))
        (progn
          (setq flg 't)
          (while (and flg lst)
            (setq itm (car lst))
            (setq lst1 (append lst1 (list itm)) )
            (if (listp itm)
              (if (equal itm '(1002 . "{"))
                (setq n (1+ n))
                (if (equal itm '(1002 . "}"))
                  (setq n (1- n))
                ) ; end if
              ) ; end if
            ) ; end if
            (if (<= n 0) (setq flg nil))
            (setq lst (cdr lst))
          ) ; end while
        ) ; end progn
      ) ; end if
      (if lst (append '((1002 . "{")) lst '((1002 . "}")) ) )
    ) ; end progn
    nil
  ) ; end if
) ; end defun

;; eedassoc(): funcao que retorna a sublista que contem a chave dada
;;  key - chave de pesquisa (ex: '(1000 . "#ORIGEM") )
;;  lst - lista de dados de entidade que sera analisada
(defun eedassoc(key lst / itm)
  (if (eedlistp lst)
    (if (equal (cadr (eedcar lst)) key)
      lst
      (eedassoc key (eedcdr lst))
    ) ; end if
    nil
  ) ; end if
) ; end defun

;; eedget(): funcao que obtem os dados de entidade extendidos
;;  enm - ename da entidade que sera analisada
;;  app - nome da aplicacao associada
(defun eedget(enm app)
  (cdr (car (cdr (assoc -3 (entget enm (list app))) )))
) ; end defun

;; eedmod(): funcao que modifica os dados de entidade extendidos
;;  enm - ename da entidade que sera modificada
;;  app - nome da aplicacao associada
;;  eed - lista com os novos dados de entidade
(defun eedmod(enm app eed / ent)
  (setq ent (entget enm (list app)) )
  (entmod (append ent (list (cons -3 (list (cons app eed))) )) )
) ; end defun

(princ)
