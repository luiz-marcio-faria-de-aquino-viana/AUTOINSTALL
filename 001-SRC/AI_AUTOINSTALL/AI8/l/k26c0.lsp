
;;
;; K26C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 7/92 - 12/97
;;

;; logon(): funcao de gerenciamento de acesso
(defun logon(/ oldech oldreq d cdata chora enm)
  (m:savevars)

;;  (setq oldech (acadvar "cmdecho" 0))

;;  (setq d (rtos (getvar "cdate") 2 6))
;;  (setq
;;    cdata (strcat (substr d  7 2) "/" (substr d  5 2) "/" (substr d 3 2) )
;;    chora (strcat (substr d 10 2) ":" (substr d 12 2) )
;;  ) ; end setq

  (if (or (null aci_getusername) (null (setq #USR (aci_getusername))) )
    (setq #USR "USR_UNKNOW") )
  (if (or (null aci_getcomputername) (null (setq #CPU (aci_getcomputername))) )
    (setq #CPU "CPU_UNKNOW") )



(command "shell" "username")
(setq #USR (getvar "users2"))



  (setq #ID (strcat #CPU ", " #USR))

;;  (textscr)
;;  (prompt "\n\nLOGON:")
;;  (prompt "\n======")
;;  (prompt (strcat "\n\nDATA: " cdata))
;;  (prompt (strcat   "\nHORA: " chora))
;;  (prompt (strcat "\n\nNOME: "   #ID))

;;  (getstring "\n\n[ ENTER ] PARA PROSSEGUIR")

;;  (graphscr)

;;  (setq oldreq (acadvar "attreq" 0))
;;  (command "insert" (V:AID "SET/SET0DC02") "0,0" 1 "" 0)
;;  (setvar "attreq" oldreq)

;;  (setq enm (entlast))

;;  (attvalue enm "DWGNAME" (getdwgname))
;;  (attvalue enm "ID"               #ID)
;;  (attvalue enm "LOGIN"   (strcat "DATA: " cdata " - HORA: " chora))

;;  (setvar "cmdecho" oldech)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
