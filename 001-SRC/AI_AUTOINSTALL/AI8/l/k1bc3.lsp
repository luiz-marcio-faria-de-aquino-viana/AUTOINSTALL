; K1bc0/SETup - Jan/92

; Variaveis:
;     Fpapel - Formato do papel                 - Entrada
;     Fescl  - Escala selecionada               - Entrada
;     Funid  - Unidade selecionada              - Entrada
;     Dpapel - Dimensao dos padroes existentes  - Interna
;     Nblock - Lista contendo os blocos corresp - Interna
;     Npapel - Nome do bloco a ser inserido     - Interna
;     Tpapel - Relacao dos padroes existentes   - Interna
;     Xpapel - Largura do padrao selecionado    - Interna
;     Ypapel - Altura do padrao selecionado     - Interna
;     Spapel - Padrao para pesquisa             - Interna
;     Flag   - Contador                         - Interna
;     Nfile  - Nome do arquivo p/gravacao       - Interna
;     File   - Nome da entidade ARQUIVO         - Interna
;     Nnivel - Nome dos layers                  - Interna
;     Cnivel - Nome das cores p/respc layers    - Interna
;     Lnivel - Tipo de linha p/respc layers     - Interna
;     (#UND)   - Unidade selecionada (mm=1)       - Saida
;     (#SCL)   - Unidade selecionada (s/esc mm=1) - Saida

(setvar "cmdecho" 0)

(if (/= (strcase (getvar "menuname") T) "SETMENU")
  (command "menu" "SETmenu")
  (menucmd "s=screen")
);endif
(command
  "vslide" "SET-00c"
);endcommand

(initget 1 "A0 A1 A2 A3 2A2 2A3 A2A3A4 A1A2 A2A3 A3A4 Outro")
(setq
  fpapel (getkword "\nFormato do papel: ")
  dpapel '((1189 841) (841 594) ( 594 420) ( 420 297)
           (1189 420) (841 297) (1189 594) (891 420)
           (630 297) (1050 297))
  tpapel '("A0" "A1" "A2" "A3" "2A2" "2A3" "A1A2" "A2A3" "A3A4" "A2A3A4")
  nblock '("01c01" "02c01" "03c01" "04c01" "05c01"
           "06c01" "07c01" "08c01" "09c01" "0ac01")
  flag 0
);endsetq
(if (= fpapel "Outro")
  (progn
    (initget 7)
    (setq
      xpapel (getint "\nLargura da folha (mm): ")
    );endsetq
    (initget 7)
    (setq
      ypapel (getint "\nAltura da folha (mm): ")
    );endsetq
  );endprogn
  (progn
    (foreach spapel tpapel
      (if (= fpapel spapel)
        (setq
          xpapel (car (nth flag dpapel))
          ypapel (cadr (nth flag dpapel))
          npapel (nth flag nblock)
        );endsetq
      );endif
      (setq flag (1+ flag))
    );endforeach
  );endprogn
);endif
(command "redraw")

(menucmd "s=escala")
(initget 7)
(setq
  fescl (getreal "\nEscala do desenho: ")
);endsetq

(menucmd "s=unidade")
(initget 1 "MM CM M Outro")
(setq
  funid (getkword "\nUnidade de trabalho: ")
);endsetq
(if (= funid "Outro")
  (progn
    (initget 7)
    (setq
      (#UND) (* (getreal "\nRelacao com a unidade (m): ") 1000.0)
    );endsetq
  );endprogn
  (progn
    (cond
      ((= funid "MM") (setq (#UND) 1.0))
      ((= funid "CM") (setq (#UND) 10.0))
      ((= funid "M") (setq (#UND) 1000.0))
    );endcond
  );endprogn
);endif

(setq
  (#SCL) (/ fescl (#UND))
);endsetq

(setvar "ltscale" (* 10.0 (#SCL)))
(setvar "dimscale" (#SCL))
(setvar "textsize" (* (#SCL) 2.0))
(setvar "snapunit" (list
                     (/ 25.0 (#UND))
                     (/ 25.0 (#UND))
)                  );endlist,setvar
(setvar "gridunit" (list
                     (/ 250.0 (#UND))
                     (/ 250.0 (#UND))
)                  );endlist,setvar
(command
  "layer" "s" 0 ""
  "limits" "0,0" (list
                   (* (#SCL) xpapel) (* (#SCL) ypapel)
                 );endlist
  "zoom" "a"
);endcommand

(if (= fpapel "Outro")
  (command
    "pline" "0,0" "w" 0 ""
            (list (* (#SCL) xpapel) 0)
            (list (* (#SCL) xpapel) (* (#SCL) ypapel))
            (list 0 (* (#SCL) ypapel)) "c"
    "pline" (list (* 20.0 (#SCL)) (* 10.0 (#SCL)))
            (list (* (- xpapel 10.0) (#SCL)) (* 10.0 (#SCL)))
            (list (* (- xpapel 10.0) (#SCL)) (* (- ypapel 10.0) (#SCL)))
            (list (* 20.0 (#SCL)) (* (- ypapel 10.0) (#SCL))) "c"
    "copy" "l" "" "m" "0,0"
            (list (* (#SCL) 0.5) (* (#SCL) 0.5))
            (list (#SCL) (#SCL)) ""
    "insert" "SET00c01"
             (list (* (- xpapel 10.0) (#SCL)) (* 10.0 (#SCL)))
             (#SCL) "" 0
  );endcommand
  (command
    "insert" (strcat "SET" npapel)
             "0,0" (#SCL) "" 0
  );endcommand
);endif

(setq
  fname (strcat
          (getvar "DWGNAME") ".SET"
        );endstrcat
  file (open fname "w")
);endsetq
(write-line "AI-V2.1" file)
(write-line (rtos (#UND) 2 6) file)
(write-line (rtos (#SCL) 2 6) file)
(setq
  file (close file)
);endsetq

(setq
  nnivel '("ARQ-arquitetura" "ARQ-textos"
           "F-pl_teto" "F-vg_teto" "F-vg_piso" "F-furacao" "F-textos"
           "EL-prumadas" "EL-dt_teto" "EL-dt_piso" "EL-dt_aparente" "EL-pontos" "EL-furacao" "EL-vigas" "EL-textos" "EL-detalhe"
           "ES-colunas" "ES-primario" "ES-secundario" "ES-ventilacao" "ES-apluvial" "ES-bujao" "ES-pontos" "ES-furacao" "ES-vigas" "ES-textos" "ES-detalhe"
           "H-colunas" "H-tb_afria" "H-tb_aquente" "H-tb_incendio" "H-pontos" "H-furacao" "H-vigas" "H-Textos" "H-detalhe"

           "G-prumadas" "G-tb_teto" "G-tb_piso" "G-pontos" "G-furacao" "G-vigas" "G-textos" "G-detalhe"
           "TE-prumadas" "TE-tb_teto" "TE-tb_piso" "TE-pontos" "TE-furacao" "TE-vigas" "TE-textos" "TE-detalhe"
           "TI-prumadas" "TI-tb_teto" "TI-tb_piso" "TI-pontos" "TI-furacao" "TI-vigas" "TI-textos" "TI-detalhe"
           "IE-prumadas" "IE-tvfm" "IE-som" "IE-circ_tv" "IE-pararaio" "IE-pontos" "IE-furacao" "IE-vigas" "IE-textos" "IE-detalhe"
           "AR-colunas" "AR-agelada" "AR-dutos" "AR-pontos" "AR-furacao" "AR-vigas" "AR-textos" "AR-detalhe")
  lnivel '("continuous" "continuous"
           "continuous" "dashdot" "divide" "continuous" "continuous"
           "continuous" "continuous" "hidden" "dashdot" "continuous" "continuous" "continuous" "continuous" "continuous"
           "continuous" "continuous" "hidden" "dot" "dashdot" "continuous" "continuous" "continuous" "continuous" "continuous" "continuous"
           "continuous" "continuous" "hidden" "dashdot" "continuous" "continuous" "continuous" "continuous" "continuous"

           "continuous" "continuous" "hidden" "continuous" "continuous" "dashdot" "continuous" "continuous"
           "continuous" "hidden" "continuous" "continuous" "continuous" "dashdot" "continuous" "continuous"
           "continuous" "hidden" "continuous" "continuous" "continuous" "dashdot" "continuous" "continuous"
           "continuous" "divide" "border" "phantom" "center" "continuous" "continuous" "dashdot" "continuous" "continuous"
           "continuous" "continuous" "continuous" "continuous" "continuous" "dashdot" "continuous" "continuous")
  cnivel '("yellow" "yellow"
           "yellow" "yellow" "yellow" "yellow" "yellow"
           "green" "blue" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
           "green" "blue" "blue" "blue" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
           "green" "blue" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"

           "green" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
           "green" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
           "green" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
           "green" "blue" "blue" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
           "green" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow")
  flag 0
);endsetq
(command "layer" "t" "*" "c" "blue" "0")
(foreach snivel nnivel
  (command
    "m" snivel
    "l" (nth flag lnivel) snivel
    "c" (nth flag cnivel) snivel
  );endcommand
  (setq flag (1+ flag))
);endforeach
(command
  "s" "0" ""
  "menu" "ARQmenu"
);endcommand
(setq
  enivel nil
  cnivel nil
  lnivel nil
  dpapel nil
  tpapel nil
  nblock nil
);endsetq

(princ)
