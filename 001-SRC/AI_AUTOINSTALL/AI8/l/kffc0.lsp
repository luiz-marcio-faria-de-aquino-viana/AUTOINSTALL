
;;
;; KFFC0.lsp
;; Copyright (C) 1999 by Luiz Marcio F A Viana, 4/5/99
;;

;; c:ff_fiacao(): rotina para ajuste da fiacao do desenho
(defun c:ff_fiacao(/ oldech ent enm TB_DAT sclx scly sclz flg it ss cnt)
  (m:savevars)

  (setq TB_DAT '("EL1FC00" "EL20C00" "EL21C00" "EL22C00" "EL23C00"))

  (if (setq enm (car (entsel "\nSelecione uma fiacao para referencia: ")))
    (progn
      (setq
        ent (entget enm)
        sclx (assoc 41 ent)
        scly (assoc 42 ent)
        sclz (assoc 43 ent)
      ) ; end setq

      (foreach it TB_DAT (command ".insert" (strcat it "=" (V:AID "EL/") it) nil) )

      (command ".select")

      (setq flg nil)
      (foreach it TB_DAT
        (if (setq ss (ssget "x" (list '(0 . "INSERT") (cons 2 it))) )
          (progn
            (command ss)
            (setq flg 't)
          ) ; end progn
        ) ; end if
      ) ; end foreach
      (command "")

      (if (and flg (setq ss (ssget "p")))
        (progn
          (setq cnt (sslength ss))
          (while (>= (setq cnt (1- cnt)) 0)
            (setq
              enm (ssname ss cnt)
              ent (entget enm)
            ) ; end setq
            (setq
              ent (subst sclx (assoc 41 ent) ent)
              ent (subst scly (assoc 42 ent) ent)
              ent (subst sclz (assoc 43 ent) ent)
            ) ; end setq
            (entmod ent)
            (entupd enm)
          ) ; end while
        ) ; end progn
      ) ; end if
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

;; ff_byblock(): funcao que atribui a cor byblock e camada 0 aos elementos de um bloco
(defun ff_byblock(blk / tbl enm ent)
  (setq tbl (tblsearch "block" blk))
  (setq enm (cdr (assoc -2 tbl)) )
  (while enm
    (setq ent (entget enm))
    (if (= (enttype enm) "INSERT")
      (ff_byblock (cdr (assoc 2 ent)))
      (progn
        (setq ent (subst '(8 . "0") (assoc 8 ent) ent))
        (if (assoc 62 ent)
          (setq ent (subst '(62 . 0) (assoc 62 ent) ent) )
          (setq ent (append ent '((62 . 0))) )
        ) ; end if
        (entmod ent)
        (entupd enm)
      ) ; end progn
    ) ; end if
    (setq enm (entnext enm))
  ) ; end while
) ; end defun

;; c:ff_byblock(): funcao que atribui a cor byblock e camada 0 aos elementos de um bloco
(defun c:ff_byblock(/ oldech enm blk)
  (m:savevars)

  (if (setq enm (car (entsel "\nSelecione o bloco de referencia: ")) )
    (if (= (enttype enm) "INSERT")
      (progn
        (setq blk (cdr (assoc 2 (entget enm))) )
        (ff_byblock blk)
      ) ; end progn
      (prompt "\nERR: O elemento selecionado nao e um bloco.")
    ) ; end if
    (prompt "\nERR: Nenhum bloco foi selecionado.")
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

(princ)
