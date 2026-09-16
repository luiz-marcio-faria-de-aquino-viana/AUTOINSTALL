
;;
;; K89C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 3/25/98
;;

;; c:eordem(): Rotina para trocar a ordem de processamento dos interruptores three-way
(defun c:eordem(/ oldecho ls ss enm idx)

  (setq ls '())

  (while (progn (initget "Undo") (setq ss (entsel "\n<Selecione interruptor>/Undo: ")) )
    (cond
      ( (= ss "Undo")    ;; processa entrada da opcao 'undo'
        (if ls (progn
                 (setq
                   enm (car ls)
                   ls  (cdr ls)
                 ) ; end setq
                 (redraw enm 4)
               ) ; end progn
               (prompt "\nERR: O conjunto de selecao esta vazio.")
      ) ) ; end if, case
      ( 't (progn        ;; processa a selecao de uma entidade
             (setq
               enm (car ss)
               idx 0
             ) ; end setq
             (if (etipo enm idx)
               (progn
                 (while (and (>= idx 0) (etipo enm idx))
                   (if (ecomando enm idx)
                     (progn
                       (setq
                         ls  (cons enm ls)
                         idx -5001
                       ) ; end setq
                       (redraw enm 3)
                     ) ; end progn
                   ) ; end if
                   (setq idx (+ idx 1))
                 ) ; end while
                 (if (>= idx 0) (prompt "\nERR: Elemento selecionado nao e um comando.") )
               ) ; end progn
               (prompt "\nERR: Objeto selecionado nao e um objeto eletrico.")
             ) ; end if
      )    ) ; end progn, case
    ) ; end cond
  ) ; end while

  (if ls
    (progn
      (m:savevars)
      (command ".undo" "g")
      (setq oldlay (slay "EL-PONTOS"))
      (foreach enm (reverse ls)
        (progn
          (command ".copy" enm "" "0,0" "@")
          (command ".erase" "p" "")
          (redraw (entlast) 4)
        ) ; end progn
      ) ; end foreach
      (m:restorevars)
      (command ".undo" "e")
      (setvar "cmdecho" oldecho)
    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

(princ)

