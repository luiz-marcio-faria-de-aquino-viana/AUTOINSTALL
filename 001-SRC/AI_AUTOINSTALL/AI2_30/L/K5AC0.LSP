
;;
;; K5AC0.lsp
;; Copyright (C) 1996 by Luiz Marcio F A Viana, 3/19/96.
;;

;;
;; BEXTEND: rotina para extender uma entidade ate o objeto de um bloco

(defun c:bextend()
  (if (setq ss (nentsel "\nSelect boundery edge: "))
    (if (car (cadddr ss))
      (progn
        ;;
        ;; entidade limitante pertence a um bloco
        (setq
          obj (entget (car ss))
          blk (car (cadddr ss))
          typ (cdr (assoc 0 obj))
        ) ; end setq
        (cond
          ((= typ "LINE")   (ex_line obj blk))
          ((= typ "ARC")    (ex_arc  obj blk))
          ((= typ "CIRCLE") (ex_circ obj blk))
          ((= typ "VERTEX") (ex_vert obj blk))
          (t                  (prompt "\nThis isn't a valid entity."))
        ) ; end cond
      ) ; end progn
      (progn
        ;;
        ;; entidade limitante nao pertence a um bloco
      ) ; end progn
    ) ; end if
  ) ; end if
  (princ)
) ; end defun

;;
;; EX_LINE: funcao para processar quando objeto limitante for uma linha

(defun ex_line(obj blk)
  (setq
    pti (cdr (assoc 10 obj))
    ptf (cdr (assoc 11 obj))
  ) ; end setq
  (setq scl (cdr (assoc 41 (entget blk))) )
  (if (setq ss1 (entsel "\nSelect object to extend: "))
    (progn
      (command
        ".ucs" "e" blk
        ".line" pti ptf ""
        ".scale" (entlast) "" "0,0" scl
        ".ucs" "p"
        ".extend" "p" "" ss1 ""
        ".erase" "p" ""
      ) ; end command
      (redraw blk)
    ) ; end progn
  ) ; end if
) ; end defun

;;
;; EX_ARC: funcao para processar quando objeto limitante for um arco

(defun ex_arc(obj blk)
  (setq
    ptc  (cdr (assoc 10 obj))
    rad  (cdr (assoc 40 obj))
    angi (cdr (assoc 50 obj))
    angf (cdr (assoc 51 obj))
  ) ; end setq
  (setq scl (cdr (assoc 41 (entget blk))) )
  (if (setq ss1 (entsel "\nSelect object to extend: "))
    (progn
      (command
        ".ucs" "e" blk
        ".arc" "c" ptc (polar ptc angi rad) (polar ptc angf rad)
        ".scale" (entlast) "" "0,0" scl
        ".ucs" "p"
        ".extend" "p" "" ss1 ""
        ".erase" "p" ""
      ) ; end command
      (redraw blk)
    ) ; end progn
  ) ; end if
) ; end defun

;;
;; EX_CIRC: funcao para processar quando objeto limitante for um ciculo

(defun ex_circ(obj blk)
  (setq
    ptc  (cdr (assoc 10 obj))
    rad  (cdr (assoc 40 obj))
  ) ; end setq
  (setq scl (cdr (assoc 41 (entget blk))) )
  (if (setq ss1 (entsel "\nSelect object to extend: "))
    (progn
      (command
        ".ucs" "e" blk
        ".circle" ptc rad
        ".scale" (entlast) "" "0,0" scl
        ".ucs" "p"
        ".extend" "p" "" ss1 ""
        ".erase" "p" ""
      ) ; end command
      (redraw blk)
    ) ; end progn
  ) ; end if
) ; end defun

;;
;; EX_VERT: funcao para processar quando objeto limitante for um vertex

(defun ex_vert(obj blk)
  (setq obj1 (entget (entnext (cdr (assoc -1 obj)))) )
  (setq
    ptv  (cdr (assoc 10  obj))
    ptv1 (cdr (assoc 10 obj1))
    b    (cdr (assoc 42  obj))
  ) ; end setq
  (setq
    d (distance ptv ptv1)
    r (+ (/ (* b d) 2.0) (/ d (* 8 b)) )
  ) ; end setq
  (setq scl (cdr (assoc 41 (entget blk))) )
  (if (setq ss1 (entsel "\nSelect object to extend: "))
    (progn
      (command ".ucs" "e" blk)
      (if (= blg 0.0)
        (command ".pline" ptv "w" 0 "" ptv1 "")
        (command ".pline" ptv "w" 0 "" "a" "r" r ptv1 "")
      ) ; end if
      (command
        ".scale" (entlast) "" "0,0" scl
        ".ucs" "p"
        ".extend" "p" "" ss1 ""
        ".erase" "p" ""
      ) ; end command
      (redraw blk)
    ) ; end progn
  ) ; end if
) ; end defun

(princ)
