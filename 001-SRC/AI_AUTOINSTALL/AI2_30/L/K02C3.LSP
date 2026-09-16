; K02c0/Carimbo

;   Opcao - Opcao do tipo de carimbo a ser inserido            - Entrada
;   Resp  - Opcao de carimbo com texto de ante-projeto         - Entrada
;   Px    - Absisa do ponto de insercao do carimbo             - Interna
;   Py    - Ordenada do ponto de insercao do carimbo           - Interna

(defun C:CARIMBO(/ FORM oldech oldlay px py opc resp blk lay ss)
  (setq oldech (acadvar "cmdecho" 0))
  (setq
    FORM '(("EL" "EL/EL00C04" "EL-TEXTOS")
           ("ES" "ES/ES00C04" "ES-TEXTOS")
           ("H"  "H/H00C04"  "H-TEXTOS")
           ("G"  "G/G00C04"  "G-TEXTOS")
           ("TE" "TE/TE00C04" "TE-TEXTOS")
           ("TI" "TI/TI00C04" "TI-TEXTOS")
           ("IE" "IE/IE00C04" "IE-TEXTOS")
           ("AR" "AR/AR00C04" "AR-TEXTOS")
           ("PC" "PC/PC00C04" "PC-TEXTOS")
           ("EX" "EX/EX00C04" "EX-TEXTOS") )
  ) ; end setq
  (initget 1 "EL PC ES IE TE TI AR G H EX")
  (setq opc (getkword "\nCarimbo (EL,PC,ES,H,G,TE,TI,IE,AR ou EX): "))
  (initget "Yes No")
  (setq resp (getkword "\nCarimbo para anteprojeto <Yes>? "))
  (setq
    blk (cadr  (assoc opc FORM))
    lay (caddr (assoc opc FORM))
    px (car (getvar "limmax"))
    py (cadr (getvar "limmin"))
  );endsetq
  (setq oldlay (slay lay))
  (command
    ".insert" (v:aid "SET/SET20C00") (list px py) #SCL "" 0
    ".insert" (v:aid blk) (list px py) #SCL "" 0
  );endsetq
  (setq ss (entlast))
  (if (/= resp "No")
    (command
      ".insert"
        (v:aid "SET/SET30C00")
        (list (- px (*  97.5 #SCL)) (+ py (* 153.5 #SCL)) )
        #SCL
        ""
        60
    ) ; end command
  ) ; end if
  (command ".ddatte" ss)
  (slay oldlay)
  (setvar "cmdecho" oldech)
  (princ)
);enddefun

(princ)
