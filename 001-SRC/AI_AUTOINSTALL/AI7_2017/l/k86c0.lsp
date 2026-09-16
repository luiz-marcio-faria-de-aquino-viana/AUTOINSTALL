
;;
;; K86C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 2/12/98
;;

;; fread(): funcao que le o conteudo de um arquivo de lista delimitado e retorna uma lista
;;  fn - nome do arquivo de listagem a ser lido
;;  c  - caracter delimitador dos dados no arquivo
(defun fread(fn c / fp s)
  (setq ls '())
  (if (setq fp (open fn "r"))
    (progn
      (while (setq s (read-line fp))
        (setq ls1 '())
        (while (/= s "")
          (setq
            ls1 (cons (strhead s c) ls1)
            s   (strtail s c)
          ) ; end setq
        ) ; end while
        (setq ls (cons (reverse ls1) ls))
      ) ; end while
      (setq fp (close fp))
    ) ; end progn
  ) ; end if
  (reverse ls)
) ; end defun

;; fwrite(): funcao que grava o conteudo de uma lista em um arquivo delimitado
;;  fn - nome do arquivo de listagem a ser escrito
;;  ls - lista de dados a ser gravado (ex: '((a b c...) (a b c...) ... (a b c...)) )
;;  c  - caracter delimitador dos dados no arquivo
(defun fwrite(fn ls c / it s fp)
  (if (setq fp (open fn "w"))
    (progn
      (foreach it ls
        (progn
          (setq s (car it))
          (while (setq it (cdr it)) (setq s (strcat s c (car it))) )
          (write-line s fp)
        ) ; end progn
      ) ; end foreach
      (setq fp (close fp))
    ) ; end progn
  ) ; end if
) ; end defun

(princ)
