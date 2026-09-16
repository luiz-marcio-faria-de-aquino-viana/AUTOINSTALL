
;;
;; OLDPLOT.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 8/13/96.
;;

;;
;; oldploter: rotina para plotagem de desenhos com ajuste automatico de escala

(defun c:oldploter(/ MAX_WIDTH FORM pt1 pt2 pta ptb plscl nfile pltype ncpy
                   ss ss1 ss2 ss3 oldhigh desc dx dy plrot deltx delty fat
                  fform n nform larg alt f1 s f)
  (setvar "cmdecho" 0)

  ;; declaracao da tabela de padroes
  (setq
    MAX_WIDTH  (- 900.0 0.5 0.5)
    FORM      '(("A3" . ( 422.0  299.0)) ("A2" . ( 596.0  422.0))
                ("A1" . ( 843.0  596.0)) ("A0" . (1191.0 843.0)) )
  ) ; end setq

  ;; definicao das variaveis globais
  (or #PLSCL (setq #PLSCL (* #scl #und)) )  ;; escala de plotagem
  (or #PLTYPE (setq #PLTYPE "Sulfite") )    ;; tipo de papel

  (initget 1)
  (setq pt1 (getpoint "\nPrimeiro corner: "))
  (initget 1)
  (setq pt2 (getcorner pt1 "\nSegundo corner: "))

  (setq
    pta (list (max (car pt1) (car pt2)) (max (cadr pt1) (cadr pt2)))
    ptb (list (min (car pt1) (car pt2)) (min (cadr pt1) (cadr pt2)))
  ) ; end setq
  (setq pta (list (+ (car pta)  1.0) (+ (cadr pta)  1.0)) )

  (initget 6 "Corrente")
  (setq plscl (getreal (strcat "\nEscala para plotagem/(C)orrente <" (rtos #PLSCL 2 2) ">: ")))
  (if plscl
    (if (= plscl "Corrente")
      (setq #PLSCL (* #SCL #UND))
      (setq #PLSCL plscl)
    ) ; end if
  ) ; end if
  
  (setq nfile (getstring "\nNome do arquivo: ") )

  (initget "Sulfite Vegetal")
  (setq pltype (getkword (strcat "\nPapel utilizado <" #pltype ">: ")))
  (if pltype (setq #pltype pltype))  

  (initget 6)
  (setq ncpy (getint "\nNumero de copias < 1 >: "))
  (if (null ncpy) (setq ncpy 1))

  (if (= #pltype "Vegetal")
    (if (setq ss1 (ssget "x" '((0 . "INSERT") (2 . "SET20C00"))))
      (if (setq ss2 (ssget "c" pt1 pt2))
        (progn
          (setq oldhigh (acadvar "highlight" 0))
          (command ".select" ss2 "r" ss1 "")
          (setq ss3 (ssget "p"))
          (if (= (sslength ss2) (sslength ss3))
            (setq ss nil)
            (progn
              (command ".select" ss2 "r" ss3 "")
              (setq ss (ssget "p"))
            ) ; end progn
          ) ; end if
          (setvar "highlight" oldhigh)
          (if (not (null ss))
            (progn
              (prompt "\nInforme a revisao realizada no desenho (max = 40 linhas)")
              (while (= (setq desc (getstring t "\n:: ")) "")
                (prompt "\nERR: Entrada nula nao e valida.") )
            ) ; end progn
          ) ; end if
        ) ; end progn
      ) ; end if
    ) ; end if
  ) ; end if

  (setq
    dx (- (car pta) (car ptb))
    dy (- (cadr pta) (cadr ptb))
  ) ; end setq

  (if (< dx dy)
    (setq
      plrot "Yes"
      deltx (/ dy (/ #PLSCL #UND))
      delty (/ dx (/ #PLSCL #UND))
    ) ; end setq
    (setq
      plrot "No"
      deltx (/ dx (/ #PLSCL #UND))
      delty (/ dy (/ #PLSCL #UND))
    ) ; end setq
  ) ; end if

  (setq
    fat   (/ (/ #PLSCL #UND) #SCL)
    deltx (* deltx #SCL)
    delty (* delty #SCL) 
  ) ; end setq

  (setq fform nil)
  (foreach n FORM
    (progn
      (setq
        nform (car n)
        larg (car  (cdr n))
        alt  (cadr (cdr n))
      ) ; end setq
      (if (null fform)
        (if (and (<= deltx larg) (<= delty alt)) (setq fform n) )
      ) ; end if
    ) ; end progn
  ) ; end foreach
  (if (null fform) (setq fform (cons "+A0" (list deltx delty))) )
  
  (prompt (strcat "\nFolha: < " (car fform) " >\t" (rtos deltx 2 2) " Larg\t\t" (rtos delty 2 2) " Alt"))
  (getstring "\nTecle [ENTER] p/ prosseguir.")  

  ;; atualizacao dos atributos da tabela de revisao e margem
  (if (and ss (= #pltype "Vegetal"))
    (updrev ss desc) )               ;; atualiza a tabela de revisoes
  (upddat)                           ;; atualiza informacao na margem

  ;; cria arquivo de script de plotagem
  (setq f (open (v:appl "PLOTER.SCR") "w"))

  (write-line "PLOT" f)
  (write-line "Window" f)
  (write-line (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6)) f)
  (write-line (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6)) f)
  (write-line "Yes" f)
  (write-line "Yes" f)

  ;; le o arquivo de configuracao de penas
  (if (findfile (v:ai "PLOTER.CFG"))
    (progn
      (setq f1 (open (v:ai "PLOTER.CFG") "r"))
      (while (setq s (read-line f1)) (write-line s f))
      (setq f1 (close f1))
    ) ; end progn
  ) ; end if

  (write-line "Yes" f)
  (write-line "M" f)
  (write-line "0,0" f)

  ;; se comprimento da folha for menor que a largura do ploter
  ;; rode o arquivo de 90d
  (if (< deltx MAX_WIDTH)
    (write-line (strcat (rtos deltx 2 6) "," (rtos (+ deltx 1.0) 2 6)) f)
    (write-line (strcat (rtos deltx 2 6) "," (rtos delty 2 6))         f)
  ) ; end if

  (write-line plrot f)
  (write-line "0.35" f)
  (write-line "No" f)
  (write-line "No" f)
  (write-line (strcat "1=" (rtos fat 2 6)) f)
  (write-line (strcat "C:\\SPOOL\\PLOT\\" nfile) f)
  (write-line (itoa ncpy) f)
  (write-line "" f)
  (write-line "Shell" f)
  (write-line (strcat "PLOTER " (strcase nfile) ".PLT" " " (car fform) " " #PLTYPE " " (itoa ncpy)) f)

  (setq f (close f))

  (command "script" (v:appl "PLOTER"))
  (princ)
) ; end defun

(princ)
