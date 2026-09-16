
;;
;; K72C0.lsp
;; Copyright (C) 1996 by Fabio Henrique de Araujo, 12/10/96
;;

;; c:diagelet - rotina para desenhar o quadro unifilar
(defun c:diagelet(/ BLK dy qt p1 p2 x y)
  (setq oldech (acadvar "cmdecho" 0))

  (setq BLK "EL/EL3EC00")
  (setq dy (* 10.0 #SCL))

  (initget (+ 1 2 4))
  (setq qt (getint "\nNumero de disjuntores: "))

  (initget 1)
  (setq p1 (getpoint "\nPonto de insercao: "        ))

  (setq
    x (car  p1)
    y (cadr p1)
  )
  (setq p2 (list x (- y (* (- qt 1) dy)) ) )

  (repeat qt
    (progn   
      (command 
        "line" p1 p2 ""   
        "insert" (v:aid BLK) p1 #SCL #SCL 0
      )
      (setq p1 (list x (- (cadr p1) dy)) )
    )
  )
  (setvar "cmdecho" oldech)
  (princ)
)
