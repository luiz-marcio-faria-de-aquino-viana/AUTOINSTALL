(prompt "\nAutoINSTALL v8.0")
(prompt "\nCopyright(C) 1991-2014 AQ Projetos de Instalações Ltda. All Rights Reserved.")

;; definicao das funcoes de caminhos de pesquisa

(defun V:AI(f) (strcat "C:/ACADAPPL/AI8/" f))

(defun V:AID(f) (V:AI (strcat "D/" f)))
(defun V:AIL(f) (V:AI (strcat "L/" f)))
(defun V:AIM(f) (V:AI (strcat "M/" f)))
(defun V:AII(f) (V:AI (strcat "ICO/" f)))
(defun V:AIF(f) (V:AI (strcat "FONTS/" f)))
(defun V:AIS(f) (V:AI (strcat "S/" f)))

(defun V:AIPATH() (strcat (V:AI ";") (V:AII ";") (V:AIM ";") (V:AIF ";") (V:AIS ";")))

(defun V:APPL(f) (strcat "C:/Appl/AI8/" f))

(defun V:SPOOL(f) (strcat "C:\\SPOOL\\" f))

(defun V:PRJ(f) (strcat "V:" f))

(defun V:DET(f) (strcat "K:/AI7-DET/" f))

(setq V:OLDOSMODE 0):
(setq V:OLDBLIPMODE 0)
(setq V:OLDHIGHLIGHT 0)
(setq V:OLDCMDECHO 0)

;; m:savevars(): funcao que grava os valores das variaveis de ambiente do sistema
(defun m:savevars()
  (setq V:OLDOSMODE (getvar "osmode"))
  (setq V:OLDCMDECHO (getvar "cmdecho"))
  (setvar "osmode" 0)
  (setvar "cmdecho" 0)
) ; end setq

;; m:restorevars(): funcao que recupera os valores das variaveis de ambiente do sistema
(defun m:restorevars()
  (setvar "osmode" V:OLDOSMODE)
  (setvar "cmdecho" V:OLDCMDECHO)
) ; end setq

;; m:err(): funcao de erro padrao
;;  msg - mensagem de erro a ser impressa
(defun m:err(msg)
  (prompt msg)
  (setvar "blipmode" 1)
  (setvar "highlight" 1)
  (m:restorevars)
  (prompt "\n")
  (princ)
) ; end defun

;; ativa a funcao de tratamento de erro como sendo a padrao
(setq *error* m:err)

;; loadf: funcao de carga das rotinas
;;  arqv - nome do arquivo a ser carregado
(defun loadf(arqv / cnt tmp num)
  (setq arqv (V:AIL arqv))
  (cond
    ( (findfile (strcat arqv ".lsp")) (load (strcat arqv ".lsp")) )
    ( (findfile (strcat arqv ".ls1")) (load (strcat arqv ".ls1")) )
    ( (findfile (strcat arqv ".fas")) (load (strcat arqv ".fas")) )
    ( (findfile (strcat arqv ".crt"))
        (progn
          (setq cnt 0)
          (setq tmp "")
          (while (not (zerop (setq num (strlen (setq dat (aci_xloadf (strcat arqv ".crt") cnt)) )) ))
            (setq tmp (strcat tmp dat))
            (setq cnt (+ cnt num))
          ) ; end while
          (eval (read tmp))
        ) ; end progn
    ) ; end case
    ( (prompt (strcat "\nERR: Arquivo inexistente (=" arqv ").")) )
  ) ; end if
  (princ)
) ; end defun

;; carrega arquivo de definicao das funcoes autocarregaveis
(if (findfile (V:AIL "ai.lsp")) (load (V:AIL "ai.lsp")) )

;; definicao das variaveis de controle do programa
(setq
  M:VGTYPE  "F-VG_TETO"  ;; controle de camada para formas
  M:HISO    nil          ;; controle de camada para isometrico
  M:FLSAVED "NOTSAVED"   ;; controle de desenho salvo
 
) ; end setq

;; definicao das propriedades do desenho

(defun #VER()   (getvar "users1") )
(defun #ESCL()  (getvar "userr1") )
(defun #UND()   (getvar "userr2") )
(defun #LARG()  (getvar "userr3") )
(defun #ALT()   (getvar "userr4") )
(defun #OWNER() (getvar "users2") )
(defun #DATE()  (getvar "users3") )
(defun #SCL()   (getvar "dimscale") )

;; s::startup(): funcao autoexecucao de configuracao do ambiente de trabalho
(defun s::startup()

  (if (= (getvar "dwgname") "Drawing1.dwg")
    (command "menu" (V:AIM "arqmenu"))
  ) ; end if

  (setvar "cmdecho"0)

  (regapp "AI230EL")

  (if (= (getvar "handles") 0) (command ".handles" "on"))

  (setvar "plinetype" 0)
  
;;  (setvar "srchpath" (V:AIPATH))

;;  (command ".undefine" "save")
;;  (command ".undefine" "qsave")
;;  (command ".undefine" "saveall")
;;  (command ".undefine" "saveas")
;;  (command ".undefine" "saveasr12")
;;  (command ".undefine" "exit")
;;  (command ".undefine" "quit")
;;  (command ".undefine" "close")
;;  (command ".undefine" "wclose")
;;  (command ".undefine" "wcloseall")

  (loadf "base")    ;; carga das funcoes basicas de operacao
  (loadf "conf")    ;; carga das funcoes de configuracao do desenho

  (loadf "base/ai_base")
  (loadf "base/ai_auto")
  (loadf "base/ai_lay")

  ;; execucao das funcoes de inicializacao

  (c:mklay)       ;; funcao de criacao da estrutura de camadas
  (c:xfload)      ;; funcao de carga dos arquivos externos
  (logon)         ;; funcao de registro de acesso ao desenho

  (slaylight "0")
  ;;(setvar "cmdlntext" (strcat "[ " #USR " ]  Command: "))

  (conf)          ;; funcao de leitura dos parametros de configuracao

  (princ)
) ; end function

(s::startup)

(princ)
