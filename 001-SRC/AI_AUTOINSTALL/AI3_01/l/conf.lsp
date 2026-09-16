
;;
;; CONF.lsp
;; Copyright (C) 1997 by Luiz Marcio F A Viana, 11/24/97
;;

;; conf(): funcao que obtem a configuracao do desenho
(defun conf(/ errmsg ss fset fdwg f ln1 ln2 ln3 enm ent tag verno und scl escl larg alt owner date)
  (setq errmsg nil)
  (if (null (setq ss (ssget "x" '((0 . "INSERT") (2 . "SET0EC00"))) ) )
    (progn
      ;; processa desenho criado por uma versao anterior ou igual a 2.25
      (setq
        fset (strcat (getvar "dwgname") ".set")
        fdwg (strcat (getvar "dwgname") ".dwg")
      ) ; end setq
      (if (and (findfile fdwg) (findfile fset))
        (if (setq f (open fset "r"))
          (progn
            (setq ln1 (read-line f))    ;; linha que determina a versao do desenho (AI-V2.1) ou unidade (AI-V1.0)
            (setq ln2 (read-line f))    ;; linha que determina a unidade (AI-V2.1) ou escala de trabalho (AI-V1.0)
            (setq ln3 (read-line f))    ;; linha que determina a escala de trabalho (AI-V2.1)
            (setq f (close f))
            (if (or (= ln1 "AI2.25") (= ln1 "AI-V2.1"))
              (progn
                ;; processa desenho criado pelas versoes 2.1 e 2.25
                (if (and ln1 ln2 ln3)
                  (setq
                     verno ln1
                     und   (atof ln2)
                     scl   (atof ln3)
                  ) ; end setq
                  (setq errmsg "ERR: Arquivo de configuracao danificado.")
                ) ; end if
              ) ; end progn
              (progn
                ;; processa desenho criado pela versao 1.0
                (if (and ln1 ln2)
		  (progn
                    (setq
                      verno "AI-V1.0"
                      und   (atof ln1)
                      scl   (atof ln2)
                    ) ; end setq
                    (loadf"k22c0")    ;; transforma camadas da versao 1.0 para a 2.1 e posterior
                    (loadf"k25c0")    ;; transforma espesura das tubulacoes da versao 1.0 para a 2.1 e posterior
		  ) ; end progn
                  (setq errmsg "ERR: Arquivo de configuracao danificado.")
                ) ; end if
              ) ; end progn
            ) ; end if
            (setq
              escl   (* #UND #SCL)
              larg   (car (getvar "limmax"))
              alt    (cadr (getvar "limmax"))
              owner  "ANNONYMOUS"
              date   "??/??/??"
            ) ; end setq
            ;; atualizando formato dos atributos de configuracao
            (command ".insert" (V:AID "SET/SET0EC00") "0,0" #SCL "" "0")
            (setq enm (entlast))
            (while (and (setq enm (entnext enm)) (/= (cdr (assoc 0 (setq ent (entget enm)))) "SEQEND") )
              (setq tag (cdr (assoc 2 ent)))
              (cond
                ((= tag "#VER")   (setq ent (subst (cons 1 verno) (assoc 1 ent) ent)) )
                ((= tag "#LARG")  (setq ent (subst (cons 1 (rtos larg 2 6)) (assoc 1 ent) ent)) )
                ((= tag "#ALT")   (setq ent (subst (cons 1 (rtos alt  2 6)) (assoc 1 ent) ent)) )
                ((= tag "#ESCL")  (setq ent (subst (cons 1 (rtos escl 2 6)) (assoc 1 ent) ent)) )
                ((= tag "#UNID")  (setq ent (subst (cons 1 (rtos und 2 6)) (assoc 1 ent) ent)) )
                ((= tag "#OWNER") (setq ent (subst (cons 1 owner) (assoc 1 ent) ent)) )
                ((= tag "#DATE")  (setq ent (subst (cons 1 date) (assoc 1 ent) ent)) )
              ) ; end cond
              (entmod ent)
            ) ; end while
          ) ; end progn
          (setq msgerr "ATT: Nao foi possivel abrir o arquivo de configuracao.")
        ) ; end if
        (setq errmsg "ATT: Desenho sem configuracao definida.")
      ) ; end if
    ) ; end progn
    (progn
      ;; desenho criado por versoes posteriores a 2.25
      (setq enm (ssname ss (- (sslength ss) 1)) )
      (while (and (setq enm (entnext enm)) (/= (cdr (assoc 0 (setq ent (entget enm)))) "SEQEND") )
        (progn
          (setq tag (cdr (assoc 2 ent)))
          (cond
            ((= tag   "#VER") (setq verno (cdr (assoc 1 ent))) )
            ((= tag  "#LARG") (setq larg  (atof (cdr (assoc 1 ent)))) )
            ((= tag   "#ALT") (setq alt (atof (cdr (assoc 1 ent)))) )
            ((= tag  "#ESCL") (setq escl (atof (cdr (assoc 1 ent)))) )
            ((= tag  "#UNID") (setq und (atof (cdr (assoc 1 ent)))) )
            ((= tag "#OWNER") (setq owner (cdr (assoc 1 ent))) )
            ((= tag  "#DATE") (setq date (cdr (assoc 1 ent))) )
          ) ; end cond
        ) ; end progn
      ) ; end while
      (setq scl (/ escl und))
    ) ; end progn
  ) ; end if

  (if errmsg
    (progn
      (prompt (strcat "\n\n" errmsg))
      (c:ddsetup)
    ) ; end progn
    (progn
      (setvar "users1" verno)
      (setvar "userr1" escl)
      (setvar "userr2" und)
      (setvar "userr3" larg)
      (setvar "userr4" alt)
      (setvar "users2" owner)
      (setvar "users3" date)
      (setvar "dimscale" scl)
    ) ; end progn
  ) ; end if

  (if verno
    (progn
      (textscr)
      (prompt "\n\n\nPROPRIEDADES DO DESENHO:")
      (prompt "\n========================")
      (prompt (strcat "\n\nVERSAO  = " (#VER)))
      (prompt (strcat "\n\nESCALA  = " (rtos (#ESCL) 2 2)) )
      (prompt (strcat "\nUNIDADE = " (rtos (#UND)  2 2) "\t(milimetro = 1)") )
    ) ; end progn
  ) ; end if
  (princ)
) ; end defun

(princ)
