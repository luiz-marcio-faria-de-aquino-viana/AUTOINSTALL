; ***********************
; * LMV - Dez/91 - Util *
; * Copyright (C), 1991 *
; ***********************

(vmon)

; ********
; * 45GR *
; ********

(defun 45GR(/ pt1 pt2 pt3 delt1 delt2)
  (setvar "cmdecho" 0)

  (setq
    pt1
      (getvar "LASTPOINT")
    pt2
      (getpoint pt1 "\nSelecione reta (ou polyline): ")
    pt3
      (osnap pt2 "PERP")
    delt1
      (* (- (car pt2) (car pt3)) (- (cadr pt1) (cadr pt3)))
    delt2
      (* (- (cadr pt2) (cadr pt3)) (- (car pt1) (car pt3)))
  )
  (if
    (and
      (>= delt1 0)
      (<= delt2 0)
    )
    (progn
      (list
        (+ (car pt3) (- (cadr pt1) (cadr pt3)))
        (+ (cadr pt3) (- (car pt3) (car pt1)))
      )
    )
    (progn
      (list
        (- (car pt3) (- (cadr pt1) (cadr pt3)))
        (- (cadr pt3) (- (car pt3) (car pt1)))
      )
    )
  )
);end programm


; ************
; * PARALELA *
; ************

(defun PARALELA(/ ag1 pt1 pt2 pt3 pt4 pt5 pt6)
  (setvar "cmdecho" 0)

  (setq
    pt1
      (getvar "lastpoint")
    pt2
      (getpoint "\nSelecione objeto: ")
    pt6
      (getpoint pt1 "\nMarque o comprimento: ")
    pt3
      (osnap pt2 "end")
    ag1
      (angle pt3 pt2)
  )

  (setq
    pt4
      (if (zerop (cos ag1))
        (list
          (+ (car pt2) (- (car pt2) (car pt1)))
          (cadr pt1)
        )
        (list
          (+ (car pt1) (* (cadr pt1) (/ (sin ag1) (cos ag1))))
          0.0
        )
      )
    pt5
      (inters
        pt2 pt3
        pt1 pt4
        nil
      )
    pt4
      (if (zerop (cos ag1))
        (list
          (+ (car pt2) (- (car pt2) (car pt6)))
          (cadr pt6)
        )
        (list
          (+ (car pt6) (* (cadr pt6) (/ (sin ag1) (cos ag1))))
          0.0
        )
      )
  )

  (polar pt1
    (angle pt1
      (mapcar '+ pt1
        (mapcar '-
          (inters
            pt2 pt3
            pt6 pt4
            nil
          )
          pt5
        )
      )
    )
    (distance
      pt1 pt6
    )
  )

); end program

; ********
; * RS45 *
; ********

(defun RS45(/ ag1 pt1 pt2 pt3 pt4 pt5 delt1 delt2)
  (setq
    pt1
      (getvar "lastpoint")
    pt2
      (getpoint pt1 "\nSelecione objeto (RS ou Coluna): ")
    pt3
      (osnap pt2 "CEN")
    ag1
      (angle pt3 pt2)
    pt4
      (if (zerop (cos ag1))
        (list
          (+ (car pt2) (- (car pt2) (car pt1)))
          (cadr pt1)
        )
        (list
          (+ (car pt1) (* (cadr pt1) (/ (sin ag1) (cos ag1))))
          0.0
        )
      )
    pt5
      (inters
        pt2 pt3
        pt1 pt4
        nil
      )
    delt1
      (* (- (car pt2) (car pt5)) (- (cadr pt1) (cadr pt5)))
    delt2
      (* (- (cadr pt2) (cadr pt5)) (- (car pt1) (car pt5)))
  )

  (command
    (if (and
        (>= delt1 0)
        (<= delt2 0)
      )
      (list
        (+ (car pt5) (- (cadr pt1) (cadr pt5)))
        (+ (cadr pt5) (- (car pt5) (car pt1)))
      )
      (list
        (- (car pt5) (- (cadr pt1) (cadr pt5)))
        (- (cadr pt5) (- (car pt5) (car pt1)))
      )
    )
    pt2
  )

); end program

; ********
; * RS90 *
; ********

(defun RS90(/ ag1 pt1 pt2 pt3 pt4)
  (setvar "cmdecho" 0)

  (setq
    pt1
      (getvar "lastpoint")
    pt2
      (getpoint pt1 "\nSelecione objeto (RS ou Coluna): ")
    pt3
      (osnap pt2 "CEN")
    ag1
      (angle pt3 pt2)
    pt4
      (if (zerop (cos ag1))
        (list
          (+ (car pt2) (- (car pt2) (car pt1)))
          (cadr pt1)
        )
        (list
          (+ (car pt1) (* (cadr pt1) (/ (sin ag1) (cos ag1))))
          0.0
        )
      )
  )
  (command
    (inters
      pt2 pt3
      pt1 pt4
      nil
    )
    pt2
  )

);end program

;;
;; GETDWGNAME: Function to return the current drawing name
;; Copyright (C) 1995 by Luiz Marcio F A Viana, 2/21/95.

(defun GETDWGNAME(/ nm cnt)
  (setq nm (getvar "dwgname"))
  (setq cnt (strlen nm))
  (while (and (/= (substr nm cnt 1) "\\") (/= (substr nm cnt 1) "/") (> cnt 0))
     (setq cnt (- cnt 1))
  ) ; end while
  (if (or (= (substr nm cnt 1) "\\") (= (substr nm cnt 1) "/") )
    (substr nm (1+ cnt))
    nm
  ) ; end if
) ; end function

(princ)
