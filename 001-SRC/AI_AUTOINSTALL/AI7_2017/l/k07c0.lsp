
;;
;; k07c0.lsp
;; Copyright (C) 1999 by Luiz Marcio F A Viana, 11/22/99
;;

;; editext_text(): funcao de ajuste das entidades 'texto'
;; enm - ename da entidade
;; alt - nova altura para o texto
;; cap - capitalizacao das letras (maiusculas, minusculas ou indiferente)
(defun editext_text(enm alt cap / ent txt)
  (setq ent (entget enm))
  (setq txt (cdr (assoc 1 ent)) )
  (cond
    ( (= cap "MAiuscula") (setq txt (strcase txt nil)) )
    ( (= cap "MInuscula") (setq txt (strcase txt 't)) )
  ) ; end cond
  (setq ent (subst (cons 40 alt) (assoc 40 ent) ent))
  (entmod (subst (cons 1 txt) (assoc 1 ent) ent))
) ; end defun

;; editext_insert(): funcao de ajuste das entidades 'atributos'
;; enm - ename da entidade
;; alt - nova altura para o texto
;; cap - capitalizacao das letras (maiusculas, minusculas ou indiferente)
(defun editext_insert(enm alt cap / ent txt)
  (while (and (setq enm (entnext enm)) (= (enttype enm) "ATTRIB"))
    (setq ent (entget enm))
    (setq txt (cdr (assoc 1 ent)) )
    (cond
      ( (= cap "MAiuscula") (setq txt (strcase txt nil)) )
      ( (= cap "MInuscula") (setq txt (strcase txt 't)) )
    ) ; end cond
    (setq ent (subst (cons 40 alt) (assoc 40 ent) ent))
    (entmod (subst (cons 1 txt) (assoc 1 ent) ent))
    (entupd enm)
  ) ; end while
) ; end defun

;; c:editext(): rotina de ajuste do tamanho dos textos do desenho
(defun c:editext(/ oldmnu oldech sel alt cap ent cnt)

  (setq oldech (acadvar "cmdecho" 0))

  (prompt "\nSelecione os objetos para ajuste...")
  (setq sel (ssget))

  (setq oldmnu (ai_svar "promptmenu" 1))

  (initget "Micro Normal Super")
  (setq alt (getdist (strcat "\nAltura do texto - Micro/Normal/Super/<" (rtos (getvar "textsize") 2) ">: ")) )
  (if (null alt) (setq alt (getvar "textsize")) )

  (initget "MAiuscula MInuscula Indiferente")
  (setq cap (getkword "\nConverter para MAiuscula/MInuscula/<Indiferente>: "))

  (setvar "promptmenu" oldmnu)

  (cond
    ( (= alt "Micro")  (setq alt (* 1.5 (#SCL))) )
    ( (= alt "Normal") (setq alt (* 2.0 (#SCL))) )
    ( (= alt "Super")  (setq alt (* 4.0 (#SCL))) )
  ) ; end cond

  (setq cnt (sslength sel))
  (while (>= (setq cnt (1- cnt)) 0)
    (setq enm (ssname sel cnt))
    (cond
      ( (= (enttype enm) "TEXT") (editext_text enm alt cap) )
      ( (= (enttype enm) "INSERT") (editext_insert enm alt cap) )
    ) ; end cond
  ) ; end while

  (setvar "cmdecho" oldech)
  (princ)
) ;end defun

(princ)
