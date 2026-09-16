
;;
;; K75C0.lsp
;; Copyright (C) 1997 by Fabio Henrique de Araujo
;;                       Luiz Marcio F A Viana, 2/21/97
;;
;; Descricao: Rotina para apresentacao do desenho em vista isometrica
;;

;; c:isoblk: rotina que cria uma representacao isometrica da planta baixa
(defun c:isoblk(/ oldech oldhigh oldblip oldlay pci pcf ptm pq pta ptb
  pt1 pt2 pt3 pt4 ss v1 pt1u pt2u pti)
  (setq oldech (acadvar "cmdecho" 0))

  (prompt "\nSelecione a regiao para o isometrico...")
  (setq pci  (getpoint "\nPrimeiro canto: "))
  (setq pcf  (getcorner pci "\nSegundo canto: "))

  (setq ptm (mapcar '/ (mapcar '+ pci pcf) '(2.0 2.0 2.0)) )
  (setq pq  (getpoint ptm "\nSelecione o quadrante: "))

  (setq pta (list (min (car pci) (car pcf)) (min (cadr pci) (cadr pcf))) )
  (setq ptb (list (max (car pci) (car pcf)) (max (cadr pci) (cadr pcf))) )

  (setq pt1 (getpoint pta "\nPonto de insercao: "))
  (setq pt2 (mapcar '+ pt1 (mapcar '- ptb pta)) )
  (setq pt3 (list (car pt1) (cadr pt2)) )
  (setq pt4 (list (car pt2) (cadr pt1)) )
    
  (command ".undo" "g")

  (setq oldhigh (acadvar "highlight" 0))
  (setq oldblip (acadvar "blipmode"  0))

  (command ".copy" "c" pci pcf "" pta pt1)

  (setq ss (ssget "c" pt1 pt2))

  (setq v1 (mapcar '- pq ptm))
  (command 
    ".ucs" "d" "$ISOBLK"
    ".ucs" "s" "$ISOBLK"
  ) ;; end command
  
  (cond 
    ( (and (minusp (car v1)) (minusp (cadr v1)) )
      (progn
        (command ".ucs" "za" "0,0" "-1,-1,1")
        (setq pti (trans pt1 0 1))
    ) ) ; end progn, case
    ( (minusp (car v1))
      (progn
        (command ".ucs" "za" "0,0" "-1,1,1" )
        (setq pti (trans pt3 0 1))
    ) ) ; end progn, case
    ( (minusp (cadr v1))
      (progn
        (command ".ucs" "za" "0,0" "1,-1,1" )
        (setq pti (trans pt4 0 1))
    ) ) ; end progn, case
    ( t (progn
          (command ".ucs" "za" "0,0" "1,1,1"  )
          (setq pti (trans pt2 0 1))
    )   ) ; end progn, case
  ) ;; end cond

  ;; redefinindo os ponto na ucs atual
  (setq pt1u (trans pt1 0 1))
  (setq pt2u (trans pt2 0 1))
  
  ;; preparando o bloco em vista isometrica
  (cond
    ((tblsearch "block" "$isoblk") (command ".block" "$isoblk" "y" pti "c" pt1u pt2u ""))
    ( t                            (command ".block" "$isoblk"     pti "c" pt1u pt2u ""))
  ) ;; end cond
  
  ;; inserindo o bloco da vista isometrica 
  (command
      ".ucs" "r" "$isoblk"
      ".insert"  "*$isoblk" pt1 "" ""
  ) ;; end command

  (setvar "highlight" oldhigh)
  (setvar "blipmode"  oldblip)

  (command ".undo" "e")

  (setvar "cmdecho" oldech)
  (princ)
) ;; end function

(princ)
