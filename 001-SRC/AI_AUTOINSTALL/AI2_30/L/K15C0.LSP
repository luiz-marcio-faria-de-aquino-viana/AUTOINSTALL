
;;
;; K15C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 19/11/99.
;;

;; c:ploter(): rotina para plotagem de desenhos com ajuste de escala
(defun c:ploter()
  (setq oldech (acadvar "cmdecho" 0))

  (or #PLSCL (setq #PLSCL #ESCL))

  (or #PLTYPE (setq #PLTYPE "Sulfite"))

  (setq BLKREV "SET20C00")

  (setq MAX_WIDTH (- 900.0 0.5 0.5))

  (setq MARG_TABLE '( ("SET12C" "A0MAX"  1559.0  841.0)
                      ("SET01C" "A0"     1189.0  841.0)
                      ("SET13C" "A1MAX"  1559.0  594.0)
                      ("SET02C" "A1"      841.0  594.0)
                      ("SET03C" "A2"      594.0  420.0)
                      ("SET04C" "A3"      420.0  297.0)
                      ("SET05C" "2A2"    1189.0  420.0)
                      ("SET06C" "2A3"     841.0  297.0)
                      ("SET07C" "A1A2"   1189.0  594.0)
                      ("SET08C" "A2A3"    891.0  420.0)
                      ("SET09C" "A3A4"    630.0  297.0)
                      ("SET0AC" "A2A3A4" 1050.0  297.0) )
  ) ; end setq

  (setq FORM_SIZE  '( ("A3"  422.0  299.0)
                      ("A2"  596.0  422.0)
                      ("A1"  843.0  596.0)
                      ("A0" 1191.0  843.0) )
  ) ; end setq

  (setq CARIMBO_TABLE '( "EL00C04"
                         "PC00C04"
                         "ES00C04"
                         "H00C04"
                         "INC00C04"
                         "G00C04"
                         "TE00C04"
                         "TI00C04"
                         "IE00C04"
                         "AR00C04"
                         "EX00C04" )
  ) ; end setq

  ;; selecao da area de impressao

  (setq flg_mrg nil)
  (if (setq enm_mrg (car (entsel "\nSelecione uma margem ou ENTER para marcar os pontos: ")) )
      (if (= (enttype enm_mrg) "INSERT")
        (progn
          (setq blk_mrg (substr (cdr (assoc 2 (entget enm_mrg))) 1 6) )
          (if (setq itm_mrg (cdr (assoc blk_mrg MARG_TABLE)) )
            (setq flg_mrg 't)
            (prompt "\nERR: Objeto selecionado nao e uma margem.")
          ) ; end if
        ) ; end progn
    ) ; end progn
  ) ; end if

  (if flg_mrg
    (progn
      (setq pt1 (cdr (assoc 10 (entget enm_mrg))) )
      (setq
        nfile_mrg (getdocname enm_mrg)
        etp_mrg (getetpprj enm_mrg)
      ) ; end setq
    ) ; end progn
    (progn
      (prompt "\nInforme os limites de impressao... ")
      (initget 1)
      (setq pt1 (getpoint "\nPrimeiro canto: "))
      (initget 1)
      (setq pt2 (getcorner pt1 "\nSegundo canto: "))
    ) ; end progn
  ) ; end if

  ;; escala de impressao

  (initget 6 "Corrente")
  (setq plscl (getreal (strcat "\nEscala para plotagem/(C)orrente <" (rtos #PLSCL 2 2) ">: ")))

  (if plscl
    (if (= plscl "Corrente")
      (setq #PLSCL #ESCL)
      (setq #PLSCL plscl)
    ) ; end if
  ) ; end if

  (setq fat (/ #PLSCL #UND))

  ;; identificacao da area de impressao

  (if flg_mrg
    (setq
      pta pt1
      ptb (mapcar '+ pt1 (mapcar '* (cdr itm_mrg) (list fat fat)) ) 
    ) ; end setq
    (setq
       pta (list (max (car pt1) (car pt2)) (max (cadr pt1) (cadr pt2)) )
       ptb (list (min (car pt1) (car pt2)) (min (cadr pt1) (cadr pt2)) )
    ) ; end setq
  ) ; end if
  (setq pta (list (+ (car pta) #SCL) (+ (cadr pta) #SCL)) )      ;; bug - correcao do problema com as linhas no limite da area de impressao

  ;; tipo de papel (sulfite/vegetal)

  (initget "Sulfite Vegetal")
  (setq pltype (getkword (strcat "\nPapel utilizado <" #PLTYPE ">: ")))
  (if pltype (setq #PLTYPE pltype))

  ;; numero de copias

  (initget 6)
  (setq ncpy (getint "\nNumero de copias < 1 >: "))
  (if (null ncpy) (setq ncpy 1))

  ;; informacoes de revisao

  (setq flg_rev nil)
  (if (and
        (= #PLTYPE "Vegetal")
        (setq enm_rev (car (entsel "\nSelecione a tabela de revisao ou [ENTER]: ")))
      ) ; end and
    (if (= (enttype enm_rev) "INSERT")
      (if (= (substr (cdr (assoc 2 (entget enm_rev))) 1 6) (substr BLKREV 1 6))
        (progn
          (setq flg_rev 't)
          (prompt "\nInforme a revisao realizada no desenho (max = 40 caracteres)")
          (while (= (setq dsc_rev (getstring t "\n:: ")) "")
            (prompt "\nERR: Entrada nula nao e valida.") )
        ) ; end progn
        (prompt "\nERR: Objeto selecionado nao e uma tabela de revisao.")
      ) ; end if
    ) ; end if
  ) ; end if

  ;; selecionando o bloco de revisao e o carimbo

  (setq ss1 (ssget "c" pta ptb))

  (if (null flg_rev)
    (progn
      (setq ss2 (ssget "x" (list '(0 . "INSERT") (cons 2 BLKREV))) )
      (if (setq ss (ssinter ss1 ss2))
        (setq
          enm_rev (ssname ss 0)
          flg_rev 't
        ) ; end setq
      ) ; end if
    ) ; end progn
  ) ; end if

  ;; selecionando o carimbo do desenho

  (setq flg_car nil)
  (while (and (null flg_car) (setq itm_car (car CARIMBO_TABLE)) )
    (setq ss2 (ssget "x" (list '(0 . "INSERT") (cons 2 itm_car))) )
    (if (setq ss (ssinter ss1 ss2))
      (setq
        enm_car (ssname ss 0)
        flg_car 't
      ) ; end setq
    ) ; end if
    (setq CARIMBO_TABLE (cdr CARIMBO_TABLE))
  ) ; end while

  ;; publicacao do documento (yes/no)

  (if (and flg_mrg flg_rev flg_car (= #PLTYPE "Vegetal"))
    (progn
      (initget "Yes No")
      (setq plpub (getkword (strcat "\nPublicar documento na Internet <No>: ")))
      (if (null plpub) (setq plpub "No"))
    ) ; end progn
  ) ; end if

  ;; nome do arquivo

  (if flg_mrg
    (setq nfile_tmp nfile_mrg)
    (setq nfile_tmp (getdwgname))
  ) ; end if

  (setq nfile (getstring (strcat "\nNome do arquivo <" nfile_tmp ">: ")) )
  (if (= nfile "") (setq nfile nfile_tmp))

  ;;
  ;; obtem informacoes para publicacao na internet
  ;;

  (if (= plpub "Yes")
    (progn
      (setq
        codigo_obra            (getprjname)
        nome_documento         (getdocname enm_mrg)
        descricao_documento    (getdocdesc enm_car)
        revisao_documento      (rtos (getdocrev enm_rev) 2 0)
        responsavel_publicacao (getuser)
        data_publicacao        (rtos (getvar "cdate") 2 0)
        validade_publicacao    "99999999"
        codigo_assunto         (gettrbdir)
        etapa_projeto          (getetpprj enm_mrg)
        escala_desenho         (rtos #ESCL 2 6)
        fator_ampliacao        (rtos (/ #ESCL #PLSCL) 2 6)
      ) ; end setq
    ) ; end progn
  ) ; end if

  ;;
  ;; preparacao inicial do processamento da impressao
  ;;

  (setq
    dx (- (car pta) (car ptb))
    dy (- (cadr pta) (cadr ptb))
  ) ; end setq

  (if (< dx dy)
    (setq
      plrot "Yes"
      deltx (/ dy fat)
      delty (/ dx fat)
    ) ; end setq
    (setq
      plrot "No"
      deltx (/ dx fat)
      delty (/ dy fat)
    ) ; end setq
  ) ; end if

  (while (and (null frm) (setq itm (car FORM_SIZE)) )
    (if (and (<= deltx (cadr itm)) (<= delty (caddr itm))) (setq frm itm) ) )
  (if (null frm) (setq frm (list "+A0" deltx delty)) )
  
  (prompt (strcat "\nFolha: < " (car frm) " >\t" (rtos deltx 2 2) " Larg\t\t" (rtos delty 2 2) " Alt"))
  (getstring "\nTecle [ENTER] p/ prosseguir.")  

  ;;
  ;; atualiza as informacoes no carimbo, na margem e na tabela de revisao
  ;;

  (if (and flg_rev (= #PLTYPE "Vegetal")) (updrev enm_rev dsc_rev) )
  (upddat)

  ;;
  ;; obtem a configuracao de penas
  ;;

  (setq lp '())
  (if (setq fn (findfile (v:ai "PLOTER.CFG")) )
    (if (setq f (open fn "r"))
      (progn
        (while (setq s (read-line f))
          (setq lp (append lp (list s))) )
        (setq f (close f))
      ) ; end progn
    ) ; end if
  ) ; end if

  ;;
  ;; constroi o arquivo de script de impressao
  ;;

  (if (setq f (open (v:appl "PLOTER.SCR") "w"))
    (progn
      (write-line "PLOT" f)
      (write-line "Window" f)
      (write-line (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6)) f)
      (write-line (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6)) f)
      (write-line "Yes" f)
      (write-line "Yes" f)

      ;; adiciona configuracao de penas se existir

      (if lp
        (foreach s lp (write-line s f))
        (write-line "No" f)
      ) ; end if

      (write-line "Yes" f)
      (write-line "M" f)
      (write-line "0,0" f)

      ;; rodar o arquivo de 90d se comprimento da folha for menor que a largura da ploter

      (if (< deltx MAX_WIDTH)
        (write-line (strcat (rtos deltx 2 6) "," (rtos (+ deltx 1.0) 2 6)) f)
        (write-line (strcat (rtos deltx 2 6) "," (rtos delty 2 6)) f)
      ) ; end if

      (write-line plrot f)
      (write-line "0.35" f)
      (write-line "No" f)
      (write-line "No" f)
      (write-line (strcat "1=" (rtos fat 2 6)) f)
      (write-line (strcat "C:\\SPOOL\\PLOT\\" nfile) f)
      (write-line (itoa ncpy) f)
      (write-line "" f)
      (write-line "Shell" f)
      (write-line (strcat "PLOTER " (strcase nfile) ".PLT" " " (car frm) " " #PLTYPE " " (itoa ncpy)) f)
      (if (= plpub "Yes")
        (write-line (strcat "WEBSND " (strcase nfile)) f) )
      (write-line (strcat "SCRIPT " (v:appl "NULSCR")) f)

      (setq f (close f))
    ) ; end progn
  ) ; end if

  ;;
  ;; construindo o arquivo de dados para publicacao
  ;;

  (if (= plpub "Yes")
    (if (setq f (open (strcat "C:\\SPOOL\\PLOT\\" nfile ".dat") "w"))
      (progn
        (write-line (strcat "codigo_obra=" codigo_obra) f)
        (write-line (strcat "nome_documento=" nome_documento) f)
        (write-line (strcat "descricao_documento=" descricao_documento) f)
        (write-line (strcat "revisao_documento=" revisao_documento) f)
        (write-line (strcat "responsavel_publicacao=" responsavel_publicacao) f)
        (write-line (strcat "data_publicacao=" data_publicacao) f)
        (write-line (strcat "codigo_assunto=" codigo_assunto) f)
        (write-line (strcat "etapa_projeto=" etapa_projeto) f)
        (write-line (strcat "escala_desenho=" escala_desenho) f)
        (write-line (strcat "fator_ampliacao=" fator_ampliacao) f)
        (setq f (close f))
      ) ; end progn
    ) ; end if
  ) ; end if

  ;;
  ;; processa o script de impressao
  ;;

  (command "script" (v:appl "PLOTER"))

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
