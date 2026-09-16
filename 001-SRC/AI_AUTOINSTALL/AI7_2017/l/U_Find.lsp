;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
^       Programador     : Hugo Antonio da Costa JR
^       Empresa         : iComS
^
^       Modulo          : 
^       Data de Entrega : 
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


(defun StrPos ( sub string / lensub  lenstring i pos)
       (setq i 1  lensub (strlen sub) lenstring (strlen string) pos -1)
       (while (<= i (+ (- lenstring lensub) 1) )

                  (if (= (substr string i lensub) sub)
                         (progn
                               (setq pos i)
                               (setq i (+ lenstring 10) )
                         )
                  )
                  (setq i (+ i 1))
       )
       pos
)


(defun ifind_AddLista()
        (setq  txt1  ifind_find  txt2 (cdr (assoc 1 dat)) )

        (if (= ifind_opt1 "0")
            (setq  txt1 (strcase txt1)  txt2 (strcase txt2) )
        )

        (if (= ifind_opt2 "0")
               (progn (setq condicao (/= (StrPos txt1 txt2) -1)))
               (progn (setq condicao (and (/= (StrPos txt1 txt2) -1)  (= (strlen txt1) (strlen txt2)))))
        )

        (if condicao
            (progn
                (setq ifind_ListaEnt        (cons (cdr (assoc 1       dat))  ifind_ListaEnt))
                (setq ifind_ListaPontos     (cons     pcc                    ifind_ListaPontos))
                (setq ifind_DadosDaEntidade (cons     dat                    ifind_DadosDaEntidade))
            )
        )
)

(defun ifind_FilterEnt( TipoEnt / elementos cont qtdele)
    (setq
         elementos (ssget "X"  (list  (cons 0 TipoEnt)))
         cont      0
    )

    (if elementos
        (progn (setq qtdele (sslength elementos)))
        (progn (setq qtdele 0))
    )

    (while (< cont qtdele)
        (setq ent (ssname elementos cont))

        (setq pcc (cdr (assoc 10 (entget ent))) )
        (if  (= TipoEnt "INSERT")
                (progn
                      (setq ent (entnext ent))
                      (setq dat (entget ent))

                      (while (= (cdr (assoc 0  dat)) "ATTRIB")

                        (setq pcc (cdr (assoc 10 dat)))
                        (ifind_AddLista)
                        (setq ent (entnext ent))
                        (setq dat (entget ent))
                      )
                )
                (progn
                  (setq dat (entget ent))
                  (ifind_AddLista)
                )
        )
        (setq cont (+ cont 1))
    )

)

(defun ifind_Localizar( reler )
    (setq ifind_ListaEnt  nil   ifind_ListaPontos nil  ifind_DadosDaEntidade nil)

    (if (= reler 1)
    	(progn
	    (if  (= ifind_opt3 "1")  (ifind_FilterEnt   "TEXT"      ))
	    (if  (= ifind_opt3 "1")  (ifind_FilterEnt   "MTEXT"     ))
	    (if  (= ifind_opt4 "1")  (ifind_FilterEnt   "INSERT"    ))
	    (setq ifind_LastListFind ifind_ListaEnt)
	    (alert "Fim da Pesquisa !!!")
	)   
    )
    
    (start_list "TextosEncontrados")
    (mapcar 'add_list ifind_LastListFind)
    (end_list)
    (set_tile "TextosEncontrados" ifind_cmdpo)
)

(defun ifind_AtualizaPos( pnl )
    (if (= ifind_opt5 "1")
           (progn
                 (setq NovoTexto (ChangeChar (nth pnl ifind_ListaEnt) ifind_find ifind_replace)  )
           )
           (progn
                 (setq NovoTexto ifind_replace)
           )
    )
   (setq dados (nth pnl ifind_DadosDaEntidade))
   (setq dados (subst (cons 1 NovoTexto)  (assoc 1 dados)  dados))
   (entmod dados)
   (entupd (cdr (assoc -1 dados))  )
)


(defun ifind_GeraPonto ( ponto offx offy offz )
	(list (+ (car ponto) offx) (+ (cadr ponto) offy) (+ (caddr ponto) offz) )
)



(defun ifind_cmdW ()
    (if  ifind_ListaPontos
        (progn
            (setq ifind_PosNaLista  (atoi ifind_cmdpo)  )
            (setq ifind_PontoDoZoom (nth  ifind_PosNaLista ifind_ListaPontos)  )
             

            (cond
                 ( (= ifind_cmd 1)
                         (command 
                         	"Zoom" 
                         	(ifind_GeraPonto ifind_PontoDoZoom  0  0 0)
                         	(ifind_GeraPonto ifind_PontoDoZoom 60 60 0)
                         	
                         )
                 )

                 ( (= ifind_cmd 2)
                         (ifind_AtualizaPos ifind_PosNaLista)
                 )
                 ( (= ifind_cmd 3)
                         (setq pos 0)
                         (while  (< pos (length ifind_ListaPontos))
                                    (ifind_AtualizaPos pos)
                                    (setq pos (+ pos 1))
                         )
                 )
            )
        )
    )
)





(defun c:ifind()

  (setvar "cmdecho" 0)
  (setq form  (load_dialog "U_find.dcl"))
  (new_dialog "IFIND" form)
  (setq ifind_cmd nil)
 
 
  (if (= ifind_find    nil) (setq ifind_find    ""))
  (if (= ifind_replace nil) (setq ifind_replace ""))
  (if (= ifind_cmdpo  nil)  (setq ifind_cmdpo  "0"))

  
  (ifind_Localizar 0)

  (if (= ifind_opt1 nil) (setq ifind_opt1 "0"))
  (if (= ifind_opt2 nil) (setq ifind_opt2 "1"))
  (if (= ifind_opt3 nil) (setq ifind_opt3 "1"))
  (if (= ifind_opt4 nil) (setq ifind_opt4 "1"))
  (if (= ifind_opt5 nil) (setq ifind_opt5 "0"))

  (set_tile  "find"     ifind_find)
  (set_tile  "replace"  ifind_replace)

  (set_tile "opt1" ifind_opt1)
  (set_tile "opt2" ifind_opt2)
  (set_tile "opt3" ifind_opt3)
  (set_tile "opt4" ifind_opt4)
  (set_tile "opt5" ifind_opt5)

  (action_tile  "find"               "(setq ifind_find      (get_tile \"find\"))")
  (action_tile  "replace"            "(setq ifind_replace   (get_tile \"replace\"))")

  (action_tile  "botaoSubstituir"    "(setq ifind_cmd 2)   (done_dialog)")
  (action_tile  "botaoST"            "(setq ifind_cmd 3)   (done_dialog)")
   
  (action_tile  "botaoZoom"          "(setq ifind_cmd 1)   (done_dialog)")
  (action_tile  "botaoLocal"         "(ifind_Localizar 1)")
  (action_tile  "TextosEncontrados"  "(setq ifind_cmdpo (get_tile \"TextosEncontrados\"))")

  (action_tile  "opt1"      "(setq ifind_opt1    (get_tile \"opt1\"))")
  (action_tile  "opt2"      "(setq ifind_opt2    (get_tile \"opt2\"))")
  (action_tile  "opt3"      "(setq ifind_opt3    (get_tile \"opt3\"))")
  (action_tile  "opt4"      "(setq ifind_opt4    (get_tile \"opt4\"))")
  (action_tile  "opt5"      "(setq ifind_opt5    (get_tile \"opt5\"))")

  (start_dialog)
  (setvar "cmdecho" 1)
  (if ifind_cmd (progn (ifind_cmdW) (c:ifind)))
)

