
;;
;; K31C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 5/27/96.
;;

;; hdrdsp: rotina que apresenta a linha de cabecalho
;;   opt - opcao para o tipo de cabecalho a apresentar
(defun hdrdsp(opt)
  (prompt "e[2J")
  (cond
    ((= opt "Quadros")    (progn
                            (prompt "\nCdg Descricao                 Nome do quadro  Origem          Pot    PotDem Cor")
                            (prompt "\n--- ------------------------- --------------- --------------- ------ ------ ---")
    )                     ) ; end progn, case
    ((= opt "CArgas")     (progn
                            (prompt "\nCdg Descricao                 Origem          Circ Cmd  Pot    Fase  ")
                            (prompt "\n--- ------------------------- --------------- ---- ---- ------ ------")
    )                     ) ; end progn, case
    ((= opt "Iluminacao") (progn
                            (prompt "\nCdg Descricao                 Origem          Circ Cmd  Pot    Fase  ")
                            (prompt "\n--- ------------------------- --------------- ---- ---- ------ ------")
    )                     ) ; end progn, case
    ((= opt "CAMpainhas") (progn
                            (prompt "\nCdg Descricao                 Origem          Circ Cmd  Pot    Fase  ")
                            (prompt "\n--- ------------------------- --------------- ---- ---- ------ ------")
    )                     ) ; end progn, case
    ((= opt "COmandos")   (progn
                            (prompt "\nCdg Descricao                 Origem          Cmd ")
                            (prompt "\n--- ------------------------- --------------- ----")
    )                     ) ; end progn, case
    ((= opt "CAIxas")     (progn
                            (prompt "\nCdg Descricao                 Origem         ")
                            (prompt "\n--- ------------------------- ---------------")
    )                     ) ; end progn, case
  ) ; end cond
) ; end defun

;; datdsp: rotina que apresenta os dados do elemento
;;   opt - opcao para o tipo de elemento a apresentar
;; parametros com informacoes a serem apresentadas
;;   cdg - codigo do elemento
;;   des - descricao
;;   qdr - nome do quadro
;;   org - quadro de origem
;;   crc - identificacao do circuito
;;   cmd - identificacao do comando
;;   pot - potencia
;;   dem - potencia demandada
;;   fas - sistema de fase
;;   col - cor do elemento
(defun datdsp(opt cdg des qdr org crc cmd pot dem fas col)
  (prompt (strcat "\n" (lfill cdg 3 " ") " " (rfill des 25 " ") " "))
  (cond
    ((= opt "Quadros")    (prompt (strcat (rfill qdr 15 " ") " " (rfill org 15 " ") " " (lfill pot 6 " ") " " (lfill dem 6 " ") " " (lfill col 3 " "))) )
    ((= opt "CARgas")     (prompt (strcat (rfill org 15 " ") " " (lfill crc  4 " ") " " (lfill cmd 4 " ") " " (lfill pot 6 " ") " " (rfill fas 6 " "))) )
    ((= opt "Iluminacao") (prompt (strcat (rfill org 15 " ") " " (lfill crc  4 " ") " " (lfill cmd 4 " ") " " (lfill pot 6 " ") " " (rfill fas 6 " "))) )
    ((= opt "CAMpainhas") (prompt (strcat (rfill org 15 " ") " " (lfill crc  4 " ") " " (lfill cmd 4 " ") " " (lfill pot 6 " ") " " (rfill fas 6 " "))) )
    ((= opt "COmandos")   (prompt (strcat (rfill org 15 " ") " " (lfill cmd  4 " "))) )
    ((= opt "CAIxas")     (prompt (strcat (rfill org 15 " ") " " (lfill crc  4 " "))) )
  ) ; end cond
) ; end defun

;; datlst: rotina que lista os dados de todos os elementos
;;   ss  - conjunto de selecao a ser efetuada a listagem
;;   opt - opcao para o tipo de elemento a apresentar
(defun datlst(ss opt / idx cnt fnd enm ent att cdg des qdr org crc cmd pot dem fas col)
  (textscr)
  (hdrdsp opt)
  (setq idx 0)
  (setq cnt (- (sslength ss) 1))
  (while (>= cnt 0)
    (setq enm (ssname ss cnt))
    (setq idx (+ idx 1))
    (setq
      ent (entget  enm)
      att (attread enm)
    ) ; end setq
    (setq
      cdg (itoa idx)
      des (car (readdef (cdr (assoc 2 ent))))
      qdr (cadr (assoc "#NOME_QUADRO"        att))
      org (cadr (assoc "#QUADRO_ORIGEM"      att))
      crc (cadr (assoc "#CIRCUITO"           att))
      cmd (cadr (assoc "#COMANDO"            att))
      pot (cadr (assoc "#POTENCIA"           att))
      dem (cadr (assoc "#POTENCIA_DEMANDADA" att))
      fas (cadr (assoc "#SISTEMA"            att))
    ) ; end setq
    (if (assoc 62 ent)
      (setq col (itoa (cdr (assoc 62 ent))))
      (setq col                          "")
    ) ; end if
    (datdsp opt cdg des qdr org crc cmd pot dem fas col)
    (if (zerop (rem idx 20))
      (progn
        (getstring "\n\nTecle [ENTER] para prosseguir...")
        (hdrdsp opt)
      ) ; end progn
    ) ; end if
    (setq cnt (- cnt 1))
  ) ; end while
  (princ)
) ; end defun

;; datcpy: rotina para copiar elementos do desenho modificando os atributos
(defun datcpy(opt / oldech ss ss1 ls cnt enm oldqdr newqdr num neworg oldorg ptb pti)
  (m:savevars)

  (cond
    ((= opt "Copy")   (prompt "\nSelecione os objetos que serao copiados..."))
    ((= opt "Mirror") (prompt "\nSelecione os objetos a serem espelhados..."))
  ) ; end cond
  (if (setq ss (ssget))
    (progn
      (command ".undo" "g")
      ;; duplicacao dos objetos selecionados
      (setq enm1 (entlast))  ;; ename da ultima entidade do desenho
      (prompt "\nDuplicando os objetos selecionados...")
      (command ".copy" ss "" "0,0" "0,0")
      ;; modificacao das identificacoes dos quadros
      (setq ls '())
      (if (setq ss1 (ssfilter "EQUADRO" ss))
        (progn
          (initget "Yes No")
          (if (/= (getkword "\nModificar identificacao dos quadros <Yes>: ") "No")
            (progn
              (setq cnt (- (sslength ss1) 1))
              (while (>= cnt 0)
                (setq enm (ssname ss1 cnt))
                (setq idx 0)
                (while (setq oldqdr (cadr (assoc (strcat "#NOME_QUADRO(" (itoa idx) ")") (attread enm))))
                  (setq newqdr (strcase (getstring (strcat "\nInforme novo nome do quadro <" oldqdr ">: "))))
                  (if (and (/= newqdr "") (/= newqdr oldqdr))
                    (progn
                      (setq ls (append ls (list (list oldqdr newqdr))))
                      (attvalue enm (strcat "#NOME_QUADRO(" (itoa idx) ")") newqdr)
                    ) ; end progn
                    (prompt "*ATENCAO* Apos a copia este quadro estara duplicado no desenho.")
                  ) ; end if
                  (setq idx (1+ idx))
                ) ; end while
                (setq cnt (- cnt 1))
              ) ; end while
              ;; modificacao da origem dos objetos de acordo com o quadro
              (setq num 0)
              (setq cnt (- (sslength ss) 1))
              (while (>= cnt 0)
                (setq enm (ssname ss cnt))
                (setq idx 0)
                (while (setq oldorg (cadr (assoc (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") (attread enm))))
                  (if (setq neworg (cadr (assoc oldorg ls)))
                    (attvalue enm (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") neworg)
                    (setq num (+ num 1))
                  ) ; end if
                  (setq idx (1+ idx))
                ) ; end while
                (setq cnt (- cnt 1))
              ) ; end while
              (prompt (strcat "\nTotal de objetos nao modificados = " (itoa num)))
            ) ; end progn
            (prompt "\n*ATENCAO* Apos a copia existirao quadros duplicados no desenho.")
          ) ; end if
        ) ; end progn
      ) ; end if
      (cond
        ((= opt "Copy")   (progn
                            (initget 1)
                            (setq ptb (getpoint "\nPonto base: "))
                            (initget 1)
                            (setq pti (getpoint ptb "\nPonto de insercao: "))
                            (command ".move" ss "" ptb pti)
        )                 ) ; end progn, case
        ((= opt "Mirror") (progn
                            (initget 1)
                            (setq pt1 (getpoint "\nPrimeiro ponto do espelho: "))
                            (initget 1)
                            (setq pt2 (getpoint pt1 "\nSegundo ponto do espelho: "))
                            (command ".mirror" ss "" pt1 pt2 "Y")
        )                 ) ; end progn, case
      ) ; end cond
      (while (setq enm1 (entnext enm1)) (redraw enm1 1))
      (command ".undo" "e")
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

;; ecopy: rotina para copiar objetos do desenho
(defun c:ecopy() (datcpy "Copy"))

;; emirror: rotina para espelhar objetos do desenho
(defun c:emirror() (datcpy "Mirror"))

;; elist: rotina para apresentar os dados dos elementos na tela
(defun c:elist(/ MAGNIF oldech opt ss idx cnt ent att enm pti cdg des qdr org crc cmd pot dem fas col)
  (m:savevars)

  (setq MAGNIF 5000.0)     ;; fator de ampliacao para a area abrangida
  (graphscr)
  (initget "Quadros CARgas CAMpainhas COmandos")
  (setq opt (getkword "\nListar Quadros, CARgas, CAMpainhas ou COmandos <Quadros>: "))
  (if (null opt) (setq opt "Quadros"))
  (if (setq ss (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))))
    (cond
      ((= opt "Quadros")    (setq ss1 (ssfilter "EQUADRO"    ss)) )
      ((= opt "CARgas")     (setq ss1 (ssfilter "ECARGA"     ss)) )
      ((= opt "CAMpainhas") (setq ss1 (ssfilter "ECAMPAINHA" ss)) )
      ((= opt "COmandos")   (setq ss1 (ssfilter "ECOMANDO"   ss)) )
    ) ; end cond
  ) ; end if
  (if ss1
    (progn
      ;; lista dos objetos inseridos no desenho
      (datlst ss1 opt)
      ;; selecao dos objetos a serem editados
      (while (progn
               (initget 6)
               (setq n (getint "\n\nCodigo do objeto (ou ENTER): "))
             ) ; end progn
        (graphscr)
        (setq cnt (- (sslength ss1) 1))
        (while (and (>= cnt 0) (> n 0))
          (setq enm (ssname ss1 cnt))
          (setq n (- n 1))
          (setq cnt (- cnt 1))
        ) ; end while
        (if (zerop n)
          (progn
            (setq ent (entget enm))
            (setq pti (cdr (assoc 10 ent)))
            (command ".zoom" "c" pti (/ MAGNIF (#UND)))
            (redraw enm 3)
            (if (/= (progn
                      (initget "Yes No")
                      (getkword "\nEditar este objeto <Yes>: ")
                    ) ; end progn
                    "No")
              (cond
                ((= opt "Quadros")  (progn
                                      (if (/= (progn
                                                (initget "Yes No")
                                                (getkword "\nAlterar a cor deste objeto <Yes>: ")
                                              ) ; end progn
                                              "No")
                                        (progn
                                          (setq col (cdr (assoc 62 ent)))
                                          (if col
                                            (progn
                                              (initget 6)
                                              (setq c (getint (strcat "\nCor do quadro <" (itoa col) ">: ")))
                                              (if (null c) (setq c col))
                                              (entmod (subst (cons 62 c) (assoc 62 ent) ent))
                                            ) ; end progn
                                            (progn
                                              (initget 7)
                                              (setq c (getint "\nCor do quadro: "))
                                              (entmod (append ent (list (cons 62 c))))
                                            ) ; end progn
                                          ) ; end if
                                        ) ; end progn
                                      ) ; end if
                                      (command ".ddatte" enm)
                                    ) ; end progn
                ) ; end case
                ((= opt "CARgas")     (command ".ddatte" enm))
                ((= opt "CAMpainhas") (command ".ddatte" enm))
                ((= opt "COmandos")   (command ".ddatte" enm))
              ) ; end cond
            ) ; end if
            (redraw enm 1)
          ) ; end progn
          (prompt "\nERR: Nao existe objeto com este codigo.")
        ) ; end if
      ) ; end while
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

;; esetcol: reajusta as cores dos objetos em funcao do quadro origem
(defun c:esetcol(/ oldech oldhigh ss ss1 ss2 ss3 ls cnt enm ent att qdr org col newcol oldcol)
  (m:savevars)

  (prompt "\nSelecione os objetos ou ENTER para todos...")
  (if (setq ss (ssget))
    (progn
      ;; filtra a selecao obtendo apenas os blocos de eletrica
      (setq oldhigh (getvar "highlight"))
      (setvar "highlight" 0)
      (setq ss1 (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))))
      (command ".select" ss "r" ss1 "")
      (setq ss2 (ssget "p"))
      (command ".select" ss "r" ss2 "")
      (setq ss (ssget "p"))
      (setvar "highlight" oldhigh)
    ) ; end progn
    (setq ss (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))))
  ) ; end if
  (if ss
    (progn
      ;; monta uma lista de quadros e respectivas cores
      (setq ss3 (ssfilter "EQUADRO" ss))
      (setq ls '())
      (setq cnt (- (sslength ss3) 1))
      (while (>= cnt 0)
        (setq enm (ssname ss3 cnt))
        (if (equadro enm)
          (progn
            (setq
              ent (entget enm)
              att (attread enm)
            ) ; end setq
            (setq qdr (cadr (assoc "#NOME_QUADRO" att)))
            (if (setq col (cdr (assoc 62 ent)))
              (setq ls (append ls (list (list qdr col))))
            ) ; end if
          ) ; end progn
        ) ; end if
        (setq cnt (- cnt 1))
      ) ; end while
      ;; ajusta os atributos dos objetos selecionados
      (setq cnt (- (sslength ss) 1))
      (while (>= cnt 0)
        (setq enm (ssname ss cnt))
        (if (/= (etipo enm) "EQUADRO")
          (progn
            (setq
              ent (entget enm)
              att (attread enm)
            ) ; end setq
            (setq org (cadr (assoc "#QUADRO_ORIGEM" att)))
            (if (setq newcol (cadr (assoc org ls)))
              (if (setq oldcol (cdr (assoc 62 ent)))
                (entmod (subst (cons 62 newcol) (assoc 62 ent) ent))
                (entmod (append ent (list (cons 62 newcol))))
              ) ; end if
            ) ; end if
          ) ; end progn
        ) ; end if
        (attreset enm)
        (setq cnt (- cnt 1))
      ) ; end while
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

;; esetorg: reajusta o quadro origem em funcao das cores
(defun c:esetorg(/ oldech oldhigh ss ss1 ss2 ss3 ls cnt enm ent att qdr org col oldcol)
  (m:savevars)

  (prompt "\nSelecione os objetos ou ENTER para todos...")
  (if (setq ss (ssget))
    (progn
      ;; filtra a selecao obtendo apenas os blocos de eletrica
      (setq oldhigh (getvar "highlight"))
      (setvar "highlight" 0)
      (setq ss1 (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))))
      (command ".select" ss "r" ss1 "")
      (setq ss2 (ssget "p"))
      (command ".select" ss "r" ss2 "")
      (setq ss (ssget "p"))
      (setvar "highlight" oldhigh)
    ) ; end progn
    (setq ss (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))))
  ) ; end if
  (if ss
    (progn
      ;; monta uma lista de quadros e respectivas cores
      (setq ss3 (ssfilter "EQUADRO" ss))
      (setq ls '())
      (setq cnt (- (sslength ss3) 1))
      (while (>= cnt 0)
        (setq enm (ssname ss3 cnt))
        (if (equadro enm)
          (progn
            (setq
              ent (entget enm)
              att (attread enm)
            ) ; end setq
            (setq qdr (cadr (assoc "#NOME_QUADRO" att)))
            (if (setq col (cdr (assoc 62 ent)))
              (setq ls (append ls (list (list col qdr))))
            ) ; end if
          ) ; end progn
        ) ; end if
        (setq cnt (- cnt 1))
      ) ; end while
      ;; ajusta os atributos dos objetos selecionados
      (setq cnt (- (sslength ss) 1))
      (while (>= cnt 0)
        (setq enm (ssname ss cnt))
        (if (/= (etipo enm) "EQUADRO")
          (progn
            (setq ent (entget enm))
            (if (setq oldcol (cdr (assoc 62 ent)))
              (if (setq org (cadr (assoc oldcol ls)))
                (attvalue enm "#QUADRO_ORIGEM" org)
              ) ; end if
            ) ; end if
          ) ; end progn
        ) ; end if
        (attreset enm)
        (setq cnt (- cnt 1))
      ) ; end while
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

;; eerase: rotina para eliminar objetos do desenho
(defun c:eerase(/ ss ss1 oldech oldhigh)
  (m:savevars)

  (prompt "\nSelecione os objetos ou ENTER para todos...")
  (if (setq ss (ssget))
    (progn
      (if (setq ss1 (ssget "x" '((8 . "EL-CIRCUITOS"))))
        (progn
          (setq oldhigh (acadvar "highlight" 0))
          (command ".select" ss "r" ss1 "")
          (setvar "highlight" oldhigh)
          (command ".erase" ss "r" "p" "")
        ) ; end progn
        (prompt "\nERR: Nenhum circuito foi encontrado.")
      ) ; end if
    ) ; end progn
    (progn
      (prompt "\nEliminando todos os circuitos...")
      (if (setq ss (ssget "x" '((8 . "EL-CIRCUITOS"))))
        (command ".erase" ss "")
        (prompt "\nERR: Nenhum circuito foi encontrado.")
      ) ; end if
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

;; eattmov: movimenta um atributo selecionado pelo usuario
(defun c:eattmov(/ ss oldech)
  (m:savevars)

  (if (setq ss (nentsel "\nSelecione o atributo: "))
    (progn
      (prompt "\nNova posicao para o atributo: ")
      (command ".attedit" "y" "*" "*" "*" ss "p" pause "")
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

(princ)
