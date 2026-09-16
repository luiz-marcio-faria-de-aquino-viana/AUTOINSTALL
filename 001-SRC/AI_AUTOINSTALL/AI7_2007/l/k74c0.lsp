;
;;
;; K74C0.lsp
;; Copyright (C) 1997 by Fabio Henrique de Araujo
;;                       Luiz Marcio F A Viana, 1/24/97
;;

(defun c:lismat()
 ;;(setq oldech (acadvar "cmdecho" 0))
  
  (setq FILE "s:\\fabio\\Arquivo.dat")
  
  (prompt "\nSelecione os objetos [ENTER = TODOS]...")
  (if (null (setq ss (ssget)))
    (setq ss (ssget "x"))     
  ) ; end if
  
  (setq pb (getpoint "\nInforme o ponto base: "))

  (setq xb (car  pb)) 
  (setq yb (cadr pb))
    
  (setq xp1 ( +  (* (#SCL) 2.0) xb ))
  (setq yp1 ( +  (* (#SCL) 1.0) yb))

  (setq oldsty (getvar "textstyle"))
  (command "style" "monotxt" "monotxt" "" "" "" "" "" "")

  (setq f (open FILE "r"))
  (setq cont 0) 
  (while (/= (setq s (read-line f)) nil)
    (command "text" (list xp1 yp1) (* (#SCL) 2.0) 0 s)
    (setq yp1 ( + ( * (#SCL) 4.0) yp1))
    (setq cont (+ 1 cont))
  ) ; end while
  (setq f (close f))

  (command ".text" "s" oldsty nil)

  (setq xp2 xb)
  (setq yp2 (+ yb (* (#SCL) cont 4.0)) )
  (setq p2  (list xp2 yp2))

  (setq xp3 (+ xb (* (#SCL) 48.0 2.0)) )
  (setq yp3 yp2)
  (setq p3  (list xp3 yp3))

  (setq xp4 xp3)
  (setq yp4 yb)
  (setq p4 (list xp4 yp4))
  
  (command ".pline" pb "w" 0 0 p2 p3 p4 "c")
   
  (setq xl xb)
  (setq yl (+ yb (* (#SCL) 4.0)) )
  (setq xlf xp4)
  (setq ylf (+ yp4 (* (#SCL) 4.0)) )
  
  (repeat (- cont 1)
    (progn
      (command ".line" (list xl yl) (list xlf ylf) "")
      (setq yl  (+ (* (#SCL) 4.0) yl ))
      (setq ylf (+ (* (#SCL) 4.0) ylf))
    ) ; end progn
  ) ; end repeat

  (setq xlv1 (+ xp2 (* (#SCL) 10.0 2.0)) ) 
  (setq ylv1 yp2)
  (setq lv1  (list xlv1 ylv1))

  (setq xlv2 (+ xb (* (#SCL) 10.0 2.0) )) 
  (setq ylv2 yb)
  (setq lv2  (list xlv2 ylv2))

  (setq xlv3 (+ xlv1 ( * (#SCL) 30.0 2.0) ))
  (setq ylv3 ylv1)
  (setq lv3  (list xlv3 ylv3))
 
  (setq xlv4 (+ xlv2 ( * (#SCL) 30.0 2.0) ))
  (setq ylv4 ylv2)
  (setq lv4 (list xlv4 ylv4))
  
  (command 
    "line" lv1 lv2 ""
    "line" lv3 lv4 ""
  ) 
  
  ;;Escrevendo o cabecalho

  (setq pc (list (+ xp2 (* (#SCL) 10.0 ))  (+ yp2  ( * (#SCL) 3.0)) ))
  (setq pd (list (+ xp2 (* (#SCL) 45.0 ))  (+ yp2  ( * (#SCL) 3.0)) ))
  (setq pq (list (+ xp2 (* (#SCL) 87.50 )) (+ yp2  ( * (#SCL) 3.0)) ))
  
  (setq #CD   "CODIGO"     )  
  (setq #DSC  "DESCRICAO"  )
  (setq #QTDE "QTDE" )
  
  (command 
     
     "text" "m" pc (* (#SCL) 2.0) 0 #CD 
     "text" "m" pd (* (#SCL) 2.0) 0 #DSC 
     "text" "m" pq (* (#SCL) 2.0) 0 #QTDE 
 
 )
 ;;Desenhando o cabecalho

  (setq p5  (list xp2  (+ yp2  (* (#SCL) 6.0)) ))
  (setq p6  (list xp3  (+ yp3  (* (#SCL) 6.0)) ))
  (setq lv5 (list xlv1 (+ ylv1 (* (#SCL) 6.0)) ))
  (setq lv6 (list xlv3 (+ ylv3 (* (#SCL) 6.0)) ))
 
  (command
     ".pline" p2  "w" 0 0 p5 p6 p3 ""
     ".pline" lv1 "w" 0 0 lv5 ""
     ".pline" lv3 "w" 0 0 lv6 ""
  )

  (setvar "cmdecho" oldech)
  (princ)

)
