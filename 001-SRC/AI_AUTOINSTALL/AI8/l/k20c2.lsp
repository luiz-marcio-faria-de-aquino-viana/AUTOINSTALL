
;;
;; UTIL.lsp
;; Copyright (C) by Luiz Marcio Faria Viana, 12/1/91
;;

(vmon)

;; toggle(): funcao que ativa/desativa uma variavel de sistema
(defun toggle(v flg)
  (if (and flg (= (setvar v (- 1 (getvar v))) 0) )
    (prompt (strcat "\n< " (strcase v) " = OFF >" ))
    (prompt (strcat "\n< " (strcase v) " = ON >"))
  ) ; end if
  (princ)
) ; end defun

;; efstvt: funcao que retorna a entidade do primeiro vertice da polilinha
;;  enm - ename da polilinha a ser examinada
(defun efstvt(enm / ent enm1 ent1)
  (setq enm1 nil)
  (if (setq enm (entnext enm))
    (progn
      (setq ent (entget  enm))
      (if (= (cdr (assoc 0 ent)) "VERTEX") (setq ent1 ent))
    ) ; end progn
  ) ; end if
  ent1
) ; end defun

;; elstvt: funcao que retorna a entidade do ultimo vertice da polilinha
;;  enm - ename da polilinha a ser examinada
(defun elstvt(enm / ent1 ent)
  (setq ent1 nil)
  (setq enm (entnext enm))
  (while (and
           (setq enm (entnext enm))
           (= (cdr (assoc 0 (setq ent (entget enm)))) "VERTEX")
         ) ; end and
    (setq ent1 ent)
  ) ; end while
  ent1
) ; end defun

;; vtmod: funcao que retorna o modulo de um vetor
;;  vt - vetor na forma normal
(defun vtmod(vt)
  (sqrt (+ (expt (car vt) 2) (expt (cadr vt) 2) (expt (caddr vt) 2)))
) ; end setq

;; vtunit: funcao que retorna o vetor unitario de um vetor
;;  vt - vetor na forma normal
(defun vtunit(vt / d)
  (if (zerop (setq d (vtmod vt)))
     (list 0.0 0.0 0.0)
     (list (/ (car vt) d) (/ (cadr vt) d) (/ (caddr vt) d) )
  ) ; end if
) ; end defun

;; vtnorm: funcao que retorna o vetor normal a uma direcao
;;  vt - vetor que representa a direcao
(defun vtnorm(vt) (list (- (cadr vt)) (car vt) (caddr vt)))

;; vtprod: funcao que calcula o produto escalar entre dois vetores
;;  v1 - primeiro vetor
;;  v2 - segundo vetor
(defun vtprod(v1 v2) (apply '+ (mapcar '* v1 v2)) )

;; vtvet: funcao que calcula o produto vetorial entre dois vetores
;;  v1 - primeiro vetor
;;  v2 - segundo vetor
(defun vtvet(v1 v2)
  (list (- (* (cadr  v1) (caddr v2)) (* (caddr v1) (cadr  v2)) )
        (- (* (caddr v1) (car   v2)) (* (car   v1) (caddr v2)) )
        (- (* (car   v1) (cadr  v2)) (* (cadr  v1) (car   v2)) )
  ) ; end list
) ; end defun

;; vtsim(): funcao que retorna o vetor simetrico relativo a um eixo
;;  v - vetor que sera processado
;;  e - vetor que caracteriza a direcao do eixo
(defun vtsim(v e / n)
  (setq n (vtunit (vtnorm e)) )
  (mapcar '+ v (vtmul -2.0 (vtmul (vtprod v n) n)) )
) ; end defun

;; vtmul: funcao que multiplica um valor escalar por um vetor
;;  a - multiplicador escalar
;;  v - verto a ser multiplicado
(defun vtmul(a v) (apply '(lambda (x y z) (list (* a x) (* a y) (* a z)) ) v) )

;; vtang: funcao que calcula o angulo entre dois vetores no espaco
;;  v1 - primeiro vetor
;;  v2 - segundo vetor
(defun vtang(v1 v2 / m)
  (setq m (vtprod (vtunit v1) (vtunit v2)) )
  (if (= m 0.0)
    (/ pi 2.0)
    (if (< m 0.0)
      (- pi (atan (/ (sqrt (- 1.0 (expt m 2.0))) m)) )
      (atan (/ (sqrt (- 1.0 (expt m 2.0))) m))
    ) ; end if
  ) ; end if
) ; end defun

;; enttype: funcao que retorna o tipo da entidade
;;  enm - ename/entity list da entidade
(defun enttype(enm)
  (cond
    ( (= (type enm) 'ENAME) (cdr (assoc 0 (entget enm))) )
    ( (= (type enm)  'LIST) (cdr (assoc 0          enm)) )
  ) ; end cond
) ; end defun

;; segpl: funcao que retorna o comprimento de um segmento de pline
;;  vtx1 - ename do vertice inicial
(defun segpl(vtx1 / vtx2 tt ent1 ent2 d blg A R)
  (setq tt 0)
  (if (and (= (enttype vtx1) "VERTEX")
           (= (enttype (setq vtx2 (entnext vtx1))) "VERTEX") )
    (progn
      (setq
        ent1 (entget vtx1)
        ent2 (entget vtx2)
      ) ; end setq
      (setq d (distance (cdr (assoc 10 ent1)) (cdr (assoc 10 ent2)) ))
      (if (= (setq blg (cdr (assoc 42 ent1))) 0.0)
        (setq tt d)
        (setq
          A  (* 4.0 (atan blg))
          R  (/ (/ d 2.0) (sin (/ A 2.0)))
          tt (* A R)
        ) ; end setq
      ) ; end if
    ) ; end progn
  ) ; end if
) ; end defun

;; lenpl: funcao que calcula o comprimento de uma pline
;;  enm - ename da polelinha a ser processada
(defun lenpl(enm / tt d)
  (setq tt 0.0)
  (if (= (enttype enm) "POLYLINE")
    (while (= (enttype (setq enm (entnext enm))) "VERTEX")
      (if (setq d (segpl enm)) (setq tt (+ tt d)))
    ) ; end while
  ) ; end if
  tt
) ; end defun

;; midpl: funcao que retorna a posicao do meio de uma pline
;;  enm - ename da polelinha a ser processada
(defun midpl(enm)
  (if (= (enttype enm) "POLYLINE")
    (progn
      (setq
        m  (/ (lenpl enm) 2.0)
        tt 0
      ) ; end setq
      (while (and (= (enttype (setq enm (entnext enm))) "VERTEX")
                  (< (setq tt (+ tt (segpl enm))) m) )
      ) ; end while
      (setq dm (- (segpl enm) (- tt m)))
      (setq
        vtx1 (cdr (assoc 10 (entget enm)))
        vtx2 (cdr (assoc 10 (entget (entnext enm))))
      ) ; end setq
      (setq
        v1 (mapcar '- vtx2 vtx1)
        u1 (vtunit           v1)
        m1 (vtmod            v1)
      ) ; end setq
      (setq u2 (vtnorm u1))
      (if (zerop (setq blg (cdr (assoc 42 (entget enm)))) )
        (progn
          (setq
            pti (mapcar '+ vtx1 (mapcar '* u1 (list dm dm dm)))
            dir u1
          ) ; end setq
        ) ; end progn
        (progn
          (setq
            A (* 4.0 (atan blg))
            R (/ (/ m1 2.0) (sin (/ A 2.0)))
            d (- R (* (/ m1 2.0) blg))
            v (mapcar '* u2 (list d d d))
          ) ; end setq
          (setq vtx0 (mapcar '+ vtx1
                     (mapcar '+ (mapcar '/ v1 '(2.0 2.0 2.0)) v)) )
          (setq
            w  (mapcar '- vtx1 vtx0)
            wi (vtunit  w)
            wj (vtnorm wi)
          ) ; end
          (setq
            x (* R (cos (/ dm R)))
            y (* R (sin (/ dm R)))
          ) ; end setq
          (setq
            vt (mapcar '+ (mapcar '* wi (list x x x))
                          (mapcar '* wj (list y y y))) )
          (if (minusp blg)
            (setq pti (mapcar '- vtx0 vt))
            (setq pti (mapcar '+ vtx0 vt))
          ) ; end if
          (setq dir (vtnorm (vtunit vt)))
        ) ; end progn
      ) ; end if
      (list pti dir)
    ) ; end progn
  ) ; end if
) ; end defun

;; midpline: retorna o ponto medio da pline selecionada
(defun midpline(/ enm)
  (if (setq enm (car (entsel "\nSelecione a polelinha: ")))
    (if (= (enttype enm) "POLYLINE")
      (car (midpl enm))
      (prompt "\nERR: Entidade selecionada nao e uma pline")
    ) ; end if
    (prompt "\nERR: Nenhuma entidade foi selecionada")
  ) ; end if
) ; end defun

; ********
; * 45GR *
; ********

(defun 45GR(/ pt1 pt2 pt3 delt1 delt2)
  (setvar "cmdecho" 0)

  (setq
    pt1
      (getvar "LASTPOINT")
    pt2
      (getpoint pt1 "\nSelecione reta (ou polyline): ")
    pt3
      (osnap pt2 "PERP")
    delt1
      (* (- (car pt2) (car pt3)) (- (cadr pt1) (cadr pt3)))
    delt2
      (* (- (cadr pt2) (cadr pt3)) (- (car pt1) (car pt3)))
  )
  (if
    (and
      (>= delt1 0)
      (<= delt2 0)
    )
    (progn
      (list
        (+ (car pt3) (- (cadr pt1) (cadr pt3)))
        (+ (cadr pt3) (- (car pt3) (car pt1)))
      )
    )
    (progn
      (list
        (- (car pt3) (- (cadr pt1) (cadr pt3)))
        (- (cadr pt3) (- (car pt3) (car pt1)))
      )
    )
  )
);end programm


; ************
; * PARALELA *
; ************

(defun PARALELA(/ ag1 pt1 pt2 pt3 pt4 pt5 pt6)
  (setvar "cmdecho" 0)

  (setq
    pt1
      (getvar "lastpoint")
    pt2
      (getpoint "\nSelecione objeto: ")
    pt6
      (getpoint pt1 "\nMarque o comprimento: ")
    pt3
      (osnap pt2 "end")
    ag1
      (angle pt3 pt2)
  )

  (setq
    pt4
      (if (zerop (cos ag1))
        (list
          (+ (car pt2) (- (car pt2) (car pt1)))
          (cadr pt1)
        )
        (list
          (+ (car pt1) (* (cadr pt1) (/ (sin ag1) (cos ag1))))
          0.0
        )
      )
    pt5
      (inters
        pt2 pt3
        pt1 pt4
        nil
      )
    pt4
      (if (zerop (cos ag1))
        (list
          (+ (car pt2) (- (car pt2) (car pt6)))
          (cadr pt6)
        )
        (list
          (+ (car pt6) (* (cadr pt6) (/ (sin ag1) (cos ag1))))
          0.0
        )
      )
  )

  (polar pt1
    (angle pt1
      (mapcar '+ pt1
        (mapcar '-
          (inters
            pt2 pt3
            pt6 pt4
            nil
          )
          pt5
        )
      )
    )
    (distance
      pt1 pt6
    )
  )

); end program

; ********
; * RS45 *
; ********

(defun RS45(/ ag1 pt1 pt2 pt3 pt4 pt5 delt1 delt2)
  (setq
    pt1
      (getvar "lastpoint")
    pt2
      (getpoint pt1 "\nSelecione objeto (RS ou Coluna): ")
    pt3
      (osnap pt2 "CEN")
    ag1
      (angle pt3 pt2)
    pt4
      (if (zerop (cos ag1))
        (list
          (+ (car pt2) (- (car pt2) (car pt1)))
          (cadr pt1)
        )
        (list
          (+ (car pt1) (* (cadr pt1) (/ (sin ag1) (cos ag1))))
          0.0
        )
      )
    pt5
      (inters
        pt2 pt3
        pt1 pt4
        nil
      )
    delt1
      (* (- (car pt2) (car pt5)) (- (cadr pt1) (cadr pt5)))
    delt2
      (* (- (cadr pt2) (cadr pt5)) (- (car pt1) (car pt5)))
  )

  (command
    (if (and
        (>= delt1 0)
        (<= delt2 0)
      )
      (list
        (+ (car pt5) (- (cadr pt1) (cadr pt5)))
        (+ (cadr pt5) (- (car pt5) (car pt1)))
      )
      (list
        (- (car pt5) (- (cadr pt1) (cadr pt5)))
        (- (cadr pt5) (- (car pt5) (car pt1)))
      )
    )
    pt2
  )

); end program

; ********
; * RS90 *
; ********

(defun RS90(/ ag1 pt1 pt2 pt3 pt4)
  (setvar "cmdecho" 0)

  (setq
    pt1
      (getvar "lastpoint")
    pt2
      (getpoint pt1 "\nSelecione objeto (RS ou Coluna): ")
    pt3
      (osnap pt2 "CEN")
    ag1
      (angle pt3 pt2)
    pt4
      (if (zerop (cos ag1))
        (list
          (+ (car pt2) (- (car pt2) (car pt1)))
          (cadr pt1)
        )
        (list
          (+ (car pt1) (* (cadr pt1) (/ (sin ag1) (cos ag1))))
          0.0
        )
      )
  )
  (command
    (inters
      pt2 pt3
      pt1 pt4
      nil
    )
    pt2
  )

);end program

;;
;; GETFILENAME: Function to return a file name from
;; a full file name specification
;; Copyright (C) 1995 by Luiz Marcio F A Viana, 2/21/95.

(defun GETFILENAME(nm / cnt)
  (setq nm (strpiece nm 1 "."))
  (setq cnt (strlen nm))
  (while (and (> cnt 0) (/= (substr nm cnt 1) "\\") (/= (substr nm cnt 1) "/"))
     (setq cnt (- cnt 1))
  ) ; end while
  (if (zerop cnt)
    nm
    (substr nm (1+ cnt))
  ) ; end if
) ; end function

;;
;; GETDWGNAME: Function to return the current drawing name
;; Copyright (C) 1995 by Luiz Marcio F A Viana, 2/21/95.

(defun GETDWGNAME(/ nm cnt)
  (setq nm (getvar "dwgname"))
  (getfilename nm)
) ; end function

;;
;; GETDWGPATH: Function to return the current drawing path
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 1/26/96.

(defun GETDWGPATH(/ nm cnt)
  (setq nm (getvar "dwgprefix"))
  (setq cnt 1)
  (while (and (<= cnt (strlen nm)) (/= (substr nm cnt 1) "\\") (/= (substr nm cnt 1) "/") )
    (setq cnt (+ cnt 1))
  ) ; end while
  (setq nm (substr nm cnt))
  (setq cnt (strlen nm))
  (while (and (> cnt 0) (or (= (substr nm cnt 1) "\\") (= (substr nm cnt 1) "/")) )
    (setq cnt (- cnt 1))
  ) ; end while
  (substr nm 1 cnt)
) ; end defun

;;
;; GETDWGDRIVE: Function to return the current drawing drive letter
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 1/26/96.

(defun GETDWGDRIVE(/ nm cnt)
  (setq nm (getvar "dwgprefix"))
  (setq cnt 1)
  (while (and (<= cnt (strlen nm)) (/= (substr nm cnt 1) ":") )
    (setq cnt (+ cnt 1))
  ) ; end while
  (substr nm 1 cnt)
) ; end defun

;;
;; CHCHAR: Change character from a string for another
;; Copyright (C) 1995 by Luiz Marcio F A Viana, 4/4/95.

(defun CHCHAR(s c1 c2 / cnt)
  (setq cnt (strlen s))
  (while (not (zerop cnt))
    (if (= (substr s cnt 1) c1)
      (setq s (strcat (substr s 1 (- cnt 1)) c2 (substr s (+ cnt 1))))
    ) ; end if
    (setq cnt (- cnt 1))
  ) ; end while
  s
) ; end function

;;
;; LTRIM: Elimina os espacos em branco a esquerda de uma string
;;

(defun ltrim(s)
  (if (/= (substr s 1 1) " ")
    s
    (ltrim (substr s 2))
  ) ; end if
) ; end defun

;;
;; RTRIM: Elimina os espacos em branco a direita de uma string
;;

(defun rtrim(s)
  (if (= s "")
    ""
    (if (/= (substr s (strlen s) 1) " ")
      s
      (rtrim (substr s 1 (- (strlen s) 1)))
    ) ; end if
  ) ; end if
) ; end defun

(princ)

;;
;; LFILL: Preenche com n espacos a esquerda de uma string
;;

(defun lfill(s n c)
  (setq n (- n (strlen s)))
  (while (> n 0)
    (setq s (strcat c s))
    (setq n (- n 1))
  ) ; end while
  s
) ; end defun

;;
;; RFILL: Preenche com n espacos a direita de uma string
;;

(defun rfill(s n c)
  (setq n (- n (strlen s)))
  (while (> n 0)
    (setq s (strcat s c))
    (setq n (- n 1))
  ) ; end while
  s
) ; end defun

;; strpiece: tras a substring da string s contida entre a ocorrencia n-1 e n de c
;;  s - string a ser percorrida
;;  n - numero de ocorrencia de c
;;  c - caracter delimitador
(defun strpiece(s n c / i c1 p1)
  (setq
    i  1
    p1 ""
  ) ; end setq
  (while (and (> n 0) (<= i (strlen s)) )
    (setq c1 (substr s i 1) )
    (if (= c1 c)
      (progn
        (setq n  (- n 1))
        (if (> n 0) (setq p1 ""))
      ) ; end progn
      (setq p1 (strcat p1 c1))
    ) ; end if
    (setq i (+ i 1))
  ) ; end while
  (if (<= n 1) p1 "")
) ; end defun

;; strsearch: procura a primeira ocorrencia da string s1 dentro de s
;;  s1 - string que se deseja procurar
;;  s  - string que sera vasculhada a procura de s1
(defun strsearch(s1 s / i p1)
  (setq
    i  1
    p1 ""
  ) ; end setq
  (while (and (<= i (strlen s)) (/= (substr s i (strlen s1)) s1) )
    (setq i (+ i 1))
  ) ; end while
  (if (= (substr s i (strlen s1)) s1) i 0)
) ; end defun

;; acadvar: funcao ativa variavel acad retornando o valor antigo da mesma
;;  v      - variavel do autocad
;;  newval - novo valor para a variavel
(defun acadvar(v newval / oldval)
  (setq oldval (getvar v))
  (setvar v newval)
  oldval
) ; end defun

;; getuser: funcao que retorna o nome do usuario
(defun getuser(/ usr) (if (setq usr (getenv "USR")) usr "USR_UNKNOW") )

;; getcpu: funcao que retorna o identificador do equipamento
(defun getcpu(/ cpu) (if (setq cpu (getenv "MICRO")) cpu "CPU_UNKNOW") )

;; slay: funcao para mudar de layer retornando o atual
;;  lay - nome do layer que se deseja migrar
(defun slay(lay / oldlay)
  (setq oldlay (getvar "clayer"))
  (if (tblsearch "layer" lay)
    (command ".layer" "t" lay "s" lay "")
    (command ".layer" "m" lay "")
  ) ; end if
  oldlay
) ; end defun

;; strnull: funcao que retorna verdadeiro para string vazia ou com brancos
;;   s - string a ser analisada
(defun strnull(s / c fnd)
  (if (null s)
    nil
    (progn
      (setq fnd t)
      (while (and fnd (/= s ""))
        (setq c (substr s 1 1))
        (if (/= c " ") (setq fnd nil))
        (setq s (substr s 2))
      ) ; end while
      fnd
    ) ; end progn
  ) ; end if
) ; end defun

;; strhead: funcao que retorna a substring ate o caracter delimitador
;;  s - string de pesquisa
;;  c - caracter delimitador
(defun strhead(s c)
  (strpiece s 1 c)
) ; end defun

;; strtail: funcao que retorna a substring posterior ao caracter delimitdor
;;  s - string de pesquisa
;;  c - caracter delimitador
(defun strtail(s c)
  (if (> (setq n (strsearch c s)) 0)
    (substr s (+ n 1))
    ""
  ) ; end if
) ; end defun

;; strcnt: funcao que retorna o numero de ocorrencias do caracter c em s
;;  s - string a ser pesquisada
;;  c - caracter a ser contabilizado
(defun strcnt(s c / cnt pos)
  (setq pos (strlen s))
  (setq cnt          0)
  (while (> pos 0)
    (if (= (substr s pos 1) c) (setq cnt (+ cnt 1)))
    (setq pos (- pos 1))
  ) ; end while
  cnt
) ; end defun

;; additem(): funcao que adiciona um elemento em uma lista ordenada
;;  itm - elemento que sera inserido
;;  ls  - lista ordenada
(defun additem(itm ls / lr flg it itm cmp)
  (setq lr '())
  (setq flg 't)
  (while (and flg (setq it (car ls)) )
    (if (listp itm)
      (setq cmp (< (car it) (car itm)) )
      (setq cmp (< it itm))
    ) ; end if
    (if cmp
      (setq lr (append lr (list it)) )
      (setq
        lr (append lr (list itm) ls)
        flg nil
      ) ; end setq
    ) ; end if
    (setq ls (cdr ls))
  ) ; end while
  (if flg (append lr (list itm)) lr)
) ; end defun

;; sort(): funcao que ordena uma lista de elementos aplicando o metodo de insercao ordenada
;;  ls - lista de elementos a que sera ordenada
(defun sort(ls / lr it)
  (setq lr '())
  (while (setq it (car ls))
    (setq
      lr (additem it lr)
      ls (cdr ls)
    ) ; end setw
  ) ; end while
  lr
) ; end defun

;; merge(): funcao que associa duas listas ordenadas
;;  ls1 - primeira lista da associacao
;;  ls2 - segunda lista da associacao
(defun merge(ls1 ls2 / it1 it2 lr cmp)
  (setq lr '())
  (setq
    it1 (car ls1)
    it2 (car ls2)
  ) ; end setq
  (while (and ls1 ls2)
    (if (listp it1)
      (setq cmp (< (car it1) (car it2)) )
      (setq cmp (< it1 it2))
    ) ; end if
    (if cmp
      (setq
        lr (append lr (list it1))
        ls1 (cdr ls1)
        it1 (car ls1)
      ) ; end setq
      (setq
        lr (append lr (list it2))
        ls2 (cdr ls2)
        it2 (car ls2)
      ) ; end setq
    ) ; end if
  ) ; end while
  (if ls1 (append lr ls1) (append lr ls2))
) ; end defun

;; xsort(): funcao de ordenacao de lista pelo processo de particionamento dos dados
;;  ls - lista a ser ordenada
(defun xsort(ls / ls1 cnt)
  (if (> (setq cnt (length ls)) 1)
    (progn
      (setq ls1 '())
      (repeat (/ cnt 2)
        (setq
          ls1 (append ls1 (list (car ls)) )
          ls  (cdr ls)
        ) ; end setq
      ) ; end while
      (merge (xsort ls1) (xsort ls))
    ) ; end progn
    ls
  ) ; end if
) ; end defun

;; merge2(): funcao que associa duas listas ordenadas com chave dupla
;;  ls1 - primeira lista com chave dupla da associacao
;;  ls2 - segunda lista com chave dupla da associacao
(defun merge2(ls1 ls2 / it1 it2 lr)
  (setq lr '())
  (setq
    it1 (car ls1)
    it2 (car ls2)
  ) ; end setq
  (while (and ls1 ls2)
    (if (or (and (= (car it1) (car it2)) (< (cadr it1) (cadr it2)) )
            (< (car it1) (car it2)) )
      (setq
        lr (append lr (list it1))
        ls1 (cdr ls1)
        it1 (car ls1)
      ) ; end setq
      (setq
        lr (append lr (list it2))
        ls2 (cdr ls2)
        it2 (car ls2)
      ) ; end setq
    ) ; end if
  ) ; end while
  (if ls1 (append lr ls1) (append lr ls2))
) ; end defun

;; xsort2(): funcao de ordenacao de lista com chave dupla pelo processo de particionamento dos dados
;;  ls - lista a ser ordenada com chave dupla
(defun xsort2(ls / ls1 cnt)
  (if (> (setq cnt (length ls)) 1)
    (progn
      (setq ls1 '())
      (repeat (/ cnt 2)
        (setq
          ls1 (append ls1 (list (car ls)) )
          ls  (cdr ls)
        ) ; end setq
      ) ; end while
      (merge2 (xsort2 ls1) (xsort2 ls))
    ) ; end progn
    ls
  ) ; end if
) ; end defun

;; lpos: funcao que retorna a posicao do elemento na lista
;;  el - elemento a ser pesquisado
;;  ls - lista a ser pesquisada
(defun lpos(el ls / l1)
  (if (setq l1 (member el ls))
    (- (length ls) (length l1)) )
) ; end defun

(princ)
