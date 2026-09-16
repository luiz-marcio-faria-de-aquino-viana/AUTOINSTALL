; -- ESG v1.1  - Copyright (C)1993, TML Software
; ESG01 - Mai/93
; --------------

;  - ESGin   -- INSERCAO DAS CONEXOES SANITARIAS


(defun c:ESGin()
  (m:savevars)

  (setq
    lbit '(("40"       . "c0") ("50X40" . "c1") ("50"       . "c2")
           ("75X50"    . "c3") ("75"    . "c4") ("100X50"   . "c5")
           ("100X75"   . "c6") ("100"   . "c7") ("150X75"   . "c8")
           ("150X100"  . "c9") ("150"   . "ca"))
    lrot '(("0"        . "0" ) ("45"    . "1" ) ("90"       . "2" )
           ("135"      . "3" ) ("180"   . "4" ) ("-135"     . "5" )
           ("-90"      . "6" ) ("-45"   . "7" ) ("SUPERIOR" . "8" )
           ("INFERIOR" . "9" ))
  )

  (if #codg
    (setq
      codg (getstring
             (strcat "\nCodigo da peca <" #codg ">: ")
    )      )
    (while (= ""
              (setq
                codg (getstring "\nCodigo da peca: ")
    )      )  )
  )
  (if(/= codg "") (setq #codg codg))

  (if #esgbl
    (progn
      (initget "40 50X40 50 75X50 75 100X50 100X75 100 150X75 150X100 150")
      (setq
        esgbl (getkword
                (strcat
                  "\nDiametro nominal da peca <" #esgbl ">: "
              ) )
    ) )
    (progn
      (initget 1 "40 50X40 50 75X50 75 100X50 100X75 100 150X75 150X100 150")
      (setq
        esgbl (getkword "\nDiametro nominal da peca: ")
    ) )
  )
  (if esgbl (setq #esgbl esgbl))

  (if #esgrt
    (progn
      (initget "-135 -90 -45 0 45 90 135 180 SUPERIOR INFERIOR")
      (setq
        esgrt (getkword
                (strcat
                  "\nRotacao da peca sobre seu eixo <" #esgrt ">: "
              ) )
    ) )
    (progn
      (initget 1 "-135 -90 -45 0 45 90 135 180 SUPERIOR INFERIOR")
      (setq
        esgrt (getkword "\nRotacao da peca sobre seu eixo: ")
    ) )
  )
  (if esgrt (setq #esgrt esgrt))

  (setq
    blck (strcat
           #codg (cdr (assoc #esgbl lbit)) (cdr (assoc #esgrt lrot))
  )      )

  (setq fat (/ (#SCL) 25.0))

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (setq rot (getangle pti "\nRotacao <0>: "))
  (if (null rot) (setq rot 0.0))

  (if (findfile (strcat (V:AID blck) ".dwg"))
    (ai_insert (V:AID blck) pti fat rot)
    (prompt "\nERR: Este modelo de peca nao existe.")
  )

  (m:restorevars)
  (princ)
)
(princ)
