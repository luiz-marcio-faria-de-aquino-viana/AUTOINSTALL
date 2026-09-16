
;;
;; K33C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 6/12/96
;;

;; eobj: funcao que retorna o ename do bloco de tipo quadro, carga
;;        ou comando existente na vizinhanca do ponto especificado
;;  pt - ponto especificado (onde sera feita a pesquiza)
(defun eobj(pt / oldhigh pt1 pt2 ss cnt enm dst enm1 dst1)
  (setq d (* 1.0 (#SCL)))
  (setq
    pt1 (list (- (car pt) d) (- (cadr pt) d))
    pt2 (list (+ (car pt) d) (+ (cadr pt) d))
  ) ; end setq
  (setq
    enm nil
    dst (* 10.0 d)
  ) ; end setq
  (setq oldhigh (acadvar "highlight" 0))
  (if (setq ss (ssget "c" pt1 pt2))
    (progn
      (setq cnt (- (sslength ss) 1))
      (while (>= cnt 0)
        (setq enm1 (ssname ss cnt))
        (if (etipo enm1 0)
          (progn
            (setq dst1 (distance pt (cdr (assoc 10 (entget enm1)))))
            (if (or (null enm) (< dst1 dst))
              (setq
                enm enm1
                dst dst1
              ) ; end setq
            ) ; end if
          ) ; end progn
        ) ; end if
        (setq cnt (- cnt 1))
      ) ; end while
    ) ; end progn
    (setq enm nil)
  ) ; end if
  (setvar "highlight" oldhigh)
  enm
) ; end defun

;; edtdata: funcao que retorna o dado de objeto associado ao eletroduto
;;  tag - identificador do campo
;;  enm - ename da entidade analisada
(defun edtdata(tag enm / eed edt)
  (if (setq eed (eedget enm "AI230EL"))
    (if (setq edt (eedcar (eedassoc '(1000 . "#ELETRODUTO") eed)) )
      (eedassoc (cons 1000 tag) (eedcdr edt))
      nil
    ) ; end if
    nil
  ) ; end if
) ; end defun

;; efiacao: rotina para extrair informacoes para programa de fiacao
;;  ff - nome do arquivo de extracao
(defun efiacao(ff / ss1 ss2 ss3 cnt enm lay vti vtf enm1 enm2 ent hnd ent1
  att1 hnd1 tip1 qdr1 org1 cir1 cmd1 fas1 ent2 att2 hnd2 tip2 qdr2 org2
  cir2 cmd2 fas2 f oldech)

  (setq oldech (acadvar "cmdecho" 0))

  ;; selecao dos eletrodutos inseridos
  (prompt "\nSelecione os eletrodutos ou ENTER para todos...")
  (setq ss (ssget '((0 . "POLYLINE"))) )

  (if (null ss) (setq ss (ssget "x" '((0 . "POLYLINE")))) )

  (initget "Yes No")
  (setq opt (getkword "\nPesquisar pontos nas extremidades dos eletrodutos <No>? "))
  (if (null opt) (setq opt "No"))

  ;; extracao das informacoes do desenho
  (setq cnt (- (sslength ss) 1))

  (setq f (open ff "w"))
  (while (>= cnt 0)
    (setq enm (ssname ss cnt))
    (setq ent (entget enm))

    (setq lay (cdr (assoc 8 ent)))
    (if (or (= lay "EL-DT_PISO") (= lay "EL-DT_TETO") (= lay "EL-DT_APARENTE"))
      (progn
        ;; obtem objeto origem do eletroduto
        (if (setq eed1 (edtdata "#ORIGEM"  enm))
          (setq enm1 (handent (cdr (assoc 1005 eed1))) )
          (if (and (= opt "Yes") (setq vti (efstvt enm)))
            (setq enm1 (eobj (cdr (assoc 10 vti))) )
            (setq enm1 nil)
          ) ; end if
        ) ; end if

        ;; obtem objeto destino do eletroduto
        (if (setq eed2 (edtdata "#DESTINO"  enm))
          (setq enm2 (handent (cdr (assoc 1005 eed2))) )
          (if (and (= opt "Yes") (setq vti (elstvt enm)))
            (setq enm2 (eobj (cdr (assoc 10 vti))) )
            (setq enm2 nil)
          ) ; end if
        ) ; end if

        (if (and enm1 enm2)
          (progn
            ;; obtem informacoes do eletroduto
            (setq hnd (cdr (assoc 5 ent)))

            ;; obtem informacoes do primeiro objeto
            (setq
              ent1 (entget enm1)
              att1 (attread enm1)
            ) ; end setq
            (setq hnd1 (cdr (assoc 5 ent1)))

            ;; obtem informacoes do segundo objeto
            (setq
              ent2 (entget enm2)
              att2 (attread enm2)
            ) ; end setq
            (setq hnd2 (cdr (assoc 5 ent2)))

            ;; obtem informacoes das cargas ligadas ao eletroduto
            (setq idx1 0)
            (while (setq tip1 (cadr (assoc (strcat "#TIPO(" (itoa idx1) ")") att1)) )
              (setq
                qdr1 (cadr (assoc (strcat "#NOME_QUADRO("   (itoa idx1) ")") att1))
                org1 (cadr (assoc (strcat "#QUADRO_ORIGEM(" (itoa idx1) ")") att1))
                des1 (cadr (assoc (strcat "#DESVIO("        (itoa idx1) ")") att1))
                cir1 (cadr (assoc (strcat "#CIRCUITO("      (itoa idx1) ")") att1))
                cmd1 (cadr (assoc (strcat "#COMANDO("       (itoa idx1) ")") att1))
                fas1 (cadr (assoc (strcat "#SISTEMA("       (itoa idx1) ")") att1))
              ) ; end setq
              (if (null qdr1) (setq qdr1 ""))
              (if (null org1) (setq org1 ""))
              (if (null des1) (setq des1 ""))
              (if (null cir1) (setq cir1 ""))
              (if (null cmd1) (setq cmd1 ""))
              (if (null fas1) (setq fas1 ""))
              (setq idx2 0)
              (while (setq tip2 (cadr (assoc (strcat "#TIPO(" (itoa idx2) ")") att2)) )
                (setq
                  qdr2 (cadr (assoc (strcat "#NOME_QUADRO("   (itoa idx2) ")") att2))
                  org2 (cadr (assoc (strcat "#QUADRO_ORIGEM(" (itoa idx2) ")") att2))
                  des2 (cadr (assoc (strcat "#DESVIO("        (itoa idx2) ")") att2))
                  cir2 (cadr (assoc (strcat "#CIRCUITO("      (itoa idx2) ")") att2))
                  cmd2 (cadr (assoc (strcat "#COMANDO("       (itoa idx2) ")") att2))
                  fas2 (cadr (assoc (strcat "#SISTEMA("       (itoa idx2) ")") att2))
                ) ; end setq
                (if (null qdr2) (setq qdr2 ""))
                (if (null org2) (setq org2 ""))
                (if (null des2) (setq des2 ""))
                (if (null cir2) (setq cir2 ""))
                (if (null cmd2) (setq cmd2 ""))
                (if (null fas2) (setq fas2 ""))
                ;; grava as informacoes do eletroduto e das cargas
                (write-line
                  (strcat
                    hnd "@"
                    hnd1 "@" (itoa idx1) "@" tip1 "@" qdr1 "@" org1 "@" des1 "@" cir1 "@" cmd1 "@" fas1 "@"
                    hnd2 "@" (itoa idx2) "@" tip2 "@" qdr2 "@" org2 "@" des2 "@" cir2 "@" cmd2 "@" fas2
                  ) ; end strcat
                  f
                ) ; end write-line
                (setq idx2 (+ idx2 1))
              ) ; end while
              (setq idx1 (+ idx1 1))
            ) ; end while

          ) ; end progn
        ) ; end if

      ) ; end progn
    ) ; end if

    (setq cnt (- cnt 1))
  ) ; end while
  (setq f (close f))

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;; inssize: rotina para determinar o tamanho do bloco de fios no desenho
;;  fios - fiacao a ser inserida
(defun inssize(fios / sz)
  (setq sz 0)
  (while (> fios 0)
    (if (/= (logand fios 1) 0)
      (setq sz (+ sz 1))
    ) ; end if
    (setq fios (lsh fios -1))
  ) ; end while
  sz
) ; end defun

;; insfios: rotina para inserir os fios de um circuito no eletroduto
;;  fios - fiacao a ser inserida
;;  pti  - ponto de insercao do conjunto de fios
;;  vt   - vetor de incremento entre cada fio do conjunto
(defun insfios(fios pti vt / TBLK TFIO oldech it blk)
  (setq
    TBLK '(("T"  "EL/EL23C00") ("N" "EL/EL20C00") ("F" "EL/EL1FC00")
           ("RC" "EL/EL22C00") ("R" "EL/EL21C00") )
    TFIO '(("R" 32768) ("R" 16384) ("R"  8192) ("R" 4096) ("R" 2048)
           ("R"  1024) ("R"   512) ("R"   256) ("R"  128) ("R"   64)
           ("RC"   32) ("F"    16) ("F"     8) ("F"    4) ("N"    2)
           ("T"     1) )
  ) ; end setq
  (foreach it TFIO
    (progn
      (if (/= (logand fios (cadr it)) 0)
        (progn
          (setq blk (cadr (assoc (car it) TBLK)))
          (setq oldech (ai_svar "cmdecho" 0))
          (ai_insertpt (v:aid blk) pti (#SCL) (mapcar '+ pti vt))
          (setvar "cmdecho" oldech)
          (if (= (car it) "T") (setq pti (mapcar '+ pti vt)) )
          (if (= (car it) "N")
            (setq pti (mapcar '+ pti (vtmul 2.0 vt)))
            (setq pti (mapcar '+ pti (vtmul 1.5 vt)))
          ) ; end if
        ) ; end progn
      ) ; end if
    ) ; end progn
  ) ; end foreach
  pti
) ; end defun

;; reletr: rotina para inserir o resultado da fiacao em um eletroduto
;;   eletr - lista que descreve a fiacao que passa pelo eletroduto
(defun reletr(elem / DIST pti dir enm vt v1 v2 pt pt1 pt2 ls item sz)
  (setq DIST (* 1.0 (#SCL)))          ;; valor do espacamento
  (setq enm (handent (car elem)))
  (setq
    pti (car  (midpl enm))
    dir (cadr (midpl enm))
  ) ; end setq
  (setq vt (mapcar '* dir (list DIST DIST DIST)) )
  (setq ls (cadr elem))
  (setq v1 '(0.0 0.0 0.0))
  (foreach item ls
    (setq
      sz (inssize (cadr item))
      v1 (mapcar '+ v1 (mapcar '* vt (list sz sz sz)))
    ) ; end setq
  ) ; end foreach
  (setq pt1 (mapcar '- pti (mapcar '/ v1 '(2.0 2.0 2.0))))
  (foreach item (reverse (sort ls))
    (setq pt2 (insfios (cadr item) pt1 vt) )
    (setq pt (mapcar '+ (vtmul 0.5 (mapcar '+ pt1 pt2)) (mapcar '* (vtnorm vt) '(3.0 3.0 3.0))) )
    (command ".text" "m" pt (* 1.5 (#SCL)) 0 (car item))
    (setq pt1 pt2)
  ) ; end foreach
) ; end defun

;; rfiacao: rotina para inserir o resultado da fiacao para todo o projeto
;;  ff - nome do arquivo de entrada
(defun rfiacao(ff / rst f dat ls item oldlay)
  (setq rst "")
  (if (findfile ff)
    (progn
      (setq f (open ff "r"))
      (while (setq dat (read-line f))
        (setq rst (strcat rst dat))
      ) ; end while
      (setq f (close f))
      (setq ls (read (strcat "(" rst ")")))
      (setq oldlay (slay "EL-CIRCUITOS"))
      (foreach item ls (reletr item))
      (slay oldlay)
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

;; c:efiacao(): rotina para exportar dados para a execucao da fiacao eletrica
(defun c:efiacao(/ FILEXT oldosm)
  (m:savevars)
  (setq FILEXT (v:appl "fiacao.~xt"))
  (prompt "\nExtraindo informacoes do desenho... ")
  (efiacao FILEXT)
  (prompt "\nProcessando... ")
  (command "shell" "runfiacao.bat")
  (prompt "\nProcessamento concluido. ")
  (m:restorevars)
  (princ)
) ; end defun

;; c:rfiacao(): rotina para importar os resultados da execucao da fiacao eletrica
(defun c:rfiacao(/ FILRST oldosm)
  (m:savevars)
  (setq FILRST (v:appl "fiacao.~st"))
  (prompt "\nInserindo resultado do processamento da fiacao... ")
  (rfiacao FILRST)
  (m:restorevars)
  (princ)
) ; end defun

(princ)
