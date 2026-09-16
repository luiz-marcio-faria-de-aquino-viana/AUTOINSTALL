;                                dF A X (R)
;   ________________________________________________________________________
;         Copyright (C) 1994 by TML Software, Inc. All Rights Reserved.


;    THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
;    ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR PURPOSE AND OF
;    MERCHANTABILITY ARE HEREBY DISCLAIMED.
;   ________________________________________________________________________


;    DESCRIPTION:

;    LISP dFAX application - by Luiz Marcio Viana - 2/20/95


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

(defun c:dfax()

  (setvar "cmdecho" 0)

  (defun *error*(msg)
    (prompt msg)
    (setvar "blipmode" 1)
    (setvar "highlight" 1)
    (setq *error* nil)
    (princ)
  )

  (setq
    NROT "0"
    YROT "90"
  )

  (setq
    LARG 210.0
    ALT 279.0
  )

  (setq FAT (/ 100.0 180.0))    ;; 180dpi to 100dpi

  (or #prrot (setq
               #prrot "No"
  )          )
  (or #prscl (setq
               #prscl (* #scl #und)
  )          )

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

  (initget "Yes No")
  (setq rot (getkword (strcat "\nRodar desenho de 90d <" #prrot ">: ")) )
  (if rot (setq #prrot rot))

  (initget 2)
  (setq
    scl (getdist
          (strcat "\nEscala para impressao 1/<" (rtos #prscl 2 2) ">: ")
  )     )
  (if scl (setq #prscl scl))

  (setq nm (getstring (strcat "\nNome do arquivo <" (getdwgname) ">: ")))
  (if (/= nm "")
    (setq fname (strcat "C:\\SPOOL\\FAX\\" nm))
    (setq fname (strcat "C:\\SPOOL\\FAX\\" (setq nm (getdwgname))))
  ) ; end if

  (setq
    pt1 (cadr (grread T))
  )

  (if (= #prrot "Yes")
    (setq
      deltax (/ (* ALT (/ #prscl #und)) 2.0)
      deltay (/ (* LARG (/ #prscl #und)) 2.0)
    )
    (setq
      deltax (/ (* LARG (/ #prscl #und)) 2.0)
      deltay (/ (* ALT (/ #prscl #und)) 2.0)
    )
  )

  (setq
    drmode (getvar "dragmode")
  )
  (setvar "dragmode" 2)

  (setvar "highlight" 0)
  (setvar "blipmode" 0)

  (setq
    cnivel (getvar "clayer")
  )
  (if (tblsearch "layer" "_DFAX_")
    (command "layer" "t" "_DFAX_" "m" "_DFAX_" "")
    (command "layer" "m" "_DFAX_" "")
  )

  (command
    "pline" (list
              (- (car pt1) deltax)
              (- (cadr pt1) deltay)
            )
            "w" 0 ""
            (list
              (+ (car pt1) deltax)
              (- (cadr pt1) deltay)
            )
            (list
              (+ (car pt1) deltax)
              (+ (cadr pt1) deltay)
            )
            (list
              (- (car pt1) deltax)
              (+ (cadr pt1) deltay)
            )
            "c"
    "move" (setq
             ent1 (ssget "l")
           )
           "" pt1
  )
  (redraw (ssname ent1 0) 2)
  (prompt "\n--- Selecione area para o fax ---\n")
  (command
            pause
    "erase" ent1 ""
  )

  (command
    "layer" "s" cnivel ""
  )

  (setvar "highlight" 1)
  (setvar "blipmode" 1)

  (setvar "dragmode" drmode)

  (setq
    pta (list
          (- (car (getvar "lastpoint")) deltax)
          (- (cadr (getvar "lastpoint")) deltay)
        )
    ptb (list
          (+ (car (getvar "lastpoint")) deltax)
          (+ (cadr (getvar "lastpoint")) deltay)
        )
  )

  (setq file (open (V:APPL "dfax.scr") "w"))

    (write-line "PRplot" file)
    (write-line "Window" file)
    (write-line (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6)) file)
    (write-line (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6)) file)
    (write-line "Yes" file)
    (write-line "M" file)
    (write-line "0,0" file)
    (write-line (strcat (rtos LARG 2 6) "," (rtos ALT 2 6)) file)
    (write-line #prrot file)
    (write-line "No" file)
    (write-line (strcat (rtos FAT 2 6) "=" (rtos (/ #prscl #und) 2 6)) file)
    (write-line fname file)
    (write-line "" file)

    (write-line "shell" file) 
    (write-line (strcat "dfax " nm " " faxn " " customer_name " " dest_name) file)

  (setq file (close file))

  (command "script" (V:APPL "dfax"))

  (setq *error* nil)
  (princ)
)
(princ)
