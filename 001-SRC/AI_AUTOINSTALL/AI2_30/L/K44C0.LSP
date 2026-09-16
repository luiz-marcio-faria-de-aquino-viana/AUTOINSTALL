
;;
;;  SPLIT.lsp
;; ============================================================================
;;             Copyright (C) 1995 by Luiz Marcio F A Viana, 3/28/95
;;

(defun c:split(/ opt nm)
  (setvar "cmdecho" 0)
  (initget "EL ES H G TEL")
  (setq opt (getkword "\nSelecione <EL>/ES/H/G/TEL: "))
  (if (null opt) (setq opt "EL"))
  (while (= (setq nm (getstring "Nome do arquivo: ")) "")
    (prompt "*ERROR* Nome do arquivo nao pode ser nulo.")
  ) ; end while
  (command ".ucs" "")
  (cond
    ((= opt "EL")  (command ".layer" "t" "arq-*" "t" "f-*" "t" "el-*" "f" "es-*" "f" "h-*" "f" "g-*" "f" "te-*" "f" "ti-*" "f" "ie-*" "f" "ar-*" "") )
    ((= opt "ES")  (command ".layer" "t" "arq-*" "t" "f-*" "f" "el-*" "t" "es-*" "f" "h-*" "f" "g-*" "f" "te-*" "f" "ti-*" "f" "ie-*" "f" "ar-*" "") )
    ((= opt "H")   (command ".layer" "t" "arq-*" "t" "f-*" "f" "el-*" "f" "es-*" "t" "h-*" "f" "g-*" "f" "te-*" "f" "ti-*" "f" "ie-*" "f" "ar-*" "") )
    ((= opt "G")   (command ".layer" "t" "arq-*" "t" "f-*" "f" "el-*" "f" "es-*" "f" "h-*" "t" "g-*" "f" "te-*" "f" "ti-*" "f" "ie-*" "f" "ar-*" "") )
    ((= opt "TEL") (command ".layer" "t" "arq-*" "t" "f-*" "f" "el-*" "f" "es-*" "f" "h-*" "f" "g-*" "t" "te-*" "t" "ti-*" "t" "ie-*" "f" "ar-*" "") )
  ) ; end cond
  (if (or (findfile (strcat (getvar "dwgprefix") nm ".ai2")) (findfile (strcat (getvar "dwgprefix") nm "._pk")) (findfile (strcat (getvar "dwgprefix") nm ".dwg")) )
    (if (= (progn (initget "Yes No") (getkword "\n*ATENCAO* Arquivo existente!\nGravar por cima <No>? ")) "Yes")
      (command
        ".zoom" "a"
        ".wblock" (strcat (getvar "dwgprefix") nm)
                  "y" "" "0,0" "c" "0,0" (getvar "limmax") ""
        ".oops"
        ".shell" (strcat "split " (getvar "dwgname") " " (getvar "dwgprefix") nm)
      ) ; end command
      (prompt "\nAtualizacao descartada.")
    ) ; end if
    (command
      ".zoom" "a"
      ".wblock" (strcat (getvar "dwgprefix") nm)
                "" "0,0" "c" "0,0" (getvar "limmax") ""
      ".oops"
      ".shell" (strcat "split " (getvar "dwgname") " " (getvar "dwgprefix") nm)
    ) ; end command
  ) ; end if
  (princ)
) ; end function

(princ)
