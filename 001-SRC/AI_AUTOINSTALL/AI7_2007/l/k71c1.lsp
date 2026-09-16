
;;
;; K71C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 11/1/96
;;

;; c:brkins(): rotina para insercao de blocos com quebra da tubulacao
(defun c:brkins()

  (setq TAB '( ("ES02C00" 600.0 2)
               ("ES04C00" 150.0 2)
               ("ES05C00" 600.0 1) 
               ("ES06C00" 400.0 2)
               ("ES07C00" 600.0 2)
               ("ES09C00" 600.0 2)
               ("ES0AC00" 600.0 2)
               ("ES0CC00" 600.0 2)
               ("ES0DC00" 600.0 2)
               ("ES0EC00" 150.0 1)
               ("ES0FC00" 150.0 1)
               ("ES10C00" 150.0 2)
               ("ES11C00" 150.0 2)
               ("ES13C00"  50.0 1) )
  ) ; end setq 

  (if #BLCK
    (setq blck (getstring (strcat "\nNome do bloco <" #BLCK ">: ") ) )
    (while (= (setq blck (getstring "\nNome do bloco: ")) "")
      (prompt "\nERR: Entrada nula nao valida.") )
  ) ; end if
  (if (/= blck "") (setq #BLCK blck))

  (setq blk (getfilename #BLCK))

  (setq itm (assoc blk TAB))
  (setq
    wth (cadr  itm)
    tip (caddr itm)
  ) ; end setq

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (setq rot (getangle pti "\nRotacao <0>: "))
  (if (null rot) (setq rot 0.0))

  (setq ptf (

  (if (setq ss (nentselp pti))
    (brkins_brkln pti wth tip enm pt1 pt2)
  ) ; end if

  (if (tblsearch "block" (getfilename #BLCK))
    (command ".insert" (getfilename #BLCK) "s" (/ 1.0 (#UND)) pti rot)
    (command ".insert" (V:AID #BLCK) "s" (/ 1.0 (#UND)) pti rot)
  ) ; end if

  (princ)
); end defun

;; brkins_brkln(): funcao que corta uma linha ou polilinha para inserir um objeto
;; enm - ename da linha ou polilinha a ser cortada
;; pti - ponto inicial da linha
;; ptf - ponto final da linha
;; wth - largura do corte
;; tip - tipo de corte (1=
(defun brkln()
  (setvar "cmdecho" 0)
  (command
    ".ucs" "d" "$BRKLN"
    ".ucs" "s" "$BRKLN"
  ) ; end command
  (command
    ".ucs" "or" p1
    ".ucs" "z"  ang
  ) ; end command
  (if flg
    (command ".break" "0,0" (list (- d) 0))
    (command ".break" "0,0" "f" (list (- (/ d 2.0)) 0) (list (/ d 2.0) 0))
  ) ; end if
  (command ".ucs" "r" "$BRKLN")
  (princ)
); end defun

(princ)
