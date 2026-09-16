
;;
;; KES03C0.lsp
;; Copyright (C) 2000-2016 by Luiz Marcio F A Viana, 10/10/2016
;;

;; tabelas de calculos

(setq KES03_DESNIVEL_MINIMO_POR_CAIXA 0.03)    		      ;;desnivel minimo por caixa =3cm

(setq KES03_DISTANCIA_ENTRE_TUBULACOES (* 4.0 (#SCL)))	      ;;distancia em mm do papel

(setq KES03_DISTANCIA_ENTRE_TUBULACAO_E_CI (/ 1250.0 (#UND))) ;;distancia em mm do desenho

(setq KES03_DISTANCIA_INDICADOR (* 15.0 (#SCL)))              ;;distancia em mm do desenho

(setq KES03_DIAMETRO_TUBULACAO (/ 30.0 (#UND)))               ;;diametro tubulacao em mm do desenho

(setq KES03_ALTURA_TEXTO (* 2.0 (#SCL)))                      ;;altura do texto em mm do papel

(setq KES03_LISTA_UH_COLETOR_PREDIAL
  '(;;declividade =0.5%
    (200.0 0.5 1400.0)
    (250.0 0.5 2500.0)
    (300.0 0.5 3900.0)
    (400.0 0.5 7000.0)
    ;;declividade =1.0%
    (100.0 1.0 180.0)
    (150.0 1.0 700.0)
    (200.0 1.0 1600.0)
    (250.0 1.0 2900.0)
    (300.0 1.0 4600.0)
    (400.0 1.0 8300.0)
    ;;declividade =2.0%
    (100.0 2.0 216.0)
    (150.0 2.0 840.0)
    (200.0 2.0 1920.0)
    (250.0 2.0 3500.0)
    (300.0 2.0 5600.0)
    (400.0 2.0 10000.0)
    ;;declividade =4.0%
    (100.0 4.0 250.0)
    (150.0 4.0 1000.0)
    (200.0 4.0 2300.0)
    (250.0 4.0 4200.0)
    (300.0 4.0 6700.0)
    (400.0 4.0 12000.0) ) )

(setq KES03_MAX_NUMERO_COLETOR_PREDIAL 10)

;; blocos: caixa de inspecao
(setq KES03_BLK_CAIXA_INSPECAO_60CM "es/es17c00")
(setq KES03_BLK_CAIXA_INSPECAO_100CM "es/es18c00")

;; layer: camada das caixas de inspecao
(setq KES03_LAY_CAIXA_INSPECAO "ES-CI")

;; valores padroes
(setq KES03_V_CI_UH 0.0)
(setq KES03_V_CI_PROFUNDIDADE -0.6)
(setq KES03_V_CI_DECLIVIDADE 0.5)
(setq KES03_V_CI_TMP_UH 0.0)

;; valores de unidades de hunter
(setq KES03_V_LS_UH '(6.0 6.0 2.0 1.0 1.0 2.0 0.5 3.0 2.0 3.0 3.0 2.0 3.0 5.0 0.0 ));

;; calcula_uh - funcao de calculo do total de unidades hunter
(defun calcula_uh(/ total uh1 qtd1 uh2 qtd2 uh3 qtd3 uh4 qtd4 uh5 qtd5 uh6 qtd6 uh7 qtd7 uh8 qtd8 uh9 qtd9 uh10 qtd10
  uh11 qtd11 uh12 qtd12 uh13 qtd13 uh14 qtd14 uh15 qtd15)
  (setq total 0.0)
  
  (setq uh1 (atof (get_tile "IDC_UH1")))
  (setq qtd1 (atof (get_tile "IDC_QTD1")))
  (set_tile "IDC_TOTAL1" (rtos (* uh1 qtd1) 2 1))
  (setq total (+ total (* uh1 qtd1)))
  
  (setq uh2 (atof (get_tile "IDC_UH2")))
  (setq qtd2 (atof (get_tile "IDC_QTD2")))
  (set_tile "IDC_TOTAL2" (rtos (* uh2 qtd2) 2 1))
  (setq total (+ total (* uh2 qtd2)))
  
  (setq uh3 (atof (get_tile "IDC_UH3")))
  (setq qtd3 (atof (get_tile "IDC_QTD3")))
  (set_tile "IDC_TOTAL3" (rtos (* uh3 qtd3) 2 1))
  (setq total (+ total (* uh3 qtd3)))
  
  (setq uh4 (atof (get_tile "IDC_UH4")))
  (setq qtd4 (atof (get_tile "IDC_QTD4")))
  (set_tile "IDC_TOTAL4" (rtos (* uh4 qtd4) 2 1))
  (setq total (+ total (* uh4 qtd4)))
  
  (setq uh5 (atof (get_tile "IDC_UH5")))
  (setq qtd5 (atof (get_tile "IDC_QTD5")))
  (set_tile "IDC_TOTAL5" (rtos (* uh5 qtd5) 2 1))
  (setq total (+ total (* uh5 qtd5)))
  
  (setq uh6 (atof (get_tile "IDC_UH6")))
  (setq qtd6 (atof (get_tile "IDC_QTD6")))
  (set_tile "IDC_TOTAL6" (rtos (* uh6 qtd6) 2 1))
  (setq total (+ total (* uh6 qtd6)))
  
  (setq uh7 (atof (get_tile "IDC_UH7")))
  (setq qtd7 (atof (get_tile "IDC_QTD7")))
  (set_tile "IDC_TOTAL7" (rtos (* uh7 qtd7) 2 1))
  (setq total (+ total (* uh7 qtd7)))
  
  (setq uh8 (atof (get_tile "IDC_UH8")))
  (setq qtd8 (atof (get_tile "IDC_QTD8")))
  (set_tile "IDC_TOTAL8" (rtos (* uh8 qtd8) 2 1))
  (setq total (+ total (* uh8 qtd8)))
  
  (setq uh9 (atof (get_tile "IDC_UH9")))
  (setq qtd9 (atof (get_tile "IDC_QTD9")))
  (set_tile "IDC_TOTAL9" (rtos (* uh9 qtd9) 2 1))
  (setq total (+ total (* uh9 qtd9)))
  
  (setq uh10 (atof (get_tile "IDC_UH10")))
  (setq qtd10 (atof (get_tile "IDC_QTD10")))
  (set_tile "IDC_TOTAL10" (rtos (* uh10 qtd10) 2 1))
  (setq total (+ total (* uh10 qtd10)))
  
  (setq uh11 (atof (get_tile "IDC_UH11")))
  (setq qtd11 (atof (get_tile "IDC_QTD11")))
  (set_tile "IDC_TOTAL11" (rtos (* uh11 qtd11) 2 1))
  (setq total (+ total (* uh11 qtd11)))
  
  (setq uh12 (atof (get_tile "IDC_UH12")))
  (setq qtd12 (atof (get_tile "IDC_QTD12")))
  (set_tile "IDC_TOTAL12" (rtos (* uh12 qtd12) 2 1))
  (setq total (+ total (* uh12 qtd12)))
  
  (setq uh13 (atof (get_tile "IDC_UH13")))
  (setq qtd13 (atof (get_tile "IDC_QTD13")))
  (set_tile "IDC_TOTAL13" (rtos (* uh13 qtd13) 2 1))
  (setq total (+ total (* uh13 qtd13)))
  
  (setq uh14 (atof (get_tile "IDC_UH14")))
  (setq qtd14 (atof (get_tile "IDC_QTD14")))
  (set_tile "IDC_TOTAL14" (rtos (* uh14 qtd14) 2 1))
  (setq total (+ total (* uh14 qtd14)))
    
  (setq uh15 (atof (get_tile "IDC_UH15")))
  (setq qtd15 (atof (get_tile "IDC_QTD15")))
  (set_tile "IDC_TOTAL15" (rtos (* uh15 qtd15) 2 1))
  (setq total (+ total (* uh15 qtd15)))
    
  (set_tile "IDC_TOTAL_FINAL" (rtos total 2 1))

  (setq KES03_V_CI_TMP_UH total)
) ; end defun

;; ddciinsert_uh_action_idc_qtd - funcao de acionamento por modificacao do campo quantidade
(defun ddciinsert_uh_action_idc_qtd()
  (calcula_uh)
) ; end defun

;; ddciinsert_uh_init - funcao de inicializacao do dialogo de calculo de unidades de hunter
(defun ddciinsert_uh_init()
  (set_tile "IDC_UH1" (rtos (nth 0 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD1" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL1" (rtos 0.0 2 1))
  (action_tile "IDC_QTD1" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH2" (rtos (nth 1 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD2" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL2" (rtos 0.0 2 1))
  (action_tile "IDC_QTD2" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH3" (rtos (nth 2 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD3" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL3" (rtos 0.0 2 1))
  (action_tile "IDC_QTD3" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH4" (rtos (nth 3 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD4" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL4" (rtos 0.0 2 1))
  (action_tile "IDC_QTD4" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH5" (rtos (nth 4 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD5" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL5" (rtos 0.0 2 1))
  (action_tile "IDC_QTD5" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH6" (rtos (nth 5 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD6" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL6" (rtos 0.0 2 1))
  (action_tile "IDC_QTD6" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH7" (rtos (nth 6 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD7" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL7" (rtos 0.0 2 1))
  (action_tile "IDC_QTD7" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH8" (rtos (nth 7 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD8" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL8" (rtos 0.0 2 1))
  (action_tile "IDC_QTD8" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH9" (rtos (nth 8 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD9" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL9" (rtos 0.0 2 1))
  (action_tile "IDC_QTD9" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH10" (rtos (nth 9 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD10" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL10" (rtos 0.0 2 1))
  (action_tile "IDC_QTD10" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH11" (rtos (nth 10 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD11" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL11" (rtos 0.0 2 1))
  (action_tile "IDC_QTD11" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH12" (rtos (nth 11 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD12" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL12" (rtos 0.0 2 1))
  (action_tile "IDC_QTD12" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH13" (rtos (nth 12 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD13" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL13" (rtos 0.0 2 1))
  (action_tile "IDC_QTD13" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH14" (rtos (nth 13 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD14" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL14" (rtos 0.0 2 1))
  (action_tile "IDC_QTD14" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH15" (rtos (nth 14 KES03_V_LS_UH) 2 1))
  (set_tile "IDC_QTD15" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL15" (rtos 0.0 2 1))
  (action_tile "IDC_QTD15" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_TOTAL_FINAL" (rtos 0.0 2 1))
) ; end defun

;; ddciinsert_uh_process()
(defun ddciinsert_uh_process()
  (set_tile "IDC_UH" (rtos KES03_V_CI_TMP_UH 2 1))
  (setq KES03_V_CI_UH KES03_V_CI_TMP_UH)
) ; end defun

;; ddciinsert_uh_cancel()
(defun ddciinsert_uh_cancel()
  (princ)
) ; end defun

(defun ddciinsert_action_btn_uh(/ dlgid result)
  (setvar "cmdecho" 0)
	
  (if (> (setq dlgid (load_dialog (V:AIL "modules/es/kes03c0b"))) 0)
    (progn
      (if (new_dialog "ddciinsert_uh" dlgid)
        (progn
          (ddciinsert_uh_init)
          (setq result (start_dialog))
          (if (= result 1)
            (ddciinsert_uh_process)
            (ddciinsert_uh_cancel)
          ) ; end if
        ) ; end progn
        (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
      ) ; end if
      (unload_dialog dlgid)
    ) ; end progn
  ) ; end if
) ; end defun

;; ddciinsert_process()
(defun ddciinsert_process(/ uh profundidade declividade pti enm ent hnd)
  (setvar "cmdecho" 0)
  
  (setq uh (rtos KES03_V_CI_UH 2 1))
  (setq profundidade (rtos KES03_V_CI_PROFUNDIDADE 2 2))
  (setq declividade (rtos KES03_V_CI_DECLIVIDADE 2 1))

  (slay KES03_LAY_CAIXA_INSPECAO)
  
  (while (setq pti (getpoint "\nPonto de insercao: "))
    (progn
      (command ".-insert" (V:AID KES03_BLK_CAIXA_INSPECAO_60CM) pti (/ 1.0 (#UND)) "" 0.0)

      (setq enm (entlast))

      (setq ent (entget enm))

      (setq hnd (cdr (assoc 5 ent)))
      
      (attvalue enm "UH" uh)
      (attvalue enm "PROFUNDIDADE" profundidade)
      (attvalue enm "DECLIVIDADE" declividade)
      (attvalue enm "NUMEROCI" hnd)
    ) ; end progn
  ) ; end while

  (princ)
) ; end defun

;; ddciinsert_cancel()
(defun ddciinsert_cancel()
  (princ)
) ; end defun

;; ddciinsert_action_idc_uh
(defun ddciinsert_action_idc_uh(/ val)
  (setq val (atof (get_tile "IDC_UH")))
  (setq KES03_V_CI_UH val)
) ; end defun

;; ddciinsert_action_idc_profundidade
(defun ddciinsert_action_idc_profundidade(/ val)
  (setq val (atof (get_tile "IDC_PROFUNDIDADE")))
  (setq KES03_V_CI_PROFUNDIDADE val)
) ; end defun

;; ddciinsert_action_idc_declividade
(defun ddciinsert_action_idc_declividade(/ val)
  (setq val (atof (get_tile "IDC_DECLIVIDADE")))
  (setq KES03_V_CI_DECLIVIDADE val)
) ; end defun

;; ddciinsert_init - funcao de inicializacao do dialogo de insercao de caixas de inspecao
(defun ddciinsert_init()
  (set_tile "IDC_UH" (rtos KES03_V_CI_UH 2 1))
  (set_tile "IDC_PROFUNDIDADE" (rtos KES03_V_CI_PROFUNDIDADE 2 2))
  (set_tile "IDC_DECLIVIDADE" (rtos KES03_V_CI_DECLIVIDADE 2 1))
	
  (action_tile "IDC_UH" "(ddciinsert_action_idc_uh)")
  (action_tile "IDC_PROFUNDIDADE" "(ddciinsert_action_idc_profundidade)")
  (action_tile "IDC_DECLIVIDADE" "(ddciinsert_action_idc_declividade)")
  (action_tile "BTN_UH" "(ddciinsert_action_btn_uh)")
) ; end defun

;; c:ai_es_ciinsert - funcao que insere caixas de inspecao no desenho
(defun c:ai_es_ciinsert(/ dlgid result)
  (setvar "cmdecho" 0)
	
  (if (> (setq dlgid (load_dialog (V:AIL "modules/es/kes03c0a"))) 0)
    (progn
      (if (new_dialog "ddciinsert" dlgid)
        (progn
          (ddciinsert_init)
          (setq result (start_dialog))
          (if (= result 1)
            (ddciinsert_process)
            (ddciinsert_cancel)
          ) ; end if
        ) ; end progn
        (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
      ) ; end if
      (unload_dialog dlgid)
    ) ; end progn
  ) ; end if
) ; end defun

;; c:ai_es_ciproxima - funcao que define a ordem das caixas de inspecao
(defun c:ai_es_ciproxima(/ enm_orig enm_dest ent_dest hnd)
  (setvar "cmdecho" 0)
	
  (while (setq enm_orig (car (entsel "\nSelecione a caixa de inspecao origem: ")))
    (if (setq enm_dest (car (entsel "\nSelecione a caixa de inspecao destino: ")))
      (progn
        (setq ent_dest (entget enm_dest))
	
        (setq hnd (cdr (assoc 5 ent_dest)))
        (attvalue enm_orig "PROXIMACI" hnd)
      ) ; end progn
    ) ; end if
  ) ; end while
) ; end defun

;; cidimensiona_buildlista - funcao que associa as caixas de inspecao anterior de cada caixa
(defun cidimensiona_buildlista(ls / newLs it0 it1 lsAnterior1 numeroCI1 it2 it3 numeroCI2 proximaCI2 newIt)
  (setq newLs '())
  (foreach it0 ls
    (progn
      (setq it1 (cdr it0))
      
      (setq lsAnterior1 '())
      (setq numeroCI1 (cadr (assoc "NUMEROCI" it1)))
      (foreach it3 ls
	(progn
          (setq it2 (cdr it3))

          (setq
	    numeroCI2 (cadr (assoc "NUMEROCI" it2))
	    proximaCI2 (cadr (assoc "PROXIMACI" it2))
	  ) ; end setq
	  (if (= proximaCI2 numeroCI1)
	    (progn
	      (setq lsAnterior1 (cons numeroCI2 lsAnterior1))
	      ;;(princ numeroCI2)
	    ) ; end progn
	  ) ; end if
	) ; end progn
      ) ; end foreach
      (setq newIt (append it1 (list (cons "CIANTERIOR" (list lsAnterior1)))) )
      (setq newLs (append newLs (list (cons numeroCI1 newIt))))
    ) ; end progn
  ) ; end foreach
  newLs
) ; end defun

;; cidimensiona_findroot - funcao que associa as caixas de inspecao raiz
(defun cidimensiona_findroot(ls / it0 it numeroCI ciAnterior newLs)
  (setq newLs '())
  (foreach it0 ls
    (progn
      (setq it (cdr it0))
      
      (setq
	numeroCI (cadr (assoc "NUMEROCI" it))
	ciAnterior (cadr (assoc "CIANTERIOR" it))
      ) ; end setq
      (if (null ciAnterior)
	(setq newLs (cons numeroCI newLs))
      ) ; end if
    ) ; end progn
  ) ; end foreach
  newLs
) ; end defun

;; cidimensiona_findUHColetorPredial - funcao que pesquisa o coletor predial em funcao da declividade e unidades de hunter
(defun cidimensiona_findUHColetorPredial(declividade uh / result n it declividade_tmp uhMax_tmp)
  (setq result nil)
  (setq n 1)
  (while (and (not result) (<= (setq n (1+ n)) KES03_MAX_NUMERO_COLETOR_PREDIAL))
    (progn
      (foreach it KES03_LISTA_UH_COLETOR_PREDIAL
        (progn
          (setq
	    declividade_tmp (cadr it)
	    uhMax_tmp (caddr it)
	  ) ; end setq
	  (if (and (not result) (<= declividade declividade_tmp) (<= uh (* uhMax_tmp n))) (setq result (append (list n) it)))
        ) ; end progn
      ) ; end foreach
    ) ; end progn
  ) ; end while
  result
) ; end setq

;; cidimensiona_calculaUHAcumulada - funcao que calcula a unidade hunter acumulada para as caixas
(defun cidimensiona_calculaUHAcumulada(it ls / oCIAtual numeroCI uh uhAcumulada ciAnterior itAnterior uhAcumuladaCIAnterior numeroCIAnteior oCIAnterior newCIAtual proximaCI oProximaCI)
  (setq oCIAtual (cdr it))
  (setq
    numeroCI (cadr (assoc "NUMEROCI" oCIAtual))
    uh (atof (cadr (assoc "UH" oCIAtual)))
    uhAcumulada (atof (cadr (assoc "UHACUMULADA" oCIAtual)))
    ciAnterior (cadr (assoc "CIANTERIOR" oCIAtual))
  ) ; end setq
  (if (< uhAcumulada 0.1)
    (progn
      (setq uhAcumulada (+ uhAcumulada uh))
      (foreach itAnterior ciAnterior
        (progn
          (setq oCIAnterior (cdr (assoc itAnterior ls)))
          (setq
	    numeroCIAnterior (cadr (assoc "NUMEROCI" oCIAnterior))
	    uhAcumuladaCIAnterior (atof (cadr (assoc "UHACUMULADA" oCIAnterior)))
          ) ; end setq
          (if (= uhAcumuladaCIAnterior 0.0)
            (setq ls (cidimensiona_calculaUHAcumulada (cons numeroCIAnterior oCIAnterior) ls))
          ) ; end if
          (setq oCIAnterior (cdr (assoc itAnterior ls)))
          (setq uhAcumuladaCIAnterior (atof (cadr (assoc "UHACUMULADA" oCIAnterior))) )
          (setq uhAcumulada (+ uhAcumulada uhAcumuladaCIAnterior))
        ) ; end progn
      ) ; end foreach
      (setq newCIAtual (subst (list "UHACUMULADA" (rtos uhAcumulada 2 1)) (assoc "UHACUMULADA" oCIAtual) oCIAtual))
      (setq ls (subst (cons numeroCI newCIAtual) (assoc numeroCI ls) ls))
    ) ; end progn
  ) ; end if
  (setq
    proximaCI (cadr (assoc "PROXIMACI" oCIAtual))
  ) ; end setq
  (if (/= proximaCI "0")
    (progn
      (setq oProximaCI (cdr (assoc proximaCI ls)) )
      (setq ls (cidimensiona_calculaUHAcumulada (cons proximaCI oProximaCI) ls))
    ) ; end progn
  ) ; end if
  ls
) ; end defun

;; cidimensiona_processa1 - funcao que calcula a unidade hunter acumulada das caixas
(defun cidimensiona_processa1(ls_root ls / oCIAtual numeroCI)
  (setq numeroCI (car ls_root))
  (setq oCIAtual (cdr (assoc numeroCI ls)))
  (setq ls (cidimensiona_calculaUHAcumulada (cons numeroCI oCIAtual) ls))
  ls
) ; end defun

;; cidimensiona_calculaColetor - funcao que calcula o coletor para a caixa de inspecao
(defun cidimensiona_calculaColetor(it ls / oCIAtual numeroCI oProximaCI proximaCI uh uhAcumulada diametro diametroTubulacao profundidade
  declividade qtdTubulacao ciAnterior uhColetor newCIAtual enmCI entCI ptiCI enmProximaCI entProximaCI ptiProximaCI fatorUndToMetro
  dh profundidadeProximaCI profProximaCIOrig newProximaCI)
  (setq oCIAtual (cdr it))
  (setq
    numeroCI (cadr (assoc "NUMEROCI" oCIAtual))
    proximaCI (cadr (assoc "PROXIMACI" oCIAtual))
    uh (atof (cadr (assoc "UH" oCIAtual)))
    uhAcumulada (atof (cadr (assoc "UHACUMULADA" oCIAtual)))
    diametro (atof (cadr (assoc "DIAMETRO" oCIAtual)))
    diametroTubulacao (atof (cadr (assoc "DIAMETROTUBULACAO" oCIAtual)))
    profundidade (atof (cadr (assoc "PROFUNDIDADE" oCIAtual)))
    declividade (atof (cadr (assoc "DECLIVIDADE" oCIAtual)))
    qtdTubulacao (atof (cadr (assoc "QTDTUBULACAO" oCIAtual)))
    ;;cotaFundo (atof (cadr (assoc "COTAFUNDO" oCIAtual)))
    ciAnterior (cadr (assoc "CIANTERIOR" oCIAtual))
  ) ; end setq

  (setq uhColetor (cidimensiona_findUHColetorPredial declividade uhAcumulada))
  (setq
    diametroTubulacao (cadr uhColetor)
    qtdTubulacao (car uhColetor)
  ) ; end setq

  (setq newCIAtual (subst (list "DIAMETROTUBULACAO" (rtos diametroTubulacao 2 1)) (assoc "DIAMETROTUBULACAO" oCIAtual) oCIAtual))
  (setq newCIAtual (subst (list "QTDTUBULACAO" (rtos qtdTubulacao 2 1)) (assoc "QTDTUBULACAO" newCIAtual) newCIAtual))
  (setq ls (subst (cons numeroCI newCIAtual) (assoc numeroCI ls) ls))

  (setq enmCI (handent numeroCI))
  (setq entCI (entget enmCI))
  (setq ptiCI (cdr (assoc 10 entCI)))
  (if (/= proximaCI "0")
    (progn
      (setq oProximaCI (cdr (assoc proximaCI ls)))

      (setq profProximaCIOrig (atof (cadr (assoc "PROFUNDIDADE" oProximaCI))))

      (setq enmProximaCI (handent proximaCI))
      (setq entProximaCI (entget enmProximaCI))
      (setq ptiProximaCI (cdr (assoc 10 entProximaCI)))

      (setq fatorUndToMetro (/ 1000.0 (#UND)))
      
      (setq dh (/ (* (/ declividade 100.0) (distance ptiCI ptiProximaCI)) fatorUndToMetro) )  ;; diferenca de altura em metros
      (setq profundidadeProximaCI (- profundidade KES03_DESNIVEL_MINIMO_POR_CAIXA dh))

      (setq newProximaCI oProximaCI)
      (if (< profundidadeProximaCI profProximaCIOrig)
	(progn
          (setq newProximaCI (subst (list "PROFUNDIDADE" (rtos profundidadeProximaCI 2 3)) (assoc "PROFUNDIDADE" oProximaCI) oProximaCI))
          (if (>= profundidadeProximaCI 1.0)
            (setq newProximaCI (subst (list "DIAMETRO" 1.0) (assoc "DIAMETRO" newProximaCI) newProximaCI))
          ) ; end if
          (setq ls (subst (cons proximaCI newProximaCI) (assoc proximaCI ls) ls))
	) ; end progn
      ) ; end if

      (setq ls (cidimensiona_calculaColetor (cons proximaCI newProximaCI) ls))
    ) ; end progn
  ) ; end if
  ls
) ; end defun

;; cidimensiona_processa2 - funcao que dimensiona as caixas de inspecao
(defun cidimensiona_processa2(ls_root ls / oCIAtual numeroCI)
  (foreach numeroCI ls_root
    (progn
      (setq oCIAtual (cdr (assoc numeroCI ls)))
      (setq ls (cidimensiona_calculaColetor (cons numeroCI oCIAtual) ls))
    ) ; end setq
  ) ; end foreach
  ls
) ; end defun

;;cidimensiona_desenhaIndicador - funcao que desenha o indicador da caixa de inspecao
(defun cidimensiona_desenhaIndicador(ptiCI diametro profundidade / pt1 pt2 pt3)
  (slay "ES-TEXTO")
  (setq pt1 (mapcar '+ ptiCI (list KES03_DISTANCIA_INDICADOR KES03_DISTANCIA_INDICADOR 0.0)))
  (setq pt2 (mapcar '+ pt1 (list KES03_DISTANCIA_INDICADOR 0.0 0.0)))
  (command ".pline" ptiCI "w" 0.0 "" pt1 pt2 "")
  (setq pt3 (mapcar '+ pt1 (list KES03_ALTURA_TEXTO 0.0 0.0)))
  (command ".text" (mapcar '+ pt3 (list 0.0 KES03_ALTURA_TEXTO 0.0)) KES03_ALTURA_TEXTO 0 (strcat "D=" (rtos diametro 2 1) "mm"))
  (command ".text" (mapcar '- pt3 (list 0.0 (* KES03_ALTURA_TEXTO 2.0) 0.0)) KES03_ALTURA_TEXTO 0 (strcat "P=" (rtos profundidade 2 2) "m"))
) ; end defun

;; cidimensiona_desenhaTubulacoes - funcao que desenha as tubulacoes e insere a indicacao do diametro
(defun cidimensiona_desenhaTubulacoes(ptiCI ptiProximaCI qtdTubulacao diametroTubulacao /
  v12 u12 n12 d0 v12_d pt0_i pt0_f n)
  (setq v12 (mapcar '- ptiProximaCI ptiCI))
  (setq
    u12 (vtunit v12)
    n12 (vtnorm u12)
  ) ; end setq
  (setq d0 (* KES03_DISTANCIA_ENTRE_TUBULACOES (/ (- qtdTubulacao 1.0) 2.0)))
  (setq v12_d (vtmul KES03_DISTANCIA_ENTRE_TUBULACAO_E_CI u12))
  (setq
    pt0_i (mapcar '+ (mapcar '+ ptiCI (vtmul d0 n12)) v12_d)
    pt0_f (mapcar '- (mapcar '+ ptiProximaCI (vtmul d0 n12)) v12_d)
  ) ; end setq
  (setq n 0)
  (while (< n qtdTubulacao)
    (progn
      (slay "ES-PRIMARIO")
      (command ".pline" ptiCI "w" KES03_DIAMETRO_TUBULACAO "" pt0_i pt0_f ptiProximaCI "")

      (slay "ES-TEXTOS")
      (setq ptc (mapcar '/ (mapcar '+ pt0_i pt0_f) '(2.0 2.0 2.0)))
      (command ".text" ptc KES03_ALTURA_TEXTO pt0_f (strcat (rtos diametroTubulacao 2 1) "mm"))
      (setq
        pt0_i (mapcar '- pt0_i (vtmul KES03_DISTANCIA_ENTRE_TUBULACOES n12))
        pt0_f (mapcar '- pt0_f (vtmul KES03_DISTANCIA_ENTRE_TUBULACOES n12))
      ) ; end setq
      (setq n (1+ n))
    ) ; end progn
  ) ; end while
) ; end defun
  
;; cidimensiona_atualizaCI - funcao que atualiza os dados das CIs e desenha as tubulacoes e identificadores
(defun cidimensiona_atualizaCI(it ls / oCIAtual numeroCI proximaCI uh uhAcumulada diametro diametroTubulacao profundidade
  declividade qtdTubulacao ciAnterior uhColetor newCIAtual enmCI entCI ptiCI enmProximaCI entProximaCI ptiProximaCI fatorUndToMetro
  dh profundidadeProximaCI newProximaCI)
  (setq oCIAtual (cdr it))
  (setq
    numeroCI (cadr (assoc "NUMEROCI" oCIAtual))
    proximaCI (cadr (assoc "PROXIMACI" oCIAtual))
    uh (atof (cadr (assoc "UH" oCIAtual)))
    uhAcumulada (atof (cadr (assoc "UHACUMULADA" oCIAtual)))
    diametro (atof (cadr (assoc "DIAMETRO" oCIAtual)))
    diametroTubulacao (atof (cadr (assoc "DIAMETROTUBULACAO" oCIAtual)))
    profundidade (atof (cadr (assoc "PROFUNDIDADE" oCIAtual)))
    declividade (atof (cadr (assoc "DECLIVIDADE" oCIAtual)))
    qtdTubulacao (atof (cadr (assoc "QTDTUBULACAO" oCIAtual)))
    ;;cotaFundo (atof (cadr (assoc "COTAFUNDO" oCIAtual)))
    ciAnterior (cadr (assoc "CIANTERIOR" oCIAtual))
  ) ; end setq

  (setq enmCI (handent numeroCI))
  (setq entCI (entget enmCI))
  (setq ptiCI (cdr (assoc 10 entCI)))

  (attvalue enmCI "DIAMETRO" (rtos diametro 2 1))
  (attvalue enmCI "PROFUNDIDADE" (rtos profundidade 2 2))
  (attvalue enmCI "QTDTUBULACAO" (rtos qtdTubulacao 2 0))
  (attvalue enmCI "DIAMETROTUBULACAO" (rtos diametroTubulacao 2 1))
  
  (cidimensiona_desenhaIndicador ptiCI diametro profundidade)
  
  (if (/= proximaCI "0")
    (progn
      (setq oProximaCI (cdr (assoc proximaCI ls)))
  
      (setq enmProximaCI (handent proximaCI))
      (setq entProximaCI (entget enmProximaCI))
      (setq ptiProximaCI (cdr (assoc 10 entProximaCI)))

      (cidimensiona_desenhaTubulacoes ptiCI ptiProximaCI qtdTubulacao diametroTubulacao)

      (setq ls (cidimensiona_atualizaCI (cons proximaCI oProximaCI) ls))
    ) ; end progn
  ) ; end if
  ls
) ; end defun

;; cidimensiona_processa3 - funcao que dimensiona as caixas de inspecao
(defun cidimensiona_processa3(ls_root ls / oCIAtual numeroCI)
  (foreach numeroCI ls_root
    (progn
      (setq oCIAtual (cdr (assoc numeroCI ls)))
      (cidimensiona_atualizaCI (cons numeroCI oCIAtual) ls)
    ) ; end setq
  ) ; end foreach
) ; end defun

;; c:ai_es_cidimensiona - funcao que dimensiona as caixas de inspecao
(defun c:ai_es_cidimensiona(/ filter ss ls1 n enm att ls2 ls_root ls_result1 numeroCI)
  (setvar "cmdecho" 0)

  (setq ls_result '())
  
  (setq filter (list (cons 0 "INSERT") (cons 8 KES03_LAY_CAIXA_INSPECAO)) )
  
  (prompt "\nSelecione as caixas para dimensionamento...")
  (if (setq ss (ssget filter))
    (progn
      (setq ls1 '())
      
      (setq n (sslength ss))
      (while (>= (setq n (- n 1)) 0)
	(setq enm (ssname ss n))
	(setq att (attread enm))
	(setq numeroCI (cadr (assoc "NUMEROCI" att)))
	(setq ls1 (append ls1 (list (cons numeroCI att))))
      ) ; end setq

      (setq ls2 (cidimensiona_buildlista ls1))

      (setq ls_root (cidimensiona_findroot ls2))

      (setq ls_result1 (cidimensiona_processa1 ls_root ls2))

      (setq ls_result2 (cidimensiona_processa2 ls_root ls_result1))
      
      (command ".undo" "g")

      (cidimensiona_processa3 ls_root ls_result2)

      (command ".undo" "e")
      
    ) ; end progn
  ) ; end if
  ls_result
) ; end defun

(princ)
