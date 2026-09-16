
;;
;; BASE.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 11/24/97
;;

;;
;; carga das rotinas utilitarias base do programa
;;

(loadf "k20c0")                 ;; utilitarios variados

(loadf "k86c0")                 ;; utilitarios para arquivos com campos delimitados

(loadf "k2fc0")                 ;; utilitarios para atributos
(loadf "k6cc0")                 ;; utilitarios para extended entity data

(loadf "k03c0")                 ;; utilitarios para edicao de textos

(loadf "k36c0")                 ;; utilitarios para depuracao

(loadf "k51c0")                 ;; utilitario para carga de xref
(loadf "k55c0")                 ;; utilitario para ajuste de xref
;; (loadf "k60c0")                 ;; utilitario para descarga de xref

(loadf "k4Ec0")                 ;; utilitario para criacao das camadas
(loadf "k1cc0")                 ;; utilitario para ativar/desativar camadas

;;
;; carga das rotinas de controle de acesso do programa
;;

;; (loadf "k47c0")                 ;; assegura exclusao mutua
(loadf "k26c0")                 ;; gerenciamento de acesso
;; (loadf "k27c0")                 ;; visualizador do registro de acesso
(loadf "k65c0")                 ;; atualizacao dos atributos de revisao

;;
;; carga das rotinas de redefinicao de comandos do AutoCAD
;;

;; (loadf "k81c0")                  ;; redefinicao dos comandos do AutoCAD

(princ)
