
;;
;; K3EC0.lsp
;; Copyright (C) 1999 by Luiz Marcio F A Viana, 8/24/99
;;

;; c:ps(): rotina que ativa uma camada selecionando um de seus objetos
(defun c:ps(/ sel enm ent lay)
  (setvar "cmdecho" 0)
  (if (setq sel (nentsel "\nClick num objeto para selecionar o layer: "))
    (progn
      (setq
        enm (car sel)
        ent (entget enm)
        lay (cdr (assoc 8 ent))
      ) ; end setq
      (if (setq lst (cadddr sel))
        (while (and lst (= lay "0"))
          (setq
            enm (car lst)
            ent (entget enm)
            lay (cdr (assoc 8 ent))
          ) ; end setq
          (setq lst (cdr lst))
        ) ; end while
      ) ; end if
      (command "layer" "s" lay "")
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

;; c:pf(): rotina para congelar a camada selecionada
(defun c:pf(/ sel enm ent lay)
  (setvar "cmdecho" 0)
  (if (setq sel (nentsel "\nClick num objeto para selecionar o layer: "))
    (progn
      (setq
        enm (car sel)
        ent (entget enm)
        lay (cdr (assoc 8 ent))
      ) ; end setq
      (if (setq lst (cadddr sel))
        (while (and lst (= lay "0"))
          (setq
            enm (car lst)
            ent (entget enm)
            lay (cdr (assoc 8 ent))
          ) ; end setq
          (setq lst (cdr lst))
        ) ; end while
      ) ; end if
      (command "layer" "f" lay "")
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

;; c:pch(): rotina para modificar a camada de um objeto a partir de outro
(defun c:pch(/ ss enm lay)
  (setvar "cmdecho" 0)
  (if (setq enm (car (entsel "\nSelecione um objeto na camada de referencia: ")))
    (if (setq ss (ssget))
      (progn
        (setq lay (cdr (assoc 8 (entget enm))))
        (command ".change" ss "" "p" "la" lay "")
      ) ; end progn
    ) ; end if
  ) ; end if
  (princ)
) ; end defun

(princ)
