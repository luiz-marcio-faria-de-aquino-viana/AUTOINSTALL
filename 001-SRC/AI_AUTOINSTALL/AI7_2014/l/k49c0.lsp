(defun c:pe(/ ss ent lt et)
  (setq ss (entsel "\nSelecione o tipo de objeto: "))
  (setq
    ent (entget (car ss))
    lt (cdr (assoc 8 ent))
    et (cdr (assoc 0 ent))
  ) ; end setq
  (command "erase" (ssget "x" (list (cons 0 et) (cons 8 lt))) "")
  (princ)
) ; end function
