; K24c0/CXD - Jun/91

; Variaveis:
;    ptini  - Ponto de insercao da caixa de distribuicao     - Entrada
;    direc  - Direcao da caixa (parte frontal/parte lateral) - Entrada
;    cxwdh  - Largura da caixa de distribuicao               - Entrada
;    #cxwdh - Valor default p/larg da caixa de distribuicao  - Sistema
;    (#UND)   - Unidade utilizada no desenho (mm=1)            - Sistema
;    (#SCL)   - Escala utilizada no desenho (mm)               - Sistema

(defun C:Cxd(/ ptini direc cxwdh)  
  (initget 1)
  (setq
    ptini (getpoint "\nPonto de insercao: ")
  );endsetq
  
  (initget 1)
  (setq
    direc (getangle ptini "\nDirecao da caixa: ")
  );endsetq
  
  (if #cxwdh
    (setq
      cxwdh (getdist ptini (strcat "\nLargura da caixa <"
                                   (rtos #cxwdh 2 2) ">: "
            )              );endstrcat,dist
    );endsetq
    (progn
      (initget 1)
      (setq
        cxwdh (getdist ptini "\nLargura da caixa: ")
      );endsetq
  ) );endprogn,if
  (if cxwdh (setq #cxwdh cxwdh))
  
  (setq
    direc (* (/ direc pi) 180.0)
  );endsetq
  
  (command
  	"pline" ptini "w" 0 ""
                  (strcat "@" (rtos (/ #cxwdh 2.0) 2 6)
                          "<" (rtos (- direc 90.0) 2 6)
                  );endstrcat
                  (strcat "@" (rtos (/ 150.0 (#UND)) 2 6)
                          "<" (rtos direc 2 0)
                  );endsetrcat
                  (strcat "@" (rtos #cxwdh 2 6)
                          "<" (rtos (+ 180.0 (- direc 90.0)) 2 6)
                  );endstrcat
                  (strcat "@" (rtos (/ 150.0 (#UND)) 2 6)
                          "<" (rtos (+ 180.0 direc) 2 0)
                  );endstrcat
                  "c"
  	"hatch" "u" 45
                  (* 2.5 (#SCL)) "n"
                  "l" ""
  );endcommand
  (princ)
);enddefun

(princ)
