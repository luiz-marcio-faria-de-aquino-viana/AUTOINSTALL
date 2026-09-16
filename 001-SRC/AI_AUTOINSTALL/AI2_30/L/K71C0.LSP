
;;
;; K71C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana
;;                       Paulo Lincoln de Oliveira, 11/1/96
;;

;;
;; breakins: rotina para insercao de blocos com quebra da tubulacao
;;
(defun c:brkins( / BLKTAB nblk pti ang ff tipo dist)
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

  (if (setq ss (nentsel "\nPonto de insercao: "))
    (setq pti (cadr ss))
    (setq pti (cadr (grread t)))
  ) ; end if

  (setq ang (getangle pti "\nRotacao <0>: "))
  (if (null ang)  (setq ang 0.0))

  (if (and ss (= (caddr ss) nil))
    (if (or (= (enttype (car ss)) "LINE") (= (enttype (car ss)) "VERTEX"))
      (progn
        (setq ff (strcase (getfilename #BLCK)))
        (setq
          tipo (caddr (assoc ff BLKTAB))
          dist (/ (cadr (assoc ff BLKTAB)) #UND)
        ) ; end setq
        (setq ent (entget (car ss)))
        (if (= (enttype (car ss)) "LINE")
          (progn
            (setq p1 (cdr (assoc 10 ent)))
            (setq p2 (cdr (assoc 11 ent)))
          ) ; end progn
          (progn
            (setq p1 (cdr (assoc 10 ent)) )
            (setq p2 (cdr (assoc 10 (entget (entnext (car ss))) )) )
          ) ; end progn
        ) ; end if
        (setq d (distance p1 p2))
        (if (and (< (distance p1 pti) d) (< (distance p2 pti) d))
          (cond
            ( (= tipo 1)
              (progn
                (setq dir (* (/ (angle p1 p2) pi) 180))
                (brkln pti dir dist nil)
            ) ) ; end progn, case
            ( (= tipo 2)
              (progn
                (setq dir (* (/ ang pi) 180))
                (brkln pti dir dist   t)
            ) ) ; end progn, case
          ) ;end cond
        ) ; end if
      ) ; end progn
    ) ; end if
  ) ; end if

  (command ".insert" (v:aid #BLCK) "s" (/ 1.0 #UND) pti (* (/ ang pi) 180))
  (princ)
); end defun

;; brkln: efetua quebra da linha dado ponto inicial, tamanho e direcao
;;  p1  - ponto base e inicial da quebra
;;  ang - angulo da linha a ser quebrada
;;  d   - tamanho da quebra da linha
;;  flg - flag indicador do tipo de quebra (t=dist, nil=dist/2)
(defun brkln(p1 ang d flg)
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
