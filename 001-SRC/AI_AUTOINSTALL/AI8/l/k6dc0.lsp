
;;
;; K6DC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 8/7/97
;;

;; carrega funcoes externas necessarias a rotina
(loadf "k30c0")

;; C:EMkClh(): rotina para converter uma polilinha em calha
(defun C:EMkClh(/ nm pti ss tbl oldlay oldech oldhigh)
  (m:savevars)

  (while (= (setq nm (getstring "\nInforme a identificacao da calha: ")) "")
    (prompt "\nERR: Resposta nula nao e valida.") )
  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))
  (prompt "Selecione os objetos que serao transformados em calha...")
  (if (setq ss (ssget))
    (progn
      (setq tbl (tblsearch "block" nm))
      (if (or (null tbl)
              (progn
                (prompt "\n*ATENCAO* Existe no desenho um bloco com este nome e")
                (prompt "\na criacao desta calha modificara o bloco existente.")
                (initget "Yes No")
                (= (getkword "\nVoce tem certeza de que deseja continuar <No>? ") "Yes")
          )   ) ; end progn
        (progn
          (setq oldech (acadvar "cmdecho" 0))
          (setq oldhigh (acadvar "highlight" 0))
          (command ".undo" "g")
          (setq oldlay (slay "0"))
          (setvar "aflags" 0)
          (command
            ".attdef" "p" ""
              "#FREE2(0)" "Free(0)" ""
              pti (* 1.5 (#SCL)) "0"
            ".select" "l" ""
            ".attdef" ""
              "#FREE1(0)" "Free(0)" ""
              (list (car pti) (+ (cadr pti) (* 3.0 (#SCL)))) (* 1.5 (#SCL)) "0"
            ".select" "l" "p" ""
            ".attdef" "i" ""
              "#QUADRO_ORIGEM(0)" "Quadro de origem(0)" ""
              (list (car pti) (+ (cadr pti) (* 6.0 (#SCL)))) (* 1.5 (#SCL)) "0"
            ".select" "l" "p" ""
            ".attdef" ""
              "#TIPO(0)" "Tipo de aparelho(0)" "ECALHA"
              (list (car pti) (+ (cadr pti) (* 9.0 (#SCL)))) (* 1.5 (#SCL)) "0"
            ".change" "l" "p" ss "" "p" "la" "0" "c" "byblock" "lt" "byblock" ""
          ) ; end command
          (if tbl
            (command ".block" nm "y" pti "p" ss "")
            (command ".block" nm pti "p" ss "")
          ) ; end if
          (slay "EL-PONTOS")
          (command ".insert" nm pti "" "" "0")
          (slay oldlay)
          (command ".undo" "e")
          (acadvar "highlight" oldhigh)
          (acadvar "cmdecho" oldech)
          (attvalue (entlast) "#QUADRO_ORIGEM(0)" (uorigem))
        ) ; end progn
      ) ; end if
    ) ; end progn
  ) ; end if

  (m:savevars)
  (princ)
) ; end defun

(princ)
