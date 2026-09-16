
;;
;; K41C0.lsp
;; Copyright (C) 1995-98 by Luiz Marcio F A Viana, 1/23/98
;;

;; definicao das variaveis globais
(or #PRROT  (setq #PRROT "No") )           ;; rotacao do papel
(or #PRSCL  (setq #PRSCL (* (#SCL) (#UND))) )  ;; escala de impressao

;; dfax_adicionar_item(): funcao que adiciona novos clientes ao arquivo de telefones
(defun dfax_adicionar_item(/ cli tel)

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

;; dfax_adicionar_init(): funcao de inicializacao do quadro de dialogos adicionar
(defun dfax_adicionar_init()
  (action_tile "accept" "(if (dfax_adicionar_item) (done_dialog 1))")
) ; end defun

;; dfax_adicionar(/ itm): funcao que permite adicionar um novo cliente
(defun dfax_adicionar()
  (if (new_dialog "dfax_cadastro" dlgid)
    (progn
      (dfax_adicionar_init)
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

;; dfax_alterar_item(): funcao que altera as informacoes de um cliente no arquivo de telefones
(defun dfax_alterar_item(/ cli tel)

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

;; dfax_alterar_init(): funcao de inicializacao do quadro de dialogos alterar
(defun dfax_alterar_init(/ cli tel)
  (setq
    cli (car (nth phone_index phone_list))
    tel (cdr (nth phone_index phone_list))
  ) ; end setq
  (set_tile "IDC_NOME_CLIENTE" cli)
  (set_tile "IDC_NUMERO_FAX"   tel)

  (action_tile "accept" "(if (dfax_alterar_item) (done_dialog 1))")
) ; end defun

;; dfax_alterar(): funcao que permite alterar as informacoes do cliente no arquivo de telefone
(defun dfax_alterar(/ itm)
  (if phone_list
    (if (new_dialog "dfax_cadastro" dlgid)
      (progn
        (dfax_alterar_init)
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

;; dfax_eliminar_item(): funcao que elimina as informacoes de um cliente do arquivo de telefones
(defun dfax_eliminar_item(/ itm ls itm1)
  (setq
    itm (nth phone_index phone_list)
    ls '()
  ) ; end setq
  (foreach itm1 phone_list (if (not (equal itm itm1)) (setq ls (cons itm1 ls)) ) )
  (setq phone_list (sort ls))
) ; end defun

;; dfax_eliminar_init(): funcao de inicializacao do quadro de dialogos eliminar
(defun dfax_eliminar_init(/ cli)
  (setq cli (car (nth phone_index phone_list)) )
  (set_tile "IDC_MENSAGEM" (strcat "Eliminar as informacoes sobre o cliente: " cli))
  (action_tile "IDC_SIM" "(dfax_eliminar_item)(done_dialog 1)")
  (action_tile "IDC_NAO" "(done_dialog 0)")
) ; end defun

;; dfax_eliminar(): funcao que permite eliminar as informacoes do cliente no arquivo de telefone
(defun dfax_eliminar(/ itm)
  (if phone_list
    (if (new_dialog "dfax_confirmacao" dlgid)
      (progn
        (dfax_eliminar_init)
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

;; dfax_valida_escala(): funcao de validacao da caixa de edicao IDC_ESCALA
(defun dfax_valida_escala(s / rst st n v)
  (setq
    st  "i"
    v   ""
    rst -1
  ) ; end setq

  (while (< rst 0)
    (setq n (substr s 1 1))
    (cond
      ( (= st "i")
        (if (and (>= n "0") (<= n "9"))
          (setq
            v (strcat v n)
            st "1"
          ) ; end setq
          (if (= n ".")
            (setq
              v (strcat v n)
              st "2"
            ) ; end setq
            (setq rst  1)
          ) ; end if
        ) ; end if
      ) ; end case
      ( (= st "1")
        (if (and (>= n "0") (<= n "9"))
          (setq v (strcat v n))
          (if (= n ".")
            (setq
              v (strcat v n)
              st "2"
            ) ; end setq
            (if (= n "")
              (setq rst 0)
              (setq rst 1)
            ) ; end if
          ) ; end if
        ) ; end if
      ) ; end case
      ( (= st "2")
        (if (and (>= n "0") (<= n "9"))
          (setq v (strcat v n))
          (if (= n "")
            (setq rst 0)
            (setq rst 1)
          ) ; end if
        ) ; end if
      ) ; end case
    ) ; end cond
    (setq s (substr s 2))
  ) ; end while
  (if (= rst 0) (atof v) nil)
) ; end defun

;; dfax_discar_getparm(): funcao que obtem os parametros de impressao do quadro parametros da discagem
(defun dfax_discar_getparm(/ dst cli tel fil scl)

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

      (if (= (get_tile "IDC_0") "1")
        (setq #PRROT  "No")
        (setq #PRROT "Yes")
      ) ; end if
      (setq scl (dfax_valida_escala (get_tile "IDC_ESCALA")) )
      (if scl
        (progn
          (setq #PRSCL scl)
          't
        ) ; end progn
        (progn
          (set_tile "error" "ERR: Especificacao de escala invalida.")
          nil
        ) ; end progn
      ) ; end if
    ) ; end progn
    (progn
      (set_tile "error" "ERR: Entrada nula nao e valida.")
      nil
    ) ; end progn
  ) ; end if
) ; end defun

;; dfax_discar_init(): funcao de inicializacao do quadro de dialogo parametros de discagem
(defun dfax_discar_init(/ cli tel)
  (setq
    cli (car (nth phone_index phone_list))
    tel (cdr (nth phone_index phone_list))
  ) ; end setq
  (set_tile "IDC_NOME_CLIENTE" cli)
  (set_tile "IDC_NUMERO_FAX" tel)
  (set_tile "IDC_ESCALA" (rtos #PRSCL 2 2))
  (set_tile "IDC_NOME_ARQUIVO" (getdwgname))
  (if (= #PRROT "No") (set_tile "IDC_0" "1") (set_tile "IDC_90" "1"))
  (action_tile "accept" "(if (dfax_discar_getparm) (done_dialog 1))")
) ; end defun

;; dfax_discar(): funcao de definicao dos parametros de discagem e transmissao do fax
(defun dfax_discar(/ rst)
  (setq rst nil)
  (if phone_list
    (if (new_dialog "dfax_discagem" dlgid)
      (progn
        (dfax_discar_init)
        (if (> (start_dialog) 0) (setq rst 't))
      ) ; end progn
      (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
    ) ; end if
    (set_tile "error" "ERR: Nao existe nenhum destinatario definido.")
  ) ; end if
  rst
) ; end defun

;; dfax_phonelist(): funcao que retorna uma lista com o conteudo do arquivo de telefone
(defun dfax_phonelist(/ fn f cli tel ls)
  (setq
    fn (V:APPL "phone.lst")
    ls '()
  ) ; end setq
  (if (findfile fn)
    (progn
      (setq f (open fn "r"))
      (while (setq s (read-line f))
        (setq
          cli (substr (strpiece s 1 "#") 1 30)
          tel (strpiece s 2 "#")
        ) ; end setq
        (setq ls (cons (cons cli tel) ls))
      ) ; end while
      (setq f (close f))
    ) ; end progn
  ) ; end if

  (sort ls)
) ; end defun

;; dfax_updatelist(): funcao que retorna uma lista com o conteudo do arquivo de telefone
(defun dfax_updatelist(/ fn f itm)
  (setq fn (V:APPL "phone.lst"))
  (setq f (open fn "w"))
  (foreach itm phone_list (write-line (strcat (car itm) "#" (cdr itm)) f) )
  (setq f (close f))
) ; end defun

;; dfax_seleciona(): funcao que modifica o valor do ponteiro de selecao da lista
(defun dfax_seleciona() (setq phone_index (atoi (get_tile "IDC_LISTA_CLIENTES"))) )

;; dfax_init(): funcao de inicializacao do quadro de dialogo
(defun dfax_init(/ itm)

  (if (setq phone_list (dfax_phonelist))
    (progn
      (start_list "IDC_LISTA_CLIENTES")
      (foreach itm phone_list (add_list (strcat (car itm) "\t" (cdr itm))) )
      (end_list)
    ) ; end progn
  ) ; end if

  (setq phone_index 0)
  (set_tile "IDC_LISTA_CLIENTES" (itoa phone_index))

  (action_tile "IDC_LISTA_CLIENTES" "(dfax_seleciona)")

  (action_tile "IDC_ADICIONAR"     "(dfax_adicionar)")
  (action_tile "IDC_ALTERAR"       "(dfax_alterar)" )
  (action_tile "IDC_ELIMINAR"      "(dfax_eliminar)")
  (action_tile "IDC_DISCAR"        "(if (dfax_discar) (done_dialog 2))")
) ; end defun

;; dfax_process(): funcao de processamento do comando
(defun dfax_process(/ oldech LARG ALT CFAT pt1 fat deltax deltay olddrag oldhigh oldblip enm1 pt pta ptb fn)
  (setq oldech (acadvar "cmdecho" 0))

  (setq
    LARG (*  8.5 25.4)
    ALT  (* 11.0 25.4)
  ) ; end setq

  (setq CFAT (/ 850.0 215.9))    ;; fator de transformacao dpi -> dpmm

  (setq pt1 (cadr (grread T)) )

  (setq fat (/ #PRSCL (#UND)))
  (if (= #PRROT "Yes")
    (setq
      deltax (/ (* ALT  fat) 2.0)
      deltay (/ (* LARG fat) 2.0)
    ) ; end setq
    (setq
      deltax (/ (* LARG fat) 2.0)
      deltay (/ (* ALT  fat) 2.0)
    ) ; end setq
  ) ; end if

  (setq
    olddrag (acadvar "dragmode"  2)
    oldhigh (acadvar "highlight" 0)
    oldblip (acadvar "blipmode"  0)
  ) ; end setq

  (setq cnivel (slay "$FAX"))

  (command
    "pline"
      (list (- (car pt1) deltax) (- (cadr pt1) deltay)) "w" 0 ""
      (list (+ (car pt1) deltax) (- (cadr pt1) deltay))
      (list (+ (car pt1) deltax) (+ (cadr pt1) deltay))
      (list (- (car pt1) deltax) (+ (cadr pt1) deltay))
      "c"
    "move" (setq enm1 (entlast)) "" pt1
  ) ; end command
  (redraw enm1 2)

  (prompt "\nSelecione a area de impressao...")
  (command pause "erase" enm1 "")

  (setvar "dragmode"  olddrag)
  (setvar "highlight" oldhigh)
  (setvar "blipmode"  oldblip)

  (slay cnivel)

  (setq pt (getvar "lastpoint"))
  (setq
    pta (list (- (car pt) deltax) (- (cadr pt) deltay))
    ptb (list (+ (car pt) deltax) (+ (cadr pt) deltay))
  ) ; end setq

  (setvar "cmdecho" 1)

  (setvar "plotid" "fax")
  (command
    ".plot"
      "Window"
      (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6))
      (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6))
      "5"
      "Yes"
      "Fax"
      "Window"
      (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6))
      (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6))
      "5"
      "No"
      "1"
      "1"
      "n"
      "I"
      "0,0"
      "Max"
  ) ; end command
  (if (= #PRROT "No") (command "0") (command "90"))
  (command
      "No"
      (strcat (rtos CFAT 2 6) "=" (rtos fat 2 6))
      "0"
      "No"
  ) ; end command

  (setq fn (V:SPOOL (strcat "FAX\\" nome_arquivo)) )
;  (if (findfile (strcat fn ".bmp"))
;    (command fn "Yes")
  (command fn)
;  ) ; end if

  (command
    ".shell"
    (strcat "dfax " fn " " nome_destinatario " " nome_cliente " " numero_fax " " #USR)
  ) ; end command

  (setvar "cmdecho" oldech)
)

;; c:dfax(): rotina para envio de fax com selecao dinamica da area de impressao
(defun c:dfax(/ dlgid rst phone_list phone_index nome_destinatario nome_cliente numero_fax nome_arquivo)
  (m:savevars)

  (if (> (setq dlgid (load_dialog (V:AIL "k41c0"))) 0)
    (progn
      (if (new_dialog "dfax" dlgid)
        (progn
          (dfax_init)
          (if (> (setq rst (start_dialog)) 1)
            (if (= rst 2) (dfax_process))
            (if (= rst 1) (dfax_updatelist) )
          ) ; end if
        ) ; end progn
        (prompt "\nERR: Nao foi possivel apresentar o dialogo.")
      ) ; end if
      (unload_dialog dlgid)
    ) ; end progn
    (prompt "\nERR: Nao foi possivel abrir o arquivo de dialogo.")
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

(princ)
