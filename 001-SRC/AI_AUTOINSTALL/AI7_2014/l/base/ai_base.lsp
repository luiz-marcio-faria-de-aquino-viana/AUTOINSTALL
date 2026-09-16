
;;
;; AI_BASE.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 1/6/2000
;;

;; ai_svar(): funcao que atribui um novo valor a uma variavel de ambiente
;; acvar - nome da variavel de sistema
;; acval - novo valor para a variavel de sistema
(defun ai_svar(acvar acval / acold)
  (setq acold (getvar acvar))
  (setvar acvar acval)
  acold
) ; end defun

;; ai_loadf(): funcao de carga das rotinas
;; arqv - nome do arquivo a ser carregado
(defun ai_loadf(arqv / cnt tmp dat)
  (setq arqv (V:AIL arqv))
  (cond
    ( (findfile (strcat arqv ".lsp")) (load (strcat arqv ".lsp")) )
    ( (findfile (strcat arqv ".ls1")) (load (strcat arqv ".ls1")) )
    ( (findfile (strcat arqv ".crt"))
      (progn
        (setq
          cnt 0
          tmp ""
        ) ; end setq
        (while (/= (setq dat (aci_xloadf (strcat arqv ".crt") cnt)) "")
            (setq tmp (strcat tmp dat))
            (setq cnt (+ cnt (strlen dat)))
        ) ; end while
        (eval (read tmp))
      ) ; end progn
    ) ; end case
    ( (ai_errmsg AI_ERR_FILENOTFOUND) )
  ) ; end if
) ; end defun

;; ai_autoload(): funcao para carregamento das rotinas sob demanda
;; id - identificador da rotina auto-carregavel
;; cm - comando de acionamento da funcao de auto-carregamento
;; ff - nome do arquivo a ser carregado durante o acionamento
(defun ai_autoload (id cm ff / s)
  (setq s (strcat
            "(defun " cm "()"
            "(princ \"\nInicializando...\")"
            "(ai_loadf \"" ff "\")"
            "(" cm ")"
            "(princ))"
          ) ; end strcat
  ) ; end read
  (eval (read s))
  (prompt (strcat "." (itoa id)))
)

;; ai_mon(): funcao para monitoracao das rotinas
;; ai_mon_flg - sinalizador ('t=efetuar uma pausa apos cada atualizacao de tela/nil=nao efetuar pausa)
;; ai_mon_lst - lista de variaveis para monitoracao
(defun ai_mon(ai_mon_flg ai_mon_lst / ai_mon_itm)
  (foreach ai_mon_itm ai_mon_lst
    (prompt (strcat "\n" ai_mon_itm "=")) (princ (eval (read ai_mon_itm)))
  ) ; end foreach
  (if ai_mon_flg (getstring "\n= ENTER =========================================="))
) ; end defun

;; ai_getfilename(): funcao que retorna o nome do arquivo a partir do seu caminho completo
;; ff - nome completo do arquivo
(defun ai_getfilename(ff / cnt)
  (setq cnt (strlen ff))
  (while (and (> cnt 0) (/= (substr ff cnt 1) "\\") (/= (substr ff cnt 1)  "/")) (setq cnt (1- cnt)))
  (if (zerop cnt) ff (substr ff (1+ cnt)) )
) ; end defun

;; ai_insert(): funcao para insercao de blocos no desenho
;; ffblk - caminho completo do bloco
;; pti - ponto de insercao do bloco
;; scl - escala do bloco
;; rot - rotacao do bloco
(defun ai_insert(ffblk pti scl rot / blk)
  (setq blk (ai_getfilename ffblk))
  (if (tblsearch "block" blk)
    (command ".insert" blk pti scl scl (angtos rot))
    (command ".insert" ffblk pti scl scl (angtos rot))
  ) ; end if
) ; end defun

;; ai_insertpt(): funcao para insercao de blocos no desenho com rotacao fornecida por um ponto
;; ffblk - caminho completo do bloco
;; pti - ponto de insercao do bloco
;; scl - escala do bloco
;; ptd - ponto que define a direcao do bloco
(defun ai_insertpt(ffblk pti scl ptd / blk)
  (setq blk (ai_getfilename ffblk))
  (if (tblsearch "block" blk)
    (command ".insert" blk pti scl scl ptd)
    (command ".insert" ffblk pti scl scl ptd)
  ) ; end if
) ; end defun

;; ai_toggle_ucsicon(): funcao para habilitar e desabilitar a variavel 'ucsicon'
(defun ai_toggle_ucsicon()
  (if (= (getvar "ucsicon") 0)
    (command ".ucsicon" "on")
    (command ".ucsicon" "off")
  ) ; end if
  (princ)
) ; end defun

(princ)
