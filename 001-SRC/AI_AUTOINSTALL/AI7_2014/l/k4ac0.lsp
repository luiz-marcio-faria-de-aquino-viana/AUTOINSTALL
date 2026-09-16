
;;
;; ILUM.lsp
;;
;; Copyright (C) 1994 by Luiz Marcio F A Viana
;; All Rights Reserved.
;;

;; bibliografia: Instalacoes Eletricas (3 Edicao),
;;               Ademaro A. M. B. Cotrim

(defun C:ILUM(/ REFL INDX l b Hm K S E F Teto Parede Piso R cnt u Local d N und)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (setq
    REFL '(("BCE" . (0.32 0.40 0.46 0.52 0.56 0.63 0.67 0.71 0.74 0.77))
           ("BME" . (0.24 0.33 0.40 0.46 0.51 0.58 0.63 0.67 0.70 0.74))
           ("BEE" . (0.22 0.29 0.35 0.41 0.46 0.54 0.59 0.63 0.69 0.72))
           ("CCE" . (0.32 0.39 0.45 0.50 0.55 0.61 0.66 0.69 0.72 0.75))
           ("CME" . (0.26 0.33 0.39 0.45 0.50 0.57 0.62 0.65 0.70 0.73))
           ("CEE" . (0.21 0.28 0.34 0.40 0.45 0.53 0.59 0.62 0.67 0.74))
           ("MCE" . (0.25 0.32 0.38 0.44 0.49 0.56 0.61 0.64 0.60 0.71))
           ("MME" . (0.25 0.32 0.38 0.44 0.49 0.56 0.61 0.64 0.60 0.71))
           ("MEE" . (0.24 0.28 0.34 0.40 0.45 0.53 0.58 0.61 0.66 0.69))
           ("ECE" . (0.20 0.24 0.32 0.38 0.43 0.50 0.55 0.59 0.64 0.67))
           ("EME" . (0.20 0.24 0.32 0.38 0.43 0.50 0.55 0.59 0.64 0.67))
           ("EEE" . (0.20 0.24 0.32 0.38 0.43 0.50 0.55 0.59 0.64 0.67)))
    INDX '(0.60 0.80 1.00 1.25 1.50 2.00 2.50 3.00 4.00 5.00)
  ) ; end setq 

  (cond
    ((= (#UND) 1.0)    (setq und "mm"))
    ((= (#UND) 10.0)   (setq und "cm"))
    ((= (#UND) 1000.0) (setq und  "m"))
    (t               (setq und "un"))
  ) ; end cond

  (setq l (/ (* (getdist (strcat "\nComprimento do ambiente (" und "): ")) (#UND)) 1000.0))
  (setq b (/ (* (getdist (strcat "\nLargura do ambiente (" und "): ")) (#UND)) 1000.0))
  (setq Hm (/ (* (getdist (strcat "\nDistancia das luminarias ao plano de trabalho (" und "): ")) (#UND)) 1000.0))
  (setq K (/ (* l b) (* Hm (+ l b))))

  (setq S (* l b))

  (textscr)
  (prompt "\e[2J")
  (prompt "Iluminancias recomendadas pela NBR 5413")
  (prompt "\n\n\tMinimo para ambiente de trabalho              150 lux")
  (prompt "\n\n\tTarefas visuais simples e variadas       250- 500 lux")
  (prompt "\n\n\tObservacoes continuas de detalhes")
  (prompt   "\n\tmedios e finos (trabalho normal)         500-1000 lux")
  (prompt "\n\n\tTarefas visuais continuas e precisas")
  (prompt   "\n\t(trabalho fino, por exemplo, desenho)   1000-2000 lux")
  (prompt "\n\n\tTrabalho muito fino (iluminacao local,")
  (prompt   "\n\tpor exemplo, conserto de relogios)          +2000 lux")

  (setq E (getreal "\n\n\nIndice de iluminamento do local: "))
  (setq F (getreal "\nFluxo luminoso da luminaria: "))

  (graphscr)
  (initget 1 "Escuro Medio Claro Branco")
  (setq Teto (substr (getkword "\nTipo de teto (Escuro,Medio,Claro ou Branco): ") 1 1))
  (initget 1 "Escura Media Clara")
  (setq Parede (substr (getkword "\nTipo de parede (Escura,Media ou Clara): ") 1 1))
  (setq Piso (substr "Escuro" 1 1))

  (setq R (strcat Teto Parede Piso))
  ;; processo de determinacao do fator de utilizacao
  ;; na tabela Fator do local (K) x Refletancia (R)
  (setq cnt 0)
  (while (and (< cnt 10) (< (nth cnt INDX) K)) (setq cnt (+ cnt 1)))
  (setq u (nth cnt (cdr (assoc R REFL))))

  (initget 1 "Limpo Normal Sujo")
  (setq Local (getkword "\nTipo de ambiente (Limpo,Normal ou Sujo): "))
  ;; considerando manutencao regular a cada 5000h
  (cond
    ((= Local "Limpo") (setq d 0.91))
    ((= Local "Normal") (setq d 0.85))
    ((= Local "Sujo") (setq d 0.66))
  ) ; end cond

  (setq N (/ (/ (* S E) (* u d)) F))

  (prompt (strcat "\nNumero total de aparelhos = " (rtos N 2 0)))

  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
