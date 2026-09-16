
;;
;; K79C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 3/14/97
;;
;; Descricao: Rotina para criar detalhes em 1/25 da planta baixa
;;

;; dettrim: funcao para cortar as linhas que excedem a area delimitada
;;  ss1 - conjunto de selecao a ser analisado
;;  ss2 - elemento delimitador
;;  pci - vertice inferior esquerdo da area delimitadora
;;  pcf - vertice superior direito da area delimitadora
(defun dettrim(ss1 ss2 pci pcf / ls n cnt enm ent v1 v2 oldpck)
  (setq oldpck (acadvar "pickbox" 1))
  (command ".trim" ss2 "")
  (setq
    n (sslength ss1)
    cnt 0
  ) ; end setq
  (while (< cnt n)
    (if (or (= (enttype (setq enm (ssname ss1 cnt)))     "LINE")
            (= (enttype enm)                         "POLYLINE") )
      (cond 
        ( (= (enttype enm) "LINE")
          (progn
            ;;
            ;; elimina os vertices externos a area delimitadora
            ;;
            (setq ent (entget enm))
            (setq
              v1 (cdr (assoc 10 ent))
              v2 (cdr (assoc 11 ent))
            ) ;; end setq
            (if (or (< (car  v1) (car  pci)) (> (car  v1) (car  pcf))
                    (< (cadr v1) (cadr pci)) (> (cadr v1) (cadr pcf)) )
                (command v1)
            ) ;; end if
            (if (or (< (car  v2) (car  pci)) (> (car  v2) (car  pcf))
                    (< (cadr v2) (cadr pci)) (> (cadr v2) (cadr pcf)) )
                (command v2)
            ) ;; end if
        ) ) ;; end progn,case
        ( (= (enttype enm) "POLYLINE")
          (progn
            ;;
            ;; Algoritimo para a pline
            ;;
            (setq ls '())
            (while (= (enttype (setq enm (entnext enm))) "VERTEX")
              (setq ls (cons (cdr (assoc 10 (entget enm))) ls))
            ) ;; end while
            (foreach v1 ls
              (if (or (< (car  v1) (car  pci)) (> (car  v1) (car  pcf))
                      (< (cadr v1) (cadr pci)) (> (cadr v1) (cadr pcf)) )
                  (command v1)
              ) ;; end if
            ) ;; end foreach
        ) ) ;; end progn , case  
      ) ;; end cond
    ) ;; end if
    (setq cnt (1+ cnt))
  ) ;; end while
  (command "")
  (setvar "pickbox" oldpck)          
) ;; end defun

;; c:detblk: rotina que cria detalhes em 1/25 da planta baixa
(defun c:detblk(/ oldech oldhigh oldblip oldlay pci pcf pta ptb
  pt1 pt2 pt3 pt4 ss s1 s2 s3)
  (m:savevars)

;;  (command ".undo" "m")



  (prompt "\nSelecione a regiao do detalhe...")
  (setq pci  (getpoint "\nPrimeiro canto: "))
  (setq pcf  (getcorner pci "\nSegundo canto: "))

  (setq pta (list (min (car pci) (car pcf)) (min (cadr pci) (cadr pcf))) )
  (setq ptb (list (max (car pci) (car pcf)) (max (cadr pci) (cadr pcf))) )

  (setq pt1 (getpoint pta "\nPonto de insercao: "))


  (setq pt2 (mapcar '+ pt1 (mapcar '- ptb pta)) )
  (setq pt3 (list (car pt1) (cadr pt2)) )
  (setq pt4 (list (car pt2) (cadr pt1)) )


    
  (setq oldhigh (acadvar "highlight" 0))


  (setq oldblip (acadvar "blipmode"  0))




  (command ".copy" "c" pci pcf "" pta pt1 "")



  (setq ss (ssget "c" pt1 pt2))



  (setq oldlay (slay "H-DETALHE"))



  (command
    ".line" pt1 pt3 ""
    ".select" "l" ""
    ".line" pt3 pt2 ""
    ".select" "p" "l" ""
    ".line" pt2 pt4 ""
    ".select" "p" "l" ""
    ".line" pt4 pt1 ""
    ".select" "p" "l" ""
  ) ;; end command




  (slay oldlay)




  (dettrim ss (ssget "p") pt1 pt2)

  (setvar "highlight" oldhigh)
  (setvar "blipmode"  oldblip)

;;  (command ".undo" "e")

  (m:restorevars)
  (princ)
) ;; end function

(princ)
