
;;
;; K80C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 8/14/97
;;

;; carrega funcoes externas necessarias a rotina
(loadf "k30c0")

;; EInsObj_ComposeBit(): funcao que retorna um conjunto de bits que reflete a composicao do objeto
;;  enm - ename do objeto que sera analisado
(defun EInsObj_ComposeBit(enm / idx bit)

  (setq
    BIT_N 16
    BIT_Q  8
    BIT_D  4
    BIT_P  2
    BIT_F  1
  ) ; end setq

  (setq bit 0)    ;; bit indicador da composicao do bloco

  (setq idx 0)
  (while (setq tip (etipo enm idx))
    (cond
      ( (or (= tip "ECARGA") (= tip "EILUMINACAO"))
        (setq bit  (logior bit BIT_Q BIT_P BIT_F))
      ) ; end case
      ( (or (= tip "ECOMANDO") (= tip "ECAMPAINHA")
            (= tip "ECAIXA")   (= tip "ECALHA") )
        (setq bit (logior bit BIT_Q))
      ) ; end case
      ( (= tip "EQUADRO") (setq bit (logior bit BIT_N BIT_Q BIT_F)))
      ( (= tip "EDESVIO") (setq bit (logior bit BIT_Q BIT_D)))
    ) ; end cond
    (setq idx (1+ idx))
  ) ; end while
  bit
) ; end defun

;; C:EInsObj(): rotina que transforma um conjunto de elementos em um objeto eletrico
(defun C:EInsObj(/ oldmnu oldech BIT_N BIT_Q BIT_D BIT_P BIT_F flg blk nblk pt1
  rot bit qdr org dsv pot fas idx)
  (m:savevars)

  (setq oldech (acadvar "cmdecho" 0))

  (setq
    BIT_N 16
    BIT_Q  8
    BIT_D  4
    BIT_P  2
    BIT_F  1
  ) ; end setq

  (setq flg 't)
  (while flg
    (if #BLCK
      (setq blk (strcase (getstring (strcat "\nNome do bloco (ou ?) <" #BLCK ">: "))) )
      (while (= (setq blk (getstring "\nNome do bloco (ou ?): ")) "")
        (prompt "\nERR: Resposta nula nao e valida.") )
    ) ; end if
    (if (/= blk "") (setq nblk blk) (setq nblk #BLCK))
    (if (= nblk "?")
      (command ".block" "?" "")
      (if (not (tblsearch "block" nblk))
        (prompt "\nERR: Objeto eletrico inexistente no desenho.")
        (setq flg nil)
      ) ; end if
    ) ; end if
  ) ; end while

  (setq #BLCK nblk)

  (initget 1)
  (setq pt1 (getpoint "\nPonto de insercao: "))

  (setq rot (getangle pt1 "\nRotacao <0>: "))
  (if (null rot) (setq rot 0))

  (command ".insert" #BLCK pt1 "1" "" (* (/ rot PI) 180.0))

  (setq bit (EInsObj_ComposeBit (entlast)) )

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

  (setq idx 0)
  (while (etipo (entlast) idx)
    (if (> (logand bit BIT_N) 0) (attvalue (entlast) (strcat "#NOME_QUADRO(" (itoa idx) ")") qdr))
    (if (> (logand bit BIT_Q) 0) (attvalue (entlast) (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") org))
    (if (> (logand bit BIT_D) 0) (attvalue (entlast) (strcat "#DESVIO(" (itoa idx) ")") dsv))
    (if (> (logand bit BIT_P) 0) (attvalue (entlast) (strcat "#POTENCIA(" (itoa idx) ")") pot))
    (if (> (logand bit BIT_F) 0) (attvalue (entlast) (strcat "#SISTEMA(" (itoa idx) ")") fas))
    (setq idx (1+ idx))
  ) ; end while

  (m:restorevars)
  (princ)
) ; end defun

(princ)
