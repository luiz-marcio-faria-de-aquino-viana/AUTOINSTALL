
;;
;;
;; K73C0.lsp
;; Copyright (C) 1997 by Fabio Henrique de Araujo
;;                       Luiz Marcio F A Viana, 02/03/97
;; 

(setq #HTALT (/ 3100 (#UND)))

;; htbcnt: funcao que retorna o ponto de conexao para as tubulacoes
;;  pt1 - ponto estatico de referencia para a conexao
;;  enm - ename da entidade de referencia (linha ou vertice de polilinha)
(defun htbcnt(pt1 enm / vt1 vt2 v1 v2 v3 m3 u1)
  (if (= (enttype enm) "LINE")
    (setq
      vt1 (cdr (assoc 10 (entget enm)))
      vt2 (cdr (assoc 11 (entget enm)))
    ) ; end setq
    (setq
      vt1 (cdr (assoc 10 (entget enm)))
      vt2 (cdr (assoc 10 (entget (entnext enm))))
    ) ; end setq
  ) ; end if
  (setq
    v1 (mapcar '- vt2 vt1)
    v2 (mapcar '- pt1 vt1)
  ) ; end setq
  (setq u1 (vtunit v1))
  (setq
    m3 (vtprod u1 v2)
    v3 (list (* (car u1) m3) (* (cadr u1) m3) (* (caddr u1) m3))
  ) ; end setq
  (mapcar '+ vt1 v3)
) ; end defun

;; htbdwg: funcao auxiliar no desenho da tubulacao
;;  pt1 - primeiro ponto da tubulacao
;;  pt2 - segundo ponto da tubulcao
(defun htbdwg(pt1 pt2 / pti ptf)
  (if (and (/= (caddr pt2) 0.0) (/= (caddr pt2) (caddr pt1)) )
    (setq #HTALT (caddr pt2))
  ) ; end if

  (setq
    pti (list (car pt1) (cadr pt1) #HTALT)
    ptf (list (car pt2) (cadr pt2) #HTALT)
  ) ; end setq

  (if (/= (caddr pt1) #HTALT)
    (command pt1 pti)
  ) ; end if
  (command pti ptf)
  (list pti ptf)
) ; end defun

;; htb90: funcao que retorna um ponto que permite uma conexao de 90d
;;  pt1 - primeiro ponto (direcao de caminhamento)
;;  pt2 - segundo ponto (direcao de caminhamento)
;;  pt3 - terceiro ponto (ponto de conexao)
(defun htb90(pt1 pt2 pt3 / v1 v2 v3 u1)
  (setq
    v1 (mapcar '- pt2 pt1)
    v2 (mapcar '- pt3 pt2)
  ) ; end setq
  (setq u1 (vtunit v1))
  (setq
    m3 (vtprod u1 v2)
    v3 (list (* (car u1) m3) (* (cadr u1) m3) (* (caddr u1) m3) )
  ) ; end setq
  (mapcar '+ pt2 v3)
) ; end defun

;; htb45: funcao que retorna um ponto que permite uma conexao de 45d
;;  pt1 - primeiro ponto (direcao de caminhamento)
;;  pt2 - segundo ponto (direcao de caminhamento)
;;  pt3 - terceiro ponto (ponto de conexao)
(defun htb45(pt1 pt2 pt3)
  (setq pt4 (htb90 pt1 pt2 pt3))
  (setq
    v1 (mapcar '- pt2 pt1)
    w1 (mapcar '- pt4 pt2)
  ) ; end setq
  (setq u1 (vtunit v1))
  (setq
    d  (distance pt3 pt4)
    w3 (mapcar '* u1 (list d d d))
  ) ; end setq
  (setq w4 (mapcar '- w1 w3))
  (mapcar '+ pt2 w4)
) ; end defun

;; c:htub: rotina para desenho da tubulacao hidraulica
(defun c:htub(/ oldech pt1 pt2 pt3 h ss enm flg flg1)
  (m:savevars)

  ;;
  ;; obtem primeiro ponto, modifica altura ou conecta tubulacao
  ;;
  (while (= (progn
              (initget 1 "Conectar Altura")
              (setq pt1 (getpoint (strcat "\n<Primeiro ponto>/(C)onectar/(A)ltura (h=" (rtos #HTALT 2 2) "): ")) )
            ) ; end progn
            "Altura"
         ) ; end eq
    (setq h (getdist (strcat "\nAltura em relacao ao piso (h=" (rtos #HTALT 2 2) "): ")) )
    (if h (setq #HTALT h))
  ) ; end while
  
  ;;
  ;;  resolve opcao de conexao do primeiro ponto
  ;;
  (if (= pt1 "Conectar")
    (progn
      ;;
      ;; obtem objeto a conectar
      ;;
      (setq flg1 t)
      (while flg1
        (setq ss (nentsel "\nSelecione objeto a conectar: "))
        (setq enm (car ss))
        (if (setq flg1 (and (/= (enttype enm) "VERTEX") (/= (enttype enm) "LINE")) )
          (prompt "\nERR: Entrada invalida, selecione linha ou polilinha.")
        ) ; end if
      ) ; end while
      ;;
      ;; obtem ponto de referencia para conexao
      ;;
      (while (= (progn
                  (initget "Altura")
                  (setq pt2 (getpoint (strcat "\n<Ponto de referencia>/(A)ltura (h=" (rtos #HTALT 2 2) "): ")) )
                ) ; end progn
                "Altura"
             ) ; end eq
        (setq h (getdist (strcat "\nAltura em relacao ao piso (h=" (rtos #HTALT 2 2) "): ")) )
        (if h (setq #HTALT h))
      ) ; end while
      ;;
      ;; calcula o ponto chave da conexao
      ;;
      (setq pt1 (htbcnt pt2 enm))
      (command ".line" pt1)
      (setq pt1 (htbdwg pt1 pt2))
    ) ; end progn
    (progn
      ;;
      ;; insere primeiro ponto da tubulacao
      ;;
      (if (/= (caddr pt1) 0.0)
        (setq #HTALT (caddr pt1))
      ) ; end if
      (setq pt1 (list (car pt1) (cadr pt1) #HTALT))
      (command ".line" pt1)
      (setq
        pt2 pt1
        pt1 nil
      ) ; end setq
    ) ; end progn
  ) ; end if

  ;;
  ;; obtem os pontos seguintes da tubulacao
  ;;
  (setq flg t)
  (while flg
    (while (= (if pt1
                (progn
                  (initget "Conectar 90d 45d Altura")
                  (setq pt3 (getpoint pt2 (strcat "\n<Proximo ponto>/(C)onectar/90d/45d/(A)ltura (h=" (rtos #HTALT 2 2) "): ")) )
                ) ; end progn
                (progn
                  (initget "Conectar Altura")
                  (setq pt3 (getpoint pt2 (strcat "\n<Proximo ponto>/(C)onectar/(A)ltura (h=" (rtos #HTALT 2 2) "): ")) )
                ) ; end progn
              ) ; end if
              "Altura"
           ) ; end eq
      (setq h (getdist (strcat "\nAltura em relacao ao piso (h=" (rtos #HTALT 2 2) "): ")) )
      (if h (setq #HTALT h))
    ) ; end while

    (if pt3
      (progn
        ;;
        ;; resolve opcao conectar
        ;;
        (if (= pt3 "Conectar")
          (progn
            (setq flg1 t)
            (while flg1
              (setq ss (nentsel "\nSelecione objeto a conectar: "))
              (setq enm (car ss))
              (if (setq flg1 (and (/= (enttype enm) "VERTEX") (/= (enttype enm) "LINE")) )
                (prompt "\nERR: Entrada invalida, selecione linha ou polilinha.")
              ) ; end if
            ) ; end while
            (setq pt3 (htbcnt pt2 enm))
          ) ; end progn
        ) ; end if
        ;;
        ;; resolve opcoes 45d e 90d
        ;;
        (if (or (= pt3 "90d") (= pt3 "45d"))
          (progn
            (initget 1)
            (setq pt (getpoint pt2 "\nProximo ponto: "))
            (cond
              ( (= pt3 "90d") (setq pti (htb90 pt1 pt2 pt)) )
              ( (= pt3 "45d") (setq pti (htb45 pt1 pt2 pt)) )
            ) ; end cond
            (setq ls (htbdwg pt2 pti))
            (setq
              pt1 (car  ls)
              pt2 (cadr ls)
              pt3 pt
            ) ; end setq
          ) ; end progn
        ) ; end if
        ;;
        ;; desenha representacao da tubulacao
        ;;
        (setq ls (htbdwg pt2 pt3))
        (setq
          pt1 (car  ls)
          pt2 (cadr ls)
        ) ; end setq
      ) ; end progn
      (setq flg nil)
    ) ; end if
  ) ; end while
  (command "")

  (m:restorevars)
  (princ)
) ; end defun

(princ)
