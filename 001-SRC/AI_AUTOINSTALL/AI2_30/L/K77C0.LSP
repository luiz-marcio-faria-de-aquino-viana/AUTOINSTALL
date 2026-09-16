
;;
;; K77C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 3/6/97
;;

;; eadjattr: rotina para ajuste dos atributos dos pontos de eletrica
(defun eadjattr(/ enm ent tag)
  (setq enm (entnext))
  (while enm
    (if (= (enttype enm) "ATTRIB")
      (progn
        (setq ent (entget enm) )
        (setq tag (cdr (assoc 2 ent)) )
        (cond
          ((= tag "#TIPO")               (setq tag "#TIPO(0)"))
          ((= tag "#NOME_QUADRO")        (setq tag "#NOME_QUADRO(0)"))
          ((= tag "#QUADRO_ORIGEM")      (setq tag "#QUADRO_ORIGEM(0)"))
          ((= tag "#CIRCUITO")           (setq tag "#CIRCUITO(0)"))
          ((= tag "#COMANDO")            (setq tag "#COMANDO(0)"))
          ((= tag "#POTENCIA")           (setq tag "#POTENCIA(0)"))
          ((= tag "#POTENCIA_DEMANDADA") (setq tag "#POTENCIA_DEMANDADA(0)"))
          ((= tag "#SISTEMA")            (setq tag "#SISTEMA(0)"))
        ) ; end cond
        (entmod (subst (cons 2 tag) (assoc 2 ent) ent))
      ) ; end progn
    ) ; end if
    (setq enm (entnext enm))
  ) ; end while
  (princ)
) ; end defun

;; eadjfios: rotina para ajuste do tamanho da representacao da fiacao
(defun eadjfios()
  (if (tblsearch "block" "el1fc00")
    (command ".insert" (strcat "el1fc00=" (v:aid "el\\el1fc00")) "y" nil)
  ) ; end if
  (if (tblsearch "block" "el20c00")
    (command ".insert" (strcat "el20c00=" (v:aid "el\\el20c00")) "y" nil)
  ) ; end if
  (if (tblsearch "block" "el21c00")
    (command ".insert" (strcat "el21c00=" (v:aid "el\\el21c00")) "y" nil)
  ) ; end if
  (if (tblsearch "block" "el22c00")
    (command ".insert" (strcat "el22c00=" (v:aid "el\\el22c00")) "y" nil)
  ) ; end if
  (if (tblsearch "block" "el23c00")
    (command ".insert" (strcat "el23c00=" (v:aid "el\\el23c00")) "y" nil)
  ) ; end if
) ; end defun

;; c:eadjuste: rotina para ajuste dos elementos de projeto de eletrica
(defun c:eadjuste()
  (prompt "\nAjustando atributos dos pontos de eletrica...") (eadjattr)
  (prompt "\nAjustando tamanho da representacao da fiacao...") (eadjfios)
  (command ".regen")
) ; end defun

(princ)
