
;;
;; K85C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 2/12/98
;;

;; definicao das variaveis globais
(or #CATIDX (setq #CATIDX 0) )      ;; armazena o valor da categoria default

;; ddgdet_block(): funcao que cria ou modifica o bloco de detalhe
;;  cat - sigla do catalogo
;;  blk - nome do bloco
;;  lay - nome da camada padrao
;;  pt0 - ponto de insercao
;;  pti - ponto inicial da janela de selecao
;;  ptf - ponto final da janela de selecao
(defun ddgdet_block(cat blk lay pt0 pti ptf / oldlay oldecho oldblip oldhigh)
  (setq oldecho (acadvar "cmdecho" 0))

  (command ".undo" "g")
  (setq
    oldblip (acadvar "blipmode" 0)
    oldhigh (acadvar "highlight" 0)
  ) ; end setq

  (setq oldlay (slay lay))
  (command
    ".zoom"
      "c" (mapcar '/ (mapcar '+ pti ptf) '(2.0 2.0 2.0)) (abs (- (cadr ptf) (cadr pti)))
    ".change"
      "w" pti ptf ""
      "p" "la"
      lay
      ""
    ".mslide"
      (V:DET (strcat cat "/S/" blk))
    ".scale"
      "p" ""
      pt0
      (/ 1.0 (#SCL))
  ) ; end command
  (if (findfile (V:DET (strcat cat "/D/" blk ".dwg")))
    (command ".wblock" (V:DET (strcat cat "/D/" blk)) "y" "" pt0 "p" "")
    (command ".wblock" (V:DET (strcat cat "/D/" blk)) "" pt0 "p" "")
  ) ; end if
  (command
    ".oops"
    ".scale"
      "p" ""
      pt0
      (#SCL)
  ) ; end command
  (command ".zoom" "p")
  (slay oldlay)

  (setvar "blipmode" oldblip)
  (setvar "highlight" oldhigh)
  (command ".undo" "e")

  (setvar "cmdecho" oldecho)
) ; end defun

;; ddgdet_criar(): rotina de entrada de dados para criacao dos detalhes
(defun ddgdet_criar(/ pti ptf pt0 des blk cnt itm)

  (while (strnull (setq des (getstring 't "\nDescricao: ")))
    (prompt "\nERR: Entrada nula nao e valida.") )

  (initget 1)
  (setq pt0 (getpoint "\nPonto de insercao: "))

  (prompt "\nSelecione o detalhe...")
  (initget 1)
  (setq pti (getpoint "\nPrimeiro canto: "))
  (initget 1)
  (setq ptf (getcorner pti "\nSegundo canto: "))

  (setq
    blk (strcat (cadr cat_item) (lfill (caddr cat_item) 3 "0"))
    cnt (atoi (caddr cat_item))
  ) ; end setq

  (ddgdet_block (cadr cat_item) blk (cadddr cat_item) pt0 pti ptf)

  (setq itm (list (car cat_item) (cadr cat_item) (itoa (1+ cnt)) (cadddr cat_item)) )
  (setq
    cat_list (subst itm cat_item cat_list)
    cat_item itm
  ) ; end setq
  (fwrite (V:DET "classes.lst") cat_list "@")

  (setq itm (list des blk))
  (setq
    det_list  (xsort (cons itm det_list))
    det_index 0
    det_item  (nth det_index det_list)
  ) ; end setq
  (fwrite (V:DET (strcat (cadr cat_item) "/detalhes.lst")) det_list "@")
) ; end defun

;; ddgdet_alterar(): rotina de entrada de dados para alterar os detalhes
(defun ddgdet_alterar(/ des blk pt0 pti ptf itm)
  (setq
    des (car det_item)
    blk (cadr det_item)
  ) ; end setq

  (textscr)
  (prompt "\nDESCRICAO ORIGINAL")
  (prompt "\n------------------")
  (prompt (strcat "\n:: " des))
  (prompt "\n")
  (prompt "\nNOVA DESCRICAO (Tecle [ENTER] para manter a descricao anterior)")
  (prompt "\n--------------")
  (setq ndes (getstring 't "\n:: "))
  (if (not (strnull ndes)) (setq des ndes))

  (initget "Yes No")
  (setq opt (getkword "\nDeseja redefinir o detalhe <No>? "))
  (if (= opt "Yes")
    (progn
      (graphscr)

      (initget 1)
      (setq pt0 (getpoint "\nPonto de insercao: "))

      (prompt "\nSelecione o detalhe...")
      (initget 1)
      (setq pti (getpoint "\nPrimeiro canto: "))
      (initget 1)
      (setq ptf (getcorner pti "\nSegundo canto: "))

      (ddgdet_block (cadr cat_item) blk (cadddr cat_item) pt0 pti ptf)
    ) ; end progn
  ) ; end if

  (setq itm (list des blk))
  (setq
    det_list  (xsort (subst itm det_item det_list))
    det_index (lpos itm det_list)
    det_item  itm
  ) ; end setq
  (fwrite (V:DET (strcat (cadr cat_item) "/detalhes.lst")) det_list "@")

) ; end defun

;; ddgdet_inserir(): funcao de insercao do detalhe selecionado
(defun ddgdet_inserir(/ oldech oldlay pt0 blk dir lay)
  (initget 1)
  (setq pt0 (getpoint "\nPonto de insercao: "))

  (setq
    blk (cadr det_item)
    dir (V:DET (strcat (cadr cat_item) "/D/"))
    lay (cadddr cat_item)
  ) ; end setq

  (setq oldech (acadvar "cmdecho" 0))
  (command ".undo" "g")
  (setq oldlay (slay lay))
  (command ".insert" (strcat blk "=" dir blk) pt0 (#SCL) "" "0")
  (slay oldlay)
  (command ".undo" "e")
  (setvar "cmdecho" oldech)
) ; end defun

;; ddgdet_categoria(): funcao de resposta a um evento em categoria
(defun ddgdet_categoria()
  (setq #CATIDX (atoi (get_tile "IDC_CATEGORIA")) )
  (setq cat_item (nth #CATIDX cat_list))

  (setq det_list (aci_fileread (V:DET (strcat (cadr cat_item) "/detalhes.lst")) "@") )
  (setq det_index 0)
  (if det_list (setq det_item (nth det_index det_list)) )
) ; end defun

;; ddgdet_lista_detalhes(): funcao de resposta a um evento na lista de detalhes
(defun ddgdet_lista_detalhes()
  (setq det_index (atoi (get_tile "IDC_LISTA_DETALHES")) )
  (if det_list (setq det_item (nth det_index det_list)) )
) ; end defun

;; ddgdet_init(): rotina de inicializacao das variaveis de controle do dialogo
(defun ddgdet_init(/ itm)
  (setq cat_list (xsort (aci_fileread (V:DET "classes.lst") "@")) )
  (if (>= #CATIDX (length cat_list)) (setq #CATIDX 0) )
  (setq cat_item (nth #CATIDX cat_list))

  (setq det_list (aci_fileread (V:DET (strcat (cadr cat_item) "/detalhes.lst")) "@") )
  (setq det_index 0)
  (if det_list (setq det_item (nth det_index det_list)) )

  (start_list "IDC_CATEGORIA")
  (foreach itm cat_list (add_list (car itm)) )
  (end_list)

  (set_tile "IDC_CATEGORIA" (itoa #CATIDX))

  (start_list "IDC_LISTA_DETALHES")
  (foreach itm det_list (add_list (strcat (cadr itm) " - " (car itm))) )
  (end_list)

  (set_tile "IDC_LISTA_DETALHES" (itoa det_index))
) ; end defun

;; ddgdet_reinit(): rotina de re-inicializacao das variaveis de controle do dialogo
(defun ddgdet_reinit(/ itm)
  (start_image "IDC_IMAGEM_DETALHE")
  (fill_image 0 0 (dimx_tile "IDC_IMAGEM_DETALHE") (dimy_tile "IDC_IMAGEM_DETALHE") 0)
  (slide_image 0 0 (dimx_tile "IDC_IMAGEM_DETALHE") (dimy_tile "IDC_IMAGEM_DETALHE") (V:DET (strcat (cadr cat_item) "/S/" (cadr det_item))) )
  (end_image)

  (action_tile "IDC_CATEGORIA"           "(progn (ddgdet_categoria) (ddgdet_init) (ddgdet_reinit))")
  (action_tile "IDC_LISTA_DETALHES"      "(progn (ddgdet_lista_detalhes) (ddgdet_reinit))")
  (action_tile "IDC_DETALHE_ALTERAR"     "(done_dialog 3)")
  (action_tile "IDC_DETALHE_CRIAR"       "(done_dialog 2)")
  (action_tile "IDC_DETALHE_INSERIR"     "(done_dialog 1)")
  (action_tile "IDC_DETALHE_SAIR"        "(done_dialog 0)")
) ; end defun

;; c:ddgdet(): rotina de gerenciamento de detalhes
(defun c:ddgdet(/ dlgid rst cat_item cat_list det_item det_list det_index)
  (if (> (setq dlgid (load_dialog (V:AIL "k85c0"))) 0)
    (progn
      (if (new_dialog "ddgdet" dlgid)
        (progn
          (ddgdet_init)
          (ddgdet_reinit)
          (setq rst (start_dialog))
        ) ; end progn
        (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
      ) ; end if
      (cond
        ( (= rst 1) (ddgdet_inserir) )
        ( (= rst 2) (ddgdet_criar) )
        ( (= rst 3) (ddgdet_alterar) )
      ) ; end cond
      (unload_dialog dlgid)
    ) ; end progn
    (prompt "\nERR: Nao foi possivel abrir o arquivo de dialogo.")
  ) ; end if
  (princ)
) ; end defun

(princ)
