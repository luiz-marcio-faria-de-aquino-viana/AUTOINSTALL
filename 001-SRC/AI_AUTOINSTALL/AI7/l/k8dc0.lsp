
;;
;; K8DC0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 5/27/98
;;

;; definicao das variaveis globais
(setq
  #TBTEXT_ALG "Direita"
  #TBTEXT_HGT (* 2.0 (#SCL))
  #TBTEXT_DTX (* 2.0 (#SCL))
  #TBTEXT_DTY (* 1.0 (#SCL))
) ; end setq

;; tbtext_ugetcel(): funcao que retorna uma lista de selecao de objetos e o ponto base de duas celulas escolhidas
;;  msg - mensagem informativa apresentada ao usuario
(defun tbtext_ugetcel(msg / ss flg pt1 pt2 xp1 xp2 yp1 yp2)
  (prompt msg)
  (if (setq ss (ssget))
    (progn
      (setq flg 't)
      (while flg
        (initget 1)
        (setq pt1 (getpoint "\nSelecione a celula base: "))
        (if (and (and (>= (car  pt1) xpmin) (<= (car  pt1) xpmax))
                 (and (>= (cadr pt1) ypmin) (<= (cadr pt1) ypmax)) )
          (setq flg nil)
          (prompt "\nERR: Nenhuma celula da tabela selecionada.")
        ) ; end if
      ) ; end while

      (setq flg 't)
      (while flg
        (initget 1)
        (setq pt2 (getpoint "\nSelecione a celula destino: "))
        (if (and (and (>= (car  pt2) xpmin) (<= (car  pt2) xpmax))
                 (and (>= (cadr pt2) ypmin) (<= (cadr pt2) ypmax)) )
          (setq flg nil)
          (prompt "\nERR: Nenhuma celula da tabela selecionada.")
        ) ; end if
      ) ; end while

      (setq
        xp1 (+ xpmin (* (fix (/ (- (car  pt1) xpmin) dx)) dx) )
        yp1 (+ ypmin (* (fix (/ (- (cadr pt1) ypmin) dy)) dy) )
      ) ; end setq
      (setq
        xp2 (+ xpmin (* (fix (/ (- (car  pt2) xpmin) dx)) dx) )
        yp2 (+ ypmin (* (fix (/ (- (cadr pt2) ypmin) dy)) dy) )
      ) ; end setq

      (list ss (list xp1 yp1) (list xp2 yp2))
    ) ; end progn
  ) ; end if
) ; end defun

;; c:tbtext(): rotina para insercao de textos em tabelas
(defun c:tbtext(/ oldecho pta ptb pt0 dx dy xpmin ypmin xpmax ypmax xn yn flg
  xpi ypi opt alg hgt dty dtx flg1 xp0 yp0 xp1 yp1 enm ss pt1 pt2 txt)

  (setq oldecho (acadvar "cmdecho" 0))
  (setvar "osmode" (logior (getvar "osmode") 32))

  (initget 1)
  (setq pta (getpoint "\nMarque um canto da tabela: "))

  (initget 1)
  (setq ptb (getcorner pta "\nMarque o outro canto da tabela: "))

  (initget 1 "Dimensoes")
  (setq pt0 (getcorner pta "\nDimensoes/<Incremento da celula>: "))

  (if (= pt0 "Dimensoes")
    (progn
      (initget 7)
      (setq dx (getdist "\nLargura da celula: "))
      (initget 7)
      (setq dy (getdist "\nAltura da celula: "))
    ) ; end progn
    (progn
      (setq
        dx (abs (- (car  pt0) (car  pta)) )
        dy (abs (- (cadr pt0) (cadr pta)) )
      ) ; end setq
    ) ; end progn
  ) ; end if

  (setvar "osmode" 0)

  (setq
    xpmin (min (car  pta) (car  ptb))
    ypmin (min (cadr pta) (cadr ptb))
  ) ; end setq
  (setq
    xpmax (max (car  pta) (car  ptb))
    ypmax (max (cadr pta) (cadr ptb))
  ) ; end setq

  (setq
    xn (fix (/ (- xpmax xpmin) dx))
    yn (fix (/ (- ypmax ypmin) dy))
  ) ; end setq

  (setq flg 't)

  (setq
    xpi xpmin
    ypi (- ypmax dy)
  ) ; end setq

  (while flg
    (setq oldmnu (ai_svar "promptmenu" 1))
    (initget "ALInhamento ALTura CElula APagar COpiar Mover Sair Texto")
    (setq opt (getkword "\nALInhamento/ALTura/CElula/APagar/COpiar/Mover/Sair/<Texto>: "))
    (setvar "promptmenu" oldmnu)

    (cond
      ( (= opt "ALInhamento")
        (progn
          (setq oldmnu (ai_svar "promptmenu" 1))
          (initget "Direita Centro Esquerda")
          (setq alg (getkword (strcat "\nAlinhamento pela Direita, Centro ou Esquerda <" #TBTEXT_ALG ">: ")) )
          (setvar "promptmenu" oldmnu)
          (if alg (setq #TBTEXT_ALG alg))
        ) ; end progn
      ) ; end case
      ( (= opt "ALTura")
        (progn
          (setq hgt (getdist (strcat "\nAltura do texto <" (rtos #TBTEXT_HGT 2 0) ">: ")) )
          (if hgt (setq #TBTEXT_HGT hgt))
          (setq dty (getdist (strcat "\nDistancia para a linha da base da celula <" (rtos #TBTEXT_DTY 2 0) ">: ")) )
          (if dty (setq #TBTEXT_DTY dty))
          (setq dtx (getdist (strcat "\nDistancia para a linha lateral da celula <" (rtos #TBTEXT_DTX 2 0) ">: ")) )
          (if dtx (setq #TBTEXT_DTX dtx))
        ) ; end progn
      ) ; end case
      ( (= opt "CElula")
        (progn
          (setq flg1 't)
          (while flg1
            (setq pt0 (getpoint "\nSelecione uma celula da tabela (ENTER=retorna): "))
            (if pt0
              (progn
                (setq
                  xp0 (car  pt0)
                  yp0 (cadr pt0)
                ) ; end setq
                (if (and (>= xp0 xpmin) (<= xp0 xpmax))
                  (if (and (>= yp0 ypmin) (<= yp0 ypmax))
                    (progn
                      (setq
                        xp1 (+ xpmin (* (fix (/ (- xp0 xpmin) dx)) dx) )
                        yp1 (+ ypmin (* (fix (/ (- yp0 ypmin) dy)) dy) )
                      ) ; end setq
                      (command
                        ".pline"
                          (list xp1 yp1) "w" 0 0
                          (list (+ xp1 dx) yp1)
                          (list (+ xp1 dx) (+ yp1 dy))
                          (list xp1 (+ yp1 dy))
                          "c"
                      ) ; end command
                      (redraw (setq enm (entlast)) 3)
                      (setq oldmnu (ai_svar "promptmenu" 1))
                      (initget "Yes No")
                      (if (/= (getkword "\nAtivar a celula destacada <Yes>? ") "No")
                        (setq
                          xpi xp1
                          ypi yp1
                          flg1 nil
                        ) ; end setq 
                      ) ; end if
                      (setvar "promptmenu" oldmnu)
                      (command
                        ".erase" enm ""
                        ".redraw"
                      ) ; end command
                    ) ; end progn
                    (prompt "\nERR: Ponto selecionado fora da tabela.")
                  ) ; end if
                  (prompt "\nERR: Ponto selecionado fora da tabela.")
                ) ; end if
              ) ; end progn
              (setq flg1 nil)
            ) ; end if
          ) ; end while
        ) ; end progn
      ) ; end case
      ( (= opt "APagar") (if (setq ss (ssget)) (command ".erase" ss "")) )
      ( (= opt "COpiar")
        (if (setq ls (tbtext_ugetcel "\nSelecionar os objetos a copiar (ENTER=retorna)..."))
          (command ".copy" (car ls) "" (cadr ls) (caddr ls))
      ) ) ; end if, progn
      ( (= opt "Mover")
        (if (setq ls (tbtext_ugetcel "\nSelecionar os objetos a mover (ENTER=retorna)..."))
          (command ".move" (car ls) "" (cadr ls) (caddr ls))
      ) ) ; end if, progn
      ( (= opt "Sair") (setq flg nil) )
      ( 't
        (progn
          (setq flg1 't)
          (while flg1

            (command
              ".pline"
              (list xpi ypi) "w" 0 0
              (list (+ xpi dx) ypi)
              (list (+ xpi dx) (+ ypi dy))
              (list xpi (+ ypi dy))
              "c"
            ) ; end command
            (redraw (setq enm (entlast)) 3)

            (if (/= (setq txt (getstring 't "\nText (ENTER=retorna): ")) "")
              (progn
                (cond
                  ( (= #TBTEXT_ALG "Esquerda")
                    (progn
                      (setq
                        xp1 (+ xpi #TBTEXT_DTX)
                        yp1 (+ ypi #TBTEXT_DTY)
                      ) ; end setq
                      (command ".text" (list xp1 yp1) #TBTEXT_HGT 0 txt)
                    ) ; end progn
                  ) ; end case
                  ( (= #TBTEXT_ALG "Centro")
                    (progn
                      (setq
                        xp1 (+ xpi (/ dx 2.0))
                        yp1 (+ ypi #TBTEXT_DTY)
                      ) ; end setq
                      (command ".text" "c" (list xp1 yp1) #TBTEXT_HGT 0 txt)
                    ) ; end progn
                  ) ; end case
                  ( (= #TBTEXT_ALG "Direita")
                    (progn
                      (setq
                        xp1 (- (+ xpi dx) #TBTEXT_DTX)
                        yp1 (+ ypi #TBTEXT_DTY)
                      ) ; end setq
                      (command ".text" "r" (list xp1 yp1) #TBTEXT_HGT 0 txt)
                    ) ; end progn
                  ) ; end case
                ) ; end cond
              ) ; end progn
              (setq flg1 nil)
            ) ; end if

            (command
              ".erase" enm ""
              ".redraw"
            ) ; end command

            (if flg1 (progn
                       (setq ypi (- ypi dy))
                       (if (< ypi ypmin)
                         (progn
                           (setq
                             ypi (- ypmax dy)
                             xpi (+ xpi dx)
                           ) ; end setq
                           (if (>= xpi xpmax) (setq xpi xpmin))
                         ) ; end progn
                       ) ; end if
                     ) ; end progn
            ) ; end if

          ) ; end while
        ) ; end progn
      ) ; end case
    ) ; end cond
  ) ; end while

  (setvar "cmdecho" oldecho)
  (princ)
) ; end defun

(princ)
