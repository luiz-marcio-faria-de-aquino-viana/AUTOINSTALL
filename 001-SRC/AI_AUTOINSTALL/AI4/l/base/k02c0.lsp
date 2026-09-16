
;;
;; K02C0.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 7/31/2000
;;

;; c:ai_poff(): rotina que desliga a camada que contem o objeto selecionado
(defun c:ai_poff(/ oldech ss enmls ent blk tbl enm lay)
  (setq oldech (ai_svar "cmdecho" 0))

  (if (setq ss (nentsel "\nSelecione o objeto de referencia: "))
    (if (setq enmls (cadddr ss))
      (progn
        ;; objeto selecionado pertence a um bloco ou referencia externa

        (setq ent (entget (car (reverse enmls))) )
        (setq blk (cdr (assoc 2 ent)) )

        (setq tbl (tblsearch "block" blk))
        (if (/= (logand (cdr (assoc 70 tbl)) 4) 0)
          (progn
            ;; objeto selecionado pertence a uma referencia externa

            (if (setq enm (cadr (reverse enmls)))
              (progn
                ;; objeto selecionado pertence a um bloco dentro de uma referencia externa

                (setq ent (entget enm))
                (setq lay (cdr (assoc 8 ent)))
                (ai_offlay (strcat blk "|" lay))

              ) ; end progn
              (progn
                ;; objeto selecionado e uma entidade simples dentro de uma referencia externa

                (setq ent (entget (car ss)))
                (setq lay (cdr (assoc 8 ent)))
                (ai_offlay (strcat blk "|" lay))

              ) ; end progn
            ) ; end if

          ) ; end progn
          (progn
            ;; objeto selecionado pertence a um bloco

            (setq lay (cdr (assoc 8 ent)))
            (ai_offlay lay)

          ) ; end progn
        ) ; end if

      ) ; end progn
      (progn
        ;; objeto selecionado nao pertence a um bloco

        (setq ent (entget (car ss)))
        (setq lay (cdr (assoc 8 ent)))
        (ai_offlay lay)

      ) ; end progn
    ) ; end if
  ) ; end if

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
