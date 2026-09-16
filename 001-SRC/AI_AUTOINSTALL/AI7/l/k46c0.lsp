
;;
;; malha.lsp
;; Copyright (C) 1995 by Luiz Marcio F A Viana, 4/17/95
;;

(or #ESPCP (setq #ESPCP (/  100.0 (#UND))) )

(defun add_point(pti ls)
  (if (null ls)
    (list pti)
    (if (< (distance pti (car ls)) (/ 1.0 (#UND)))
      ls
      (append (list (car ls)) (add_point pti (cdr ls)))
    ) ; end if
  ) ; end if
) ; end function

(defun line_list(pti ls)
  (if (null ls)
    (list pti)
    (if (< (distance pti (car ls)) (/ 1.0 (#UND)))
      ls
      (if (null (cadr ls))
        (append ls (list pti))
        (if (< (distance pti (cadr ls)) (/ 1.0 (#UND)))
          ls
          (if (< (distance pti (car ls)) (distance (car ls) (cadr ls)))
            (append (list (car ls) pti) (cdr ls))
            (append (list (car ls)) (line_list pti (cdr ls)))
          ) ; end if
        ) ; end if
      ) ; end if
    ) ; end if
  ) ; end if
) ; end function

(defun angular_list(an ls)
  (if (null ls)
    (append (list an) ls)
    (if (< (car an) (caar ls))
      (append (list an) ls)
      (append (list (car ls)) (angular_list an (cdr ls)))
    ) ; end if
  ) ; end if
) ; end function

(defun break_line(selc / vert cnt1 cnt2 ss1 ss2 p1 p2 p3 p4)
  (setq vert '())
  (setq cnt1 0)
  (while (setq ss1 (ssname selc cnt1))
    (setq
      p1 (cdr (assoc 10 (entget ss1)))
      p2 (cdr (assoc 11 (entget ss1)))
    ) ; end setq
    (setq cnt2 0)
    (setq ls (list p1 p2))
    (while (setq ss2 (ssname selc cnt2))
      (if (/= ss1 ss2)
        (progn
          (setq
            p3 (cdr (assoc 10 (entget ss2)))
            p4 (cdr (assoc 11 (entget ss2)))
          ) ; end setq
          (if (setq pti (inters p1 p2 p3 p4)) (setq ls (line_list pti ls)) )
        ) ; end progn
      ) ; end if
      (setq cnt2 (+ cnt2 1))
    ) ; end while
    (command ".line")
    (foreach pt ls
      (progn
        (command pt)
        (setq vert (add_point pt vert))
      ) ; end progn
    ) ; end foreach
    (command "")
    (setq cnt1 (+ cnt1 1))
  ) ; end while
  vert
) ; end function

(defun double_line(selc / cnt ss p1 p2)
  (if selc
    (progn
      (setq cnt 0)
      (while (setq ss (ssname selc cnt))
        (setq
          p1 (cdr (assoc 10 (entget ss)))
          p2 (cdr (assoc 11 (entget ss)))
        ) ; end setq
        (command
          ".ucs" "e" ss
          ".line" (list 0.0 (/ #ESPCP 2.0)) (list (distance p1 p2) (/ #ESPCP 2.0)) ""
          ".line" (list 0.0 (- (/ #ESPCP 2.0))) (list (distance p1 p2) (- (/ #ESPCP 2.0))) ""
        ) ; end command
        (setq cnt (+ cnt 1))
      ) ; end while
    ) ; end progn
  ) ; end if
) ; end function

(defun fillet_edges(pt / selc ss1 ss2 aux p1 p2 p3 p4 ls)
  (command ".ucs" "")
  (setq
    selc (ssget "c" (list (- (car pt) #ESPCP) (- (cadr pt) #ESPCP))
                    (list (+ (car pt) #ESPCP) (+ (cadr pt) #ESPCP)) )
  ) ; end setq
  (setq cnt1 0)
  (while (setq ss1 (ssname selc cnt1))
    (if (setq ss2 (ssname selc (setq cnt1 (+ cnt1 1))))
      (progn
        (setq
          p1 (cdr (assoc 10 (entget ss1)))
          p2 (cdr (assoc 11 (entget ss1)))
        ) ; end setq
        (setq
          p3 (cdr (assoc 10 (entget ss2)))
          p4 (cdr (assoc 11 (entget ss2)))
        ) ; end setq
        (if (< (distance pt p1) (distance pt p2))
          (setq
            aux p1
            p1 p2
            p2 aux
          ) ; end setq
        ) ; end if
        (if (< (distance pt p3) (distance pt p4))
          (setq
            aux p3
            p3 p4
            p4 aux
          ) ; end setq
        ) ; end if
        (command ".ucs" "or" p2 ".ucs" "z" p2 p1)
        (if (minusp (cadr (trans p3 0 1)))
          (setq ls (angular_list (list (angle pt p1) ss1 ss2) ls))
          (setq ls (angular_list (list (angle pt p3) ss2 ss1) ls))
        ) ; end if
        (command ".ucs" "")
      ) ; end progn
    ) ; end if
    (setq cnt1 (+ cnt1 1))
  ) ; end while
  (setq cnt1 0)
  (while (setq elem1 (nth cnt1 ls))
    (if (setq elem2 (nth (+ cnt1 1) ls))
      (progn
        (setq
          p1 (cdr (assoc 10 (entget (cadr elem1))))
          p2 (cdr (assoc 11 (entget (cadr elem1))))
        ) ; end setq
        (setq
          p3 (cdr (assoc 10 (entget (caddr elem2))))
          p4 (cdr (assoc 11 (entget (caddr elem2))))
        ) ; end setq
        (if (setq pti (inters p1 p2 p3 p4 nil))
          (progn
            (if (< (distance pti p1) (distance pti p2))
              (setq p1 pti)
              (setq p2 pti)
            ) ; end if
            (if (< (distance pti p3) (distance pti p4))
              (setq p3 pti)
              (setq p4 pti)
            ) ; end if
          ) ;end progn
        ) ; end if
        (command
          ".line" p1 p2 ""
          ".line" p3 p4 ""
        ) ; end command
      ) ; end progn
    ) ; end if
    (setq cnt1 (+ cnt1 1))
  ) ; end while
  (if (setq elem1 (car (reverse ls)))
    (if (setq elem2 (car ls))
      (progn
        (setq
          p1 (cdr (assoc 10 (entget (cadr elem1))))
          p2 (cdr (assoc 11 (entget (cadr elem1))))
        ) ; end setq
        (setq
          p3 (cdr (assoc 10 (entget (caddr elem2))))
          p4 (cdr (assoc 11 (entget (caddr elem2))))
        ) ; end setq
        (if (setq pti (inters p1 p2 p3 p4 nil))
          (progn
            (if (< (distance pti p1) (distance pti p2))
              (setq p1 pti)
              (setq p2 pti)
            ) ; end if
            (if (< (distance pti p3) (distance pti p4))
              (setq p3 pti)
              (setq p4 pti)
            ) ; end if
          ) ;end progn
        ) ; end if
        (command
          ".line" p1 p2 ""
          ".line" p3 p4 ""
        ) ; end command
      ) ; end progn
    ) ; end if
  ) ; end if
  (command ".erase" selc "")
) ; end function

(defun c:malha(/ oldech olducs oldblip oldhigh cnivel selc0 selc1 selc2 pt ww)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)

  (command ".undo" "m")

  (setq olducsi (getvar "ucsicon"))
  (setvar "ucsicon" 0)
  (setq oldblip (getvar "blipmode"))
  (setvar "blipmode" 0)
  (setq oldhigh (getvar "highlight"))
  (setvar "highlight" 0)

  (command
    ".ucs" "d" "$WALL"
    ".ucs" "s" "$WALL"
  ) ; end command

  (setq cnivel (getvar "clayer"))
  (if (tblsearch "LAYER" "$WALL1")
    (command ".layer" "t" "$WALL1" "s" "$WALL1" "")
    (command ".layer" "m" "$WALL1" "")
  ) ; end if

  (setq ww (getdist (strcat "\nEspesura da parede <" (rtos #ESPCP 2 2) ">: ")))
  (if ww (setq #ESPCP ww))

  (prompt "\* Selecione a Malha *")
  (if (setq selc0 (ssget))
    (progn
      (command ".change" selc0 "" "p" "la" "0" "")
      (if (setq selc1 (ssget "x" '((0 . "LINE") (8 . "0"))) )
        (progn
          (setq vert (break_line selc1))
          (command ".erase" selc1 "")
          (if (tblsearch "LAYER" "$WALL2")
            (command ".layer" "t" "$WALL2" "s" "$WALL2" "")
            (command ".layer" "m" "$WALL2" "")
          ) ; end if
          (if (setq selc2 (ssget "x" '((0 . "LINE") (8 . "$WALL1"))) )
            (progn
              (double_line selc2)
              (command ".erase" selc2 "")
              (foreach pt vert (fillet_edges pt))
              (command ".change" (ssget "x" '((0 . "LINE") (8 . "$WALL2"))) "" "p" "la" "ARQ-ARQUITETURA" "")
            ) ; end progn
          ) ; end if
        ) ; end progn
      ) ; end if
    ) ; end progn
  ) ; end if

  (command
    ".ucs" "r" "$WALL"
    ".layer" "s" cnivel ""
    ".redraw"
  ) ; end command

  (command ".undo" "e")

  (setvar "highlight" oldhigh)
  (setvar "blipmode" oldblip)
  (setvar "ucsicon" olducsi)
  (setvar "cmdecho" oldech)
  (princ)
) ; end function

(princ)
