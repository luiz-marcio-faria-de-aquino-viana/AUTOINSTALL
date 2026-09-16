;                                F A X (R)
;   ________________________________________________________________________
;         Copyright (C) 1994 by TML Software, Inc. All Rights Reserved.


;    THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
;    ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR PURPOSE AND OF
;    MERCHANTABILITY ARE HEREBY DISCLAIMED.
;   ________________________________________________________________________


;    DESCRIPTION:

;    LISP FAX application - by Luiz Marcio Viana - 3/22/95


(defun pad(s n)
  (repeat (- n (strlen s)) (setq s (strcat s " ")))
) ; end function

(defun strip(s / cnt flg)
  (setq flg nil)
  (setq cnt (strlen s))
  (while (and (null flg) (not (zerop cnt)))
    (if (/= (substr s cnt 1) " ") (setq flg t))
    (setq cnt (- cnt 1))
  ) ; end while
  (substr s 1 (+ cnt 1))
) ; end defun

(defun phone_add(customer_name phone_number / data_read src_file dst_file)
  (setq src_file (open (strcat (getenv "ACADLOG") "phone.lst") "r"))
  (setq dst_file (open (strcat (getenv "ACADLOG") "phone.$t$") "w"))
  (while (and (setq data_read (read-line src_file))
              (< (substr data_read 1 40) customer_name) 
         ) ; end and
    (write-line data_read dst_file)
  ) ; end while
  (write-line (strcat (pad customer_name 40) " " phone_number) dst_file)
  (while data_read
    (write-line data_read dst_file)
    (setq data_read (read-line src_file))
  ) ; end while
  (close src_file);
  (close dst_file);
) ; end function

(defun phone_sub(reg / data_read src_file dst_file)
  (setq src_file (open (strcat (getenv "ACADLOG") "phone.lst") "r"))
  (setq dst_file (open (strcat (getenv "ACADLOG") "phone.$t$") "w"))
  (while (setq data_read (read-line src_file))
    (setq reg (- reg 1))
    (if (not (zerop reg)) (write-line data_read dst_file) )
  ) ; end while
  (close src_file)
  (close dst_file)
) ; end function

(defun phone_chg(reg customer_number phone_number / data_read src_file dst_file)
  (setq src_file (open (strcat (getenv "ACADLOG") "phone.lst") "r"))
  (setq dst_file (open (strcat (getenv "ACADLOG") "phone.$t$") "w"))
  (while (and (setq data_read (read-line src_file))
              (< (substr data_read 1 40) customer_name)
         ) ; end and
    (setq reg (- reg 1))
    (if (not (zerop reg)) (write-line data_read dst_file))
  ) ; end while
  (write-line (strcat (pad customer_name 40) " " phone_number) dst_file)
  (while data_read
    (setq reg (- reg 1))
    (if (not (zerop reg)) (write-line data_read dst_file)) 
    (setq data_read (read-line src_file))
  ) ; end while
  (close src_file);
  (close dst_file);
) ; end function

(defun phone_read(reg / flag data_read src_file)
  (setq flag nil)
  (setq src_file (open (strcat (getenv "ACADLOG") "phone.lst") "r"))
  (while (and (null flag) (setq data_read (read-line src_file)))
    (setq reg (- reg 1))
    (setq flag (zerop reg))
  ) ; end while
  (close src_file)
  (if (zerop reg) data_read nil)
) ; end function

(defun phone_list(/ cnt flag data_read src_file)
  (textscr)
  (prompt "\e[2J")
  (prompt " REG#              NOME DO CLIENTE                       FAX#        \n")
  (prompt "------ ---------------------------------------- --------------------\n")

  (setq cnt 1)
  (setq flag nil)

  (setq src_file (open (strcat (getenv "ACADLOG") "phone.lst") "r"))
  (while (and (null flag) (setq data_read (read-line src_file)))
    (prompt (strcat " #" (pad (itoa cnt) 4) " " data_read "\n"))
    (if (zerop (rem cnt 20))
        (if (null (setq flag (= (strcase (getstring "\n* (P) Para/(ENTER) Continua...")) "P")))
          (progn
            (prompt "\e[2J")
            (prompt " REG#              NOME DO CLIENTE                       FAX#        \n")
            (prompt "------ ---------------------------------------- --------------------\n")
          ) ; end progn
        ) ; end if
    ) ; end if    
    (setq cnt (+ cnt 1))
  ) ; end while
) ; end function

(defun c:fax()

  (setvar "cmdecho" 0)

  (defun *error*(msg)
    (prompt msg)
    (setvar "blipmode" 1)
    (setvar "highlight" 1)
    (setq *error* nil)
    (princ)
  )

  (phone_list)

  (setq flag nil)
  (while (null flag)
    (initget "Adicionar Eliminar Trocar Listar Discar")
    (setq opt (getkword "\nSelecione (A)dicionar/(E)liminar/(T)rocar/(L)istar/<(D)iscar>: "))
    (cond
      ((= opt "Adicionar") 
        (progn
          (while (= (setq customer_name (getstring t "\nNome do cliente: ")) "")
            (prompt "\n* ERROR * O nome do cliente nao foi informado.")
          ) ; end while
          (while (= (setq phone_number (getstring t "\nNumero do fax: ")) "")
            (prompt "\n* ERROR * O numero do fax nao foi informado.")
          ) ; end while
          (phone_add customer_name phone_number)
          (command "phone")
        ) ; end progn
      ) ; end case
      ((= opt "Eliminar") 
        (progn
          (initget 7)
          (setq rec_number (getint "\nNumero do registro: ")) 
          (phone_sub rec_number)
          (command "phone")
        ) ; end progn
      ) ; end case
      ((= opt "Trocar") 
        (progn
          (initget 7)
          (setq rec_number (getint "\nNumero do registro: ")) 
          (while (= (setq customer_name (getstring t "\nNome do cliente: ")) "")
            (prompt "\n* ERROR * O nome do cliente nao foi informado.")
          ) ; end while
          (while (= (setq phone_number (getstring t "\nNumero do fax: ")) "")
            (prompt "\n* ERROR * O numero do fax nao foi informado.")
          ) ; end while
          (phone_chg rec_number customer_name phone_number)
          (command "phone")
        ) ; end progn
      ) ; end case
      ((= opt "Listar") (phone_list))
      ((= opt "Discar") (setq flag t))
    ) ; end cond
  ) ;  end while

  (initget 7 "Telefone")
  (setq rec_number (getint "\n<Numero do registro>/(T)elefone: "))
  (if (= rec_number "Telefone")
    (progn
      (setq customer_name (chchar (getstring t "\nNome do cliente: ") " " "_"))
      (setq dest_name (chchar (getstring t "\nNome do destinatario: ") " " "_"))
      (while (= (setq faxn (getstring t "\nNumero do fax: ")) "")
        (prompt "\n* ERROR * O numero do fax nao foi informado.")
      ) ; end while
    ) ; end progn
    (progn
      (setq dest_name (chchar (getstring t "\nNome do destinatario: ") " " "_"))
      (setq rec_read (phone_read rec_number))
      (setq customer_name (chchar (strip (substr rec_read 1 41)) " " "_"))
      (setq faxn (substr rec_read 42 20))
    ) ; end progn
  ) ; end if

  (setq nm (getstring (strcat "\nNome do arquivo <" (getdwgname) ">: ")))
  (if (/= nm "")
    (setq fname (strcat "C:\\SPOOL\\FAX\\" nm))
    (setq fname (strcat "C:\\SPOOL\\FAX\\" (setq nm (getdwgname))))
  ) ; end if

  (command "shell" (strcat "fax " nm " " faxn " " customer_name " " dest_name) )

  (setq *error* nil)
  (princ)
)
(princ)
