
;;
;; K95C0.lsp
;; Copyright (C) 1999 by Luiz Marcio F A Viana, 6/21/99
;;

;; c:ad_insert: comando para insercao do bloco de delimitacao de regiao de empacotamento
(defun c:ad_insert(/ MARG pt1 pt2)

  (setq MARG "SET/SET31C00")

  (initget 1)
  (setq pt1 (getpoint "\nPrimeiro canto: "))

  (initget 1)
  (setq pt2 (getcorner pt1 "\nSegundo canto: "))

  (slay "$LIM0")
  (command ".insert" (V:AID MARG) pt1 "C" pt2 0)

  (princ)
) ; end defun

;; ad_config: funcao para leitura da configuracao de empacotamento do desenho
;;  file_name - nome do arquivo de configuracao de impressao
(defun ad_config(file_name / fld dat s f)

  (prompt "\nLendo arquivo de configuracao...")

  (setq
    #AD_COMPACTAR "NAO"
    #AD_CAMADAS ""
  ) ; end setq

  (if (setq f (open file_name "r"))
    (progn
      (while (setq s (read-line f))
        (setq
          fld (strcase (strpiece s 1 "="))
          dat (strcase (strpiece s 2 "="))
        ) ; end setq
        (cond
          ((= fld "COMPACTARARQUIVO") (setq #AD_COMPACTAR dat))
          ((= fld "CONFCAMADAS")      (setq #AD_CAMADAS dat))
        ) ; end cond
      ) ; end while
      (setq f (close f))
    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

;; ad_camadas: funcao que processa as informacoes sobre o estado das camadas
(defun ad_camadas(llay / stt cnt s lay)
  (setq stt "Thaw")
  (setq cnt 1)
  (command ".layer")
  (while (/= (setq s (strpiece llay cnt ";")) "")
    (cond
      ((= s "+") (setq stt "Thaw"))
      ((= s "-") (setq stt "Freeze"))
      ((= s "#") (setq lay "ARQ-*,F-*,EL-*,ES-*,H-*,G-*,TE-*,TI-*,IE-*,AR-*"))
      ('t        (setq lay s))
    ) ; end cond
    (if (and (/= s "+") (/= s "-")) (command stt lay))
    (setq cnt (1+ cnt))
  ) ; end while
  (command "")
) ; end defun

;; ad_xbind: funcao que insere todos os arquivos de referencia no desenho
(defun ad_xbind(/ xl tbl xfn xfp it)
  (setq xl '())

  (setq tbl (tblnext "block" 't))
  (while tbl
    (if (/= (logand (cdr (assoc 70 tbl)) 4) 0)
      (progn
        (setq
          xfn (cdr (assoc 2 tbl))
          xfp (cdr (assoc 1 tbl))
        ) ; end setq
        (command ".xref" "d" xfn)
        (setq xl (cons (list xfn xfp) xl))
      ) ; end progn
    ) ; end if
    (setq tbl (tblnext "block"))
  ) ; end while
  
  (foreach it xl
    (progn
      (setq
        xfn (car it)
        xfp (cadr it)
      ) ; end setq
      (command
        ".insert" (strcat xfn "=" xfp) "0,0" "1.0" "" "0.0"
        ".explode" (entlast)
      ) ; end command
    ) ; end progn
  ) ; end foreach
) ; end defun

;; ad_pack: funcao que extrai as entidades do arquivo
(defun ad_pack(org larg alt fn / ff)
  (setq ff (strcat "C:\\LIXO\\" fn))
  (if (findfile (strcat ff ".dwg"))
    (command ".wblock" ff "y")
    (command ".wblock" ff)
  ) ; end if
  (command
      ""
      org
      "w"
      org
      (list (+ (car org) larg) (+ (cadr org) alt))
      ""
    ".oops"
  ) ; end command
) ; end defun

;; ad_execute: funcao para execucao do processo de empacotamento automatico
(defun ad_execute(/ MARG psl msl cnt enm ent ss org larg alt psf cdg fn it)
  (setvar "cmdecho" 0)

  (setq MARG "SET31C00")

  (ad_xbind)

  (ad_camadas #AD_CAMADAS)

  (setq psl '())
  (setq msl '())

  (if (setq ss (ssget "x" (list '(0 . "INSERT") (cons 2 MARG))) )
    (progn
      (setq cnt (sslength ss))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq
          enm (ssname ss cnt)
          ent (entget enm)
        ) ; end setq
        (setq
          org  (cdr (assoc 10 ent))
          larg (cdr (assoc 41 ent))
          alt  (cdr (assoc 42 ent))
          psf  (cdr (assoc 67 ent))
        ) ; end setq
        (setq cdg (cadr (assoc "CR_CODG" (attread enm))) )
        (if (or (null cdg) (= cdg ""))
          (setq fn (strcat "$" (substr (getdwgname) 1 5) (substr (itoa cnt) 1 2)) )
          (setq fn (strcat "$" (substr cdg 1 7)) )
        ) ; end if
        (if (= psf 1)
          (setq psl (cons (list org larg alt fn) psl))
          (setq msl (cons (list org larg alt fn) msl))
        ) ; end if
      ) ; end while
    ) ; end progn
  ) ; end if

  (foreach it msl
    (ad_pack (car it) (cadr it) (caddr it) (cadddr it)) )
  (setvar "tilemode" 0)
  (foreach it psl
    (ad_pack (car it) (cadr it) (caddr it) (cadddr it)) )

  (command ".script" (V:AI "quitfile"))
  (princ)
) ; end defun

(princ)
