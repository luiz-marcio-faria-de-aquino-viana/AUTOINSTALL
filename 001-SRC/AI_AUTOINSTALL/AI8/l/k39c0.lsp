
;;
;; IMPTXT.lsp
;; Copyright (C) by Luiz Marcio F A Viana, 12/11/95
;;

;;
;; IMPTXT: programa para importar arquivo texto para o autocad

(defun c:imptxt(/ oldech fn fn1 ff pti h d dx txt oldstyle oldhigh oldblip)
  (m:savevars)

  (command ".undo" "g")
  (if #INFIL
    (setq fn (strcase (getstring (strcat "\nNome do arquivo de entrada <" #INFIL ">: "))))
    (while (= (setq fn (strcase (getstring "\nNome do arquivo de entrada: "))) ""))
  ) ; end if
  (if (/= fn "") (setq #INFIL fn))
  (if (setq fn1 (findfile #INFIL))
    (progn
      (initget 1 "Centro Direita")
      (setq pti (getpoint "Alinhamento (C)entro/(D)ireita/<Ponto de insercao>: "))
      (if (or (= pti "Centro") (= pti "Direita"))
        (progn
          (setq ff pti)
          (initget 1)
          (setq pti (getpoint "\nPonto de insercao: "))
        ) ; end progn
        (setq ff "Esquerda")
      ) ; end if
      (cond
        ((= ff "Centro") (setq ff "C"))
        ((= ff "Direita") (setq ff "R"))
        ((= ff "Esquerda") (setq ff "L"))
      ) ; end cond
      (initget "Micro Normal Super")
      (setq h (getdist pti (strcat "\nAltura do texto <" (rtos (getvar "textsize") 2) ">: ")))
      (if (null h) (setq h (getvar "textsize")))
      (cond
        ((= h "Micro") (setq h (* 1.5 (#SCL))))
        ((= h "Normal") (setq h (* 2.0 (#SCL))))
        ((= h "Super") (setq h (* 4.0 (#SCL))))
      ) ; end cond
      (initget "Proporcional")
      (setq d (getdist pti "\nDistancia entre linhas/<Proporcional>: "))
      (if (or (null d) (= d "Proporcional"))
        (setq dx (* h 1.75))
        (setq dx d)
      ) ; end if
      (setq oldstyle (getvar "textstyle"))
      (setq fp (open fn1 "r"))
      (setq oldhigh (getvar "highlight"))
      (setvar "highlight" 0)
      (setq oldblip (getvar "blipmode"))
      (setvar "blipmode" 0)
      (command ".-style" "monotxt" "monotxt" "" "" "" "" "" "")
      (while (setq txt (read-line fp))
        (if (/= ff "L")
          (command ".text" ff pti h "" txt)
          (command ".text" "s" "monotxt" pti h "" txt)
        ) ; end if
        (setq pti (list (car pti) (- (cadr pti) dx)) )
      ) ; end while
      (setvar "blipmode" oldblip)
      (setvar "highlight" oldhigh)
      (setq fp (close fp))
      (command ".-style" oldstyle "" "" "" "" "" "" "")
      (setvar "textsize" h)
    ) ; end progn
    (prompt "\n* ERROR * Arquivo nao encontrado ou nome invalido")
  ) ; end if
  (command ".undo" "e")

  (m:restorevars)
  (princ)
) ; end defun

(princ)
