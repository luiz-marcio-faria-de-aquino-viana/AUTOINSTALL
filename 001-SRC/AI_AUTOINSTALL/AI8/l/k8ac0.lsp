
;;
;; K8AC0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 5/8/98
;;

;; menureload(): funcao para recompilacao de um menu fornecido
;;  mm - nome do menu que sera recompilado
(defun menureload(mm) (command ".menu" (strcat mm ".mnu")))

;; c:mr(): rotina para recompilacao do menu corrente
(defun c:mr(/ mm)
  (m:savevars)
  (setq mm (getvar "menuname"))
  (menureload mm)
  (m:restorevars)
  (princ)
) ; end defun

;; c:mra(): rotina para recompilacao de todos os menus de instalacoes
(defun c:mra(/ MNULST mm)
  (m:savevars)
  (setq MNULST '("M/ARQMENU"
                 "M/FMENU"
                 "M/ELMENU"
                 "M/ESMENU"
                 "M/HMENU"
                 "M/GMENU"
                 "M/TEMENU"
                 "M/TIMENU"
                 "M/IEMENU") )
  (foreach mm MNULST (menureload mm))
  (m:restorevars)
  (princ)
) ; end defun

(princ)

