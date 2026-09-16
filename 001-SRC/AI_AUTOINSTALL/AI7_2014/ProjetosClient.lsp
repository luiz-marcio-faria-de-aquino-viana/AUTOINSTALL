;;;;; INICIO: Projetos.Com

(defun PRJCLI() (progn (getenv"PROJETOSCLIENT_HOME")))

(defun callProjetosClientOpenDWG()
	(prompt "\nOpenDWG()")
	(if (not (eq (strcase (getvar "dwgname") nil) "DRAWING1.DWG") )
		(progn
			(setq cmd 
				(strcat (PRJCLI)
					"\\CallProjetosClientOpenDWG.bat" 
					" \""
				  	(getvar "dwgprefix") 
				  	(getvar "dwgname")
				  	"\""
			)	) ; end strcat, setq
			(prompt (strcat "\nOPEN => " cmd))
			(command "shell" cmd)
		) ; end progn
	) ; end if
) ; end defun

(defun callProjetosClientCloseDWG()
	(prompt "\nCloseDWG()")
	(if (not (eq (strcase (getvar "dwgname") nil) "DRAWING1.DWG") )
		(progn
			(setq cmd 
				(strcat (PRJCLI)
					"\\CallProjetosClientCloseDWG.bat" 
					" \""
				  	(getvar "dwgprefix") 
				  	(getvar "dwgname")
				  	"\""
			)	) ; end strcat, setq
			(prompt (strcat "\nCLOSE => " cmd))
			(command "shell" cmd)
		) ; end progn
	) ; end if
) ; end defun

(defun callProjetosClientCloseAllDWG()
	(prompt "\nCloseAllDWG()")
	(setq cmd (strcat (PRJCLI) "\\CallProjetosClientCloseAllDWG.bat"))
	(prompt (strcat "\nCLOSE => " cmd))
	(command "shell" cmd)
) ; end defun

(callProjetosClientOpenDWG)

(command ".undefine" "end")
(command ".undefine" "quit")
(command ".undefine" "wclose")
(command ".undefine" "exit")

(defun c:end() (progn (callProjetosClientCloseAllDWG) (command ".save" ".quit" "y")(princ)))
(defun c:quit() (progn (callProjetosClientCloseAllDWG) (command ".quit" "y")(princ)))
(defun c:wclose() (progn (callProjetosClientCloseDWG) (command ".wclose")(princ)))
(defun c:exit() (progn (callProjetosClientCloseAllDWG) (command ".exit")(princ)))

;;;;; FIM: Projetos.Com
