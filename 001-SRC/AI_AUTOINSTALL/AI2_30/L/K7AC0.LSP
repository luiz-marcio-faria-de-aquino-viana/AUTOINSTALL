
;;
;; K7AC0.lsp
;; Copyright (C) 1997 By Luiz Marcio F A Viana
;;                       Fabio Henrique de Araujo, 03/25/97
;;

;; c:cd: lista contendo os tamanhos e os blocos associados
(defun c:cd( / diam lsblk )
  (setq oldech (acadvar "cmdecho" 0))

  ;; lista de diametros e nomes de blocos associados
  (setq
    LSBLK '(("50"  "ESG/ESG000C0") ("75"  "ESG/ESG001C0")
            ("100" "ESG/ESG002C0") ("150" "ESG/ESG003C0") )
  ) ; end setq

  (initget 1 "50 75 100 150")
  (setq diam (getkword "\nDiametro da coluna (50,75,100 ou 150): "))

  (command ".insert" (v:aid (cadr (assoc diam LSBLK))) "s" (/ 1 #UND))

  (setvar "cmdecho" oldech)
  (princ)
) ;; end function

;; ftd: funcao que retorna o centro da coluna tangente a reta
;;  pti - ponto inicial da reta
;;  ptf - ponto final da reta
;;  pta - ponto de apoio da coluna
;;  ptl - sentido de insercao da coluna
;;  r   - raio da coluna
(defun ftd(pti ptf pta ptl r / v1 v2 u1 v3 v4 u4)
  (setq
    v1 (mapcar '- ptf pti)
    v2 (mapcar '- ptl pti)
  ) ;; end setq
  (setq u1 (vtunit v1))
  (setq 
    v3 (vtmul (vtprod v2 u1) u1)
    v4 (mapcar '- v2 v3)
  ) ;; end setq
  (setq u4 (vtunit v4))
  (mapcar '+ pta (vtmul r u4))
) ;; end defun

;; tdl : funcao que busca o ponto inicial e final de uma linha
;;  enm - ename da linha selecionada
(defun tdl(enm pta ptl r /  pti ptf )
 (setq pti (cdr (assoc 10 (entget enm))))
 (setq ptf (cdr (assoc 11 (entget enm))))
 (ftd pti ptf pta ptl r)
) ;; end defun

;; tdp: funcao que busca os vertices inicial e final de um segmento de polilinha
;;  enm - ename da polilinha selecionada
(defun tdp(enm pta ptl r / pti ptf) 
 (setq pti (cdr (assoc 10 (entget enm ))))
 (setq ptf (cdr (assoc 10 (entget (entnext enm)))))
 (ftd pti ptf pta ptl r)
) ;; end defun

;; c:ctd: rotina para insercao de uma coluna tangente a uma linha ou polilinha
(defun c:ctd(/ oldech oldap LSBLK ss r enm pti ptf pta )
  (setq oldech (acadvar "cmdecho" 0))

  ;; lista de diametros e nomes de blocos associados
  (setq
    LSBLK '(("50"  "ESG/ESG000C0") ("75"  "ESG/ESG001C0")
            ("100" "ESG/ESG002C0") ("150" "ESG/ESG003C0") )
    FT    (/ 1.0 #UND)
  ) ; end setq

  (initget 1 "50 75 100 150")
  (setq dn (getkword "\nDiametro da coluna(50 75 100 150): "))
  (setq r (* (/ (atof dn) 2.0) FT) )

  (setq blk ( (cadr (assoc dn LSBLK)))

  (setq ss (nentsel "\nSelecione a linha: "))

  (setq
    enm (car ss)
    typ (enttype enm)
  ) ; end setq

  (if (or (= typ "LINE") (= typ "VERTEX"))
    (progn
      (initget 1)
      (setq ptl (getpoint"\nDetermine o lado: "))

      (setq oldap (acadvar "aperture" (getvar "pickbox")))
      (setq pta (osnap (cadr ss) "near"))
      (setvar "aperture" oldap)

      (if (= typ "LINE") 
        (command ".insert" blk (tdl enm pta ptl r) FT "" 0)
        (command ".insert" blk (tdp enm pta ptl r) FT "" 0)
      ) ; end if
    ) ;; end progn
    (prompt "\nERR: Entidade selecionada precisa ser linha ou polilinha.")
  ) ;; end if

  (setvar "cmdecho" oldech)
) ;; end defun

;; fttd: funcao que retorna o centro da coluna tangente a reta
;;  pt1 - ponto de selecao da primeira reta
;;  pt2 - ponto de selecao da segunda reta
;;  pto - ponto de intersecao das retas
;;  r   - raio da coluna
(defun fttd(pt1 pt2 p0 r / p1 p2 v1 v2 v3 v4 n1 n2 u1 u2 an tg)
  (setq
    v1 (mapcar '- pt1 p0)
    v2 (mapcar '- pt2 p0)
  ) ;; end setq

  (setq an (/ (vtang v1 v2) 2.0) )

  (setq
    u1 (vtunit v1)
    u2 (vtunit v2)
  ) ; end setq

  (setq tg (abs (/ (sin an) (cos an))))

  (setq
    v3 (vtmul (/ r tg) u1)
    v4 (vtmul (/ r tg) u2)
  ) ; end setq

  (setq
    n1 (vtnorm u1)
    n2 (vtnorm u2)
  ) ; end setq

  (setq p1 (mapcar '+ p0 v3))
  (setq p2 (mapcar '+ p0 v4))
  (setq t1 (mapcar '+ p1 n1))
  (setq t2 (mapcar '+ p2 n2))

  (setq ptc (inters p1 t1 p2 t2 nil))
  (if (null ptc)
    (mapcar '+ p0 (vtmul r n1))
    ptc
  ) ; end if
) ;; end defun

;; ttdl: retorna os pontos inicial e final de uma linha
;;  enm - ename da linha a ser processada
(defun ttdl( enm / pti ptf )
 (setq pti (cdr (assoc 10 (entget enm))))
 (setq ptf (cdr (assoc 11 (entget enm))))
 (list pti ptf)
) ;; end defun

;; ttdp: retorna os vertex anterior e posterior de um segmento de polilinha
;;  enm - ename do vertex da polilinha a ser processada
(defun ttdp ( enm / pti ptf )
 (setq pti (cdr (assoc 10 (entget enm))))
 (setq ptf (cdr (assoc 10 (entget (entnext enm)))))
 (list pti ptf)
) ;; end defun

;; c:cttd : rotina para desenhar colunas tangentes a linhas ou polilinhas
(defun c:cttd(/ oldeco oldapp  LSBLK dn r ss1 ss2 enm1 enm2 ent1 ent2 ls1 ls2 pt0  pt1 pt2)
  (setq oldeco (acadvar "cmdecho" 0))
  (setq 
    LSBLK '(("50"  "ESG000C0") ("75"  "ESG010C0")
            ("100" "ESG020C0") ("150" "ESG030C0") )
    FT  ( / 1.0 #UND)
  ) ;; end setq
 
  (initget 1 "50 75 100 150")
  (setq dn  (getkword "\nDiametro da coluna(50 75 100 150): "))
  (setq r ( * ( / (atof dn) 2.0) FT))

  (setq blk (cadr (assoc dn LSBLK)))
  (setq ss1(nentsel "\nSelecione a primeira reta: "))
  (setq ss2 (nentsel "\nSelecione a segunda reta: "))

  (setq
    enm1 (car ss1)
    enm2 (car ss2)
  ) ; end setq

  (setq
    typ1 (enttype enm1)
    typ2 (enttype enm2)
  ) ; end setq

  (if (and (or (= typ1 "LINE") (= typ1 "VERTEX"))
           (or (= typ2 "LINE") (= typ2 "VERTEX")) )
    (progn
      (if (= ent1 "LINE")
        (setq ls1 (ttdl enm1))
        (setq ls1 (ttdp enm1))
      ) ; end if
      (if (= ent2 "LINE")
        (setq ls2 (ttdl enm2))
        (setq ls2 (ttdp enm2))
      ) ;; end if

      (setq oldap (acadvar "aperture" (getvar "pickbox")))
      (setq pt1 (osnap (cadr ss1) "near"))
      (setq pt2 (osnap (cadr ss2) "near"))
      (setvar "aperture" oldap)

      (setq pt0 (inters (car ls1) (cadr ls1) (car ls2) (cadr ls2) nil))
      (if ( = pt0 nil)
          (command ".insert" blk (ftd (car ls1) (cadr ls2) pt1 pt2 r) FT "" 0)
          (command ".insert" blk (fttd pt1 pt2 pt0 r) FT "" 0)
      ) ;; end if
    ) ;; end progn
    (prompt "\nERR:Selecao de entidades invalidas")
  ) ;; end if

  (setvar "cmdecho" oldeco)
  (princ)
) ;; end defun

(princ)
