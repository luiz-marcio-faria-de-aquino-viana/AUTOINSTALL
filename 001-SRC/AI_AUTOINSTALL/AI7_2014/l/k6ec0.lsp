
;;
;; K6EC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 8/14/97
;;

;; carrega funcoes externas necessarias a rotina
(loadf "k30c0")

;; EMkObj_AttAlign(): funcao que troca o alinhamento do atributo
;;  enm - ename do atributo que sera modificado
;;  mod - modo de alinhamento desejado (0=Esquerda, 1=Centro, 2=Direita, 4=Meio)
(defun EMkObj_AttAlign(enm mod / ent pti)
  (setq ent (entget enm))
  (setq pti (cdr (assoc 10 ent)))
  (entmod
    (subst (cons 11 pti) (assoc 11 ent)
      (subst (cons 72 mod) (assoc 72 ent) ent) )
  ) ; end entmod
) ; end defun

;; EMkObj_AttMake(): funcao que cria os atributos para um objeto eletrico determinado
;;  pti - ponto de insercao dos atributos
;;  idx - indice para os atributos do objeto
;;  tip - tipo do objeto eletrico desejado
;;   (ex: ECARGA, ECOMANDO, EQUADRO, ECAMPAINHA,
;;        EILUMINACAO, ECAIXA, EDESVIO ou ECALHA)
(defun EMkObj_AttMake(pti idx tip / xi yi h d)

  (setq
    xi (car  pti)
    yi (cadr pti)
    h  (* 1.5 (#SCL))
    d  (* 3.0 (#SCL))
  ) ; end setq

  (acadvar "aflags" 0)
  (cond
    ( (= tip "ECARGA")		;; atributos para os objetos do tipo carga
      (progn
        (command
          ".attdef" "p" "i" ""
            (strcat "#TIPO(" (itoa idx) ")")
            (strcat "Tipo de aparelho(" (itoa idx) ")")
            "ECARGA"
            (list xi (+ yi (* 7 d)) )
            h
            "0"
          ".select" "l" ""
          ".attdef" ""
            (strcat "#QUADRO_ORIGEM(" (itoa idx) ")")
            (strcat "Quadro de origem(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 6 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#CIRCUITO(" (itoa idx) ")")
            (strcat "Identificacao do circuito(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 5 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#COMANDO(" (itoa idx) ")")
            (strcat "Identificacao do comando(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 4 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#POTENCIA(" (itoa idx) ")")
            (strcat "Potencia(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 3 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#SISTEMA(" (itoa idx) ")")
            (strcat "Sistema de fases(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 2 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#FREE1(" (itoa idx) ")")
            (strcat "Free1(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 1 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#FREE2(" (itoa idx) ")")
            (strcat "Free2(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 0 d)) )
            h
            "0"
          ".select" "p" "l" ""
        ) ; end command
        (ssget "p")
    ) ) ; end progn, case
    ( (= tip "ECOMANDO")	;; atributos para os objetos do tipo comando
      (progn
        (command
          ".attdef" "p" "i" ""
            (strcat "#TIPO(" (itoa idx) ")")
            (strcat "Tipo de aparelho(" (itoa idx) ")")
            "ECOMANDO"
            (list xi (+ yi (* 4 d)) )
            h
            "0"
          ".select" "l" ""
          ".attdef" ""
            (strcat "#QUADRO_ORIGEM(" (itoa idx) ")")
            (strcat "Quadro de origem(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 3 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#COMANDO(" (itoa idx) ")")
            (strcat "Identificacao do comando(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 2 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#FREE1(" (itoa idx) ")")
            (strcat "Free1(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 1 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#FREE2(" (itoa idx) ")")
            (strcat "Free2(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 0 d)) )
            h
            "0"
          ".select" "p" "l" ""
        ) ; end command
        (ssget "p")
    ) ) ; end progn, case
    ( (= tip "EQUADRO")		;; atributos para os objetos do tipo quadro
      (progn
        (command
          ".attdef" "p" "i" ""
            (strcat "#TIPO(" (itoa idx) ")")
            (strcat "Tipo de aparelho(" (itoa idx) ")")
            "EQUADRO"
            (list xi (+ yi (* 9 d)) )
            h
            "0"
          ".select" "l" ""
          ".attdef" ""
            (strcat "#NOME_QUADRO(" (itoa idx) ")")
            (strcat "Nome do quadro(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 8 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#QUADRO_ORIGEM(" (itoa idx) ")")
            (strcat "Quadro de origem(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 7 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#CIRCUITO(" (itoa idx) ")")
            (strcat "Identificacao do circuito(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 6 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#COMANDO(" (itoa idx) ")")
            (strcat "Identificacao do comando(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 5 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#POTENCIA(" (itoa idx) ")")
            (strcat "Potencia(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 4 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#POTENCIA_DEMANDADA(" (itoa idx) ")")
            (strcat "Potencia demandada(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 3 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#SISTEMA(" (itoa idx) ")")
            (strcat "Sistema de fases(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 2 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#FREE1(" (itoa idx) ")")
            (strcat "Free1(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 1 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#FREE2(" (itoa idx) ")")
            (strcat "Free2(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 0 d)) )
            h
            "0"
          ".select" "p" "l" ""
        ) ; end command
        (ssget "p")
    ) ) ; end progn, case
    ( (= tip "ECAMPAINHA")	;; atributos para os objetos do tipo campainha
      (progn
        (command
          ".attdef" "p" "i" ""
            (strcat "#TIPO(" (itoa idx) ")")
            (strcat "Tipo de aparelho(" (itoa idx) ")")
            "ECAMPAINHA"
            (list xi (+ yi (* 4 d)) )
            h
            "0"
          ".select" "l" ""
          ".attdef" ""
            (strcat "#QUADRO_ORIGEM(" (itoa idx) ")")
            (strcat "Quadro de origem(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 3 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#COMANDO(" (itoa idx) ")")
            (strcat "Identificacao do comando(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 2 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#FREE1(" (itoa idx) ")")
            (strcat "Free1(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 1 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#FREE2(" (itoa idx) ")")
            (strcat "Free2(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 0 d)) )
            h
            "0"
          ".select" "p" "l" ""
        ) ; end command
        (ssget "p")
    ) ) ; end progn, case
    ( (= tip "EILUMINACAO")	;; atributos para os objetos do tipo iluminacao
      (progn
        (command
          ".attdef" "p" "i" ""
            (strcat "#TIPO(" (itoa idx) ")")
            (strcat "Tipo de aparelho(" (itoa idx) ")")
            "EILUMINACAO"
            (list xi (+ yi (* 7 d)) )
            h
            "0"
          ".select" "l" ""
          ".attdef" ""
            (strcat "#QUADRO_ORIGEM(" (itoa idx) ")")
            (strcat "Quadro de origem(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 6 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#CIRCUITO(" (itoa idx) ")")
            (strcat "Identificacao do circuito(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 5 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#COMANDO(" (itoa idx) ")")
            (strcat "Identificacao do comando(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 4 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#POTENCIA(" (itoa idx) ")")
            (strcat "Potencia(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 3 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#SISTEMA(" (itoa idx) ")")
            (strcat "Sistema de fases(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 2 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#FREE1(" (itoa idx) ")")
            (strcat "Free1(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 1 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#FREE2(" (itoa idx) ")")
            (strcat "Free2(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 0 d)) )
            h
            "0"
          ".select" "p" "l" ""
        ) ; end command
        (ssget "p")
    ) ) ; end progn, case
    ( (= tip "ECAIXA")		;; atributos para os objetos do tipo caixa
      (progn
        (command
          ".attdef" "p" "i" ""
            (strcat "#TIPO(" (itoa idx) ")")
            (strcat "Tipo de aparelho(" (itoa idx) ")")
            "ECAIXA"
            (list xi (+ yi (* 3 d)) )
            h
            "0"
          ".select" "l" ""
          ".attdef" ""
            (strcat "#QUADRO_ORIGEM(" (itoa idx) ")")
            (strcat "Quadro de origem(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 2 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#FREE1(" (itoa idx) ")")
            (strcat "Free1(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 1 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#FREE2(" (itoa idx) ")")
            (strcat "Free2(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 0 d)) )
            h
            "0"
          ".select" "p" "l" ""
        ) ; end command
        (ssget "p")
    ) ) ; end progn, case
    ( (= tip "EDESVIO")		;; atributos para os objetos do tipo desvio
      (progn
        (command
          ".attdef" "p" "i" ""
            (strcat "#TIPO(" (itoa idx) ")")
            (strcat "Tipo de aparelho(" (itoa idx) ")")
            "EDESVIO"
            (list xi (+ yi (* 4 d)) )
            h
            "0"
          ".select" "l" ""
          ".attdef" ""
            (strcat "#QUADRO_ORIGEM(" (itoa idx) ")")
            (strcat "Quadro de origem(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 3 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#DESVIO(" (itoa idx) ")")
            (strcat "Identificacao do desvio(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 2 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#FREE1(" (itoa idx) ")")
            (strcat "Free1(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 1 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#FREE2(" (itoa idx) ")")
            (strcat "Free2(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 0 d)) )
            h
            "0"
          ".select" "p" "l" ""
        ) ; end command
        (ssget "p")
    ) ) ; end progn, case
    ( (= tip "ECALHA")		;; atributos para os objetos do tipo calha
      (progn
        (command
          ".attdef" "p" "i" ""
            (strcat "#TIPO(" (itoa idx) ")")
            (strcat "Tipo de aparelho(" (itoa idx) ")")
            "ECALHA"
            (list xi (+ yi (* 3 d)) )
            h
            "0"
          ".select" "l" ""
          ".attdef" ""
            (strcat "#QUADRO_ORIGEM(" (itoa idx) ")")
            (strcat "Quadro de origem(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 2 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" "i" ""
            (strcat "#FREE1(" (itoa idx) ")")
            (strcat "Free1(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 1 d)) )
            h
            "0"
          ".select" "p" "l" ""
          ".attdef" ""
            (strcat "#FREE2(" (itoa idx) ")")
            (strcat "Free2(" (itoa idx) ")")
            ""
            (list xi (+ yi (* 0 d)) )
            h
            "0"
          ".select" "p" "l" ""
        ) ; end command
        (ssget "p")
    ) ) ; end progn, case
  ) ; end cond
) ; end defun

;; C:EMkObj(): rotina que transforma um conjunto de elementos em um objeto eletrico
(defun C:EMkObj(/ oldmnu oldech oldblip ALIGNMODE BIT_N BIT_Q BIT_D BIT_P BIT_F flg blk
  tbl idx tip bit pti ls enm ent ptf opt ss itm pt1 qdr org dsv pot fas cnt)

  (setq ALIGNMODE '(("Esquerda" 0) ("Centro" 1) ("Direita" 2) ("Meio" 3)) )

  (setq
    BIT_N 16
    BIT_Q  8
    BIT_D  4
    BIT_P  2
    BIT_F  1
  ) ; end setq

  (setq flg 't)
  (while flg
    (while (= (setq blk (getstring "\nNome do bloco (ou ?): ")) "")
      (prompt "\nERR: Resposta nula nao e valida.") )
    (if (= blk "?")
      (command ".block" "?" "")
      (if (setq tbl (tblsearch "block" blk))
        (progn
          (prompt "\n*ATENCAO* Existe no desenho um bloco com este nome e")
          (prompt "\na criacao deste objeto modificara o bloco existente.")
          (initget "Yes No")
          (setq flg (not (= (getkword "\nVoce tem certeza de que deseja continuar <No>? ") "Yes")) )
        ) ; end progn
        (setq flg nil)
      ) ; end if
    ) ; end if
  ) ; end while

  (setq idx 0)
  (setq bit 0)
  (setq ls '())

  (setq flg 't)
  (while flg
    (prompt (strcat "\nPara o objeto de indice [ " (itoa idx) " ] informe: "))
    (initget "CARga COmando Quadro CAMpainha Iluminacao CAIxa Desvio CALha")
    (setq tip (getkword (strcat "\n - Tipo do objeto (CARga/COmando/Quadro/CAMpainha/Iluminacao/CAIxa/Desvio/CALha): ")) )
    (if tip
      (progn
        (cond
          ( (or (= tip "CARga") (= tip "Iluminacao"))
            (setq bit  (logior bit BIT_Q BIT_P BIT_F))
          ) ; end case
          ( (or (= tip "COmando") (= tip "Campainha")
                (= tip "CAIxa")   (= tip "CALha") )
            (setq bit (logior bit BIT_Q))
          ) ; end case
          ( (= tip "Quadro") (setq bit (logior bit BIT_N BIT_Q BIT_F)))
          ( (= tip "Desvio") (setq bit (logior bit BIT_Q BIT_D)))
        ) ; end cond
        (initget 1)
        (setq pti (getpoint "\n - Ponto de insercao dos atributos: "))
        (setq ls (cons (EMkObj_AttMake pti idx (strcat "E" (strcase tip))) ls))
        (prompt "\n Posicione os atributos livremente...")
        (while (= (enttype (setq enm (car (entsel "\n Selecione um atributo: ")))) "ATTDEF")
          (setq ent (entget enm))
          (if (= (cdr (assoc 72 ent)) 0)
            (setq pti (cdr (assoc 10 (entget enm))) )
            (setq pti (cdr (assoc 11 (entget enm))) )
          ) ; end if
          (initget "Alinhamento")
          (setq ptf (getpoint pti "\n Alinhamento/<Ponto de insercao>: "))
          (if (= ptf "Alinhamento")
            (progn
              (initget "Direita Esquerda Centro Meio")
              (setq opt (getkword "\n Alinhamento (Direita/<Esquerda>/Centro): "))
              (if (null opt) (setq opt "Esquerda"))
              (EMkObj_AttAlign enm (cadr (assoc opt ALIGNMODE)) )
            ) ; end progn
            (command ".move" enm "" pti ptf)
          ) ; end if
        ) ; end while
        (setq idx (1+ idx))
      ) ; end progn
      (setq flg nil)
    ) ; end if
  ) ; end flg
  (if ls
    (progn
      (initget 1)
      (setq pt1 (getpoint "\nPonto de insercao do bloco: "))
      (prompt "\nSelecione os elementos que formarao o bloco...")
      (while (null (setq ss (ssget)))
        (prompt "\nERR: Resposta nula nao e valida.") )
      (command ".change")
      (foreach itm (reverse ls) (command itm))
      (command ss "" "p" "la" "0" "c" "byblock" "lt" "byblock" "")
      (if tbl
        (command ".block" blk "y" pt1 "p" "")
        (command ".block" blk     pt1 "p" "")
      ) ; end if
      (command ".insert" blk pt1 "1" "" "0")
      (if (> (logand bit BIT_N) 0) (setq qdr (uquadro)) )
      (if (> (logand bit BIT_Q) 0) (setq org (uorigem)) )
      (if (> (logand bit BIT_D) 0) (setq dsv (udesvio)) )
      (if (> (logand bit BIT_P) 0) (setq pot (upot  nil)) )
      (if (> (logand bit BIT_F) 0)
        (progn
          (setq oldmnu (ai_svar "promptmenu" 1))
          (setq fas (ufase nil))
          (setvar "promptmenu" oldmnu)
        ) ; end progn
      ) ; end if
      (setq cnt 0)
      (while (< cnt idx)
        (if (> (logand bit BIT_N) 0) (attvalue (entlast) (strcat "#NOME_QUADRO(" (itoa cnt) ")") qdr))
        (if (> (logand bit BIT_Q) 0) (attvalue (entlast) (strcat "#QUADRO_ORIGEM(" (itoa cnt) ")") org))
        (if (> (logand bit BIT_D) 0) (attvalue (entlast) (strcat "#DESVIO(" (itoa cnt) ")") dsv))
        (if (> (logand bit BIT_P) 0) (attvalue (entlast) (strcat "#POTENCIA(" (itoa cnt) ")") pot))
        (if (> (logand bit BIT_F) 0) (attvalue (entlast) (strcat "#SISTEMA(" (itoa cnt) ")") fas))
        (setq cnt (1+ cnt))
      ) ; end while
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

(princ)
