; K08c0/esgoto CaiXas - Abr/92
  
(defun C:CX(/ esblk larg alt ptx)
  
  (setvar "cmdecho" 0)
  (command ".undo" "g")
  
  (if #esblk
    (progn
      (initget "CGE CSE CRE")
      (setq
        esblk (getkword (strcat
                          "\nInserir CGE/GSE/GRE <"
                          #esblk ">: "
                        );endstrcat
      )       );endget,setq
    );endprogn
    (progn
      (initget 1 "CGE CSE CRE")
      (setq
        esblk (getkword "\nInserir CGE/GSE/GRE: ")
    ) );endsetq,progn
  );endif
  (if esblk (setq #esblk esblk))
  
  (if #larg
    (setq
      larg (getdist (strcat
                      "\nLargura da " #esblk " <"
                      (rtos #larg 2 2) ">: "
           )        );endstrcat,dist
    );endsetq
    (progn
      (initget 1)
      (setq
        larg (getdist (strcat
                        "\nLargura da " #esblk ": "
             )        );endstrcat,dist
    ) );endsetq,progn
  );endif
  (if larg (setq #larg larg))
  
  (setq
    alt (getdist (strcat
                   "\nAltura da " #esblk " <Alt=Larg>: "
        )        );endstrcat,dist
  );endsetq
  (if (null alt) (setq alt #larg))
  
  (setvar "highlight" 0)
  (setvar "blipmode" 0)
  (command "insert")
  (cond
   ((= (strcase #esblk) "CGE")(command (V:AID "ES/ES03c00")))
   ((= (strcase #esblk) "CSE")(command (V:AID "ES/ES0bc00")))
   ((= (strcase #esblk) "CRE")(command (V:AID "ES/ES08c00")))
  );endcond
  (command
    (setq
      ptx (cadr (grread T))
    );endsetq
    #larg alt 0
  );endcommand
  (redraw (ssname (ssget "l") 0) 2)
  (command
    "move" "l" ""
  );endcommand
  (setvar "cmdecho" 1)
  (command
    ptx
  );endcommand
  (setvar "cmdecho" 0)
  (setvar "blipmode" 1)
  (command pause)
  (redraw (ssname (ssget "l") 0) 2)
  (command
    "rotate" "p" ""
  );endcommand
  (setvar "cmdecho" 1)
  (setvar "blipmode" 0)
  (command
    (getvar "lastpoint")
  );endcommand
  (setvar "cmdecho" 0)
  (setvar "blipmode" 1)
  (command pause)
  (setvar "highlight" 1)
  (princ)
);enddefun
