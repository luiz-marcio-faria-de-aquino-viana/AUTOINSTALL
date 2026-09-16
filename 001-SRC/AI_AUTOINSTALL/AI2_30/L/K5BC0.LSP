
;;
;; IL.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 2/23/96.
;;
;; Rotina para preparacao dos dados de entrada do Calculo de Iluminamento

;;
;; Definicao dos caminhos de procura dos dados
;;

(defun v:il (f) (strcat "\\ai\\"    f))
(defun v:ild(f) (strcat "\\ai\\d\\el\\" f))

;;
;; Definicao de variaveis globais
;;

(setq #R_IDENT                         0 )
(setq #R_Z      (* 25.0 (/ 1000.0 #UND)) )

;;
;; Carrega aplicacao ADS externa
;;

(xload (v:il "il"))

;;
;; IL_REFL: Rotina para insercao de refletores e focos
;;

(defun c:il_refl(/ oldech oldlay Rpt Fpt Id Alt enm R_X R_Y R_Z F_IDENT F_X F_Y)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (initget 1)
  (setq Rpt (getpoint "\nPonto de insercao do refletor: "))
  (initget 1)
  (setq Fpt (getpoint Rpt "\nMarque a posicao do foco: "))
  (setq #R_IDENT (+ #R_IDENT 1))
  (setq Id (getint (strcat "\nIdentificacao do refletor <" (itoa #R_IDENT) ">: ")))
  (if Id (setq #R_IDENT Id))
  (setq F_IDENT #R_IDENT)
  (setq Alt (getdist (strcat "\nAltura do refletor <" (rtos #R_Z 2 1) ">: ")))
  (if Alt (setq #R_Z Alt))
  (setq oldlay (getvar "clayer"))
  (if (tblsearch "LAYER" "IL-LUMENS")
    (command ".layer" "t" "il-lumens" "s" "il-lumens" "")
    (command ".layer" "m" "il-lumens" "")
  ) ; end if

  ;; insercao do bloco do refletor
  (command ".insert" (v:ild "EL3DC00") "s" #SCL Rpt Fpt)
  (setq enm (entnext (ssname (ssget "l") 0) ) )
  (while (/= (cdr (assoc 0 (setq ent (entget enm)) )) "SEQEND")
    (cond
      ((= (cdr (assoc 2 ent)) "R_IDENT")   (entmod (subst (cons 1 (itoa #R_IDENT))       (assoc 1 ent) ent)) )
      ((= (cdr (assoc 2 ent)) "R_MODEL")   (entmod (subst (cons 1 "not-used")            (assoc 1 ent) ent)) )
      ((= (cdr (assoc 2 ent)) "R_FLUXLUM") (entmod (subst (cons 1 "not-used")            (assoc 1 ent) ent)) )
      ((= (cdr (assoc 2 ent)) "R_FATDEPR") (entmod (subst (cons 1 "not-used")            (assoc 1 ent) ent)) )
      ((= (cdr (assoc 2 ent)) "R_X")       (entmod (subst (cons 1 (rtos (car  Rpt) 2 6)) (assoc 1 ent) ent)) )
      ((= (cdr (assoc 2 ent)) "R_Y")       (entmod (subst (cons 1 (rtos (cadr Rpt) 2 6)) (assoc 1 ent) ent)) )
      ((= (cdr (assoc 2 ent)) "R_Z")       (entmod (subst (cons 1 (rtos #R_Z 2 6))       (assoc 1 ent) ent)) )
      ((= (cdr (assoc 2 ent)) "F_IDENT")   (entmod (subst (cons 1 (itoa F_IDENT))        (assoc 1 ent) ent)) )
    ) ; end cond
    (setq enm (entnext enm))
  ) ; end while
  (entupd enm)

  ;; insercao do bloco do foco
  (command ".insert" (v:ild "EL3CC00") "s" #SCL Fpt Rpt)
  (setq enm (entnext (ssname (ssget "l") 0) ) )
  (while (/= (cdr (assoc 0 (setq ent (entget enm)) )) "SEQEND")
    (cond
      ((= (cdr (assoc 2 ent)) "F_IDENT") (entmod (subst (cons 1 (itoa F_IDENT))        (assoc 1 ent) ent)) )
      ((= (cdr (assoc 2 ent)) "F_X")     (entmod (subst (cons 1 (rtos (car  Fpt) 2 6)) (assoc 1 ent) ent)) )
      ((= (cdr (assoc 2 ent)) "F_Y")     (entmod (subst (cons 1 (rtos (cadr Fpt) 2 6)) (assoc 1 ent) ent)) )
      ((= (cdr (assoc 2 ent)) "R_IDENT") (entmod (subst (cons 1 (itoa #R_IDENT))       (assoc 1 ent) ent)) )
    ) ; end cond
    (setq enm (entnext enm))
  ) ; end while
  (entupd enm)

  (command ".layer" "s" oldlay "")

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;;
;; IL_CALC: Rotina para coletar dados do arquivo e iniciar prog de calculo
;;

(defun c:il_calc(/ oldech oldlay ls n pt ss3 max Rf Fl Ft Im ss ss1
                   ss2 ls1 cnt1 enm ent R_IDENT1 R_MODEL1 R_FLUXLUM1
                   R_FATDEPR1 R_X1 R_Y1 R_Z1 F_IDENT1 cnt2 F_IDENT2
                   F_X2 F_Y2 R_IDENT2 f p cnt)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (setq oldlay (getvar "clayer"))
  (if (tblsearch "LAYER" "IL-LUMENS")
    (command ".layer" "t" "il-lumens" "s" "il-lumens" "")
    (command ".layer" "m" "il-lumens" "")
  ) ; end if

  (prompt "\nMarque a area a ser analisada...")
  (initget 1)
  (setq ls (list (getpoint "\nPrimeiro vertice: ")) )
  (command ".pline" (car ls) "w" 0 "")
  (initget 1)
  (setq ls (append (list (getpoint (car ls) "\nSegundo vertice: ")) ls))
  (command (car ls))
  (initget 1)
  (setq ls (append (list (getpoint (car ls) "\nTerceiro vertice: ")) ls))
  (command (car ls))
  (setq n  3)
  (while (and (< n 20) (setq pt (getpoint (car ls) "\nN-esimo vertice (ou ENTER): ")) )
    (setq ls (append (list pt) ls))
    (command (car ls))
    (setq n (+ n 1))
  ) ; end while
  (command "c")
  (setq ss3 (ssget "l"))

  (textscr)
  (setq max (il_dsprefl))
  (setq flg nil)
  (while (null flg)
    (initget 7 "?")
    (setq Rf (getint "\n\nSelecione um modelo de refletor (?): "))
    (if (= Rf "?")
      (setq max (il_dsprefl))
      (if (> Rf max)
        (prompt "\n* ERROR * Codigo de refletor inexistente.")
        (setq flg t)
      ) ; end if
    ) ; end if
  ) ; end while

  (initget 7)
  (setq Fl (getreal "\nFluxo luminoso total das lampadas: "))

  (initget 6)
  (setq Ft (getreal "\nFator de depreciacao <100%>: "))
  (if (null Ft) (setq Ft 100.0))

  (initget 7)
  (setq Im (getreal "\nIndice medio de iluminamento desejado: "))

  (prompt "\nSelecione os refletores (ENTER = Seleciona todos)...")
  (if (null (setq ss (ssget)) )
    (progn
      (setq ss1 (ssget "x" '((0 . "INSERT") (2 . "EL3DC00"))) )
      (setq ss2 (ssget "x" '((0 . "INSERT") (2 . "EL3CC00"))) )
    ) ; end progn
    (progn
      (command ".select" ss "r" (ssget "x" '((0 . "INSERT") (2 . "EL3DC00"))) "")
      (command ".select" ss "r" "p" "")
      (setq ss1 (ssget "p"))
      (command ".select" ss "r" (ssget "x" '((0 . "INSERT") (2 . "EL3CC00"))) "")
      (command ".select" ss "r" "p" "")
      (setq ss2 (ssget "p"))
    ) ; end progn
  ) ; end if

  (setq ls1 '())

  (setq cnt1 (sslength ss1))
  (while (not (zerop cnt1))
    (setq cnt1 (- cnt1 1))
    (setq enm (ssname ss1 cnt1))
    (while (/= (cdr (assoc 0 (setq ent (entget enm)) )) "SEQEND")
      (cond
        ((= (cdr (assoc 2 ent)) "R_IDENT")   (setq R_IDENT1   (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "R_MODEL")   (setq R_MODEL1   (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "R_FLUXLUM") (setq R_FLUXLUM1 (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "R_FATDEPR") (setq R_FATDEPR1 (cdr (assoc 1 ent))) )
        ((= (cdr (assoc 2 ent)) "R_X")       (setq R_X1       (rtos (/ (atof (cdr (assoc 1 ent))) (/ 1000.0 #UND)) 2 2)) )
        ((= (cdr (assoc 2 ent)) "R_Y")       (setq R_Y1       (rtos (/ (atof (cdr (assoc 1 ent))) (/ 1000.0 #UND)) 2 2)) )
        ((= (cdr (assoc 2 ent)) "R_Z")       (setq R_Z1       (rtos (/ (atof (cdr (assoc 1 ent))) (/ 1000.0 #UND)) 2 2)) )
        ((= (cdr (assoc 2 ent)) "F_IDENT")   (setq F_IDENT1   (cdr (assoc 1 ent))) )
      ) ; end cond
      (setq enm (entnext enm))
    ) ; end while
    (setq
      cnt2 (sslength ss2)
      flg  nil
    ) ; end setq
    (while (and (null flg) (not (zerop cnt2)) )
      (setq cnt2 (- cnt2 1))
      (setq enm (ssname ss2 cnt2))
      (while (/= (cdr (assoc 0 (setq ent (entget enm)) )) "SEQEND")
        (cond
          ((= (cdr (assoc 2 ent)) "F_IDENT") (setq F_IDENT2 (cdr (assoc 1 ent))) )
          ((= (cdr (assoc 2 ent)) "F_X")     (setq F_X2     (rtos (/ (atof (cdr (assoc 1 ent))) (/ 1000.0 #UND)) 2 2)) )
          ((= (cdr (assoc 2 ent)) "F_Y")     (setq F_Y2     (rtos (/ (atof (cdr (assoc 1 ent))) (/ 1000.0 #UND)) 2 2)) )
          ((= (cdr (assoc 2 ent)) "R_IDENT") (setq R_IDENT2 (cdr (assoc 1 ent))) )
        ) ; end cond
        (setq enm (entnext enm))
      ) ; end while
      (if (and (= R_IDENT1 R_IDENT2) (= F_IDENT1 F_IDENT2))
        (setq
          ls1 (append ls1 (list (list (list R_X1 R_Y1 R_Z1) (list F_X2 F_Y2)) ))
          flg t
        ) ; end setq
      ) ; end if
    ) ; end while
  ) ; end while

  ;; definicao do arquivo de saida
  (setq fn (strcat (getvar "dwgname") ".imp"))

  (setq f (open fn "w"))
  (write-line (itoa Rf)          f)
  (write-line (rtos Fl 2 0)      f)
  (write-line (rtos Im 2 0)      f)
  (write-line (rtos Ft 2 2)      f)
  (write-line (itoa (length ls)) f)
  (foreach p ls
    (progn
      (write-line (rtos (/ (car p)  (/ 1000.0 #UND)) 2 2) f)
      (write-line (rtos (/ (cadr p) (/ 1000.0 #UND)) 2 2) f)
    ) ; end progn
  ) ; end foreach
  (setq cnt (- 20 (length ls)) )
  (while (not (zerop cnt))
    (write-line "0.00" f)
    (write-line "0.00" f)
    (setq cnt (- cnt 1))
  ) ; end while
  (write-line (itoa (sslength ss1)) f)
  (foreach p ls1
    (progn
      (write-line (car   (car  p)) f)
      (write-line (cadr  (car  p)) f)
      (write-line (caddr (car  p)) f)
      (write-line (car   (cadr p)) f)
      (write-line (cadr  (cadr p)) f)
    ) ; end progn
  ) ; end foreach
  (setq cnt (- 50 (sslength ss1)) )
  (while (not (zerop cnt))
    (write-line "0.00" f)
    (write-line "0.00" f)
    (write-line "0.00" f)
    (write-line "0.00" f)
    (write-line "0.00" f)
    (setq cnt (- cnt 1))
  ) ; end while

  (write-line "0.00" f)
  (setq cnt 0)
  (while (< cnt (* 19 19))
    (write-line "0.00" f)
    (setq cnt (+ cnt 1))
  ) ; end while
  (setq cnt 0)

  (while (< cnt (sslength ss1))
    (write-line "-1" f)
    (setq cnt (+ cnt 1))
  ) ; end while
  (while (< cnt 50)
    (write-line "0" f)
    (setq cnt (+ cnt 1))
  ) ; end while
  (setq f (close f))

  (command ".erase" ss3 "")
  (command ".layer" "s" oldlay "")

  (command ".shell" (strcat "il " (getvar "dwgname")))

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;;
;; IL_MODIF: Rotina para modificar as posicoes dos refletores e dos focos
;;

(defun c:il_modif(/ oldech ss1 ss2 cnt1 pt1 ent1a enm1 ent1
                    R_IDENT1 F_IDENT1 cnt2 enm2 ent2a ent2
                    F_IDENT2 R_IDENT2 rot1 rot2 pt2)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (setq
    ss1 (ssget "x" '((0 . "INSERT") (2 . "EL3DC00")))
    ss2 (ssget "x" '((0 . "INSERT") (2 . "EL3CC00")))
  ) ; end setq
  (setq cnt1 0)
  (while (< cnt1 (sslength ss1))
    (setq enm1 (ssname ss1 cnt1))
    (setq pt1  (cdr (assoc 10 (setq ent1a (entget enm1)) )) )
    (while (/= (cdr (assoc 0 (setq ent1 (entget enm1)) )) "SEQEND")
      (cond
        ((= (cdr (assoc 2 ent1)) "R_IDENT") (setq R_IDENT1 (cdr (assoc 1 ent1))) )
        ((= (cdr (assoc 2 ent1)) "R_X")     (entmod (subst (cons 1 (rtos (car  pt1) 2 6)) (assoc 1 ent1) ent1)) )
        ((= (cdr (assoc 2 ent1)) "R_Y")     (entmod (subst (cons 1 (rtos (cadr pt1) 2 6)) (assoc 1 ent1) ent1)) )
        ((= (cdr (assoc 2 ent1)) "F_IDENT") (setq F_IDENT1 (cdr (assoc 1 ent1))) )
      ) ; end cond
      (setq enm1 (entnext enm1))
    ) ; end while
    (setq cnt2 0)
    (while (< cnt2 (sslength ss2))
      (setq enm2 (ssname ss2 cnt2))
      (setq pt2 (cdr (assoc 10 (setq ent2a (entget enm2)) )) )
      (while (/= (cdr (assoc 0 (setq ent2 (entget enm2)) )) "SEQEND")
        (cond
          ((= (cdr (assoc 2 ent2)) "F_IDENT") (setq F_IDENT2 (cdr (assoc 1 ent2))) )
          ((= (cdr (assoc 2 ent2)) "R_IDENT") (setq R_IDENT2 (cdr (assoc 1 ent2))) )
        ) ; end cond
        (setq enm2 (entnext enm2))
      ) ; end while
      (if (and (= R_IDENT1 R_IDENT2) (= F_IDENT1 F_IDENT2))
        (progn
          (setq rot1 (angle pt1 pt2))
          (entmod (subst (cons 50 rot1) (assoc 50 ent1a) ent1a))
          (setq rot2 (angle pt2 pt1))
          (entmod (subst (cons 50 rot2) (assoc 50 ent2a) ent2a))
        ) ; end progn
      ) ; end if
      (setq cnt2 (+ cnt2 1))
    ) ; end while
    (setq cnt1 (+ cnt1 1))
  ) ; end while

  (setq cnt2 0)
  (while (< cnt2 (sslength ss2))
    (setq enm2 (ssname ss2 cnt2))
    (setq pt2 (cdr (assoc 10 (entget enm2))) )
    (while (/= (cdr (assoc 0 (setq ent2 (entget enm2)) )) "SEQEND")
      (cond
        ((= (cdr (assoc 2 ent2)) "F_X") (entmod (subst (cons 1 (rtos (car  pt2) 2 6)) (assoc 1 ent2) ent2)) )
        ((= (cdr (assoc 2 ent2)) "F_Y") (entmod (subst (cons 1 (rtos (cadr pt2) 2 6)) (assoc 1 ent2) ent2)) )
      ) ; end cond
      (setq enm2 (entnext enm2))
    ) ; end while
    (setq cnt2 (+ cnt2 1))
  ) ; end while

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;;
;; IL_RSLT: rotina para leitura e apresentacao dos resultados na planta
;;

(defun c:il_rslt(/ oldech oldblip oldhigh oldstl file_name htc f
                   rf fl im ft nv rfl lsvx lsvy vx vy cnt cnt1 cnt2
                   nrf n lsr lg cnivel xmax ymax xmin ymin dx dy
                   pta ptb imt il tx ic pti)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (setq file_name (getstring (strcat "\nNome do arquivo <" (getvar "dwgname") ">: ")))
  (if (= file_name "") (setq file_name (getvar "dwgname")))

  (setq file_name (strcat file_name ".imp"))

  (initget "Yes No")
  (setq htc (getkword "\nUsar hachuras para destacar itensidade luminosa <Yes>: "))
  (if (null htc) (setq htc "Yes"))

  (setq f (open file_name "r"))

  (setq
    rf (atoi (read-line f))       ;; codigo do refletor
    fl (atof (read-line f))       ;; fluxo luminoso total por refletor
    im (atof (read-line f))       ;; indice medio de desejado
    ft (atof (read-line f))       ;; fator de depreciacao
    nv (atoi (read-line f))       ;; numero de vertices
  ) ; end setq

  (setq rfl (il_getrefl rf))      ;; lista com caracteristicas do refletor

  (setq
    lsvx '()                      ;; lista das coordenadas x de cada vertice
    lsvy '()                      ;; lista das coordenadas y de cada vertice
  ) ; end setq

  (setq cnt 0)
  (while (< cnt 20)
    (setq
      vx (atof (read-line f))
      vy (atof (read-line f))
    ) ; end setq
    (if (< cnt nv)
      (setq
        lsvx (append (list vx) lsvx)
        lsvy (append (list vy) lsvy)
      ) ; end setq
    ) ; end if
    (setq cnt (+ cnt 1))
  ) ; end while

  (setq nrf (atoi (read-line f))) ;; numero de refletores

  (setq cnt 0)
  (while (< cnt 50)
    (read-line f) ;; Xrf
    (read-line f) ;; Yrf
    (read-line f) ;; Zrf
    (read-line f) ;; Xf
    (read-line f) ;; Yf
    (setq cnt (+ cnt 1))
  ) ; end while

  (setq n (atoi (read-line f)))   ;; numero de linhas do resultado

  (setq lsr '())                  ;; lista de resultados

  (setq cnt1 0)
  (while (< cnt1 19)
    (setq cnt2 0)
    (while (< cnt2 19)
      (setq il (atof (read-line f)))
      (if (< cnt1 n) (setq lsr (append lsr (list il))) )
      (setq cnt2 (+ cnt2 1))
    ) ; end while
    (setq cnt1 (+ cnt1 1))
  ) ; end while

  (setq lg 0)                     ;; total de refletores ligados

  (setq cnt 0)
  (while (< cnt 50)
    (if (= (atoi (read-line f)) -1) (setq lg (+ lg 1)))
    (setq cnt (+ cnt 1))
  ) ; end while

  (setq f (close f))

  (setq cnivel (getvar "clayer"))
  (if (tblsearch "layer" "IL-RESULTADO")
    (command ".layer" "t" "IL-RESULTADO" "s" "IL-RESULTADO" "")
    (command ".layer" "m" "IL-RESULTADO" "")
  ) ; end if

  ;; calculando area de processamento
  (setq
    xmax (* (eval (append '(max) lsvx)) (/ 1000.0 #UND))
    ymax (* (eval (append '(max) lsvy)) (/ 1000.0 #UND))
    xmin (* (eval (append '(min) lsvx)) (/ 1000.0 #UND))
    ymin (* (eval (append '(min) lsvy)) (/ 1000.0 #UND))
  ) ; end setq

  ;; calculando incremento de area
  (setq
    dx (/ (- xmax xmin) 19.0)
    dy (/ (- ymax ymin)    n)
  ) ; end setq

  ;; desenho das areas utilizadas no calculo
  (setq
    pta (list xmin ymin)
    ptb (list (+ xmin dx) (+ ymin dx))
  ) ; end setq

  (setq imt 0)                     ;; indice medio total obtido

  (setq oldblip (getvar "blipmode"))
  (setvar "blipmode" 0)
  (setq oldhigh (getvar "highlight"))
  (setvar "highlight" 0)

  (setq cnt1 0)
  (while (< cnt1 n)
    (setq cnt2 0)
    (while (< cnt2 19)
      (setq il (car lsr))
      (setq imt (+ imt il))
      (setq tx (- 1.0 (/ (- im il) im)) )
      (command
        ".pline" pta "w" 0 ""
          (list (car ptb) (cadr pta))
          ptb
          (list (car pta) (cadr ptb))
          "c"
      ) ; end command
      (if (= htc "Yes") (command ".hatch" "dots" (/ (* #SCL 100.0) tx) 0 "l" ""))
      (command
        ".text" "m" (list (+ (car pta) (/ dx 2.0)) (+ (cadr pta) (/ dy 2.0)))
                    (* 1.5 #SCL) "0" (rtos il 2 0)
      ) ; end command
      (setq
        pta (list (car ptb) (cadr pta))
        ptb (list (+ (car ptb) dx) (cadr ptb))
      ) ; end setq
      (setq lsr (cdr lsr))
      (setq cnt2 (+ cnt2 1))
    ) ; end while
    (setq
      pta (list xmin (cadr ptb))
      ptb (list (+ xmin dx) (+ (cadr ptb) dy))
    ) ; end setq
    (setq cnt1 (+ cnt1 1))
  ) ; end while

  (setq ic (/ imt (* 19 n)))               ;; indice medio obtido

  (setvar "blipmode" oldblip)
  (setvar "highlight" oldhigh)

  ;; inserindo tabela de dados utilizados
  (initget "Yes No")
  (if (/= (getkword "\nInserir tabela com dados do calculo <Yes>? ") "No")
    (progn
      (setq pti (getpoint "\nPonto de insercao (superior esquerdo): "))
      (setvar "blipmode" 0)
      (setq oldstl (getvar "textstyle"))
      (command
        ".style" "monotxt" "monotxt" 0 1 0 "n" "n" "n"
        ".text" pti (* 2.5 #SCL) "0"
                "CALCULO DE ILUMINACAO"
        ".text" ""
                "====================="
        ".text" (list (car pti) (- (cadr pti) (* 16.0 #SCL))) (* 2.0 #SCL) "0"
                "FABRICANTE      REFLETOR        LAMPADA(S)"
        ".text" ""
                "=============== =============== ========================================"
        ".text" ""
                (strcat (car rfl) " " (cadr rfl) " " (caddr rfl))
        ".text" (list (car pti) (- (cadr pti) (* 32.0 #SCL))) (* 2.0 #SCL) "0"
                "FLUXO LUMINOSO TOTAL POR REFLETOR =                    lm"
        ".text" ""
                "TOTAL DE REFLETORES               ="
        ".text" ""
                "FLUXO LUMINOSO TOTAL              =                    lm"
        ".text" ""
                "FATOR DE DEPRECIACAO              =                    %"
        ".text" ""
                "INDICE MEDIO DESEJADO             =                    lux"
        ".text" ""
                "INDICE MEDIO OBTIDO               =                    lux"
      ) ; end command
      (command
        ".text" "r" (list (+ (car pti) (* 54.0 2.0 #SCL)) (- (cadr pti) (* 32.0 #SCL))) (* 2.0 #SCL) "0"
                (rtos fl 2 0)
        ".text" ""
                (itoa lg)
        ".text" ""
                (rtos (* lg fl) 2 0)
        ".text" ""
                (rtos ft 2 1)
        ".text" ""
                (rtos im 2 0)
        ".text" ""
                (rtos ic 2 0)
        ".text" "s" oldstl pti (* 2.0 #SCL) 0 ""
      ) ; end command
      (setvar "blipmode" oldblip)
    ) ; end progn
  ) ; end if


  (command ".layer" "s" cnivel "")

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
