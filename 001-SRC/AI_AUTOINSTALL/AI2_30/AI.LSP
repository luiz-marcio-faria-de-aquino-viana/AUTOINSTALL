
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

(autoload  1 "c:inserir" "k0bc0")

(autoload  2 "c:brkins"  "k71c0")

(autoload  3 "c:insert2" "k0cc0")

(autoload  4 "c:insert3" "k0dc0")

(autoload  5 "c:uinsert" "k30c0")

(autoload  6 "c:setlum" "K6ac0")

(autoload  7 "c:eattmov" "k31c0")

(autoload  8 "c:esetorg" "k31c0")

(autoload  9 "c:esetcol" "k31c0")

(autoload 10 "c:echcirc" "k34c0")

(autoload 11 "c:echcmd" "k34c0")

(autoload 12 "c:eerase" "k31c0")

(autoload 13 "c:elist" "k31c0")

(autoload 14 "c:emirror" "k31c0")

(autoload 15 "c:ecopy" "k31c0")

(autoload 16 "c:fiacao" "k33c0")

(autoload 17 "c:echorg" "k34c0")

(autoload 18 "c:epckorg" "k34c0")

(autoload 19 "c:epckcirc" "k34c0")

(autoload 20 "c:epckcmd" "k34c0")

(autoload 21 "c:lumembt" "k4cc0")

(autoload 22 "c:lumsobr" "k4cc0")

(autoload 23 "c:lumpend" "k4cc0")

(autoload 24 "c:pscar" "k4bc0")

(autoload 25 "c:psmarg" "k4bc0")

(autoload 26 "c:pswin" "k4bc0")

(autoload 27 "c:carimbo" "k02c0")

(autoload 28 "c:i_indic" "k5dc0")

(autoload 29 "c:esgtb" "k68c0")

(autoload 30 "c:esgin" "k69c0")

(autoload 31 "c:cx" "k08c0")

(autoload 32 "c:circuito" "k04c0")

(autoload 33 "c:gbox" "k23c0")

(autoload 34 "c:cxd" "k24c0")

(autoload 35 "c:torre" "k2bc0")

(autoload 36 "c:mq2s" "k2ac0")

(autoload 37 "c:mq1s" "k29c0")

(autoload 38 "c:barrane" "k70c0")

(autoload 39 "c:eqdrq" "k35c0")

(autoload 40 "c:htub" "k73c0")

(autoload 41 "c:lismat" "k74c0")

(autoload 42 "c:isoblk" "k75c0")

(autoload 43 "c:eadjuste" "k77c0")

(autoload 44 "c:hinsert" "k78c0")

(autoload 45 "c:detblk" "k79c0")

(autoload 46 "c:cd" "k7ac0")

(autoload 47 "c:ctd" "k7ac0")

(autoload 48 "c:cttd" "k7ac0")

(autoload 49 "c:offchg" "k58c0")

(autoload 50 "c:ap_etpproj" "k7cc0")

(autoload 51 "c:edt" "k6bc0")

(autoload 52 "c:emkclh" "k6dc0")

(autoload 53 "c:emkobj" "k6ec0")

(autoload 54 "c:everdt" "k76c0")

(autoload 55 "c:ecpatt" "k6fc0")

(autoload 56 "c:echblk" "k7dc0")

(autoload 57 "c:echdt" "k7ec0")

(autoload 58 "c:einsobj" "k80c0")

(autoload 59 "c:eqpot" "k7fc0")

(autoload 60 "c:colblk" "k8fc0")

(autoload 61 "c:copyrot" "k90c0")

(autoload 62 "c:blexpl" "k91c0")

(autoload 63 "c:sol2hat" "k92c0")

(autoload 64 "c:ff_fiacao" "kffc0")

(autoload 65 "c:ff_byblock" "kffc0")

(autoload 66 "c:ff_bdel" "kffc0")

(autoload 67 "c:ff_bchl" "kffc0")

(autoload 68 "c:ad_insert" "k95c0")

(autoload 69 "c:ff_sf" "kffc0")

(prompt "\n")
(princ)
