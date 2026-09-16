
;  LAYER.lsp
; ____________________________________________________________________________
;        Copyright (C) 1994  by TML Software, Inc. All Rights Reserved.

;             AI support file - by Luiz Marcio F A Viana, 3/23/94.
;

;
;  PS  -- pick and set layer

(defun c:ps(/ entpick entlay)
  (setvar "cmdecho" 0)

  (if (setq entpick (nentsel "\nClick um objeto para selecionar o layer: "))
    (progn
      (setq entlay (cdr (assoc 8 (entget (car entpick)))))
      (command "layer" "s" entlay "")
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

;
;  PF  -- pick and freeze layer

(defun c:pf(/ entpick entlay)
  (setvar "cmdecho" 0)

  (if (setq entpick (nentsel "\nClick um objeto para selecionar o layer: "))
    (progn
      (setq entlay (cdr (assoc 8 (entget (car entpick)))))
      (command "layer" "f" entlay "")
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

;
;  PCH  -- pick and change object

(defun c:pch(/ entselc entpick entlay)
  (setvar "cmdecho" 0)

  (if (and
        (setq entselc (ssget))
        (setq entpick (nentsel "\nClick um objeto para selecionar o layer: "))
      ) ; end and
    (progn
      (setq entlay (cdr (assoc 8 (entget (car entpick)))))
      (command ".change" entselc "" "p" "la" entlay "")
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

(princ)
