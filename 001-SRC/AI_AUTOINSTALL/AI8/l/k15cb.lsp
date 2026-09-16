
;;
;; K15C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 4/10/96
;;

;; definicao das variaveis globais
(setq #PLSCL  (* (#SCL) (#UND)))  ;; escala de plotagem
(setq #PLTYPE     "Sulfite")  ;; tipo de papel


;; c:ploter(): comando para plotagem de desenhos com ajuste automatico de escala
(defun c:ploter()
  (setvar "cmdecho" 0)

  (setq MAX_WIDTH  (- 900.0 0.5 0.5))  ;; tamanho maximo permitido pelo dispositivo

  ;;
  ;; declaracao da tabela de padroes em ordem crescente de dimensoes
  ;;

  (setq
    FORM '( ( "A3" . (   422.0    299.0))
            ( "A2" . (   596.0    422.0))
            ( "A1" . (   843.0    596.0))
            ( "A0" . (  1191.0    843.0))
            ("+A0" . (999999.0 999999.0)) )
  ) ; end setq


  ;;
  ;; inicio dos procedimentos de entrada de dados
  ;;

  (initget 1)
  (setq pt1 (getpoint "\nPrimeiro corner: "))

  (initget 1)
  (setq pt2 (getcorner pt1 "\nSegundo corner: "))

  (setq
    pta (list (+ (max (car pt1) (car pt2)) (#SCL)) (+ (max (cadr pt1) (cadr pt2)) (#SCL)))
    ptb (list    (min (car pt1) (car pt2))          (min (cadr pt1) (cadr pt2))      )
  ) ; end setq

  (initget 6 "Corrente")
  (if (setq plscl (getreal (strcat "\nEscala de plotagem/Corrente <" (rtos #PLSCL 2 2) ">: ")) )
    (if (= plscl "Corrente")
      (setq #PLSCL (* (#SCL) (#UND)))
      (setq #PLSCL plscl)
    ) ; end if
  ) ; end if
  
  (initget 6)
  (setq ncpy (getint "\nNumero de copias < 1 >: "))
  (if (null ncpy) (setq ncpy 1))

  (setq nfile (getstring "\nNome do arquivo: ") )

  (initget "Sulfite Vegetal")
  (setq pltype (getkword (strcat "\nPapel utilizado <" #pltype ">: ")))
  (if pltype (setq #pltype pltype))  

  (if (= #pltype "Vegetal")
    (if (setq enm (car (entsel "\nSelecione a tabela de revisao ou [ENTER]: ")) )
      (progn
        (setq ent (entget enm))
        (if (and (= (cdr (assoc 0 ent))   "INSERT")
                 (= (cdr (assoc 2 ent)) "SET20C00") )
          (progn
            (prompt "\nInforme a revisao realizada no desenho (max = 40 linhas)")
            (while (= (setq desc (getstring t "\n:: ")) "")
              (prompt "\nERR: Entrada nula nao e valida.") )
          ) ; end progn
        ) ; end if
      ) ; end progn
    ) ; end if
  ) ; end if

  ;;
  ;; calcula dimensao da area selecionada
  ;;

  (setq
    dx (- (car pta) (car ptb))
    dy (- (cadr pta) (cadr ptb))
  ) ; end setq

  ;;
  ;; calcula fator de escala
  ;;

  (setq fat (/ #PLSCL (#UND)))

  ;;
  ;; calcula dimensao de impressao e sentido do papel
  ;;

  (if (< dx dy)
    (setq
      plrot "Yes"
      deltx (/ dy fat)
      delty (/ dx fat)
    ) ; end setq
    (setq
      plrot "No"
      deltx (/ dx fat)
      delty (/ dy fat)
    ) ; end setq
  ) ; end if

  ;;
  ;; obtem formato de prancha necessario para imprimir o desenho
  ;;

  (setq fform nil)
  (foreach n FORM
    (progn
      (setq
        nform (car n)
        larg  (car  (cdr n))
        alt   (cadr (cdr n))
      ) ; end setq
      (if (and (null fform) (and (<= deltx larg) (<= delty alt)) ) (setq fform n) )
    ) ; end progn
  ) ; end foreach
  (if (null fform) (setq fform (cons "+A0" (list deltx delty))) )
  
  (prompt (strcat "\nFolha: < " (car fform) " >\t" (rtos deltx 2 2) " Larg\t\t" (rtos delty 2 2) " Alt"))
  (getstring "\nTecle [ENTER] p/ prosseguir.")  

  ;;
  ;; atualizacao da tabela de revisoes
  ;;

  (if (and (= #pltype "Vegetal") enm) (updrev enm desc))

  (upddat)   ;; atualizacao das informacoes na margem

  ;;
  ;; criacao do arquivo de script de plotagem
  ;;

  (setq f (open (v:appl "PLOTER.SCR") "w"))

  (write-line ".PLOT"  f)
  (write-line "Window" f)
  (write-line (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6)) f)
  (write-line (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6)) f)
  (write-line "Yes"    f)
  (write-line "Yes"    f)
  (write-line "PLOT"   f)
  (write-line "Window" f)
  (write-line (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6)) f)
  (write-line (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6)) f)
  (write-line "Yes"    f)
  (write-line "No"     f)
  (write-line "0"      f)
  (write-line "Yes"    f)

  ;; processa arquivo de configuracao de penas
  (if (findfile (v:ai "PLOTER.CFG"))
    (progn
      (setq f1 (open (v:ai "PLOTER.CFG") "r"))
      (while (setq s (read-line f1)) (write-line s f))
      (setq f1 (close f1))
    ) ; end progn
  ) ; end if

  (write-line "Yes"    f)
  (write-line "M"      f)
  (write-line "0,0"    f)

  ;; se comprimento da folha for menor que a largura do ploter rodar de 90d
  (if (< deltx MAX_WIDTH)
    (write-line (strcat (rtos deltx 2 6) "," (rtos (+ deltx 1.0) 2 6)) f)
    (write-line (strcat (rtos deltx 2 6) "," (rtos delty 2 6))         f)
  ) ; end if

  (write-line plrot    f)
  (write-line "No"     f)
  (write-line (strcat "1=" (rtos fat 2 6)) f)
  (write-line (strcat "C:\\SPOOL\\PLOT\\" nfile) f)
  (write-line "Shell"  f)
  (write-line (strcat "PLOTER " (strcase nfile) ".PLT" " " (car fform) " " #PLTYPE " " (itoa ncpy)) f)

  (setq f (close f))

  (command "script" (v:appl "PLOTER"))
  (princ)
) ; end defun

(princ)
