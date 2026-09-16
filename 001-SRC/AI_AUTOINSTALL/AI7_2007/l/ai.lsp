
;;
;; AI.lsp
;; Copyright (C) 1996 by Luiz Marcio Faria Viana, 9/10/96
;;
;; Descricao: Arquivo de declaracao das rotinas auto-carregaveis
;;

;; autoload: funcao de auto-carregamento das rotinas
;;  n  - identificacao da rotina auto-carregavel
;;  ls - lista dos comandos existentes no arquivo
;;  ff - nome do arquivo a ser carregado
(defun autoload (n cmd ff / s)
  (setq s (strcat
            "(defun " cmd "()"
            "(princ \"\nInicializando...\")"
            "(loadf \"" ff "\")"
            "(" cmd ")"
            "(princ))"
          ) ; end strcat
  ) ; end read
  (eval (read s))
  (prompt (strcat "." (itoa n)) )
  (princ)
)

;;
;; declaracao das rotinas auto-carregaveis pelo editor de desenho
;;

(princ "\n\nDeclarando rotinas auto-carregaveis... ")

;; ===== aplicacoes Lisp auto-carregaveis =====

(autoload   1 "c:inserir"     "k0bc0")

(autoload   2 "c:brkins"      "k71c0")

(autoload   3 "c:insert2"     "k0cc0")

(autoload   4 "c:insert3"     "k0dc0")

(autoload   5 "c:uinsert"     "k30c0")

(autoload   6 "c:setlum"      "K6ac0")

(autoload   7 "c:eattmov"     "k31c0")

(autoload   8 "c:esetorg"     "k31c0")

(autoload   9 "c:esetcol"     "k31c0")

(autoload  10 "c:echcir"      "k34c0")

(autoload  11 "c:echcmd"      "k34c0")

(autoload  12 "c:edelfios"    "k87c0")

(autoload  13 "c:elist"       "k31c0")

(autoload  14 "c:emirror"     "k31c0")

(autoload  15 "c:ecopy"       "k31c0")

(autoload  16 "c:efiacao"     "k33c0")

(autoload  17 "c:echorg"      "k34c0")

(autoload  18 "c:i_legenda"   "k5dc0")

(autoload  19 "i_togglecnt"   "k5dc0")

(autoload  20 "c:leader1"     "k0fc0")

(autoload  21 "c:lumembt"     "k4cc0")

(autoload  22 "c:lumsobr"     "k4cc0")

(autoload  23 "c:lumpend"     "k4cc0")

(autoload  24 "c:pscar"       "k4bc0")

(autoload  25 "c:psmarg"      "k4bc0")

(autoload  26 "c:pswin"       "k4bc0")

(autoload  27 "c:carimbo"     "k02c0")

(autoload  28 "c:i_indic"     "k5dc0")

(autoload  29 "c:esgtb"       "k68c0")

(autoload  30 "c:esgin"       "k69c0")

(autoload  31 "c:cx"          "k08c0")

(autoload  32 "c:circuito"    "k04c0")

(autoload  33 "c:gbox"        "k23c0")

(autoload  34 "c:cxd"         "k24c0")

(autoload  35 "c:torre"       "k2bc0")

(autoload  36 "c:mq2s"        "k2ac0")

(autoload  37 "c:mq1s"        "k29c0")

(autoload  38 "c:barrane"     "k70c0")

(autoload  39 "c:eqdca"       "k35c0")

(autoload  40 "c:htub"        "k73c0")

(autoload  41 "c:lismat"      "k74c0")

(autoload  42 "c:isoblk"      "k75c0")

(autoload  43 "c:eadjuste"    "k77c0")

(autoload  44 "c:hinsert"     "k78c0")

(autoload  45 "c:detblk"      "k79c0")

(autoload  46 "c:cd"          "k7ac0")

(autoload  47 "c:ctd"         "k7ac0")

(autoload  48 "c:cttd"        "k7ac0")

(autoload  49 "c:offchg"      "k58c0")

(autoload  50 "c:ap_etpproj"  "k7cc0")

(autoload  51 "c:edt"         "k6bc0")

(autoload  52 "c:emkclh"      "k6dc0")

(autoload  53 "c:emkobj"      "k6ec0")

(autoload  54 "c:everdt"      "k76c0")

(autoload  55 "c:copyattr"    "k6fc0")

(autoload  56 "c:chgblock"    "k7dc0")

(autoload  57 "c:echdt"       "k7ec0")

(autoload  58 "c:einsobj"     "k80c0")

(autoload  59 "c:eqpot"       "k7fc0")

(autoload  60 "c:ddsetup"     "k1bc0")

(autoload  61 "c:imptxt"      "k39c0")

(autoload  62 "c:vmodif"      "k56c0") 

(autoload  63 "c:vlog"        "k28c0")

(autoload  64 "c:custo"       "k48c0")

(autoload  65 "c:info"        "k3dc0")

(autoload  66 "c:pilar"       "k14c0")

(autoload  67 "c:redondo"     "k1ac0")

(autoload  68 "c:parede"      "k13c0")

(autoload  69 "c:malha"       "k46c0")

(autoload  70 "c:ambiente_1p" "k82c0")

(autoload  71 "c:ambiente_2p" "k82c0")

(autoload  72 "c:ambiente_3p" "k82c0")

(autoload  73 "ambiente_esp"  "k82c0")

(autoload  74 "ambiente_esp0" "k82c0")

(autoload  75 "c:porta"       "k16c0")

(autoload  76 "c:porta2x"     "k16c0")

(autoload  77 "c:pcorrer"     "k16c0")

(autoload  78 "c:janela"      "k0ec0")

(autoload  79 "c:editext"     "k07c0")

(autoload  80 "c:chcopy"      "k2ec0")

(autoload  81 "c:ps"          "k3ec0")

(autoload  82 "c:pf"          "k3ec0")

(autoload  83 "c:pch"         "k3ec0")

(autoload  84 "c:serie"       "k3fc0")

(autoload  85 "c:pe"          "k49c0")

(autoload  86 "c:plexpl"      "k4dc0")

(autoload  87 "c:uniline"     "k64c0")

(autoload  88 "c:cutwall"     "k21c0")

(autoload  89 "c:numblk"      "k66c0")

(autoload  90 "c:xfreload"    "k52c0")

(autoload  91 "c:apto"        "k00c0")

(autoload  92 "c:dblscr"      "k59c0")

(autoload  93 "c:siscr"       "k59c0")

(autoload 94 "c:c2p"          "k01c0")

(autoload  95 "c:layiso"      "qtools")

(autoload  98 "c:boneca"      "k84c0")

(autoload  99 "c:ddgdet"      "k85c0")

(autoload 100 "c:ecopfios"    "k87c0")

(autoload 101 "c:emovfios"    "k87c0")

(autoload 102 "c:erotfios"    "k87c0")

(autoload 103 "c:erestdt"     "k76c0")

(autoload 104 "c:eordem"      "k89c0")

(autoload 105 "c:mr"          "k8ac0")

(autoload 106 "c:mra"         "k8ac0")

(autoload 107 "c:ai_propchk"  "k8cc0")

(autoload 108 "ai_propchk"    "k8cc0")

(autoload 109 "c:eqdcm"       "k35c0")

(autoload 110 "c:tbtext"      "k8dc0")

(autoload 111 "c:tbcons"      "k8ec0")

(autoload 112 "c:il_refl"     "k5bc0")

(autoload 113 "c:il_calc"     "k5bc0")

(autoload 114 "c:il_modif"    "k5bc0")

(autoload 115 "c:il_rslt"     "k5bc0")

(autoload 116 "c:colblk"      "k8fc0")

(autoload 117 "c:blexpl"      "k91c0")

(autoload 118 "c:sol2hat"     "k92c0")

(autoload 119 "c:p-desce"     "k10c0")

(autoload 120 "c:p-passa"     "k11c0")

(autoload 121 "c:p-sobe"      "k12c0")

(autoload 122 "c:t-desce"     "k1dc0")

(autoload 123 "c:t-passa"     "k1ec0")

(autoload 124 "c:t-sobe"      "k1fc0")

(autoload 125 "c:flaje"       "k09c0")

(autoload 126 "c:fviga"       "k0ac0")

(autoload 128 "c:ff_fiacao"   "kffc0")

(autoload 129 "c:ff_byblock"  "kffc0")

(autoload 130 "c:dutos"       "k2cc0")

(autoload 131 "c:transf"      "k2dc0")

(autoload 132 "ap_config"     "k7cc0")

(autoload 133 "ap_execute"    "k7cc0")

(autoload 134 "c:aci_echkdt"  "k95c0")

(autoload 135 "c:inser0"      "k96c0")

(autoload 136 "c:rfiacao"     "k33c0")

(autoload 137 "c:ccalha"      "k5cc0")

(autoload 138 "c:ccaixa"      "k5ec0")

(autoload 139 "c:cdt"         "k45c0")

(autoload 140 "c:ilum"        "k4ac0")

(autoload 141 "c:ccd"         "k01c0")

(autoload 142 "c:c2td"        "k01c0")

(autoload 143 "c:IFIND"       "U_FIND")

(autoload 144 "c:ATTEXPLD"    "K99c0")

(autoload 145 "c:CIRTEXT"     "qtools")

(autoload 146 "c:LAYOFF"      "qtools")

(autoload 147 "c:LAYON"       "qtools")

(autoload 148 "c:LAYTHW"      "qtools")

(autoload 149 "c:LAYFRZ"      "qtools")

(autoload 150 "c:CLOUD"       "qtools")

(autoload 151 "c:FVIGA2"      "k9ac0")

(autoload 152 "c:ELETROCALHA" "k9bc0")

(autoload 153 "c:detajusta"   "k9cc0")

(autoload 154 "c:dettrocacamada" "k9cc0")

(autoload 155 "c:sp2pl"       "k9dc0")

(autoload 156 "c:allsp2pl"    "k9dc0")

(autoload 157 "c:lum2ai"      "k9dc0")

(autoload 158 "c:lumdiag2ai"  "k9dc0")

(autoload 159 "c:inserirsimb" "k0bc0")

(autoload 160 "c:cotaeixo" "ka0c0")

(autoload 161 "c:cotaeixo_seleixos" "ka1c0")

(autoload 162 "c:cotaeixo_inscota" "ka1c0")

(prompt "\n")
(princ)
