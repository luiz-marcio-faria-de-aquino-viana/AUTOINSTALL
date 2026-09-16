
;;
;; K6BC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 7/3/97
;;

;; edt_IsEletricObj(): funcao que retorna verdadeiro se objeto 
;;  enm - ename da entidade que sera analisada
(defun edt_IsEletricObj(enm)
  (setq lay (cdr (assoc 8 (entget enm))) )
  (or (= lay "EL-PONTOS") (= lay "EL-PRUMADAS"))
) ; end defun

;; edt_SetObjectData(): funcao para insercao de dados nos eletrodutos
;;  enm  - ename da entidade eletroduto
;;  obj1 - ename do ponto origem do eletroduto
;;  obj2 - ename do ponto destino do eletroduto
(defun edt_SetObjectData(enm obj1 obj2 / hnd1 hnd2 lst1 lst2)
  (if obj1
    (progn
      (setq hnd1 (cdr (assoc 5 (entget obj1))) )
      (setq lst1 (list
                   '(1002 . "{")
                     (cons 1000 "#ORIGEM")
                     (cons 1005 hnd1)
                   '(1002 . "}")
      )          ) ; end list, setq
    ) ; end progn
    (setq lst1 '((1002 . "{") (1000 . "#ORIGEM") (1005 . nil) (1002 . "}")) )
  ) ; end if
  (if obj2
    (progn
      (setq hnd2 (cdr (assoc 5 (entget obj2))) )
      (setq lst2 (list
                   '(1002 . "{")
                     (cons 1000 "#DESTINO")
                     (cons 1005 hnd2)
                   '(1002 . "}")
      )          ) ; end list, setq
    ) ; end progn
    (setq lst2 '((1002 . "{") (1000 . "#DESTINO") (1005 . nil) (1002 . "}")) )
  ) ; end if
  (eedmod enm "AI230EL" (append '((1002 . "{") (1002 . "{") (1000 . "#ELETRODUTO")) lst1 lst2 '((1002 . "}") (1002 . "}"))) )
) ; end defun

;; edt_GetObject(): funcao de selecao de objetos eletricos
;;  ptb - ponto de referencia
;;  msg - mensagem a ser apresentada
;;  ctl - conjunto de bits de controle da entrada de dados
;;  opt - opcoes de palavra chave para entrada de dados
(defun edt_GetObject(ptb msg ctl opt / flg pt pt1 ss enm rst)
  (setq flg 't)
  (while flg
    (initget (strcat "Sel " opt))
    (if ptb
      (setq pt (getpoint ptb msg))
      (setq pt (getpoint msg))
    ) ; end if
    (if (= pt "Sel")
      (progn
        ;; se a selecao sera feita em duas etapas
        (if (setq ss (entsel "\nSelecione objeto: "))
          (if (edt_IsEletricObj (setq enm (car ss)))
            (if (setq pt (getpoint "\nPonto de contato: "))
              (progn
                (if (setq pt1 (osnap pt "node")) (setq pt pt1))
                (setq rst (cons enm pt))
                (setq flg nil)
              ) ; end progn
              (prompt "\nERR: Ponto de contato invalido.")
            ) ; end if
            (prompt "\nERR: Elemento selecionado nao e um ponto de eletrica.")
          ) ; end if
          (prompt "\nERR: Resposta nula nao e valida.")
        ) ; end if
      ) ; end progn
      (progn
        (if (= (type pt) 'STR)
          (progn
            ;; se foi selecionada uma palavra chave
            (setq rst pt)
            (setq flg nil)
          ) ; end progn
          (progn
            ;; se nao foi selecionada uma palavra chave
            (cond
              ((= ctl 0) (if pt
                           (progn
                             ;; se a selecao nao foi nula
                             (if (setq pt1 (osnap pt "node")) (setq pt pt1))
                             (if (setq ss (ssget pt))
                               (progn
                                 ;; se algum objeto foi selecionado
                                 (setq enm (ssname ss 0))
                                 (if (edt_IsEletricObj enm)
                                   (progn
                                     ;; se um objeto eletrico foi selecionado
                                     (setq rst (cons enm pt))
                                     (setq flg nil)
                                   ) ; end progn
                                   (progn
                                     ;; se elemento selecionado nao for um objeto eletrico
                                     (setq rst (cons '() pt))
                                     (setq flg nil)
                                   ) ; end progn
                                 ) ; end if
                               ) ; end progn
                               (progn
                                 ;; se nenhum objeto foi selecionado
                                 (setq rst (cons '() pt))
                                 (setq flg nil)
                               ) ; end progn
                             ) ; end if
                           ) ; end progn
                           (progn
                             ;; se a selecao foi nula
                             (setq rst nil)
                             (setq flg nil)
                           ) ; end progn
                         ) ; end if
              ) ; end case
              ((= ctl 1) (if pt
                           (progn
                             ;; se a selecao nao foi nula
                             (if (setq pt1 (osnap pt "node")) (setq pt pt1))
                             (if (setq ss (ssget pt))
                               (progn
                                 ;; se algum objeto foi selecionado
                                 (setq enm (ssname ss 0))
                                 (if (edt_IsEletricObj enm)
                                   (progn
                                     ;; se um objeto eletrico foi selecionado
                                     (setq rst (cons enm pt))
                                     (setq flg nil)
                                   ) ; end progn
                                   (prompt "\nERR: Selecione um ponto de eletrica.")
                                 ) ; end if
                               ) ; end progn
                               (prompt "\nERR: Selecione um ponto de eletrica.")
                             ) ; end if
                           ) ; end progn
                           (prompt "\nERR: Resposta nula nao e valida.")
                         ) ; end if
              ) ; end case
            ) ; end cond
          ) ; end progn
        ) ; end if
      ) ; end progn
    ) ; end if
  ) ; end while
  rst
) ; end defun

;; c:edt(): comando para desenho de eletrodutos de eletrica
(defun c:edt(/ oldech TYP_LINE TYP_ARC obj1 obj2 typ ls flg ESP_EDT)
  (m:savevars)

  ;;(setq ESP_EDT (/ 15.0 (#UND)))
  (setq ESP_EDT 0.0)
  
  (setq
     TYP_LINE 0
     TYP_ARC  1
  ) ; end setq

  (setq obj1 (edt_GetObject nil "\nSelecione objeto/<Origem do eletroduto>: " 1 ""))
  (command ".pline" (cdr obj1) "w" ESP_EDT "")

  (setq
    typ TYP_LINE
    ls  (cons (cons typ obj1) '())
    flg 't
  ) ; end setq

  (while flg
    (setq obj2 (edt_GetObject (cdr obj1) "\nSelecione objeto/<Proximo ponto>: " 0 ""))
    (if obj2
      (cond
        ((car obj2)
          (progn
            (setq
              ls  (cons (cons typ obj2) ls)
              obj1 obj2
              flg nil
            ) ; end setq
            (command (cdr obj2) "")
        ) ) ; end progn, case
        ('t (progn
              (setq
                ls (cons (cons typ obj2) ls)
                obj1 obj2
              ) ; end setq
              (command (cdr obj2))
        ) ) ; end progn, case
      ) ; end cond
      (progn
        (setq flg nil)
        (command "")
      ) ; end progn
    ) ; end if
  ) ; end while

  (setq
    enm1 (cadr (car (reverse ls)))
    enm2 (cadr (car ls))
  ) ; end setq
  (edt_SetObjectData (entlast) enm1 enm2)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
