; K02c0/Carimbo R4

; +-------------------------- VARIAVEIS ---------------------------------+

;   Opcao - Opcao do tipo de carimbo a ser inserido            - Entrada
;   Resp  - Opcao de carimbo com texto de ante-projeto         - Entrada
;   Px    - Absisa do ponto de insercao do carimbo             - Interna
;   Py    - Ordenada do ponto de insercao do carimbo           - Interna

; +--------------------- DEFINICAO DA ROTINA ----------------------------+

(defun C:CARIMBO(/ px py opcao resp ss)
  (setvar "cmdecho" 0)

; +----------------------- ENTRADA DE DADOS -----------------------------+

  (initget 1 "EL PC ES IE TE TI AR G H EX")
  (setq opcao (getkword "\nCarimbo (EL,PC,ES,H,G,TE,TI,IE,AR ou EX): "))

  (initget "Yes No")
  (setq resp (getkword "\nCarimbo para ante-projeto <Yes>? "))

; +--------------------- INSERCAO DO CARIMBO ----------------------------+

  (setq
    px (car (getvar "limmax"))
    py (cadr (getvar "limmin"))
  );endsetq

  (command ".insert"
    (strcat (v:aid opcao) "00c03")
    (list px py) #SCL "" 0
  );endsetq
  (setq ss (entlast))

  (if (/= resp "No")
    (command
      ".text"
        "m"
        (list
          (- px (*  97.5 #SCL))
          (+ py (* 153.5 #SCL))
        ) ; end list
        (* 15.0 #SCL)
        45
        "ANTE-PROJETO"
    ) ; end command
  ) ; end if

  (command ".ddatte" ss)

; +-------------------------- FINALIZACAO -------------------------------+

  (princ)
);enddefun

(princ)
