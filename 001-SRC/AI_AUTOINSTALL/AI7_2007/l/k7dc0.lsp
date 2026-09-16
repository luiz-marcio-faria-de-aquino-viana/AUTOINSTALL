
;;
;; K7DC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 8/23/97
;;

;; c:chgblock(): rotina que troca um conjunto de blocos de um desenho por outro
(defun c:chgblock(/ oldech oldblip PI flg enm blk scl ent ss flt cnt enm1 ent1 blk1 org1 rot1)
  (setq oldech (acadvar "cmdecho" 0))

  (setq PI 3.141592765)

  (setq flg 't)
  (while flg
    (setq enm (car (entsel "\nSelecione o bloco de referencia (ou ENTER para informar pelo nome): ")) )
    (if (or (null enm) (= (enttype enm) "INSERT"))
      (setq flg nil)
      (prompt "\nERR: Objeto selecionado nao e bloco.")
    ) ; end if
  ) ; end while

  (if (null enm)
    (progn
      (setq flg 't)
      (while flg
        (setq blk (getstring "\nNome do bloco (ou ?): "))
        (cond
          ( (= blk "?") (command ".block" "?" "*") )
          ( (= blk  "") (prompt "\nERR: Resposta nula nao e valida.") )
          ('t (progn
                (if (null (tblsearch "block" blk))
                  (prompt "\nERR: O bloco desejado nao existe no desenho.")
                  (setq flg nil)
                ) ; end if
          )   ) ; end progn, case
        ) ; end cond
      ) ; end while
      (initget 6)
      (setq scl (getdist "\nEscala para insercao do bloco <1.0>: "))
      (if (null scl) (setq scl 1.0))
    ) ; end progn
    (progn
      (setq ent (entget enm))
      (setq
        blk (cdr (assoc  2 ent))
        scl (cdr (assoc 41 ent))
      ) ; end setq
    ) ; end progn
  ) ; end if

  (prompt "\nSelecione os objetos que serao trocados...")
  (if (setq ss (ssget))
    (progn
      (setq flt (strcase (getstring "\nInforme nome do bloco para filtragem <*>: ")) )
      (if (= flt "") (setq flt "*"))
      (setq cnt (sslength ss))
      (prompt (strcat "\nProcessando " (itoa cnt) " entidades... "))
      (command ".undo" "g")
      (setq oldblip (acadvar "blipmode" 0))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq enm1 (ssname ss cnt))
        (if (= (enttype enm1) "INSERT")
          (progn
            (setq ent1 (entget enm1))
            (setq blk1 (cdr (assoc 2 ent1)))
            (if (wcmatch blk1 flt)
              (progn
                (setq
                  org1 (cdr (assoc 10 ent1))
                  rot1 (cdr (assoc 50 ent1))
                ) ; end setq
                (command
                  ".erase" enm1 ""
                  ".insert" blk org1 scl "" (* (/ rot1 PI) 180.0)
                ) ; end command
                (attreset (entlast))
                (if enm (attcpval enm (entlast)) )
              ) ; end progn
            ) ; end if
          ) ; end progn
        ) ; end if
        (if (zerop (rem cnt 10)) (prompt "."))
      ) ; end while
      (acadvar "blipmode" oldblip)
      (command ".undo" "e")
    ) ; end progn
    (prompt "\nERR: Nenhum objeto foi selecionado.")
  ) ; end if

  (acadvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
