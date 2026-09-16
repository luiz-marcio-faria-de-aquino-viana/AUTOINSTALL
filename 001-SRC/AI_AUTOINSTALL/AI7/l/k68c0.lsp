; -- ESG v1.1  - Copyright (C)1993, TML Software

; ESG00 - Mai/93
; --------------

;  - ESGtb   -- TUBOS DE PONTA E BOLSA


(defun c:ESGtb()
  (setvar "cmdecho" 0)
  (setq
    lblk '((40 . "esg/esg46c00") (50 . "esg/esg46c20") (75 . "esg/esg46c40")
           (100 . "esg/esg46c70") (150 . "esg/esg46ca0"))
  )
  (if #esgdn
    (progn
      (initget "40 50 75 100 150")
      (setq
        esgdn (getkword
                (strcat "\nDiametro nominal do tubo <" (itoa #esgdn) ">: ")
      )       )
    )
    (progn
      (initget 1 "40 50 75 100 150")
      (setq
        esgdn (getkword "\nDiametro nominal do tubo: ")
    ) )
  )
  (if esgdn (setq #esgdn (atoi esgdn)))
  (setq
    blck (cdr (assoc #esgdn lblk))
  )
  (initget 1)
  (setq
    pti (getpoint "\nPonto inicial: ")
  )
  (initget 1)
  (setq
    ptf (getpoint pti "\nPonto final: ")
  )

  (setq
    fator (/ (#SCL) 25.0)
    raio (* (/ #esgdn 2.0) fator)
    dist (- (distance pti ptf)
            (* 59.0 (/ #esgdn 100.0) fator)
         )
  )
  (if(minusp dist)(setq dist 0))

  (setq
    u (vtunit (vtnorm (mapcar '- ptf pti)))
    v (vtmul raio u)
  )

  (setvar "blipmode" 0)
  (command
    "line" (mapcar '+ pti v) (mapcar '+ ptf v) ""
    "line" (mapcar '- pti v) (mapcar '- ptf v) ""
  )
  (ai_insert (V:AID blck) ptf fator (angle pti ptf))

  (setvar "blipmode" 1)
  (princ)
)
(princ)
