
;;
;; K5EC0.lsp
;;
;; Copyright (C) 1996 by Paulo Lincoln de Oliveira, 5/5/96
;;

;; lerA(): funcao que obtem distancia entre centro de tubo e parede da caixa
;;  b1 - bitola do eletroduto
(defun lerA( b1 / TAB_A)
  (setq TAB_A '( ("1/2" 27) ("3/4" 31) ("1" 35) ("1-1/4" 41) ("1-1/2" 43) ("2" 53) ("2-1/2" 58) ("3" 67) ("3-1/2" 74) ("4" 84)))
  (cadr (assoc b1 TAB_A))
) ; end defun

;; lerB(): funcao que obtem distancia entre centros de tubos adjacentes
;;  b1 - bitola do primeiro eletroduto
;;  b2 - bitola do segundo eletroduto
(defun lerB( b1 b2 / TAB_B rst)
  (setq
    TAB_B '( ("1/2"   (("1/2"    32) ("3/4"    36) ("1"      41) ("1-1/4"  47) ("1-1/2"  49) ("2"      58) ("2-1/2"  64) ("3"     73) ("3-1/2" 81) ("4" 90)))
             ("3/4"   (("3/4"    40) ("1"      45) ("1-1/4"  51) ("1-1/2"  53) ("2"      62) ("2-1/2"  68) ("3"      77) ("3-1/2" 85) ("4"     94))) 
             ("1"     (("1"      50) ("1-1/4"  56) ("1-1/2"  58) ("2"      67) ("2-1/2"  73) ("3"      82) ("3-1/2"  90) ("4"     99)))
             ("1-1/4" (("1-1/4"  62) ("1-1/2"  84) ("2"      73) ("2-1/2"  79) ("3"      88) ("3-1/2"  96) ("4"     105)))
             ("1-1/2" (("1-1/2"  66) ("2"      75) ("2-1/2"  81) ("3"      90) ("3-1/2"  98) ("4"     107)))
             ("2"     (("2"      84) ("2-1/2"  90) ("3"      99) ("3-1/2" 107) ("4"     116)))
             ("2-1/2" (("2-1/2"  96) ("3"     105) ("3-1/2" 113) ("4"     122)))
             ("3"     (("3"     114) ("3-1/2" 122) ("4"     131)))
             ("3-1/2" (("3-1/2" 130) ("4"     139)))
             ("4"     (("4"     148)))
           )
  ) ; end setq
  (or
    (setq rst (cadr (assoc b2 (cadr (assoc b1 TAB_B)))) )
    (setq rst (cadr (assoc b1 (cadr (assoc b2 TAB_B)))) )
  ) ; end or
  rst
) ; end defun

;; ord_list(): funcao que insere um elemento na lista de forma ordenada
(defun ord_list( tipo num ls / laux )
  (setq laux '( ("1/2" 0.5) ("3/4" 0.75) ("1" 1.0) ("1 1/4" 1.25) ("1 1/2" 1.5) ("2" 2.0) ("2 1/2" 2.5) ("3" 3.0) ("3 1/2" 3.5) ("4" 4.0))) 
  (if ls
    (if ( <= (assoc tipo laux) (assoc (car (car ls)) laux))
      (append (list (list tipo num)) ls)
      (append (list (list (car (car ls)) (cadr (car ls)) )) (ord_list tipo num (cdr ls)))
    ) ; end if
    (list (list tipo num))
  ) ; end if
) ; end defun

;; caltcx(): funcao que calcula a altura da caixa de passagem    
(defun caltcx( prv cam ls / elem)
  (if (and ls (> cam 0))
    (progn
      (setq elem (car ls))
      (if (> (cadr elem) cam)
        (if prv
          (+ (lerB (car prv) (car elem))
             (* (- cam 1) (lerB (car elem) (car elem)))
             (caltcx elem (- cam (cadr elem)) (cdr ls))
          )
          (+ (lerA (car elem))
             (* (- cam 1) (lerB (car elem) (car elem)))
             (caltcx elem (- cam (cadr elem)) (cdr ls))
          )
        ) ; end if
        (if prv
          (+ (lerB (car prv) (car elem))
             (* (- (cadr elem) 1) (lerB (car elem) (car elem)))
             (caltcx elem (- cam (cadr elem)) (cdr ls))
          )
          (+ (lerA (car elem))
             (* (- (cadr elem) 1) (lerB (car elem) (car elem)))
             (caltcx elem (- cam (cadr elem)) (cdr ls))
          )
        ) ; end if
      ) ; end if
    ) ; end progn
    (if prv (lerA (car prv)) 0)
  ) ; end if
) ; end defun

;; c:ccaixa(): rotina para calcular as dimensoes de uma caixa de passagem
(defun c:ccaixa( / lista tdut tipb qtde b1 n1 b2 n2 result elem cam dimf alt)
  (setq oldmnu (ai_svar "promptmenu" 1))

  ;; entrada da lista de eletrodutos com as respectivas quantidades
  (setq lista '())
  (setq tdut 0)
  (while (progn
           (initget "1/2 3/4 1 1-1/4 1-1/2 2 2-1/2 3 3-1/2 4")
           (setq tipb (getkword "\nBitola do eletroduto (ENTER=Termina): "))
         ) ; end progn
    (initget 6 "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15")
    (setq qtde (getint "\nQuantidade <1>: "))
    (if (= (type qtde) 'STR)
      (setq qtde (atoi qtde))
      (if (null qtde) (setq qtde 1))
    ) ; end if
    (setq tdut (+ tdut qtde))
    (setq lista (ord_list tipb qtde lista))
  ) ; end while
  
  ;; calculo da dimensao linear da caixa de passagem
  (if lista
    (progn
      ;; adicao do primeiro elemento e sua repeticao
      (setq
        b1 (car  (car lista))
        n1 (cadr (car lista))
      ) ; end setq
      (setq result (+ (lera b1) (* (lerb b1 b1) (- n1 1))) )
      ;; adicao dos elementos subsequentes e suas repeticoes
      (foreach elem (cdr lista)
        (progn
          (setq
            b2 (car  elem)
            n2 (cadr elem)
          ) ; end setq
          (setq result (+ result (lerb b1 b2) (* (lerb b2 b2) (- n2 1))) )
          (setq b1 b2)
        ) ; end progn
      ) ; end foreach
      ;; adicao do ultimo elemento
      (setq result (+ result (lera (car (last lista)))) )
    ) ; end progn
  ) ; end if

  ;; laco para entrada do numero de camadas
  (setq cam 1)
  (setq dimf result)
  (while cam
    (prompt (strcat "\nNumero de camadas = " (itoa cam) ", Comprimento da caixa = " (rtos dimf 2 0) " mm"))
    (setq alt (caltcx nil cam lista))
    (prompt (strcat "\nAltura da caixa = " (rtos alt 2 0) " mm"))
    (setq cam (getint "\nNovo numero de camadas (ENTER=Termina): "))
    (if cam
      (if (<= cam tdut)
        (setq dimf (/ result cam))
        (progn
          (prompt "\nERR: Numero de camadas maior que numero de eletrodutos.")
          (getstring "\nQualquer tecla para prosseguir...")
        ) ; end progn
      ) ; end if
    ) ; end if
  ); end while

  (setvar "promptmenu" oldmnu)
  (princ)
) ; end defun

(princ)
