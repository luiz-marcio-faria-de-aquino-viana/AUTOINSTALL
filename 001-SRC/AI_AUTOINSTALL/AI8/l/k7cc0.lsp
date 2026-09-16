
;;
;; K7CC0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 5/6/97
;;

;; c:ap_etpproj: rotina para trocar a etapa do projeto pela mudanca da cor da margem
(defun c:ap_etpproj(/ FFORM oldech opt ss col cnt ent enm frm)
  (m:savevars)

  (setq
    FFORM '("SET01C03" "SET02C03" "SET03C03" "SET04C03"
            "SET05C03" "SET06C03" "SET07C03" "SET08C03"
            "SET09C03" "SET0AC03" "SET0BC03")
  ) ; end setq

  (initget 1 "Estudo Anteprojeto Projeto")
  (setq opt (getkword "\nEtapa do projeto - (E)studo preliminar/(A)nteprojeto/(P)rojeto definitivo: ") )

  (cond
    ((= opt "Estudo")      (setq col 1))
    ((= opt "Anteprojeto") (setq col 3))
    ((= opt "Projeto")     (setq col 5))
  ) ; end cond

  (prompt "\nSelecione as margens dos desenhos que mudarao de etapa...")
  (if (setq ss (ssget))
    (progn
      (setq oldech (acadvar "cmdecho" 0))
      (setq cnt (sslength ss))
      (while (>= (setq cnt (1- cnt)) 0)
        (setq
          enm (ssname ss cnt)
          ent (entget enm)
        ) ; end setq
        (setq frm (cdr (assoc 2 ent)) )
        (if (member frm FFORM) (command ".change" enm "" "p" "c" col ""))
      ) ; end while
      (setvar "cmdecho" oldech)
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

;; ap_config: funcao para leitura da configuracao de impressao do desenho
;;  file_name - nome do arquivo de configuracao de impressao
(defun ap_config(file_name / fld dat s f)

  (prompt "\nLendo arquivo de configuracao...")

  (setq
    #AP_ETAPA   "PROJETO_DEFINITIVO"
    #AP_ESCALA  "1.0"
    #AP_PAPEL   "VEGETAL"
    #AP_CAMADAS ""
    #AP_NCOPIAS "1"
    #AP_SAIDA   "IMPRESSORA"
  ) ; end setq

  (if (setq f (open file_name "r"))
    (progn
      (while (setq s (read-line f))
        (setq
          fld (strcase (strpiece s 1 "="))
          dat (strcase (strpiece s 2 "="))
        ) ; end setq
        (cond
          ((= fld "ETAPA")           (setq #AP_ETAPA   dat))
          ((= fld "FATORAMPLIACAO")  (setq #AP_ESCALA  dat))
          ((= fld "PAPEL")           (setq #AP_PAPEL   dat))
          ((= fld "CONFCAMADAS")     (setq #AP_CAMADAS dat))
          ((= fld "NCOPIAS")         (setq #AP_NCOPIAS dat))
          ((= fld "SAIDA")           (setq #AP_SAIDA   dat))
        ) ; end cond
      ) ; end while
      (setq f (close f))
    ) ; end progn
  ) ; end if

  (princ)
) ; end defun

;; ap_camadas: funcao que processa as informacoes sobre o estado das camadas
(defun ap_camadas(llay / stt cnt s)
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

;; ap_plot: funcao para criacao do arquivo de comandos de impressao
;;  org  - origem da janela de impressao
;;  larg - largura da area selecionada
;;  alt  - altura da area selecionada
;;  scl  - escala de impressao
;;  ppl  - tipo do papel (sulfite/vegetal)
;;  cpy  - numero de copias
;;  plf  - dispositivo de saida (arquivo/impressora)
;;  fn   - nome do arquivo de saida
;;  f    - bloco de controle do arquivo de comandos
(defun ap_plot(org larg alt scl ppl cpy plf fn f / MAX_WIDTH FORM pta ptb
  dx dy plrot deltx delty fform n nform flarg falt f1 s)
  (setvar "cmdecho" 0)

  ;; declaracao da tabela de padroes
  (setq
    MAX_WIDTH  (- 900.0 0.5 0.5)
    FORM      '(("A3" . ( 422.0  299.0)) ("A2" . ( 596.0  422.0))
                ("A1" . ( 843.0  596.0)) ("A0" . (1191.0  843.0)) )
  ) ; end setq

  (setq
    pta (list (+ (car org) (* larg scl) (#SCL)) (+ (cadr org) (* alt scl) (#SCL)) )
    ptb org
  ) ; end setq

  (setq
    dx (- (car pta) (car ptb))
    dy (- (cadr pta) (cadr ptb))
  ) ; end setq

  (if (< dx dy)
    (setq
      plrot "Yes"
      deltx (/ dy scl)
      delty (/ dx scl)
    ) ; end setq
    (setq
      plrot "No"
      deltx (/ dx scl)
      delty (/ dy scl)
    ) ; end setq
  ) ; end if

  (setq fform nil)
  (foreach n FORM
    (progn
      (setq
        nform (car n)
        flarg (car  (cdr n))
        falt  (cadr (cdr n))
      ) ; end setq
      (if (null fform)
        (if (and (<= deltx flarg) (<= delty falt)) (setq fform n) )
      ) ; end if
    ) ; end progn
  ) ; end foreach
  (if (null fform) (setq fform (cons "+A0" (list deltx delty))) )
  
  (setvar "cmdecho" 1)

  (command
    ".PLOT"
      "Window"
      (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6))
      (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6))
      "5"
      "Yes"
      "PLOTER"
      "Window"
      (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6))
      (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6))
      "5"
      "No"
      "yes"
  ) ; end command
  
  ;; processa arquivo de configuracao de penas
  (if (setq f (open (v:ai "PLOTER.CFG") "r"))
    (progn
      (while (setq s (read-line f)) (command s))
      (setq f (close f))
    ) ; end progn
  ) ; end if

  (command
    "Yes"
    "M"
    "0,0"
  ) ; end command

  ;; se comprimento da folha for menor que a largura do ploter rode o arquivo de 90d
  (if (< deltx MAX_WIDTH)
    (command (strcat (rtos deltx 2 6) "," (rtos (+ deltx 1.0) 2 6)) )
    (command (strcat (rtos deltx 2 6) "," (rtos delty 2 6)) )
  ) ; end if

  (command
    plrot
    "No"
    (strcat "1=" (rtos scl 2 6))
    "0"
    "N"
  ) ; end command
  
  (setq fn (V:SPOOL (strcat "PLOT\\" fn)) )
  (if (findfile (strcat fn ".plt")) (command fn "Yes") (command fn))

  (setvar "cmdecho" 0)

  (command
    "Shell"
    (strcat
      "PLOTER "
      (strcase fn)
      " "
      (car fform)
      " "
      ppl
      " "
      cpy
      " "
      #USR
      " "
      plf
    ) ; end strcat
  ) ; end command
  
) ; end defun

;; ap_execute: funcao para execucao do processo de impressao automatica
(defun ap_execute(/ FFORM blk frm larg alt ss scl etp plf cnt ent
                 org col cdg fn f psl msl x)
  (setq
    FFORM '(("SET01C03" "A0"     1189.0  841.0)
            ("SET02C03" "A1"      841.0  594.0)
            ("SET03C03" "A2"      594.0  420.0)
            ("SET04C03" "A3"      420.0  297.0)
            ("SET05C03" "2A2"    1189.0  420.0)
            ("SET06C03" "2A3"     841.0  297.0)
            ("SET07C03" "A1A2"   1189.0  594.0)
            ("SET08C03" "A2A3"    891.0  420.0)
            ("SET09C03" "A3A4"    630.0  297.0)
            ("SET0AC03" "A2A3A4" 1050.0  297.0) )
  ) ; end setq

  (ap_config (strcat (getdwgfullname) ".psp"))

  (setq scl (/ (#SCL) (atof #AP_ESCALA)) )

  (cond
    ((= #AP_ETAPA "PROJETO_DEFINITIVO") (setq etp 5))
    ((= #AP_ETAPA "ANTEPROJETO")        (setq etp 3))
    ((= #AP_ETAPA "ESTUDO_PRELIMINAR")  (setq etp 1))
  ) ; end cond

  (if (= #AP_SAIDA "IMPRESSORA")
    (setq plf "No")
    (setq plf "Yes")
  ) ; end if

  (ap_camadas #AP_CAMADAS)

  (upddat)        ;; atualiza informacao na margem

  (setq psl '() )
  (setq msl '() )

  (foreach form FFORM
    (setq
      blk  (car    form)
      frm  (cadr   form)
      larg (caddr  form)
      alt  (cadddr form)
    ) ; end setq
    (if (setq ss (ssget "x" (list '(0 . "INSERT") (cons 2 blk))) )
      (progn
        (prompt (strcat "\nAnalisando formato " frm "..."))
        (setq cnt (sslength ss))
        (while (>= (setq cnt (1- cnt)) 0)
          (setq
            enm (ssname ss cnt)
            ent (entget enm)
          ) ; end setq
          (setq
            org (cdr (assoc 10 ent))
            col (cdr (assoc 62 ent))
            psf (cdr (assoc 67 ent))
          ) ; end setq
          (setq cdg (cadr (assoc "CR_CODG" (attread enm))) )
          (if (or (null cdg) (= cdg ""))
            (setq fn (strcat (substr (getdwgname) 1 6) (itoa cnt)) )
            (setq fn cdg)
          ) ; end if
          (if (>= col etp)
            (if (= psf 1)
              (setq psl (cons (list org larg alt fn) psl))
              (setq msl (cons (list org larg alt fn) msl))
            ) ; end if
          ) ; end if
        ) ; end while
      ) ; end progn
    ) ; end if
  ) ; end foreach

  (setvar "tilemode" 1)
  (foreach x msl
    (setq
      org  (car    x)
      larg (cadr   x)
      alt  (caddr  x)
      fn   (cadddr x)
    ) ; end setq
    (ap_plot org larg alt scl #AP_PAPEL #AP_NCOPIAS plf fn f)
  ) ; end foreach

  (setvar "tilemode" 0)
  (foreach x psl
    (setq
      org  (car    x)
      larg (cadr   x)
      alt  (caddr  x)
      fn   (cadddr x)
    ) ; end setq
    (ap_plot org larg alt scl #AP_PAPEL #AP_NCOPIAS plf fn f)
  ) ; end foreach

  (command ".quit" "y")
) ; end defun

(princ)
