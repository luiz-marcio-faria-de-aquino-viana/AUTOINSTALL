
;;
;; K6AC0.lsp
;; Copyright (C) 1996 by Luiz Marcio Faria Viana, 9/20/96
;;

;; tiplum: funcao que retorna o tipo da luminaria especificada
;;  enm - ename da entidade que representa a luminaria
(defun tiplum(enm / TBLUM)
  (setq
    TBLUM '(("ELE200C2" "20W;1;E;N")  ("ELE201C2" "20W;1;E;V")
            ("ELE202C2" "20W;1;E;E")  ("ELE203C2" "20W;1;P;N")
            ("ELE204C2" "20W;1;P;V")  ("ELE205C2" "20W;1;P;E")
            ("ELE206C2" "20W;1;S;N")  ("ELE207C2" "20W;1;S;V")
            ("ELE208C2" "20W;1;S;E")  ("ELE209C2" "20W;2;E;N")
            ("ELE20AC2" "20W;2;E;V")  ("ELE20BC2" "20W;2;E;E")
            ("ELE20CC2" "20W;2;P;N")  ("ELE20DC2" "20W;2;P;V")
            ("ELE20EC2" "20W;2;P;E")  ("ELE20FC2" "20W;2;S;N")
            ("ELE210C2" "20W;2;S;V")  ("ELE211C2" "20W;2;S;E")
            ("ELE212C2" "20W;4;E;N")  ("ELE213C2" "20W;4;E;V")
            ("ELE214C2" "20W;4;E;E")  ("ELE215C2" "20W;4;P;N")
            ("ELE216C2" "20W;4;P;V")  ("ELE217C2" "20W;4;P;E")
            ("ELE218C2" "20W;4;S;N")  ("ELE219C2" "20W;4;S;V")
            ("ELE21AC2" "20W;4;S;E")  ("ELE21BC2" "20W;6;E;N")
            ("ELE21CC2" "20W;6;E;V")  ("ELE21DC2" "20W;6;E;E")
            ("ELE21EC2" "20W;6;P;N")  ("ELE21FC2" "20W;6;P;V")
            ("ELE220C2" "20W;6;P;E")  ("ELE221C2" "20W;6;S;N")
            ("ELE222C2" "20W;6;S;V")  ("ELE223C2" "20W;6;S;E")
            ("ELE224C2" "20W;8;E;N")  ("ELE225C2" "20W;8;E;V")
            ("ELE226C2" "20W;8;E;E")  ("ELE227C2" "20W;8;P;N")
            ("ELE228C2" "20W;8;P;V")  ("ELE229C2" "20W;8;P;E")
            ("ELE22AC2" "20W;8;S;N")  ("ELE22BC2" "20W;8;S;V")
            ("ELE22CC2" "20W;8;S;E")
            ("ELE22DC2" "40W;1;E;N")  ("ELE22EC2" "40W;1;E;V")
            ("ELE22FC2" "40W;1;E;E")  ("ELE230C2" "40W;1;P;N")
            ("ELE231C2" "40W;1;P;V")  ("ELE232C2" "40W;1;P;E")
            ("ELE233C2" "40W;1;S;N")  ("ELE234C2" "40W;1;S;V")
            ("ELE235C2" "40W;1;S;E")  ("ELE236C2" "40W;2;E;N")
            ("ELE237C2" "40W;2;E;V")  ("ELE238C2" "40W;2;E;E")
            ("ELE239C2" "40W;2;P;N")  ("ELE23AC2" "40W;2;P;V")
            ("ELE23BC2" "40W;2;P;E")  ("ELE23CC2" "40W;2;S;N")
            ("ELE23DC2" "40W;2;S;V")  ("ELE23EC2" "40W;2;S;E")
            ("ELE23FC2" "40W;4;E;N")  ("ELE240C2" "40W;4;E;V")
            ("ELE241C2" "40W;4;E;E")  ("ELE242C2" "40W;4;P;N")
            ("ELE243C2" "40W;4;P;V")  ("ELE244C2" "40W;4;P;E")
            ("ELE245C2" "40W;4;S;N")  ("ELE246C2" "40W;4;S;V")
            ("ELE247C2" "40W;4;S;E")  ("ELE248C2" "40W;6;E;N")
            ("ELE249C2" "40W;6;E;V")  ("ELE24AC2" "40W;6;E;E")
            ("ELE24BC2" "40W;6;P;N")  ("ELE24CC2" "40W;6;P;V")
            ("ELE24DC2" "40W;6;P;E")  ("ELE24EC2" "40W;6;S;N")
            ("ELE24FC2" "40W;6;S;V")  ("ELE250C2" "40W;6;S;E")
            ("ELE251C2" "40W;8;E;N")  ("ELE252C2" "40W;8;E;V")
            ("ELE253C2" "40W;8;E;E")  ("ELE254C2" "40W;8;P;N")
            ("ELE255C2" "40W;8;P;V")  ("ELE256C2" "40W;8;P;E")
            ("ELE257C2" "40W;8;S;N")  ("ELE258C2" "40W;8;S;V")
            ("ELE259C2" "40W;8;S;E")
            ("ELE25AC2" "65W;1;E;N")  ("ELE25BC2" "65W;1;E;V")
            ("ELE25CC2" "65W;1;E;E")  ("ELE25DC2" "65W;1;P;N")
            ("ELE25EC2" "65W;1;P;V")  ("ELE25FC2" "65W;1;P;E")
            ("ELE260C2" "65W;1;S;N")  ("ELE261C2" "65W;1;S;V")
            ("ELE262C2" "65W;1;S;E")  ("ELE263C2" "65W;2;E;N")
            ("ELE264C2" "65W;2;E;V")  ("ELE265C2" "65W;2;E;E")
            ("ELE266C2" "65W;2;P;N")  ("ELE267C2" "65W;2;P;V")
            ("ELE268C2" "65W;2;P;E")  ("ELE269C2" "65W;2;S;N")
            ("ELE26AC2" "65W;2;S;V")  ("ELE26BC2" "65W;2;S;E")
            ("ELE26CC2" "65W;4;E;N")  ("ELE26DC2" "65W;4;E;V")
            ("ELE26EC2" "65W;4;E;E")  ("ELE26FC2" "65W;4;P;N")
            ("ELE270C2" "65W;4;P;V")  ("ELE271C2" "65W;4;P;E")
            ("ELE272C2" "65W;4;S;N")  ("ELE273C2" "65W;4;S;V")
            ("ELE274C2" "65W;4;S;E")  ("ELE275C2" "65W;6;E;N")
            ("ELE276C2" "65W;6;E;V")  ("ELE277C2" "65W;6;E;E")
            ("ELE278C2" "65W;6;P;N")  ("ELE279C2" "65W;6;P;V")
            ("ELE27AC2" "65W;6;P;E")  ("ELE27BC2" "65W;6;S;N")
            ("ELE27CC2" "65W;6;S;V")  ("ELE27DC2" "65W;6;S;E")
            ("ELE27EC2" "65W;8;E;N")  ("ELE27FC2" "65W;8;E;V")
            ("ELE280C2" "65W;8;E;E")  ("ELE281C2" "65W;8;P;N")
            ("ELE282C2" "65W;8;P;V")  ("ELE283C2" "65W;8;P;E")
            ("ELE284C2" "65W;8;S;N")  ("ELE285C2" "65W;8;S;V")
            ("ELE286C2" "65W;8;S;E")
            ("ELE287C2" "85W;1;E;N")  ("ELE288C2" "85W;1;E;V")
            ("ELE289C2" "85W;1;E;E")  ("ELE28AC2" "85W;1;P;N")
            ("ELE28BC2" "85W;1;P;V")  ("ELE28CC2" "85W;1;P;E")
            ("ELE28DC2" "85W;1;S;N")  ("ELE28EC2" "85W;1;S;V")
            ("ELE28FC2" "85W;1;S;E")  ("ELE290C2" "85W;2;E;N")
            ("ELE291C2" "85W;2;E;V")  ("ELE292C2" "85W;2;E;E")
            ("ELE293C2" "85W;2;P;N")  ("ELE294C2" "85W;2;P;V")
            ("ELE295C2" "85W;2;P;E")  ("ELE296C2" "85W;2;S;N")
            ("ELE297C2" "85W;2;S;V")  ("ELE298C2" "85W;2;S;E")
            ("ELE299C2" "105W;1;E;N") ("ELE29AC2" "105W;1;E;V")
            ("ELE29BC2" "105W;1;E;E") ("ELE29CC2" "105W;1;P;N")
            ("ELE29DC2" "105W;1;P;V") ("ELE29EC2" "105W;1;P;E")
            ("ELE29FC2" "105W;1;S;N") ("ELE2A0C2" "105W;1;S;V")
            ("ELE2A1C2" "105W;1;S;E") ("ELE2A2C2" "105W;2;E;N")
            ("ELE2A3C2" "105W;2;E;V") ("ELE2A4C2" "105W;2;E;E")
            ("ELE2A5C2" "105W;2;P;N") ("ELE2A6C2" "105W;2;P;V")
            ("ELE2A7C2" "105W;2;P;E") ("ELE2A8C2" "105W;2;S;N")
            ("ELE2A9C2" "105W;2;S;V") ("ELE2AAC2" "105W;2;S;E") )
  ); end setq
  (cadr (assoc (cdr (assoc 2 (entget enm))) TBLUM))
) ; end defun

;; blklum: funcao que retorna bloco em funcao das especificacoes da luminaria
;;  esp - especificacoes da luminaria no formato (Pot;Qtd;Mod;Cir)
(defun blklum(esp / TBLUM)
  (setq
    TBLUM '(("20W;1;E;N" "ELE200C2") ("20W;1;E;V" "ELE201C2")
            ("20W;1;E;E" "ELE202C2") ("20W;1;P;N" "ELE203C2")
            ("20W;1;P;V" "ELE204C2") ("20W;1;P;E" "ELE205C2")
            ("20W;1;S;N" "ELE206C2") ("20W;1;S;V" "ELE207C2")
            ("20W;1;S;E" "ELE208C2") ("20W;2;E;N" "ELE209C2")
            ("20W;2;E;V" "ELE20AC2") ("20W;2;E;E" "ELE20BC2")
            ("20W;2;P;N" "ELE20CC2") ("20W;2;P;V" "ELE20DC2")
            ("20W;2;P;E" "ELE20EC2") ("20W;2;S;N" "ELE20FC2")
            ("20W;2;S;V" "ELE210C2") ("20W;2;S;E" "ELE211C2")
            ("20W;4;E;N" "ELE212C2") ("20W;4;E;V" "ELE213C2")
            ("20W;4;E;E" "ELE214C2") ("20W;4;P;N" "ELE215C2")
            ("20W;4;P;V" "ELE216C2") ("20W;4;P;E" "ELE217C2")
            ("20W;4;S;N" "ELE218C2") ("20W;4;S;V" "ELE219C2")
            ("20W;4;S;E" "ELE21AC2") ("20W;6;E;N" "ELE21BC2")
            ("20W;6;E;V" "ELE21CC2") ("20W;6;E;E" "ELE21DC2")
            ("20W;6;P;N" "ELE21EC2") ("20W;6;P;V" "ELE21FC2")
            ("20W;6;P;E" "ELE220C2") ("20W;6;S;N" "ELE221C2")
            ("20W;6;S;V" "ELE222C2") ("20W;6;S;E" "ELE223C2")
            ("20W;8;E;N" "ELE224C2") ("20W;8;E;V" "ELE225C2")
            ("20W;8;E;E" "ELE226C2") ("20W;8;P;N" "ELE227C2")
            ("20W;8;P;V" "ELE228C2") ("20W;8;P;E" "ELE229C2")
            ("20W;8;S;N" "ELE22AC2") ("20W;8;S;V" "ELE22BC2")
            ("20W;8;S;E" "ELE22CC2")
            ("40W;1;E;N" "ELE22DC2") ("40W;1;E;V" "ELE22EC2")
            ("40W;1;E;E" "ELE22FC2") ("40W;1;P;N" "ELE230C2")
            ("40W;1;P;V" "ELE231C2") ("40W;1;P;E" "ELE232C2")
            ("40W;1;S;N" "ELE233C2") ("40W;1;S;V" "ELE234C2")
            ("40W;1;S;E" "ELE235C2") ("40W;2;E;N" "ELE236C2")
            ("40W;2;E;V" "ELE237C2") ("40W;2;E;E" "ELE238C2")
            ("40W;2;P;N" "ELE239C2") ("40W;2;P;V" "ELE23AC2")
            ("40W;2;P;E" "ELE23BC2") ("40W;2;S;N" "ELE23CC2")
            ("40W;2;S;V" "ELE23DC2") ("40W;2;S;E" "ELE23EC2")
            ("40W;4;E;N" "ELE23FC2") ("40W;4;E;V" "ELE240C2")
            ("40W;4;E;E" "ELE241C2") ("40W;4;P;N" "ELE242C2")
            ("40W;4;P;V" "ELE243C2") ("40W;4;P;E" "ELE244C2")
            ("40W;4;S;N" "ELE245C2") ("40W;4;S;V" "ELE246C2")
            ("40W;4;S;E" "ELE247C2") ("40W;6;E;N" "ELE248C2")
            ("40W;6;E;V" "ELE249C2") ("40W;6;E;E" "ELE24AC2")
            ("40W;6;P;N" "ELE24BC2") ("40W;6;P;V" "ELE24CC2")
            ("40W;6;P;E" "ELE24DC2") ("40W;6;S;N" "ELE24EC2")
            ("40W;6;S;V" "ELE24FC2") ("40W;6;S;E" "ELE250C2")
            ("40W;8;E;N" "ELE251C2") ("40W;8;E;V" "ELE252C2")
            ("40W;8;E;E" "ELE253C2") ("40W;8;P;N" "ELE254C2")
            ("40W;8;P;V" "ELE255C2") ("40W;8;P;E" "ELE256C2")
            ("40W;8;S;N" "ELE257C2") ("40W;8;S;V" "ELE258C2")
            ("40W;8;S;E" "ELE259C2")
            ("65W;1;E;N" "ELE25AC2") ("65W;1;E;V" "ELE25BC2")
            ("65W;1;E;E" "ELE25CC2") ("65W;1;P;N" "ELE25DC2")
            ("65W;1;P;V" "ELE25EC2") ("65W;1;P;E" "ELE25FC2")
            ("65W;1;S;N" "ELE260C2") ("65W;1;S;V" "ELE261C2")
            ("65W;1;S;E" "ELE262C2") ("65W;2;E;N" "ELE263C2")
            ("65W;2;E;V" "ELE264C2") ("65W;2;E;E" "ELE265C2")
            ("65W;2;P;N" "ELE266C2") ("65W;2;P;V" "ELE267C2")
            ("65W;2;P;E" "ELE268C2") ("65W;2;S;N" "ELE269C2")
            ("65W;2;S;V" "ELE26AC2") ("65W;2;S;E" "ELE26BC2")
            ("65W;4;E;N" "ELE26CC2") ("65W;4;E;V" "ELE26DC2")
            ("65W;4;E;E" "ELE26EC2") ("65W;4;P;N" "ELE26FC2")
            ("65W;4;P;V" "ELE270C2") ("65W;4;P;E" "ELE271C2")
            ("65W;4;S;N" "ELE272C2") ("65W;4;S;V" "ELE273C2")
            ("65W;4;S;E" "ELE274C2") ("65W;6;E;N" "ELE275C2")
            ("65W;6;E;V" "ELE276C2") ("65W;6;E;E" "ELE277C2")
            ("65W;6;P;N" "ELE278C2") ("65W;6;P;V" "ELE279C2")
            ("65W;6;P;E" "ELE27AC2") ("65W;6;S;N" "ELE27BC2")
            ("65W;6;S;V" "ELE27CC2") ("65W;6;S;E" "ELE27DC2")
            ("65W;8;E;N" "ELE27EC2") ("65W;8;E;V" "ELE27FC2")
            ("65W;8;E;E" "ELE280C2") ("65W;8;P;N" "ELE281C2")
            ("65W;8;P;V" "ELE282C2") ("65W;8;P;E" "ELE283C2")
            ("65W;8;S;N" "ELE284C2") ("65W;8;S;V" "ELE285C2")
            ("65W;8;S;E" "ELE286C2")
            ("85W;1;E;N" "ELE287C2") ("85W;1;E;V" "ELE288C2")
            ("85W;1;E;E" "ELE289C2") ("85W;1;P;N" "ELE28AC2")
            ("85W;1;P;V" "ELE28BC2") ("85W;1;P;E" "ELE28CC2")
            ("85W;1;S;N" "ELE28DC2") ("85W;1;S;V" "ELE28EC2")
            ("85W;1;S;E" "ELE28FC2") ("85W;2;E;N" "ELE290C2")
            ("85W;2;E;V" "ELE291C2") ("85W;2;E;E" "ELE292C2")
            ("85W;2;P;N" "ELE293C2") ("85W;2;P;V" "ELE294C2")
            ("85W;2;P;E" "ELE295C2") ("85W;2;S;N" "ELE296C2")
            ("85W;2;S;V" "ELE297C2") ("85W;2;S;E" "ELE298C2")
            ("105W;1;E;N" "ELE299C2") ("105W;1;E;V" "ELE29AC2")
            ("105W;1;E;E" "ELE29BC2") ("105W;1;P;N" "ELE29CC2")
            ("105W;1;P;V" "ELE29DC2") ("105W;1;P;E" "ELE29EC2")
            ("105W;1;S;N" "ELE29FC2") ("105W;1;S;V" "ELE2A0C2")
            ("105W;1;S;E" "ELE2A1C2") ("105W;2;E;N" "ELE2A2C2")
            ("105W;2;E;V" "ELE2A3C2") ("105W;2;E;E" "ELE2A4C2")
            ("105W;2;P;N" "ELE2A5C2") ("105W;2;P;V" "ELE2A6C2")
            ("105W;2;P;E" "ELE2A7C2") ("105W;2;S;N" "ELE2A8C2")
            ("105W;2;S;V" "ELE2A9C2") ("105W;2;S;E" "ELE2AAC2"))
  ); end setq
  (cadr (assoc esp TBLUM))
) ; end defun

;; ultlum: funcao que detecta a ultima luminaria do desenho
(defun ultlum(/ rst ss num cnt)
  (setq rst nil)
  (if (setq ss (ssget "x" '((0 . "INSERT") (8 . "EL-PONTOS"))))
    (progn
      (setq num (sslength ss))
      (setq cnt 0)
      (while (and (null rst) (< cnt num))
        (setq rst (tiplum (ssname ss cnt)))
        (setq cnt (+ cnt 1))
      ) ; end while
    ) ; end progn
  ) ; end if
  (if (null rst)
    "40W;2;E;N"
    rst
  ) ; end if
) ; end defun

;; setlum: funcao que seleciona a luminaria em funcao de suas especificacoes
;;  pot - potencia da lampada utilizada na luminaria
;;  qtd - quantidade de lampadas suportadas pela luminaria
;;  mod - modelo da luminaria (embutir, sobrepor ou pendente)
;;  cir - tipo de circuito da luminaria (normal, vigia ou emergencia)
(defun setlum(pot qtd mod cir / blk esp)
  (if (null #ESPL) (setq #ESPL (ultlum)))
  (setq esp (strcat pot ";" qtd ";" mod ";" cir))
  (if (setq blk (blklum esp))
    (setq #ESPL esp)
  ) ; end setq
  blk
) ; end defun

;; c:setlum: rotina para selecionar a luminaria a ser inserida
(defun c:setlum(/ pot qtd mod cir blk)
  (if (null #ESPL) (setq #ESPL (ultlum)))

  (initget "20W 40W 65W 85W 105W")
  (setq pot (getkword
    (strcat "\nPotencia das lampadas <" (strpiece #ESPL 1 ";") ">: ")))
  (if (null pot) (setq pot (strpiece #ESPL 1 ";")))

  (initget "1 2 4 6 8")
  (setq qtd (getkword
    (strcat "\nQuantidade de lampadas <" (strpiece #ESPL 2 ";") ">: ")))
  (if (null qtd) (setq qtd (strpiece #ESPL 2 ";")))

  (initget "E P S")
  (setq mod (getkword
    (strcat "\nModelo da luminaria (E)mbutir, (P)endente ou (S)obrepor <"
      (strpiece #ESPL 3 ";") ">: ")))
  (if (null mod) (setq mod (strpiece #ESPL 3 ";")))

  (initget "N V E")
  (setq cir (getkword
    (strcat "\nTipo de circuito (N)ormal, (V)igia ou (E)mergencia <"
      (strpiece #ESPL 4 ";") ">: ")))
  (if (null cir) (setq cir (strpiece #ESPL 4 ";")))

  (if (setq blk (setlum pot qtd mod cir))
    (progn
      (setq #BLCK (strcat "ELE/" blk))
      (prompt "\nLuminaria ")
      (cond
        ((= mod "E") (prompt "(Embutir)"))
        ((= mod "P") (prompt "(Pendente)"))
        ((= mod "S") (prompt "(Sobrepor)"))
      ) ; end cond
      (prompt (strcat " = " (strpiece #ESPL 2 ";") "x" (strpiece #ESPL 1 ";") ", "))
      (cond
        ((= cir "N") (prompt "Normal"))
        ((= cir "V") (prompt "Vigia"))
        ((= cir "E") (prompt "Emergencia"))
      ) ; end cond
    ) ; end progn
    (prompt "\nERR: Modelo de luminaria inexistente.")
  ) ; end if
  (princ)
) ; end defun

(princ)
