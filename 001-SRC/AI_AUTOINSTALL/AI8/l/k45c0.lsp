
;;
;; K45C0.lsp
;; Copyright (C) 2000 by Luiz Marcio F A Viana, 1/14/2000
;;
;; Bibliografia
;;
;;	Instalacoes Eletricas Industriais, Joao Mamede Filho, p69-p71
;;

;; c:cdt(): rotina para calculo do diametro do eletroduto
(defun c:cdt(/ DN_XLPE DN_PVC DN_COND TB_ELET opt flg ls dm nm soma elem Smin dat)
  ;;(setq oldmnu (ai_svar "promptmenu" 1))
  (m:savevars)

  (setq
    DN_XLPE '( ("1.5mm"  5.3)
               ("2.5mm"  5.7)
               ("4mm"    6.8)
               ("6mm"    7.2)
               ("10mm"   8.1)
               ("16mm"   9.1)
               ("25mm"  11.0)
               ("35mm"  12.0)
               ("50mm"  14.0)
               ("70mm"  15.5)
               ("95mm"  18.0)
               ("120mm" 19.0)
               ("150mm" 21.5)
               ("185mm" 23.5)
               ("240mm" 26.5) )

    DN_PVC '( ("1.5mm"  3.0)
              ("2.5mm"  3.7)
              ("4mm"    4.2)
              ("6mm"    4.6)
              ("10mm"   5.9)
              ("16mm"   6.9)
              ("25mm"   8.5)
              ("35mm"   9.5)
              ("50mm"  11.5)
              ("70mm"  13.0)
              ("95mm"  15.0)
              ("120mm" 16.5)
              ("150mm" 18.5)
              ("185mm" 20.5)
              ("240mm" 23.5) )

    DM_COND '( ("1.5mm"  1.55)
               ("2.5mm"  2.0)
               ("4mm"    2.5)
               ("6mm"    2.9)
               ("10mm"   3.75)
               ("16mm"   4.75)
               ("25mm"   5.95)
               ("35mm"   7.0)
               ("50mm"   8.05)
               ("70mm"   9.7)
               ("95mm"  11.45)
               ("120mm" 12.8)
               ("150mm" 14.25)
               ("185mm" 15.90)
               ("240mm" 18.45) )
  ) ; end setq

  (setq
    TB_ELET '( (126.6  "3/8\"")
               (203.6  "1/2\"")
               (346.3  "3/4\"")
               (564.1  "1\"")
               (962.1  "1 1/4\"")
               (1244.1 "1 1/2\"")
               (1979.2 "2\"")
               (3327.0 "2 1/2\"")
               (4488.8 "3\"")
               (7043.5 "3 1/2\"") )
  ) ; end setq

  (initget "PVC XLPE Condutor")
  (setq opt (getkword "\nIsolamento empregado (PVC, XLPE ou Condutor sem isolamento) <PVC>: "))
  (if (null opt) (setq opt "PVC"))

  (cond
    ( (= opt "PVC") (setq lscond DN_PVC) ) 
    ( (= opt "XLPE") (setq lscond DN_XLPE) ) 
    ( (= opt "Condutor") (setq lscond DN_COND) ) 
  ) ; end cond

  (setq
    flg 't
    ls  '()
  ) ; end setq

  (while flg
    (if (null ls)
      (progn
        (initget 1 "1.5mm 2.5mm 4mm 6mm 10mm 16mm 25mm 35mm 50mm 70mm 95mm 120mm 150mm 185mm 240mm")
        (setq dm (getdist "\nDiametro do condutor em (mm): "))
      ) ; end progn
      (progn
         (initget "Undo 1.5mm 2.5mm 4mm 6mm 10mm 16mm 25mm 35mm 50mm 70mm 95mm 120mm 150mm 185mm 240mm")
         (setq dm (getdist "\nUndo/<Diametro do condutor em (mm)>: "))
      ) ; end progn
    ) ; end if

    (if (= (type dm) 'STR) (setq dm (cadr (assoc dm lscond))) )

    (if dm
      (if (= dm "Undo")
        (setq ls (cdr ls))
        (progn
          (initget 4)
          (if (setq nm (getint "\nNumero de condutores: "))
            (if ls
              (setq ls (append (list (cons dm nm)) ls))
              (setq ls (list (cons dm nm)))
            ) ; end if
            (setq flg nil)
          ) ; end if
        ) ; end progn
      ) ; end if
      (setq flg nil)
    ) ; end if
  ) ; end while

  (setq soma 0)
  (foreach elem ls (setq soma (+ soma (/ (* (cdr elem) pi (expt (car elem) 2.0)) 4.0))) )

  (setq Smin (/ soma 0.33))
  (if (not (zerop soma))
    (progn
      (setq flg 't)
      (while (and flg (setq dat (car TB_ELET)))
        (if (>= (car dat) Smin) (setq flg nil))
        (setq TB_ELET (cdr TB_ELET))
      ) ; end while
      (if (null flg)
        (prompt (strcat "\nDiametro do eletroduto = " (cadr dat)))
        (prompt "\nERR: Dimensao extrapola o valor maximo na tabela (=3 1/2\")")
      ) ; end if
    ) ; end progn
  ) ; end if

  ;;(setvar "promptmenu" oldmnu)
  (m:restorevars)
  (princ)
) ; end function

(princ)
