
;;
;; K27C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 7/92 - 12/97
;;

;; logoff(): funcao de controle de saida do desenho
(defun logoff(/ oldech d cname cdata chora hist ss enm att dwg cdg f)
  (m:savevars)

  (setq d (rtos (getvar "cdate") 2 6))
  (setq
    cname (getdwgname)
    cdata (strcat (substr d  7 2) "/" (substr d  5 2) "/" (substr d 3 2))
    chora (strcat (substr d 10 2) ":" (substr d 12 2))
  ) ; end setq

  (if (null (setq #USR (getenv   "USR")) ) (setq #USR "USR_UNKNOW"))
  (if (null (setq #CPU (getenv "MICRO")) ) (setq #CPU "CPU_UNKNOW"))

  (setq #ID (strcat #CPU ", " #USR))

  (prompt "\n\nEste arquivo sofreu/sofrera modificacoes no disco")
  (prompt "\nInforme as modificacoes realizadas (max = 2 linhas)")
  (while (= (setq hist (getstring 't "\n:: ")) "")
    (prompt "\nERR: Nao e valida resposta nula") )

  (if (setq ss (ssget "x" '((0 . "INSERT") (2 . "SET0DC02")) ) )
    (progn
      (setq enm (ssname ss 0))
      (setq att (attread enm))
      (setq cdg (cadr (assoc "ID" att)) )
      (if (= cdg #ID)
        (progn
          (attvalue enm "DWGNAME" cname)
          (attvalue enm "LOGOFF"  (strcat "DATA: " cdata " - HORA: " chora))
          (attvalue enm "HISTORIC" hist)
        ) ; end progn
        (prompt "\nERR: Nenhum bloco de controle de acesso disponivel ao usuario.")
      ) ; end if
    ) ; end progn
    (prompt "\nERR: Nenhum bloco de controle de acesso encontrado.")
  ) ; end if

  (setq aclog (V:APPL "ai.log"))

  (setq f (open aclog "a"))
  (write-line "- LOGOFF -------------------------------" f)
  (write-line (strcat "Arquivo:    " cname) f)
  (write-line (strcat "Data:       " cdata) f)
  (write-line (strcat "Hora:       " chora) f)
  (write-line (strcat "Projetista: "  #USR) f)
  (write-line (strcat "Historico:  "  hist) f)
  (setq f (close f))

  (m:restorevars)
  (princ)
) ; end defun

(princ)
