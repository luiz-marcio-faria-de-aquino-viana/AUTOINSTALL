
;;
;; K42C0.lsp
;; Copyright (C) 1995-98 by Luiz Marcio F A Viana, 2/6/98
;;

;; fax_adicionar_item(): funcao que adiciona novos clientes ao arquivo de telefones
(defun fax_adicionar_item(/ cli tel)

  (setq
    cli (strcase (get_tile "IDC_NOME_CLIENTE"))
    tel (strcase (get_tile "IDC_NUMERO_FAX"))
  ) ; end setq

  (if (and (not (strnull cli)) (not (strnull tel)) )
    (progn
      (setq phone_list (sort (cons (cons cli tel) phone_list)) )
      't
    ) ; end progn
    (progn
      (set_tile "error" "ERR: Informacoes incompletas para cadastro.")
      nil
    ) ; end progn
  ) ; end if

) ; end defun

;; fax_adicionar_init(): funcao de inicializacao do quadro de dialogos adicionar
(defun fax_adicionar_init()
  (action_tile "accept" "(if (fax_adicionar_item) (done_dialog 1))")
) ; end defun

;; fax_adicionar(/ itm): funcao que permite adicionar um novo cliente
(defun fax_adicionar()
  (if (new_dialog "fax_cadastro" dlgid)
    (progn
      (fax_adicionar_init)
      (if (> (start_dialog) 0)
        (progn
          (start_list "IDC_LISTA_CLIENTES")
          (foreach itm phone_list (add_list (strcat (car itm) "\t" (cdr itm))) )
          (end_list)
          (setq phone_index 0)
        ) ; end progn
      ) ; end if
      (set_tile "IDC_LISTA_CLIENTES" (itoa phone_index))
    ) ; end progn
    (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
  ) ; end if
) ; end defun

;; fax_alterar_item(): funcao que altera as informacoes de um cliente no arquivo de telefones
(defun fax_alterar_item(/ cli tel)

  (setq
    cli (strcase (get_tile "IDC_NOME_CLIENTE"))
    tel (strcase (get_tile "IDC_NUMERO_FAX"))
  ) ; end setq

  (if (and (not (strnull cli)) (not (strnull tel)) )
    (progn
      (setq phone_list (sort (subst (cons cli tel) (nth phone_index phone_list) phone_list)) )
      't
    ) ; end progn
    (progn
      (set_tile "error" "ERR: Entrada nula nao e valida.")
      nil
    ) ; end progn
  ) ; end if

) ; end defun

;; fax_alterar_init(): funcao de inicializacao do quadro de dialogos alterar
(defun fax_alterar_init(/ cli tel)
  (setq
    cli (car (nth phone_index phone_list))
    tel (cdr (nth phone_index phone_list))
  ) ; end setq
  (set_tile "IDC_NOME_CLIENTE" cli)
  (set_tile "IDC_NUMERO_FAX"   tel)

  (action_tile "accept" "(if (fax_alterar_item) (done_dialog 1))")
) ; end defun

;; fax_alterar(): funcao que permite alterar as informacoes do cliente no arquivo de telefone
(defun fax_alterar(/ itm)
  (if phone_list
    (if (new_dialog "fax_cadastro" dlgid)
      (progn
        (fax_alterar_init)
        (if (> (start_dialog) 0)
          (progn
            (start_list "IDC_LISTA_CLIENTES")
            (foreach itm phone_list (add_list (strcat (car itm) "\t" (cdr itm))) )
            (end_list)
            (setq phone_index 0)
          ) ; end progn
        ) ; end if
        (set_tile "IDC_LISTA_CLIENTES" (itoa phone_index))
      ) ; end progn
      (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
    ) ; end if
    (set_tile "error" "ERR: A lista de telefone dos clientes esta vazia.")
  ) ; end if
) ; end defun

;; fax_eliminar_item(): funcao que elimina as informacoes de um cliente do arquivo de telefones
(defun fax_eliminar_item(/ itm ls itm1)
  (setq
    itm (nth phone_index phone_list)
    ls '()
  ) ; end setq
  (foreach itm1 phone_list (if (not (equal itm itm1)) (setq ls (cons itm1 ls)) ) )
  (setq phone_list (sort ls))
) ; end defun

;; fax_eliminar_init(): funcao de inicializacao do quadro de dialogos eliminar
(defun fax_eliminar_init(/ cli)
  (setq cli (car (nth phone_index phone_list)) )
  (set_tile "IDC_MENSAGEM" (strcat "Eliminar as informacoes sobre o cliente: " cli))
  (action_tile "IDC_SIM" "(fax_eliminar_item)(done_dialog 1)")
  (action_tile "IDC_NAO" "(done_dialog 0)")
) ; end defun

;; fax_eliminar(): funcao que permite eliminar as informacoes do cliente no arquivo de telefone
(defun fax_eliminar(/ itm)
  (if phone_list
    (if (new_dialog "fax_confirmacao" dlgid)
      (progn
        (fax_eliminar_init)
        (if (> (start_dialog) 0)
          (progn
            (start_list "IDC_LISTA_CLIENTES")
            (foreach itm phone_list (add_list (strcat (car itm) "\t" (cdr itm))) )
            (end_list)
            (setq phone_index 0)
          ) ; end progn
        ) ; end if
        (set_tile "IDC_LISTA_CLIENTES" (itoa phone_index))
      ) ; end progn
      (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
    ) ; end if
    (set_tile "error" "ERR: A lista de telefone dos clientes esta vazia.")
  ) ; end if
) ; end defun

;; fax_discar_getparm(): funcao que obtem os parametros de impressao do quadro parametros da discagem
(defun fax_discar_getparm(/ dst cli tel)
  (setq
    dst (get_tile "IDC_DESTINATARIO")
    cli (get_tile "IDC_NOME_CLIENTE")
    tel (get_tile "IDC_NUMERO_FAX")
    fil (get_tile "IDC_NOME_ARQUIVO")
  ) ; end setq

  (if (and (not (strnull cli))
           (not (strnull tel))
           (not (strnull fil)) )
    (progn
      (setq
        nome_destinatario (strcase (chchar dst " " "_"))
        nome_cliente      (strcase (chchar cli " " "_"))
        numero_fax        (strcase (chchar tel " " "-"))
        nome_arquivo      fil
      ) ; end setq
      't
    ) ; end progn
    (progn
      (set_tile "error" "ERR: Entrada nula nao e valida.")
      nil
    ) ; end progn
  ) ; end if
) ; end defun

;; fax_discar_select(): funcao de selecao do arquivo de fax
(defun fax_discar_select(/ fil)
  (if (setq fil (getfiled "Select a Fax File" (V:SPOOL "FAX\\") "qfx" 2))
    (set_tile "IDC_NOME_ARQUIVO" (getfilename fil))
  ) ; end if
) ; end defun

;; fax_discar_init(): funcao de inicializacao do quadro de dialogo parametros de discagem
(defun fax_discar_init(/ cli tel)
  (setq
    cli (car (nth phone_index phone_list))
    tel (cdr (nth phone_index phone_list))
  ) ; end setq
  (set_tile "IDC_NOME_CLIENTE" cli)
  (set_tile "IDC_NUMERO_FAX" tel)
  (set_tile "IDC_NOME_ARQUIVO" (strcat (getdwgname) ".qfx"))
  (action_tile "IDC_SELECT_FILE" "(fax_discar_select)")
  (action_tile "accept" "(if (fax_discar_getparm) (done_dialog 1))")
) ; end defun

;; fax_discar(): funcao de definicao dos parametros de discagem e transmissao do fax
(defun fax_discar(/ rst)
  (setq rst nil)
  (if phone_list
    (if (new_dialog "fax_discagem" dlgid)
      (progn
        (fax_discar_init)
        (if (> (start_dialog) 0) (setq rst 't))
      ) ; end progn
      (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
    ) ; end if
    (set_tile "error" "ERR: Nao existe nenhum destinatario definido.")
  ) ; end if
  rst
) ; end defun

;; fax_phonelist(): funcao que retorna uma lista com o conteudo do arquivo de telefone
(defun fax_phonelist(/ fn f cli tel ls)
  (setq
    fn (V:APPL "phone.lst")
    ls '()
  ) ; end setq
  (if (findfile fn)
    (progn
      (setq f (open fn "r"))
      (while (setq s (read-line f))
        (setq
          cli (strpiece s 1 "#")
          tel (strpiece s 2 "#")
        ) ; end setq
        (setq ls (cons (cons cli tel) ls))
      ) ; end while
      (setq f (close f))
    ) ; end progn
  ) ; end if

  (sort ls)
) ; end defun

;; fax_updatelist(): funcao que retorna uma lista com o conteudo do arquivo de telefone
(defun fax_updatelist(/ fn f itm)
  (setq fn (V:APPL "phone.lst"))
  (setq f (open fn "w"))
  (foreach itm phone_list (write-line (strcat (car itm) "#" (cdr itm)) f) )
  (setq f (close f))
) ; end defun

;; fax_seleciona(): funcao que modifica o valor do ponteiro de selecao da lista
(defun fax_seleciona() (setq phone_index (atoi (get_tile "IDC_LISTA_CLIENTES"))) )

;; fax_init(): funcao de inicializacao do quadro de dialogo
(defun fax_init(/ itm)

  (if (setq phone_list (fax_phonelist))
    (progn
      (start_list "IDC_LISTA_CLIENTES")
      (foreach itm phone_list (add_list (strcat (car itm) "\t" (cdr itm))) )
      (end_list)
    ) ; end progn
  ) ; end if

  (setq phone_index 0)
  (set_tile "IDC_LISTA_CLIENTES" (itoa phone_index))

  (action_tile "IDC_LISTA_CLIENTES" "(fax_seleciona)")

  (action_tile "IDC_ADICIONAR"     "(fax_adicionar)")
  (action_tile "IDC_ALTERAR"       "(fax_alterar)" )
  (action_tile "IDC_ELIMINAR"      "(fax_eliminar)")
  (action_tile "IDC_DISCAR"        "(if (fax_discar) (done_dialog 2))")
) ; end defun

;; c:fax(): rotina para envio de fax com selecao dinamica da area de impressao
(defun c:fax(/ dlgid rst phone_list phone_index nome_destinatario nome_cliente numero_fax nome_arquivo)
  (if (> (setq dlgid (load_dialog (V:AIL "k42c0"))) 0)
    (progn
      (if (new_dialog "fax" dlgid)
        (progn
          (fax_init)
          (if (> (setq rst (start_dialog)) 1)
            (command
              ".shell"
              (strcat "fax " (V:SPOOL (strcat "FAX\\" nome_arquivo)) " " nome_destinatario " " nome_cliente " " numero_fax " " #USR)
            ) ; end command
            (if (= rst 1) (fax_updatelist) )
          ) ; end if
        ) ; end progn
        (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
      ) ; end if
      (unload_dialog dlgid)
    ) ; end progn
    (prompt "\nERR: Nao foi possivel abrir o arquivo de dialogo.")
  ) ; end if
  (princ)
) ; end defun

(princ)
