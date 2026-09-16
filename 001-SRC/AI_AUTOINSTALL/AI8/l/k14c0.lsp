
;;
;; K14C0.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 1/2/97
;;

;; c:pilar(): comando para desenho de pilar
(defun c:pilar(/ cnivel ptchv1 ptbase ptini angox dist1 enivel)
  (m:savevars)

  (setq cnivel (getvar "clayer"))
  
  (initget 1 "Inclinado")
  (setq
    ptchv1 (getpoint "\nPonto base (ou inicial)/Pilar (I)nclinado: ")
  ) ; end setq
  (if (= ptchv1 "Inclinado")
    (progn
      (initget 1)
      (setq
        ptbase (getpoint "\nPonto base (ou inicial): ")
      ) ; end setq
    ) ; end progn
    (setq ptbase ptchv1)
  ) ; end if
  (setq
    ptini (getpoint ptbase "\nPonto inicial (ou ENTER): ")
  ) ; end setq
  (if (null ptini) (setq ptini ptbase))
  (if #ptdim
    (setq
      ptdim (getpoint
              (strcat "\nDimensoes do pilar (base,alt) <"
                      (rtos (car #ptdim) 2 2) ","
                      (rtos (cadr #ptdim) 2 2) ">: "
            ) ) ; end strcat, get
    ) ; end setq
    (progn
      (initget 1)
      (setq
        ptdim (getpoint "\nDimensoes do pilar (base,alt): ")
    ) ) ; end setq, progn
  ) ; end if
  (if ptdim (setq #ptdim ptdim))
  (if (= ptchv1 "Inclinado")
    (progn
      (initget 1)
      (setq
        angox (getangle ptini "\nInclinacao do pilar (relativo ao ANGbase): ")
      ) ; end setq
    ) ; end progn
    (setq angox (/ pi 2.0))
  ) ; end if
  (if (zerop (rem angox pi))
    (progn
      (prompt "\n--- Valor de inclinacao invalido ---")
      (princ)
    ) ; end progn
    (progn
      (setq
        dist1 (/ (cadr #ptdim) (sin angox))
      ) ; end setq
      (setq enivel (tblsearch "LAYER" "F-PL_TETO"))
      (command "layer")
      (if enivel
        (if (zerop (rem (cdr (assoc 70 enivel)) 2.0))
          (command "s" "F-pl_teto" "")
          (command "t" "F-pl_teto" "s" "F-pilar" "")
        ) ; end if
        (command "m" "F-pl_teto" "")
      ) ; end if
      (command
        "pline"
          ptini "w" 0 ""
          (polar ptini (getvar "angbase") (car #ptdim))
          (polar (getvar "lastpoint") (+ (getvar "angbase") angox) dist1)
          (polar (getvar "lastpoint") (- (getvar "angbase") pi) (car #ptdim))
          "c"
        "hatch" "u" 45 (#SCL) "n" "l" ""
        "layer" "s" cnivel ""
      ) ; end command
    ) ; end progn
  ) ; end if

  (m:restorevars)
  (princ)
) ; end defun

(princ)
