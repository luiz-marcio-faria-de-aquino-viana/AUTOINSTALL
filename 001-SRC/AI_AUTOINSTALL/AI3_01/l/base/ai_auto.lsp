
;;
;; AI_AUTO.lsp
;; Copyright (C) 2000 by Luiz Marcio Faria Viana, 1/6/2000
;;

(prompt "\n\nIniciando auto-carregamento... ")

;; declaracao dos comandos de acionamento das rotinas auto-carregaveis basicas

(ai_autoload 1000 "c:ai_insert1p"   "base/k00c0")
(ai_autoload 1001 "c:ai_insertvs1p" "base/k01c0")
(ai_autoload 1002 "c:ai_poff"       "base/k02c0")


;; declaracao dos comandos de acionamento das rotinas auto-carregaveis de eletrica

(ai_autoload 2000 "c:ai_el_insertmega" "modules/el/kel00c0")


;; declaracao dos comandos de acionamento das rotinas auto-carregaveis de esgoto

(ai_autoload 5000 "c:ai_es_bujao" "modules/es/kes00c0")
(ai_autoload 5001 "c:ai_es_to"    "modules/es/kes01c0")
(ai_autoload 5002 "ai_es_rs45"    "modules/es/kes02c0")
(ai_autoload 5003 "ai_es_rs90"    "modules/es/kes02c0")

(prompt "\n")
(princ)
