
;;
;; K5DC0.lsp
;; Copyright (C) 1996 by Paulo Lincoln de Oliveira, 4/17/96
;;

;; declaracao das variaveis globais
(setq #I_NVERT "Circulo")
(setq #I_CONT          1)
(setq #I_INCR          t)

;; I_INDIC: rotina para desenho de indicadores
(defun c:i_indic(/ oldech p1 p2 r op msg)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (initget 1)
  (setq p1 (getpoint "\nPrimeiro ponto: "))

  (initget 1)
  (setq p2 (getpoint  p1 "\nSegundo ponto: "))

  (initget 6 "Circulo")
  (if (= (type #I_NVERT) 'INT)
    (setq op (getint (strcat "\nNumero de vertices/Circulo <" (itoa #I_NVERT) ">: ")))
    (setq op (getint (strcat "\nNumero de vertices/Circulo <" #I_NVERT        ">: ")))
  ) ; end if
  (if op (setq #I_NVERT op))

  (setq r (* 3.0 #SCL))

  (if (= #I_NVERT "Circulo")
    (command
      ".line" p1 p2 ""
      ".circle" p2 r
      ".trim" "l" "" p2 ""
    ) ; end command
    (command
      ".line" p1 p2 ""
      ".polygon" #I_NVERT p2 "i" r
      ".trim" "l" "" p2 ""
    ) ; end command
  ) ; end if
  
  (initget 6)
  (setq cnt (getint (strcat "\nEntre com o identificador <" (itoa #I_CONT) "> :")))
  (setq des (getstring t "\nDescricao: "))
  (if cnt (setq #I_CONT cnt))
  (command ".insert" (v:aid "SET/SET10C00") "s" #SCL p2 0)
  (setq enm (entlast))
  (attvalue enm "#I_IDENT" (itoa #I_CONT))
  (if (= #I_NVERT "Circulo")
    (attvalue enm "#I_NVERT"             "0")
    (attvalue enm "#I_NVERT" (itoa #I_NVERT))
  ) ; end if
  (attvalue enm "#I_DESCR"          des)
  (if #I_INCR (setq #I_CONT (+ #I_CONT 1)) )
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

;;
;; I_LEGENDA
(defun c:i_legenda()
  (setq r (* 5.0 #SCL))
  (prompt "\nSelecione os indicadores... ")
  (if (setq ss (ssget))
    (progn
      (initget 1)
      (setq pti (getpoint "\nPonto de insercao: "))
      (command ".attext" "s" (v:ail "X5Dc0") (v:appl "$TEMP$"))
      (if (findfile (setq ff (strcat (v:appl "$TEMP$") ".txt")) )
        (progn
          (setq f (open ff "r"))
          (while (setq s (read-line f))
            (setq
              nvert (atoi  (substr s 1  3))
              ident (rtrim (substr s 4  3))
              descr (rtrim (substr s 7 60))
            ) ; end setq
            (if (not (strnull descr))
              (progn
                (if (zerop nvert)
                  (command ".circle"        pti     r)
                  (command ".polygon" nvert pti "i" r)
                ) ; end if
                (command ".text" "m" pti (* 2.0 #SCL) "0" ident)
                (command ".text" "j" "ml" (list (+ (car pti) (* 1.5 r)) (cadr pti)) (* 2.0 #SCL) "0" descr)
                (setq pti (list (car pti) (- (cadr pti) (* 2.5 r))) )
              ) ; end progn
            ) ; end if
          ) ; end while
          (setq f (close f))
        ) ; end progn
      ) ; end if
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

(princ)
