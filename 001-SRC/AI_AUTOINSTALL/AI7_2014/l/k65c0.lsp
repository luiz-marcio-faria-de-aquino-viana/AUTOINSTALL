
;;
;; K65C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 7/1/96.
;;

;; idxrev: obtem o numero da revisao
;;  ls - lista de valores a serem pesquisados
(defun idxrev(ls)
  (setq ls (reverse ls))
  (setq idx 0)
  (setq flg t)
  (while (and flg ls)
    (setq e1 (car ls))
    (if (= (substr (car e1) 1 6) "CR_REV")
      (progn
        (setq idx (+ (atoi (cadr e1)) 1) )
        (setq flg nil)
      ) ; end progn
    ) ; end if
    (setq ls (cdr ls))
  ) ; end while
  idx
) ; end defun

;; valrev: adiciona novos valores a lista de revisao
;;  num - numero da revisao
;;  ll  - lista de valores a serem adicionados
;;  ls  - lista de valores existentes
(defun valrev(num ll ls / idx val)
  (if (> num 9)
    (setq idx "(9)")
    (setq idx (strcat "(" (itoa num) ")"))
  ) ; end if
  (setq
    val (list
          (list (strcat "CR_REV"   idx) (itoa  num))
          (list (strcat "CR_DATA"  idx) (car    ll))
          (list (strcat "CR_DESCR" idx) (cadr   ll))
          (list (strcat "CR_PROJ"  idx) (caddr  ll))
        ) ; end list
  ) ; end setq
  (append ls val)
) ; end defun

;; modrev: modifica atributos de revisao
;;  enm - ename do bloco que tera os atributos modificados
;;  ls  - lista de valores a serem trocados
(defun modrev(enm ls / enm1 ent1 e1)
  (setq enm1 (entnext enm))
  (while (and enm1 (= (cdr (assoc 0 (setq ent1 (entget enm1)))) "ATTRIB"))
    (if (setq e1 (assoc (cdr (assoc 2 ent1)) ls))
      (entmod (subst (cons 1 (cadr e1)) (assoc 1 ent1) ent1))
    ) ; end if
    (setq enm1 (entnext enm1))
  ) ; end while
  (entupd enm)
) ; end defun

;; rolrev: rola as revisoes uma posicao para baixo na tabela
;;  ls - lista de valores a serem rolados
(defun rolrev(ls / ls1 e1 e2)
  (setq ls1 '())
  (while ls
    (setq e1 (car ls))
    (if (setq e2 (car (cddddr ls)))
      (setq ls1 (append ls1 (list (list (car e1) (cadr e2)))))
    ) ; end if
    (setq ls (cdr ls))
  ) ; end while
  ls1
) ; end defun

;; insrev: insere nova entrada a lista de revisoes
;;  ll - lista com os novos elementos a serem inseridos
;;  ls - lista dos elementos ja inseridos
(defun insrev(ll ls / flg ls1 e1)
  (setq flg t)
  (setq ls1 '())
  (while (and flg ls)
    (setq e1 (car ls))
    (if (/= (cadr e1) "")
      (setq ls1 (append ls1 (list e1)))
      (setq flg nil)
    ) ; end if
    (setq ls (cdr ls))
  ) ; end while
  (if flg
    (valrev (idxrev ls1) ll (rolrev ls1))
    (valrev (idxrev ls1) ll ls1)
  ) ; end if
) ; end defun

;; updrev: atualiza as tabelas de revisoes ativas
(defun updrev(enm des / cdt cr_data cr_descr cr_proj ss cnt enm ent lay att rst)
  (setq cdt (rtos (getvar "cdate") 2 8))
  (setq
    cr_data  (strcat (substr cdt 7 2) "/" (substr cdt 5 2) "/" (substr cdt 3 2))
    cr_descr (strcase des)
    cr_proj  (getuser)
  ) ; end setq
  (if (not (null enm))
    (progn
      (setq att (attread enm))
      (setq rst (insrev (list cr_data cr_descr cr_proj) att))
      (modrev enm rst)
    ) ; end progn
  ) ; end if
) ; end defun

;; upddat: atualiza o atributo de data da plotagem
(defun upddat(/ cdt cr_arqv cr_data cr_hora cr_info ss cnt enm ent lay att rst)
  (setq cdt (rtos (getvar "cdate") 2 8))
  (setq
    cr_arqv  (getvar "dwgname")
    cr_data  (strcat (substr cdt 7 2) "/" (substr cdt 5 2) "/" (substr cdt 3 2))
    cr_hora  (strcat (substr cdt 10 2) ":" (substr cdt 12 2))
  ) ; end setq
  (setq cr_info (strcat cr_arqv " - " cr_data " - " cr_hora))
  (if (setq ss (ssget "x" '((0 . "INSERT") (8 . "0"))))
    (progn
      (setq cnt (sslength ss))
      (while (>= (setq cnt (- cnt 1)) 0)
        (setq enm (ssname ss cnt))
        (if (assoc "CR_INFO" (attread enm))
          (attvalue enm "CR_INFO" cr_info)
        ) ; end if
      ) ; end while
    ) ; end progn
  ) ; end if
) ; end defun

(princ)
