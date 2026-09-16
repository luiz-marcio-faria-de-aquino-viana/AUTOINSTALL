
;;
;; K31C0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 5/27/96.
;;

;; c:ecopy(): rotina para copiar objetos eletricos modificando o quadro de origem
(defun c:ecopy(/ ptb pti ss)
  (prompt "\nSelecione os objetos que serao copiados...")
  (if (setq ss (ssget))
    (progn
      (initget 1)
      (setq ptb (getpoint "\nPonto base: "))
      (initget 1)
      (setq pti (getpoint ptb "\nPonto de insercao: "))
      (edoubleobj ss)
      (command ".move" ss "" ptb pti)
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

;; c:emirror(): rotina para espelhar objetos eletricos modificando o quadro de origem
(defun c:emirror(/ pt1 pt2 ss)
  (prompt "\nSelecione os objetos que serao espelhados...")
  (if (setq ss (ssget))
    (progn
      (initget 1)
      (setq pt1 (getpoint "\nPrimeiro ponto do espelho: "))
      (initget 1)
      (setq pt2 (getpoint pt1 "\nSegundo ponto do espelho: "))
      (edoubleobj ss)
      (command ".mirror" ss "" pt1 pt2 "Y")
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

;; edoubleobj(): funcao que duplica os objetos eletricos modificando o quadro de origem
(defun edoubleobj(ss / oldech enm1 ls ss1 cnt enm idx oldqdr newqdr num opt)

  (initget "Yes No")
  (setq opt (getkword "\nModificar identificacao dos quadros <Yes>: "))

  (command ".undo" "g")
  (setq oldech (acadvar "cmdecho" 0))

  (setq enm1 (entlast))       ;; ename da ultima entidade

  ;; duplicacao dos objetos selecionados
  (prompt "\nDuplicando os objetos selecionados...")
  (command ".copy" ss "" "0,0" "0,0")

  ;; modificacao das identificacoes dos quadros
  (if (setq ss1 (ssfilter "EQUADRO" ss))
    (progn
      (setq ls '())
      (if (/= opt "No")
        (progn
          (setq cnt (- (sslength ss1) 1))
          (while (>= cnt 0)
            (setq enm (ssname ss1 cnt))
            (setq idx 0)
            (while (setq oldqdr (cadr (assoc (strcat "#NOME_QUADRO(" (itoa idx) ")") (attread enm))))
              (setq newqdr (strcase (getstring (strcat "\nInforme novo nome do quadro <" oldqdr ">: "))))
              (if (and (/= newqdr "") (/= newqdr oldqdr))
                (progn
                  (setq ls (append ls (list (list oldqdr newqdr))))
                  (attvalue enm (strcat "#NOME_QUADRO(" (itoa idx) ")") newqdr)
                ) ; end progn
                (prompt "\nATT: Apos o processamento este quadro estara duplicado no desenho.")
              ) ; end if
              (setq idx (1+ idx))
            ) ; end while
            (setq cnt (- cnt 1))
          ) ; end while
          ;; modificacao da origem dos objetos de acordo com o quadro
          (setq num 0)
          (setq cnt (- (sslength ss) 1))
          (while (>= cnt 0)
            (setq enm (ssname ss cnt))
            (setq idx 0)
            (while (setq oldorg (cadr (assoc (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") (attread enm))))
              (if (setq neworg (cadr (assoc oldorg ls)))
                (attvalue enm (strcat "#QUADRO_ORIGEM(" (itoa idx) ")") neworg)
                (setq num (+ num 1))
              ) ; end if
              (setq idx (1+ idx))
            ) ; end while
            (setq cnt (- cnt 1))
          ) ; end while
          (prompt (strcat "\nTotal de objetos com origem nao modificadas = " (itoa num)))
        ) ; end progn
        (prompt "\nATT: Apos o processamento existirao quadros duplicados no desenho.")
      ) ; end if
    ) ; end progn
  ) ; end if

;;;;  (while (setq enm1 (entnext enm1)) (redraw enm1 1))

  (setvar "cmdecho" oldech)
  (command ".undo" "e")
  (princ)
) ; end defun

(princ)
