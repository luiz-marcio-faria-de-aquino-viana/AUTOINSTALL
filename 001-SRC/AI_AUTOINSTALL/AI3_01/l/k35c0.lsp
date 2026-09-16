
;;
;; K35C0.lsp
;; Copyright (C) by Luiz Marcio F A Viana, 2/5/97
;;

;; definicao das variaveis globais
(or #VFASE (setq #VFASE 220.0) )      ;; tensao fase-fase do projeto
(or #BTMIN (setq #BTMIN "2.5") )      ;; bitola nominal minima do condutor
(or #TEMP  (setq #TEMP   30.0) )      ;; temperatura ambiente

;; eqdc_ftemp(): funcao que calcula o fator de correcao por temperatura
;;  te - temperatura ambiente
(defun eqdc_ftemp(te / TTEMP i n)
  ;;
  ;; tabela de fatores de correcao de temperatura para condutores de isolamento de PVC 70C (k1)
  ;;
  (setq
    TTEMP '( (10.0 1.20) (15.0 1.15)
             (20.0 1.10) (25.0 1.05)
             (35.0 0.95) (40.0 0.85)
             (45.0 0.80) (50.0 0.70)
             (55.0 0.60) (60.0 0.50) )
  ) ; end setq

  (setq TTEMP (append TTEMP (list (list (+ te te) 0.50))) )

  (setq i 0)
  (while (> te (car (nth i TTEMP))) (setq i (1+ i)) )
  (cadr (nth i TTEMP))
) ; end defun

;; eqdc_bitcond(): funcao que calcula a bitola do condutor aplicando a tabela capacidade de corrente
;;  nf - numero de condutores carregados (2 ou 3)
;;  cc - corrente do circuito
;;  dj - disjuntor de protecao
(defun eqdc_bitcond(nf cc dj / TCC i)
  ;;
  ;; tabela da capacidade de corrente para cabos de cobre isolados
  ;;       com PVC 70C instalados em eletrodutos embutidos
  ;; formato: '( (bitola_condutor capacidade_2condutores capacidade_3condutores disjuntor_protecao) ... )
  ;;
  (setq
    TCC '( (  1.5  17.5  15.5) (  2.5  24.0  21.0) (  4.0  32.0  28.0)
           (  6.0  41.0  36.0) ( 10.0  57.0  50.0) ( 16.0  76.0  68.0)
           ( 25.0 101.0  89.0) ( 35.0 125.0 111.0) ( 50.0 151.0 134.0)
           ( 70.0 192.0 171.0) ( 95.0 232.0 207.0) (120.0 269.0 239.0)
           (150.0 309.0 272.0) (185.0 353.0 310.0) (240.0 415.0 364.0)
           (300.0 473.0 429.0) (400.0 566.0 502.0) (500.0 651.0 578.0) )
  ) ; end setq

  (setq TCC (append TCC (list (list 500.0 (+ cc cc) (+ cc cc)))) )

  (setq i 0)
  (while (or (and (<= nf 2) (> cc (cadr (nth i TCC)))) (and (= nf 3) (> cc (caddr (nth i TCC)))) ) (setq i (1+ i)) )
  (if (or (and (<= nf 2) (> dj (cadr (nth i TCC)))) (and (= nf 3) (> dj (caddr (nth i TCC)))) )
    (car (nth (1+ i) TCC))
    (car (nth      i TCC))
  ) ; end if
) ; end defun

;; eqdc_bitprot(): funcao que calcula a bitola do condutor de protecao
;;  btq - bitola do condutor fase
(defun eqdc_bitprot(btq / TPR btq)
  (setq
    TPR '( ( 35.0  25.0)
           ( 50.0  25.0)
           ( 70.0  35.0)
           ( 95.0  50.0)
           (120.0  70.0)
           (150.0  70.0)
           (185.0  95.0)
           (240.0 120.0) )
  ) ; end setq
  (if (> btq 25.0)
    (if (setq bpq (cadr (assoc btq TPR)) )
      bpq
      150.0
    ) ; end if
    btq
  ) ; end if
) ; end defun

;; eqdc_protecao(): funcao que calcula o disjuntor de protecao
;;  cc - corrente do circuito
(defun eqdc_protecao(cc / TDISJ i n)
  ;;
  ;; tabela de disjuntores de protecao
  ;;
  (setq TDISJ '(10 15 20 25 30 35 40 50 60 70 75 100 125 150 175 200 225 250 300 350 400 450 500))

  (setq i 0)
  (setq n (length TDISJ))
  (while (and (< i n) (> cc (nth i TDISJ)) ) (setq i (1+ i)) )
  (if (< i n) (nth i TDISJ) 500.0)
) ; end defun

;; eqdc_eqfases(): funcao que retorna uma lista de distribuicao das fases pelos circuitos
;;  nf - numero maximo de condutores carregados admissivel
;;  ls - lista de circuitos que serao equilibradas
;; formato: '( (NF1 POT1 CIR1) (NF2 POT2 CIR2) ... (NFn POTn CIRn) )
;; onde NFn=numero de condutores carregados
;;      POTn=potencia do circuito
;;      CIRn=identificacao do circuito
(defun eqdc_eqfases(nf ls / potr pots pott lr is nf1 pot1 cir1 fas1)
  (setq
    potr 0
    pots 0
    pott 0
  ) ; end setq

  (setq lr '())

  (foreach is (reverse (xsort2 ls))
    (progn
      (setq
        nf1  (car   is)
        pot1 (cadr  is)
        cir1 (caddr is)
      ) ; end setq
      (cond
        ( (> nf1 nf) (setq fas1 "* ERROR *") )
        ( (= nf1 3)  (setq fas1 "RST") )
        ( (= nf1 2)
          (if (= nf1 nf)
            (setq fas1 "RS")
            (if (and (> potr pots) (> potr pott))
              (setq
                fas1 "ST"
                pots (+ pot1 pots)
                pott (+ pot1 pott)
              ) ; end setq
              (if (and (> pots potr) (> pots pott))
                (setq
                  fas1 "TR"
                  potr (+ pot1 potr)
                  pott (+ pot1 pott)
                ) ; end setq
                (setq
                  fas1 "RS"
                  potr (+ pot1 potr)
                  pots (+ pot1 pots)
                ) ; end setq
              ) ; end if
            ) ; end if
          ) ; end if
        ) ; end case
        ( (= nf1 1)
          (progn
            (if (= nf1 nf)
              (setq fas1 "R")
              (if (or (= nf 1) (and (= nf 2) (<= potr pots)) (and (<= potr pots) (<= potr pott)) )
                (setq
                  fas1 "R"
                  potr (+ pot1 potr)
                ) ; end setq
                (if (or (= nf 2) (and (<= pots potr) (<= pots pott)) )
                  (setq
                    fas1 "S"
                    pots (+ pot1 pots)
                  ) ; end setq
                  (setq
                    fas1 "T"
                    pott (+ pot1 pott)
                  ) ; end setq
                ) ; end if
              ) ; end if
            ) ; end if
          ) ; end progn
        ) ; end case
      ) ; end cond
      (setq lr (cons (list cir1 fas1) lr))
    ) ; end progn
  ) ; end if
  lr
) ; end defun

;; eqdc_lsquadros(): funcao que lista todos os quadros do desenho
(defun eqdc_lsquadros(/ ss ls cnt enm idx att qdr org itm)
  (if (setq ss (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))) )
    (progn
      (setq ls '())
      (setq cnt (sslength ss))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq enm (ssname ss cnt))
        (setq idx 0)
        (while (etipo enm idx)
          (setq att (attread enm))
          (if (= (cadr (assoc (strcat "#TIPO(" (itoa idx) ")") att)) "EQUADRO")
            (progn
              (setq
                qdr (strcase (cadr (assoc (strcat "#NOME_QUADRO(" (itoa idx) ")") att)))
                org (strcase (cadr (assoc (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") att)))
              ) ; end setq
              (setq ls (append ls (list (list qdr org))) )
            ) ; end progn
          ) ; end if
          (setq idx (1+ idx))
        ) ; end while
      ) ; end while

      (prompt "\nNOME DO QUADRO            QUADRO DE ORIGEM         ")
      (prompt "\n========================= =========================")
      (foreach itm (xsort ls)
        (prompt (strcat "\n" (rfill (substr (car itm) 1 25) 25 " ") " " (rfill (substr (cadr itm) 1 25) 25 " ")) )
      ) ; end foreach
    ) ; end progn
    (prompt "\nERR: Nao existem objetos eletricos no desenho.")
  ) ; end if
) ; end defun

;; eqdc_lvquadro(): funcao que retorna uma lista com os elementos dos quadros
;;  qdr - nome do quadro que sera analisado
;; formato: '( POTq FASq (C1 F1 ( (TIP1 ((P1 N1) (P2 N2) ... (Pn Nn)) )
;;                             (TIP2 ((P1 N1) (P2 N2) ... (Pn Nn)) )
;;                               :
;;                             (TIPn ((P1 N1) (P2 N2) ... (Pn Nn)) ) )
;;                       )
;;                         :
;;                       (Cn Fn ( (TIP1 ((P1 N1) (P2 N2) ... (Pn Nn)) )
;;                             (TIP2 ((P1 N1) (P2 N2) ... (Pn Nn)) )
;;                               :
;;                             (TIPn ((P1 N1) (P2 N2) ... (Pn Nn)) ) )
;;                       ) ... )
;;           )
;;  onde POTq=potencia do quadro,
;;       FASq=sistema de fases do quadro,
;;       Cn=identificador do circuito,
;;       Fn=sistema de fases do circuito,
;;       TIPn=tipo da carga,
;;       Pn=potencia da carga,
;;       Nn=quantidade da carga
(defun eqdc_lvquadro(qdr / ls lc lt lp ss cnt idx enm att org1 qdr1 pot1 cir1 tip1 potd potc potcq potdq potq fasq)
  (setq ls '())
  (if (setq ss (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))) )
    (progn
      (setq cnt (sslength ss))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq
          enm (ssname ss cnt)
          att (attread enm)
        ) ; end setq
        (setq idx 0)
        (while (setq org1 (cadr (assoc (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") att)) )
          (setq qdr1 (cadr (assoc (strcat "#NOME_QUADRO(" (itoa idx) ")") att)) )
          (if (and (= qdr org1) (/= qdr qdr1))
            (progn
              (setq
                potd (cadr (assoc (strcat "#POTENCIA_DEMANDADA(" (itoa idx) ")") att))
                potc (cadr (assoc (strcat "#POTENCIA(" (itoa idx) ")") att))
              ) ; end setq
              (if (or potd potc)
                (progn
                  (setq
                    tip1 (cadr (assoc (strcat "#TIPO(" (itoa idx) ")") att))
                    cir1 (cadr (assoc (strcat "#CIRCUITO(" (itoa idx) ")") att))
                    fas1 (cadr (assoc (strcat "#SISTEMA(" (itoa idx) ")") att))
                  ) ; end setq
                  (if (or (null potd) (equal (atof potd) 0.0 0.000001))
                    (setq pot1 potc)
                    (setq pot1 potd)
                  ) ; end if
                  (if (setq lc (caddr (assoc cir1 ls)) )
                    (progn
                      (if (setq lt (cadr (assoc tip1 lc)) )
                        (progn
                          (if (setq lp (cadr (assoc pot1 lt)) )
                            (setq lt (subst (list pot1 (1+ lp)) (assoc pot1 lt) lt))
                            (setq lt (cons (list pot1 1) lt) )
                          ) ; end if
                          (setq lc (subst (list tip1 lt) (assoc tip1 lc) lc))
                        ) ; end progn
                        (setq lc (cons (list tip1 (list (list pot1 1)) ) lc))
                      ) ; end if
                      (setq ls (subst (list cir1 fas1 lc) (assoc cir1 ls) ls))
                    ) ; end progn
                    (setq ls (cons (list cir1 fas1 (list (list tip1 (list (list pot1 1)) )) ) ls))
                  ) ; end if
                ) ; end progn
              ) ; end if
            ) ; end progn
            (if (= qdr qdr1)
              (progn
                (setq
                  potdq (cadr (assoc (strcat "#POTENCIA_DEMANDADA(" (itoa idx) ")") att))
                  potcq (cadr (assoc (strcat "#POTENCIA(" (itoa idx) ")") att))
                ) ; end setq
                (if (or potdq potcq)
                  (progn
                    (setq fasq (cadr (assoc (strcat "#SISTEMA(" (itoa idx) ")") att)) )
                    (if (or (null potdq) (equal (atof potdq) 0.0 0.000001))
                      (setq potq (atof potcq))
                      (setq potq (atof potdq))
                    ) ; end if
                  ) ; end progn
                ) ; end if
              ) ; end progn
            ) ; end if
          ) ; end if
          (setq idx (1+ idx))
        ) ; end while
      ) ; end while
      (setq ls (append (list potq fasq) ls))
    ) ; end progn
    (prompt "\nERR: Nao existem objetos eletricos no desenho.")
  ) ; end if
  ls
) ; end defun

;; eqdc_dmquadro(): funcao de dimensionamento do quadro de cargas
;;  potdq - potencia demandada do quadro (nil=nao definida)
;;  fasq  - sistema de fases do quadro
;;  vfase - tensao fase-fase do projeto
;;  btmin - bitola minima do condutor
;;  temp  - temperatura ambiente
;;  fred  - fator de reducao por agrupamento
;;  lscar - lista de cargas do quadro
;; formato: '(POTt Vt BTt BNt PROTt FASt (C1 POT1 V1 BT1 PROT1 A1) ... (Cn POTn Vn BTn PROTn An) )
;;  onde POTt=potencia total do quadro,
;;       Vt=tensao de alimentacao do quadro,
;;       BTt=bitola do condutor alimentador do quadro,
;;       BPt=bitola do condutor de protecao do quadro,
;;       PROTt=disjuntor de protecao do quadro,
;;       FASt=distribuicao de fases do quadro
;;       Cn=identificador do circuito,
;;       POT1=potencia total do circuito,
;;       V1=tensao do circuito,
;;       BTn=bitola do condutor,
;;       PROTn=disjuntor de projecao,
;;       A1=distribuicao das fases
(defun eqdc_dmquadro(vfase btmin temp fred lscar / ls lr cir1 fas1 pot1 cor1 bit1 prt1 ftmp lc lt lp pot1 fas1 vf1 nf1 potq potdq fasq vfq nfq btq protq corq fsq)

  (setq
    ls '()
    lr '()
  ) ; end setq

  (setq ftmp (eqdc_ftemp temp))

  (setq
    potq  (car  lscar)
    fasq  (cadr lscar)
  ) ; end setq

  (foreach lc (cddr lscar)
    (progn
      (setq
        cir1 (car lc)
        fas1 (cadr lc)
        pot1 0
      ) ; end setq

      (foreach lt (caddr lc)
        (foreach lp (cadr lt)
          (setq pot1 (+ pot1 (* (atof (car lp)) (cadr lp))) )
        ) ; end foreach
      ) ; end foreach

      (cond
        ( (or (= fas1 "F+N") (= fas1 "F+N+T"))
          (setq
            vf1  (/ vfase (sqrt 3.0))
            cor1 (/ (/ pot1 vf1) (* ftmp fred))
            nf1 1
        ) ) ; end setq, case
        ( (or (= fas1 "2F") (= fas1 "2F+N") (= fas1 "2F+T") (= fas1 "2F+N+T"))
          (setq
            vf1  vfase
            cor1 (/ (/ pot1 vf1) (* ftmp fred))
            nf1 2
        ) ) ; end setq, case
        ( (or (= fas1 "3F") (= fas1 "3F+N") (= fas1 "3F+T") (= fas1 "3F+N+T"))
          (setq
            vf1  vfase
            cor1 (/ (/ pot1 vf1 (sqrt 3.0)) (* ftmp fred))
            nf1 3
        ) ) ; end setq, case
      ) ; end cond

      (setq
        prt1 (eqdc_protecao cor1)
        bit1 (eqdc_bitcond nf cor1 prt1)
      ) ; end setq
      (if (< bit1 btmin) (setq bit1 btmin))

      (setq
        ls (cons (list nf1 pot1 cir1) ls)
        lr (cons (list cir1 pot1 vf1 bit1 prt1) lr)
      ) ; end setq
    ) ; end progn
  ) ; end foreach

  (cond
    ( (or (= fasq "F+N")  (= fasq "F+N+T")  )
      (setq
        vfq  (/ vfase (sqrt 3.0))
        corq (/ (/ potq vfq) (* ftmp fred))
        nfq  1
        fsq  "R"
    ) ) ; end setq, case
    ( (or (= fasq "2F")   (= fasq "2F+N")
          (= fasq "2F+T") (= fasq "2F+N+T") )
      (setq
        vfq  vfase
        corq (/ (/ potq vfq) (* ftmp fred))
        nfq  2
        fsq  "RS"
    ) ) ; end setq, case
    ( (or (= fasq "3F")   (= fasq "3F+N")
          (= fasq "3F+T") (= fasq "3F+N+T") )
      (setq
        vfq  vfase
        corq (/ (/ potq vfq (sqrt 3.0)) (* ftmp fred))
        nfq  3
        fsq  "RST"
    ) ) ; end setq, case
  ) ; end cond

  (foreach is (eqdc_eqfases nfq ls)
    (progn
      (setq ir (assoc (car is) lr))
      (setq lr (subst (append ir (cdr is)) ir lr))
    ) ; end progn
  ) ; end foreach

  (setq
    prtq (eqdc_protecao corq)
    bitq (eqdc_bitcond nfq corq prtq)
  ) ; end setq
  (if (< bitq btmin) (setq bitq btmin))

  (list potq vfq bitq (eqdc_bitprot bitq) prtq fsq lr)
) ; end defun

;; eqdc_lstipo(): funcao que retorna uma lista com as potencias associadas aos elementos do tipo identificado
;;  tip - identificador do tipo de elemento
;;  lc  - lista de circuitos e cargas
(defun eqdc_lstipo(tip lc / lt it ls)
  (setq ls '())
  (foreach lt lc
    (foreach it (cadr (assoc tip (caddr lt)))
      (if (setq lp (assoc (atoi (car it)) ls))
        (setq ls (subst (list (atoi (car it)) (+ (cadr lp) (cadr it))) (assoc (atoi (car it)) ls) ls))
        (setq ls (cons (list (atoi (car it)) (cadr it)) ls))
      ) ; end if
    ) ; end foreach
  ) ; end foreach
  (xsort ls)
) ; end defun

;; eqdc_param(): funcao de inicializacao dos parametros do quadro
;;  obs: constantes globais no escopo do programa
(defun eqdc_param()
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
) ; end defun

;; eqdc_dsquadro(): funcao de desenho parametrizado do quadro de cargas
;;  pti - ponto de insercao do quadro de  cargas
;;  qdr - nome do quadro de cargas
;;  nc  - numero de circuitos
;;  nl  - numero de potencias diferentes para iluminacao
;;  nt  - numero de potencias diferentes para tomadas
(defun eqdc_dsquadro(pti qdr nc nl nt / TTAB nt nl tc pt0 itm)

  ;; definicao da tabela de titulo dos campos
  ;; formato: '( (STR_TOP1 STR_MIDDLE1 STR_BOTTON1)
  ;;             (STR_TOP2 STR_MIDDLE2 STR_BOTTON2)
  ;;               :
  ;;             (STR_TOPn STR_MIDDLEn STR_BOTTONn)
  (setq
    TTAB '( ("TOTAL"     "DE"       "PONTOS")
            ("POTENCIA"  ""         "VA"    )
            ("TENSAO"    ""         "V"     )
            ("PROTECAO"  ""         "A"     )
            ("BITOLA DO" "CONDUTOR" "mm2"   )
            ("FASE"      ""         ""      ) )
  ) ; end setq

  (setq tc (+ 1 nl nt 6))      ;; total de colunas

  ;; desenho das linhas de contorno do quadro
  (command
    ".pline"
      pti "w" 0 0
      (list (+ (car pti) (* tc WCL)) (cadr pti))
      (list (+ (car pti) (* tc WCL)) (+ (cadr pti) HLT HLC (* nc HLD) HLS))
      (list (car pti) (+ (cadr pti) HLT HLC (* nc HLD) HLS))
      "c"
  ) ; end command

  ;; desenha as linhas verticais principais
  (command
    ".pline"
      (list (+ (car pti) WCL) (cadr pti)) "w" 0 0
      (list (+ (car pti) WCL) (+ (cadr pti) HLC (* nc HLD) HLS))
      ""
  ) ; end command
  (setq pt0 (list (+ (car pti) (* (+ 1 nl nt) WCL)) (cadr pti)) )
  (repeat 6
    (progn
      (command
        ".pline"
          pt0 "w" 0 0
          (list (car pt0) (+ (cadr pt0) HLC (* nc HLD) HLS))
          ""
      ) ; end command
      (setq pt0 (list (+ (car pt0) WCL) (cadr pt0)) )
    ) ; end progn
  ) ; end repeat

  ;; desenha as linhas verticais para as cargas de iluminacao e tomadas
  (setq pt0 (list (+ (car pti) (* 2 WCL)) (cadr pti)) )
  (repeat (- (+ nl nt) 1)
    (progn
      (command
        ".pline"
          pt0 "w" 0 0
          (list (car pt0) (+ (cadr pt0) HLC1 (* nc HLD) HLS))
          ""
      ) ; end command
      (setq pt0 (list (+ (car pt0) WCL) (cadr pt0)) )
    ) ; end progn
  ) ; end repeat

  ;; desenha a linha de divisao entre iluminacao e tomada
  (command
    ".pline"
      (list (+ (car pti) (* (+ 1 nl) WCL)) (+ (cadr pti) HLC1 (* nc HLD) HLS)) "w" 0 0
      (list (+ (car pti) (* (+ 1 nl) WCL)) (+ (cadr pti) HLC (* nc HLD) HLS))
      ""
  ) ; end command

  ;; desenha as linhas horizontais dos circuitos
  (setq pt0 (list (car pti) (+ (cadr pti) HLS)) )
  (repeat (+ nc 1)
    (progn
      (command
        ".pline"
          pt0 "w" 0 0
          (list (+ (car pt0) (* tc WCL)) (cadr pt0))
          ""
      ) ; end command
      (setq pt0 (list (car pt0) (+ (cadr pt0) HLD)) )
    ) ; end progn
  ) ; end repeat

  ;; desenha a linha horizontal do campo lampadas e tomadas
  (command
    ".pline"
      (list (+ (car pti) WCL) (+ (cadr pti) (+ HLC1 (* nc HLD) HLS))) "w" 0 0
      (list (+ (car pti) (* (+ 1 nl nt) WCL)) (+ (cadr pti) (+ HLC1 (* nc HLD) HLS))) "w" 0 0
      ""
  ) ; end command

  ;; desenha a linha horizontal do titulo
  (command
    ".pline"
    (list (car pti) (+ (cadr pti) HLC (* nc HLD) HLS)) "w" 0 0
    (list (+ (car pti) (* tc WCL)) (+ (cadr pti) HLC (* nc HLD) HLS))
    ""
  ) ; end command

  ;; insere os textos na area de titulo dos campos
  (setq pt0 (list (+ (car pti) (/ WCL 2.0)) (+ (cadr pti) HLC1 (* nc HLD) HLS)) )
  (command
    ".text" "m" (list (car pt0) (+ (cadr pt0) (/ HLC1 2.0))) HTC 0  "NUMERO"
    ".text" "m" (list (car pt0) (cadr pt0)) HTC 0                     "DO"
    ".text" "m" (list (car pt0) (- (cadr pt0) (/ HLC1 2.0))) HTC 0 "CIRCUITO"
  ) ; end command
  (command
    ".text"
      "m"
      (list (+ (car  pt0) (* (+ 0.5 (/ nl 2.0)) WCL)) (+ (cadr pt0) (/ HLC1 2.0)) )
      HTC
      0
      "LAMPADAS"
    ".text"
      "m"
      (list (+ (car pt0) (* (+ 0.5 nl (/ nt 2.0)) WCL)) (+ (cadr pt0) (/ HLC1 2.0)) )
      HTC
      0
      "TOMADAS"
  ) ; end command

  (setq pt0 (list (+ (car pt0) (* (+ 1 nl nt) WCL)) (cadr pt0)) )
  (foreach itm TTAB
    (command
      ".text" "m" (list (car pt0) (+ (cadr pt0) (/ HLC1 2.0))) HTC 0 (car itm)
      ".text" "m" pt0 HTC 0 (cadr itm)
      ".text" "m" (list (car pt0) (- (cadr pt0) (/ HLC1 2.0))) HTC 0 (caddr itm)
    ) ; end command
    (setq pt0 (list (+ (car pt0) WCL) (cadr pt0)) )
  ) ; end foreach

  ;; insere texto na area de titulo
  (command
    ".text"
      "m"
      (list (+ (car pti) (/ (* tc WCL) 2.0)) (+ (cadr pti) (/ HLT 2.0) HLC (* nc HLD) HLS) )
      HTT
      0
      qdr
  ) ; end command

  ;; insere texto de totalizacao na area de sumario
  (command
    ".text"
      "m"
      (list (+ (car pti) (/ WCL 2.0)) (+ (cadr pti) (/ HLS 2.0)) )
      HTC
      0
      "TOTAL"
  ) ; end command

  (princ)
) ; end defun

;; eqdc_qdrauto(): funcao de pre-processamento do quadro automatico
;;  pti   - ponto de insercao do quadro de  cargas
;;  qdr   - nome do quadro de cargas
;;  lscar - lista de cargas levantadas do quadro
;;  lsdim - lista de resultado do dimensionamento
(defun eqdc_qdrauto(pti qdr lscar lsdim / oldecho oldblip HTT HTC HTD HLT HLC1 HLC HLD HLS WCL NLE NTE NCE lt ll nc nt nl
  pt0 it numq potq lc1 lc2 cir1 pot1 vf1 bt1 prot1 fas1 num1 lt1 tip1 it1 potc1 numc1 potdq vfq btq bpq protq fasq)

  (eqdc_param)        ;; inicializacao dos parametros do quadro

  (setq
    lt (eqdc_lstipo "ECARGA" (cddr lscar))           ;; lista das diferentes potencias de tomadas
    ll (eqdc_lstipo "EILUMINACAO" (cddr lscar))      ;; lista das diferentes potencias de luminarias
  ) ; end setq

  (setq
    nc (+ (length (cddr lscar)) NCE)      ;; numero de circuitos
    nt (+ (length lt) NTE)                ;; numero de tomadas
    nl (+ (length ll) NLE)                ;; numero de luminarias
  ) ; end setq

  (setq
    oldecho (acadvar "cmdecho" 0)
    oldblip (acadvar "blipmode" 0)
  ) ; end setq

  (command ".undo" "g")

  (eqdc_dsquadro pti qdr nc nl nt)              ;; desenha o quadro de cargas

  ;; insere texto de titulo dos campos de potencia de iluminacao e o total sumario
  (setq pt0 (list (+ (car pti) (* 1.5 WCL)) (+ (cadr pti) (/ HLC1 2.0) (* nc HLD) HLS)) )
  (foreach it ll
    (progn
      (command
        ".text" "m" pt0 HTC 0 (itoa (car it))
        ".text" "m" (list (car pt0) (+ (cadr pti) (/ HLS 2.0))) HTC 0 (itoa (cadr it))
      ) ; end command
      (setq pt0 (list (+ (car pt0) WCL) (cadr pt0)) )
    ) ; end progn
  ) ; end foreach

  ;; insere texto de titulo dos campos de potencia de tomadas
  (setq
    pt0  (list (+ (car pti) (* (+ 1 nl 0.5) WCL)) (+ (cadr pti) (/ HLC1 2.0) (* nc HLD) HLS))
    numq 0
    potq 0
  ) ; end setq
  (foreach it lt
    (progn
      (command
        ".text" "m" pt0 HTC 0 (itoa (car it))
        ".text" "m" (list (car pt0) (+ (cadr pti) (/ HLS 2.0))) HTC 0 (itoa (cadr it))
      ) ; end command
      (setq pt0 (list (+ (car pt0) WCL) (cadr pt0)) )
    ) ; end progn
  ) ; end foreach

  ;; preenchimento dos dados de cada circuito
  (setq pt0 (list (+ (car pti) (/ WCL 2.0)) (+ (cadr pti) (* (- nc 0.5) HLD) HLS)) )
  (foreach lc1 (xsort (cddr lscar))
    (setq lc2 (assoc (car lc1) (caddr (cddddr lsdim))) )
    (setq
      cir1  (car    lc1)
      pot1  (cadr   lc2)
      vf1   (caddr  lc2)
      bt1   (cadddr lc2)
      prot1 (car  (cddddr lc2))
      fas1  (cadr (cddddr lc2))
      num1  0
    ) ; end setq 
    (command
      ".text" "m" pt0 HTD 0 cir1
      ".text" "m" (list (+ (car pt0) (* (+ 1 nl nt 1) WCL)) (cadr pt0)) HTD 0 (rtos pot1  2 0)
      ".text" "m" (list (+ (car pt0) (* (+ 1 nl nt 2) WCL)) (cadr pt0)) HTD 0 (rtos vf1   2 0)
      ".text" "m" (list (+ (car pt0) (* (+ 1 nl nt 3) WCL)) (cadr pt0)) HTD 0 (rtos prot1 2 0)
      ".text" "m" (list (+ (car pt0) (* (+ 1 nl nt 4) WCL)) (cadr pt0)) HTD 0 (rtos bt1   2 1)
      ".text" "m" (list (+ (car pt0) (* (+ 1 nl nt 5) WCL)) (cadr pt0)) HTD 0 fas1
    ) ; end command

    (foreach lt1 (caddr lc1)
      (setq tip1 (car lt1))
      (foreach it1 (cadr lt1)
        (setq
          potc1 (atof (car  it1))
          numc1 (cadr it1)
        ) ; end setq
        (cond
          ( (= tip1 "EILUMINACAO")
            (command ".text" "m" (list (+ (car pt0) WCL (* (lpos (assoc potc1 ll) ll) WCL)) (cadr pt0)) HTD 0 (itoa numc1))
          ) ; end case
          ( (= tip1 "ECARGA")
            (command ".text" "m" (list (+ (car pt0) WCL (* (+ nl (lpos (assoc potc1 lt) lt)) WCL)) (cadr pt0)) HTD 0 (itoa numc1))
          ) ; end case
        ) ; end cond
        (setq num1 (+ num1 numc1))
      ) ; end foreach
    ) ; end foreach

    (setq
      potq (+ potq pot1)
      numq (+ numq num1)
    ) ; end setq

    (command ".text" "m" (list (+ (car pt0) (* (+ 1 nt nl) WCL)) (cadr pt0)) HTD 0 (itoa num1))
    (setq pt0 (list (car pt0) (- (cadr pt0) HLD)) )
  ) ; end foreach

  ;; preenchimento do total sumario de cada campo do quadro
  (setq pt0 (list (+ (car pti) (* (+ 1 nl nt 0.5) WCL)) (+ (cadr pti) (/ HLS 2.0))) )
  (setq
    potdq  (car    lsdim)
    vfq    (cadr   lsdim)
    btq    (caddr  lsdim)
    bpq    (cadddr lsdim)
    protq  (car (cddddr lsdim))
    fasq   (cadr (cddddr lsdim))
  ) ; end setq
  (command
    ".text" "m" pt0 HTD 0 (rtos numq 2 0)
    ".text" "m" (list (+ (car pt0) WCL) (cadr pt0)) HTD 0 (rtos potq 2 0)
    ".text" "m" (list (+ (car pt0) (* WCL 2.0)) (cadr pt0)) HTD 0 (rtos vfq 2 0)
    ".text" "m" (list (+ (car pt0) (* WCL 3.0)) (cadr pt0)) HTD 0 (rtos protq 2 0)
    ".text" "m" (list (+ (car pt0) (* WCL 4.0)) (cadr pt0)) HTD 0 (rtos btq 2 1)
    ".text" "m" (list (+ (car pt0) (* WCL 5.0)) (cadr pt0)) HTD 0 fasq
  ) ; end command

  (command
    ".text"
      (list (car pti) (- (cadr pti) HLD))
      HTD
      0
      (strcat "* POTENCIA CONSIDERADA NO DIMENSIONAMENTO DO ALIMENTADOR E DA PROTECAO DO QUADRO = " (RTOS POTDQ 2 0) " VA")
  ) ; end command

  (command ".undo" "e")

  (setvar "cmdecho" oldecho)
  (setvar "blipmode" oldblip)

  (princ)
) ; end defun

;; c:eqdcm(): rotina de desenho do quadro de cargas manual
(defun c:eqdcm(/ oldecho oldblip HTT HTC HTD HLT HLC1 HLC HLD HLS WCL NLE NTE NCE flg qdr pti nc nl nt cnt ll lt pot pt0 it)

  (setq flg 't)
  (while flg
    (setq qdr (strcase (strcat (getstring "\n\nNome do quadro (?): "))) )
    (cond
      ( (= qdr "?") (eqdc_lsquadros) )
      ( (= qdr "")  (prompt "\nERR: Entrada nula nao e valida.") )
      ( 't          (setq flg nil) )
    ) ; end cond
  ) ; end while

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (initget 3)
  (setq nc (getint "\nNumero de circuitos: "))

  (initget 3)
  (setq nl (getint "\nNumero de potencias diferentes de iluminacao: "))

  (initget 3)
  (setq nt (getint "\nNumero de potencias diferentes de tomadas: "))

  (prompt "\nInforme as diferentes potencias de iluminacao...")
  (setq
    cnt 1
    ll '()
  ) ; end setq
  (while (<= cnt nl)
    (initget 6)
    (setq pot (getreal (strcat "\nPotencia de iluminacao (" (itoa cnt) "): ")) )
    (setq
      ll (cons pot ll)
      cnt (1+ cnt)
    ) ; end setq
  ) ; end while

  (prompt "\nInforme as diferentes potencias de tomadas...")
  (setq
    cnt 1
    lt '()
  ) ; end setq
  (while (<= cnt nt)
    (initget 6)
    (setq pot (getreal (strcat "\nPotencia de tomada (" (itoa cnt) "): ")) )
    (setq
      lt (cons pot lt)
      cnt (1+ cnt)
    ) ; end setq
  ) ; end while

  (eqdc_param)        ;; inicializacao dos parametros do quadro

  (setq
    oldecho (acadvar "cmdecho" 0)
    oldblip (acadvar "blipmode" 0)
  ) ; end setq

  (command ".undo" "g")

  (eqdc_dsquadro pti qdr nc nl nt)              ;; desenha o quadro de cargas

  ;; insere texto de titulo dos campos de potencia de iluminacao e o total sumario
  (setq pt0 (list (+ (car pti) (* 1.5 WCL)) (+ (cadr pti) (/ HLC1 2.0) (* nc HLD) HLS)) )
  (foreach it (reverse ll)
    (progn
      (if it (command ".text" "m" pt0 HTC 0 (rtos it 2 0)) )
      (setq pt0 (list (+ (car pt0) WCL) (cadr pt0)) )
    ) ; end progn
  ) ; end foreach

  ;; insere texto de titulo dos campos de potencia de tomadas
  (setq pt0  (list (+ (car pti) (* (+ 1 nl 0.5) WCL)) (+ (cadr pti) (/ HLC1 2.0) (* nc HLD) HLS)) )
  (foreach it (reverse lt)
    (progn
      (if it (command ".text" "m" pt0 HTC 0 (rtos it 2 0)) )
      (setq pt0 (list (+ (car pt0) WCL) (cadr pt0)) )
    ) ; end progn
  ) ; end foreach

  (command ".undo" "e")

  (setvar "cmdecho" oldecho)
  (setvar "blipmode" oldblip)

  (princ)
) ; end defun

;; c:eqdca(): rotina de desenho do quadro de cargas com dimensionamento simplificado
(defun c:eqdca(/ qdr vfase btmin pti fred temp flg lscar)

  (setq flg 't)
  (while flg
    (setq qdr (strcase (strcat (getstring "\n\nNome do quadro (?): "))) )
    (cond
      ( (= qdr "?") (eqdc_lsquadros) )
      ( (= qdr "")  (prompt "\nERR: Entrada nula nao e valida.") )
      ( 't          (setq flg nil) )
    ) ; end cond
  ) ; end while

  (setq vfase (getreal (strcat "\nTensao fase-fase do projeto <" (rtos #VFASE 2 0) ">: ")) )
  (if vfase (setq #VFASE vfase))

  (setq temp (getreal (strcat "\nTemperatura ambiente <" (rtos #TEMP 2 0) ">: ")) )
  (if temp (setq #TEMP temp))

  (setq fred (getreal (strcat "\nFator de reducao por agrupamento (k2 x k3) <0.80>: ")) )
  (if (null fred) (setq fred 0.80))

  (initget "1.5 2.5 4 6 10 16 25 35 50 70 95 120 150 184 240 300 400 500 630 800 1000")
  (setq btmin (getkword (strcat "\nSecao nominal minima do condutor (mm) <" #BTMIN ">: ")) )
  (if btmin (setq #BTMIN btmin))

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (if (setq lscar (eqdc_lvquadro qdr))
    (eqdc_qdrauto pti qdr lscar (eqdc_dmquadro #VFASE (atof #BTMIN) #TEMP fred lscar))
  ) ; end if

  (princ)
) ; end defun

(princ)

