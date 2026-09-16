
;;
;; AUTOLOAD.LSP
;; Copyright (C) 1996 by Luiz Marcio Faria Viana, 9/10/96
;;

;; autoload: funcao de auto-carregamento das rotinas
;;  ls - lista dos comandos existentes no arquivo
;;  ff - nome do arquivo a ser carregado
(defun autoload (ls ff / qff)
  (setq qff (strcat "\"" ff "\""))
  (mapcar
    '(lambda (cmd)
       (if (not (eval (read cmd)))
         (eval
           (read
             (strcat
               "(defun " cmd "()"
               "(loadf " qff ")"
               "(" cmd ")"
               "(princ))"
             ) ; end strcat
           ) ; end read
         ) ; end eval
         (prompt "ERR: Tentativa de redefinir uma rotina ja existente.\n")
       ) ; end if
     ) ; end lambda
     ls
  ) ; end mapcar
  (princ)
)

(princ)
