
;;
;; K5BC0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 2/23/96.
;;
;; Rotina para preparacao dos dados de entrada do Calculo de Iluminamento
;;

;; definicao de variaveis globais
(setq
  #R_IDENT 0
  #R_Z     (* 25.0 (/ 1000.0 (#UND)))
) ; end setq

;; c:il_refl(): rotina para insercao de refletores e focos no desenho
(defun c:il_refl(/ oldech oldlay rpt fpt id alt enm F_IDENT)
  (setq oldech (acadvar "cmdecho" 0))

  (initget 1)
  (setq rpt (getpoint "\nPonto de insercao do refletor: "))

  (initget 1)
  (setq fpt (getpoint rpt "\nMarque a posicao do foco: "))

  (setq #R_IDENT (+ #R_IDENT 1))
  (setq id (getint (strcat "\nIdentificacao do refletor <" (itoa #R_IDENT) ">: ")))
  (if id (setq #R_IDENT id))

  (setq F_IDENT #R_IDENT)

  (setq alt (getdist (strcat "\nAltura do refletor <" (rtos #R_Z 2 1) ">: ")))
  (if alt (setq #R_Z alt))

;  (command ".undo" "g")

  (setq oldlay (slay "IL-PONTOS"))

  ;; insercao do bloco do refletor
  (ai_insertpt (v:aid "EL\\EL3DC00") rpt (#SCL) fpt)

  (setq enm (entlast))
  (attvalue enm "R_IDENT"   (itoa #R_IDENT))
  (attvalue enm "R_MODEL"   "not-used")
  (attvalue enm "R_FLUXLUM" "not-used")
  (attvalue enm "R_FATDEPR" "not-used")
  (attvalue enm "R_X"       (rtos (car  rpt) 2 6))
  (attvalue enm "R_Y"       (rtos (cadr rpt) 2 6))
  (attvalue enm "R_Z"       (rtos #R_Z 2 6))
  (attvalue enm "F_IDENT"   (itoa F_IDENT))
  (entupd enm)

  ;; insercao do bloco do foco
  (ai_insertpt (v:aid "EL\\EL3CC00") fpt (#SCL) rpt)

  (setq enm (entlast) )
  (attvalue enm "F_IDENT"   (itoa F_IDENT))
  (attvalue enm "F_X"       (rtos (car  fpt) 2 6))
  (attvalue enm "F_Y"       (rtos (cadr fpt) 2 6))
  (attvalue enm "R_IDENT"   (itoa #R_IDENT))
  (entupd enm)

  (slay oldlay)

;  (command ".undo" "e")

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;; c:il_calc(): rotina para coletar dados do arquivo e iniciar o programa de calculo
(defun c:il_calc(/ oldech oldlay ff ls n pt ss3 max rf fl ft im ss ss1 ss2 ls1 cnt1 enm ent cnt2 f it
   R_IDENT1 R_MODEL1 R_FLUXLUM1 R_FATDEPR1 R_X1 R_Y1 R_Z1 F_IDENT1 F_IDENT2 F_X2 F_Y2 R_IDENT2)
  (setq oldech (acadvar "cmdecho" 0))

  (setq oldlay (slay "IL-PONTOS"))

  (prompt "\nMarque a area a ser analisada...")

  (initget 1)
  (setq pt1 (getpoint "\nPrimeiro canto: ") )

  (initget 1)
  (setq pt2 (getcorner pt1 "\nSegundo canto: ") )

  (setq n 2)
  (setq ls (list pt1 pt2))

  (prompt "\nSelecione os refletores (ENTER=todos)...")
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

  (textscr)
  (setq max (aci_il_dsprefl))

  (setq flg 't)
  (while flg
    (initget 7 "?")
    (setq rf (getint "\n\nSelecione um modelo de refletor (?): "))
    (cond
      ( (=  rf "?") (setq max (il_dsprefl)) )
      ( (<= rf max) (setq flg nil) )
      ( 't (prompt "\nERR: Modelo de refletor inexistente.") )
    ) ; end cond
  ) ; end while

  (initget 7)
  (setq fl (getreal "\nFluxo luminoso total das lampadas: "))

  (initget 6)
  (setq ft (getreal "\nFator de utilizacao <100%>: "))
  (if (null ft) (setq ft 100.0))

  (initget 7)
  (setq im (getreal "\nIndice medio de iluminamento desejado: "))

  (setq
    ls1 '()
    cnt1 (sslength ss1)
  ) ; end setq

  (prompt "\nAnalisando os dados..")

  (while (>= (setq cnt1 (1- cnt1)) 0)
    (setq
      enm (ssname ss1 cnt1)
      att (attread enm)
    ) ; end setq
    (setq
      R_IDENT1   (cadr (assoc "R_IDENT"   att))
      R_MODEL1   (cadr (assoc "R_MODEL"   att))
      R_FLUXLUM1 (cadr (assoc "R_FLUXLUM" att))
      R_FATDEPR1 (cadr (assoc "R_FATDEPR" att))
      R_X1       (/ (atof (cadr (assoc "R_X" att)) ) (/ 1000.0 (#UND)))
      R_Y1       (/ (atof (cadr (assoc "R_Y" att)) ) (/ 1000.0 (#UND)))
      R_Z1       (/ (atof (cadr (assoc "R_Z" att)) ) (/ 1000.0 (#UND)))
      F_IDENT1   (cadr (assoc "F_IDENT"   att))
    ) ; end setq

    (setq
      cnt2 (sslength ss2)
      flg  't
    ) ; end setq
    (while (and flg (>= (setq cnt2 (- cnt2 1)) 0))
      (setq
        enm (ssname ss2 cnt2)
        att (attread enm)
      ) ; end setq
      (setq
        F_IDENT2 (cadr (assoc "F_IDENT" att))
        F_X2     (/ (atof (cadr (assoc "F_X" att)) ) (/ 1000.0 (#UND)))
        F_Y2     (/ (atof (cadr (assoc "F_Y" att)) ) (/ 1000.0 (#UND)))
        R_IDENT2 (cadr (assoc "R_IDENT" att))
      ) ; end setq
      (if (and (= R_IDENT1 R_IDENT2) (= F_IDENT1 F_IDENT2))
        (setq
          ls1 (append ls1 (list (list (list R_X1 R_Y1 R_Z1) (list F_X2 F_Y2)) ) )
          flg nil
        ) ; end setq
      ) ; end if
    ) ; end while
  ) ; end while

  ;; construcao do arquivo de dados de calculo

  (prompt "\nAbrindo arquivo de saida...")

  (setq ff (strcat (getdwgdrive) (getdwgpath) "\\" (getdwgname) ".imp"))
  (if (setq f (open ff "w"))
    (progn
      (prompt "\nExportando os dados...")

      (write-line (itoa rf)          f)
      (write-line (rtos fl 2 0)      f)
      (write-line (rtos im 2 0)      f)
      (write-line (rtos ft 2 2)      f)
      (write-line (itoa (length ls)) f)
      (foreach it ls
        (write-line (rtos (/ (car  it) (/ 1000.0 (#UND))) 2 2) f)
        (write-line (rtos (/ (cadr it) (/ 1000.0 (#UND))) 2 2) f)
      ) ; end foreach
      (repeat (- 20 (length ls))
        (write-line "0.00" f)
        (write-line "0.00" f)
      ) ; end while
      (write-line (itoa (sslength ss1)) f)
      (foreach it ls1
        (write-line (rtos (car   (car  it)) 2 6) f)
        (write-line (rtos (cadr  (car  it)) 2 6) f)
        (write-line (rtos (caddr (car  it)) 2 6) f)
        (write-line (rtos (car   (cadr it)) 2 6) f)
        (write-line (rtos (cadr  (cadr it)) 2 6) f)
      ) ; end foreach
      (repeat (- 50 (sslength ss1))
        (write-line "0.00" f)
        (write-line "0.00" f)
        (write-line "0.00" f)
        (write-line "0.00" f)
        (write-line "0.00" f)
      ) ; end repeat
      (write-line "0.00" f)
      (repeat (* 19 19) (write-line "0.00" f))
      (repeat (sslength ss1) (write-line "-1" f))
      (repeat (- 50 (sslength ss1)) (write-line "0" f))
      (setq f (close f))

      (prompt "\nExportacao dos dados concluida.")
    ) ; end progn
  ) ; end if

  (slay oldlay)
;  (command ".undo" "e")

  (if (setq appd (getenv "LUMENS"))
    (progn
      (prompt "\nIniciando aplicacao externa...")
      (aci_xrun (strcat appd "LUMENS.EXE") (strcat (getdwgdrive) (getdwgpath) "\\" (getdwgname) ".imp"))
    ) ; end progn
    (prompt "\nERR: Localizacao da aplicacao externa nao informada.")
  ) ; end if

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;; c:il_modif(): rotina para modificar as posicoes dos refletores e dos focos
(defun c:il_modif(/ oldech ss1 ss2 cnt1 pt1 ent1a enm1 ent1 R_IDENT1 F_IDENT1 cnt2 enm2 ent2a ent2 F_IDENT2 R_IDENT2 rot1 rot2 pt2)
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

;; c:il_rslt(): rotina para leitura e apresentacao dos resultados na planta
(defun c:il_rslt(/ oldech oldblip oldhigh oldstl file_name htc f ffname
                   rf fl im ft nv rfl lsvx lsvy vx vy cnt cnt1 cnt2 q
                   nrf n lsr lg cnivel xmax ymax xmin ymin dx dy
                   pta ptb imt il tx ic pti max_il min_il)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (setq ffname (strcat (getdwgdrive) (getdwgpath) "\\" (getdwgname) ".imp"))
  (setq file_name (getstring (strcat "\nNome do arquivo <" ffname ">: ")))
  (if (= file_name "") (setq file_name ffname))

  (initget "Yes No")
  (setq htc (getkword "\nUsar hachuras para destacar itensidade luminosa <Yes>: "))
  (if (null htc) (setq htc "Yes"))

  (setq f (open file_name "r"))

  (setq
    rf (atoi (read-line f))       ;; codigo do refletor
    fl (atof (read-line f))       ;; fluxo luminoso total por refletor
    im (atof (read-line f))       ;; indice medio desejado
    ft (atof (read-line f))       ;; fator de depreciacao
    nv (atoi (read-line f))       ;; numero de vertices
  ) ; end setq

  (setq rfl (aci_il_getrefl rf))      ;; lista com caracteristicas do refletor

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

  (setq
    max_il nil
    min_il nil
  ) ; end setq

  (setq cnt1 0)
  (while (< cnt1 19)
    (setq cnt2 0)
    (while (< cnt2 19)
      (setq il (atof (read-line f)))
      (if (< cnt1 n)
        (progn
          (if (or (null max_il) (> il max_il)) (setq max_il il))
          (if (or (null min_il) (< il min_il)) (setq min_il il))
          (setq lsr (append lsr (list il)))
        ) ; end progn
      ) ; end if
      (setq cnt2 (+ cnt2 1))
    ) ; end while
    (setq cnt1 (+ cnt1 1))
  ) ; end while

  (if (< (- max_il min_il) 1.0)
    (setq q 1.0)
    (setq q (/ (- max_il min_il) 10.0))
  ) ; end if

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
    xmax (* (eval (append '(max) lsvx)) (/ 1000.0 (#UND)))
    ymax (* (eval (append '(max) lsvy)) (/ 1000.0 (#UND)))
    xmin (* (eval (append '(min) lsvx)) (/ 1000.0 (#UND)))
    ymin (* (eval (append '(min) lsvy)) (/ 1000.0 (#UND)))
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
      (command
        ".pline" pta "w" 0 ""
          (list (car ptb) (cadr pta))
          ptb
          (list (car pta) (cadr ptb))
          "c"
      ) ; end command
      (if (= htc "Yes")
        (progn
          (setq tx (/ (- max_il il) q))
          (command ".hatch" "tridots" (* (#SCL) (+ 1.0 (* 1.10 tx))) 0 "l" "")
        ) ; end progn
      ) ; end if
      (command
        ".text" "m" (list (+ (car pta) (/ dx 2.0)) (+ (cadr pta) (/ dy 2.0)))
                    (* 1.5 (#SCL)) "0" (rtos il 2 0)
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
        ".text" pti (* 2.5 (#SCL)) "0"
                "CALCULO DE ILUMINACAO"
        ".text" ""
                "====================="
        ".text" (list (car pti) (- (cadr pti) (* 16.0 (#SCL)))) (* 2.0 (#SCL)) "0"
                "FABRICANTE      REFLETOR        LAMPADA(S)"
        ".text" ""
                "=============== =============== ========================================"
        ".text" ""
                (strcat (car rfl) " " (cadr rfl) " " (caddr rfl))
        ".text" (list (car pti) (- (cadr pti) (* 32.0 (#SCL)))) (* 2.0 (#SCL)) "0"
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
        ".text" ""
                "INDICES MINIMO E MAXIMO OBTIDOS   =                    lux"
      ) ; end command
      (command
        ".text" "r" (list (+ (car pti) (* 54.0 2.0 (#SCL))) (- (cadr pti) (* 32.0 (#SCL)))) (* 2.0 (#SCL)) "0"
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
        ".text" ""
                (strcat "[ " (rtos min_il 2 0) " - " (rtos max_il 2 0) " ]")
        ".text" "s" oldstl pti (* 2.0 (#SCL)) 0 ""
      ) ; end command
      (setvar "blipmode" oldblip)
    ) ; end progn
  ) ; end if


  (command ".layer" "s" cnivel "")

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
