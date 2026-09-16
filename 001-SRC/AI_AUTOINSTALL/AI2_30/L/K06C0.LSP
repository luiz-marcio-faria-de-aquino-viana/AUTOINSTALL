; DPRinter - Mar/92

; Variaveis:
;   pfile  - Variavel p(lot)file? (Yes/No)               - Entrada
;   larg   - Variavel largura da folha                   - Entrada
;   alt    - Variavel Altura da folha                    - Entrada
;   prscl  - Variavel Escala de impressao                - Entrada
;   rot    - Variavel rot(ate 90d)? (Yes/No)             - Entrada
;   nfile  - Variavel nome do arquivo                    - Entrada
;   larg1  - Variavel c/largura da folha rep no desenho  - Interna
;   alt1   - Variavel c/altura da folha rep no desenho   - Interna
;   ent1   - Variavel que contem a entidade p/trabalho   - Interna
;   pta    - Primeiro corner p/janela                    - Interna
;   ptb    - Segundo corner p/janela                     - Interna
;   #pfile - Global de 'pfile'                           - Sistema
;   #larg  - Global de 'larg'                            - Sistema
;   #alt   - Global de 'alt'                             - Sistema
;   #prscl - Global de 'prscl'                           - Sistema
;   #rot   - Global de 'rot'                             - Sistema
;   #file  - Global de 'file'                            - Sistema
;   #und   - Global contem a unidade de trabalho (mm=1)  - Sistema

(defun C:DPRINTER(/ pfile larg alt prscl rot nfile larg1 alt1 ent1 pta ptb)

  (setvar "cmdecho" 0)

  (and (null #pfile) (setq #pfile "Yes"))
  (and (null #larg) (setq #larg 345.23))
  (and (null #alt) (setq #alt 279.40))
  (and (null #prscl) (setq #prscl (* #scl #und)))
  (and (null #rot) (setq #rot "No"))

  (setq
    larg (getdist
           (strcat "\nLargura da folha <" (rtos #larg 2 2) ">: ")
         );enddist
    alt (getdist
          (strcat "\nAltura da folha <" (rtos #alt 2 2) ">: ")
        );enddist
    prscl (getint
            (strcat "\nEscala para impressao <" (rtos #prscl 2 2) ">: ")
          );endint
  );endsetq

  (initget "Yes No")
  (setq
    rot (getkword
          (strcat "\nRodar o desenho de 90d <" #rot ">: ")
        );endkword
  );endsetq

  (or (null pfile) (setq #pfile pfile))
  (or (null larg) (setq #larg larg))
  (or (null alt) (setq #alt alt))
  (or (null prscl) (setq #prscl prscl))
  (or (null rot) (setq #rot rot))

  (while
    (> (strlen (setq nfile (getstring "\nNome do arquivo: "))) 8)
  );endwhile

  (if (= #rot "Yes")
    (setq
      larg1 (* (/ #alt #und) #prscl)
      alt1 (* (/ #larg #und) #prscl)
    );endsetq
    (setq
      larg1 (* (/ #larg #und) #prscl)
      alt1 (* (/ #alt #und) #prscl)
    );endsetq
  );endif

  (setvar "dragmode" 2)
  (setvar "highlight" 0)
  (setvar "blipmode" 0)

  (command
    "pline" (list
              (- (caadr (grread T)) (/ larg1 2.0))
              (- (cadadr (grread T)) (/ alt1 2.0))
            );endlist
            "w" 0 ""
            (polar (getvar "lastpoint") 0 larg1)         
            (polar (getvar "lastpoint") (/ pi 2.0) alt1)
            (polar (getvar "lastpoint") pi larg1) "c"
    "move" (setq ent1 (ssget "l"))
           "" (cadr (grread T))
  );endcommand
  (redraw (ssname ent1 0) 2)
  (prompt "\n--- Selecione objeto para impressao ---\n")
  (command
            pause
    "erase" ent1 ""
  );endcommand

  (setvar "highlight" 1)
  (setvar "blipmode" 1)

  (setq
    pta (list
          (- (car (getvar "lastpoint")) (/ larg1 2.0))
          (- (cadr (getvar "lastpoint")) (/ alt1 2.0))
        );endlist
    ptb (list
          (+ (car (getvar "lastpoint")) (/ larg1 2.0))
          (+ (cadr (getvar "lastpoint")) (/ alt1 2.0))
        );endlist
    #file (open (V:APPL "dprinter.scr") "w")
  );endsetq

  (write-line "PRplot" #file)
  (write-line "Window" #file)
  (write-line (strcat (rtos (car pta) 2 6) "," (rtos (cadr pta) 2 6)) #file)
  (write-line (strcat (rtos (car ptb) 2 6) "," (rtos (cadr ptb) 2 6)) #file)
  (write-line "Yes" #file)
  (write-line "M" #file)
  (write-line "0,0" #file)
  (write-line (strcat (rtos #larg 2 6) "," (rtos #alt 2 6)) #file)
  (write-line #rot #file)
  (write-line "No" #file)
  (write-line (strcat "1=" (rtos (/ #prscl #und) 2 6)) #file)
  (write-line "" #file)
  (write-line "" #file)
  (write-line "Shell" #file)
  (write-line
    (strcat "dPrinter " nfile) #file
  );endwrite

  (setq
    #file (close #file)
  );endsetq

  (command "script" (V:APPL "dprinter"))

  (princ)
);enddefun
