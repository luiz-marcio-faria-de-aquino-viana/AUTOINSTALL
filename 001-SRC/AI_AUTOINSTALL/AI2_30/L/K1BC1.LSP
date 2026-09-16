;                                S E T U P (R)
;   ________________________________________________________________________
;         Copyright (C) 1994 by TML Software, Inc. All Rights Reserved.


;    THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
;    ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR PURPOSE AND OF
;    MERCHANTABILITY ARE HEREBY DISCLAIMED.
;   ________________________________________________________________________


;    DESCRIPTION:

;    LISP SETUP application - by Luiz Marcio Viana - 3/30/95

;    VARIABELS

;    fpapel  - Formato do papel                             - Entrada
;    fescl   - Escala selecionada                           - Entrada
;    funid   - Unidade selecionada                          - Entrada
;    dpapel  - Lista dos padroes existentes                 - Interna
;    npapel  - Nome do bloco a ser inserido                 - Interna
;    nfile   - Nome do arquivo p/gravacao                   - Interna
;    file    - Nome da entidade ARQUIVO                     - Interna
;    ss      - Selecao do bloco SETUP                       - Interna
;    ename   - ENAME dos atributos do bloco SETUP           - Interna
;    ent     - Valor da entidade apontada por ENAME         - Interna
;    tag     - Descricao do atributo em analise             - Interna
;    #UND    - Unidade selecionada (mm=1)                   - Saida
;    #SCL    - Unidade selecionada (s/esc mm=1)             - Saida
;    #ESCL   - Seleciona a escala de trabalho               - Saida
;    #XPAPEL - Largura do padrao selecionado                - Saida
;    #YPAPEL - Altura do padrao selecionado                 - Saida
;    #VER    - Versao do software de instalacao             - Saida
;    #OWNER  - Criador do desenho                           - Saida
;    #DATE   - Data de criacao do arquivo                   - Saida

(defun c:setup(/ ss ename ent tag fpapel dpapel npapel fescl funid)
  (setvar "cmdecho" 0)

  (command
    ".menu" (V:AIM "SETmenu")
    ".vslide" (V:AIS "SET-00c")
  ) ; end command

  (initget 1 "A0 A1 A2 A3 2A2 2A3 A2A3A4 A1A2 A2A3 A3A4 Outro")
  (setq
    fpapel (getkword "\nFormato do papel: ")
    dpapel '((    "A0" . ("SET01c01" 1189  841))
             (    "A1" . ("SET02c01"  841  594))
             (    "A2" . ("SET03c01"  594  420))
             (    "A3" . ("SET04c01"  420  297))
             (   "2A2" . ("SET05c01" 1189  420))
             (   "2A3" . ("SET06c01"  841  297))
             (  "A1A2" . ("SET07c01" 1189  594))
             (  "A2A3" . ("SET08c01"  891  420))
             (  "A3A4" . ("SET09c01"  630  297))
             ("A2A3A4" . ("SET0Ac01" 1050  297)) )
  ) ; end setq

  (if (= fpapel "Outro")
    (progn
      (initget 7)
      (setq #XPAPEL (getint "\nLargura da folha (mm): ") )
      (initget 7)
      (setq #YPAPEL (getint "\nAltura da folha (mm): ") )
    ) ; end progn
    (progn
      (setq
        npapel  (cadr   (assoc fpapel dpapel))
        #XPAPEL (caddr  (assoc fpapel dpapel))
        #YPAPEL (cadddr (assoc fpapel dpapel))
      ) ; end setq
    ) ; end progn
  ) ; endif

  (command "redraw")
  (menucmd "s=escala")

  (initget 7)
  (setq fescl (getreal "\nEscala do desenho: ") )

  (menucmd "s=unidade")
  (initget 1 "MM CM M Outro")
  (setq funid (getkword "\nUnidade de trabalho: ") )

  (if (= funid "Outro")
    (progn
      (initget 7)
      (setq #UND (* (getreal "\nRelacao com a unidade (m): ") 1000.0) )
    ) ; end progn
    (progn
      (cond
        ((= funid "MM") (setq #UND    1.0))
        ((= funid "CM") (setq #UND   10.0))
        ((= funid  "M") (setq #UND 1000.0))
      ) ; end cond
    ) ; end progn
  );endif

  (setq #VER "AI2.26")

  (setvar "userr1" fescl)
  (setvar "userr2" #UND)

  (setq #SCL (/ fescl #UND) )
  (setvar "dimscale" #SCL)

  (setvar "ltscale" (* 10.0 #SCL))
  (setvar "textsize" (* #SCL 2.0))

  (setvar "snapunit" (list (/  25.0 #UND) (/  25.0 #UND)) )
  (setvar "gridunit" (list (/ 250.0 #UND) (/ 250.0 #UND)) )

  (command
    ".layer" "s" 0 ""
    ".limits" "0,0" (list (* #SCL #XPAPEL) (* #SCL #YPAPEL))
    ".zoom" "a"
  ) ; end command

  (if (= fpapel "Outro")
    (command
      ".pline" "0,0" "w" 0 ""
              (list (* #SCL #XPAPEL) 0)
              (list (* #SCL #XPAPEL) (* #SCL #YPAPEL))
              (list 0 (* #SCL #YPAPEL)) "c"
      ".pline" (list (* 20.0 #SCL) (* 10.0 #SCL))
              (list (* (- #XPAPEL 10.0) #SCL) (* 10.0 #SCL))
              (list (* (- #XPAPEL 10.0) #SCL) (* (- #YPAPEL 10.0) #SCL))
              (list (* 20.0 #SCL) (* (- #YPAPEL 10.0) #SCL)) "c"
      ".copy" "l" "" "m" "0,0"
              (list (* #SCL 0.5) (* #SCL 0.5))
              (list #SCL #SCL) ""
      ".insert" (V:AID "SET00c01")
              (list (* (- #XPAPEL 10.0) #SCL) (* 10.0 #SCL))
              #SCL "" 0
    ) ; end command
    (command ".insert" (V:AID npapel) "0,0" #SCL "" 0)
  ) ; end if

  (setq
    #VER "AI2.26"
    #ESCL fescl
    #OWNER (getenv "USR")
    #DATE (strcat
            (substr (rtos (getvar "cdate") 2 6) 7 2) "/"
            (substr (rtos (getvar "cdate") 2 6) 5 2) "/"
            (substr (rtos (getvar "cdate") 2 6) 3 2)
          ) ; end strcat
  ) ; end setq

  (if (null (setq ss (ssget "x" '((0 . "INSERT") (2 . "SET0EC00")))))
    (command ".insert" (V:AID "SET0EC00") "0,0" "" "" "" #VER #XPAPEL #YPAPEL #ESCL #UND #OWNER #DATE)
    (progn
      (setq ename (entnext (ssname ss (- (sslength ss) 1))) )
      (while (/= (cdr (assoc 0 (setq ent (entget ename)))) "SEQEND")
        (progn
          (setq tag (cdr (assoc 2 ent)))
          (cond
            ((= tag "#VER") (setq ent (subst (cons 1 #VER) (assoc 1 ent) ent)) )
            ((= tag "#LARG") (setq ent (subst (cons 1 (rtos #XPAPEL 2 2)) (assoc 1 ent) ent)) )
            ((= tag "#ALT") (setq ent (subst (cons 1 (rtos #YPAPEL 2 2)) (assoc 1 ent) ent)) )
            ((= tag "#ESCL") (setq ent (subst (cons 1 (rtos #ESCL 2 2)) (assoc 1 ent) ent)) )
            ((= tag "#UNID") (setq ent (subst (cons 1 (rtos #UND 2 2)) (assoc 1 ent) ent)) )
            ((= tag "#OWNER") (setq ent (subst (cons 1 #OWNER) (assoc 1 ent) ent)) )
            ((= tag "#DATE") (setq ent (subst (cons 1 #DATE) (assoc 1 ent) ent)) )
          ) ; end cond
          (entmod ent)
          (setq ename (entnext ename))
        ) ; end progn
      ) ; end while
    ) ; end progn
  ) ; end if

  (command ".menu" (V:AIM "ARQmenu"))

  (princ)
) ; end function

(princ)
