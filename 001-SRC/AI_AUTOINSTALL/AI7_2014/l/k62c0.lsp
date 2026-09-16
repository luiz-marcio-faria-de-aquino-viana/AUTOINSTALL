
;;
;; K62C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 1/26/96.
;;

;; xfread: rotina que cria lista de Xrefs a partir de um arquivo referencia
(defun xfread(/ lxf xf ff f s)
  (setq lxf '())
  (if (findfile (setq ff (strcat (getvar "dwgname") ".xrf")))
    (progn
      (setq f (open ff "r"))
      (while (setq s (read-line f))
        (setq xf (list (strpiece s 1 "=") (strpiece s 2 "=")))
        (setq lxf (append lxf (list xf)))
      ) ; end while
      (setq f (close f))
    ) ; end progn
  ) ; end if
  lxf
) ; end defun

;; xfwrite: rotina que escreve o conteudo de uma lista no arquivo de referencia
;;   lxf - lista de Xrefs a ser escrita no arquivo referencia
(defun xfwrite(lxf)
  (setq ff (strcat (getvar "dwgname") ".xrf"))
  (setq f (open ff "w"))
  (foreach xf lxf (write-line (strcat (car xf) "=" (cadr xf)) f) )
  (setq f (close f))
) ; end defun

;; xfpath: troca o caminho de diretorio dos XREF definidos no arquivo (.xrf)
(defun c:xfpath(/ oldoch lxf s blk pth flg drv xrf fn xff)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (setq lxf (xfread))
  (command ".xref" "?" "")
  (while (/= (setq s (strcase (getstring "\nNome do Xref (ou ENTER): "))) "")
    (if (setq ent (tblsearch "block" s))
      (progn
        (setq
          blk (cdr (assoc  2 ent))
          pth (cdr (assoc  1 ent))
          flg (cdr (assoc 70 ent))
        ) ; end setq
        (if (= (logand flg 4) 4)
          (progn
            (prompt (strcat "\nArquivo referenciado = " pth))
            (setq drv (getstring (strcat "\nDrive de pesquisa <" (getdwgdrive) ">: ")))
            (if (= drv "") (setq drv (getdwgdrive)) )
            (setq xrf (getstring (strcat "\nNome do arquivo <"             blk ">: ")))
            (if (= xrf "") (setq xrf blk))
            (if (setq fn (filesea drv (strcat xrf ".dwg")))
              (progn
                (command ".xref" "p" blk fn)
                (setq xff (strcat "@" (substr fn 1 (- (strsearch ".DWG" fn) 1))) )
                (if (assoc blk lxf)
                  (setq lxf (subst (list blk xff) (assoc blk lxf) lxf))
                  (setq lxf (append lxf (list (list blk xff))) )
                ) ; end if
              ) ; end progn
              (prompt (strcat "\nERR: Arquivo " xrf " nao foi encontrado no drive " drv "."))
            ) ; end if
          ) ; end progn
          (prompt (strcat "\nERR: Bloco " s " nao e xref.\n"))
        ) ; end if
      ) ; end progn
      (prompt (strcat "\nERR: Bloco " s " nao existe.\n"))
    ) ; end if
  ) ; end while
  (if lxf (xfwrite lxf))
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
