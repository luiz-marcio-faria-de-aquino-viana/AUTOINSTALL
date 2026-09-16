
;;
;; K1BC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 12/28/97
;;

;; ddsetup_val_escala(): funcao de validacao da caixa de edicao IDC_ESCALA
(defun ddsetup_val_escala(s / rst st n dd dv)
  (setq
    st  "i"
    rst -1
  ) ; end setq

  (setq dd "")
  (setq dv "")

  (while (< rst 0)
    (setq n (substr s 1 1))
    (cond
      ( (= st "i")
        (if (and (>= n "1") (<= n "9"))
          (setq
            dd (strcat dd n)
            st "1"
          ) ; end setq
          (setq rst  1)
        ) ; end if
      ) ; end case
      ( (= st "1")
        (if (and (>= n "0") (<= n "9"))
          (setq dd (strcat dd n))
          (if (= n "/")
            (setq st "2")
            (if (= n "") (setq rst 0) (setq rst 1))
          ) ; end if
        ) ; end if
      ) ; end case
      ( (= st "2")
        (if (and (>= n "1") (<= n "9"))
          (setq
            dv (strcat dv n)
            st "3"
          ) ; end setq
          (if (= n "") (setq rst 0) (setq rst 1))
        ) ; end if
      ) ; end case
      ( (= st "3")
        (if (and (>= n "0") (<= n "9"))
          (setq dv (strcat dv n))
          (if (= n "") (setq rst 0) (setq rst 1))
        ) ; end if
      ) ; end case
    ) ; end cond
    (setq s (substr s 2))
  ) ; end while
  (if (= dv "") (setq dv "1"))
  (if (= rst 0)
    (/ (atof dd) (atof dv))
    nil
  ) ; end if
) ; end defun

;; ddsetup_val_distance(): funcao de validacao das caixa de edicao IDC_LARGURA e IDC_ALTURA
(defun ddsetup_val_distance(s / st rst v n)
  (setq
    st  "i"
    rst -1
  ) ; end setq

  (setq v "")  

  (while (< rst 0)
    (setq n (substr s 1 1))
    (cond
      ( (= st "i")
        (if (and (>= n "0") (<= n "9"))
          (setq
            v (strcat v n)
            st "1"
          ) ; end setq
          (setq rst  1)
        ) ; end if
      ) ; end case
      ( (= st "1")
        (if (and (>= n "0") (<= n "9"))
          (setq v (strcat v n))
          (if (= n ".")
            (setq
              v (strcat v n)
              st "2"
            ) ; end setq
            (if (= n "") (setq rst 0) (setq rst 1))
          ) ; end if
        ) ; end if
      ) ; end case
      ( (= st "2")
        (if (and (>= n "0") (<= n "9"))
          (setq v (strcat v n))
          (if (= n "") (setq rst 0) (setq rst 1))
        ) ; end if
      ) ; end case
    ) ; end cond
    (setq s (substr s 2))
  ) ; end while
  (if (= rst 0) (atof v) nil)
) ; end defun

;; ddsetup_idc_escala(): funcao de acao da caixa de edicao IDC_ESCALA
(defun ddsetup_idc_escala(/ idx)
  (setq v_escl (get_tile "IDC_ESCALA"))
  (if (ddsetup_val_escala v_escl)
    (progn
      (if (setq idx (lpos v_escl LS_ESCL))
        (set_tile "IDC_LISTA_ESCALAS" (itoa idx))
        (set_tile "IDC_LISTA_ESCALAS" "-1")
      ) ; end if
      (set_tile "error" "")
    ) ; end progn
    (progn
      (set_tile "error" "ERR: Especificacao de escala invalida.")
      (mode_tile "IDC_ESCALA" 2)
    ) ; end progn
  ) ; end if
) ; end defun

;; ddsetup_idc_lista_escalas(): funcao de acao da caixa de listagem IDC_LISTA_ESCALAS
(defun ddsetup_idc_lista_escalas()
  (setq v_escl (nth (atoi (get_tile "IDC_LISTA_ESCALAS")) LS_ESCL))
  (set_tile "IDC_ESCALA" v_escl)
) ; end defun

;; ddsetup_idc_outro(): funcao de acao do botao de checagem IDC_OUTRO
(defun ddsetup_idc_outro()
  (if (= (get_tile "IDC_OUTRO") "0")
    (progn
      (mode_tile "IDC_PADRAO" 0)
      (mode_tile "IDC_LARGURA" 1)
      (mode_tile "IDC_ALTURA"  1)
    ) ; end progn
    (progn
      (mode_tile "IDC_PADRAO" 1)
      (mode_tile "IDC_LARGURA" 0)
      (mode_tile "IDC_ALTURA"  0)
    ) ; end progn
  ) ; end if
) ; end defun

;; ddsetup_idc_padrao(): funcao de acao da caixa de listagem IDC_PADRAO
(defun ddsetup_idc_padrao()
  (setq v_form (get_tile "IDC_PADRAO"))
  (setq
    v_larg  (rtos (car  (caddr (nth (atoi v_form) LS_FORM))) 2 1)
    v_alt   (rtos (cadr (caddr (nth (atoi v_form) LS_FORM))) 2 1)
  ) ; end setq
  (set_tile "IDC_LARGURA" v_larg)
  (set_tile "IDC_ALTURA" v_alt)
) ; end defun

;; ddsetup_idc_largura(): funcao de acao da caixa de edicao IDC_LARGURA
(defun ddsetup_idc_largura()
  (setq v_larg (get_tile "IDC_LARGURA"))
  (if (ddsetup_val_distance v_larg)
    (set_tile "error" "")
    (progn
      (set_tile "error" "ERR: Especificacao de largura de folha invalida.")
      (mode_tile "IDC_LARGURA" 2)
    ) ; end progn
  ) ; end if
) ; end defun

;; ddsetup_idc_altura(): funcao de acao da caixa de edicao IDC_ALTURA
(defun ddsetup_idc_altura()
  (setq v_alt (get_tile "IDC_ALTURA"))
  (if (ddsetup_val_distance v_alt)
    (set_tile "error" "")
    (progn
      (set_tile "error" "ERR: Especificacao de altura de folha invalida.")
      (mode_tile "IDC_ALTURA" 2)
    ) ; end progn
  ) ; end if
) ; end defun

;; ddsetup_validate(): funcao de validacao dos dados do dialogo
(defun ddsetup_validate()
  (setq
    v_escl  (get_tile "IDC_ESCALA")
    v_form  (get_tile "IDC_PADRAO")
    v_opcao (get_tile "IDC_OUTRO")
    v_larg  (get_tile "IDC_LARGURA")
    v_alt   (get_tile "IDC_ALTURA")
    v_unid  (get_tile "IDC_UNIDADE")
  ) ; end setq
  (and (ddsetup_val_escala v_escl) (ddsetup_val_distance v_larg) (ddsetup_val_distance v_alt) )
) ; end defun

;; ddsetup_init(): funcao de inicializacao dos controles do dialogo
(defun ddsetup_init(/ itm)
  (setq
    LS_ESCL '("1/1"   "1/5"   "1/10"  "1/20" "1/25"   "1/50"   "1/75"   "1/100"
              "1/125" "1/200" "1/250" "1/500" "1/750" "1/1000" "1/2000")

    LS_FORM '(("A0M+ (1744X841)"     "SET13C03" (1744.0 841.0))
	      ("A0M (1559X841)"      "SET12C03" (1559.0 841.0))
              ("A0M- (1374X841)"     "SET14C03" (1374.0 841.0))
	      ("A0 (1189x841)"       "SET01C03" (1189.0 841.0))
              ("A1 (841x594)"        "SET02C03" ( 841.0 594.0))
            ("A2 (594x420)"        "SET03C03" ( 594.0 420.0))
              ("A2+ (841x420)"       "SET11C03" ( 841.0 420.0))
	      ("A3 (420x297)"        "SET04C03" ( 420.0 297.0))
              ("2A2 (1189x420)"      "SET05C03" (1189.0 420.0))
              ("2A3 (841x297)"       "SET06C03" ( 841.0 297.0))
              ("A1+A2 (1189x594)"    "SET07C03" (1189.0 594.0))
              ("A1+A2M+ (1744x594)"  "SET16C03" (1744.0 594.0))
              ("A1+A2M (1559x594)"   "SET15C03" (1559.0 594.0))
	      ("A1+A2M- (1374x594)"  "SET17C03" (1374.0 594.0))
              ("A2+A3 (891x430)"     "SET08C03" ( 891.0 420.0))
              ("A3+A4 (630x297)"     "SET09C03" ( 630.0 297.0))
              ("A2+A3+A4 (1050x297)" "SET0AC03" (1050.0 297.0)) )
  ) ; end setq

  (setq
    v_escl  "1/50"
    v_form  "0"
    v_opcao "0"
    v_larg  (rtos (car  (caddr (nth (atoi v_form) LS_FORM))) 2 1)
    v_alt   (rtos (cadr (caddr (nth (atoi v_form) LS_FORM))) 2 1)
    v_unid  "IDC_CENTIMETRO"
  ) ; end setq

  (start_list "IDC_LISTA_ESCALAS")
  (foreach itm LS_ESCL (add_list itm))
  (end_list)

  (start_list "IDC_PADRAO")
  (foreach itm LS_FORM (add_list (car itm)) )
  (end_list)

  (set_tile "IDC_ESCALA"        v_escl)
  (set_tile "IDC_LISTA_ESCALAS" (itoa (lpos v_escl LS_ESCL)) )
  (set_tile "IDC_PADRAO"        v_form)
  (set_tile "IDC_OUTRO"         v_opcao)
  (set_tile "IDC_LARGURA"       v_larg)
  (set_tile "IDC_ALTURA"        v_alt)
  (set_tile "IDC_UNIDADE"       v_unid)

  (mode_tile "IDC_LARGURA" 1)
  (mode_tile "IDC_ALTURA"  1)

  (action_tile "IDC_ESCALA"        "(ddsetup_idc_escala)")
  (action_tile "IDC_LISTA_ESCALAS" "(ddsetup_idc_lista_escalas)")
  (action_tile "IDC_PADRAO"        "(ddsetup_idc_padrao)")
  (action_tile "IDC_OUTRO"         "(ddsetup_idc_outro)")
  (action_tile "IDC_LARGURA"       "(ddsetup_idc_largura)")
  (action_tile "IDC_ALTURA"        "(ddsetup_idc_altura)")
  (action_tile "accept"            "(if (ddsetup_validate) (done_dialog 0))")
  (action_tile "cancel"            "(done_dialog 1)")
) ; end defun

;; ddsetup_process(): funcao de processamento do comando de configuracao do desenho
(defun ddsetup_process(/ oldflg oldreq escl ss enm blk)
  (setq escl (ddsetup_val_escala v_escl))
  (cond
    ( (= v_unid "IDC_METRO")      (setq unid 1000.0) )
    ( (= v_unid "IDC_CENTIMETRO") (setq unid   10.0) )
    ( (= v_unid "IDC_MILIMETRO")  (setq unid    1.0) )
  ) ; end cond
  
  (setq
    verno  "AI 7"
    escl   (/ 1.0 escl)
    und    unid
    scl    (/ escl und)
    ;;owner  #USR
	owner  "unknow"
    date   (strcat
             (substr (rtos (getvar "cdate") 2 6) 7 2) "/"
             (substr (rtos (getvar "cdate") 2 6) 5 2) "/"
             (substr (rtos (getvar "cdate") 2 6) 3 2)
           ) ; end strcat
  ) ; end setq

  (if (= v_opcao "0")
    (setq
      larg (car  (caddr (nth (atoi v_form) LS_FORM)))
      alt  (cadr (caddr (nth (atoi v_form) LS_FORM)))
    ) ; end setq
    (setq
      larg (atof v_larg)
      alt  (atof v_alt)
    ) ; end setq
  ) ; end if

  (setvar "users1" "AI 7")
  (setvar "userr1" escl)
  (setvar "userr2" und)
  (setvar "userr3" larg)
  (setvar "userr4" alt)
  (setvar "users2" owner)
  (setvar "users3" (strcat
              (substr (rtos (getvar "cdate") 2 6) 7 2) "/"
              (substr (rtos (getvar "cdate") 2 6) 5 2) "/"
              (substr (rtos (getvar "cdate") 2 6) 3 2)
            ) ; end strcat
  ) ; end setvar

  (setvar "dimscale" scl)
  (setvar "ltscale"  (* 10.0 scl))
  (setvar "textsize" (*  2.0 scl))
  (setvar "snapunit" (list (/  25.0 und) (/  25.0 und)) )
  (setvar "gridunit" (list (/ 250.0 und) (/ 250.0 und)) )

  (command
    ".layer" "s" 0 ""
    ".limits" "0,0" (list (* scl larg) (* scl alt))
    ".zoom" "a"
  ) ; end command

  (if (= v_opcao "0")
    (progn
      (setq blk (cadr (nth (atoi v_form) LS_FORM)))
      (if (tblsearch "block" blk)
        (command ".insert" blk "0,0" scl "" 0)
        (command ".insert" (V:AID (strcat "SET/" blk)) "0,0" scl "" 0)
      ) ; end if
    ) ; end progn
    (progn
      (setq oldflg (acadvar "aflags" 8))
      (command
        ".pline" "0,0" "w" 0 ""
          (list (* larg scl) 0)
          (list (* larg scl) (* alt scl))
          (list 0            (* alt scl))
          "c"
        ".select" "l" ""
        ".pline" (list (* 20.0 scl) (* 10.0 scl)) "w" (* 0.5 scl) ""
          (list (* (- larg 10.0) scl) (* 10.0 scl))
          (list (* (- larg 10.0) scl) (* (- alt 10.0) scl))
          (list (* 20.0 scl)          (* (- alt 10.0) scl))
          "c"
        ".select" "p" "l" ""
        ".attdef" ""
          "CR_INFO" "Informacao" ""
          "r" (list (* (- larg 10.0) scl) (* 6.0 scl))
          (* 2.0 scl)
          "0"
        ".select" "p" "l" ""
        ".attdef" ""
          "CR_CODG" "Identificacao" ""
          "r" (list (* (- larg 10.0) scl) (* 3.0 scl))
          (* 2.0 scl)
          "0"
      ) ; end command
      (if (tblsearch "block" "SET11C0")
        (command ".block" "SET11C0" "y" "0,0" "p" "l" "")
        (command ".block" "SET11C0" "0,0" "p" "l" "")
      ) ; end if
      (command ".insert" "SET11C0" "0,0" "" "" "0")
      (setvar "aflags" oldflg)
    ) ; end progn
  ) ; end if

  (if (setq ss (ssget "x" '((0 . "INSERT") (2 . "SET0EC00"))) )
    (setq enm (entnext (ssname ss (- (sslength ss) 1))) )
    (progn
      (setq oldreq (acadvar "attreq" 0))
      (if (tblsearch "block" "SET0EC00")
        (command ".insert" "SET0EC00" "0,0" "" "" "0")
        (command ".insert" (V:AID "SET/SET0EC00") "0,0" "" "" "0")
      ) ; end if
      (setvar "attreq" oldreq)
      (setq enm (entlast))
    ) ; end progn
  ) ; end if

  (attvalue enm "#VER"   verno)
  (attvalue enm "#LARG"  (rtos larg 2 2))
  (attvalue enm "#ALT"   (rtos alt 2 2))
  (attvalue enm "#ESCL"  (rtos escl 2 2))
  (attvalue enm "#UNID"  (rtos und 2 2))
  (attvalue enm "#OWNER" owner)
  (attvalue enm "#DATE"  date)

  (princ)
) ; end defun

;; ddsetup_cancel(): funcao de cancelamento do comando de configuracao do desenho
(defun ddsetup_cancel()
  (setvar "users1" "AI 7")
  (setvar "userr1" 1.0)
  (setvar "userr2" 1.0)
  (setvar "userr3" 1189.0)
  (setvar "userr4" 841.0)
  (setvar "users2" #USR)
  (setvar "users3"
    (strcat
      (substr (rtos (getvar "cdate") 2 6) 7 2) "/"
      (substr (rtos (getvar "cdate") 2 6) 5 2) "/"
      (substr (rtos (getvar "cdate") 2 6) 3 2)
    ) ; end strcat
  ) ; end setvar
  (setvar "dimscale" 1.0)
  (setvar "ltscale"  10.0)
  (setvar "textsize" 2.0)
  (setvar "snapunit" '( 25.0  25.0))
  (setvar "gridunit" '(250.0 250.0))
) ; end defun

;; c:ddsetup(): rotina para configuracao dos parametros iniciais do desenho
(defun c:ddsetup(/ dlgid v_escl v_form v_opcao v_larg v_alt v_unid LS_ESCL LS_FORM)
  (if (> (setq dlgid (load_dialog (V:AIL "k1bc0"))) 0)
    (progn
      (if (new_dialog "ddsetup" dlgid)
        (progn
          (ddsetup_init)
          (if (= (start_dialog) 0) (ddsetup_process) (ddsetup_cancel))
        ) ; end progn
        (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
      ) ; end if
      (unload_dialog dlgid)
    ) ; end progn
    (prompt "\nERR: Nao foi possivel abrir o arquivo de dialogo.")
  ) ; end if
  (princ)
) ; end defun 

(princ)
