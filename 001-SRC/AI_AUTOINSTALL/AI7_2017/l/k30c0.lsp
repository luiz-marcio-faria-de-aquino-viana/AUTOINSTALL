
;;
;; K30C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 5/14/96
;;

;; funcoes de interface com o usuario

;; declaracao das variaveis globais
;; #UORIG - valor default para nome do quadro origem
;; #UPOT  - valor default para a potencia
;; #UFAS  - valor default para sistema de fase
;; #UAPAR - lista de valores default da potencia, fase e
;;        lista da sequencia de entrada de cada economia

;; udef: preenche os atributos potencia e fase do bloco com valores default
(defun udef(enm def / pot1 pot2 fs1 fs2)
  (setq pot1 (car  (caddr def)) )
  (if (and (/= pot1 "-") (/= pot1 "?")) (attvalue enm "#POTENCIA" pot1) )
  (setq fs1 (car  (cadddr def)) )
  (if (and (/= fs1 "-") (/= fs1 "?")) (attvalue enm "#SISTEMA" fs1) )
) ; end defun

;; ublk: retorna o nome do bloco
(defun ublk(/ blk)
  (if (null #BLCK)
    (while (= (setq blk (getstring "Nome do bloco: ")) "")
      (prompt "\nERR: Resposta nula nao e valida.") )
    (setq blk (getstring (strcat "Nome do bloco <" #BLCK ">: ")))
  ) ; end if
  (if (/= blk "") (setq #BLCK (strcase blk)) )
  #BLCK
) ; end defun

;; upti: retorna o ponto de insercao
(defun upti(typ / pta ptb)
  (if typ
    (progn
      (initget 1)
      (getpoint "\nPonto de insercao: ")
    ) ; end progn
    (progn
      (initget 1)
      (setq pta (getpoint "\nPrimeiro ponto/Ponto de insercao: "))
      (setq ptb (getpoint pta "\nSegundo ponto (ou ENTER): "))
      (if ptb
        (mapcar '/ (mapcar '+ pta ptb) '(2.0 2.0))
        pta
      ) ; end if
    ) ; end progn
  ) ; end if
) ; end defun

;; urot: retorna a rotacao
(defun urot(pt / rot)
  (setq rot (getangle pt "\nRotacao <0>: "))
  (if rot (* (/ rot 3.141592) 180.0) 0)
) ; end defun

;; uquadro: retorna o nome do quadro
(defun uquadro(/ s)
  (while (= (setq s (getstring "\nNome do quadro: ")) "")
    (prompt "\nERR: Resposta nula nao e valida.") )
  (strcase s)
) ; end defun

;; uorigem: retorna o quadro de origem
(defun uorigem(/ s)
  (if (null #UORIG)
    (while (= (setq s (getstring "\nQuadro de origem: ")) "")
      (prompt "\nERR: Resposta nula nao e valida.") )
    (setq s (getstring (strcat "\nQuadro de origem <" #UORIG ">: ")) )
  ) ; end if
  (if (/= s "") (setq #UORIG (strcase s)) )
  #UORIG
) ; end defun

;; udesvio: retorna o identificador do desvio
(defun udesvio(/ s)
  (while (= (setq s (getstring "Identificacao do desvio: ")) "")
    (prompt "\nERR: Resposta nula nao e valida.") )
  (strcase s)
) ; end defun

;; upot: retorna a potencia da economia
(defun upot(def / pot1 pot2 pot)
  (if def
    (progn
      ;; se existir parametro default para o objeto
      (setq
        pot1 (car  (caddr def))
        pot2 (cadr (caddr def))
      ) ; end setq
      (cond
        ((= pot1 "-") (progn
                        (initget 7)
                        (setq pot (getint "\nPotencia (VA): "))
        )             ) ; end progn, case
        ((= pot1 "?") (progn
                        (if pot2 (progn
                                   (initget 6)
                                   (setq pot (getint (strcat "\nPotencia (VA) <" pot2 ">: ")))
                                   (if (null pot) (setq pot (atoi pot2)))
                                 ) ; end progn
                                 (progn
                                   (initget 7)
                                   (setq pot (getint "\nPotencia (VA): "))
                        )        ) ; end progn, if
                        (setq #UAPAR (subst (list (car def) (cadr def) (list pot1 (itoa pot)) (cadddr def)) def #UAPAR))
        )             ) ; end progn, case
        (t (progn
             (initget 6)
             (setq pot (getint (strcat "\nPotencia (VA) <" pot1 ">: ")))
             (if (null pot)
               (setq pot (atoi pot1))
               (setq #UAPAR (subst (list (car def) (cadr def) (list (itoa pot)) (cadddr def)) def #UAPAR))
             ) ; end if
        )  ) ; end progn, cond
      ) ; end cond
      (itoa pot)
    ) ; end progn
    (progn
      ;; se nao existir parametro default para o objeto
      (if #UPOT
        (progn
          (initget 6)
          (setq pot (getint (strcat "\nPotencia (VA) <" (itoa #UPOT) ">: ")))
        ) ; end progn
        (progn
          (initget 7)
          (setq pot (getint "\nPotencia (VA): "))
        ) ; end progn
      ) ; end if
      (if pot (setq #UPOT pot))
      (itoa #UPOT)
    ) ; end progn
  ) ; end if
) ; end defun

;; ufase: retorna o sistema de fase da economia
(defun ufase (def / oldmnu fs1 fs2 fs)
  (if def
    (progn
      ;; se existir parametro default para o objeto
      (setq
        fs1 (car  (cadddr def))
        fs2 (cadr (cadddr def))
      ) ; end setq
      (cond
        ((= fs1 "-") (progn
                       (initget 1 "F+N 2F 2F+N 3F 3F+N F+N+T 2F+T 2F+N+T 3F+T 3F+N+T")
                       (setq fs (getkword "\nSistema (F+N, 2F, 2F+N, ... 3F+N+T): "))
        )            ) ; end progn, case
        ((= fs1 "?") (progn
                       (if fs2 (progn
                                 (initget "F+N 2F 2F+N 3F 3F+N F+N+T 2F+T 2F+N+T 3F+T 3F+N+T")
                                 (setq fs (getkword (strcat "\nSistema (F+N, 2F, 2F+N, ... 3F+N+T) <" fs2 ">: ")))
                                 (if (null fs) (setq fs fs2))
                               ) ; end progn
                               (progn
                                 (initget 1 "F+N 2F 2F+N 3F 3F+N F+N+T 2F+T 2F+N+T 3F+T 3F+N+T")
                                 (setq fs (getkword "\nSistema (F+N, 2F, 2F+N, ... 3F+N+T): "))
                       )       ) ; end progn, if
                       (setq #UAPAR (subst (list (car def) (cadr def) (caddr def) (list fs1 fs)) def #UAPAR))
        )            ) ; end progn, case
        (t (progn
             (initget "F+N 2F 2F+N 3F 3F+N F+N+T 2F+T 2F+N+T 3F+T 3F+N+T")
             (setq fs (getkword (strcat "\nSistema (F+N, 2F, 2F+N, ... 3F+N+T) <" fs1 ">: ")))
             (if (null fs)
               (setq fs fs1)
               (setq #UAPAR (subst (list (car def) (cadr def) (caddr def) (list fs)) def #UAPAR))
             ) ; end if
        )  ) ; end progn, cond
      ) ; end cond
      fs
    ) ; end progn
    (progn
      ;; se existir parametro default para o objeto
      (if #UFAS
        (progn
          (initget "F+N 2F 2F+N 3F 3F+N F+N+T 2F+T 2F+N+T 3F+T 3F+N+T")
          (setq fs (getkword (strcat "\nSistema (F+N, 2F, 2F+N, ... 3F+N+T) <" #UFAS ">: ")))
        ) ; end progn
        (progn
          (initget 1 "F+N 2F 2F+N 3F 3F+N F+N+T 2F+T 2F+N+T 3F+T 3F+N+T")
          (setq fs (getkword "\nSistema (F+N, 2F, 2F+N, ... 3F+N+T): "))
        ) ; end progn
      ) ; end if
      (if fs (setq #UFAS fs))
      #UFAS
    ) ; end progn
  ) ; end if
) ; end defun

;; ucopy: rotina que copia os valores dos atributos de um indice a outro
;;  enm  - ename do bloco que tera os tributos copiados
;;  idx1 - indice para os atributos fonte
;;  idx2 - indice para os atributos destinos
(defun ucopy(enm idx1 idx2 / att qdr org pot fas)
  (setq att (attread enm))
  (setq
    qdr (cadr (assoc (strcat "#NOME_QUADRO("   (itoa idx1) ")") att))
    org (cadr (assoc (strcat "#QUADRO_ORIGEM(" (itoa idx1) ")") att))
    pot (cadr (assoc (strcat "#POTENCIA("      (itoa idx1) ")") att))
    fas (cadr (assoc (strcat "#SISTEMA("       (itoa idx1) ")") att))
  ) ; end setq
  (if qdr (attvalue enm (strcat "#NOME_QUADRO("   (itoa idx2) ")") qdr) )
  (if org (attvalue enm (strcat "#QUADRO_ORIGEM(" (itoa idx2) ")") org) )
  (if pot (attvalue enm (strcat "#POTENCIA("      (itoa idx2) ")") pot) )
  (if fas (attvalue enm (strcat "#SISTEMA("       (itoa idx2) ")") fas) )
) ; end defun

;; uinsert: rotina para insercao dos aparelhos no desenho
(defun c:uinsert()
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (setq blk (ublk))                         ;; pede o nome do bloco
  (setq def '())
  (if (setq def (assoc blk #UAPAR))         ;; existe definicao do bloco na lista?
    (progn
      ;; se existe definicao do bloco na lista
      (setq
        defc (cadr   def)
        defp (caddr  def)
        deff (cadddr def)
      ) ; end setq
    ) ; end progn
    (progn
      ;; se nao existe definicao do bloco na lista
      (if (setq reg (readdef blk))          ;; existe registro na tabela de definicoes?
        (progn
          ;; se existe registro na tabela de definicoes
          (setq
            defc (list (cadr   reg))
            defp (list (caddr  reg))
            deff (list (cadddr reg))
          ) ; end setq
          (setq def (list blk defc defp deff))
          (setq #UAPAR (append #UAPAR (list def)) )
        ) ; end progn
        (prompt (strcat "\nERR: Registro " blk " nao encontrado na tabela."))
      ) ; end if
    ) ; end progn
  ) ; end if
  (if def
    (progn
      (setq
        cmdln (car defc)
        cnt            0
      ) ; end setq
      (setq
        pti nil                       ;; flags que avaliam os comandos
        rot nil
        flg nil
        err nil
      ) ; end setq
      (setq idx 0)                    ;; ponteiro indice do atributo corrente
      (while (and (not err) (< cnt (strlen cmdln)) )
        (setq cnt (1+ cnt))
        (setq cmd (substr cmdln cnt 1))
        (cond
          ((= cmd "1") (progn
                         ;; insercao por 1p
                         (setq pti (upti t))
          )            ) ; end progn, case
          ((= cmd "2") (progn
                         ;; insercao por 2p
                         (setq pti (upti nil))
          )            ) ; end progn, case
          ((= cmd "R") (progn
                         ;; rotacao
                         (if pti
                           (setq rot (urot pti))
                           (setq err t)
                         ) ; end if
          )            ) ; end progn, case
          ((= cmd "0") (progn
                         ;; rotacao = 0
                         (setq rot 0.0)
          )            ) ; end progn, case
          ((= cmd "N") (progn
                         ;; nome do quadro
                         (if flg
                           (attvalue (entlast) (strcat "#NOME_QUADRO(" (itoa idx) ")") (uquadro))
                           (setq err t)
                         ) ; end if
          )            ) ; end progn, case
          ((= cmd "Q") (progn
                         ;; quadro origem
                         (if flg
                           (attvalue (entlast) (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") (uorigem))
                           (setq err t)
                         ) ; end if
          )            ) ; end progn, case
          ((= cmd "D") (progn
                         ;; desvio
                         (if flg
                           (attvalue (entlast) (strcat "#DESVIO(" (itoa idx) ")") (udesvio))
                           (setq err t)
                         ) ; end if
          )            ) ; end progn, case
          ((= cmd "P") (progn
                         ;; potencia
                         (if flg
                           (attvalue (entlast) (strcat "#POTENCIA(" (itoa idx) ")") (upot def))
                           (setq err t)
                         ) ; end if
          )            ) ; end progn, case
          ((= cmd "F") (progn
                         ;; fase
                         (if flg
                           (progn
                             ;;(setq oldmnu (ai_svar "promptmenu" 1))
                             (attvalue (entlast) (strcat "#SISTEMA(" (itoa idx) ")") (ufase def))
                             ;;(setvar "promptmenu" oldmnu)
                           ) ; end progn
                           (setq err t)
                         ) ; end if
          )            ) ; end progn, case
          ((= cmd "I") (progn
                         ;; insere bloco
                         (if (and pti rot)
                           (progn
                             (if (tblsearch "block" (getfilename blk))
                               (command ".insert" (getfilename blk) pti (/ 1.0 (#UND)) "" rot)
                               (command ".insert" (V:AID blk) pti (/ 1.0 (#UND)) "" rot)
                             ) ; end if
                             (attreset (entlast))
                             (udef (entlast) def)
                             (setq flg t)
                           ) ; end progn
                          (setq err t)
                         ) ; end if
          )            ) ; end progn, case
          ((= cmd "C") (progn
                         ;; copia os atributos entre indices
                         (setq cnt (1+ cnt))
                         (setq cmd (substr cmdln cnt 1))
                         (if (and (>= cmd "0") (<= cmd "9"))
                           (ucopy (entlast) idx (atoi cmd))
                           (setq err t)
                         ) ; end if
          )            ) ; end progn, case
          ((= cmd "S") (progn
                         ;; torna um novo indice ativo
                         (setq cnt (1+ cnt))
                         (setq cmd (substr cmdln cnt 1))
                         (if (and (>= cmd "0") (<= cmd "9"))
                           (setq idx (atoi cmd))
                           (setq err t)
                         ) ; end if
          )            ) ; end progn, case
        ) ; end cond
      ) ; end while
      (if err (prompt (strcat "\nERR: Sequencia de comandos invalida para inserir " blk ".")) )
    ) ; end progn
  ) ; end if
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
