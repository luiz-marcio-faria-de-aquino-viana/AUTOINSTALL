

;;
;; K35C0.lsp
;; Copyright (C) by Luiz Marcio F A Viana, 2/5/97
;;

;; elevq: rotina para levantamento das cargas eletricas do desenho
;;  qdr - nome do quadro eletrico a ser analisado
(defun elevq(qdr / ilst clst lst ss cnt enm att idx tip chv cir pot lc lq qt)
  (setq lst '())
  (setq
    clst '()
    ilst '()
  ) ; end setq
  (if (setq ss (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))) )
    (progn
      (setq cnt (sslength ss))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq enm (ssname ss cnt))
        (setq att (attread enm))
        (setq idx 0)
        (while (setq tip (cadr (assoc (strcat "#TIPO(" (itoa idx) ")") att)) )
          (if (or (= tip "ECARGA")
                  (= tip "EILUMINACAO")
                  (= tip "EQUADRO")
                  (= tip "ECAMPAINHA")
              ) ; end or
            (if (= (cadr (assoc (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") att)) qdr)
              (progn
                (setq
                  cir (lfill (cadr (assoc (strcat "#CIRCUITO("           (itoa idx) ")") att)) 3 " ")
                  pot (atoi  (cadr (assoc (strcat "#POTENCIA("           (itoa idx) ")") att)))
                ) ; end setq

                (cond
                  ((= tip "EILUMINACAO")
                    (progn
                      (if (null (member pot ilst)) (setq ilst (cons pot ilst)) )
                      (setq chv 0)
                    ) ; end progn
                  ) ; end case
                  ((= tip "ECARGA")
                    (progn
                      (if (null (member pot clst)) (setq clst (cons pot clst)) )
                      (setq chv 1)
                    ) ; end progn
                  ) ; end case
                  (t (setq chv 2))
                ) ; end cond

                (if (setq lc (cdr (assoc cir lst)))
                  (progn
                    ;;
                    ;; se existe o circuito na lista
                    ;;
                    (if (setq lq (cdr (assoc chv lc)))
                      (progn
                        ;;
                        ;; existe cargas do tipo chave
                        ;;
                        (if (setq qt (cdr (assoc pot lq)))
                          (progn
                            ;;
                            ;; existe a potencia
                            ;;
                            (setq lq (subst (cons pot (1+ qt)) (assoc pot lq) lq))
                          ) ; end progn
                          (progn
                            ;;
                            ;; nao existe a potencia
                            ;;
                            (setq lq (cons (cons pot 1) lq))
                          ) ; end progn
                        ) ; end if
                        (setq lc (subst (cons chv lq) (assoc chv lc) lc))
                      ) ; end progn
                      (progn
                        ;;
                        ;; nao existe cargas do tipo chave
                        ;;
                        (setq lc (cons (cons chv (list (cons pot 1))) lc))
                      ) ; end progn
                    ) ; end if
                    (setq lst (subst (cons cir lc) (assoc cir lst) lst))
                  ) ; end progn
                  (progn
                    ;;
                    ;; se nao existe o circuito na lista
                    ;;
                    (setq lst (cons (cons cir (list (cons chv (list (cons pot 1))))) lst) )
                  ) ; end progn
                ) ; end if
              ) ; end progn
            ) ; end if
          ) ; end if
          (setq idx (1+ idx))
        ) ; end while
      ) ; end while
      (if lst (setq lst (list (sort ilst) (sort clst) (sort lst))) )
    ) ; end progn
  ) ; end if
  lst
) ; end defun

;; c:eqdrq: rotina que desenha o quadro eletrico
(defun c:eqdrq()
  ;; definicao dos parametros de desenho do quadro
  (setq
    HTT  (*  3.5 (#SCL))		;; altura do texto do titulo
    HTC  (*  2.0 (#SCL))		;; altura do texto dos campos descricao
    HTD  (*  2.0 (#SCL))          ;; altura do texto de dados
    HLT  (* 10.0 (#SCL))		;; altura da linha de titulo
    HLC1 (*  7.5 (#SCL))		;; altura de cada faixa campos de descricao
    HLC  (*  2.0 HLC1)		;; altura da faixa dos campos de descricao
    HLD  (*  4.0 (#SCL))		;; altura da linha de dados
    HLS  (*  7.5 (#SCL))		;; altura da linha total sumario
    WCL  (* 20.0 (#SCL))		;; largura das colunas
  ) ; end setq

  ;; definicao dos parametros de projeto
  (setq
    NLE 1	;; numero de colunas extras para lampadas
    NTE 1	;; numero de colunas extras para tomadas
    NCE 3	;; numero de circuitos extras
  ) ; end setq

  ;; entrada de dados do programa

  (while (= (setq qdr (getstring "\nNome do quadro: ")) "")
    (prompt "\nERR: Resposta nula nao e valida.") )

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (if (setq ls (elevq qdr))
    (progn

      (setq
        ll (car   ls)		;; lista de lampadas
        lt (cadr  ls)		;; lista de tomadas
        lc (caddr ls)		;; lista de circuitos
      ) ; end setq

      (setq
        tcl (+ (length ll) NLE)		;; total de colunas lampadas
        tct (+ (length lt) NTE)		;; total de colunas tomadas
        tlc (+ (length lc) NCE)		;; total de linhas circuitos
        tc  (+ 1 tcl tct 6)		;; total de colunas
      ) ; end setq

      ;; calcula os quatro vertices para desenho do quadro
      (setq
        p1 pti
        p2 (list (+ (car pti) (* tc WCL)) (cadr pti))
        p3 (list (+ (car pti) (* tc WCL)) (+ (cadr pti) HLT HLC (* tlc HLD) HLS))
        p4 (list (car pti) (+ (cadr pti) HLT HLC (* tlc HLD) HLS))
      ) ; end setq

      ;; calcula os pontos das linhas horizontais principais
      (setq
        p5 (list (car pti) (+ (cadr pti) HLS))
        p6 (list (+ (car pti) (* tc WCL)) (+ (cadr pti) HLS))
      ) ; end setq
      (setq
        p7 (list (car pti) (+ (cadr pti) HLC (* tlc HLD) HLS))
        p8 (list (+ (car pti) (* tc WCL)) (+ (cadr pti) HLC (* tlc HLD) HLS))
      ) ; end setq
      (setq
        p15 (list (+ (car pti) WCL) (+ (cadr pti) HLC1 (* tlc HLD) HLS))
        p16 (list (+ (car pti) WCL (* WCL tcl) (* WCL tct)) (+ (cadr pti) HLC1 (* tlc HLD) HLS))
      ) ; end setq

      ;; calcula os pontos das linhas verticais principais
      (setq
        p9  (list (+ (car pti) WCL) (cadr pti))
        p10 (list (+ (car pti) WCL) (+ (cadr pti) HLC (* tlc HLD) HLS))
      ) ; end setq
      (setq
        p11 (list (+ (car pti) WCL (* WCL tcl)) (cadr pti))
        p12 (list (+ (car pti) WCL (* WCL tcl)) (+ (cadr pti) HLC (* tlc HLD) HLS))
      ) ; end setq
      (setq
        p13 (list (+ (car pti) WCL (* WCL tcl) (* WCL tct)) (cadr pti))
        p14 (list (+ (car pti) WCL (* WCL tcl) (* WCL tct)) (+ (cadr pti) HLC (* tlc HLD) HLS))
      ) ; end setq

      ;; calcula pontos para insercao dos textos
      (setq
        t1  (list (+ (car pti) (/ (* tc WCL) 2.0))
                  (+ (cadr pti) (/ HLT 2.0) HLC (* tlc HLD) HLS) )
        t2  (list (+ (car pti) (/ WCL 2.0))
                  (+ (cadr pti) (/ HLC1 2.0) HLC1 (* tlc HLD) HLS) )
        t3  (list (+ (car pti) WCL (/ (* WCL tcl) 2.0))
                  (+ (cadr pti) (/ HLC1 2.0) HLC1 (* tlc HLD) HLS) )
        t4  (list (+ (car pti) WCL (* WCL tcl) (/ (* WCL tct) 2.0))
                  (+ (cadr pti) (/ HLC1 2.0) HLC1 (* tlc HLD) HLS) )
        t5  (list (+ (car pti) WCL (* WCL tcl) (* WCL tct) (/ WCL 2.0))
                  (+ (cadr pti) (/ HLC1 2.0) HLC1 (* tlc HLD) HLS) )
        t6  (list (+ (car pti) (/ WCL 2.0))
                  (+ (cadr pti) (/ HLS 2.0)) )
        t7  (list (+ (car pti) WCL (/ WCL 2.0))
                  (+ (cadr pti) (/ HLC1 2.0) (* tlc HLD) HLS) )
        t8  (list (+ (car pti) WCL (* tcl WCL) (/ WCL 2.0))
                  (+ (cadr pti) (/ HLC1 2.0) (* tlc HLD) HLS) )
        t9  (list (+ (car pti) HTD)
                  (+ (cadr pti) (/ HTD 2.0) (* (- tlc 1) HLD) HLS) )
        t10 (list (+ (car pti) HTD WCL)
                  (+ (cadr pti) (/ HTD 2.0)) )
        t11 (list (+ (car pti) HTD WCL (* tcl WCL))
                  (+ (cadr pti) (/ HTD 2.0)) )
        t12 (list (+ (car pti) HTD WCL (* (+ tcl tct) WCL))
                  (+ (cadr pti) (/ HTD 2.0)) )
      ) ; end setq

      (setq oldech (acadvar "cmdecho"  0))
      (setq oldblp (acadvar "blipmode" 0))

      ;; desenha os quatro vertices do quadro
      (command ".pline" p1 "w" 0 0 p2 p3 p4 "c")

      ;; desenha as linhas horizontais
      (command
        ".line" p5 p6 ""
        ".line" p7 p8 ""
        ".line" p15 p16 ""
      ) ; end command

      (setq
        pta (list (car p5) (+ (cadr p5) HLD))
        ptb (list (car p6) (+ (cadr p6) HLD))
      ) ; end setq
      (setq n 0)
      (while (< n tlc)
        (command ".line" pta ptb "")
        (setq
          pta (list (car pta) (+ (cadr pta) HLD))
          ptb (list (car ptb) (+ (cadr ptb) HLD))
        ) ; end setq
        (setq n (1+ n))
      ) ; end while

      ;; desenha as linhas verticais
      (command
        ".line" p9  p10 ""
        ".line" p11 p12 ""
        ".line" p13 p14 ""
      ) ; end command

      (setq
        pta (list (+ (car p9)  WCL) (cadr p9))
        ptb (list (+ (car p10) WCL) (- (cadr p10) HLC1))
      ) ; end setq
      (setq n 0)
      (while (< n (- tcl 1))
        (command ".line" pta ptb "")
        (setq
          pta (list (+ (car pta) WCL) (cadr pta))
          ptb (list (+ (car ptb) WCL) (cadr ptb))
        ) ; end setq
        (setq n (1+ n))
      ) ; end while

      (setq
        pta (list (+ (car p11) WCL) (cadr p11))
        ptb (list (+ (car p12) WCL) (- (cadr p12) HLC1))
      ) ; end setq
      (setq n 0)
      (while (< n (- tct 1))
        (command ".line" pta ptb "")
        (setq
          pta (list (+ (car pta) WCL) (cadr pta))
          ptb (list (+ (car ptb) WCL) (cadr ptb))
        ) ; end setq
        (setq n (1+ n))
      ) ; end while

      (setq
        pta (list (+ (car p13) WCL) (cadr p13))
        ptb (list (+ (car p14) WCL) (cadr p14))
      ) ; end setq
      (setq n 0)
      (while (< n 5)
        (command ".line" pta ptb "")
        (setq
          pta (list (+ (car pta) WCL) (cadr pta))
          ptb (list (+ (car ptb) WCL) (cadr ptb))
        ) ; end setq
        (setq n (1+ n))
      ) ; end while

      ;; desenha os textos do titulo e dos campos de descricao
      (command ".text" "m" t1 HTT 0 qdr)
      (command
        ".text" "m" t2                                        HTC 0  "NUMERO"
        ".text" "m" (list (car t2) (- (cadr t2) (* HTC 1.5))) HTC 0    "DO"
        ".text" "m" (list (car t2) (- (cadr t2) (* HTC 3.0))) HTC 0 "CIRCUITO"
      ) ; end command
      (command ".text" "m" t3 HTC 0  "LAMPADAS")
      (command ".text" "m" t4 HTC 0  "TOMADAS")

      (setq
        l1 '( ("TOTAL"     "DE"       "PONTOS")
              ("POTENCIA"  ""         "(VA)"  )
              ("TENSAO"    ""         "(V)"   )
              ("PROTECAO"  ""         "(A)"   )
              ("BITOLA DO" "CONDUTOR" "(mm2)" )
              ("FASE"      ""         ""      ) )
      ) ; end setq
      (setq pta t5)
      (foreach e1 l1
        (command
          ".text" "m" pta                                         HTC 0 (car   e1)
          ".text" "m" (list (car pta) (- (cadr pta) (* HTC 1.5))) HTC 0 (cadr  e1)
          ".text" "m" (list (car pta) (- (cadr pta) (* HTC 3.0))) HTC 0 (caddr e1)
        ) ; end command
        (setq pta (list (+ (car pta) WCL) (cadr pta)) )
      ) ; end foreach

      (command ".text" "m" t6 HTC 0 "TOTAL")

      ;; desenho dos textos das potencias das lampadas
      (setq pta t7)
      (foreach e1 ll
        (command ".text" "m" pta HTC 0 (strcat (itoa e1) " VA"))
        (setq pta (list (+ (car pta) WCL) (cadr pta)) )
      ) ; end foreach

      ;; desenho dos textos das potencias das tomadas
      (setq pta t8)
      (foreach e1 lt
        (command ".text" "m" pta HTC 0 (strcat (itoa e1) " VA"))
        (setq pta (list (+ (car pta) WCL) (cadr pta)) )
      ) ; end foreach

      ;; desenho dos textos de cada circuito
      (setq
        ttpts 0		;; total geral de pontos dos circuito
        ttpot 0		;; total geral de potencia dos circuitos
      ) ; end setq

      (setq ls '())	;; lista das variaveis de totais gerais

      (setq pta t9)
      (foreach e1 lc
        (setq
          tpts 0	;; total de pontos por circuito
          tpot 0	;; total de potencia do circuito
        ) ; end setq

        (setq cir (car e1))
        (command ".text" pta HTC 0 cir)

        ;; desenha os textos das colunas de lampadas
        (setq ptb (list (+ (car pta) WCL) (cadr pta)) )
        (foreach e2 (cdr (assoc 0 (cdr e1)))
          (setq pot (car e2))
          (setq qtd (cdr e2))

          (setq vnm (read (strcat "I$" (itoa pot))) )
          (if (member vnm ls)
            (set vnm (+ (eval vnm) qtd) )
            (progn
              (setq ls (cons vnm ls))
              (set vnm qtd)
            ) ; end progn
          ) ; end if

          (command ".text" (list (+ (car ptb) (* (lpos pot ll) WCL)) (cadr ptb)) HTD 0 (itoa qtd) )
          (setq
            tpts (+ tpts qtd)
            tpot (+ tpot (* pot qtd))
          ) ; end setq
        ) ; end foreach

        ;; desenha os textos das colunas de tomadas
        (setq ptb (list (+ (car pta) WCL (* tcl WCL)) (cadr pta)) )
        (foreach e2 (cdr (assoc 1 (cdr e1)))
          (setq pot (car e2))
          (setq qtd (cdr e2))

          (setq vnm (read (strcat "T$" (itoa pot))) )
          (if (member vnm ls)
            (set vnm (+ (eval vnm) qtd) )
            (progn
              (setq ls (cons vnm ls))
              (set vnm qtd)
            ) ; end progn
          ) ; end if

          (command ".text" (list (+ (car ptb) (* (lpos pot lt) WCL)) (cadr ptb)) HTD 0 (itoa qtd) )
          (setq
            tpts (+ tpts qtd)
            tpot (+ tpot (* pot qtd))
          ) ; end setq
        ) ; end foreach

        (command ".text" (list (+ (car pta) WCL (* (+ tcl tct) WCL))     (cadr pta)) HTD 0 (itoa tpts) )
        (command ".text" (list (+ (car pta) WCL (* (+ tcl tct) WCL) WCL) (cadr pta)) HTD 0 (itoa tpot) )

        (setq
          ttpts (+ ttpts tpts)
          ttpot (+ ttpot tpot)
        ) ; end setq

        (setq pta (list (car pta) (- (cadr pta) HLD)) )
      ) ; end foreach

      (setq pta t10)
      (foreach e1 ll
        (setq vnm (read (strcat "I$" (itoa e1))) )
        (if (member vnm ls)
          (command ".text" pta HTD 0 (eval vnm)) )
        (setq pta (list (+ (car pta) WCL) (cadr pta)) )
      ) ; end foreach

      (setq pta t11)
      (foreach e1 lt
        (setq vnm (read (strcat "T$" (itoa e1))) )
        (if (member vnm ls)
          (command ".text" pta HTD 0 (eval vnm)) )
        (setq pta (list (+ (car pta) WCL) (cadr pta)) )
      ) ; end foreach

      (command
        ".text" t12                                 HTD 0 (itoa ttpts)
        ".text" (list (+ (car t12) WCL) (cadr t12)) HTD 0 (itoa ttpot)
      ) ; end command

      (foreach e1 ls (set e1 nil) )

      (setvar "blipmode" oldblp)
      (setvar "cmdecho"  oldech)
    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

(princ)
