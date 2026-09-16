
;;
;; K81C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 12/13/97
;;

;; ai_redefine(): funcao que redefine as funcoes basicas do IntelliCAD
(defun ai_redefine()
  (command ".redefine" "save")
  (command ".redefine" "qsave")
  (command ".redefine" "saveall")
  (command ".redefine" "saveas")
  (command ".redefine" "saveasr12")
  (command ".redefine" "exit")
  (command ".redefine" "quit")
  (command ".redefine" "close")
  (command ".redefine" "wclose")
  (command ".redefine" "wcloseall")
) ; end defun

;; ai_save(): funcao que armazena o desenho corrente
;; opt - sinalizador (0=nao forca dialogo/1=forca dialogo)
(defun ai_save(opt / oldech rst)
  (setq oldech (ai_svar "cmdecho" 0))
  (setq rst 't)
  (if (= opt 0)
    (if (/= (getvar "dbmod") 0)
      (if (= (getvar "dwgtitled") 1)
        (command ".saveasr12" (getvar "savename") "y")
        (if (setq filename (getfiled "Save Drawing As..." (V:PRJ "*.dwg") "dwg" 3))
          (command ".saveasr12" filename "y")
          (setq rst nil)
        ) ; end if
      ) ; end if
    ) ; end if
    (if (setq filename (getfiled "Save Drawing As..." (V:PRJ "*.dwg") "dwg" 3))
      (command ".saveasr12" filename "y")
      (setq rst nil)
    ) ; end if
  ) ; end if
  (setvar "cmdecho" oldech)
  rst
) ; end if

;; ai_close(): funcao de saida do desenho corrente
;; flg - sinalizador (0=nao grava desenho/1=grava desenho)
(defun ai_close(flg / oldech opt)
  (setq oldech (ai_svar "cmdecho" 0))
  (setvar "promptmenu" 1)
  (if (or (= flg 0) (= (getvar "dbmod") 0))
    (progn
      (initget "Yes No")
      (setq opt (getkword "\n Voce realmente deseja sair do desenho? <N> "))
      (if (= opt "Yes")
        (progn
          (command ".close")
          (if (= (getvar "dwgname") "") (ai_redefine))
        ) ; end progn
      ) ; end if
    ) ; end progn
    (progn
      (initget "Yes No Cancel")
      (setq opt (getkword "\n Voce deseja gravar o seu trabalho antes de sair do desenho? <N> "))
      (cond
        ( (= opt "Yes")
          (if (ai_save 0)
            (progn
              (prompt "\n Trabalho armazenado. Saindo do desenho... ")
              (command ".close")
              (if (= (getvar "dwgname") "") (ai_redefine))
            ) ; end progn
          ) ; end if
        ) ; end case
        ( (= opt "No")
          (progn
            (prompt "\n Seu trabalho foi descartado. Saindo do desenho...")
            (command ".close" "n")
            (if (= (getvar "dwgname") "") (ai_redefine))
          ) ; end progn
        ) ; end case
        ('t (prompt "\n Operacao cancelada."))
      ) ; end cond
    ) ; end progn
  ) ; end if
) ; end defun

;; redefinicao dos comandos do IntelliCAD
(defun c:save() (ai_save 0) (princ))
(defun c:qsave() (ai_save 0) (princ))
(defun c:saveas() (ai_save 1) (princ))
(defun c:exit() (ai_close 0) (princ))
(defun c:quit() (ai_close 0) (princ))
(defun c:end() (ai_close 1) (princ))
(defun c:close() (ai_close 1) (princ))
(defun c:wclose() (ai_close 1) (princ))

(princ)
