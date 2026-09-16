
;;
;; K93C0.lsp
;; Copyright (C) 1998 by Luiz Marcio F A Viana, 12/29/98.
;;

;; xfattach(): funcao que anexa um novo xref
(defun xfattach(xfl / xfn xfp xfs xff fn)
  (m:savevars)

  (setq
    xfn  (nth 0 xfl)
    xfp  (list (nth 1 xfl) (nth 2 xfl) (nth 3 xfl))
    xfs  (nth 4 xfl)
    xff  (strcat (nth 5 xfl) ".dwg")
  ) ; end setq

  (if (not (findfile xff))
    (progn
      (prompt (strcat "\nProcurando arquivo " (getfilename xff) "... "))
      (if (setq fn (filesea (getfstdir xff) (getfilename xff)) )
        (progn
          (command ".xref" "" (strcat xfn "=" fn) xfp xfs)
          (setq xfl (list xfn xfp xfs fn))
        ) ; end progn
        (prompt (strcat "\nATT: Arquivo (" xfn ") nao resolvido."))
      ) ; end if
    ) ; end progn
    (command ".xref" "" (strcat xfn "=" fn) xfp xfs)
  ) ; end if

  (m:restorevars)

  xfl
) ; end defun

;; xfix(): funcao que resolve os arquivos anexados
(defun xfix(xfl / xfn blk flg nm)
  (m:savevars)

  (setq xfn (nth 0 xfl))

  (prompt (strcat "\nResolvendo " xfn "..."))
  (if (setq blk (tblsearch "BLOCK" xfn))
    (progn
      (setq flg (cdr (assoc 70 blk)))
      (if (= (logand flg 4) 4)
        (if (zerop (logand xfl 32))
          (progn

            ;; xref nao resolvido

            (command ".erase" (ssget "x" (list '(0 . "INSERT") (cons 2 xfb))) )
            (setq xfl (xfattach xfl))

          ) ; end progn
        ) ; end if
        (progn

          ;; xref inexistente e existe um bloco com mesmo nome

          (prompt (strcat "\nATT: Existe um bloco com nome " xfn " no desenho."))
          (while (= (setq nm (getstring "\nInforme outro nome para o xref: ")) "")
            (prompt "\nERR: Resposta nula nao e valida.")
          ) ; end while
          (setq xfl (cons nm (cdr xfl)))
          (setq xfl (xfattach xfl))

        ) ; end progn
      ) ; end if
    ) ; end progn
    (progn

      ;; xref inexistente e nao existe bloco com mesmo nome

      (setq xfl (xfattach xfl))

    ) ; end progn
  ) ; end if

  (m:restorevars)

  xfl
) ; end defun

;; c:xfload(): rotina de carregamento dos arquivos de referencia externa
(defun c:xfload(/ oldech oldlay fn fd1 fd2 ls1 ls2 it1 it2)
  (m:savevars)

  (setvar "tilemode" 1)

  (setq oldlay (slay "0"))

  (setq fn (strcat (getvar "dwgname") ".xf2"))
  (if (setq fd1 (open fn "r"))
    (progn

      ;; leitura do arquivo de referencia externa

      (setq ls1 '())
      (while (setq buf (read-line fd1))
        (setq ls1 (cons (read buf) ls1))
      ) ; end while
      (setq fd1 (close fd1))

      ;; analise e carga dos arquivos anexados

      (prompt "\nAnalisando XREF... ")
      (setq ls2 '())
      (foreach it1 ls1
        (setq ls2 (cons (xfix it1) ls2))
      ) ; end foreach

      ;; atualizacao do arquivo de referencia externa

      (if (setq fd2 (open fn "w"))
        (progn
          (foreach it2 ls2 (print it2 fd2))
          (setq fd2 (close fd2))
        ) ; end progn
      ) ; end if

    ) ; end progn
  ) ; end if

  (slay oldlay)

  (m:restorevars)
  (princ)
) ; end defun

(princ)
