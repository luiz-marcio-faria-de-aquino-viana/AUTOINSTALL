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
    fator (/ #scl 25.0)
    raio (* (/ #esgdn 2.0) fator)
    dist (- (distance pti ptf)
            (* 59.0 (/ #esgdn 100.0) fator)
         )
  )
  (if(minusp dist)(setq dist 0))

  (setvar "blipmode" 0)
  (command
    "ucs" "or" pti
    "ucs" "z" pti ptf
    "line"
      (list 0.0 raio)
      (list dist raio) ""
    "line"
      (list 0.0 (- raio))
      (list dist (- raio)) ""
    "insert" (V:AID blck)
             (list dist 0.0)
             fator "" "0"
    "ucs" "w"
  )
  (setvar "blipmode" 1)
  (princ)
)
(princ)
