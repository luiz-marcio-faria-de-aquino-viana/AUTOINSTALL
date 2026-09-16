
;;
;; KES03C0.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 1/6/2000
;;

;; blocos: caixa de inspecao
(setq BLK_CAIXA_INSPECAO_60CM "es/es17c00")
(setq BLK_CAIXA_INSPECAO_100CM "es/es18c00")

;; valores padroes
(setq V_CI_UH 0.0)
(setq V_CI_PROFUNDIDADE -0.6)
(setq V_CI_DECLIVIDADE 0.5)
(setq V_CI_TMP_UH 0.0)

;; valores de unidades de hunter
(setq V_LS_UH '(6.0 6.0 2.0 1.0 1.0 2.0 0.5 3.0 2.0 3.0 3.0 2.0 3.0 5.0 0.0 ));

;; calcula_uh - funcao de calculo do total de unidades hunter
(defun calcula_uh()
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

  (setq V_CI_TMP_UH total)
) ; end defun

;; ddciinsert_uh_action_idc_qtd - funcao de acionamento por modificacao do campo quantidade
(defun ddciinsert_uh_action_idc_qtd()
  (calcula_uh)
) ; end defun

;; ddciinsert_uh_init - funcao de inicializacao do dialogo de calculo de unidades de hunter
(defun ddciinsert_uh_init()
  (set_tile "IDC_UH1" (rtos (nth 0 V_LS_UH) 2 1))
  (set_tile "IDC_QTD1" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL1" (rtos 0.0 2 1))
  (action_tile "IDC_QTD1" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH2" (rtos (nth 1 V_LS_UH) 2 1))
  (set_tile "IDC_QTD2" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL2" (rtos 0.0 2 1))
  (action_tile "IDC_QTD2" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH3" (rtos (nth 2 V_LS_UH) 2 1))
  (set_tile "IDC_QTD3" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL3" (rtos 0.0 2 1))
  (action_tile "IDC_QTD3" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH4" (rtos (nth 3 V_LS_UH) 2 1))
  (set_tile "IDC_QTD4" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL4" (rtos 0.0 2 1))
  (action_tile "IDC_QTD4" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH5" (rtos (nth 4 V_LS_UH) 2 1))
  (set_tile "IDC_QTD5" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL5" (rtos 0.0 2 1))
  (action_tile "IDC_QTD5" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH6" (rtos (nth 5 V_LS_UH) 2 1))
  (set_tile "IDC_QTD6" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL6" (rtos 0.0 2 1))
  (action_tile "IDC_QTD6" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH7" (rtos (nth 6 V_LS_UH) 2 1))
  (set_tile "IDC_QTD7" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL7" (rtos 0.0 2 1))
  (action_tile "IDC_QTD7" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH8" (rtos (nth 7 V_LS_UH) 2 1))
  (set_tile "IDC_QTD8" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL8" (rtos 0.0 2 1))
  (action_tile "IDC_QTD8" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH9" (rtos (nth 8 V_LS_UH) 2 1))
  (set_tile "IDC_QTD9" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL9" (rtos 0.0 2 1))
  (action_tile "IDC_QTD9" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH10" (rtos (nth 9 V_LS_UH) 2 1))
  (set_tile "IDC_QTD10" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL10" (rtos 0.0 2 1))
  (action_tile "IDC_QTD10" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH11" (rtos (nth 10 V_LS_UH) 2 1))
  (set_tile "IDC_QTD11" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL11" (rtos 0.0 2 1))
  (action_tile "IDC_QTD11" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH12" (rtos (nth 11 V_LS_UH) 2 1))
  (set_tile "IDC_QTD12" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL12" (rtos 0.0 2 1))
  (action_tile "IDC_QTD12" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH13" (rtos (nth 12 V_LS_UH) 2 1))
  (set_tile "IDC_QTD13" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL13" (rtos 0.0 2 1))
  (action_tile "IDC_QTD13" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH14" (rtos (nth 13 V_LS_UH) 2 1))
  (set_tile "IDC_QTD14" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL14" (rtos 0.0 2 1))
  (action_tile "IDC_QTD14" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_UH15" (rtos (nth 14 V_LS_UH) 2 1))
  (set_tile "IDC_QTD15" (rtos 0.0 2 2))
  (set_tile "IDC_TOTAL15" (rtos 0.0 2 1))
  (action_tile "IDC_QTD15" "(ddciinsert_uh_action_idc_qtd)")
  
  (set_tile "IDC_TOTAL_FINAL" (rtos 0.0 2 1))
) ; end defun

;; ddciinsert_uh_process()
(defun ddciinsert_uh_process()
  (set_tile "IDC_UH" (rtos V_CI_TMP_UH 2 1))
  (setq V_CI_UH V_CI_TMP_UH)
) ; end defun

;; ddciinsert_uh_cancel()
(defun ddciinsert_uh_cancel()
  (princ)
) ; end defun

(defun ddciinsert_action_btn_uh()
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
(defun ddciinsert_process()
  (setvar "cmdecho" 0)
  
  (setq uh (rtos V_CI_UH 2 1))
  (setq profundidade (rtos V_CI_PROFUNDIDADE 2 2))
  (setq declividade (rtos V_CI_DECLIVIDADE 2 1))

  (while (setq pti (getpoint "\nPonto de insercao: "))
    (progn
      (command ".-insert" (V:AID BLK_CAIXA_INSPECAO_60CM) pti (/ 1.0 (#UND)) "" 0.0)

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
  (setq V_CI_UH val)
) ; end defun

;; ddciinsert_action_idc_profundidade
(defun ddciinsert_action_idc_profundidade(/ val)
  (setq val (atof (get_tile "IDC_PROFUNDIDADE")))
  (setq V_CI_PROFUNDIDADE val)
) ; end defun

;; ddciinsert_action_idc_declividade
(defun ddciinsert_action_idc_declividade(/ val)
  (setq val (atof (get_tile "IDC_DECLIVIDADE")))
  (setq V_CI_DECLIVIDADE val)
) ; end defun

;; ddciinsert_init - funcao de inicializacao do dialogo de insercao de caixas de inspecao
(defun ddciinsert_init()
  (set_tile "IDC_UH" (rtos V_CI_UH 2 1))
  (set_tile "IDC_PROFUNDIDADE" (rtos V_CI_PROFUNDIDADE 2 2))
  (set_tile "IDC_DECLIVIDADE" (rtos V_CI_DECLIVIDADE 2 1))
	
  (action_tile "IDC_UH" "(ddciinsert_action_idc_uh)")
  (action_tile "IDC_PROFUNDIDADE" "(ddciinsert_action_idc_profundidade)")
  (action_tile "IDC_DECLIVIDADE" "(ddciinsert_action_idc_declividade)")
  (action_tile "BTN_UH" "(ddciinsert_action_btn_uh)")
) ; end defun

;; c:ai_es_ciinsert - funcao que insere caixas de inspecao no desenho
(defun c:ai_es_ciinsert()
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
(defun c:ai_es_ciproxima()
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

(princ)
