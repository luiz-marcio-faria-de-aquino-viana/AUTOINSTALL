
;                                A C A D (R)
;   ________________________________________________________________________
;         Copyright (C) 1994 by TML Software, Inc. All Rights Reserved.


;    THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
;    ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR PURPOSE AND OF
;    MERCHANTABILITY ARE HEREBY DISCLAIMED.
;   ________________________________________________________________________


;    DESCRIPTION:

;    LISP ACAD application - by Luiz Marcio Viana - 3/30/95

(vmon)

;; registro das aplicacoes que fazem uso de dados extendidos de entidades
(regapp "AI230EL")	;; aplicacao eletrica

(setq #VGTYPE "F-VG_TETO")
(setq m:hiso nil)

(setq M:APPDIR "/APPACAD/AI2_30/")

(defun V:AI  (f) (strcat M:APPDIR "" f))
(defun V:AID (f) (strcat M:APPDIR "D/" f))
(defun V:AIL (f) (strcat M:APPDIR "L/" f))
(defun V:AIM (f) (strcat M:APPDIR "M/" f))
(defun V:AIS (f) (strcat M:APPDIR "S/" f))
(defun V:APPL(f) (strcat "C:/APPL/AI/" f))

(defun m:err(msg)
  (prompt msg)
  (prompt "\n")
  (princ)
) ; end defun

;(setq *error* m:err)

(if (findfile "ai.lsp") (load"ai"))

(defun C:SAVE()
  (setvar "cmdecho"0)
  (if (= #LOCK "DISABLE")
    (progn
      (setq #FLSAVE "SAVED")
      (command ".save" "")
    ) ; end progn
    (progn
      (prompt "\n* ATENCAO *")
      (prompt "\nNao foi possivel gravar o desenho. Arquivo em uso.")
    ) ; end progn
  ) ; end if
  (princ)
) ; end function

(defun C:END()
  (setvar "cmdecho"0)
  (if (= #LOCK "DISABLE")
    (progn
      (logoff)
      (c:xfunload)
      (command
        ".layer" "t" "*" ""
        ".ucs" "w"
        ".plan" ""
      ) ; end command
      (if (findfile (strcat (getvar "DWGNAME") ".BAK"))
        (command ".shell" (strcat "del " (getvar "DWGNAME") ".BAK"))
      ) ; end if
      (command ".shell" (strcat "end " (getdwgdrive) " " (getdwgpath) " " (getdwgname)) )
      (if (findfile (strcat (getvar "DWGNAME") ".DWG"))
        (command ".wblock" (getvar "DWGNAME") "y" "*")
        (command ".wblock" (getvar "DWGNAME") "*")
      ) ; end if
      (unlockf)
      (command "script" "quitfile")
    ) ; end progn
    (progn
      (prompt "\n* ATENCAO *")
      (prompt "\nNao foi possivel gravar o desenho. Arquivo em uso.")
    ) ; end progn
  ) ; end if
  (princ)
) ; end function

(defun C:QUIT(/ opcao)
  (setvar "cmdecho"0)
  (initget "Yes No")
  (setq opcao(getkword "\nReally want to discard all changes to drawing <No>? ") )
  (if (= opcao "Yes") 
    (if (= #FLSAVE "NOT SAVED")
      (progn (unlockf) (command "script" "quitfile"))
      (c:end)
    ) ; end if
  ) ; end if
  (princ)
) ; end function

(defun C:RESET()
  (setvar "highlight"1)
  (setvar "blipmode"1)
  (setvar "pickbox"3)
  (setvar "aperture"3)
  (princ)
) ; end function

(defun loadf(arqv)
  (setq arqv (V:AIL arqv))
  (cond
    ( (findfile (strcat arqv ".lsp")) (load (strcat arqv ".lsp")) )
    ( (findfile (strcat arqv ".ls1")) (load (strcat arqv ".ls1")) )
    ( (findfile (strcat arqv ".crt"))
        (progn
          (setq cnt 0)
          (setq tmp "")
          (while (not (zerop (setq num (strlen (setq dat (xloadf (strcat arqv ".crt") cnt)) )) ))
            (setq tmp (strcat tmp dat))
            (setq cnt (+ cnt num))
          ) ; end while
          (eval (read tmp))
        ) ; end progn
    ) ; end case
    ( (prompt (strcat "\n* Arquivo " arqv " inexistente. *")) )
  ) ; end if
  (princ)
) ; end defun

(defun S::STARTUP()
  (setvar "cmdecho"0)

  (prompt "\nAUTOINSTALL V2.30")
  (prompt "\nCopyright (C) 1991-95 by Luiz Marcio F A Viana")
  (prompt "\nAll Rights Reserved.\n")

  (initget "Imprimir Empacotar Trabalhar")
  (setq #AUTOPLOT (getkword "\n(I)primir/(E)mpacotar/<(T)rabalhar>: "))
  (if (null #AUTOPLOT) (setq #AUTOPLOT "Trabalhar"))

  (command
    "undefine" "undo"
    "undefine" "quit"
    "undefine" "end"
    "undefine" "save"
  ) ; end command

  ;; habilita o handle se o mesmo nao estiver habilitado
  (if (zerop (getvar "handles")) (command ".handles" "on"))

  ;; load external ads functions
  (cond
    ( (= (getvar "platform") "386 DOS Extender")
      (progn
        (xload "xl")      ;; routines for data security
        (xload "filesea") ;; rotina p/ procurar arquivo no disco corrente
    ) ) ; end progn, case
    (t (prompt "ATT: Plataforma invalida para carga das funcoes ADS."))
  ) ; end cond

  ;; load external functions
  (if (= #AUTOPLOT "Trabalhar")
    (progn
      (loadf "K47c0") ;; lock file for mutual exclusion
      (lockf)         ;; call lock drawing function
    ) ; end progn
  ) ; end if

  (loadf "K20c0") ;; utility and miscelanious functions
  (loadf "k2fc0") ;; utilitarios para manipulacao de atributos
  (loadf "k36c0") ;; utilitarios para monitoracao e depuracao
  (loadf "k6cc0") ;; utilitarios para manipulacao de extended entity data
  (loadf "K65c0") ;; atualizacao dos atributos de revisao
  (loadf "k26c0") ;; logon and management functions
  (loadf "K03c0") ;; chgtext and text manipulation functions
  (loadf "K27c0") ;; vlog and project managemet functions

  (loadf "K4Ec0") ;; make layer structures
  (c:mklay)       ;; call make layer function

  (loadf "K51c0") ;; utilitario p/ analise e carga de XREF
  (loadf "K55c0") ;; utilitario p/ ajuste de XREF
  (loadf "K60c0") ;; utilitario p/ descarregar XREF

  (c:xfload)      ;; executa a funcao de carga dos XREF

  (if (null (setq ss (ssget "x" '((0 . "INSERT") (2 . "SET0EC00")))))
    (progn
      (setq
        nfile (strcat (getvar "DWGNAME") ".SET")
        file (open nfile "r")
      ) ; end setq
      (if (and file (findfile (strcat (getvar "dwgname") ".dwg") ) )
        (progn
          (setq #VER (read-line file))
          (if (or (= #VER "AI2.25") (= #VER "AI-V2.1"))
            (progn
              (setq
                #UND (atof (read-line file))
                #SCL (atof (read-line file))
                #ESCL (* #UND #SCL)
                #XPAPEL (car (getvar "limmax"))
                #YPAPEL (cadr (getvar "limmax"))
                #OWNER "ANNONYMOUS"
                #DATE "??/??/??"
              ) ; end setq
              (command ".insert" (V:AID "SET/SET0EC00") "0,0" "" "" "" #VER #XPAPEL #YPAPEL #ESCL #UND #OWNER #DATE)
            ) ; end progn
            (progn
              (setq
                #UND (/ 10.0 (atof #VER))
                #SCL (atof (read-line file))
                #VER "AI-V1.0"
                #ESCL (* #UND #SCL)
                #XPAPEL (car (getvar "limmax"))
                #YPAPEL (cadr (getvar "limmax"))
                #OWNER "ANNONYMOUS"
                #DATE "??/??/??"
              ) ; end setq
              (command ".insert" (V:AID "SET/SET0EC00") "0,0" "" "" "" #VER #XPAPEL #YPAPEL #ESCL #UND #OWNER #DATE)
              ;; convert from release (1.0) to (2.1/2.5)
              (loadf"k22c0")
              (loadf"k25c0")
            ) ; end progn
          ) ; end if
          (setq file(close file))
        ) ; end progn
        (progn
          ;; insere bloco indicador do PSPACE V2.0
          (command ".insert" (V:AID "SET/SET0FC00") "0,0" "" "" "")
          ;; load and execute setup program
          (prompt "\nCarregando programa setup...")
          (loadf "k1bc0")
          (c:setup)
        ) ; end progn
      ) ; end if
    ) ; end progn
    (progn
      ;; if exist setup block get parameters from there
      (setq ename (entnext (ssname ss (- (sslength ss) 1))) )
      (while (/= (cdr (assoc 0 (setq ent (entget ename)))) "SEQEND")
        (progn
          (setq tag (cdr (assoc 2 ent)))
          (cond
            ((= tag "#VER") (setq #VER (cdr (assoc 1 ent))) )
            ((= tag "#LARG") (setq #XPAPEL (atof (cdr (assoc 1 ent)))) )
            ((= tag "#ALT") (setq  #YPAPEL (atof (cdr (assoc 1 ent)))) )
            ((= tag "#ESCL") (setq #ESCL (atof (cdr (assoc 1 ent)))) )
            ((= tag "#UNID") (setq #UND (atof (cdr (assoc 1 ent)))) )
            ((= tag "#OWNER") (setq #OWNER (cdr (assoc 1 ent))) )
            ((= tag "#DATE") (setq #DATE (cdr (assoc 1 ent))) )
          ) ; end cond
          (entmod ent)
          (setq ename (entnext ename))
        ) ; end progn
      ) ; end while
      (setq #SCL (/ #ESCL #UND))
    ) ; end progn
  ) ; end if
  (prompt (strcat "\nVersao do desenho: " #VER))
  (if (findfile "acad1.lsp") (load "acad1"))
  (if (= #AUTOPLOT "Imprimir")
    (progn
      (prompt "\n\n\nIniciando impressao automatica...")
      (loadf "k7cc0")
      (ap_config (strcat (getvar "dwgname") ".psp"))
      (ap_execute)
    ) ; end progn
    (if (= #AUTOPLOT "Empacotar")
      (progn
        (prompt "\n\nIniciando empacotamento automatico...")
        (loadf "k95c0")
        (ad_config (strcat (getvar "dwgname") ".psd"))
        (ad_execute)
      ) ; end progn
    ) ; end if
  ) ; end if
  (princ)
) ; end function

(princ)
