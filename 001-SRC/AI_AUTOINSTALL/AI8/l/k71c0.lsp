
;;
;; K71C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana
;;                       Paulo Lincoln de Oliveira, 11/1/96
;;

;;
;; breakins: rotina para insercao de blocos com quebra da tubulacao
;;
(defun c:brkins( / BLKTAB nblk pti ang ff tipo dist)
  (m:savevars)

  (setq BLKTAB '( ("ES02C00" 600.0 2) ("ES04C00" 150.0 2) ("ES05C00" 600.0 1) 
                  ("ES06C00" 400.0 2) ("ES07C00" 600.0 2) ("ES09C00" 600.0 2)
                  ("ES0AC00" 600.0 2) ("ES0CC00" 600.0 2) ("ES0DC00" 600.0 2)
                  ("ES0EC00" 150.0 1) ("ES0FC00" 150.0 1) ("ES10C00" 150.0 2)
                  ("ES11C00" 150.0 2) ("ES13C00"  50.0 1) )  
  ) ; end setq 

  (if #BLCK
    (setq nblk (getstring (strcat "\nNome do bloco <" #BLCK ">: ") ) )
    (while (= (setq nblk (getstring "\nNome do bloco: ")) "")
      (prompt "\nERR:Entrada nula nao valida.")
    ) ; end while
  ); end if
  (if (/= nblk "") (setq #BLCK nblk))

  (setq ff (strcase (getfilename #BLCK)))

  (initget 1)
  (setq pti (getpoint "\nPonto de insercao: "))

  (setq ang (getangle pti "\nRotacao <0>: "))
  (if (null ang)  (setq ang 0.0))

  (if (setq ss (nentselp pti))
    (if (or (= (enttype (car ss)) "LINE") (= (enttype (car ss)) "VERTEX"))
      (progn
        (setq
          tipo (caddr (assoc ff BLKTAB))
          dist (/ (cadr (assoc ff BLKTAB)) (#UND))
        ) ; end setq
        (setq ent (entget (car ss)))
        (if (= (enttype (car ss)) "LINE")
          (setq
            p1 (cdr (assoc 10 ent))
            p2 (cdr (assoc 11 ent))
          ) ; end setq
          (setq
            p1 (cdr (assoc 10 ent))
            p2 (cdr (assoc 10 (entget (entnext (car ss)))))
          ) ; end setq
        ) ; end if
        (setq d (distance p1 p2))
        (if (and (< (distance p1 pti) d) (< (distance p2 pti) d))
          (cond
            ( (= tipo 1)
              (progn
                (setq dir (* (/ (angle p1 p2) pi) 180))
                (brkln (car ss) pti dir dist nil)
            ) ) ; end progn, case
            ( (= tipo 2)
              (progn
                (setq dir (* (/ ang pi) 180))
                (brkln (car ss) pti dir dist   t)
            ) ) ; end progn, case
          ) ;end cond
        ) ; end if
      ) ; end progn
    ) ; end if
  ) ; end if

  (if (tblsearch "block" ff)
    (command ".insert" ff "s" (/ 1.0 (#UND)) pti (* (/ ang pi) 180))
    (command ".insert" (v:aid #BLCK) "s" (/ 1.0 (#UND)) pti (* (/ ang pi) 180))
  ) ; end if

  (m:restorevars)
  (princ)
); end defun

;; brkln: efetua quebra da linha dado ponto inicial, tamanho e direcao
;;  enm - ename da linha a ser quebrada
;;  p1  - ponto base e inicial da quebra
;;  ang - angulo da linha a ser quebrada
;;  d   - tamanho da quebra da linha
;;  flg - flag indicador do tipo de quebra (nil=1/2 * dist, 't=dist)
(defun brkln(enm p1 ang d flg)
  (setvar "cmdecho" 0)
  (command
    ".ucs" "d" "$BRKLN"
    ".ucs" "s" "$BRKLN"
  ) ; end command
  (command
    ".ucs" "or" p1
    ".ucs" "z"  ang
  ) ; end command
  (prompt "\nBRKLN::PASSOU(1)")
  (if flg
    (command ".break" enm "0,0" (list (- d) 0))
    (command ".break" enm (list (- (/ d 2.0)) 0) (list (/ d 2.0) 0))
  ) ; end if
  (command ".ucs" "r" "$BRKLN")
  (princ)
); end defun

(princ)
