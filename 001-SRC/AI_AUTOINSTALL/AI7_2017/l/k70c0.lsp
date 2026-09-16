;;
;; K70C0.lsp
;; Copyright (C) 1996 by Luiz Marcio Faria Viana, 10/11/96
;;

;; barrane: rotina para desenho parametrizado da barra de neutros
(defun c:barrane(/ TABA TABB oldech oldsty inom vpar ls achou dat larg esp nram
  bram lista cont ngrup bgrup nserv bserv nater bater pti comp elem dscomp
  dslarg dsesp dscenex dsfur1 dsext1 dsfur2 dsext2 dsint1 dsint2 dsesppar
  dsaltpar dshaste pt1 pt2)
  ;; relaciona corrente nominal da barra com suas dimensoes
  (setq TABA '( (( 110  12.0  2.0) ( 140  15.0  2.0) ( 170  15.0  3.0)
                 ( 185  20.0  2.0) ( 220  20.0  3.0) ( 270  25.0  3.0)
                 ( 295  20.0  5.0) ( 315  30.0  3.0) ( 350  25.0  5.0)
                 ( 400  30.0  5.0) ( 420  40.0  3.0) ( 520  40.0  5.0)
                 ( 630  50.0  5.0) ( 760  40.0 10.0) ( 760  60.0  5.0)
                 ( 820  50.0 10.0) ( 970  80.0  5.0) (1060  60.0 10.0)
                 (1200 100.0  5.0) (1380  80.0 10.0) (1700 100.0 10.0)
                 (2000 120.0 10.0) (2500 160.0 10.0) (3000 200.0 10.0))
                (( 200  12.0  2.0) ( 240  15.0  2.0) ( 300  15.0  3.0)
                 ( 315  20.0  2.0) ( 380  20.0  3.0) ( 460  25.0  3.0)
                 ( 500  20.0  5.0) ( 540  30.0  3.0) ( 600  25.0  5.0)
                 ( 700  30.0  5.0) ( 710  40.0  3.0) ( 900  40.0  5.0)
                 (1100  50.0  5.0) (1250  60.0  5.0) (1350  40.0 10.0)
                 (1600  50.0 10.0) (1700  80.0  5.0) (1900  60.0 10.0)
                 (2050 100.0  5.0) (2300  80.0 10.0) (2800 100.0 10.0)
                 (3100 120.0 10.0) (3900 160.0 10.0) (4750 200.0 10.0)) )
  ) ; end setq

  ;; relaciona o diametro do condutor em (mm) e obtem a dimensao do furo
  (setq TABB '( (  6  "3/16\" x 1/2\"")
                ( 10  "3/16\" x 1/2\"")
                ( 16   "1/4\" x 5/8\"")
                ( 25   "1/4\" x 5/8\"")
                ( 35   "1/4\" x 3/4\"")
                ( 50   "1/4\" x 3/4\"")
                ( 70 "1/2\" x 1 1/4\"")
                ( 95 "1/2\" x 1 1/4\"")
                (120     "1/2\" x 3\"") 
                (150     "1/2\" x 3\"")
                (185     "1/2\" x 3\"")
                (240     "5/8\" x 3\"")
                (300     "5/8\" x 3\"")
                (500     "3/4\" x 3\"") )
  ) ; end setq

  (setq oldech (acadvar "cmdecho" 0))

  (initget 7)
  (setq inom (getint "\nCorrente nominal da barra: "))

  (initget "1 2")
  (if (= (setq vpar (getkword (strcat "\nNumero de barras em paralelo (1 ou 2) <1>: "))) "2")
    (setq ls (cadr TABA))
    (setq ls (car  TABA))
  ) ; end if

  (setq achou 0)
  (while (and (zerop achou) (setq dat (car ls)) )
    (if (<= inom (car dat))
      (progn
        (setq
          inom (car   dat)
          larg (cadr  dat)
          esp  (caddr dat)
        ) ; end setq
        (setq achou 1)
      ) ; end progn
    ) ; end if
    (setq ls (cdr ls))
  ) ; end while

  (initget 7)
  (setq nram  (getint "\nNumero de cabos de entrada do ramal (par >=2): "))
  (initget 1 "6 10 16 25 35 50 70 95 120 150 185 240 300 500")
  (setq bram  (getkword "\nBitola dos cabos de entrada do ramal: "))
  (setq lista (list (list 1 nram (atoi bram))) )

  (setq cont 1)
  (while (/= (progn
               (initget 6)
               (setq ngrup (getint (strcat "\nNumero de cabos do agrupamento numero (" (itoa cont) ") ou ENTER para terminar: ")))
             ) ; end progn
             nil
         ) ; end
    (initget 1 "6 10 16 25 35 50 70 95 120 150 185 240 300 500")
    (setq bgrup (getkword (strcat "\nBitola dos cabos do agrupamento numero (" (itoa cont) "): ")) )
    (setq lista (append lista (list (list 2 ngrup (atoi bgrup)))) )
    (setq cont (+ cont 1))
  ) ; end while

  (initget 7)
  (setq nserv (getint "\nNumero de cabos de servico: ") )
  (initget 1 "6 10 16 25 35 50 70 95 120 150 185 240 300 500")
  (setq bserv (getkword "\nBitola dos cabos de servico: ") )
  (setq lista (append lista (list (list 3 nserv (atoi bserv)))) )

  (initget 7)
  (setq nater (getint "\nNumero de cabos do aterramento: ") )
  (initget 1 "6 10 16 25 35 50 70 95 120 150 185 240 300 500")
  (setq bater (getkword "\nBitola dos cabos de aterramento: ") )
  (setq lista (append lista (list (list 4 nater (atoi bater)))) )

  (initget 7)
  (setq nres (getint "\nNumero de cabos de reserva: ") )
  (initget 1 "6 10 16 25 35 50 70 95 120 150 185 240 300 500")
  (setq bres (getkword "\nBitola dos cabos de reserva: ") )
  (setq lista (append lista (list (list 5 nres (atoi bres)))) )

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: ") )

  ;; calculando o comprimento da barra de neutros
  (setq comp 0)
  (foreach elem lista
    (setq comp (+ comp (* 7.0 (cadr elem))) )
  ) ; end foreach
  (setq comp (+ (- comp 7.0) 14.0))  ;; soma a distancia entre furos de fixacao
  (setq n (fix (/ comp 100.0)) )  ;; n = numero de furos de fixacao extras
  
  ;;
  ;; insercao da legenda da barra de neutro
  ;;

  (setq oldsty (getvar "textstyle"))
  (command ".style" "monotxt" "monotxt" "" "" "" "" "" "")

  (setq oldlay (slay "EL-DETALHE"))

  (command ".text" (setq pt1 pti) (* 4.0 (#SCL)) 0 "%%UDETALHE DA BARRA DE NEUTRO")

  (command
    ".text"
      (setq pt1 (list (car pt1) (- (cadr pt1) (* 4.0 (#SCL)))) )
      (* 1.5 (#SCL)) 0
      "S/ESCALA"
    ".text"
      (setq pt1 (list (car pt1) (- (cadr pt1) (* 50.0 (#SCL)))) )
      (* 2.0 (#SCL)) 0
      " 1 - FURO SEM ROSCA DE 9/32\" PARA FIXACAO DA BARRA A ESTRUTURA"
  ) ; end command

  (setq cont 2)
  (foreach elem lista
    (progn
      (command
        ".text"
          (setq pt1 (list (car pt1) (- (cadr pt1) (* 4.0 (#SCL)))) )
          (* 2.0 (#SCL)) 0
          (strcat
            (lfill (itoa cont) 2 " ")
            " - FUROS S/ROSCA P/ESTOJO DE "
            (cadr (assoc (caddr elem) TABB))
            " COM PORCA E ARRUELA, CABECA SEXTAVADA DE LATAO "
            (cond
              ((= (car elem) 1) "P/RAMAL ")
              ((= (car elem) 2) (strcat "P/AGRUPAMENTO " (itoa (- cont 2))) )
              ((= (car elem) 3) "P/SERVICO")
              ((= (car elem) 4) "P/ATERRAMENTO")
              ((= (car elem) 5) "P/RESERVA")
            ) ; end cond
            " (" (itoa (caddr elem)) " mm2)"
          ) ; end strcat
      ) ; end command
      (setq cont (+ cont 1))
    ) ; end progn
  ) ; end foreach

  (command
    ".text"
       (setq pt1 (list (car pt1) (- (cadr pt1) (* 4.0 (#SCL)))) )
       (* 2.0 (#SCL)) 0
       (strcat
         "OBS: BARRA DE NEUTRO "
         (itoa inom)
         " Amp. DE "
         (rtos larg 2 1)
         " x "
         (rtos esp  2 1)
         " mm (LARGURA X ESPESSURA)"
       ) ; end strcat
    ".text"
       (setq pt1 (list (car pt1) (- (cadr pt1) (* 4.0 (#SCL)))) )
       (* 2.0 (#SCL)) 0
       "     COTAS EM CENTIMETROS"
  ) ; end command

  (command ".style" oldsty "" "" "" "" "" "" "")

  ;;
  ;; DESENHO DA BARRA DE NEUTRO
  ;;

  ;; calculando as medidas dos elemento do desenho
  (setq
    dscomp    (* comp      (#SCL))
    dslarg    (* 10.0      (#SCL))
    dsesp     (*  2.5      (#SCL))
    dscenex   (* dsesp 0.25)  		;; 25% da espessura
    dsfur1    (*  1.25     (#SCL))
    dsext1    (* dsfur1 1.5)  		;; 50% maior que o furo 
    dsfur2    (*  0.75     (#SCL))
    dsext2    (* dsfur2 1.5)  		;; 50% maior que o furo
    dsint1    (*  7.0      (#SCL))
    dsint2    (*  3.5      (#SCL))
    dsextln   (*  5.0      (#SCL))
    dsesppar  dslarg
    dsaltpar  (* 3.0 dslarg)
    dshaste   dslarg
  ) ; end setq

  ;;
  ;; DESENHO EM VISTA FRONTAL DA BARRA
  ;;

  ;; calcula a posicao do ponto base do desenho
  (setq pt1 (list (+ (car pti) (* 10.0 (#SCL))) (- (cadr pti) (* 20.0 (#SCL)))) )

  ;; desenho do retangulo que representa a barra em vista frontal 
  (command
    ".pline"
      pt1 "w" 0.0 ""
      (list (+ (car pt1) dscomp)            (cadr pt1))
      (list (+ (car pt1) dscomp) (- (cadr pt1) dslarg))
      (list (car pt1)            (- (cadr pt1) dslarg))
      "c"
  ) ; end command

  ;; desenho dos furos para conexao dos condutores
  (setq pt2 (list (+ (car pt1) (* dsint2 2.0)) (- (cadr pt1) (/ dslarg 2.0))) )
  (foreach elem lista
    (repeat (cadr elem)
      (progn
        (command
          ".circle" pt2 dsfur1
          ".line"
            (list (car pt2) (- (cadr pt2) dsext1))
            (list (car pt2) (+ (cadr pt2) dsext1))
            ""
          ".line"
            (list (- (car pt2) dsext1) (cadr pt2))
            (list (+ (car pt2) dsext1) (cadr pt2))
            ""
        ) ; end command
        (setq pt2 (list (+ (car pt2) dsint1) (cadr pt2)))
      ) ; end progn
    ) ; end repeat
  ) ; end foreach

  ;; desenho dos furos para fixacao da barra
  (setq pt2 (list (+ (car pt1) dsint2) (- (cadr pt1) (/ dslarg 2.0))) )
  (command
    ".circle" pt2 dsfur2
    ".line"
      (list (car pt2) (- (cadr pt2) dsext2))
      (list (car pt2) (+ (cadr pt2) dsext2))
      ""
    ".line"
      (list (- (car pt2) dsext2) (cadr pt2))
      (list (+ (car pt2) dsext2) (cadr pt2))
      ""
  ) ; end command
  (setq pt2 (list (+ (car pt1) (- dscomp dsint2) ) (- (cadr pt1) (/ dslarg 2.0))) )
  (command
    ".circle" pt2 dsfur2
    ".line"
      (list (car pt2) (- (cadr pt2) dsext2))
      (list (car pt2) (+ (cadr pt2) dsext2))
      ""
    ".line"
      (list (- (car pt2) dsext2) (cadr pt2))
      (list (+ (car pt2) dsext2) (cadr pt2))
      ""
  ) ; end command

  ;; desenho dos n furos de fixacao extras caso o comprimento exija
  (setq pt2 pt1)
  (setq dsextra (/ dscomp (+ n 1)) )
  (setq dsresult 0.0)
  (setq soma (+ dsextra dsint1))
  (repeat n
    (progn
      (while (< dsresult soma)
        (setq dsresult (+ dsresult dsint1))
      ); end while
      (setq pt2 (list (+ (car pt1) (+ (- dsresult dsint1) dsint2) ) (- (cadr pt1) (/ dslarg 2.0))) )
      (command
        ".circle" pt2 dsfur2
        ".line"
         (list (car pt2) (- (cadr pt2) dsext2))
         (list (car pt2) (+ (cadr pt2) dsext2))
         ""
       ".line"
          (list (- (car pt2) dsext2) (cadr pt2))
         (list (+ (car pt2) dsext2) (cadr pt2))
         ""
      ) ; end command
      (setq pt2 (list (+ (car pt1) dsint2) (- (cadr pt1) (/ dslarg 2.0))) )
      (setq soma (+ soma (+ dsextra dsint1)))
    ); end progn
  ) ; end repeat
  
  ;; desenho da cota de comprimento da barra
  (setq pt2 pt1)
  (command
    "dim1"
      "horiz" pt2
      (list (+ (car pt2) dscomp) (cadr pt2))
      (list (car pt2) (+ (cadr pt2) dsextln))
      (rtos comp 2 0)
  ) ; end command

  ;; desenho das cotas dos furos do desenho

  (setq pt2 (list (+ (car pt1) (* dsint2 2.0)) (- (cadr pt1) dslarg)) )
  (foreach elem lista
    (progn
      (repeat (cadr elem)
        (command
          ".dim1"
            "horiz" pt2
            (setq pt2 (list (+ (car pt2) dsint1) (cadr pt2)))
            (list (car pt2) (- (cadr pt2) dsextln))
            "7"
        ) ; end command
      ) ; end repeat
    ) ;end progn
  ) ; end foreach
  (repeat 6 (command ".erase" "l" ""))

  ;; desenho das cotas dos furos de fixacao
  (setq pt2 (list (car pt1) (- (cadr pt1) dslarg)) )
  (repeat 2
    (command
      ".dim1"
        "horiz" pt2
        (setq pt2 (list (+ (car pt2) dsint2) (cadr pt2)))
        (list (car pt2) (- (cadr pt2) dsextln))
        "4"
    ) ; end command
  ) ; end repeat
  (setq pt2 (list (+ (car pt1) dscomp) (- (cadr pt1) dslarg)) )
  (repeat 2
    (command
      ".dim1"
        "horiz" pt2
        (setq pt2 (list (- (car pt2) dsint2) (cadr pt2)))
        (list (car pt2) (- (cadr pt2) dsextln))
        "4"
    ) ; end command
  ) ; end repeat

  ;; desenho da numeracao dos furos
  (setq pt2 (list (+ (car pt1) (* dsint1 0.875)) (- (cadr pt1) (/ dslarg 4.0))) )
  (repeat (/ (cadr (car lista)) 2)
    (progn
      (command ".text" "m" pt2 (* 1.5 (#SCL)) 0 "2")
      (setq pt2 (list (+ (car pt2) dsint1) (cadr pt2)) )
    ) ; end progn
  ) ; end command
  (setq cont 3)
  (foreach elem (cdr lista)
    (progn
      (repeat (cadr elem)
        (progn
          (command ".text" "m" pt2 (* 1.5 (#SCL)) 0 (itoa cont))
          (setq pt2 (list (+ (car pt2) dsint1) (cadr pt2)))
        ) ; end progn
      ) ; end repeat
      (setq cont (+ cont 1))
    ) ; end progn
  ) ; end foreach
  (repeat (/ (cadr (car lista)) 2)
    (progn
      (command ".text" "m" pt2 (* 1.5 (#SCL)) 0 "2")
      (setq pt2 (list (+ (car pt2) dsint1) (cadr pt2)))
    ) ; end progn
  ) ; end repeat

  ;; desenho da numeracao dos furos de fixacao
  (setq pt2 (list (+ (car pt1) (* dsint2 0.75)) (- (cadr pt1) (/ dslarg 4.0))) )
  (command ".text" "m" pt2 (* 1.5 (#SCL)) 0 "1")
  (setq pt2 (list (+ (car pt1) (- dscomp (* dsint2 0.75))) (cadr pt2)) )
  (command ".text" "m" pt2 (* 1.5 (#SCL)) 0 "1")

  ;; desenho da numeracao dos furos de fixacao extras
  (setq pt2 pt1)
  (setq dsextra (/ dscomp (+ n 1)) )
  (setq dsresult 0.0)
  (setq soma (+ dsextra dsint1))
  (repeat n
    (progn
      (while (< dsresult soma)
        (setq dsresult (+ dsresult dsint1))
      ); end while
      (setq pt2 (list (+ (car pt1) (+ (- dsresult dsint1) (* dsint2 0.75)) )  (- (cadr pt1) (/ dslarg 4.0))) )
      (command ".text" "m" pt2 (* 1.5 (#SCL)) 0 "1")  
      (setq pt2 (list (+ (car pt1) dsint2) (- (cadr pt1) (/ dslarg 4.0))) )      
      (setq soma (+ soma (+ dsextra dsint1)))
    ); end progn
  ) ; end repeat
  
  ;;
  ;; DESENHO EM VISTA LATERAL
  ;;

  ;; calcula a posicao do ponto base do desenho
  (setq pt1 (list (+ (car pt1) dscomp (* 10.0 (#SCL))) (cadr pt1)) )

  ;; desenho do retangulo que representa a barra
  (setq pt2 pt1)
  (command
    ".pline" pt2 "w" 0 0
      (list (+ (car pt2) dsesp)            (cadr pt1))
      (list (+ (car pt2) dsesp) (- (cadr pt2) dslarg))
      (list (car pt2)           (- (cadr pt2) dslarg))
      "c"
  ) ; end command

  ;; desenho dos furos da barra em vista lateral
  (setq pt2 (list (car pt1) (- (cadr pt1) (- (/ dslarg 2.0) dsfur1))) )
  (command
    ".pline" pt2 "w" 0 0
      (list (+ (car pt2) dsesp) (cadr pt2))
      ""
    ".pline"
      (list (car pt2) (- (cadr pt2) (* dsfur1 2.0)))
      "w" 0 0
      (list (+ (car pt2) dsesp) (- (cadr pt2) (* dsfur1 2.0)))
      ""
    ".pline"
      (list (- (car pt2) dscenex) (- (cadr pt2) dsfur1))
      "w" 0 0
      (list (+ (car pt2) dsesp dscenex) (- (cadr pt2) dsfur1))
      ""
  ) ; end command

  ;; desenho da cota de espessura da barra
  (setq pt2 pt1)
  (command
    ".dim1"
      "horiz" pt2
      (list (+ (car pt2) dsesp) (cadr pt2))
      (list (car pt2) (+ (cadr pt2) dsextln))
      (rtos (/ esp 10.0) 2 1)		;; converte para (cm)
  ) ; end command

  ;; desenho da cota de posicionamento do furo
  (setq pt2 (list (+ (car pt2) dsesp) (- (cadr pt2) (/ dslarg 2.0))) )
  (command
    ".dim1"
      "vert" pt2
      (list (car pt2) (- (cadr pt2) (/ dslarg 2.0)))
      (list (+ (car pt2) dsextln) (cadr pt2))
      (rtos (/ (/ larg 10.0) 2.0) 2 1)	;; converte para (cm)
  ) ; end command

  ;;
  ;; DESENHO DO DETALHE DE FIXACAO
  ;;

  ;; calcula a posicao do ponto base do desenho
  (setq pt1 (list (+ (car pt1) dsesp (* 10.0 (#SCL))) (cadr pt1)) )

  ;; desenho da parede de apoio da barra
  (setq pt2 (list (car pt1) (+ (cadr pt1) (/ (- dsaltpar dslarg) 2.0))) )
  (command
    ".pline"
      pt2 "w" 0 0
      (list (+ (car pt2) dsesppar) (cadr pt2))
      (list (+ (car pt2) dsesppar) (- (cadr pt2) dsaltpar))
      (list (car pt2)              (- (cadr pt2) dsaltpar))
      "c"
    ".hatch" "u" 45 (* (#SCL) 2.0) "n" "l" ""
    ".erase" "p" ""
    ".line"
      pt2
      (list (car pt2) (- (cadr pt2) dsaltpar))
      ""
    ".line"
      (list (+ (car pt2) dsesppar) (cadr pt2))
      (list (+ (car pt2) dsesppar) (- (cadr pt2) dsaltpar))
      ""
    ".line"
      (list (- (car pt2) (/ dsesppar 4.0)) (cadr pt2))
      (list (+ (car pt2) dsesppar (/ dsesppar 4.0)) (cadr pt2))
      ""
    ".line"
      (list (- (car pt2) (/ dsesppar 4.0)) (- (cadr pt2) dsaltpar))
      (list (+ (car pt2) dsesppar (/ dsesppar 4.0)) (- (cadr pt2) dsaltpar))
      ""
  ) ; end command

  ;; desenho haste de fixacao da barra
  (setq pt2 (list (+ (car pt1) dsesppar) (- (cadr pt1) (- (/ dslarg 2.0) dsfur2))) )
  (command
    ".line"
      pt2
      (list (+ (car pt2) dshaste) (cadr pt2))
      ""
    ".line"
      (list (car pt2) (- (cadr pt2) (* dsfur2 2.0)))
      (list (+ (car pt2) dshaste) (- (cadr pt2) (* dsfur2 2.0)))
      ""
  ) ; end command

  ;; desenho da barra de neutro em vista lateral
  (setq pt2 (list (+ (car pt1) dsesppar dshaste) (cadr pt1)) )
  (command
    ".pline"
      pt2 "w" 0 0
      (list (+ (car pt2) dsesp) (cadr pt2))
      (list (+ (car pt2) dsesp) (- (cadr pt2) dslarg))
      (list (car pt2)           (- (cadr pt2) dslarg))
      "c"
  ) ; end command

  ;; desenho da cota da haste
  (setq pt2 (list (+ (car pt1) dsesppar) (cadr pt1)) )
  (command
    ".dim1"
      "horiz"
      pt2
      (list (+ (car pt2) dshaste) (cadr pt2))
      (list (car pt2) (+ (cadr pt2) dsextln))
      "10.0"				;; dimensao fixa
  ) ; end command

  ;; desenho da cota da espessura da barra
  (setq pt2 (list (+ (car pt2) dshaste) (cadr pt2)) )
  (command
    ".dim1"
      "horiz"
      pt2
      (list (+ (car pt2) dsesp) (cadr pt2))
      (list (car pt2) (+ (cadr pt2) dsextln))
      (rtos (/ esp 10.0) 2 1)		;; converte para (cm)
  ) ; end command

  ;; desenho da cota d largura da barra 
  (setq pt2 (list (+ (car pt2) dsesp) (cadr pt2)) )
  (command
    ".dim1"
      "vert"
      pt2
      (list (car pt2) (- (cadr pt2) dslarg))
      (list (+ (car pt2) dsextln) (cadr pt2))
      (rtos (/ larg 10.0) 2 1)		;; converte para (cm)
  ) ; end command

  (slay oldlay)

  (setvar "cmdecho" oldech)
  (princ)  
) ; end defun

(princ)
