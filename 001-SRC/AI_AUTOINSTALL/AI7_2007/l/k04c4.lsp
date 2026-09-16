
;;
;; K04C0.lsp
;; Copyright (C) 1991 by Luiz Marcio F A Viana, 3/20/98
;;

;; c:circuito(): rotina para desenho da fiacao eletrica
(defun c:circuito(/ oldecho DIST pti flg enm opt vd ptf ls pt0 opt1 blk oldblip itm enm1)
  (setq oldecho (acadvar "cmdecho" 0))

  (setq DIST (* 1.0 (#SCL)))     ;; distancia entre os elementos da fiacao

  (initget 1 "Alinhado Centrado")
  (setq pti (getpoint "\nAlinhado na polilinha/Centrado num ponto/<Ponto inicial>: "))

  (cond
    ( (= pti "Alinhado")
      (progn
        (setq flg 't)
        (while flg
          (setq enm (car (entsel "\nSelecione o eletroduto: ")) )
          (cond
            ( (null enm)
              (prompt "\nERR: Resposta nula nao e valida.")
            ) ; end case
            ( (and (/= (enttype enm) "POLYLINE") (/= (enttype enm) "LWPOLYLINE"))
              (prompt "\nERR: Entidade selecionada nao e uma polilinha.")
            ) ; end case
            ('t  (setq flg nil))
          ) ; end cond
        ) ; end while
        (if (or (= (enttype enm) "POLYLINE") (= (enttype enm) "LWPOLYLINE"))
          (setq
            opt "Alinhado"
            pti (car  (midpl enm))
            vd  (vtmul DIST (cadr (midpl enm)))
          ) ; end setq
        ) ; end if
    ) ) ; end progn, case
    ( (= pti "Centrado")
      (progn
        (initget 1)
        (setq pti (getpoint "\nPonto inicial: "))
        (initget 1)
        (setq ptf (getpoint pti "\nDirecao de preenchimento: "))
        (setq
          opt "Centrado"
          vd (vtmul DIST (vtunit (mapcar '- ptf pti)))
        ) ; end setq
    ) ) ; end progn, case
    ( 't
      (progn
        (initget 1)
        (setq ptf (getpoint pti "\nDirecao de preenchimento: "))
        (setq
          opt "Esquerda"
          vd (vtmul DIST (vtunit (mapcar '- ptf pti)))
        ) ; end setq
    ) ) ; end progn, case
  ) ; end cond

  (command ".undo" "g")

  (setq
    ls '()
    pt0 pti
  ) ; end setq

  (while (progn
           (initget "Retorno Fase Neutro Terra Campainha Espaco Undo")
           (setq opt1 (getkword "\nRetorno/Fase/Neutro/Terra/retorno Campainha/Espaco/Undo (ENTER=sai): "))
         ) ; end progn
    (cond
      ((= opt1 "Retorno")   (setq blk "EL/EL21c00"))
      ((= opt1 "Fase")      (setq blk "EL/EL1fc00"))
      ((= opt1 "Neutro")    (setq blk "EL/EL20c00"))
      ((= opt1 "Terra")     (setq blk "EL/EL23c00"))
      ((= opt1 "Campainha") (setq blk "EL/EL22c00"))
      ('t                   (setq blk nil))
    ) ; end cond
    (if blk
      (progn
        (setq oldblip (acadvar "blipmode" 0))
        (ai_insertpt (V:AID blk) pt0 (#SCL) (mapcar '+ pt0 vd))
        (setvar "blipmode" oldblip)
        (setq enm1 (entlast))
      ) ; end progn
      (setq enm1 nil)
    ) ; end if

    (if (and (= opt1 "Undo") ls)
      (progn
        (while (and (null (setq enm1 (cadr (car ls)))) ls)
          (setq pt0 (mapcar '- pt0 vd))
          (setq ls (cdr ls))
        ) ; end while
        (if enm1
          (progn
            (command ".erase" enm1 "")
            (setq pt0 (mapcar '- pt0 vd))
            (setq ls (cdr ls))
          ) ; end progn
        ) ; end if
      ) ; end progn
      (progn
        (setq ls (cons (list blk enm1) ls))
        (setq pt0 (mapcar '+ pt0 vd))
      ) ; end progn
    ) ; end if
  ) ; end while

  (if (or (= opt "Alinhado") (= opt "Centrado"))
    (progn
      (setq pt0 (mapcar '- pti (vtmul (/ (length ls) 2.0) vd)) )
      (setq oldblip (acadvar "blipmode" 0))
      (foreach itm (reverse ls)
        (progn
          (setq
            blk (car  itm)
            enm (cadr itm)
          ) ; end setq
          (if blk
            (progn
              (command ".erase" enm "")
              (ai_insertpt (V:AID blk) pt0 (#SCL) (mapcar '+ pt0 vd))
            ) ; end progn
          ) ; end if
          (setq pt0 (mapcar '+ pt0 vd))
        ) ; end progn
      ) ; end foreach
      (setvar "blipmode" oldblip)
    ) ; end progn
  ) ; end if

  (command ".undo" "e")

  (setvar "cmdecho" oldecho)
  (princ)
) ; end defun

(princ)
