;;INICIO: ProjetosClient

(prompt "\nLoading: ProjetosClient... ");

(load "ProjetosClient.lsp")

(prompt "Loaded");

;;FIM: ProjetosClient

;;INICIO: AI

(prompt "\nAutoINSTALL v7.0")
(prompt "\nCopyright(C) 1991-2013 AQ Projetos de Instalações Ltda. All Rights Reserved.")

;; definicao das funcoes de caminhos de pesquisa

(defun V:AI(f) (strcat "C:/ACADAPPL/AI7/" f))

(defun V:AID(f) (V:AI (strcat "D/" f)))
(defun V:AIL(f) (V:AI (strcat "L/" f)))
(defun V:AIM(f) (V:AI (strcat "M/" f)))
(defun V:AII(f) (V:AI (strcat "ICO/" f)))
(defun V:AIF(f) (V:AI (strcat "FONTS/" f)))
(defun V:AIS(f) (V:AI (strcat "S/" f)))

(defun V:AIPATH() (strcat (V:AI ";") (V:AII ";") (V:AIM ";") (V:AIF ";") (V:AIS ";")))

(defun V:APPL(f) (strcat "C:/Appl/AI7/" f))

(defun V:SPOOL(f) (strcat "C:\\SPOOL\\" f))

(defun V:PRJ(f) (strcat "V:" f))

(defun V:DET(f) (strcat "K:/AI7-DET/" f))

;; m:err(): funcao de erro padrao
;;  msg - mensagem de erro a ser impressa
(defun m:err(msg)
  (prompt msg)
  (setvar "promptmenu" 0)
  (setvar "blipmode" 1)
  (setvar "highlight" 1)
  (prompt "\n")
  (princ)
) ; end defun

;; ativa a funcao de tratamento de erro como sendo a padrao
(setq *error* m:err)

;; loadf: funcao de carga das rotinas
;;  arqv - nome do arquivo a ser carregado
(defun loadf(arqv / cnt tmp num)
  (setq arqv (V:AIL arqv))
  (cond
    ( (findfile (strcat arqv ".lsp")) (load (strcat arqv ".lsp")) )
    ( (findfile (strcat arqv ".ls1")) (load (strcat arqv ".ls1")) )
    ( (findfile (strcat arqv ".fas")) (load (strcat arqv ".fas")) )
    ( (findfile (strcat arqv ".crt"))
        (progn
          (setq cnt 0)
          (setq tmp "")
          (while (not (zerop (setq num (strlen (setq dat (aci_xloadf (strcat arqv ".crt") cnt)) )) ))
            (setq tmp (strcat tmp dat))
            (setq cnt (+ cnt num))
          ) ; end while
          (eval (read tmp))
        ) ; end progn
    ) ; end case
    ( (prompt (strcat "\nERR: Arquivo inexistente (=" arqv ").")) )
  ) ; end if
  (princ)
) ; end defun

;; carrega arquivo de definicao das funcoes autocarregaveis
(if (findfile (V:AIL "ai.lsp")) (load (V:AIL "ai.lsp")) )

;; definicao das variaveis de controle do programa
(setq
  M:VGTYPE  "F-VG_TETO"  ;; controle de camada para formas
  M:HISO    nil          ;; controle de camada para isometrico
  M:FLSAVED "NOTSAVED"   ;; controle de desenho salvo
 
) ; end setq

;; definicao das propriedades do desenho

(defun #VER()   (getvar "users1") )
(defun #ESCL()  (getvar "userr1") )
(defun #UND()   (getvar "userr2") )
(defun #LARG()  (getvar "userr3") )
(defun #ALT()   (getvar "userr4") )
(defun #OWNER() (getvar "users2") )
(defun #DATE()  (getvar "users3") )
(defun #SCL()   (getvar "dimscale") )

;; s::startup(): funcao autoexecucao de configuracao do ambiente de trabalho
(defun s::startup()

  (if (= (getvar "dwgname") "Drawing1.dwg")
    (command "menu" (V:AIM "arqmenu"))
  ) ; end if

  (setvar "cmdecho"0)

  (regapp "AI230EL")

  (if (= (getvar "handles") 0) (command ".handles" "on"))

  (setvar "menuctl" 0)
  (setvar "plinetype" 0)
  (setvar "savetime" 0)
  (setvar "promptmenu" 0)
  (setvar "expert" 0)
  (setvar "explevel" 3)
  
  (command ".undo" "c" "a")	;; enable undo command
  
;;  (setvar "srchpath" (V:AIPATH))

;;  (command ".undefine" "save")
;;  (command ".undefine" "qsave")
;;  (command ".undefine" "saveall")
;;  (command ".undefine" "saveas")
;;  (command ".undefine" "saveasr12")
;;  (command ".undefine" "exit")
;;  (command ".undefine" "quit")
;;  (command ".undefine" "close")
;;  (command ".undefine" "wclose")
;;  (command ".undefine" "wcloseall")

  (loadf "base")    ;; carga das funcoes basicas de operacao
  (loadf "conf")    ;; carga das funcoes de configuracao do desenho

  (loadf "base/ai_base")
  (loadf "base/ai_auto")
  (loadf "base/ai_lay")

  ;; execucao das funcoes de inicializacao

  (c:mklay)       ;; funcao de criacao da estrutura de camadas
  (c:xfload)      ;; funcao de carga dos arquivos externos
  (logon)         ;; funcao de registro de acesso ao desenho

  (slaylight "0")
  ;;(setvar "cmdlntext" (strcat "[ " #USR " ]  Command: "))

  (conf)          ;; funcao de leitura dos parametros de configuracao

  (princ)
) ; end function

(princ)

;;FIM: AI

;;Routines - VCAD - Copyright by RCTASK - 2009


;;Routines - SMART UTILITIES - Copyright by RCTASK - 2009
(load (strcat (getvar "exedir") "SMART\\lisp\\VCAD_1.lsp"))
(load (strcat (getvar "exedir") "SMART\\lisp\\VCAD_2.lsp"))
(load (strcat (getvar "exedir") "SMART\\lisp\\VCAD_3.lsp"))
(xload (strcat (getvar "exedir") "SMART\\lisp\\Lispcmds.dll"))


;;End aplication...





















































;;end load
;;=======================================================================================================





































































































































































































;List Commands

; C:LAYISO
; C:LAYFRZ
; C:LAYOFF
; C:LAYLCK
; C:LAYULK
; C:LAYON
; C:LAYTHW
; C:LAYMCH
; C:LAYCUR
; C:SETLAYER
; C:BURST
; C:CHGTEXT
; C:TL
; C:AREAS
; C:ATEXT2
; C:TBOX
; C:TFBOX
; C:CHGCASE
; C:CIRTEXT
; C:CLEANUP
; C:CLRMESH
; C:DIMARC
; C:PCIRS
; C:RCLOUD
; C:CLOUD
; C:SYMLINE
; C:TXTPATH
; C:WEED
; C:BALLOON
; C:TTR
; C:DBL
; C:LOC_TXT
; C:CB
; C:CB2
; C:CB3
; C:ADT
; C:FTXT
; c:INTEGRITY

;;;**********************************************************************************************



(if (= (getvar "vendorname") "RCTASK")
(progn
  (DEFUN C:LO  () (C:LAYON))
(DEFUN C:LI  () (C:LAYISO))
(defun init_bonus_error ( lst / ss undo_init)
 
  ;;;;;;;local function;;;;;;;;;;;;;;;;;;;;
  (defun undo_init ( / undo_ctl)
   (b_set_sysvars (list "cmdecho" 0))
   (setq undo_ctl (getvar "undoctl")) 
   (if (equal 0 (getvar "UNDOCTL")) ;Make sure undo is fully enabled.
       (command "_.undo" "_all")
   )
   (if (or (not (equal 1 (logand 1 (getvar "UNDOCTL"))))  
           (equal 2 (logand 2 (getvar "UNDOCTL")))
       );or
       (command "_.undo" "_control" "_all") 
   )
    
   ;Ensure undo auto is off
   (if (equal 4 (logand 4 (getvar "undoctl")))
       (command "_.undo" "_Auto" "_off")
   )
   
   ;Place an end mark down if needed.
   (while (equal 8 (logand 8 (getvar "undoctl")))
        (command "_.undo" "_end")
   );while         
   (while (not (equal 8 (logand 8 (getvar "undoctl"))))
    (command "_.undo" "_begin")                 
   );while
   (b_restore_sysvars) 
   ;return original value of undoctl
   undo_ctl
  );defun undo_init

    ;;;;;;;;;;;;;begin the work of init_bonus error;;;;;;;;;;;;;
 ;(setq ss (ssgetfirst))
 ;(if (not bonus_alive)
 ;    (setq bonus_alive 0)
 ;);if
 ;(setq bonus_alive (1+ bonus_alive))
 
 (if (and (> bonus_alive 1)                              ;do some double checking to make sure 
          (or (not (equal 'LIST (type *error*)))         ;our error handler is still active.
              (not (equal "bonus_error" (cadr *error*))) ;for nested this call.
          );or
     );and
     (progn
      (princ "\nNested Error trapping is being used incorrectly.")
      (princ "\nResetting the nested index to 1.")
      (setq     *error* bonus_error
            bonus_alive 0
      );setq
      (restore_old_error);quietly restore undo status
      (setq bonus_alive 1)
     );progn then things need to be re-adjusted.
 );if
 (if (<= bonus_alive 0)   
     (progn 
      (setq bonus_alive 0);undo settings will be restored 
                          ;along with setting *error* back to bonus_old_error.
                          ;No call to b_restore_sysvars will be made.
                          ;If it is decided, this thing should do variable clean 
                          ;up also then set bonus_alive to 1 before calling
                          ;restore_old_error
      (restore_old_error);quietly restore bonus_old_error and undo status.
      (setq bonus_alive 1)
     );progn then
 );if
 (if (= bonus_alive 1)
     (progn
      (if (and *error*
               (or (not (equal 'LIST (type *error*)))
                   (not (equal "bonus_error" (cadr *error*)))
               );or 
          );and 
          (setq bonus_old_error *error*);save the *error* only if it 
                                        ;looks like the standard one or is some other 
                                        ;user defined one. Don't want to save it if 
                                        ;it's ours because we already have it.
      );if
      (if (cadr lst)
          (setq bonus_undoctl (undo_init)) 
          (setq bonus_undoctl nil)
      );if
    );progn then this is a top level call, or in other words, the first time through.
 );if
 (b_set_sysvars (car lst))
 (if (= bonus_alive 1)
     (progn
      (setq *error* bonus_error);setq
      (if (caddr lst)
          (setq *error* (append (reverse (cdr (reverse *error*))) 
                                (list (caddr lst)
                                      (last *error*)
                                );list
                        );append
          );setq ;then add additional routine name to the error function.
      );if
     );progn
     (progn
      (if (and (> bonus_alive 1)
               (or (not (equal 'LIST (type *error*)))
                   (not (equal "bonus_error" (cadr *error*)))
               );or
          );and
          (setq *error* bonus_error);setq
      );if
     );progn else double check to make sure the bonus_error is in effect.
 );if
 (if (and ss
          (equal 1 (logand 1 (getvar "pickfirst")))
     );and
     (sssetfirst (car ss) (cadr ss))
 );if
);defun init_bonus_error

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun bonus_error ( msg / )

"bonus_error"

(setq bonus_alive -1)
(print msg)

;;Get out of any active command.
(while (not (equal (getvar "cmdnames") "")) (command nil))

;If undo global variable flag is set then use undo as a cleanup helper.
(if bonus_undoctl
    (progn
     (setvar "cmdecho" 0)

     (while (not (wcmatch (getvar "cmdnames") "*UNDO*"))
            (command "_.undo")
     );while
     (command "_end")  ;The routine that just failed created an undo 
                       ;begin mark, so we need to close it off with 
                       ;and "end" mark.

     (command "_.undo" "1")   ;now back up to the begining.
     (while (not (equal (getvar "cmdnames") "")) 
      (command nil)
     );while

    );progn
);if

(b_restore_sysvars)
(b_restore_undo)

;Restore original error handler
(if bonus_old_error
    (setq *error* bonus_old_error)
);if

(setq bonus_alive 0)

(princ)
);defun bonus_error

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Restore_old_error
;This function should be the last thing called in a lisp 
;defined command. It does a (princ) at the end for a quiet 
;finish.
(defun restore_old_error ( / )

(setq bonus_alive (- bonus_alive 1))
(if (>= bonus_alive 0)
    (b_restore_sysvars)
    (setq bonus_varlist nil)
);if
(if (<= bonus_alive 0)
    (progn
     (b_restore_undo)
     (if bonus_old_error
         (setq *error* bonus_old_error);put the old error routine back.
     );if
    );progn then
);if

(princ)
);defun restore_old_error



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun b_restore_undo ()

(if bonus_undoctl
    (progn
      (b_set_sysvars (list "cmdecho" 0))

      (while (equal 8 (logand 8 (getvar "undoctl")))
         (command "_.undo" "_end")
      );while

      (if (not (equal bonus_undoctl (getvar "undoctl")))
          (progn
           (cond 
            ((equal 0 bonus_undoctl) 
             (command "_.undo" "_control" "_none")
            )
            ((equal 2 (logand 2 bonus_undoctl))
             (command "_.undo" "_control" "_one")
            )	
           );;cond 
           (if (equal 4 (logand 4 bonus_undoctl))
               (command "_.undo" "_auto" "_on") 
           );if 

         );progn then restore undoctl to the status the user had it set to. 
      );if
      (if (not (equal 2 (logand 2 (getvar "undoctl"))))
          (b_restore_sysvars)
      );if
    );progn then restore undo to it's original setting
);if
(setq bonus_undoctl nil)

);defun b_restore_undo


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This has no error checking. You must
;provide a list of even length in the 
;following form
;( "sysvar1" value
;  "sysvar2" value2
;)
(defun b_set_sysvars (lst / lst2 lst3 a b n)

(setq lst3 (car bonus_varlist));setq

(setq n 0)
(repeat (/ (length lst) 2)
 (setq a (strcase (nth n lst))
       b (nth (+ n 1) lst)
 );setq
 (setq lst2 (append lst2
                    (list (list a (getvar a)))
            );append
 );setq 
 (if (and bonus_varlist 
          (not (assoc a lst3))
     );and
     (setq lst3 (append lst3 
                        (list (list a (getvar a)))
                );append
     );setq 
 );if

 (setvar a b)

(setq n (+ n 2));setq
);repeat
(if bonus_varlist
    (setq bonus_varlist (append (list lst3) 
                                (cdr bonus_varlist)
                                (list lst2) 
                        );append
    );setq
    (setq bonus_varlist (list lst2))
);if
);defun b_set_sysvars

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun b_restore_sysvars ( / lst n a b)

 (if (<= bonus_alive 0)
     (setq           lst (car bonus_varlist)
           bonus_varlist (list lst)
     );setq 
     (setq lst (last bonus_varlist)) 
 );if

 (setq n 0);setq
 (repeat (length lst)
 (setq a (nth n lst)
       b (cadr a)
       a (car a)
 )
 (setvar a b)
 (setq n (+ n 1));setq
 );repeat
 (setq bonus_varlist (reverse (cdr (reverse bonus_varlist))))

);defun b_restore_sysvars

;;;;;;;;;;;;;;;;;;;;;;;;;end error handler functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;P_ISECT
;Poly-InterSECT
;takes a list of points and and a flag
;returns true if the 
; segments intersect on themselves.
;If the flag argument is true 
;then error strings will be printed to the command line
;if an intersection is found.
;
(defun p_isect ( lst flag2 / flag lst2 lst3 a b c d n j)

(setq n 0);setq
(repeat (length lst)
(setq    a (nth n lst)
      lst2 (append lst2 (list a))
);setq
(if (equal 2 (length lst2))
    (setq lst3 (append lst3 (list lst2))
          lst2 (list (cadr lst2))
    );setq
);if    
(setq n (+ n 1));setq
);repeat

(if (equal 2 (length lst2))
    (setq lst3 (append lst3 (list lst2)));setq
);if    

(setq n 0);setq
(while (and (< n (length lst3))
            (not flag)
       );and
(setq a (nth n lst3)
      b (cadr a)
      a (car a)
);setq
 (setq j (+ n 1))
 (while (and (< j (length lst3)) 
             (not flag)
        );and 
 (setq c (nth j lst3)
       d (cadr c)
       c (car c) 
 );setq
 (if (and (not (equal b c 0.000001))
          (not (equal a d 0.000001))
     );and
     (progn
      (setq flag (inters a b c d))
      (if (and flag 
               flag2
          );and
          (progn
           (princ "\nInvalid. Crossing polygon cannot self intersect.")
           (princ flag2)
          );progn
      );if
     );progn
 );if
 
 (setq j (+ j 1));setq
 );while

(setq n (+ n 1));setq
);while

flag
);defun p_isect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;zoom_4_select
;Takes - a list of coordinates. If all coords do not lie in
;the current view, zoom_4_select will zoom to the extents 
;of the coords in the list argument.
;Returns - True in the form of two corners points if a zoom operation needs 
;          to be performed and returns nil if not. 
;
(defun zoom_4_select ( lst / a b)

 (setq  lst (lsttrans lst 1 2) 
          a (maxminpnt (lsttrans (viewpnts) 1 2))
          b (maxminpnt (append a lst))
 );setq 

 (if (not (equal a b))
     (progn
      (setq b (list (trans (append (car b) '(0.0))  2 1)
                    (trans (append (cadr b) '(0.0)) 2 1)
              )
      );setq
     );progn
     (setq b nil)
 );if

 b
);defun zoom_4_select


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;maxminpnt
;takes: a list of points
;returns: a list of 2 points the lower left and the upper right
;
;	maxminpnt	 
(defun maxminpnt ( lst / x n a b c d)

(setq x (car lst)
      a (car x)
      b (cadr x)
      c (car x)
      d (cadr x)
      n 1
);setq
(repeat (max (- (length lst) 1) 0)
(setq x (nth n lst));setq
(setq a (min a (car x))
      b (min b (cadr x))
      c (max c (car x))
      d (max d (cadr x))
);setq
(setq n (+ n 1));setq
);repeat
(list (list a b)
      (list c d)
);list
);defun maxminpnt


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;viewpnts
;returns lower left and upper right coords of current view
(defun viewpnts ( / a b c d x)

(setq b (getvar "viewsize")
      c (car (getvar "screensize"))
      d (cadr (getvar "screensize"))
      a (* b (/ c d))
      x (setq x (getvar "viewctr"))
      x (trans x 1 2)
      c (list (- (car x)  (/ a 2.0))
              (- (cadr x) (/ b 2.0))
              0.0
        );list
      d (list (+ (car x)  (/ a 2.0))
              (+ (cadr x) (/ b 2.0))
              0.0
        );list
      c (trans c 2 1)
      d (trans d 2 1) 
);setq

(list c d)
);defun viewpnts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;pixel_unit
;returns the size of a single pixel in drawing units.
;value depends on current zoom factor.
;
;pixunit/viewsize = one pixel/yscreensize
;
;pixunit=viewsize/yscreensize 
;
(defun pixel_unit ( / x y x1 y1)
 (setq  y (getvar "viewsize")
       x1 (car (getvar "screensize"))
       y1 (cadr (getvar "screensize"))
        x (* y (/ x1 y1))
 );setq
 (max (abs (/ y y1))
      (abs (/ x x1))
 );max
);defun pixel_unit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;**PLINE** function takes a list and creates a polyline entity
;the list contains a list of coords.
;and optionaly other lists such as (8 . "LAYER")
;				   (40 . WIDTH)
;				   (62 . COLOR)
;	pline	     n a b flag
(defun pline ( lst / n a b flag)


(if (> (length lst) 1)
    (progn
     (if (setq b (assoc 8 lst));setq
	 (setq a (append a (list b)));setq then
     );if
     (if (setq b (assoc 40 lst));setq
	 (setq a (append a (list b)
			    (list (cons 41 (cdr b))
			    );list
		 );append
	 );setq then
     );if
     (if (setq b (assoc 62 lst));setq
	 (setq a (append a (list b)));setq then
     );if

    );progn then
    (setq flag T
	     b (car lst)
    );setq else only a coord list was provided
);if

(setq n 0)
(while (and (not flag)
	    (< n (length lst))
       );and

(if (not (member (nth n lst) a))
    (setq    b (nth n lst)
	  flag T
    );setq then
);if

(setq n (+ n 1));setq
);while

(entmake (append (list '(0 . "POLYLINE")) a));entmake

(setq n 0)
(repeat (length b)

(entmake (list '(0 . "VERTEX")
	       (append (list 10) (nth n b))
	 );list
);entmake

(setq n (+ n 1));setq
);repeat

(entmake '((0 . "SEQEND")));entmake

(princ)
);defun pline

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;**VTLIST** takes a list or a polyline ent name
;RETURNS a list of vertecies in
; WORLD if a list is provided '(na code) and code=0
; CURRENT UCS coords are returned if only na is provided as an argument
;or if a lst is provided and code=1
;
;	
(defun vtlist ( na / dxf e1 lst lst2 code n flag a z)

 ;local function
 (defun dxf (a b / ) (cdr (assoc a b)));defun

(if (equal (type na)
	     (type (list 1))
    );equal
    (setq code (cadr na)
            na (car na)
    );setq then
    (setq code 1);setq else
);if
(setq e1 (entget na));setq
(if (equal 1 (logand 1 (dxf 70 e1)))
    (setq flag 1)
    (setq flag nil)
);if
(if (equal (dxf 0 e1) "POLYLINE")
    (progn
     (setq na (entnext na)
           e1 (entget na)
     );setq
     (while (/= "SEQEND" (dxf 0 e1))    
      (setq lst (append lst 
                        (list (trans (dxf 10 e1) na code));list 
                );append
             na (entnext na)
             e1 (entget na)
      );setq
     );while
    );progn then old polyline
    (progn
     (setq lst e1
             z (dxf 38 e1)
     );setq
     (if (not z) (setq z 0.0)) 
     (setq n 0);setq
     (repeat (length lst)
     (setq    a (nth n lst))
     (if (equal (car a) 10)
         (setq   a (cdr a)
                 a (list (car a) (cadr a) z)
              lst2 (append lst2 
                           (list (trans a na code))
                   );append
         );setq then
     );if
     (setq n (+ n 1));setq 
     );repeat
     (setq  lst lst2 
           lst2 nil
     );setq
    );progn else lwpolyline
);if 
(if (and flag lst)
    (setq lst (append lst (list (car lst))));setq
);if
lst
);defun vtlist

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ep_list
;returns entity point list
;returns a list of points on the entity
;args
; na -is a polyline 'pl_point_list' is called
; alt -is an arc segmant error tolerance (altitude)
;
(defun ep_list ( na alt / dxf a b c d n e1 lst)

 ;local function
 (defun dxf (a b / ) (cdr (assoc a b)));defun

(setq e1 (entget na));setq
(cond
 ((or (equal (dxf 0 e1) "POLYLINE")
      (equal (dxf 0 e1) "LWPOLYLINE")
  );or
  (setq lst (pl_point_list na alt));setq
 );cond #1
 ((equal (dxf 0 e1) "LINE")
  (setq lst (list (trans (dxf 10 e1) na 1)
                  (trans (dxf 11 e1) na 1)
            );list
  );setq
 );cond #2
 ((or (equal (dxf 0 e1) "ARC") 
      (equal (dxf 0 e1) "CIRCLE")
  );or
  (progn
   (setq a (dxf 10 e1)             ;the center point
         b (dxf 40 e1)             ;the radius
         n (dxf 50 e1)             ;the start angle
         c (dxf 51 e1)             ;the end angle
   );setq
   (if (not n)
       (setq n 0
             c (* 2.0 pi)
       );setq then it's a circle
       (if (> n c)
           (setq c (+ c (* 2.0 pi)));setq then
       );if else it's an arc
   );if
   (setq lst (append lst 
                     (get_arc_points a 
                                     (polar a n b) 
                                     (polar a c b)
                                     (- c n) 
                                     alt
                     );get_arc_points
             );append
   );setq
   (setq lst (lsttrans lst na 1))
  );progn
 );cond #3
;add trim capabilities for text here
; ((equal "TEXT" (dxf 0 e1))
;  (setq p1 (textbox e1)
;
;  );setq
; );cond #4  
);cond close

lst
);defun ep_list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun pl_point_list ( na alt / dxf na2 a b c z p1 p2 p3 e1 lst lst2 code n flag )

 ;local function
 (defun dxf (a b / ) (cdr (assoc a b)));defun

 (if (equal (type na)
            (type (list 1))
     );equal
     (setq code (cadr na)
             na (car na)
     );setq then
     (setq code 1);setq else
 );if
 (setq e1 (entget na));setq
 (if (equal 1 (logand 1 (dxf 70 e1)))
     (setq flag 1)
     (setq flag nil)
 );if
 (setq na2 na)
 (if (equal (dxf 0 e1) "POLYLINE")
     (progn
      (setq na (entnext na)
            e1 (entget na)
            p1 (dxf 10 e1) 
             b (dxf 42 e1) 
      );setq
      (if (not (equal 16 (logand 16 (dxf 70 e1))))
          (setq lst (list p1))
          (setq lst nil)
      );if     
      (setq na (entnext na)
            e1 (entget na)
      );setq
      (while (/= "SEQEND" (dxf 0 e1 ))    
       (setq p2 (dxf 10 e1));setq
       (if (not (equal 16 (logand 16 (dxf 70 e1))))
           (progn 
            (if (and b 
                     (not (equal b 0)) 
                     ;added below for cloud problems
                     p1
                     (not (equal p1 p2))
                );and
                (setq  p3 (pl_arc_info p1 p2 b)
                      lst (append lst 
                                  (get_arc_points (car p3) p1 p2 (caddr p3) alt)
                          );append
                );setq then
                (setq lst (append lst (list p2)));setq else
            );if
           );progn then not a spline control point
       );if
       (setq  b (dxf 42 e1)
             na (entnext na)
             e1 (entget na)
             p1 p2
       );setq
      );while
     
       (if flag
           (progn
            (setq p2 (car lst))
            (if (and b 
                     (not (equal b 0)) 
                     ;added below for cloud problems
                     p1
                     (not (equal p1 p2))
                );and
                (setq  p3 (pl_arc_info p1 p2 b)
                      lst (append lst 
                                  (get_arc_points (car p3) p1 p2 (caddr p3) alt)
                          );append
                );setq then
                (setq lst (append lst (list p2)));setq else
            );if
            (setq flag nil)
           );progn then it's closed
      );if
     );progn then old polyline
     (progn
      (setq   z (dxf 38 e1)
            lst (member (assoc 10 e1) e1)
      );setq 
      (if (not z) (setq z 0.0))
      (setq n 0);setq
      (repeat (length lst)
       (setq a (nth n lst))
       (if (equal 10 (car a))
           (setq    a (cons 10 (append (cdr a) (list z)))
                 lst2 (append lst2 (list a))
           );setq
           (progn
            (if (equal 42 (car a))
                (setq lst2 (append lst2 (list a)));setq then
            );if
           );progn
       );if 
      (setq n (+ n 1));setq
      );repeat
      
      (setq  b (car lst2)
           lst (list (cdr b))
      );setq
      
      (if flag 
          (setq lst2 (append lst2 (list (car lst2)))
                flag nil 
          );setq
      );if

      (setq n 1);setq
      (repeat (- (length lst2) 1)
      (setq a (nth n lst2));setq
      (if (and (equal 10 (car a))
               (equal 42 (car b))
               (not (equal 0.0 (cdr b)))
               ;added below for cloud problems
               c
               (not (equal (cdr a) (cdr c)))
          );and  
          (progn   
           (setq  p3 (pl_arc_info (cdr c) (cdr a) (cdr b))
                 lst (append lst 
                             (get_arc_points (car p3) (cdr c) (cdr a) (caddr p3) alt)
                     );append  
           );setq
          );progn then get the arc points
          (progn
           (if (equal 10 (car a))
               (setq lst (append lst (list (cdr a)));append
               );setq then
           );if 
          );progn
      );if
      (setq c b
            b a
      );setq
      (setq n (+ n 1));setq 
      );repeat
      (setq lst2 nil);setq
     );progn else lwpolyline
 );if 

 (lsttrans lst na2 code)
);defun pl_point_list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;get_arc_points
;returns a list of points that lie along an arc described 
;by the following arguments:
;takes: 
;  p1 - start point
;  p2 - end point
;  p3 - center point
; ang - delta angle of the arc
; alt - altitude (max error tolerance)
;
(defun get_arc_points ( p1 p2 p3 ang alt / sa ea lst b c d)

 (setq  b (distance p1 p2)       ;the radius
       sa (angle p1 p2)          ;the start angle
       ea (+ sa ang)             ;the end angle
 );setq
 (setq d (- ea sa));setq full delta angle of the arc in radians
 (if (not alt)
     (setq c (/ (* 2.0 pi) 9.0));then use default resolution
     (setq c (delta_ang b alt));setq else use altitute specified. 
 );if
 (setq  c (* c (/ d (abs d))));setq the delta angle increment of the loop
 
 (if (< (abs (/ d c)) 4.0)
     (setq c (/ d 4.0)
     );setq then reset c, the delta angle increment of the loop so 
                          ;at least 4 segments are used
 );if

 (repeat (+ (fix (+ (abs (/ d c))
                    0.000001
                 );plus
            );fix
            1
         );plus
 (if (not (equal (polar p1 sa b) (last lst)))
     (setq lst (append lst
                       (list (polar p1 sa b))
               );append
     );setq then
 );if
 (setq sa (+ sa c));setq
 );repeat

 (if (not (equal p3 (last lst)))
     (setq lst (append lst (list p3)));setq
 );if
 lst
);defun get_arc_points

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;takes endpoints of an arc and bulge
;returns a list containing:
; Center point
; radius
; Delta angle
; distance (arc length)
; altitude
;
(defun pl_arc_info ( p1 p2 bulge / a b c r ang s)

 (setq b bulge 
       c (distance p1 p2)
       a (abs (/ (* c b) 2.0))
       r (/ (+ (expt (/ c 2.0)
                     2.0
               );expt
               (expt a 2.0)
            );plus
            (* 2.0 a)
         );div
     ang (* 2.0 (atan (/ c 2.0)
                      (- r a)
                );atan
         );mult delta angle
       s (* ang r);the length of the arc
     ang (* ang (/ b (abs b)))
      p3 (polar p1 (angle p1 p2) (/ c 2.0))
      p3 (polar p3 
                (+ (angle p1 p2) (/ pi 2.0)) 
                (* (- r a) 
                   (/ b (abs b))
                );mult
         );polar
 );setq
 (list p3 r ang s a)
);defun pl_arc_info

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;delta_ang
;returns the delta angle of an arc with
;the specified altitude and radius
(defun delta_ang ( r a / c ang)
 (setq c (* 2.0
            (sqrt 
              (abs (- (* 2.0 r a)
                      (expt a 2.0)
                   )
              )
            )
         )
     ang (* 2.0 (atan (/ c 2.0)
                      (- r a)
                );atan
         );mult delta angle
 );setq
 ang
);defun delta_ang

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;**M_ASSOC** Multiple-ASSOC
;TAKES:
;a  - search value for assoc
;lst- a list of sub-lists
;RETURNS: a list of all of the sublists that have 'a' as their first element
;
;	m_assoc b lst2
(defun m_assoc ( a lst / b lst2)

(while (setq b (assoc a lst));setq
(setq  lst (cdr (member b lst))
      lst2 (append lst2 (list b))
);setq
);while

lst2
);defun m_assoc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;lsttrans
;is like standard autolisp trans but takes a 
;LIST of points and returns a list of translated 
;points.
;
(defun lsttrans ( lst a b / lst2 c n)

(setq n 0);setq
(repeat (length lst)
(setq	 c (nth n lst)
	 c (trans c a b)
      lst2 (append lst2 (list c))
);setq
(setq n (+ n 1));setq
);repeat

lst2
);defun lsttrans

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;TNLIST
;returns a list of the symbol names found
;in the specified table
;	
(defun tnlist ( tbna / a lst)
(if (and (equal (type tbna) 'LIST) 
         (equal (cadr tbna) 16)          
    );and
    (progn
     (setq tbna (car tbna));setq
     (while (setq a (tblnext tbna (not a))); a acts as a rewind first time
      (if (not (equal 16 (logand 16 (cdr (assoc 70 a)))))
          (setq lst (append lst 
                            (list (cdr (assoc 2 a)))
                    );append
          );setq
      );if
     );while
    );progn then local only
    (progn
     (while (setq a (tblnext tbna (not a))); a acts as a rewind first time
      (setq lst (append lst 
                       (list (cdr (assoc 2 a)))
                );append
      );setq
     );while
    );progn else
);if 
 lst
);defun tnlist

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sets current ucs to be parallel to the extrusion vector 
;specified by p1
;
;This function is used by extrim and exchprop
;
(defun ucs_2_ent ( p1 / )
 (setq p1 (strcat "*"
                  (rtos (car p1) 2 8) ","
                  (rtos (cadr p1) 2 8) ","
                  (rtos (caddr p1) 2 8)
          );strcat
 );setq
 (command "_.ucs" "_za" "*0.0,0.0,0.0" p1)
);defun ucs_2_ent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Takes a layer name and returns 
;True if the layer is locked, and nil if unlocked.
;
(defun b_layer_locked ( la / na e1)
 (setq na (tblobjname "layer" la)
       e1 (entget na)
 );setq
 (equal 4 
        (logand 4 (cdr (assoc 70 e1)))
 );equal
);defun b_layer_locked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;takes an element and a list
;if the element is contained in the list
;   then position of the first occurrance is returned (integer)
;   else nil is returned
;
;      position b
(defun position ( a lst / b)
 (if (setq b (member a lst));setq
     (progn
      (setq b (- (length lst) (length b)));setq
     );progn then
 );if
 b
);defun position

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;**MPOPLST Make-POPup-LST take the key and a list
;
(defun mpoplst ( a lst / n )
 (start_list a 3)
 (setq n 0);setq
 (repeat (length lst)
  (add_list (nth n lst))
  (setq n (+ n 1));setq
 );repeat
 (end_list)
);defun mpoplst

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Just a little util to see what lisp commands are loaded into memory.
;also has an option that calls appload.
;
(defun c:lsp ( / lst n a )
 (initget "Commands Load") 
 (setq a (getkword "\nCommands/Load: "))
 (cond 
   ((equal a "Commands")
    (progn  
     (setq lst (atoms-family 1)
           lst (acad_strlsort lst)
     );setq
     (setq n 0);setq
     (repeat (length lst)
      (setq a (nth n lst));setq
      (if (equal "C:" (strcase (substr a 1 2)))
          (princ (strcat "\n" (substr a 3)))
      );if
     (setq n (+ n 1));setq
     );repeat
    );progn then
   );cond 1 
   ((equal a "Load") 
    (c:appload)
   )
 );cond close
 (princ)
);defun c:lsp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Takes: A ssget type of filter list and a flag.
;If the flag is true then locked layer selection is allowed. 
;
;Returns: A single entity name that matches the filter list
;
(defun single_select ( flt flag / a p1 p2 ss ss2 flag2)

(while (not flag2)
(setvar "highlight" 0)
(if (entnext)
    (progn
     (command "_.select" (entnext) "")
     (command "_.undo" "1");clear any selection sets
    );progn then
);if
(setvar "highlight" 1)
(command "_.select" "_si")
(setvar "cmdecho" 1)
(command pause)

(setq ss2 (ssget "p")
       p1 (getvar "lastpoint")
       p1 (trans p1 1 (getvar "viewdir"))
        a (* (getvar "pickbox") (pixel_unit))
       p2 (list (- (car p1) a) (- (cadr p1) a) 0.0)
       p1 (list (+ (car p1) a) (+ (cadr p1) a) 0.0)
       p1 (trans p1 (getvar "viewdir") 1)    
       p2 (trans p2 (getvar "viewdir") 1)    
);setq
(if (and ss2
         (or (setq ss (ssget "p" flt))
             (setq ss (ssget "c" p1 p2 flt))   
         );or
    );and 
    (progn
     (setq ss (ssname ss 0))
     (if flag
         (setq flag2 T)
         (progn
          (if (b_layer_locked (cdr (assoc 8 (entget ss))))
              (progn
               (setq flag2 nil) 
               (princ "\nThat object is on a locked layer!")
              );progn
              (setq flag2 T);else got something and its on an UN-locked layer
          );if
         );progn else locked layer selection is not allowed
     );if
    );progn
    (progn
     (if ss2
         (princ "\nInvalid selection.")
         (setq flag2 T);they just exited with enter
     );if
    );progn 
);if
(setvar "cmdecho" 0)
);while
ss
);defun single_select

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ss_visible ( ss code / na e1 n)
 (if ss
     (progn
      (setq n 0)
      (repeat (sslength ss)
       (setq na (ssname ss n)
             e1 (entget na)
       );setq
       (if (not (assoc 60 e1))
           (setq e1 (append e1 (list (cons 60 code))));setq then
           (setq e1 (subst (cons 60 code) (assoc 60 e1) e1));setq else
       );if
       (entmod e1) 
       (entupd na)
       (setq n (+ n 1));setq
      );repeat 
     );progn
 );if
);defun ss_visible

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun image_bounds ( na / dxf p1 p2 p3 p4 p5 p6 p7 p8 a b c x y ang e1)
 (defun dxf ( a b ) (cdr (assoc a b)))
 (setq e1 (entget na)
       p1 (dxf 10 e1);insert point
       p2 (dxf 11 e1)
       p3 (dxf 12 e1)
       p4 (dxf 13 e1)
 );setq
 (setq 
      ang (atan (/ (cadr p2) (car p2)))
        x (sqrt (+ (expt (car p2) 2) (expt (cadr p2) 2)))
        y (sqrt (+ (expt (car p3) 2) (expt (cadr p3) 2) ))
        a (* x (car p4))
        b (* y (cadr p4))
        c (list (+ a (car p1)) 
                (+ b (cadr p1)) 
                (caddr p1) 
          )
       p5 p1               ;lower left
       p6 (list (car c)    ;lower right
                (cadr p1) 
                (caddr p1)
          );list
       p7 c                ;upper right
       p8 (list (car p1)   ;upper left
                (cadr c) 
                (caddr p1)
          )
       p6 (rotate_pnt p6 p1 ang)
       p7 (rotate_pnt p7 p1 ang)
       p8 (rotate_pnt p8 p1 ang)
 );setq
 (list p5 p6 p7 p8 p5)
);defun image_bounds

;
;Rotate 'pnt' from a base point of 'p1' and through an angle 
;of 'ang' (in radians)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun rotate_pnt ( pnt p1 ang / )
 (polar p1 
        (+ (angle p1 pnt) ang) 
        (distance p1 pnt) 
 );polar
);defun rotate_pnt 




; ********************* ISOLATE LAYER FUNCTION *******************
; Isolates selected object's layer by turning all other layers off
; ****************************************************************

(Defun C:LAYISO (/ SS CNT LAY LAYLST VAL)

  (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)

;  (init_bonus_error 
 ;   (list
  ;   (list "cmdecho" 0
  ;          "expert"  0
  ;   )
  ;   T     ;flag. True means use undo for error clean up.  
  ;  );list  
  ;);init_bonus_error



  (if (not (setq SS (ssget "i")))
    (progn
      (prompt "\nSelect object(s) on the layer(s) to be ISOLATED: ")
      (setq SS (ssget))
    )
  )

  (if SS
    (progn

      (setq CNT 0)

      (while (setq LAY (ssname SS CNT))
        (setq LAY (cdr (assoc 8 (entget LAY))))
        (if (not (member LAY LAYLST))
          (setq LAYLST (cons LAY LAYLST))
        )
        (setq CNT (1+ CNT))
      )

      (if (member (getvar "CLAYER") LAYLST)
        (setq LAY (getvar "CLAYER"))
        (setvar "CLAYER" (setq LAY (last LAYLST)))
      )

      (command "_.-LAYER" "_OFF" "*" "Y" "")
;;      (foreach VAL LAYLST (command "_ON" VAL))
      (foreach LAY LAYLST (command "_.-LAYER" "_ON" LAY ""))
;;      (command "")
      (command "REGEN")
      
      (if (= (length LAYLST) 1)
        (prompt (strcat "\nLayer " (car LAYLST) " has been isolated."))
        (prompt (strcat "\n" (itoa (length LAYLST)) " layers have been isolated. "
                        "Layer " LAY " is current."
                )
        )
      )
    )
  )

;;  (restore_old_error)

  (princ)
)

; ********************* LAYER FREEZE FUNCTION ********************
; Freezes selected object's layer
; ****************************************************************

(defun C:LAYFRZ ()
  (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)
  (layproc "frz")
  (princ)
)

; ********************** LAYER OFF FUNCTION *********************
; Turns selected object's layer off
; ***************************************************************

(defun C:LAYOFF ()
  (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)
  (layproc "off")
  (princ)
)

; ------------- LAYER PROCESSOR FOR LAYOFF & LAYFRZ --------------
; Main program body for LAYOFF and LAYFRZ. Provides user with
; options for handling nested entities.
; ----------------------------------------------------------------

(defun LAYPROC ( TASK / NOEXIT OPT BLKLST CNT EN PMT ANS LAY NEST BLKLST)
  (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)

; --------------------- Error initialization ---------------------

  (init_bonus_error 
    (list
      (list "cmdecho" 0
            "expert"  0
      )

      nil     ;flag. True means use undo for error clean up.  
    );list  
  );init_bonus_error

; -------------------- Variable initialization -------------------

  (setq NOEXIT T)
  (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)

  (setq OPT (getcfg (strcat "AppData/AC_Bonus/Lay" TASK)))    ; get default option setting
  (if (not (or (null OPT) (= OPT ""))) (setq OPT (atoi OPT)))

  (setq CNT 0)                                                ; cycle counter


  (while NOEXIT

    (initget "Options Undo")
    (if (= TASK "off")
      (setq EN (nentsel "\nOptions/Undo/<Pick an object on the layer to be turned OFF>: "))
      (setq EN (nentsel "\nOptions/Undo/<Pick an object on the layer to be FROZEN>: "))
    )

; ------------------------- Set Options --------------------------

    (While (= EN "Options")
      (initget "No Block Entity")
      (cond
        ((= OPT 1)
          (setq PMT "\nBlock level nesting/Entity level nesting/<No nesting>: ")
        )
        ((= OPT 2)
          (setq PMT "\nBlock level nesting/No nesting/<Entity level nesting>: ")
        )
        (T
          (setq PMT "\nEntity level nesting/No nesting/<Block level nesting>: ")
        )
      )
      (setq ANS (getkword PMT))

      (cond
        ((null ANS)
          (if (or (null OPT) (= OPT ""))
            (progn
              (print ANS)
              (setq OPT 3)
              (setcfg (strcat "AppData/AC_Bonus/Lay" TASK) "3")
            )
          )
        )
        ((= ANS "No")
          (setq OPT 1)
          (setcfg (strcat "AppData/AC_Bonus/Lay" TASK) "1")
        )
        ((= ANS "Entity")
          (setq OPT 2)
          (setcfg (strcat "AppData/AC_Bonus/Lay" TASK) "2")
        )
        (T
          (setq OPT 3)
          (setcfg (strcat "AppData/AC_Bonus/Lay" TASK) "3")
        )
      )

      (initget "Options")
      (if (= TASK "off")
        (setq EN (nentsel "\nOptions/Undo/<Pick an object on the layer to be turned OFF>: "))
        (setq EN (nentsel "\nOptions/Undo/<Pick an object on the layer to be FROZEN>: "))
      )
    )

; ------------------------- Find Layer ---------------------------

    (if (and EN (not (= EN "Undo")))
      (progn

        (setq BLKLST (last EN))
        (setq NEST (length BLKLST))

        (cond

      ; If the entity is not nested or if the option for entity
      ; level nesting is selected.
    
          ((or (= OPT 2) (< (length EN) 3))
            (setq LAY (entget (car EN)))
          )
  
      ; If no nesting is desired

          ((= OPT 1)
            (setq LAY (entget (car (reverse BLKLST))))
          )

      ; All other cases (default)

          (T
            (setq BLKLST (reverse BLKLST))
            
            (while (and                         ; strip out xrefs
                ( > (length BLKLST) 0)
                (assoc 1 (tblsearch "BLOCK" (cdr (assoc 2 (entget (car BLKLST))))))
                   );and
              (setq BLKLST (cdr BLKLST))
            )
            (if ( > (length BLKLST) 0)          ; if there is a block present
              (setq LAY (entget (car BLKLST)))  ; use block layer
              (setq LAY (entget (car EN)))      ; else use layer of nensel
            )
          )
        )

; ------------------------ Process Layer -------------------------

        (setq LAY (cdr (assoc 8 LAY)))
  
        (if (= LAY (getvar "CLAYER"))
          (if (= TASK "off")
            (progn
              (prompt (strcat "\nReally want layer " LAY " (the CURRENT layer) off? <N>: "))
              (setq ANS (strcase (getstring)))
              (if (not (or (= ANS "Y") (= ANS "YES")))
                (setq LAY nil)
              )
            )
            (progn
              (prompt (strcat "\nCannot freeze layer " LAY".  It is the CURRENT layer."))
              (setq LAY nil)
            )
          )
          (setq ANS nil)
        )
  
        (if LAY
          (if (= TASK "off")
            (progn
              (if ANS
                (command "_.-LAYER" "_OFF" LAY "_Yes" "")
                (command "_.-LAYER" "_OFF" LAY "")
              )
              (prompt (strcat "\nLayer " LAY " has been turned off."))
              (setq CNT (1+ CNT))
            )
            (progn
              (command "_.-LAYER" "_FREEZE" LAY "")
              (prompt (strcat "\nLayer " LAY " has been frozen."))
              (setq CNT (1+ CNT))
            )
          )
        )
      )

; -------------- Nothing selected or Undo selected ---------------

      (progn
        (if (= EN "Undo")
          (if (> CNT 0)
            (progn
              (command "_.u")
              (setq CNT (1- CNT))
            )
            (prompt "\nEverything has been undone.")
          )
          (setq NOEXIT nil)
        )
      )
    )
  )

  (restore_old_error)

)

; ********************** LAYER LOCK FUNCTION ********************
; Locks selected object's layer
; ***************************************************************

(Defun C:LAYLCK (/ LAY)
  (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)

  (init_bonus_error 
    (list
      (list "cmdecho" 0
            "expert"  0
      )

      T     ;flag. True means use undo for error clean up.  
    );list  
  );init_bonus_error

  (setq LAY (entsel "\nPick an object on the layer to be LOCKED: "))

  (if LAY
    (progn
      (setq LAY (cdr (assoc 8 (entget (car LAY)))))
      (Command "_.-LAYER" "_LOCK" LAY "")
      (prompt (strcat "\nLayer " LAY " has been locked."))
    )
  )

  (restore_old_error)

  (princ)
)

; ********************* LAYER UNLOCK FUNCTION *******************
; Unlocks selected object's layer
; ***************************************************************

;;;(Defun C:LAYULK (/ LAY)
;;;  (setq olderr  *error*             ; Initialize variables
;;;         *error* chgterr
;;;         chm     0)
;;;
;;;  (init_bonus_error 
;;;    (list
;;;      (list "cmdecho" 0
;;;            "expert"  0
;;;      )
;;;
;;;      T     ;flag. True means use undo for error clean up.  
;;;    );list  
;;;  );init_bonus_error
;;;
;;;  (setq LAY (entsel "\nPick an object on the layer to be UNLOCKED: "))
;;;
;;;  (if (/= LAY nil)
;;;    (progn
;;;      (setq LAY (cdr (assoc 8 (entget (car LAY)))))
;;;      (Command "_.-LAYER" "_UNLOCK" LAY "")
;;;      (prompt (strcat "\nLayer " LAY " has been unlocked."))
;;;      )
;;;    )
;;;
;;;  (restore_old_error)
;;;
;;;  (princ)
;;;)

(Defun C:LAYULK ()
  (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)

  (init_bonus_error 
    (list
      (list "cmdecho" 0)
      nil     ;flag. True means use undo for error clean up.  
    );list  
  );init_bonus_error

  (Command "_.-LAYER" "_UNLOCK" "*" "")
  (prompt "\nAll layers have been unlocked.")

  (restore_old_error)

  (princ)
)

; ************************ LAYER ON FUNCTION *********************
; Turns all layers on
; ****************************************************************

(Defun C:LAYON ()
  (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)

  (init_bonus_error 
    (list
      (list "cmdecho" 0)
      nil     ;flag. True means use undo for error clean up.  
    );list  
  );init_bonus_error

  (Command "_.-LAYER" "_ON" "*" "")
  (prompt "\nAll layers have been turned on.")

  (restore_old_error)

  (princ)
)


; *********************** LAYER THAW FUNCTION ********************
; Thaws all layers 
; ****************************************************************

(Defun C:LAYTHW ()
  (setq olderr  *error*             ; Initialize variables
        *error* chgterr
        chm     0)

  (init_bonus_error 
    (list
      (list "cmdecho" 0)
      nil     ;flag. True means use undo for error clean up.  
    );list  
  );init_bonus_error

  (Command "_.-LAYER" "_THAW" "*" "")
  (prompt "\nAll layers have been thawed.")

  (restore_old_error)

  (princ)
)


; ********************** LAYER MATCH FUNCTION *********************
; Changes the layer of selected object(s) to the layer of a
; selected destination object.
; *****************************************************************

(Defun C:LAYMCH (/ SS CNT LOOP LAY ANS)

  (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)
  

  (init_bonus_error 
    (list
      (list "cmdecho" 0)
      T     ;flag. True means use undo for error clean up.  
    );list  
  );init_bonus_error


  (if (not (setq SS (ssget "i")))
    (progn
      (prompt "\nSelect objects to be changed: ")
      (setq SS (ssget))
    )
  )

  (if SS
    (progn
      (setq CNT (sslength SS))
      (princ (strcat "\n" (itoa CNT) " found."))      ; Report number of items found

      (command "_.move" SS "")                         ; filter out objects on locked layers

      (if (> (getvar "cmdactive") 0)                   ; if there are still objects left
        (progn
          (command "0,0" "0,0")
          (setq SS  (ssget "p")
                CNT (- CNT (sslength SS))              ; count them
          )
        )
        (setq SS nil)                                  ; else abort operation
      ) 

      (if (> CNT 0)                                    ; if items where filtered out
        (if (= CNT 1)
          (princ (strcat "\n" (itoa CNT) " was on a locked layer."))   ; report it.
          (princ (strcat "\n" (itoa CNT) " were on a locked layer."))
        )
      )
    )
  )


  (if SS
    (progn
      (initget "Type")
      (setq LAY  (entsel "\nType name/Select entity on destination layer: ")
            LOOP T
      )
      
      (while LOOP
        (cond
          ((not LAY)
            (prompt "\nNothing selected.")
            (prompt "\nUse current layer? <Y> ")
            (setq ANS (strcase (getstring)))
            (if (or (= ANS "") (= ANS "Y") (= ANS "YES"))
              (setq LAY  (getvar "clayer")
                    LOOP nil
              )
            )
          )
          ((listp LAY)
            (setq LOOP nil)
          )
          ((= LAY "Type")
            (setq LAY (getstring "\nEnter layer name: "))
            (cond
              ((tblobjname "LAYER" LAY)
                (setq LOOP nil)
              )
              ((/= LAY "")
                (prompt "\nLayer does not exist. Would you like to create it? <Y>: ")
                (setq ANS (strcase (getstring)))
                (if (or (= ANS "") (= ANS "Y") (= ANS "YES"))
                  (if
                    (entmake (list
                              '(0 . "LAYER")
                              '(100 . "AcDbSymbolTableRecord")
                              '(100 . "AcDbLayerTableRecord")
                              '(6 . "CONTINUOUS")
                              '(62 . 7)
                              '(70 . 0)
                               (cons 2 LAY)
                             )
                    )
                    (setq LOOP nil)
                    (prompt "\nInvalid Layer name.")
                  )
                )
              )
            )
          )
        )
        (if LOOP
          (progn
            (initget "Type")
            (setq LAY (entsel "\nType name/Select entity on destination layer: "))
          )
        )
      ); while LOOP
        

      (if (listp LAY)
        (setq LAY (cdr (assoc 8 (entget (car LAY)))))
      )

      (command "_.change" SS "" "_p" "_la" LAY "")

      (if (= (sslength SS) 1)
        (prompt (strcat "\nOne object changed to layer " LAY ))
        (prompt (strcat "\n" (itoa (sslength SS)) " objects changed to layer " LAY ))
      )
      (if (= LAY (getvar "clayer"))
        (prompt " (the current layer).")
        (prompt ".")
      )
    )
  )

  (restore_old_error)

  (princ)
)

; ***************** CHANGE TO CURRENT LAYER FUNCTION **************
; Changes the layer of selected object(s) to the current layer
; *****************************************************************

(Defun C:LAYCUR (/ SS CNT LAY)

  (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)

  (init_bonus_error 
    (list
      (list "cmdecho" 0)
      T     ;flag. True means use undo for error clean up.  
    );list  
  );init_bonus_error


  (if (not (setq SS (ssget "i")))
    (progn
      (prompt "\nSelect objects to be CHANGED to the current layer: ")
      (setq SS (ssget))
    )
  )

  (if SS
    (progn
      (setq CNT (sslength SS))
      (princ (strcat "\n" (itoa CNT) " found."))      ; Report number of items found

      (command "_.move" SS "")                         ; filter out objects on locked layers

      (if (> (getvar "cmdactive") 0)                   ; if there are still objects left
        (progn
          (command "0,0" "0,0")
          (setq SS  (ssget "p")
                CNT (- CNT (sslength SS))              ; count them
          )
        )
        (setq SS nil)                                  ; else abort operation
      ) 

      (if (> CNT 0)                                    ; if items where filtered out
        (if (= CNT 1)
          (princ (strcat "\n" (itoa CNT) " was on a locked layer."))   ; report it.
          (princ (strcat "\n" (itoa CNT) " were on a locked layer."))
        )
      )
    )
  )

  (if SS
    (progn
      (setq LAY (getvar "CLAYER"))
      (command "_.change" SS "" "_p" "_la" LAY "")
      (if (= (sslength SS) 1)
        (prompt (strcat "\nOne object changed to layer " LAY " (the current layer)."))
        (prompt (strcat "\n" (itoa (sslength SS)) " objects changed to layer " LAY " (the current layer)."))
      )
    )
  )

  (restore_old_error)

  (princ)
)

;;;**********************************************************************
;;;            ;;;     BURST.LSP
;;; 
;;;     Last Revision 2004 - by R&C/TASK
;;;    
;;;           
;;;   Status:
;;;       Standard error control and header
;;;       adjust for mtext if possible

(Defun C:BURST (/ OLDERROR UNDOIT MLST ITEM BURST-ERROR MODES MODER
                BITSET BCNT BUMP  ATT-TEXT LASTENT BURST-ONE
                BURST PSFLAG)

   ;-----------------------------------------------------
   ; Item from association list
   ;-----------------------------------------------------
   (Defun ITEM (N E) (CDR (Assoc N E)))
   ;-----------------------------------------------------
   ; Error Handler
   ;-----------------------------------------------------
   (Defun BURST-ERROR (S)
      (If (not (wcmatch S "Function cancelled,console break"))
         (Princ S)
      )
      (Command)
      (Command)
 ;;     (Command "._UNDO" "e")
      (If UNDOIT
         (Progn
            (Princ "\nUndoing...")
            (Command "._undo" 1)
         )
      )
      (MODER)
   )
   ;-----------------------------------------------------
   ; System variable save
   ;-----------------------------------------------------
   (Defun MODES (A)
      (Setq MLST Nil)
      (Repeat
         (Length A)
         (Setq
            MLST (Append
                    MLST
                    (List (List (CAR A) (GetVar (CAR A))))
                 )
            A    (CDR A)
         )
      )
   )
   ;-----------------------------------------------------
   ; System variable restore
   ;-----------------------------------------------------
   (Defun MODER ()
      (Repeat
         (Length MLST)
         (Setvar (CAAR MLST) (CADAR MLST))
         (Setq MLST (CDR MLST))
      )
      (Setq *Error* OLDERROR)
      (Princ)
   )
   ;-----------------------------------------------------
   ; BIT SET
   ;-----------------------------------------------------
   (Defun BITSET (A B) (= (Boole 1 A B) B))
   ;-----------------------------------------------------
   ; BUMP
   ;-----------------------------------------------------
   (Setq bcnt 0)
   (Defun bump (prmpt)
      (Princ
         ;(Strcat
         ;   "\r"
         ;   prmpt
         ;   " ["
         ;   (Nth bcnt '("-" "\\" "|" "/"))
         ;   "]...  "
         ;)
         (Nth bcnt '("\r-" "\r\\" "\r|" "\r/")) 
      )
      (Setq bcnt (Rem (1+ bcnt) 4))
   )
   ;-----------------------------------------------------
   ; Convert Attribute Entity to Text Entity
   ;-----------------------------------------------------
   (Defun ATT-TEXT (AENT / TENT ILIST INUM)
      (Setq TENT '((0 . "TEXT")))
      (ForEach INUM '(8
            6
            38
            39
            62
            67
            210
            10
            40
            1
            50
            41
            51
            7
            71
            72
            73
            11
         )
         (If (Setq ILIST (Assoc INUM AENT))
            (Setq TENT (Cons ILIST TENT))
         )
      )
      (Setq
         tent (Subst
                 (Cons 73 (item 74 aent))
                 (Assoc 72 tent)
                 tent
              )
      )
      (EntMake (Reverse TENT))
   )
   ;-----------------------------------------------------
   ; Find True last entity
   ;-----------------------------------------------------
   (Defun LASTENT (/ E0 EN)
      (Setq E0 (EntLast))
      (While (Setq EN (EntNext E0))
         (Setq E0 EN)
      )
      E0
   )
   ;-----------------------------------------------------
   ; Burst one entity
   ;-----------------------------------------------------
   (Defun BURST-ONE (BNAME / BENT ANAME ENT ATYPE AENT AGAIN ENAME
                     ENT SS-COLOR SS-LAYER SS-LTYPE mirror ss-mirror
                     mlast)
      (Setq
         BENT   (EntGet BNAME)
         BLAYER (ITEM 8 BENT)
         BCOLOR (ITEM 62 BENT)
         BCOLOR (Cond
                   ((> BCOLOR 0) BCOLOR)
                   ((= BCOLOR 0) "BYBLOCK")
                   ("BYLAYER")
                )
         BLTYPE (Cond ((ITEM 6 BENT)) ("BYLAYER"))
      )
      (Setq ELAST (LASTENT))
      (If (= 1 (ITEM 66 BENT))
         (Progn
            (Setq ANAME BNAME)
            (While (Setq
                      ANAME (EntNext ANAME)
                      AENT  (EntGet ANAME)
                      ATYPE (ITEM 0 AENT)
                      AGAIN (= "ATTRIB" ATYPE)
                   )
               (bump "Converting attributes")
               (ATT-TEXT AENT)
            )
         )
      )
         (Progn
            (bump "Exploding block")
            (Command "._explode" BNAME)
         )
      (Setq
         SS-LAYER (SsAdd)
         SS-COLOR (SsAdd)
         SS-LTYPE (SsAdd)
         ENAME    ELAST
      )
      (While (Setq ENAME (EntNext ENAME))
         (bump "Gathering pieces")
         (Setq
            ENT   (EntGet ENAME)
            ETYPE (ITEM 0 ENT)
         )
         (If (= "ATTDEF" ETYPE)
            (Progn
               (If (BITSET (ITEM 70 ENT) 2)
                  (ATT-TEXT ENT)
               )
               (EntDel ENAME)
            )
            (Progn
               (If (= "0" (ITEM 8 ENT))
                  (SsAdd ENAME SS-LAYER)
               )
               (If (= 0 (ITEM 62 ENT))
                  (SsAdd ENAME SS-COLOR)
               )
               (If (= "BYBLOCK" (ITEM 6 ENT))
                  (SsAdd ENAME SS-LTYPE)
               )
            )
         )
      )
      (If (> (SsLength SS-LAYER) 0)
         (Progn
            (bump "Fixing layers")
            (Command
               "._chprop" SS-LAYER "" "la" BLAYER ""
            )
         )
      )
      (If (> (SsLength SS-COLOR) 0)
         (Progn
            (bump "Fixing colors")
            (Command
               "._chprop" SS-COLOR "" "c" BCOLOR ""
            )
         )
      )
      (If (> (SsLength SS-LTYPE) 0)
         (Progn
            (bump "Fixing linetypes")
            (Command
               "._chprop" SS-LTYPE "" "lt" BLTYPE ""
            )
         )
      )
   )
   ;-----------------------------------------------------
   ; BURST MAIN ROUTINE
   ;-----------------------------------------------------
   (Defun BURST (/ SS1)
      (setq PSFLAG (if (= 1 (caar (vports)))
                       1 0
                   )
      )
      (Setq SS1 (SsGet (list (cons 0 "INSERT")(cons 67 PSFLAG))))
      (If SS1
         (Progn
            (Setq UNDOIT T)
            (Setvar "highlight" 0)
            (Repeat
               (SsLength SS1)
               (Setq ENAME (SsName SS1 0))
               (SsDel ENAME SS1)
               (BURST-ONE ENAME)
            )
            (princ "\n")
            (Command REDRAW-COMMAND)
         )
      )
   )
   ;-----------------------------------------------------
   ; BURST COMMAND
   ;-----------------------------------------------------
   (MODES '("cmdecho" "highlight"))
   (Setq
      OLDERROR *Error*
      *Error*  BURST-ERROR
   )
   (Setvar "cmdecho" 0)
;;   (Command "._undo" "group")
   (BURST)
;;   (Command "._undo" "e")
   (MODER)
)


;;; ********************************************************************;                             
 
;                             CHGTEXT.LSP

;  This program will replace every occurrence of an "old string" with a     
;  "new string".  You will be prompted to select the text you wish
;  to change.  Then you will be asked to enter the "old string" and 
;  the "new string".  After the text has been changed, the total number 
;  of changed lines is displayed.
; **********************************************************************

(defun chgterr (s)
   (if (/= s "Function cancelled")   ; If an error (such as CTRL-C) occurs
      (princ (strcat "\nError: " s)) ; while this command is active...
   )
   (setq p nil)                      ; Free selection set
   (setq *error* olderr)             ; Restore old *error* handler
   (princ)
)

(defun C:CHGTEXT (/ p l n e os as ns st s nsl osl sl si chf chm olderr) ;Declare the command, no args
   (setq olderr  *error*             ; Initialize variables
         *error* chgterr
         chm     0)
   (setq p (ssget))                  ; Select objects, variable p contains ss
   (if p (progn                      ; If any objects selected, continue
;|  While, the expession is something other than nil, continue processing...
    Getstring, Request input string from user.
    The T permits a space to be entered.
    Setq, stores the input in the variable os
    Strlen, returns the number of characters in the string
    Setq, stores the number in the varible osl
    =, does everything to the left equal zero?
|;
      (while (= 0 (setq osl (strlen (setq os (getstring t "\nOld string: ")))))
            (princ "Null input invalid")    ;Catch the fact that no input was provided
      )
      (setq nsl (strlen (setq ns (getstring t "\nNew string: "))))  ;New input
      (setq l 0 n (sslength p))                                     ;L set to zero
                                                                    ;number of items in ss
      (while (< l n)                 ; For each selected object...
         (if (= "TEXT"               ; Look for TEXT entity type (group 0)
                (cdr (assoc 0 (setq e (entget (ssname p l)))))) ;get the entity number
            (progn                                              ;container
               (setq chf nil si 1)                          ;si is 1, chf "flag" is nil
               (setq s (cdr (setq as (assoc 1 e))))         ;return assoc list
;|   Place the specific letter or character in st, second line
     osl is the integer, no of chars...
     so the word is now in st, the length of that word is stored in sl
|;
               (while (= osl (setq sl (strlen               
                             (setq st (substr s si osl)))))
                  (if (= st os)       ;If the old word equals the new word...
                      (progn          ;container
                        (setq s (strcat (substr s 1 (1- si)) ns   ;ns is new str, si = 1,
                                        (substr s (+ si osl))))   ;
                        (setq chf t)    ; Found old string, set a flag...chf is true!
                        (setq si (+ si nsl))  ;Increment the counter
                      )
                      (setq si (1+ si))
                  )
               )
               (if chf (progn        ; Substitute new string for old
                  (setq e (subst (cons 1 s) as e))
                  (entmod e)         ; Modify the TEXT entity
                  (setq chm (1+ chm))
               ))
            )
         )
         (setq l (1+ l))
      )
   )
   );end the first if statement,  If p contains nothing, we end up here
   (princ "Changed ")                ; Print total lines changed
   (princ chm)                       ; The varible chm is a ??, string, integer, real
   (princ " text lines.")            ; print a string
   (terpri)                          ; send a "blank" to the command line, i.e. return nothing
   (setq *error* olderr)             ; Restore old *error* handler
   (princ)
)



;;;************************************************************************
;                              TRIMLINE.LSP
;Revision ©2007 by R&C/TASK

(Defun C:TL (/ $OR PT1 PT2 AX F2) 
  (prompt "\nTrim Line routine... ")
  (setq $OR (getvar "ORTHOMODE"))(setvar "ORTHOMODE" 1)
  (setq PT1 (getpoint "\nFirst point of trimming line:  "))
  (setq PT2 (getpoint "\n  \"ORTHO is ON\"   Endpoint:" PT1))
  (command ".line" PT1 PT2 "")
  (setq AX (entlast))
  (setvar "ORTHOMODE" 0)
  (setq F2 
  (getpoint "\nEndpoint of FENCE (across lines to be trimmed): " PT1))
    (command "._trim" "l" "" "f" PT1 F2 "" "")
    (setvar "ORTHOMODE" $OR)
    (command "._erase" AX "" "redraw")
    (princ)
)


;=============================================== 
;    UnAnon.Lsp                                   Jul 05, 1998 
;====================================== 
(princ "\nCopyright (C) 1998, Fabricated Designs, Inc.") 
(princ "\nLoading UnAnon v1.0 ") 
(setq uan_ nil lsp_file "UnAnon") 

;================== For Automated Calling From Another Program ========= 
(defun uan_auto (ar1) (UnAnon ar1)) 

;================== Macros ============================================= 
(defun PDot ()(princ ".")) 

(PDot);++++++++++++ Set Modes & Error ++++++++++++++++++++++++++++++++++ 
(defun uan_smd () 
 (SetUndo) 
 (setq olderr *error* 
      *error* (lambda (e) 
                (and (/= e "quit / exit abort") 
                     (princ (strcat "\nError: *** " e " *** "))) 
                (command "_.UNDO" "_END" "_.U") 
                (uan_rmd)) 
       uan_var '( 
  ("CMDECHO"   . 0) ("MENUECHO" . 0) ("MENUCTL"   . 0) ("MACROTRACE" . 0) 
  ("OSMODE"    . 0) ("SORTENTS" . 119)("MODEMACRO" . ".") 
  ("BLIPMODE"  . 0) ("EXPERT"   . 0) ("SNAPMODE"  . 1) ("PLINEWID"   . 0.0) 
  ("ORTHOMODE" . 1) ("GRIDMODE" . 0) ("ELEVATION" . 0) ("THICKNESS"  . 0) 
  ("FILEDIA"   . 0) ("FILLMODE" . 0) ("SPLFRAME"  . 0) ("UNITMODE"   . 0) 
  ("TEXTEVAL"  . 0) ("ATTDIA"   . 0) ("AFLAGS"    . 0) ("ATTREQ"     . 1) 
  ("ATTMODE"   . 1) ("UCSICON"  . 1) ("HIGHLIGHT" . 1) ("REGENMODE"  . 1) 
  ("COORDS"    . 2) ("DRAGMODE" . 2) ("DIMZIN"    . 1) ("PDMODE"     . 0) 
  ("CECOLOR"   . "BYLAYER") ("CELTYPE" . "BYLAYER"))) 
 (foreach v uan_var 
      (setq m_v (cons (getvar (car v)) m_v) 
            m_n (cons (car v) m_n)) 
      (setvar (car v) (cdr v))) 
 (princ (strcat (getvar "PLATFORM") " Release " (substr (ver) 18 2) 
   " -  Convert To Anonymous Blocks ....\n")) 
 (princ)) 

(PDot);++++++++++++ Return Modes & Error +++++++++++++++++++++++++++++++ 
(defun uan_rmd () 
  (setq *error* olderr) 
  (mapcar 'setvar m_n m_v) 
  (command "_.UNDO" "_END") 
  (prin1)) 

(PDot);++++++++++++ Set And Start An Undo Group ++++++++++++++++++++++++ 
(defun SetUndo () 
 (and (zerop (getvar "UNDOCTL")) 
      (command "_.UNDO" "_ALL")) 
 (and (= (logand (getvar "UNDOCTL") 2) 2) 
      (command "_.UNDO" "_CONTROL" "_ALL")) 
 (and (= (logand (getvar "UNDOCTL") 8) 8) 
      (command "_.UNDO" "_END")) 
 (command "_.UNDO" "_GROUP")) 

(PDot);++++++++++++ Get Entity Name ++++++++++++++++++++++++++++++++++++ 
(defun GetOne (/ st os) 
 (setq os (getvar "SNAPMODE") s nil) 
 (setvar "SNAPMODE" 0) 
 (while (not st) 
        (setq st (ssget))) 
 (while (> (sslength st) 1) 
        (setq st nil) 
        (princ "\nOnly 1 At A Time Please\n") 
        (while (not st) 
               (setq st (ssget)))) 
 (setvar "SNAPMODE" os) 
 (setq s (ssname st 0))) 

(PDot);++++++++++++ Convert An Anonymous Block To Named Block ++++++++++ 
(defun UnAnon (b / tdef en ed bc bn bd in)          ;Supply ename 
  (setq bn "TEMP1" bc 1) 
  (while (tblsearch "BLOCK" bn) 
         (setq bc (1+ bc) bn (strcat "TEMP" (itoa bc)))) 
  (and (= (type b) 'ENAME) 
       (setq bd (entget b) 
             in (cdr (assoc 2 bd)))) 
  (if (or (not bd) 
          (not in) 
          (/= "INSERT" (cdr (assoc 0 bd))) 
          (/= "*U" (substr in 1 2)) 
          (= (logand (cdr (assoc 70 (tblsearch "BLOCK" in)))  4)  4) 
          (= (logand (cdr (assoc 70 (tblsearch "BLOCK" in))) 16) 16) 
          (= (logand (cdr (assoc 70 (tblsearch "BLOCK" in))) 32) 32)) 
       (progn 
         (princ "*** Not An Anonomymous Block *** ") 
         (setq bn nil bc nil bd nil in nil b nil) 
         (exit))) 
  (setq tdef (tblsearch "BLOCK" in) 
          en (cdr (assoc -2 tdef)) 
          ed (entget en)) 
  (entmake (list (cons 0 "BLOCK") 
                 (cons 2 bn) 
                 (cons 70 0) 
                 (cons 10 (cdr (assoc 10 tdef))))) 
  (entmake ed) 
  (while (setq en (entnext en)) 
         (setq ed (entget en)) 
         (entmake ed)) 
  (entmake (list (cons 0 "ENDBLK"))) 
  (setq bd (subst (cons 2 bn) (assoc 2 bd) bd)) 
  (entmod bd) 
  (entupd b) 
  (princ (strcat "\n" bn))) 

(PDot);************ Main Program *************************************** 
(defun uan_ (/ m_v m_n olderr uan_var s) 
  (uan_smd) 
  (GetOne) 
  (UnAnon s) 
  (uan_rmd)) 

(defun c:NAMINGBLK (/ ss i) 
 (setq ss (ssget "X" (list (cons 0 "INSERT")(cons 67 (if (= (getvar "TILEMODE") 1) 0 1))))) 
 (and ss 
   (setq i (sslength ss)) 
   (while (not (minusp (setq i (1- i)))) 
          (setq en (ssname ss i)) 
          (if (= "*U" (substr (cdr (assoc 2 (entget en))) 1 2)) 
              (UnAnon en)))) 
 (prin1)) 

(PDot);************ Load Program *************************************** 
(defun C:UnAnon () (uan_)) 
(if uan_ (princ "\nUnAnon Loaded\n")) 
(prin1) 
;================== End Program ======================================== 



;;; Text2MText[

(defun c:text2mtext (/ dxf ss index ent mtext)
  (command "cmdecho" "off")
  (setq mover 0)
  (defun dxf (tag obj) (cdr (assoc tag obj)))
  (cond
    ((not (setq reftext (car (entsel "\nPick reference text"))))
       (princ "Nothing selected"))
    ((not (= (dxf 0 (setq reftext (entget reftext))) "TEXT"))
       (princ "Not a text"))
    ((not (setq ss (ssget)))
       (princ "Nothing selected"))
    (T
     (setq mover 1)
     (setq index 0.0
           mtext '((0 . "MTEXT") (100 . "AcDbEntity") (100 . "AcDbMText"))
           mtext (append mtext 
                         (list (assoc 8 reftext) (assoc 10 reftext)
                               (assoc 7 reftext) (assoc 40 reftext)
                               (cons 41 (abs (- (caar (textbox reftext))
                                                (caadr (textbox reftext)))))
                               (cons 3 (strcat (dxf 1 reftext) "\\P"))))
     )


     (setq z1 (cdr (assoc 40 reftext)))

     (entdel (dxf -1 reftext))
     (repeat (sslength ss)
       (cond ((not
                (= (dxf 0 (setq ent (entget (ssname ss index)))) "TEXT")
              )
                (princ "Non-text ignored")
             )
             (T (setq mtext (append mtext 
                               (list (cons 3 (strcat (dxf 1 ent) "\\P")))))
                (entdel (dxf -1 ent))
             )
       )
       (setq index (1+ index))
     )
     (entmake (append mtext '((1 . " "))))
    )
  )
  (if (= mover 1)
     (command "move" "l" "" "0,0" (strcat "0," (rtos z1)))
  )
  (command "cmdecho" "on")
  (princ)
)

;;; Text2MText]


;;;PER[
(Defun C:PER (/ SANG SBASE SMODE ORTHO OSM P1 P2)
  (setvar "cmdecho" 0)
  (setq SANG (getvar "snapang"))
  (setq SBASE (getvar "snapbase"))
  (setq SMODE (getvar "snapmode"))
  (setq ORTHO (getvar "orthomode"))
  (setq OSM (getvar "osmode"))
  (setq	P1
	 (osnap
	   (getpoint
	     "\nSelect a point on entity (SNAP) to draw a perpendicular choosing the side... :  "
	   )
	   "nea"
	 )
  )
  (setvar "osmode" 0)
  (setq P2 (osnap P1 "end"))
  (if (equal P1 P2)
    (setq P2 (osnap P1 "MID"))
  )
  (command ".snap" "r" P1 P2)
  (setvar "snapmode" 0)
  (setvar "orthomodE" 1)
  (prompt "\nto point:")
  (command "pline" P1 pause "")
  (setvar "snapang" SANG)
  (setvar "snapbase" SBASE)
  (setvar "snapmode" SMODE)
  (setvar "orthomode" ORTHO)
  (setvar "osmode" OSM)
  (setvar "cmdecho" 1)
  (command "snapang" "0")
  (princ)
)	
;;;PER]


;;;************************************************************************

;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;
;                             AREAS.LSP
;        
;This routine will write the area and perimeter of selected closed
; polylines to an ascii file.  This file will have an area, a user
; input comment and a perimter on each line.  The file is tab
; delimited.

(defun c:areas(;			write area and perimeter of selected
;					plines out to a file
  /;			no formal arguments
 )
 (if (and
   (setq fname (getfiled "Output filename" "" "txt" 1))
   (setq fileh (open fname "w"))
  )
  (progn
   (write-line "Area\tPerimeter" fileh)
   (setq cmdecho (getvar "cmdecho"))
   (setvar "cmdecho" 0)
   (while (setq ent (entsel "\nSelect a closed polyline. "))
    (redraw (car ent) 3)
    (setq elist (entget (car ent)))
    (cond
     ((= "POLYLINE" (cdr (assoc 0 elist)))
      (if (= 1 (logand (cdr (assoc 70 elist)) 1))
       (progn
        (command "area" "e" ent)
        (setq
         area (getvar "area")
         perimeter (getvar "perimeter")
        )
        (if (= 4 (getvar "lunits"))
         (setq
          area (/ area 144.0)
          perimeter (/ perimeter 12.0)
         )
        )
        (write-line
         (strcat
          (rtos area 2 4)
          "\t"
          (rtos perimeter 2 4)
         );				strcat
         fileh
        );				write-line
       );				progn
       (princ "\nSelected pline is not closed. ")
      );			end if
     );				end polyline
     (T (princ "\nSelected entity is not a pline. "))
    );				end cond
   );				end while
   (setq fileh (close fileh))
   (setvar "cmdecho" cmdecho)
  );				end progn if filename and handle aquired
 );				end if
 (princ)
)

(progn

 (princ)
)

;;;************************************************************************

;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;
;;;				ATEXT2.LSP

;;;*ANGTOC is an angle formatting function that takes an angle
;;;*argument in radians and returns it with 6 decimal places
;;;*in a form universally acceptable to IntellVCAD command input
;;;*
(defun angtoc (ang)
  (setq ang
    (rtos (atof (angtos ang 0 8)) 2 6)
  )
  (strcat "<<" ang)
)

(if (not angtoc)                                              ;Test subroutines
  (prompt "\nRequires ANGTOC function. Load aborted. ")

;;;* ATEXT types text in an arc. The function gets the midpoint of the txt, the
;;;* radius point, and the orientation. This version determines if the text style
;;;* height is fixed and prompts for height if not. It uses the ANGTOC function.

(defun C:ATEXT ( / midp radp txt radi txtlen txtspc txthgt cmd arclen
  arcang sang orent txtang txtp char)
  (setq cmdech (getvar "CMDECHO"))                  ;Save command echo
  (setvar "CMDECHO" 0)                              ;Turn command echo off
  (graphscr)  
  (setq                                             ;Assign variables
    radp (getpoint "\nPick radius point: " )        ;Get radius point of text
    midp (getpoint "\nPick middle point of text: " radp) ;Get midpoint of text
    cmd 
      (if (= 0 (setq txthgt
                     (cdr (assoc 40 (tblsearch "STYLE" (getvar "TEXTSTYLE")))
      )   )    )
        (progn                                      ;If height not fixed...  
          (setq txthgt
            (getdist (strcat "\nText height <"      ;Get text height
                             (rtos (setq txt (getvar "TEXTSIZE"))) ;Default
                             ">: "
            )        )
            txthgt (if txthgt txthgt txt)           ;Set to default if nil
          );setq
          '(command "TEXT" "C" txtp txthgt txtang char) ;Assign command list
        );progn
        '(command "TEXT" "C" txtp txtang char)      ;Else fixed ht command list
      );end if
    txt (getstring "\nText: " T)                    ;Get text string
    radi (distance radp midp)                       ;Determine radius
    txtlen (strlen txt)                             ;Determine string length
    txtspc (cdr (assoc 41 (tblsearch "STYLE" (getvar "TEXTSTYLE")))) ;Char width
  );end variable assignment

  (setq orent         ;Get text orientation
    (strcase (getstring "\nIs base of text towards radius point <Y>: ")) ;Upper
  )

  ;; Calculate new radius length based on orientation
  (if (or (= orent "") (= orent "Y"))
    (setq radi (- radi (/ txthgt 2)))
    (setq radi (+ radi (/ txthgt 2)))          
  );end if

  (setq                                   ;Calculate variables
    arclen (* txtlen txtspc txthgt)       ;Arc length
    txtspc (/ arclen txtlen)              ;Arc length of one character
    arcang (/ arclen radi)                ;Arc angle of one character
    sang (- (+ (angle radp midp) (/ arcang 2))   ;Start angle of text
            (/ txtspc radi 2)
         )
    count 1                               ;Initialize counter          
  )

  (repeat txtlen                          ;Insert character loop
    (if (or (= orent "") (= orent "Y"))   ;Test text angle
        ;; Preface angle w/ << for universal angular units in dec. string
        (setq txtang (angtoc
                       (- sang (/ pi 2))  ;Convert start angle minus 90 deg
                     )                                      
              txtpos count
        ) 
        ;; Calc angle for character towards radius and 
        ;; character position in string
        (setq txtang (angtos (- sang (* pi 1.5)) 0) ;angle to command function
           txtpos (- (1+ txtlen) count)
        )
        ;; Calc angle for character away from radius and 
        ;; character position in string
    )
    (setq txtp (polar radp sang radi))    ;Calculate character point
    (setq char (substr txt txtpos 1))     ;Get text character
    (eval cmd)                            ;Execute command list
    (setq count (1+ count))               ;Increment counter
    (setq sang (- sang (/ txtspc radi)))  ;Calculate new start angle
  );End repeat loop
  (setvar "CMDECHO" cmdech)               ;Turn command echo on
  (princ)                                 ;Ends program cleanly
);End defun
;*end of ATEXT2.LSP
;*
);test subroutines

;;;**************************************************************************

;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;				
;;;			      BOXTXT.LSP
;;;
;;;
;   *** A program to draw a BASIC dimension type box
;       around a text entity. Expects a layer named DIM
;       and a linetype named CONTINUOUS to exist. The box
;       is half the text height away from all 4 sides
;       of the text entity.
;   *** R&C/TASK
;       

(defun C:TSBOX (/ e1 ed en pt1 pt2 pt3 pt4 pt1a ang1 ang2 items offset I length length1 oldcolr oldlay oldlt newlaw V1_Color)
   (setvar "CMDECHO" 0)
;;   (COMMAND ".UNDO" "MARK")  ;Undo marker
   (setq oldcolr (getvar "CECOLOR"))
   (setq oldlay (getvar "CLAYER"))
   (setq oldlt (getvar "CELTYPE"))
   (COMMAND ".COLOR" "BYLAYER")
   (COMMAND ".LINETYPE" "S" "CONTINUOUS" "")
   (prompt "\n \nDraw a Solid Box around text items: ")
   (setq V1_Color "OK")
   (setq items (ssget)) ; Select items
   (setq I (sslength items)); Counter
   (while (> I 0); While items are left
      (setq I (1- I)); Decrement counter
      (setq en (ssname items I)) ; Get name
      (setq ed (entget en))      ; Get entity info
      (if (= "TEXT" (cdr (assoc 0 ed)))
	 (progn                  ; If entity is text
	    (setq e1 ed)         ; Save a copy
            (setq offset (/ (cdr (assoc 40 ed)) 1))
            (setq ed (subst (cons 72 2) (assoc 72 ed) ed)); Make text right
            (entmod ed)                                   ; justified
            (setq ed (entget en)); Update entity details
            (setq pt1 (cdr (assoc 10 ed)))  ; Left endpoint of modified text
            (setq pt2 (cdr (assoc 11 ed)))  ; Right endpoint of modified text
            (setq length (distance pt1 pt2)); Calculate length of string
            (setq ed e1)                    ; Restore original justification
            (entmod ed)
            (setq pt1a (cdr (assoc 10 ed))) ; Lower left corner original string
            (setq ang1 (cdr (assoc 50 ed))) ; Retrieve angle of text
            (setq ang2 (+ ang1 (/ PI 2)))   ; Set perpendicular angle
            (setq pt1b (polar pt1a (+ ang1 PI) offset)); Offset from text end
            (setq pt1 (polar pt1b (+ ang2 PI) offset)); Offset from btm of text
            ; Calc lower right corner of box
            (setq  pt2  (polar  pt1  ang1 (+ length (* 2 offset))))
            ; Length of box perp to text
            (setq length1 (+ (cdr (assoc 40 ed)) (* 2 offset)))
            (setq pt3 (polar pt2 ang2 length1)); Calc upper right corner of box
            (setq pt4 (polar pt1 ang2 length1)); Calc upper left cornar of box
	    (setq newlay (cdr (assoc 8 (entget en))))
	   (if (= V1_Color "OK")
	     (progn
	       (COMMAND "change" "p" "" "p" "c" "255" "")
	       (setq V1_Color nil)
	       )
	     )
	    (COMMAND ".LAYER" "M" newlay "")
	    (COMMAND ".COLOR" 255)
            (COMMAND ".PLINE" pt1 pt2 pt3 pt4 "C"); Draw line around text
	    (COMMAND ".COLOR" 250)
	    (command "hatch" "solid" "last" "")
	    (command "draworder" "last" "" "back")
         ); End progn
         (prompt "\nThis is not a text item ! ! ")
      ); End if not a text item
   ); End while more items
   (setq V1_Color nil)
   (ssget "x" '((0 . "image")))
   (command "draworder" "p" "" "back")
   (setvar "HIGHLIGHT" 1)
   (COMMAND ".LAYER" "S" OLDLAY "")
   (COMMAND ".COLOR" OLDCOLR)
   (COMMAND ".LINETYPE" "S" OLDLT "")
   (setvar "CMDECHO" 1)
   (prin1)
)

(defun C:TBOX (/ e1 ed en pt1 pt2 pt3 pt4 pt1a ang1 ang2 items offset I length length1 oldcolr oldlay oldlt newlaw )
   (setvar "CMDECHO" 0)
;;   (COMMAND ".UNDO" "MARK")  ;Undo marker
   (setq oldcolr (getvar "CECOLOR"))
   (setq oldlay (getvar "CLAYER"))
   (setq oldlt (getvar "CELTYPE"))
   (COMMAND ".COLOR" "BYLAYER")
   (COMMAND ".LINETYPE" "S" "CONTINUOUS" "")
   (prompt "\n \nDraw a basic Box around text items: ")
   (setq items (ssget)) ; Select items
   (setq I (sslength items)); Counter
   (while (> I 0); While items are left
      (setq I (1- I)); Decrement counter
      (setq en (ssname items I)) ; Get name
      (setq ed (entget en))      ; Get entity info
      (if (= "TEXT" (cdr (assoc 0 ed)))
         (progn                  ; If entity is text
            (setq e1 ed)         ; Save a copy
            (setq offset (/ (cdr (assoc 40 ed)) 2))
            (setq ed (subst (cons 72 2) (assoc 72 ed) ed)); Make text right
            (entmod ed)                                   ; justified
            (setq ed (entget en)); Update entity details
            (setq pt1 (cdr (assoc 10 ed)))  ; Left endpoint of modified text
            (setq pt2 (cdr (assoc 11 ed)))  ; Right endpoint of modified text
            (setq length (distance pt1 pt2)); Calculate length of string
            (setq ed e1)                    ; Restore original justification
            (entmod ed)
            (setq pt1a (cdr (assoc 10 ed))) ; Lower left corner original string
            (setq ang1 (cdr (assoc 50 ed))) ; Retrieve angle of text
            (setq ang2 (+ ang1 (/ PI 2)))   ; Set perpendicular angle
            (setq pt1b (polar pt1a (+ ang1 PI ) offset)); Offset from text end
            (setq pt1 (polar pt1b (+ ang2 PI) offset)); Offset from btm of text
            ; Calc lower right corner of box
            (setq  pt2  (polar  pt1  ang1 (+ length (* 2 offset))))
            ; Length of box perp to text
            (setq length1 (+ (cdr (assoc 40 ed)) (* 2 offset)))
            (setq pt3 (polar pt2 ang2 length1)); Calc upper right corner of box
            (setq pt4 (polar pt1 ang2 length1)); Calc upper left cornar of box
	    (setq newlay (cdr (assoc 8 (entget en))))
	    (COMMAND ".LAYER" "M" newlay "")
            (COMMAND ".PLINE" pt1 pt2 pt3 pt4 "C"); Draw line around text
         ); End progn
         (prompt "\nThis is not a text item ! ! ")
      ); End if not a text item
   ); End while more items
   (setvar "HIGHLIGHT" 1)
   (COMMAND ".LAYER" "S" OLDLAY "")
   (COMMAND ".COLOR" OLDCOLR)
   (COMMAND ".LINETYPE" "S" OLDLT "")
   (setvar "CMDECHO" 1)
   (prin1)
); BOXTXT


(defun BOXTXT2 (/ e1 ed en pt1 pt2 pt3 pt4 pt1a
                   ang1 ang2 items offset I length1
                   oldcolr oldlay oldlt newlaw )
   (setvar "CMDECHO" 0)
;;   (COMMAND ".UNDO" "MARK")  ;Undo marker
   (setq oldcolr (getvar "CECOLOR"))
   (setq oldlay (getvar "CLAYER"))
   (setq oldlt (getvar "CELTYPE"))
   (COMMAND ".COLOR" "BYLAYER")
   (COMMAND ".LINETYPE" "S" "CONTINUOUS" "")
   (prompt "\n \nDraw basic dimension type box around text items: ")
   (setq items (ssget "l")) ; Select items
   (setq I (sslength items)); Counter
   (while (> I 0); While items are left
      (setq I (1- I)); Decrement counter
      (setq en (ssname items I)) ; Get name
      (setq ed (entget en))      ; Get entity info
      (if (= "TEXT" (cdr (assoc 0 ed)))
         (progn                  ; If entity is text
            (setq e1 ed)         ; Save a copy
            (setq offset (/ (cdr (assoc 40 ed)) 2))
            (setq ed (subst (cons 72 2) (assoc 72 ed) ed)); Make text right
            (entmod ed)                                   ; justified
            (setq ed (entget en)); Update entity details
            (setq pt1 (cdr (assoc 10 ed)))  ; Left endpoint of modified text
            (setq pt2 (cdr (assoc 11 ed)))  ; Right endpoint of modified text
            (setq length (distance pt1 pt2)); Calculate length of string
            (setq ed e1)                    ; Restore original justification
            (entmod ed)
            (setq pt1a (cdr (assoc 10 ed))) ; Lower left corner original string
            (setq ang1 (cdr (assoc 50 ed))) ; Retrieve angle of text
            (setq ang2 (+ ang1 (/ PI 2)))   ; Set perpendicular angle
            (setq pt1b (polar pt1a (+ ang1 PI ) offset)); Offset from text end
            (setq pt1 (polar pt1b (+ ang2 PI) offset)); Offset from btm of text
            ; Calc lower right corner of box
            (setq  pt2  (polar  pt1  ang1 (+ length (* 2 offset))))
            ; Length of box perp to text
            (setq length1 (+ (cdr (assoc 40 ed)) (* 2 offset)))
            (setq pt3 (polar pt2 ang2 length1)); Calc upper right corner of box
            (setq pt4 (polar pt1 ang2 length1)); Calc upper left cornar of box
	    (setq newlay (cdr (assoc 8 (entget en))))
	    (COMMAND ".LAYER" "M" newlay "")
            (COMMAND ".PLINE" pt1 pt2 pt3 pt4 "C"); Draw line around text
         ); End progn
         (prompt "\nThis is not a text item ! ! ")
      ); End if not a text item
   ); End while more items
   (setvar "HIGHLIGHT" 1)
   (COMMAND ".LAYER" "S" OLDLAY "")
   (COMMAND ".COLOR" OLDCOLR)
   (COMMAND ".LINETYPE" "S" OLDLT "")
   (setvar "CMDECHO" 1)
   (prin1)
)

;;;**************************************************************************

;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;
;;;			     CHGCASE.LSP
;;;
;;;                      CHANGE CASE OF TEXT
;;;

(defun C:CHGCASE (/ TYP ENT ENTG TXT)
  (initget 6 "Upper Lower")
  (setq TYP (getkword "\n \nChange to Upper or Lower case <U>: "))
  (if (= TYP "Upper") (setq TYP nil))
  (while (setq ENT (car (entsel "\nSelect line of text to be changed: ")))
    (setq ENTG (entget ENT))
    (setq TXT (strcase (cdr (assoc 1 ENTG)) TYP))
    (if (= TYP "L") (setq TXT (strcat (strcase (substr TXT 1 1)) (substr TXT 2))))
    (setq ENTG (subst (cons 1 TXT) (assoc 1 ENTG) ENTG))
    (entmod ENTG)
  )
  (princ)
)

;;;**************************************************************************


;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;      		     R&C/TASK 2007       
;;;
;;;                           CIRTEXT.LSP 
;;;
;  Function to draw text in an Arc, clockwise.   The text is mono
;  spaced at a fixed portion of the text height.  
;
;
;-------------------------- CIRTEXT -----------------------------
;
(defun r2d (r) (* (/ r pi) 180.0))

(defun d2r (d) (/ (* d pi) 180.0))

(defun ASIN (a)
   (cond
       ( (= (abs a) 1.0) (* (sign a) (/ PI 2)) )
       (      T          (atan (/ a (sqrt (- 1 (* a a)))))) )
)
;-------------------------- Main Program ------------------------ -----------------------------------------------------------------
(defun C:CIRTEXT ( / CenPt StPt Ht Txt Dir
                     Num R StAng Blips Wd Ang Delta Pt Cnt Ch Slope Sign
                 )
  (setvar "cmdecho" 0)
  (graphscr)
  (setq CenPt (getpoint "\nText arc centre point: ")
        StPt (getpoint "\nMidpoint of first character: ")
  )
  (setq Ht (getdist 
           (strcat "\nText height <" (rtos (getvar "TEXTSIZE") 2 4) ">: "))
  )
  (if (null Ht) (setq Ht (getvar "TEXTSIZE")))

  (initget "CW CCW")
  (setq Dir (getkword "\nDirection of text along arc, (CW or CCW) <CW>: ")
        Sign -1
  )
  (if (= Dir "CCW") (setq Sign 1) )
  
  (setq Txt (getstring T "\nEnter text: ")
        R (distance CenPt StPt)
        StAng (angle CenPt StPt)
        Blips (getvar "blipmode")
        Wd (* Ht 0.9)
        Delta ( * 2 (asin (/ Wd (* 2 R))) ) 
        Num (strlen Txt)
  )
;;;  (setvar "blipmode" 0)
  (setq Ang StAng
        Pt StPt
        Cnt 1
        Ch (substr Txt 1 1)
        Slope (+ (r2d Ang) (* sign 90.0) )
  )
  (repeat Num
    (command "TEXT" "M" Pt Ht Slope Ch)
    (setq Cnt (1+ Cnt)
          Ch (substr Txt Cnt 1)
          Ang (+ Ang (* sign Delta) )
          Pt (polar CenPt Ang R)
          Slope (+ (r2d Ang) (* sign 90.0) )
    )
  )
;;;  (setvar "blipmode" blips)
  (princ)
)

;;;**************************************************************************


;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;
;;;
;;;			      CLEANUP.LSP
;;;		       	     
;;;
; This routine will take drawings that have been taken from scanned
; images and clear away lines shorter then a user defined length.

(defun C:Cleanup ()
        (setvar "cmdecho" 0)
        (setq mindist (getreal "\nEnter the minimum desired line length: "))
        (setq sset (ssget "x" (list (cons 0 "LINE"))))
           (if (= sset nil)(setq l 0)
             (setq l (sslength sset))
           )
        (setq index 0)
        (while (< index l)
                (setq name (ssname sset index))
                (setq ent (entget name))
                (setq p1 (cdr (assoc 10 ent)))
                (setq p2 (cdr (assoc 11 ent)))
                (setq dist (distance p1 p2))
                   (if (<= dist mindist)
                        (entdel name)
                   )
                (setq index (1+ index))
        ); ends while loop
        (command "redraw")
        (setvar "cmdecho" 1)
        (princ)
)
; Ends 

;;;**************************************************************************

;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;
;;;
;;;                           CLRMESH.LSP  

;CLRMESH will change the colors of 3dfaces depending on their elevation.
;It is very useful when changing colors in a 3D-Mesh representation
;of a land surface.
;It requires a minimum and maximum elevation and if the highest point
;of the 3DFACE falls within this range than the 3DFACES color will be
;changed.
;You may specify the new color by either the color number or the color name.
;
;Your comments and suggestions are appreciated > R&C/TASK
 (defun c:clrmesh ()
   (setq minr (getdist "\nElevation range minimum: ")
         maxr (getdist "\nElevation range maximum: ")
            w 1
   );close setq
(initget "NAme NUmber")
(setq qu (getkword "\nSpecify color by NUmber or <NAme>: "))
  (if (= qu "NUmber")
      (setq clrn (getint "\nColor NUMBER for faces within range: "))
      (while w
       (setq clr (strcase (getstring "\nColor NAME for faces within range: ")))
              (setq clrn (cond ((= clr "RED") 1)
                         ((= clr "YELLOW") 2)
                         ((= clr "GREEN") 3)
                         ((= clr "CYAN") 4)
                         ((= clr "BLUE") 5)
                         ((= clr "MAGENTA") 6)
                         ((= clr "WHITE") 7)
                         ((= clr "GREY") 8)
                         (T nil)
                   );close cond
         );close setq
        (if (= clrn nil) (progn (prompt "\nUnsupported color name...")
        (prompt "\nBlue, Cyan, Green, Grey, Magenta, Red, White, or Yellow...")
                         );close progn      
                         (setq w nil)
        );close if
     );close while/else
   );close if
(initget "Select All")
  (setq ans (getkword "\n[S]elect individual faces <All>: "))
  (if (= ans "Select")
      (setq sst (ssget))
      (setq sst (ssget "x" (list (cons 0 "3DFACE"))))
  );close if
  (setq cnt 0)
    (repeat (sslength sst)
       (setq fac (entget (ssname sst cnt)))
          (if (= (cdr (assoc 0 fac)) "3DFACE")
              (progn
                (setq c1 (cdr (assoc 10 fac))
                      c2 (cdr (assoc 11 fac))
                      c3 (cdr (assoc 12 fac))
                      c4 (cdr (assoc 13 fac))
                     mxc (max (caddr c1) (caddr c2) (caddr c3) (caddr c4))
                );close setq
                (if (and (>= mxc minr) (<= mxc maxr))
                   (if (= (assoc 62 fac) nil)
                       (entmod (setq fac (append fac (list (cons 62 clrn)))))
                       (entmod (subst (cons 62 clrn) (assoc 62 fac) fac))
                   );close if3
                );close if2
              );close progn
          );close if1
      (setq cnt (1+ cnt))
    );close repeat
);close defun

;;;**************************************************************************


;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;
;;;                           DIMARC.LSP

;;;
;   Rotina Lisp para Cotar comprimento de um arco
;                       Por Anderson (Suporte)


 (defun grad(x)
   (* pi(/ x 180.00))
   )
 (defun radg(y)
   (/(* 180.00 y)pi)
   )
 (defun dir()
   (setq ang1 (angle pe cen))
   (setq ang2 (angle pe1 cen))
   (setq ang (- ang ang2))
   (setq carc(abs(* raio ang)))                
   )
 (defun esq()
   (setq ang (- a1 a2))
   (setq carc (abs(* raio ang)))
   )
 (defun C:dimarc(/ ang1 ang2 ang carc raio cen pe pe1 a1 a2 se sp pa type)
   (setvar "cmdecho" 0)
;;;   (setvar "blipmode" 0)
   (setq se (entsel "\nSelect arc:"))
   (setq sp (car se))
   (setq pa (entget sp))
   (setq type (cdr(assoc 0 pa)))
   (if(= type "ARC")
     (progn
     (setq a1 (cdr (assoc 50 pa)))
     (setq a2 (cdr (assoc 51 pa)))
     (setq cen (cdr (assoc 10 pa)))
     (setq raio (cdr (assoc 40 pa)))
     (setq pe (polar cen (cdr (assoc 50 pa)) raio))
     (setq pe1 (polar cen (cdr (assoc 51 pa)) raio))
       (if(< a1 a2)(esq)(dir))
     (prompt "\nLocation of dimension arc:")
     (command "dim" "angular" "" cen pe pe1
               pause (rtos carc) pause "exit")
     )
     (prompt "\Unable to use the selected entity")
    )
    (setvar "clayer" "0")
    (setvar "cmdecho" 1)
;;;    (setvar "blipmode" 1)
    (princ)
  )
    

;;;**************************************************************************

;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;
;;;				PCIRS.LSP
;;;
;PCIRS and PCIRCLE- For those times when a circle just won't do. These routines
;offer an easy and fast method to replace circles with closed polylines.
;PCIRS will replace all Circles and PCIRCLE will do one at a time.
;R&C/TASK
;
;
; Primary function used to convert Circles into closed Polylines
(defun c2p ()
  (setq center (cdr (assoc 10 cirList)))  ;center of the circle
  (setq radius (cdr (assoc 40 cirList)))  ;radius of the circle
  (setq pt1 (polar center 0 radius))      ;start point for polyline
  (setq pt2 (polar center 3.14159 radius));second point for pline arc
  (setvar "cmdecho" 0)
  (entdel cir)
  (command "pline" pt1 "A" "CE" center pt2 "Close")
  (setvar "cmdecho" 1)
)

; Command to convert single circles into closed Polylines
(defun c:PCIRCLE ()
  (setq cir (car (entsel "\nSelect Circle to convert: ")))
  (setq cirList (entget cir))
  (if (= (cdr (assoc 0 cirList)) "CIRCLE")
    (c2p)
    (prompt "\nEntity selected is not a circle.")
  )
  (princ)
)

; Command to convert ALL circles into Polylines
(defun c:PCIRS ()
  (setq cirs (ssget "x" '((0 . "CIRCLE"))))
  (if cirs
    (progn
      (setq c# (sslength cirs) count 0)
      (repeat c#
        (setq cir (ssname cirs count))
        (setq cirList (entget cir))
        (c2p)
        (setq count (1+ count))
      )
    )
    (prompt "\nNo Circles found.")
  )
  (princ)
)  


;;;**************************************************************************


;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;
;;;				RCLOUD.LSP

;;;* DXF takes an integer dxf code and an entity data list.
;;;* It returns the data element of the association pair.
;;;*
(defun dxf(code elist)
  (cdr (assoc code elist))     ;Finds the association pair, strips 1st element
);defun
;;;*

;;;* C:RCLOUD modifies an exisitng polyline to produce a revision cloud.
;;;* The polyline should be drawn counterclockwise with SKETCH, with SKPOLY
;;;* set to 1. Requires DXF subroutine.
;;;*
(defun C:RCLOUD ( / head hdata bulge en ed)
  (if (and                                           ;Get head data list
        (setq en (entsel "\nSelect a polyline: "))            ;Get entity
        (= (dxf 0 (setq hdata (entget (car en)))) "POLYLINE") ;Is it polyline
      );and
      (progn                                         ;OK, proceed
        (entmod (subst '(70 . 1) '(70 . 0) hdata))   ;If open pline, close it
        (setq bulge (list (cons 42 0.5)))      ;Make bulge association list
        (setq en (dxf -1 hdata))               ;Get first subentity - vertex
        (while (and (setq en (entnext en))     ;Loop through each vertex
                    (setq ed (entget en))      ;Get vertex data
                    (/= "SEQEND" (dxf 0 ed))   ;If SEQEND, we're done
               );and
               (setq ed (append ed bulge))     ;Add bulge association list
               (entmod ed)                     ;Modify the subentity
        );while
        (entupd en)                            ;Update the entire polyline
  ) );if&progn
  (princ)
);defun
(princ)


;;;**************************************************************************

;;;                             CLOUD.lsp
;;;                         Release 98-2004                 
;;;                         R&C/TASK 2007       

(defun savar (savelist)    ;Function takes one arg
   (mapcar                 ;Mapcar rtns list as result of funct list1...listN
       '(lambda (sysvar)   ;Quote lambda to make anonymous funct w/1 arg
           (list sysvar (getvar sysvar))  ;Get the arg and make it a list
        )                  ;End anonymous funct
       savelist)           ;This is mapcars list that the funct operates on
);end defun savar

;                  The function (resvar) required for the restore function.

(defun resvar (savelist)   ;Function takes one arg.
   (mapcar                 ;Mapcar rtns list as result of funct list1...listN
      '(lambda (sysvar)    ;Quote lambda to make anonymous funct w/1 arg

;|   reset the variable in the list with the orig value by returning
     everything but the first element i the list (cadr), and the first
     element in the list (car).  So the line will read (setvar "blipmode" 0)
|;
         (setvar (car sysvar) (cadr sysvar))

         (car sysvar)       ;Return first element of list
      )                     ;End anonymous funct

   savelist)                ;This is mapcars list that the funct operates on

);end defun resvar

; Daves orig error trap, replaced by me....
;(defun MYERROR (MSG) 
;  (if (/= MSG "console break") 
;    (if (= MSG "quit / exit abort") 
;      (princ (strcat "\nError: " MSG))) 
;    (prompt "\nProgram aborted")))
 
(defun c:CLOUD (/ LPT SPT NPT ILE OMD CLO AST)
;                   Make a list of system variables to restore

(setq syslist '( "menuecho" "orthomode" "cmdecho" "blipmode" ))

;                   Execute the save

(setq syslist (savar syslist))

;|                    Define the error while program is running
                      See page 163 Kramers Programming for productivity
                      Define the error function so that the AutoCAD
                      system variables are returned to normal.
|;

(if olderr                   ;Keep the orig error handler
    (setq olderr *error*)
)                            :End if

(defun *ERROR* (errstr)      ;Define *ERROR*
    (if (/= errstr "Function cancelled")
        (if (= errstr "bad argument type")
          (princ)
          (princ (strcat "\nError: " errstr))
        )          ;End second if
        (print "Hey, You Control C'd out of the program...Lets fixit! ")
    )              ;End first if
    (setq syslist (resvar syslist))
    (print errstr)
    (setq *error* olderr)
)                  ;End error defun

;                   Change all the variables you want.

(setvar "menuecho"  0)
(setvar "orthomode" 0)
(setvar "cmdecho"   0)
;;;(setvar "blipmode"  0)
; temp end revision
  (if OAST 
    (setq AST OAST TAST (rtos AST))
    (setq TAST "" AST 0.0)) 
  (initget 6) 
  (setq OMD (getvar "CMDECHO") 
        AST (getdist (strcat "\nLength of cloud bulge <" TAST ">: ")))
  (initget 1)
  (setq LPT (getpoint "\nPick cloud start point: ") 
        SPT LPT ILE 110 )
  (if (= AST nil) 
    (setq AST OAST)
    (setq OAST AST)) 
  (prompt "\nGuide cursor along cloud path...") 
  (command "pline" LPT "w" "0" "0" "a" "a" ILE LPT "a" ILE) 
  (setq NPT (cadr (setq PTP (grread 1 20 1))))
  (while LPT 
    (if (> (distance LPT NPT) AST) 
      (progn
        (command NPT "a" ILE) 
        (setq LPT NPT)) 
      (progn
        (command NPT "u" "a" ILE))) 
    (if (= (car PTP) 3) 
      (progn
        (command NPT "a" ILE) 
        (setq LPT NPT))) 
    (if (> (distance LPT NPT) (distance SPT NPT)) 
      (progn
        (command SPT "cl") 
        (setq LPT nil CLO 1))) 
    (setq NPT (cadr (setq PTP (grread 1 20 1))))
    (if (= (type NPT) 'INT) 
      (setq LPT nil))) 
  (princ "\nEnding cloud...") 
  (if (/= CLO 1) 
    (command (cadr (grread 1 20 1)) "")) 
  (setvar "cmdecho" OMD)

;             Execute the restore function

(setq syslist (resvar syslist))
(princ)       ;End you program quietly
);end defun cloud

;;;**************************************************************************

;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2004       
;;;
;;;			      SYMLIN.LSP

; Symlin generates line and insert blocks on it.


;*---------------- this is executed at load
(vmon)
(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) pi))
(defun c:symlin (/ ll ticker j count numxs linang d firstx rotang k brkf brk1 brk2 e1 opnt)
    (graphscr)
    (setvar "cmdecho" 0)

; IF NOT USED SINCE LOADED, DO THIS IS "if" FOR INITIALIZATION
    (if (= initvar nil)
      (progn
        (setq blknm nil)
        (setq blksz nil)
        (setq blksp nil)
        (setq brkvar "ON")
        (prompt "\n\"SYMLINE.LSP\",\(version 1.0\)\; by Duane Witherwax")
        (terpri)
        (setq h 1)
        (while h
          (prompt "Block name <>: ")
          (initget 1)
          (setq blknm (strcase (getstring)))
          (if (= blknm "")
            (progn
              (prompt "You must respond with name of block!") (terpri)
            )
          )
          (setq tbdata (tblsearch "BLOCK" blknm))
          (if (= tbdata nil) (setq tbdata (findfile (strcat blknm ".DWG"))))
          (if (/= tbdata nil) (setq h nil)
            (progn
              (prompt "\nBlock ")
              (prompt blknm)
              (prompt " does not exist.") (terpri)
              (prompt "Please try again.") (terpri)
              (setq blknm nil)
              (terpri)
            );End progn
          );End if
        )
        
        (prompt "Enter size for symbols <>: ")
        (initget 1)
        (setq blksz (getreal)) (terpri)
        
        (prompt "Enter spacing for symbols <>: ")
        (initget 1)
        (setq blksp (getreal)) (terpri)
        
        (setq op " <")
        (setq cl ">: ")
        (setq brkvarsav brkvar)
        (setq brkvardef (strcat op brkvar cl))
        (prompt "Break Line ON/OFF") (prompt brkvardef)
        (initget "ON OFF")
        (setq brkvar (getstring)) (terpri)
        (if (= brkvar "") (setq brkvar brkvarsav))
        
      )
    )

; HERE IS ACTUAL START OF WORK
; LOOP UNTIL WE GET A FIRSTPOINT
    (setq j 1)
    (while j
      (setq firstptsav firstpt)
      (initget "P B")
      (setq firstpt (getpoint "Properties/Block_last/<From point>: "))
        (terpri)
      
      (if (/= firstpt nil) (setq j nil))
      
      (if (= firstpt nil)
        (progn
          (setq firstpt endpt)
          (setq j nil)
        );End progn
      );End if
      
      (if (= firstpt "P")
        (progn
          (setq op " <")
          (setq cl ">: ")
          (setq blknmsav blknm)
          (setq blknmdef (strcat op blknm cl))
          (setq h 1)
          (while h
            (prompt "Block name") (prompt blknmdef)
            (initget " ")
            (setq blknm (strcase (getstring)))
            (if (= blknm "")
              (progn
                (setq blknm blknmsav)
                (setq h nil)
              )
            )
            (setq tbdata (tblsearch "BLOCK" blknm))
           (if (= tbdata nil) (setq tbdata (findfile (strcat blknm ".DWG"))))
            (if (/= tbdata nil) (setq h nil)
              (progn
                (prompt "\nBlock ")
                (prompt blknm)
                (prompt " does not exist!") (terpri)
                (prompt "Please try again.") (terpri)
                (setq blknm blknmsav)
                (terpri)
              );End progn
            );End if
          )
          
          (setq blkszsav blksz)
          (setq blksztmp (rtos blksz))
          (setq blkszdef (strcat op blksztmp cl))
          (prompt "Enter size for symbols") (prompt blkszdef)
          (initget " ")
          (setq blksz (getreal)) (terpri)
          (if (= blksz nil) (setq blksz blkszsav))
          
          (setq blkspsav blksp)
          (setq blksptmp (rtos blksp))
          (setq blkspdef (strcat op blksptmp cl))
          (prompt "Enter spacing for symbols") (prompt blkspdef)
          (initget " ")
          (setq blksp (getreal)) (terpri)
          (if (= blksp nil) (setq blksp blkspsav))
          
          (setq op " <")
          (setq cl ">: ")
          (setq brkvarsav brkvar)
          (setq brkvardef (strcat op brkvar cl))
          (prompt "Break Line ON/OFF") (prompt brkvardef)
          (initget "ON OFF")
          (setq brkvar (getstring)) (terpri)
          (if (= brkvar "") (setq brkvar brkvarsav))
          
          (setq j 1)
        );End progn
      );End if
      
      (if (= firstpt "B")
        (progn
          (setq firstpt firstptsav)
          (setq bfl 1)
          (setq j nil)
        );End progn
      );End if
    );End while

; LOOP FOR DRAWING SYMLINE
; LOOPS UNTIL ENDPOINT IS "Close" OR "NIL"
    (setq m 1)
    (setq strtpt firstpt)
    (if (/= bfl 1) (setq blklist nil) (setq m nil))
    (while m
;     (if (= bfl 1) (setq m nil)); Checks for last option. Skips below.
      (initget "C")
      (setq endpt (getpoint strtpt "To point: ")) (terpri)
      
      (if (= endpt nil)
        (progn
          (setq endpt strtpt)
          (setq m nil)
        );End progn
      );End if
      
      (if (= endpt "C")
        (progn
          (setq endpt firstpt)
          (setq m nil)
        );End progn
      );End if
      
      (if (/= endpt strtpt)
        (progn
          (setq ll (distance strtpt endpt))
          (setvar "highlight" 0)
          
          (setq ticker 0)
          (setq j 1)
          (setq count 0)
          (while j
            (setq ticker (+ ticker blksp))
            (setq count (+ count 1))
            (if (> ticker ll) (setq j nil))
          );End while j
          (setq numxs count)
          (setq linang (angle strtpt endpt))
          (setq d (/ (- ll (* (- numxs 1) blksp)) 2))
          (if (< d blksp)
            (progn
              (setq numxs (- numxs 1))
              (setq d (/ (- ll (* (- numxs 1) blksp)) 2))
            );End progn
          );End if
          
          (setq firstx (polar strtpt linang d))
          (setq rotang (rtd linang))
          
          (if (<= numxs 0)
            (progn
              (command "LINE" strtpt endpt "")
              (if (= blklist nil)
                (progn
                  (setq e1 (entlast))
                  (setq blklist (list e1))
                );End progn Then
                (progn
                  (setq e1 (entlast))
                  (setq blklist (append blklist (list e1)))
                );End progn Else
              );End if
            );End progn then
            (progn
              (command "LINE" strtpt endpt "")
              (setq k 0)
              (if (= blklist nil)
                (progn
                  (setq e1 (entlast))
                  (setq blklist (list e1))
                );End progn Then
                (progn
                  (setq e1 (entlast))
                  (setq blklist (append blklist (list e1)))
                );End progn Else
              );End if
              (setq brkf firstx)
              (while (< k numxs)
                (progn
                   (command "INSERT" blknm brkf blksz blksz rotang)
                   (setq e2 (entlast))
                   (setq blklist (append blklist (list e2)))
                   (setq brk1 (polar brkf (dtr (- rotang 180)) (/ blksz 2)))
                   (setq brk2 (polar brkf (dtr rotang) (/ blksz 2)))
                   (if (or (= brkvar "ON") (= brkvar "on"))
                     (progn
                       (command "BREAK" e1 brk1 brk2)
                       (setq e1 (entlast))
                       (setq blklist (append blklist (list e1)))
                     );End progn
                   );End if
                   (setq k (+ k 1))
                   (setq brkf (polar brkf (dtr rotang) blksp))
                );End progn
              );End while
            );End progn else
          );End if
          (setq strtpt endpt)
        );End progn
      );End if
    );End while m

; ROUTINE THAT BLOCKS WHOLE OF LAST USE
    (setq op " <")
    (setq cl ">: ")
    (setq blkyn "NO")
    (setq blkynsav blkyn)
    (setq blkyndef (strcat op blkyn cl))
    (prompt "Create block? \(Yes/No\)") (prompt blkyndef)
    (initget "YES NO yes no Y N y n")
    (setq blkyn (getstring)) (terpri)
    (if (= blkyn "") (setq blkyn blkynsav))

    (if (or (= blkyn "Y") (= blkyn "y") (= blkyn "YES") (= blkyn "yes"))
      (progn
        (setvar "highlight" 0)
        (setq j 1)
        (while j
          (setq newblknm (strcase (getstring "\nBlock name: ")))
          (setq tbdata (tblsearch "BLOCK" newblknm))
          (if (= tbdata nil) (setq j nil)
            (progn
              (prompt "\nBlock ")
              (prompt newblknm)
              (prompt " already exists.") (terpri)
              (prompt "Please try again.") (terpri)
            );End progn
          );End if
        )
        (prompt "\nCreating block ") (prompt newblknm) (prompt " ...")
        (terpri)
        (command "BLOCK" newblknm firstpt)
        (foreach item blklist (command item))
        (command "")
        (command "INSERT" newblknm firstpt 1 1 0)
        (setq blklist nil)
      )
    )
    (setq bfl nil); Sets Break For Last to nil.
    (setq initvar 1); Sets use as having been initialized.
    (setvar "highlight" 1)
    (setvar "cmdecho" 1)
);Close defun


;;;**************************************************************************
;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;
;;;                          TXTPATH.LSP

;Txtpath.LSP: Draws text on a curved polyline path. You must
;             create the polyline before you use this macro.
;**************************************************************************

(defun c:txtpath (/ ent1 pt1 txt tleng txtlst entlst
                    loc ang loclst count ctx cht )
(Setvar "cmdecho" 0)
(if (NOT (TBLSEARCH "BLOCK" "$CHAR"))
  (command "point" (getvar "viewctr")
           "-block" "$char" (getvar "viewctr") "l" "")
)
(setq ent1 (entsel "\nPick path for text: "))
(setq pt1 (cadr ent1))
(setq txt (getstring T "\nEnter text: "))
(princ "Please wait")
(setq tleng (strlen txt))
(command "divide" pt1 "b" "$char" "" (1+ tleng))
(setq txtlst '())
(setq count tleng)
(while (> count 0)
 (setq entlst (entget (entlast)))
 (setq loc (cdr (assoc 10 entlst)))
 (setq ang (* 57.2958(cdr (assoc 50 entlst))))
 (setq loclst (append loclst (list (cons loc ang))))
 (entdel (entlast))
 (princ ".")
 (setq count (1- count))
)
(setq count 1)
(setq loclst (reverse loclst))
 (while (< count (1+ tleng))
 (setq loc (car (car loclst)))
 (setq ang (cdr (car loclst)))
 (setq loclst (cdr loclst))
 (setq ctxt (getvar "textstyle"))
 (setq cht (cdr (assoc 40 (tblsearch "style" ctxt))))
 (if (= cht 0.0)
   (command "text" "c" loc "" ang (substr txt count 1))
   (command "text" "c" loc ang (substr txt count 1))
 )
 (setq count (1+ count))
)
(PRINC)
)



;;;**************************************************************************

;;; AutoLISP File for
;;; Maximizing AutoLISP 
;;;                Version 1.00 for Release 98-2000                 
;;;                         R&C/TASK 2007       
;;;
;;;                           WEED.LSP

; Weeds out extranous verticies from a polyline




;*----- Debugging stuff, load this file by entering LD<RETURN>

;(defun c:ld() (load "weed"))

;*----- Error Routine

(defun w-error (s) (redraw) (grtext)
  (princ "\nWeed Error: ") (princ s)
  (exit)
)

;*----- Exit Routine

(defun exit()
  (if (boundp 'f) (setq f (close f)))
  (setvar "cmdecho"  cmdecho)
;;;  (setvar "blipmode" blipmode)
  (setq *error* olderr)
  (princ)
)

;*----- Extract a field from a list

(defun fld (num lst) (cdr (assoc num lst)))

;*----- Plot a temporary X

(defun blip (blpoint / s x1 y1 x2 y2 p1 p2 p3 p4)

   (setq s  (/ (getvar "viewsize") 100)      ; 1/100 of viewsize
         x1 (+ (car blpoint) s)
         y1 (- (cadr blpoint) s)
         x2 (- (car blpoint) s)
         y2 (+ (cadr blpoint) s)
         p1 (list x1 y1) p2 (list x2 y2)
         p3 (list x2 y1) p4 (list x1 y2))
   (grdraw p1 p2 -1) (grdraw p3 p4 -1)
)

;*----- Convert a line to a polyline entity

(defun line2pline(ent / dat etype epnt ss1 ss2)
  (if ent (progn
    (setq dat   (entget ent)
          etype (fld 0 dat))
    (if (= etype "LINE") (progn
      (princ "\nConverting LINE to PLINE")
      (setq epnt (fld 10 dat)
            ss1 (ssadd ent)
            ss2 (ssget "C" (getvar "EXTMIN") (getvar "EXTMAX")))
      (ssdel ent ss2)
      (command "pedit" ss1 "y" "j" ss2 "" "x")
      (ssname (ssget epnt) 0) ; return the new entity name
    )
    ;else return nil
      (progn (princ "\nNot a Line")
        nil)
    )
  );else
  (progn
    (princ "\nNothing selected")
    nil)
  )
)

;*-----  Get a polyline or line entity

(defun fetch(/ pl etyp flgs ans)
  (setq etyp nil)
  (while (not (or (= etyp "LINE") (= etyp "POLYLINE"))) (progn
    (setq ename nil)
    (setq e (car (entsel "\nSelect a PolyLine or Line: ")))
    (if e (progn
      (setq pl	   (entget e)
	    etyp   (fld 0 pl)
	    ename  e)
      (if (or (= etyp "LINE") (= etyp "POLYLINE")) (progn
	(princ (strcat "\n" etyp " selected"))
	(if (= etyp "LINE")
	  (setq e      (line2pline e)
		ename  e
		pl     (entget e))
	))
      ;else
	(progn	(princ "\nThat's not a LINE or POLYLINE, it's a ") (princ etyp))
      ); end if
    ); end progn
    ; else
      (princ "\nNothing Selected")
    ); end if
  )); end while
  (setq flgs   (fld 70 pl))
  (setq closed (=(boole 1 flgs 1) 1))
  (if closed (princ "\nClosed Polyline"))
  (cond
    ((=(boole 1 flgs 2) 2) (progn
      (setq ptyp "F")
      (princ "\nFit curve verticies have been added")))
    ((=(boole 1 flgs 4) 4) (progn
      (setq ptyp "S")
      (princ "\nSpline curve verticies have been added...")))
    (t	(setq ptyp "N"))      ;Normal polyline
  )
  (if(/= ptyp "N") (progn
    (initget "Y N")
    (if(= (getkword "\nDecurve polyline during weeding[y/N]:") "Y")
      (setq ptyp "N"))
  ))
)

;*----- Check vertex type

(defun vt_ok ()
  (if (= etype "VERTEX")
    (cond
      ((= ptyp "F") (or(=(boole 1 flags 1) 1) (= flags 0)))
      ((= ptyp "S") (>(boole 1 flags 9) 0))
      (t	    (=(boole 1 flags 25) 0)) ;"N" normal, 1 8 16 off
    )
  ;else
    t
  )
)

;*----- extract the list containing vertex coordinates

(defun get_vertex(/ vert etype sub_ent flags)
  (setq vert nil
        etype nil)
  (while (and e (null vert) (/= etype "SEQEND")) (progn
    (setq v     (entnext e)
          e     v
          etype nil)
    (if e (progn
      (setq sub_ent   (entget v)
	    flags     (fld 70 sub_ent)
            etype     (fld 0  sub_ent))
      ;(princ "flags =")(princ flags)
      (if (vt_ok)
	(if (= etype "VERTEX")
	  (setq vert_cnt (1+ vert_cnt)
		vert	 (fld 10 sub_ent))
	; else return
	  nil
	)
      )
    ))
  ))
)

;*----- Add a vertex to the temporary file for the new pline

(defun add_vert(vt)
  (if (null f) (setq f (open "weedtmp.$$$" "w")))
  (prin1 vt f)
  (princ "\n" f)
)

;*----- Read a vertex from the temporary file for the new pline

(defun read_vert(/ pt)
   (setq pt (read-line f))
   (if pt (read pt) nil)
)

;*----- Read new polyline from the tempory file

(defun retrieve()
    (setq f (open "weedtmp.$$$" "r"))
    (command ".PLINE")
    (setq v (read_vert))
    (while v (progn
      (command v)
      (setq v (read_vert))
    ))
    (command "")
   ;(command "del" "weedtmp.$$$")
)

;*----- Check the internal angle and leg lengths then add or delete

(defun check_it(/ ang dist1 dist2 dist offset off)
  (setq ang12  (abs(angle v1 v2))
	ang13  (abs(angle v1 v3))
	ang    (abs(- ang12 ang13))
	dist1  (distance v1 v2)
	dist2  (distance v2 v3)
	dist   (max dist1 dist2)       ; largest distance
	off    (* dist1 (sin ang))
	offset (+ p_off off)
	p_off  offset
  )
  (if
    (and
      (< offset max_offset)		;offset distance criteria
      (< dist	min_dist)		;minimum leg length criteria
    )
    ;then skip middle vertex
    (progn (blip v2)			;mark the deleted vertex
       (setq v2 	v3
	     v3 	(get_vertex)
	     skip_cnt	(1+ skip_cnt))
      (princ "\nSkipping vertex # ") (princ (- vert_cnt 2))
;     (princ (strcat ", max_offset " (rtos max_offset 2 2) "
;			min_dist " (rtos min_dist 2 2)))
;     (princ (strcat ", offset " (rtos offset 2 2) " dist " (rtos dist 2 2)))
    )
  ;else add first vertex to list
    (progn
      (add_vert v2)
      (setq v1 v2
            v2 v3
	    v3 (get_vertex)
	    p_off  0)
    ); end progn
  ); end if
)

;*----- The main routine...

(defun C:WEED( / v1 v2 v3 ename v skip_cnt vert_cnt cmdecho blipmode f
		 olderr max_offset min_dist closed spline fit e_del
		 p_off vstart ptyp)

  (setq cmdecho  (getvar "cmdecho")
        blipmode (getvar "blipmode")
	olderr	 *error*
	*error*  w-error
;  *error* nil
	skip_cnt 0
	p_off	 0
	f	 nil
	vert_cnt 0
  )
  (setvar "cmdecho" 0)
;;;  (setvar "blipmode" 0)
  (initget (+ 1 2 4))
  (setq max_offset (getdist "\nEnter offset distance: "))
  (initget (+ 1 2 4))
  (setq min_dist (getdist "\nEnter leg length: "))
  (initget "Y N")
  (setq e_del (getkword "\nDelete original Polyline [Y/n]: "))
  (if (null e_del) (setq e_del "Y"))
  (fetch)
  (princ "\nChecking polyline verticies...")
  (setq v1 (get_vertex)
	vstart v1
	v2 (get_vertex)
        v3 (get_vertex))
  (add_vert v1)
  (while v3 (check_it))
  (if (< (distance v1 v2) min_dist)
    (progn (setq skip_cnt (1+ skip_cnt))
	   (princ "\nSkipping vertex # ") (princ vert_cnt))
  ;else
    (add_vert v1)
  ); end if
  (add_vert v2)
  (if closed (add_vert vstart))
  ; Delete old line and draw new Pline
  (if (> skip_cnt 0) (progn
    (close f)
    (if (= e_del "Y") (entdel ename))
    (retrieve)
    (princ (strcat "\n" (itoa skip_cnt) " verticies removed "
		   "out of " (itoa vert_cnt) " tested ("
		   (rtos(/ (* 100.0 skip_cnt) vert_cnt) 2 2)
		   ") percent"))
  )
  ;else
    (princ "\nNothing to change!")
  )
  (exit)
)


;;;**************************************************************************
; * BALLOON.LSP
; * Desenha chamada de item na escala definida pelo usuario.

(defun C:BALLOON (/ escala os lay raio tamdonut pt1 pt2 tam txt v1_txtstyle)
  (setq
    escala   (getvar "dimscale")
    os       (getvar "osmode")
    lay      (getvar "clayer")
    raio     (* 1 escala)
    tamdonut (* 0.7 escala)
    v1_txtstyle (getvar "textstyle")
    )
  (command "osnap" "none")
  (setq
    pt1 (getpoint "\nStart Point: ")
    pt2 (getpoint "\nSecond Point: " pt1)
    )
  (setq
    tam (* 3.5  escala)
    txt (getstring "\nText: ")
    )
  (if (/= txt "")
    (progn
      (if (null (tblsearch "LAYER" "ITENS"))
	(command "-LAYER" "N" "ITENS" "C" "1" "ITENS" "S" "ITENS" "")
	(command "-layer" "S" "ITENS" "")
	)
      (command "-STYLE" "Destaque" "ic-romans.shx" "" "" 0 "" "" "")
      (command "DONUT" 0 tamdonut pt1 ""
	       "LINE" pt1 pt2 ""
	       "TEXT" "M" pt2 tam 0 txt
	       )
      (command "erase" "l" "")
;;;      (if (< (strlen txt) 5)
;;;	(setq raio (* tam (+ 1 (strlen txt))))
;;;	(setq raio (* tam (strlen txt)))
;;;	)
      (setq raio (* tam (+ 1 (strlen txt))))
      (command "CIRCLE" pt2 "d" raio )
      (command "TRIM" "L" "" pt2 ""
	       "TEXT" "M" pt2 tam 0 txt
	       )
      (command "OSMODE" os
	       "CLAYER" lay
	       "-style" v1_txtstyle "" "" "" "" "" "" ""
	       )
      (princ)
      )
    (print "None text was typed... Function canceled.")
    )
  )


(defun C:BALLOON2 (/ escala os lay raio tamdonut pt1 pt2 tam txt)
  (setq
    escala   (getvar "dimscale")
    os       (getvar "osmode")
    lay      (getvar "clayer")
    raio     (* 4 escala)
    tamdonut (* 0.7 escala)
    )
  (command "osnap" "none")
  (setq
    pt1 (getpoint "\nStart Point: ")
    pt2 (getpoint "\nSecond Point: " pt1)
    )
  (setq
    tam (* 3.5  escala)
    txt (getstring "\nText: ")
    )
  (if (/= txt "")
    (progn
      (if (null (tblsearch "LAYER" "ITENS"))
	(command "-LAYER" "N" "ITENS" "C" "1" "ITENS" "S" "ITENS" "")
	(command "-layer" "S" "ITENS" "")
	)
;;;      (if (null (tblsearch "style" "Destaque"))
;;;	(command "-STYLE" "Destaque" "ic-romans.shx" "" "" 0 "" "" "")
	(command "-STYLE" "Destaque" "ic-romans.shx" "" "" 0 "" "" "")
	
      (command "DONUT" 0 tamdonut pt1 ""
	       "LINE" pt1 pt2 ""
	       "TEXT" "M" pt2 tam 0 txt
	       )
      (BOXTXT2)
      (command "erase" "p" "")
      (command "TRIM" "L" "" pt2 ""
	       "TEXT" "M" pt2 tam 0 txt
	       )
      (command "OSMODE" os
	       "CLAYER" lay	       
	       )
      (princ)
      )
    (print "None text was typed... Function canceled.")
    )
  )

;;;**************************************************************************
;			TTR.LSP
;Revision ©2007 by R&C/TASK

(defun dtr(d)
(* pi (/ d 180.0))
)

(defun appr (ppc1 ppc2 ppc3 / ppa1 ppa2)
 (setq ppa1 (+ (dtr 90)(angle ppc1 ppc2)))
  (setq ppa2 (polar ppc3 ppa1 10))
(inters ppc1 ppc2 ppc3 ppa2 nil)
)
(defun mpm (mgt0 mgt1 mgtget / mprr mgt0a1 mgt0l1)
(setq mprr (appr mgtget mgt1 mgt0))
 (setq mgt0a1 (angle mgt0 mprr))
  (setq mgt0l1 (distance mgt0 mprr))
(polar mprr mgt0a1 mgt0l1)
)
(defun c:TTR ()
(setvar "cmdecho" 0)
 (setq acsel1 (entget (car (entsel))))
  (setq acass01 (cdr (assoc 0 acsel1)))
   (setq acsel2 (entget (car (entsel))))
    (setq acass02 (cdr (assoc 0 acsel2)))
(ezacl)
(ezacac)
;(princ)
(setq xyzz baseobj)
 (setq funnn 1)
  (setq osm (getvar "osmode"))
   (setq ort (getvar "orthomode"))
    (setq clay (getvar "clayer"))
)
(defun ezacl ()
(if (or (and (or (= "ARC" acass01)
(= "CIRCLE" acass01)) 
(= "LINE" acass02)) 
(and (or (= "ARC" acass02)(= "CIRCLE" acass02))
(= "LINE" acass01)))
(progn (if (or (= "ARC" acass01)(= "CIRCLE" acass01))
(progn (setq acass101 (cdr (assoc 10 acsel1)))
(setq acass401 (cdr (assoc 40 acsel1)))
)		
(progn (setq acass1011 (cdr (assoc 10 acsel1)))
(setq acass111 (cdr (assoc 11 acsel1)))
))
(if (or (= "ARC" acass02)(= "CIRCLE" acass02))
(progn (setq acass101 (cdr (assoc 10 acsel2)))
(setq acass401 (cdr (assoc 40 acsel2)))
)		
(progn (setq acass1011 (cdr (assoc 10 acsel2)))
(setq acass111 (cdr(assoc 11 acsel2)))
))
(initget (+ 1 4 8))
(setq acradi (getreal "\nEnter the radius: "))
 (setq acppr (appr acass1011 acass111 acass101))
(if (equal acppr acass101 0.0001)
(setq acang (+ (dtr 90.0)
(angle acass101 acass111)))
(setq acang (angle acass101 acppr))
)
(setq acwh 1)
 (setq expno 0)
(while acwh (cond ((= acwh 1)
(setq acpprR (+ acass401 acradi))
 (setq acpprd (- (distance acass101 acppr) acradi))
(princ acwh)) ((= acwh 2)
(setq acpprR (- acradi acass401))
 (setq acpprd (- (distance acass101 acppr) acradi))
(princ acwh)) ((= acwh 3)
(setq acpprR acradi)
 (setq acpprd (- (distance acass101 acppr) acradi))
(princ acwh)) ((= acwh 4)
(setq acpprR (+ acass401 acradi))
 (setq acpprd (+ (distance acass101 acppr) acradi))
(princ acwh)) ((= acwh 5)
(setq acpprR (- acradi acass401))
 (setq acpprd (+ (distance acass101 acppr) acradi))
(princ acwh))
)
(if (minusp (- (expt acpprr 2.0)(expt acpprd 2.0)))
(progn (setq acwh (+ acwh 1))
(if (= acwh 6)
 (setq acwh 0))
(if (and (= expno 0)(= acwh 0))
(progn (setq acwh nil)
(getpoint)
))
(progn (setq expno 1)
(setq acx1 (expt (- (expt acpprr 2.0)(expt acpprd 2.0)) 0.5))
 (setq acx2 acpprd)
  (setq expcen (polar (polar acass101 acang acx2) (+ acang (dtr 90.0)) acx1))
   (setq mexpcen (mpm expcen acass101 (polar acppr acang 1.0)))
(command "_color" 1)
(command "_circle" expcen acradi)
(setq ladel
(entlast))
(command "_color" "bylayer")
(if (= "Y" (setq gider (strcase(getstring "\nPress Enter (to Next) or Y (to accept): "))))
(progn (entdel ladel)
(command "_circle" expcen acradi)
(setq acwh nil)
)
(progn (setq acwh (+ acwh 1))
(if (= acwh 6)
(setq acwh 1)
)
(entdel ladel)
(command "_color" 1)
(command "_circle" mexpcen acradi)
(setq ladel (entlast))
(command "_color" "bylayer"
)))
(if (and (/= "Y" gider)(= "Y" (strcase (getstring "\nPress Enter (to Next) or Y (to accept): "))))
(progn (entdel ladel)
(command "_circle" mexpcen acradi)
(setq acwh nil)))
(if (/= acwh nil)
(entdel ladel)
)))))))
(defun ezacac ()
(if (and (or (= "ARC" acass01)(= "CIRCLE" acass01)) (or (= "ARC" acass02)(= "CIRCLE" acass02)))
(progn (setq acass101 (cdr (assoc 10 acsel1)))
(setq acass401 (cdr (assoc 40 acsel1)))
 (setq acass102 (cdr (assoc 10 acsel2)))
  (setq acass402 (cdr (assoc 40 acsel2)))
(initget (+ 1 4 8))
(setq acradi (getreal "\nEnter the radius: "))
 (setq acdist (distance acass101 acass102))
  (setq acang (angle acass101 acass102))
   (setq acwh 1)
    (setq expno 0)
(while acwh (cond ((= acwh 1)
(setq acdpl1 acradi)
 (setq acdpl2 acradi)
(princ acwh)) ((= acwh 2)
(setq acdpl1 (+ acradi acass401))
 (setq acdpl2 (+ acradi acass402))
(princ acwh)) ((= acwh 3)
(setq acdpl1 acradi)
 (setq acdpl2 (- acradi acass402))
(princ acwh)) ((= acwh 4)
(setq acdpl1 (- acradi acass401))
 (setq acdpl2 acradi)
(princ acwh)) ((= acwh 5)
(setq acdpl1 (- acradi acass401))
 (setq acdpl2 (+ acradi acass402))
(princ acwh)) ((= acwh 6)
(setq acdpl1 (+ acass401 acradi))
 (setq acdpl2 (- acradi acass402))
(princ acwh)) ((= acwh 7)
(setq acdpl1 (- acradi acass401))
 (setq acdpl2 (- acradi acass402))
(princ acwh)))
(setq expac1 (expt acdpl1 2.0))
 (setq expac2 (expt acdpl2 2.0))
  (setq expacd (expt acdist 2.0))
   (setq acx1 (/ (+ (- expac1 expac2) expacd)(* 2.0 acdist)))
(if (minusp (- expac1 (expt acx1 2.0)))
(progn (setq acwh (+ acwh 1))
(if (= acwh 8)
(setq acwh 0))
(if (and (= expno 0)(= acwh 0))
(progn (setq acwh nil)
(getpoint))))
(progn (setq expno 1)
(setq acx2 (expt (- expac1 (expt acx1 2.0)) 0.5))
 (setq expcen (polar (polar acass101 acang acx1) (+ acang (dtr 90.0)) acx2))
  (setq mexpcen (mpm expcen acass101 acass102))
(command "_color" 1)
(command "_circle" expcen acradi)
(setq ladel
(entlast))
(command "_color" "bylayer"
)
(if (= "Y" (setq gider (strcase (getstring "\nPress (Enter) to Next or (Y) to accept:"))))
(progn (entdel ladel)
(command "_circle" expcen acradi)
(setq acwh nil)
)
(progn (setq acwh (+ acwh 1))
(if (= acwh 8)
(setq acwh 1))
(entdel ladel)
(command "_color" 1)
(command "_circle" mexpcen acradi)
(setq ladel
(entlast))
(command "_color" "bylayer")))
(if (and (/= "Y" gider)(= "Y" (strcase (getstring "\nPress (Enter) to Next or (Y) to accept: "))))
(progn (entdel ladel)
(command "_circle" mexpcen acradi)
(setq acwh nil)))
(if (/= acwh nil)
(entdel ladel)))))))
(princ)
)
(princ)
)




;;;**************************************************************************
;                                 DLINE.lsp 

;Revision ©2007 by R&C/TASK


(defun c:dbl () (dbl))

; Main

(defun dbl      (/ strtpt nextpt pt1    pt2    spts   wnames elast
                 uctr   pr     prnum  temp   ans    dir    ipt
                 v      lst    dist   cpt    rad    orad   ftmp
                 spt    ept    pt     en1    en2    npt    cpt1
                 flg    cont   flg2   flgn   ang    tmp    undo_setting
                 brk_e1 brk_e2 bent1  bent2  nn     nnn    
                 pr_dl_osm pr_dl_oem pr_dl_oce pr_dl_opb pr_dl_obm pr_dl_ver 
                 pr_dl_err pr_dl_oer pr_dl_arc fang   MAXSNP ange   
                 savpt1 savpt2 savpt3 savpt4 savpts 
              )

  ;; Version
  (setq pr_dl_ver "IntellVCAD by R&C/TASK")  
  
  (setq MAXSNP 10)              

  (setq pr_dl_osm (getvar "osmode")
        pr_dl_oce (getvar "cmdecho")
        pr_dl_opb (getvar "pickbox")
  )

 

  (defun pr_dl_err (s)                   
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
;;    (command "_.UNDO" "_END")
    (if pr_dl_oer                        
      (setq *error* pr_dl_oer)           
    )
    (if pr_dl_osm (setvar "osmode" pr_dl_osm))
    (if pr_dl_opb (setvar "pickbox" pr_dl_opb))
    
    
    (if pr_dl_oce (setvar "cmdecho" pr_dl_oce))      
    (princ)
  )
  
  

  (setvar "cmdecho" 0)
;;  (command "_.UNDO" "_GROUP")
  (setvar "osmode" 0)
  (if (null pr:opb) (setq pr:opb (getvar "pickbox")))

  
  (setq nextpt "Straight")
 

  (graphscr)

  (setq cont T)
  (while cont
    (pr_dl_m1)

    (pr_dl_m2)
  )
  
  (if pr_dl_osm (setvar "osmode" pr_dl_osm))
  (if pr_dl_opb (setvar "pickbox" pr_dl_opb))




  (if pr_dl_oce (setvar "cmdecho" pr_dl_oce))      

  (princ)
)

(defun pr_dl_val (v temp)
  (cdr(assoc v (entget temp)))
)

(defun pr_dl_lsu (lst v / m)
  (setq m 0 temp '())
  (repeat (- (length lst) v)
    (progn
      (setq temp (append temp (list (nth m lst))))
      (setq m (1+ m))
  ) )
  temp
)
(defun pr_dl_cls ()
  (if (or (and (null pr_dl_arc) (< uctr 4)
               (if (> uctr 1)
                 (/= (pr_dl_val 0 (entlast)) "ARC")
                 (not (> uctr 1))
               )
          )
          (and pr_dl_arc (< uctr 2)))
    (progn 
      (princ "\nImpossible to close -- insuficient segment ")
      (if pr_dl_arc
        (setq nextpt "ARc")
        (setq nextpt "LIne")
      )
    )
    (progn
;;      (command "_.UNDO" "_GROUP")
      (setq nextpt (nth 0 spts))
      (if (null pr_dl_arc)
        ;; Close with line segments
        (pr_dl_mlf 3)
        (progn
          (setq tmp (last wnames)
                ange (trans '(1 0 0) (pr_dl_val -1 tmp) 1)
                ange (angle '(0 0 0) ange)
                dir (if (= (pr_dl_val 0 tmp) "LINE")
                      (angle (trans (pr_dl_val 10 tmp) 0 1) 
                             (trans (pr_dl_val 11 tmp) 0 1))
                      (progn
                        (setq dir (+ (pr_dl_val 50 tmp) ange)
                              dir (if (> dir (* 2 pi))
                                    (- dir (* 2 pi))
                                    dir
                                  )
                        )
                        (if (equal dir
                                   (setq dir (angle (trans (pr_dl_val 10 tmp) 
                                                           (pr_dl_val -1 tmp) 
                                                           1)
                                                    strtpt
                                             ) 
                                   )
                                   0.01)
                          (- dir (/ pi 2))
                          (+ dir (/ pi 2))
                        )
                      )
                    )
          )
          (command "_.ARC" 
                   strtpt 
                   "_E" 
                   nextpt 
                   "_D"
                   (* dir (/ 180 pi))
          )
          (pr_dl_mlf 4)
        )
      )
      (setq nextpt "Close"
            v:stpt nil
            cont   nil
      )
    )
  )
)
(defun pr_dl_m2 (/ temp)
  (setq spts (list strtpt)
        uctr 0 
  )
  (if pr:snp
    (pr_dl_ved "brk_e1" strtpt)
  )
  (setq temp (/ (getvar "tracewid") 2.0))
  (if (< pr:osd (- temp))
    (setq pr:osd (- temp))
  )
  (if (> pr:osd temp)
    (setq pr:osd temp)
  )
    
  (while (and nextpt (/= nextpt "Close"))
    (if (/= nextpt "Close")
      (if pr_dl_arc 
        (progn
          (initget 
            "Break Extreme CEnter Close Displacement End Line Snap Undo Width")
          (setq nextpt (getpoint strtpt (strcat
            "\nBreak/Extreme/CEnter/Close/Displacement/End/"
            "Line/Snap/Undo/Width/<Next point>: "))
          )
        )
        (progn
          (initget "ARc Break Extreme Close Displacement Snap Undo Width")
          (setq nextpt (getpoint strtpt
            "\nARc/Break/Extreme/Close/Displacement/Snap/Undo/Width/<Next point>: ")
          )
        )
      )
    )
    (setq v:stpt (last spts))
    (cond
      ((= nextpt "Displacement")
        (pr_dl_sao)
      )
      ((= nextpt "Width")
        (pr_dl_snw)
        
      )
      ((= nextpt "Undo")
        (cond
          ((= uctr 0) (setq nextpt nil) )
          ((> uctr 0) 
            (command "_.U")
            (setq spts   (pr_dl_lsu spts 1))
            (setq savpts (pr_dl_lsu savpts 2))
            (setq wnames (pr_dl_lsu wnames 2))
            (setq uctr (- uctr 2))
            (setq strtpt (last spts))
          )
        ) 
        (if pr:snp
          (if (= uctr 0)
            (pr_dl_ved "brk_e1" strtpt)
          ) 
        ) 
      )
      ((= nextpt "Break ")
        (initget "ON OFF")
        (setq pr:brk (getkword 
          "\nIt Breaks the Dline at beginning and at the end?  OFF/<ON>: "))
        (setq pr:brk (if (= pr:brk "OFF") nil T))    
   
        (if pr:snp
          (pr_dl_ved "brk_e1" strtpt)
        )
        (if pr_dl_arc
          (setq nextpt "ARc")
          (setq nextpt "Line")
        )
      )
      ((= nextpt "Snap")
        (pr_dl_sso)
      )
      ((= nextpt "ARc")
        (setq pr_dl_arc T)               
      )
      ((= nextpt "Line")
        (setq pr_dl_arc nil)             
      )
      ((= nextpt "Close")
        (pr_dl_cls)
      )
      ((= (type nextpt) 'LIST)
        (pr_dl_ds)
      )
      ((= nextpt "CEnter")
        (pr_dl_ceo)
      )
      ((= nextpt "End")
        (pr_dl_epo)
      )
      ((= nextpt "Extreme")
        (endcap)                      
      )
      (T
        (setq nextpt nil cont nil)
        (if (> uctr 1)
          (if (= (logand 4 pr:ecp) 4)
            (progn
              (if (null brk_e1) (command "_.LINE" savpt1 savpt2 ""))
              (pr_dl_ssp)
              (if (null brk_e2) (command "_.LINE" savpt3 savpt4 ""))
            )
            (progn
              (if (= (logand 1 pr:ecp) 1)
                (command "_.LINE" savpt1 savpt2 "")
              )
              (if (= (logand 2 pr:ecp) 2)
                (progn
                  (pr_dl_ssp)
                  (command "_.LINE" savpt3 savpt4 "")
                )
              )
            )
          )
        )
        (if brk_e1 (setq brk_e1 nil))
        (if brk_e2 (setq brk_e2 nil))
 ;;       (command "_.UNDO" "_end")
      )                               
    )                                
  )                                  
)
(defun pr_dl_ds ()
  (if (equal strtpt nextpt 0.0001)
    (progn
      (princ "\nCoincident point -- please try again. ")
      (if pr_dl_arc
        (setq nextpt "ARc")
        (setq nextpt "Line")
      )
    )
    (progn
;;      (command "_.UNDO" "_GROUP")
      (setq nextpt (list (car nextpt) (cadr nextpt) (caddr strtpt)))
      (if pr_dl_arc
        (progn
          (command "_.ARC" strtpt nextpt)
          (prompt "\nEnd: ")
          (command pause)
          (setq nextpt (getvar "lastpoint")
                v:stpt nextpt)
          (setq temp (entlast))
          (entdel temp)
          (if pr:snp
            (pr_dl_ved "brk_e2" nextpt)
          )
          (entdel temp)
          (pr_dl_mlf 2)
        )
        (progn
          (setq v:stpt nextpt)
          (if pr:snp
            (pr_dl_ved "brk_e2" nextpt)
          )
          (if (and brk_e1 (eq brk_e1 brk_e2) (= (pr_dl_val 0 brk_e1) "LINE"))
            (progn
              (princ "\nIl second point cannot be on the same line interval. ")
              (setq brk_e2 nil)
            )
            (pr_dl_mlf 1)
          )
        )
      )
      (if brk_e2 (setq nextpt "Quit"))
    )
  )
)
(defun pr_dl_ceo ()
;;  (command "_.UNDO" "_GROUP")
  (setq temp T)
  (while temp
    (initget 1)
    (setq cpt (getpoint strtpt "\nCerter point: "))
    (if (<= (distance cpt strtpt) (- (/ (getvar "tracewid") 2.0) pr:osd))
      (progn
        (princ 
        "\nIl defined radius from central point is too small ")
        (princ "\nfor the defined Width.  ")
        (princ "Please select another point.")
      )
      (setq temp nil)
    )
  )
  (command "_.ARC" strtpt "_C" cpt)
  (initget "Angle Length End")
  (setq nextpt (getkword "\nAngle/Length of chord/<Fine>: "))
  (cond 
    ((= nextpt "Angle")
      (prompt "\nIncluded angle: ")
      (command "_A" pause)
      (setq nextpt (pr_dl_vnp)
            v:stpt nextpt
      )
      (pr_dl_mlf 2) 
    )
    ((= nextpt "Length")
      (prompt "\nLength of chord: ")
      (command "_L" pause)
      (setq nextpt (pr_dl_vnp)
            v:stpt nextpt
      )
      (pr_dl_mlf 2) 
    )
    (T
      (prompt "\nEnd: ")
      (command pause)
      (setq nextpt (pr_dl_vnp)
            v:stpt nextpt
      )
      (pr_dl_mlf 2) 
    )
  )
)
(defun pr_dl_epo ()
;;  (command "_.UNDO" "_GROUP")
  (initget 1)
  (setq cpt (getpoint "\nEnd: "))
  (command "_.ARC" strtpt "_E" cpt)
  (initget "Angle Direction Radius CEnter")
  (setq nextpt (getkword "\nAngle/Direction/Radius/<CEnter>: "))
  (cond 
    ((= nextpt "Angle")
      (prompt "\nIncluded angle: ")
      (command "_A" pause)
      (setq nextpt (pr_dl_vnp)
            v:stpt nextpt
      )
      (pr_dl_mlf 2) 
    )
    ((= nextpt "Direction")
      (prompt "\nTangent Direction: ")
      (command "_D" pause)
      (setq nextpt (pr_dl_vnp)
            v:stpt nextpt
      )
      (pr_dl_mlf 2) 
    )          
    ((= nextpt "Radius")
      (setq temp T)
      (while temp
        (initget 1)
        (setq rad (getdist cpt "\nRadius: "))
        
        (if (or (<= rad (/ (getvar "tracewid") 2.0))
                (< rad (/ (distance strtpt cpt) 2.0)))
          (progn
            (princ "\nIl Insert the radius is smaller of 1/2 ")
            (princ "of the Width of the Dline or it is not valid")
            (princ "\nfor the last point selected.")
            (princ "to insert a greater radius of ")
            (if (< (/ (getvar "tracewid") 2.0) 
                   (/ (distance strtpt cpt) 2.0))
              (princ (rtos (/ (distance strtpt cpt) 2.0)))
              (princ (rtos (/ (getvar "tracewid") 2.0)))
            )
            (princ ". ")
          )
          (setq temp nil)
        )
      )
      (command "_R" rad)
      (setq nextpt (pr_dl_vnp)
            v:stpt nextpt
      )
      (pr_dl_mlf 2) 
    )
    (T
      (prompt "\nCEnter: ")
      (command pause)
      (setq nextpt (pr_dl_vnp)
            v:stpt nextpt
      )
      (pr_dl_mlf 2) 
    )
  )
)


(defun pr_dl_sao (/ temp dragos)
  (initget "Left CEnter Right")
  (setq temp pr:osd)
  (setq pr:osd (getreal (strcat
    "\nDisplacement Left/CEnter/Right/<Offset of center = "
    (rtos pr:osd) ">: ")))
  (cond
    ((= pr:osd "Left")
      (setq pr:aln 1
            pr:osd (- (/ (getvar "tracewid") 2.0))
      )
    )
    ((= pr:osd "CEnter")
      (setq pr:aln 0
            pr:osd 0.0
      )
    )
    ((= pr:osd "Right")
      (setq pr:aln 2
            pr:osd (/ (getvar "tracewid") 2.0)
      )
    )
    ((= (type pr:osd) 'REAL)
      (if dragos
        (setq pr:aln nil)
        (progn
          (setq pr:aln nil)
          (if (> pr:osd (/ (getvar "tracewid") 2.0))
            (progn
              (princ "\nValue entered is out of range.  Reset to ")
              (princ (/ (getvar "tracewid") 2.0))
              (setq pr:osd (/ (getvar "tracewid") 2.0))
            )
          )
          (if (< pr:osd (- (/ (getvar "tracewid") 2.0)))
            (progn
              (princ "\nValue entered is out of range.  Reset to ")
              (princ (- (/ (getvar "tracewid") 2.0)))
              (setq pr:osd (- (/ (getvar "tracewid") 2.0)))
            )
          )
        )
      )
    )
    (T
      (setq pr:osd temp)
    )
  )
)
(defun pr_dl_snw ()
  (initget 6)
  (setvar "tracewid"
    (if (setq temp (getdist (strcat 
      "\nNew Width of the Dline <" (rtos (getvar "tracewid")) ">: ")))
      temp
      (getvar "tracewid") 
    ) 
  )
  (if pr:aln
    (cond
      ((= pr:aln 1) ; left
        (setq pr:osd (- (/ (getvar "tracewid") 2.0)))
      )
      ((= pr:aln 2) ; right
        (setq pr:osd (/ (getvar "tracewid") 2.0))
      )
      (T
        (princ)     ; center
      )
    )
  )
)

(defun pr_dl_ofs ()
  (initget 1)
  (setq strtpt (getpoint "\nOffset from: "))
  (initget 1)
  (setq nextpt (getpoint strtpt "\nOffset toward: "))
  
  (setq dist (getdist strtpt (strcat
    "\nType the distance of Offset <" (rtos (distance strtpt nextpt)) 
    ">: ")))
  (setq dist (if (or (= dist "") (null dist))
               (distance strtpt nextpt)
               (if (< dist 0)
                 (* (distance strtpt nextpt) (/ (abs dist) 100.0))
                 dist
               )
             )
  )              
  (setq strtpt (polar strtpt
                      (angle strtpt nextpt)
                      dist
               ) 
  )
  (setq temp nil)
;;  (command "_.UNDO" "_GROUP")
)

(defun pr_dl_sso ()
  (initget "ON OFF Pickbox")
  (setq ans (getkword
    "\nPickbox On/Off.  Pickbox/OFF/<ON>: "))
  (if (= ans "OFF") 
    (progn
      (setq pr:snp nil)
      (setvar "pickbox" 0) 
    )
    (if (= ans "Size") 
      (progn
        (setq pr:snp T ans 0)
        (while (or (< ans 1) (> ans MAXSNP))
          (setq ans (getint (strcat
            "\nNew Pickbox (1 - " (itoa MAXSNP) ") <" (itoa pr:opb) ">: ")))

          (if (or (= ans "") (null ans))
            (setq ans pr:opb)
          )
        )
        (setvar "pickbox" ans)
        (setq pr:opb ans)
      )
      (progn
        (setq pr:snp T)
        (setvar "pickbox" pr:opb)
      )  
    ) 
  )
  (if pr:snp
    (if (= uctr 0)
      (pr_dl_ved "brk_e1" strtpt)
    ) 
  ) 
  (if pr_dl_arc
    (setq nextpt "ARc")
    (setq nextpt "Line")
  )

)

(defun pr_dl_ved (vent pt)

  (if (set (read vent) (ssget pt))
    (progn
      (set (read vent) (ssname (eval (read vent)) 0))
      (if (and 
            (or (= (pr_dl_val 0 (eval (read vent))) "ARC")
                (= (pr_dl_val 0 (eval (read vent))) "LINE")
            )
            (equal (caddr(pr_dl_val 210 (eval (read vent))))
                   (caddr(trans '(0 0 1) 1 0)) 0.001)
          )
        (princ)
        (progn
          (princ (strcat
            "\nSelected entity is not a arc or a line, "
            "or it is not parallel with the Current UCS. "))
          (set (read vent) nil)
        )
      )
    )
  )
  (eval (read vent))
)

(defun pr_dl_vnp (/ temp cpt ang rad)

  (setq temp (entlast))
  (if (= (pr_dl_val 0 temp) "LINE")
    (setq nextpt (if (equal strtpt (pr_dl_val 10 temp) 0.001)
                   (pr_dl_val 11 temp)
                   (pr_dl_val 10 temp)
                 )
    )
    (progn
      (setq cpt  (trans (pr_dl_val 10 temp) (pr_dl_val -1 temp) 1)
            ang  (pr_dl_val 50 temp)     
            rad  (pr_dl_val 40 temp)    
      )
      (setq ange (trans '(1 0 0) (pr_dl_val -1 temp) 1)
            ange (angle '(0 0 0) ange)
            ang (+ ang ange)
      )
      (if (> ang (* 2 pi))
        (setq ang (- ang (* 2 pi)))
      )
      (setq nextpt (if (equal strtpt (polar cpt ang rad) 0.01)
                     (polar cpt (pr_dl_val 51 temp) rad)
                     (polar cpt ang rad)
                   )
      )
    )
  )
)
(defun pr_dl_mlf (flg / temp1 temp2 newang ang1 ang2 
                     ent cpt ang rad1 rad2 sent1 sent2
                     tmpt1 tmpt2 tmpt3 tmpt4)

  (if (null nextpt) (setq nextpt (pr_dl_vnp)))
  
  (if (equal nextpt (nth 0 spts) 0.01)
    (if pr_dl_arc
      (setq flg 4)
      (setq flg 3)
    )
  )
   
  (setq temp1  (+ (/ (getvar "tracewid") 2.0) pr:osd)
        temp2  (- (getvar "tracewid") temp1)
        newang (angle strtpt nextpt)
        ang1   (+ (angle strtpt nextpt) (/ pi 2))
        ang2   (- (angle strtpt nextpt) (/ pi 2))
  )
  (cond
    ((= flg 1)                        
      (pr_dl_dls nil ang1 temp1)         
      (pr_dl_dls nil ang2 temp2)         
    )
    ((or (= flg 2) (= flg 4))         
      (setq tmp (entlast)             
            ent  (entget tmp)         
            cpt  (trans (pr_dl_val 10 tmp) (pr_dl_val -1 tmp) 1) 
            ang  (pr_dl_val 50 tmp)      
      )
      (setq ange (trans '(1 0 0) (pr_dl_val -1 tmp) 1)
            ange (angle '(0 0 0) ange)
            ang (+ ang ange)
      )
      (if (> ang (* 2 pi))
        (setq ang (- ang (* 2 pi)))
      )
     
      (if (equal (angle cpt strtpt) ang 0.01)   
        (progn
          (setq strt_a T
                rad1  (+ (pr_dl_val 40 tmp) temp2) 
                rad2  (- (pr_dl_val 40 tmp) temp1) 
          )
          (setq ent (subst (cons 40 rad2) 
                           (assoc 40 ent) 
                           ent))
          (entmod ent) 
          (pr_dl_atl)                    
          (setq save_1 ent)
          (setq sent1 (pr_dl_val -1 tmp))                            
          (if (= flg 4)
            (if (> uctr 2)
              (pr_dl_das 0 rad2 50)      
            )
            (pr_dl_das nil rad2 50)      
          )
          (command "_.OFFSET" (getvar "tracewid") 
                              (list tmp '(0 0 0)) 
                              (polar cpt ang (+ 1 rad1 rad2))
                              "")
          (setq tmp (entlast)         
                ent  (entget tmp))
          (pr_dl_atl)                    
          (setq save_2 ent)
          (setq sent2 tmp) 
          (if (= flg 4)
            (if (> uctr 3)
              (progn
                (pr_dl_das 1 rad1 50)    

                (setq nextpt "Close"
                      v:stpt nil
                      cont   nil
                )
              )
            )
            (pr_dl_das nil rad1 50) 
          )

        )
        (progn                   
          (setq strt_a nil
                rad1  (+ (pr_dl_val 40 tmp) temp1) 
                rad2  (- (pr_dl_val 40 tmp) temp2) 
          )
          (setq ent (subst (cons 40 rad1) 
                           (assoc 40 ent) 
                           ent))
          (entmod ent)                             
          (pr_dl_atl)                    
          (setq save_1 ent)
          (setq sent1 (pr_dl_val -1 tmp))                            
          (if (= flg 4)
            (if (> uctr 2)
              (pr_dl_das 0 rad1 51)      
            )
            (pr_dl_das nil rad1 51)      
          )
          (command "_.OFFSET" (getvar "tracewid")    
                            (list tmp '(0 0 0)) 
                            cpt 
                            "")
          (setq tmp (entlast)         
                ent  (entget tmp))
          (pr_dl_atl)                    
          (setq save_2 ent)
          (setq sent2 tmp)
          (if (= flg 4)
            (if (> uctr 3)
              (progn
                (pr_dl_das 1 rad2 51)    

                (setq nextpt "Close"
                      v:stpt nil
                      cont   nil
                )
              )
            )
            (pr_dl_das nil rad2 51)      
          )
        )
      )

    )
    ((= flg 3)                        
      (setq nextpt (nth 0 spts)
            ang1   (+ (angle strtpt nextpt) (/ pi 2))
            ang2   (- (angle strtpt nextpt) (/ pi 2))
      )
      (pr_dl_dls 0 ang1 temp1)
      (pr_dl_dls 1 ang2 temp2)

      (setq nextpt "Close"
            v:stpt nil
            cont   nil
      )
    )
    (T
      (princ "\nERROR:  Value out of range. ")
      (exit)
    )
  )
  (setq strtpt nextpt   
        spts   (append spts (list strtpt))
        savpts (append savpts (list savpt3))
        savpts (append savpts (list savpt4))
  )
;;  (command "_.UNDO" "_E")                
)
(defun pr_dl_dls (flgn ang temp / j k pt1 pt2 tmp1 ent1 p1 p2)

  (mapcar                             
    '(lambda (j k)
       (set j (polar (eval k) ang temp))
     )      
     '(pt1 pt2)
     '(strtpt nextpt)
  )
  (cond
    ((= uctr 0)
      (setq p1 (if (pr_dl_l01 brk_e1 "1" pt1 pt2 strtpt) ipt savpt1)) 
      (setq pt2 (if (pr_dl_l01 brk_e2 "3" pt2 pt1 nextpt) ipt savpt3))
      (setq pt1 p1)
    )
    ((= uctr 1)
      (setq p1 (if (pr_dl_l01 brk_e1 "2" pt1 pt2 strtpt) ipt savpt2))
      (setq pt2 (if (pr_dl_l01 brk_e2 "4" pt2 pt1 nextpt) ipt savpt4))
      (setq pt1 p1)
      
      (if (and pr:brk brk_e1)
        (progn
          (command "_.BREAK" brk_e1 savpt1 savpt2)
        )
      )
      (if (and pr:brk brk_e2)
        (progn
          (if (eq brk_e1 brk_e2)
            (progn
              (entdel (nth 0 wnames))  
              (pr_dl_ved "brk_e2" nextpt)
              (entdel (nth 0 wnames))
            )
          )
          (command "_.BREAK" brk_e2 savpt3 savpt4)
        )
      )
    )
    ((= (rem uctr 2.0) 0)    
      (setq fang nil)
      (setq p1 (pr_dl_dl2 pt1))          
      (setq pt2 (if (pr_dl_l01 brk_e2 "3" pt2 pt1 strtpt) 
                  ipt
                  savpt3
                )
      )
      (setq pt1 p1)
      (if flgn                        
        (progn
          (setq tmp1 (nth flgn wnames)
                ent1 (entget tmp1)    
          )
          (if (= (pr_dl_val 0 tmp1) "LINE")
            (setq pt2 (pr_dl_mls nil 10))           
            (setq pt2 (pr_dl_mas T nil pt2 pt1 nil))  
          )
        )                             
      )
    )
    (T
      (setq p1 (pr_dl_dl2 pt1))              
      (setq pt2 (if (pr_dl_l01 brk_e2 "4" pt2 pt1 nextpt) 
                  ipt
                  savpt4
                )
      )
      (setq pt1 p1)
      (if flgn                        
        (progn
          (setq tmp1 (nth flgn wnames)
                ent1 (entget tmp1)    
                brk_e1 nil
                brk_e2 nil
          )
          (if (= (pr_dl_val 0 tmp1) "LINE")
            (setq pt2 (pr_dl_mls nil 10))           
            (setq pt2 (pr_dl_mas T nil pt2 pt1 nil))  
          )
        )                             
      )
      (if (and pr:brk brk_e2)
        (progn
          (command "_.BREAK" brk_e2 savpt3 savpt4)
        )
      )
    )
  )
  (command "_.LINE" pt1 pt2 "")         
  (setq wnames (if (null wnames) 
                 (list (setq elast (entlast)) )
                 (append wnames (list (setq elast (entlast)))))
        uctr   (1+ uctr)
  )
  wnames
)

(defun pr_dl_l01 (bent1 n p1 p2 pt / temp)
  (setq n (strcat "savpt" n))
  (setq spt nil)
  (if bent1
    (if (= (pr_dl_val 0 bent1) "LINE")
      (progn
        (setq temp (inters (trans (pr_dl_val 10 bent1) 0 1)
                            (trans (pr_dl_val 11 bent1) 0 1)
                            p1
                            p2
                            nil
                    )
        ) 
        (if temp
          (set (read n) temp)
          (progn
            (set (read n) p1)
            (setq brk_e1 nil)
          )
        )
      )
      (progn
        (set (read n) (pr_dl_ial bent1 p1 p2 pt))
        (if spt
          (progn
            (setq ipt (eval (read n)))
            (set (read n) spt)
          )
        )
      )
    )
    (set (read n) p1)
  )
  (if spt
    T
    nil
  )
)

(defun pr_dl_dl2 (npt)
  (setq tmp1 (nth (- uctr 2) wnames)
        ent1 (entget tmp1))          
   
  (if (= (pr_dl_val 0 tmp1) "LINE")  
    (if (or  (equal (angle strtpt nextpt)
                   (angle (trans (pr_dl_val 10 tmp1) 0 1)
                          (trans (pr_dl_val 11 tmp1) 0 1)) 0.001)
             (equal (angle strtpt nextpt)
                   (angle (trans (pr_dl_val 11 tmp1) 0 1)
                          (trans (pr_dl_val 10 tmp1) 0 1)) 0.001)
             (equal (+ (* 2 pi) (angle strtpt nextpt))
                   (angle (trans (pr_dl_val 10 tmp1) 0 1)
                          (trans (pr_dl_val 11 tmp1) 0 1)) 0.001)
        )
      (progn
        (setq brk_e2 nil)
        (command "_.LINE" (trans (pr_dl_val 11 tmp1) 0 1) pt1 "") 
        pt1 
      )
      (progn
        (pr_dl_mls nil 11)
      )
    )
    (pr_dl_mas nil nil pt1 pt2 strtpt)  
  )
)

(defun pr_dl_mls (flg2 nn / spt ept pt)  
                                      

  (setq spt (trans (pr_dl_val 10 tmp1) 0 1)   
        ept (trans (pr_dl_val 11 tmp1) 0 1)
  )
  (if flg2
    (progn
      (setq pt (pr_dl_ial tmp spt ept (if flgn nextpt strtpt)))
    )

    (setq pt (inters spt ept pt1 pt2 nil)) 
  )
  (if pt 
    (entmod (subst (cons nn (trans pt 1 0)) 
                   (assoc nn ent1) 
                   ent1))
    (setq pt pt2)
  )
  pt
)

(defun pr_dl_ial (arc pt_1 pt_2 npt / d pi2 rad ang nang temp ipt)

  (setq cpt  (trans (pr_dl_val 10 arc) (pr_dl_val -1 arc) 1)  
        pi2  (/ pi 2)                 
        ang  (angle pt_1 pt_2)                   
        nang (+ ang pi2)              
        temp (inters pt_1 pt_2 cpt (polar cpt nang 1) nil)
        nang (angle cpt temp)
  )
  (setq d (distance cpt temp))

  (cond
    ((equal (setq rad (pr_dl_val 40 arc)) d 0.01)
      (setq ipt temp)
    )
    ((< rad d)                       
      (setq spt (polar cpt nang rad)
            ipt temp
      )
      (command "_.LINE" spt ipt "")
      ipt
    )
    (T
      (if (and pr_dl_arc fang (> uctr 1)) 
        (setq npt (polar cpt fang rad))
      )
      (pr_dl_g2p npt)
      (setq ipt (pr_dl_bp arc pt_1 pt_2 ipt1 ipt2))
      (if fang 
        (setq fang nil)
        (if pr_dl_arc (setq fang (angle cpt ipt)))
      )
      ipt
    )
  )
)
(defun pr_dl_g2p (npt / temp l theta)
  (if (equal d 0.0 0.01)
    (setq theta pi2
          nang (+ ang pi2)            
    )
    (setq l     (sqrt (abs (- (expt rad 2) (expt d 2))))
          theta (abs (atan (/ l d)))
    )
  )
  (setq ipt1 (polar cpt (- nang theta) rad))
  (setq ipt2 (polar cpt (+ nang theta) rad))
  (if (< (distance ipt2 npt) (distance ipt1 npt))
    (setq temp ipt1
          ipt1 ipt2
          ipt2 temp
    )
    (if (equal (distance ipt2 npt) (distance ipt1 npt) 0.01)
      (exit)
    )
  )
  ipt1
)
(defun pr_dl_onl (sp ep pt / cpt sa ea ang)
  (if (inters sp ep pt
              (polar pt (+ (angle sp ep) (/ pi 2))
                     (/ (getvar "tracewid") 10)
              )
              T)
    T 
    nil
  )
)
(defun pr_dl_ona (arc pt / cpt sa ea ang)
  (setq cpt (trans (pr_dl_val 10 arc) (pr_dl_val -1 arc) 1) 
        sa  (pr_dl_val 50 arc)           
        ea  (pr_dl_val 51 arc)           
        ang (angle cpt pt)            
  )
  (if (> sa ea)
    (if (or (and (> ang sa) (< ang (+ ea (* 2 pi))))
            (and (> ang (- ea (* 2 pi))) (< ang ea))
        ) 
      T 
      nil
    )
    (if (and (> ang sa) (< ang ea)) T nil)
  )
)

(defun pr_dl_bp (en1 p1 p2 pp1 pp2 / temp temp1 temp2)
  (setq temp1 (pr_dl_onl p1 p2 pp2)
        temp2 (pr_dl_ona en1 pp2)
        temp  (if (or (= flg 1) (= flg 3)) T nil)
  )
  (if (and temp1 temp2)
    (if (and (< uctr 2) 
             (and brk_e1 brk_e2))
      pp1
      (if (and temp (not fang)) pp1 pp2)
    )
    pp1
  )
)

(defun pr_dl_das (flgn orad nn / tmp1 ent1 pt ang )
  (cond
    ((= uctr 0)
      (setq sent1 tmp)
      (pr_dl_a01 brk_e1 "1" strtpt nil)  
      (pr_dl_a01 brk_e2 "3" nextpt T)    
    )
    ((= uctr 1)
      (setq sent1 tmp)
      (pr_dl_a01 brk_e1 "2" strtpt nil)  
      (pr_dl_a01 brk_e2 "4" nextpt T)    
      (pr_dl_mae nil T)
      (pr_dl_mae nil nil)
      (if (and pr:brk brk_e1)
        (progn
          (pr_dl_mae T T)
          (pr_dl_mae T nil)
          (command "_.BREAK" brk_e1 savpt1 savpt2)
        )
      )
      (if (and pr:brk brk_e2)
        (progn
          (if (eq brk_e1 brk_e2)
            (progn
              (entdel (nth 0 wnames))  
              (entdel (nth 1 wnames))  
              (pr_dl_ved "brk_e2" nextpt)
              (entdel (nth 0 wnames))
              (entdel (nth 1 wnames))
            )
          )
          (if (null brk_e1)
            (progn
              (pr_dl_mae T T)
              (pr_dl_mae T nil)
            )
          )
          (command "_.BREAK" brk_e2 savpt3 savpt4)
        )
      )
    )
    ((= (rem uctr 2.0) 0) 
      (setq fang nil)
      (pr_dl_da2)                        
      (if fang 
        (setq ftmp fang
              fang nil
        )
      )
      (setq save_1 ent)
      (setq sent1 (cdr(assoc -1 ent)))
      (setq pt2 (pr_dl_a01 brk_e2 "3" nextpt T)) 
      (if ftmp 
        (setq fang ftmp
              ftmp nil
        )
      )
    )
    (T
      (pr_dl_da2)                        
      (if fang 
        (setq ftmp fang
              fang nil
        )
      )
      (setq save_2 ent)
      (setq sent1 (cdr(assoc -1 ent)))
      (setq pt2 (pr_dl_a01 brk_e2 "4" nextpt T)) 
      (if ftmp 
        (setq fang fang
              ftmp nil
        )
      )

      (if (and pr:brk brk_e2)
        (progn
          (pr_dl_mae T T)
          (pr_dl_mae T nil)
          (command "_.BREAK" brk_e2 savpt3 savpt4)
        )
      )
    )
  )
  (setq uctr   (1+ uctr))
)
(defun pr_dl_a01 (bent1 n pt flg / pt1 pt2 ang1 ang2 anga angb)
  (setq n (strcat "savpt" n))
  (if bent1
    (if (= (pr_dl_val 0 bent1) "LINE")
      (progn
        (set (read n) (pr_dl_ial tmp (trans (pr_dl_val 10 bent1) 0 1)
                                  (trans (pr_dl_val 11 bent1) 0 1) pt)) 
      )
      (progn
        (setq curcpt (trans (pr_dl_val 10 sent1) (pr_dl_val -1 sent1) 1) 
              prvcpt (trans (pr_dl_val 10 bent1) (pr_dl_val -1 bent1) 1)
              pt1    (polar prvcpt (pr_dl_val 50 bent1) (pr_dl_val 40 bent1))
              pt2    (polar curcpt (pr_dl_val nn sent1) (pr_dl_val 40 sent1))
              ang1   (angle prvcpt pt1)
        )
        (if (not (equal ang1 (angle prvcpt strtpt) 0.01))
          (setq pt1  (polar prvcpt (pr_dl_val 51 bent1) (pr_dl_val 40 bent1))
                ang1 (angle prvcpt pt1)
                ang2 (angle curcpt pt2)
                anga (- ang1 ang2)
                angb (- ang2 ang1)
          )
        )
        (if (or (and (< anga 0.0872665)
                     (> anga -0.0872665))
                (and (< angb 0.0872665)
                     (> angb -0.0872665))
            )
          (progn
            (set (read n) pt)
            (if (= bent1 brk_e1) 
              (setq brk_e1 nil)
              (setq brk_e2 nil)
            )
          )
          (set (read n) (pr_dl_iaa sent1 bent1 pt flg))
        )
      )
    )
    (progn
      (setq cpt (trans (pr_dl_val 10 tmp) (pr_dl_val -1 tmp) 1))
      (set (read n) (polar cpt (angle cpt pt) orad))
    )
  )
  (eval (read n))
)
(defun pr_dl_da2 (/ pt)
  (setq tmp1 (nth (- uctr 2) wnames) 
        ent1 (entget tmp1))
  (if (= (pr_dl_val 0 tmp1) "LINE")     
    (setq pt (pr_dl_mls T 11))             
    (setq pt (pr_dl_mas nil T nil nil strtpt)) 
  )
  (if pt
    (progn
      (setq ang (- (angle cpt pt) ange))
      (entmod (setq ent (subst (cons nn ang) 
                       (assoc nn ent) 
                       ent)))         
    )
  )
  (if flgn                            
    (progn
      (setq tmp1 (nth flgn wnames)     
            ent1  (entget tmp1)) 
      (if (= (pr_dl_val 0 tmp1) "LINE")     
        (setq pt (pr_dl_mls T 10))   
        (setq pt (pr_dl_mas T T nil nil nextpt)) 
      )
      (if pt
        (progn
          (setq ang (- (angle cpt pt) ange))
          (setq nn (if (= nn 50) 51 50))
          (entmod (setq ent (subst (cons nn ang) 
                         (assoc nn ent) 
                         ent)))       
        )                             
      )
    )                             
  )
)
(defun pr_dl_mae (eflg sflg / nn1 nn2)
  (if (= nn 50)
    (setq nn1 50 nn2 51)
    (setq nn1 51 nn2 50)
  )
  (if sflg
    (if eflg
      (setq save_1 (subst (cons nn2 
                                (angle 
                                  (trans cpt    1 (cdr(assoc -1 save_1)))
                                  (trans savpt3 1 (cdr(assoc -1 save_1)))
                                )
                          )
                          (assoc nn2 save_1) save_1)
      )
      (setq save_1 (subst (cons nn1 
                                (angle 
                                  (trans cpt    1 (cdr(assoc -1 save_1)))
                                  (trans savpt1 1 (cdr(assoc -1 save_1)))
                                )
                          )
                          (assoc nn1 save_1) save_1)
      )
    )
    (if eflg
      (setq save_2 (subst (cons nn2 
                                (angle 
                                  (trans cpt    1 (cdr(assoc -1 save_1)))
                                  (trans savpt4 1 (cdr(assoc -1 save_2)))
                                )
                          )
                          (assoc nn2 save_2) save_2)
      )
      (setq save_2 (subst (cons nn1 
                                (angle 
                                  (trans cpt    1 (cdr(assoc -1 save_1)))
                                  (trans savpt2 1 (cdr(assoc -1 save_2)))
                                )
                          )
                          (assoc nn1 save_2) save_2)
      )
    )
  )
  (if sflg
    (entmod save_1)
    (entmod save_2)
  )
)
(defun pr_dl_mas (flg3 flg2 spt ept pt / nnn pt1 pt2 rad1 ange)
  (setq cpt1   (trans (pr_dl_val 10 tmp1) (pr_dl_val -1 tmp1) 1)           
        rad1   (pr_dl_val 40 tmp1)
        ang1   (pr_dl_val 50 tmp1)
  )
  (if (null pt)                       
    (setq pt (nth 0 spts))            
  )               
  (setq ange (trans '(1 0 0) (pr_dl_val -1 tmp1) 1)
        ange (angle '(0 0 0) ange)
        ang1 (+ ang1 ange)
  )
  (if (> ang1 (* 2 pi))
    (setq ang1 (- ang1 (* 2 pi)))
  )
  (if (equal (angle cpt1 pt) ang1 0.01) 
    (setq nnn 50)                     
    (setq nnn 51)                     
  )                                   
  (if flg2
    (progn
      (setq pt1 (pr_dl_iaa tmp tmp1 (if flg3 nextpt strtpt) flg2))   
      (if pt1 
        (progn
          (setq ang1 (- (angle cpt1 pt1) ange))
          (setq ent1 (subst (cons nnn ang1) 
                            (assoc nnn ent1) 
                            ent1))                 
          (entmod ent1)               
        )
      )
    )
    (progn 
      (setq pt1 (pr_dl_ial tmp1 spt ept pt)) 
      (setq ang1 (- (angle cpt1 pt1) ange))
      (setq ent1 (subst (cons nnn ang1) 
                        (assoc nnn ent1) 
                        ent1))                 
      (entmod ent1)                   
    )
  )
  pt1
)

(defun pr_dl_iaa  (en1 en2 npt flga / a b c s ang alpha alph ipt 
                                   curcpt prvcpt temp temp1 temp2)
  (setq curcpt  (trans (pr_dl_val 10 en1) (pr_dl_val -1 en1) 1) 
        prvcpt  (trans (pr_dl_val 10 en2) (pr_dl_val -1 en2) 1) 
        a       (pr_dl_val 40 en2)
        b       (distance curcpt prvcpt)
        c       (pr_dl_val 40 en1)
        s       (/ (+ a b c) 2.0)
        ang     (angle curcpt prvcpt)
  )
  (cond
    ((or (= (- s a) 0) (equal b (+ a c) 0.001) (equal b (abs (- a c)) 0.001))
      (setq ipt nil)
    )
    ((and (or (> b (+ a c)) (if (> c a) (< (+ a b) c) (< (+ c b) a)))                 

          (not (equal (+ a b ) c (/ (+ a b c) 1000000))))
      (if (= flg 4) 
        (progn
          (setq ipt (polar curcpt (angle curcpt prvcpt) c))
          (command "_.LINE" (polar prvcpt (angle prvcpt ipt) a) ipt "")
        )
        (progn
          (setq ipt (polar curcpt (angle curcpt prvcpt) c))
          (command "_.LINE" (polar prvcpt (angle prvcpt ipt) a) ipt "")
        )
      )
    )
    (T
      (setq alpha (* 2.0 (atan (sqrt (abs (/ (* (- s b) (- s c)) 
                                             (* s (- s a)))))))
      )
      
      (setq tpt1 (polar curcpt (+ ang alpha) c)
            tpt2 (polar curcpt (- ang alpha) c)
            anga  (angle curcpt npt)
            angb  (angle prvcpt npt)
      )
      (if (and pr_dl_arc fang (> uctr 1)) 
        (setq npt (polar prvcpt fang c))
      )
      (if (< (distance tpt1 npt) (distance tpt2 npt))
        (setq temp tpt1
              tpt1 tpt2
              tpt2 temp
        )
      )
      (setq temp (angle prvcpt curcpt)) 
      (setq ipt (pr_dl_bap en1 en2 tpt2 tpt1 nil))
      (if fang 
        (setq fang nil)
        (if pr_dl_arc (setq fang (angle cpt ipt)))
      )
    )
  )
  (setq cpt curcpt)
  (setq cpt1 prvcpt)
  ipt                                 
)

(defun pr_dl_bap (en1 en2 pp1 pp2 flg / temp1 temp2)
  (setq temp1 (pr_dl_ona en1 pp2)
        temp2 (pr_dl_ona en2 pp2)
  )
  (if temp2
    (if (and (< uctr 2) 
             (and brk_e1 brk_e2))
      pp1
      (if temp1 
        (if (< uctr 2) 
          pp2
          (if (not fang) pp2 pp1)
        )
        pp1
      )
    )
    pp1
  )        
)


(defun pr_dl_atl ()
  (setq wnames (if (null wnames) 
                 (list (entlast)) 
                 (append wnames (list tmp)))
  )
  wnames
)


(defun pr_dl_ssp ( / temp)
  (setq temp (length savpts))
  (if (> temp 1)
    (progn
      (setq savpt3 (nth (- temp 2) savpts)
            savpt4 (nth (- temp 1) savpts)
      )
    )
  )
)


(defun endcap ()

    (initget "Auto Both End None Begin")

  (setq pr:ecp (getkword 
    "\nExtreme?  Both/End/None/Begin/<Auto>: "))
  (cond
    ((= pr:ecp "None")
      (setq pr:ecp 0)
    )
    ((= pr:ecp "Begin")
      (setq pr:ecp 1)
    )
    ((= pr:ecp "End")
      (setq pr:ecp 2)
    )
    ((= pr:ecp "Both")
      (setq pr:ecp 3)
    )
    (T  
      (setq pr:ecp 4)
    )
  )
)


(defun pr_dl_m1 ()
  (setq temp T
        uctr nil 
  )
  (if pr_dl_arc
    (setq nextpt "ARc")
    (setq nextpt "Line")
  )
  ;; temp set to nil when a valid point is entered.
  (while temp
    (initget "Break Extreme Displacement Offset Snap Undo Width")
    (setq strtpt (getpoint 
      "\nBreak/Extreme/Displacement/Offset/Snap/Undo/Width/<First point>: "))
    (cond
      ((= strtpt "Displacement")
        (pr_dl_sao)
      )
      ((= strtpt "Break")
        (initget "ON OFF")
        (setq pr:brk (getkword 
          "\nIt Breaks the Dline at beginning and at the end?  OFF/<ON>: "))
        (setq pr:brk (if (= pr:brk "OFF") nil T))    
      )
      ((= strtpt "Offset")
        (pr_dl_ofs)
      )
      ((= strtpt "Snap")
        (pr_dl_sso)
      )
      ((= strtpt "Undo")
        (princ "\nThe last segments have been undone. ")
        (setq temp T)
      )
      ((= strtpt "Width")
        (initget 6)
        (pr_dl_snw)
        (setq temp T)
      )
      ((null strtpt)
        (if v:stpt
          (setq strtpt v:stpt
                temp   nil
          )
          (progn
            (princ "\nInvalid point -- select another point. ")
          )
        )
      )
      ((= strtpt "Extreme")
        (endcap)    
      )
      (T
        (setq v:stpt strtpt
              temp   nil
        )
      )
    )
  )
)

(if (null pr:ecp) (setq pr:ecp 4))    
(if (null pr:snp) (setq pr:snp T))    
(if (null pr:brk) (setq pr:brk T))    
(if (null pr:osd) (setq pr:osd 0))    


;;;(princ "   Double Line loaded...")  
(princ)



;;;**************************************************************************

(defun C:LOC_TXT () 
 ;Rotina para locazacao parcial de texto
 ; exemplo : O usuario que necessita procurar todos as entidades textos do desenho 
 ;           que contem  a sequencia de caracteres = "ETA", esat rotina localizara com
 ;           zoom automatico todos os textos do desenho, (ex: Detalhe A, Detalhe B, ..)
  (setq cmdecho_atual (getvar "cmdecho"))
  (setq layer_atual (getvar "clayer"))
  (command "cmdecho" "0")
  (setq NOME_RUA (getstring "\nType complete text (or part):"))
  (setq nome1 (entnext))
  (setq dados1 (entget nome1))
  (setq cont 0)
  (setq procura 1)
  (While procura
  (progn
    (setq cont (+ cont 1))
    (if (= cont 1)
        (setq nome2 nome1)             ; obtem a primeira entidade
        (setq nome2 (entnext nome1))   ; obtem prox entidade ou vertice, etc
    )
    (if (/= nome2 nil)
      (progn
         (setq dados2 (entget nome2))     ;
         (setq entidade (cdr (assoc 0 dados2)))
         (if (= entidade "TEXT")
           (progn
              (setq nome_layer (cdr (assoc 8 dados2)))
                (setq texto_rua (cdr (assoc 1 dados2)))
                 (setq alt_txt (cdr (assoc 40 dados2)))

           ;     (print texto_rua)
                (setq pesq_txt (wcmatch (strcase texto_rua) (STRCAT "*" (strcase nome_rua) "*")))
                (if pesq_txt 
                (PROGN  
                        (setq PT (cdr (assoc 10 dados2)))
;;                        (PRINT PT)
                        (COMMAND "ZOOM" "C" PT (* 10 alt_txt)) 
                         (print texto_rua)
                        (Setq pause (getstring "Press Enter (to next) or CTRL+C (to Cancel):"))
                 ))


         ))
      )
      (setq procura nil)
    )  ;if
    (setq nome1 nome2)
  )); while
 (command "layer" "s" layer_atual "")
 (command "cmdecho" cmdecho_atual)
 (command "regen")
 (princ)
)

;;;**************************************************************************
(defun c:CB ()
  (setq cmdecho_atual (getvar "cmdecho"))
  (setq layer_atual (getvar "clayer"))
  (command "cmdecho" "0")
  (if (setq nome1 (entnext))
    (progn
      (setq dados1 (entget nome1))
      (setq cont 0)
      (setq procura 1)
      (setq bl (getstring "\nType name of block:"))
      (PRINT "Wait, searching blocks...")
      (setq contblk 0)
      (While procura
	(progn
	  (setq cont (+ cont 1))
	  (if (= cont 1)
	    (setq nome2 nome1)
	    (setq nome2 (entnext nome1))
	    )
	  (if (/= nome2 nil)
	    (progn
	      (setq dados2 (entget nome2))
	      (setq entidade (cdr (assoc 0 dados2)))
	      (if (= entidade "INSERT")
		(progn
		  (setq nomeblk (cdr (assoc 2 DADOS2)))
		  (if (= nomeblk bl)
		    (setq contblk (+ contblk 1))
		    )
		  ))
	      )
	    (setq procura nil)
	    )  ;if
	  (setq nome1 nome2)
	  )); while
      (command "layer" "s" layer_atual "")
      (command "cmdecho" cmdecho_atual)
      (command "regen")
      (print "Total of blocks:")(princ contblk)
      (command "_PMTHIST")
      )
    (progn
      (command "layer" "s" layer_atual "")
      (command "cmdecho" cmdecho_atual)
      (command "regen")
      (print "No entities founded")
      )
    )
  )

;;;**************************************************************************
(defun c:CB2()
    (setq bl (getstring "\nType name of block:"))
;;    (PRINT "Selecione entidades :")
    (setq ents (ssget))
    (setq qt (sslength ents))
    (setq cont2 0)
    (setq cont 0)
    (while (< cont qt)
    (progn
       (setq ent (entget (ssname ents cont)))
       (setq tipo (cdr (assoc 0 ent)))
       (if (= tipo "INSERT")
       (progn
           (setq nome (cdr (assoc 2 ent)))
           (if (= (strcase bl)(strcase nome))(setq cont2 (1+ cont2)))
       ))
       (setq cont (1+ cont))
    ))   ; while cont < qt
    (print "Total of blocks ")(princ bl)(princ " : ")(princ cont2) 
    (princ)
)
;;;**************************************************************************
(defun c:CB3()
    (setq listbl (list (list "" "")))
;;    (PRINT "Selecione entidades :")
    (setq ents (ssget))
    (setq qt (sslength ents));;
    (setq cont2 0)
    (setq cont 0)
    (while (< cont qt)
    (progn
       (setq ent (entget (ssname ents cont)))
       (setq tipo (cdr (assoc 0 ent)))
       (if (= tipo "INSERT")
       (progn
           (setq nome (cdr (assoc 2 ent)))
;;           (if (= (strcase bl)(strcase nome))(setq cont2 (1+ cont2)))
;;           (print nome)
           (setq contl 1 qt2 0)
           (setq tamlist (length listbl))
           (setq tem 0)
           (while (<= contl tamlist)
           (progn
              (setq elem (nth (- contl 1) listbl))
              (setq qte (cadr elem))

              (setq nl (car elem))
;;              (print "car elem  nome:")(princ nl)(princ ":")(princ nome)(princ ":")
              (if (= nl nome) ; já tem na lista
                (progn
                    (setq nova_qte (1+ qte))
                    (setq old elem)
                    (setq new (list nome nova_qte))
                    (setq listbl (subst new old listbl))
                   ;(somar qte) 
                    (setq tem 1)
                    (setq contl tamlist)
                )
                (progn  ; naotem
                    (setq tem 0)
;;;                    (setq listbl (append listbl (list (list nome 1))))
                )
              )
;              (setq listbl (append listbl (list (list nome qt2))))
               (setq contl (1+ contl))
          ))
              (if (= tem 0) (setq listbl (append listbl (list (list nome 1)))))

;;           (setq listbl (append listbl (list nome qt2)))
;;           (setq listvalv (append listvalv (list (list pc1 pcvalv))))
       ))
       (setq cont (1+ cont))
    ))   ; while cont < qt
     
;;    (princ "Quantidade de blocos ")
    (setq qtgeral 0)
    (setq contl 1)
    (setq tamlist (length listbl))
    (while (< contl tamlist)
     (progn
       (setq elem (nth contl listbl))
       (print (car elem))(princ "=")(princ (cadr elem))
       (setq contl (1+ contl))
       (setq qtgeral (+ qtgeral (cadr elem)))
    ))
    (print "Total of blocks")(princ qtgeral)

    (princ)


)


;;;**************************************************************************
;;;                                  Audit.lsp 

;Revision ©2007 by R&C/TASK


(defun c:ADT()

; (setq itc (getvar "_vendorname"))
; (if (= itc "R&C/TASK")
; (progn
  (setq nome_des (strcat "Audit_VCAD_" (substr (getvar "dwgname") 1 (- (strlen (getvar "dwgname")) 4))))
  (setq arq_exp (open (strcat (getvar "exedir") "Audit_Reports\\" nome_des ".TXT") "w"))
;;;  (setq Adt_Date (rtos (command "date")))
;;;  (write-line (strcat "Audit Report created in: " date)) arq_exp)
  (write-line "Informations file:" arq_exp)
  (write-line (strcat "User Name > " (getvar "LOGINNAME")) arq_exp)
  (write-line (strcat "File Path > " (getvar "dwgprefix")) arq_exp)
  (write-line (strcat "File Name > " (getvar "dwgname")) arq_exp)
  (write-line "" arq_exp)
  (write-line "Results: " arq_exp)
  
  
  (setq ents (ssget "X"))

;;  (setq ents (ssget "X" '((0 . "LINE") (8 . "LINE_ISO"))  ))
;;  (setq ents (ssget "X" '((0 . "LWPOLYLINE") (8 . "LINE_ISO"))  ))

   (setq cont_ents 0)
   (if ents (setq qtents (sslength ents)))
(print "Number of entities :")(princ qtents)   
   (if (/= ents nil)(setq cont_ents (sslength ents)))
   (setq cont 0)
   (while (< cont cont_ents)
   (progn
      (setq entx (ssname ents cont))
      (setq dadosx (entget entx))
      (setq tipo_ent (cdr (assoc 0 dadosx)))


; verificaçào da existencia de entidades com valor de Thickness maior do que zero
      (setq vthick (cdr (assoc 39 dadosx)))
      (if (> vthick 0.0)
      (progn
         (setq v_p1 (cdr (assoc 10 dadosx)))
         (setq v_p2 (cdr (assoc 11 dadosx)))
         (print "###COD010### Warning ; Entitied with Thickness > 0")
         (print "            ")(princ tipo_ent)(princ " p1 : ")(princ v_p1)(princ " / p2 : ")(princ v_p2)
         (write-line "###COD010### Warning ; Entitied with Thickness > 0" arq_exp)
         (setq p1x_str (rtos (car v_p1)))
         (setq p1y_str (rtos (cadr v_p1)))
         (setq p1_str (strcat p1x_str "," p1y_str))

         (setq p2x_str (rtos (car v_p2)))
         (setq p2y_str (rtos (cadr v_p2)))
         (setq p2_str (strcat p2x_str "," p2y_str))

         (write-line (strcat "            " tipo_ent " p1 : " p1_str " / p2 : " p2_str) arq_exp)
       ))


;       (setq ent (cdr (assoc 0 dadosx)))
;       (print ent) 

       (cond
          ((= tipo_ent "INSERT")
;            (print dadosx)
          )
          ((= tipo_ent "LINE")
;;            (print dadosx)
          )

          ((= tipo_ent "SPLINE")
;            (print dadosx)
          )
          ((= tipo_ent "HATCH")
;            (print dadosx)
          )
          ((= tipo_ent "HATCH")
;            (print dadosx)
          )

       )

   
;;      (PRINT DADOSX)
      (setq cont (1+ cont))
   )) ; while

;; verificação da existencia de Bloco dentro de bloco (audit ###cod050###
(PRINT "---------------------------------------------------------")
      (setq prim t)
      (while (setq tbdata (tblnext "BLOCK" prim))
      (progn
          (setq nome_bloco (cdr (assoc 2 tbdata)))
          (setq ent2 (cdr (assoc -2 tbdata)))  ; pegar ENTIDADES INTERNAS
          (setq d_ent2 (entget ent2)) ; pega dados
          (setq tipo_ent (cdr (assoc 0 d_ent2)))
          (if (= tipo_ent "INSERT")
          (progn
               (setq nome_bloco2 (cdr (assoc 2 d_ent2)))
               (setq mens (strcat "###COD050### Warning, There is (are) Block(s) inside other Block, block :" nome_bloco2 " inside of block : " nome_bloco))
               (print mens)
               (write-line mens arq_exp)

          ))
          (WHILE (setq ent2n (entnext ent2))
          (progn
             (setq d_ent2n (entget ent2n)) ; pega dados
             (setq tipo_ent (cdr (assoc 0 d_ent2n)))
             (if (= tipo_ent "INSERT")
             (progn
               (setq nome_bloco2 (cdr (assoc 2 d_ent2n)))
               (setq mens (strcat "###COD050### Warning, Block inside other block, block :" nome_bloco2 " inside of block : " nome_bloco))
               (print mens)
               (write-line mens arq_exp)

             ))

             (setq ent2 ent2n)
           ))
          (setq prim nil)
      )) ; while block
          
;; verificação da existencia de estilo de dimensionamento STANDARD
(PRINT "---------------------------------------------------------")
	(setq dim_std (TBLSEARCH "DIMSTYLE" "STANDARD"))
      (if (= dim_std nil)
        (setq mens "###COD060### Warning, There isn't Dimensioning Style name = STANDARD ")
        (setq mens "###COD061### OK , There is Dimensioning Style : name = STANDARD ")
      )
      (print mens)
      (write-line mens arq_exp)



;; verificação da existencia de Layer = zero
(PRINT "---------------------------------------------------------")
	(setq lay_std (TBLSEARCH "LAYER" "0"))
      (if (= lay_std nil)
        (setq mens "###COD070### Warning, there isn't Layer Zero ")
        (setq mens "###COD071### OK , there is Layer Zero  ")
      )
      (print mens)
      (write-line mens arq_exp)



;; verificação da existencia de Estilo de Texto = STANDARD
(PRINT "---------------------------------------------------------")
	(setq style_std (TBLSEARCH "STYLE" "STANDARD"))
      (if (= style_std nil)
        (setq mens "###COD080### Warning, there isn't Style text name = STANDARD ")
        (setq mens "###COD081### OK , there is Style Text name=STANDARD ")
      )
      (print mens)
      (write-line mens arq_exp)


;; verificação da existencia de Tipo de linha = CONTINUOUS
(PRINT "---------------------------------------------------------")
	(setq ltype_std (TBLSEARCH "LTYPE" "CONTINUOUS"))
      (if (= ltype_std nil)
        (setq mens "###COD090### Warning, there isn't Linetype CONTINUOUS ")
        (setq mens "###COD091### OK, there is Linetype CONTINUOUS")
      )
      (print mens)
      (write-line mens arq_exp)

;; Verificação da existencia de Nome de bloco que começam com A$C
(PRINT "---------------------------------------------------------")
      (setq existe 0)
      (setq prim t)
      (while (setq tbdata (tblnext "BLOCK" prim))
      (progn
          (setq nome_bloco (cdr (assoc 2 tbdata)))
          (if (= (substr nome_bloco 1 3) "A$C")
            (progn
              (print "###COD100### Warning, There is (are) Block(s) with name : A$C, block : ")(princ nome_bloco)
              (write-line (strcat "###COD100### Warning, There is (are) Block(s) with name : A$C, block : " nome_bloco) arq_exp)

              (setq existe 1)
             )
          )
 
          (setq prim nil)
      )) ; while block
      (if (= existe 0)
      (progn
         (print "###COD101### OK , there aren't blocks with A$C")
         (write-line "###COD101### OK , there aren't blocks with A$C " arq_exp)
      ))

;;#### a fazer#####
;#################
;; verificação da existencia de caracteres não recomendados nos nomes de Blocos, Ltype, Layers, etc
(PRINT "---------------------------------------------------------")
      (setq prim t)
      (while (setq tbdata (tblnext "BLOCK" prim))
      (progn
          (setq nome (cdr (assoc 2 tbdata)))
;          (print nome)
          (setq tam_nome (strlen nome))
          (setq cont 1)
          (while (< cont tam_nome)
          (progn
             (setq carac (substr nome cont 1))
             (setq vasc (ascii carac))
             (if (or
                    (and (>= vasc 48)(<= vasc 57))   ; 0 1 2 .. 9
                    (and (>= vasc 65)(<= vasc 90))   ; A B C D...Z
                    (and (>= vasc 97)(<= vasc 122))   ; a b c d ..z
                    (= vasc 45)(= vasc 95)(= vasc 32)(= vasc 42)           ; "-" "_" " " "*"   
                 )
              () ; ok estao corretos
             (progn
               (print "###COD200###  Warning, There is (are) Block(s) with inappropriate name ")(princ nome)
               (write-line (strcat "###COD200### Warning, There is (are) Block(s) with inappropriate name , block : " nome) arq_exp)
             ))
             (setq cont (1+ cont))
           )) ; while cont < tam_nome
          (setq prim nil)
      )) ; while block

;; verificação da existencia de caracteres não recomendados nos nomes de Blocos, Ltype, Layers, etc
(PRINT "---------------------------------------------------------")
                     
      (setq prim t)
      (while (setq tbdata (tblnext "LAYER" prim))
      (progn
          (setq nome (cdr (assoc 2 tbdata)))
;          (print nome)
          (setq tam_nome (strlen nome))
          (setq cont 1)
          (while (< cont tam_nome)
          (progn
             (setq carac (substr nome cont 1))
             (setq vasc (ascii carac))
             (if (or
                    (and (>= vasc 48)(<= vasc 57))   ; 0 1 2 .. 9
                    (and (>= vasc 65)(<= vasc 90))   ; A B C D...Z
                    (and (>= vasc 97)(<= vasc 122))   ; a b c d ..z
                    (= vasc 45)(= vasc 95)(= vasc 32)           ; "-" "_" " "   
                 )
              () ; ok estao corretos
             (progn
               (print "###COD200### Warning, There is (are) layer(s) with inappropriate name , Layer : ")(princ nome)
               (write-line (strcat "###COD200### Warning, There is (are) Layer(s) with inappropriate name  Layer : " nome) arq_exp)
             ))
             (setq cont (1+ cont))
           )) ; while cont < tam_nome
          (setq prim nil)
      )) ; while block

       (print)
       (setq nome_arq_aud (strcat "Created audit file : " (getvar "exedir") "Audit_Reports\\" nome_des ".TXT"))
       (print nome_arq_aud)
       (alert nome_arq_aud)
       (princ)

     (close arq_exp)
;  )) ; if do vendor_name
)




;;;**************************************************************************
;;;                           Prefix and Sufix text increments

;Revision ©2007 by R&C/TASK


(defun c:ftxt ()
  (setq ti (getstring "\nType Prefix text to include: "))
  (setq tf (getstring "\nType Suffix text to include: "))

  (setq sset (ssget))
  (setq pos  0)

  (while (< pos (sslength sset) )

    (setq ename (ssname sset pos))
    (if (= (cdr (assoc 0 (entget ename))) "TEXT")
      (progn
        (setq etext (cdr (assoc 1 (entget ename))))
        (command "change" ename "" "" "" "" "" "" (strcat ti etext tf))
      )
    )
    (setq pos (+ pos 1))
  )
)


;;;**************************************************************************
;;                          Files Integrity Check

;Revision ©2007 by R&C/TASK


(defun c:Integrity()
  (progn
    (setq v1_PathCheck (getfiled "Insert Path" (getvar "dwgprefix") "dwg" 2))
    (setq v1_LenCheck (- (strlen v1_PathCheck) 4))
      (while (/= (substr v1_PathCheck v1_LenCheck 1) "\\")
        (progn
          (setq v1_LenCheck (- v1_LenCheck 1))
          )
        )
    (setq v1_LenCheck (- v1_LenCheck 1))
    (setq V1_PathCheck (strcat (substr v1_PathCheck 1 v1_LenCheck)"\\"))
    )
    (alert "1")
  (setq 
;;;	         dir 	       (getstring "\nType path name to file(s) audit: ")
;;;            v1_PathCheck (IncBackSlash v1_PathCheck)
		lista_files  (ic_ListFiles (strcat v1_PathCheck "*.dwg"))
            lista_files	 (mapcar 'ExtractFileName lista_files)
    		fp 		 (open (strcat (getvar "exedir") "SMART/temp/list.scr")  "w")
    )
  (alert "2")
  (while lista_files
    (write-line (strcat "(command \"open\" \"" v1_PathCheck "\\" (car lista_files)"\")") fp)
    (write-line  "(command \"_close\")" fp   )
    (setq lista_files (cdr lista_files))
    )
    (alert "3")
  (write-line  "(alert   \"All trouble files were openned sucessfully!!!\")"  fp  )
  (close fp)
    (alert "4")
  (progn
    (command "filedia" "0")
    (command "script" (strcat (getvar "exedir") "SMART/temp/list.scr"))
    (command "filedia" "1")
    )
    (alert "5")
)


;;;**************************************************************************


(setq var_icomscad_install  (strcat (getvar "exedir") "SMART/"))


(DEFUN func_icomscad_ler( nomelisp )
  (load (strcat var_icomscad_install "lisp/" nomelisp))
)




;;;(func_icomscad_ler "VCAD_CopyPaste.lsp")


(defun C:cpbase ()
  (if (not (setq SS (ssget "i")))
    (progn
      (prompt "\nSelect object(s) to be COPYEDED: ")
      (setq SS (ssget))
    )
    (progn (setq SS (ssget))
      )
    )  
  (princ "\n")
  (setq PT1 (getpoint "Selecione o ponto base: (0,0,0)"))
  (setq NAMECOPY (strcat (getvar "exedir") "Temporary File/VCAD_Copyclip_X0"))
  (command "filedia" "0")
  (command "wblock" NAMECOPY "Y" "" PT1 SS "")
  (command "filedia" "1")
  (command "oops")
  (command "regen")
  )

(defun C:cutbase ()
  (if (not (setq SS (ssget "i")))
    (progn
      (prompt "\nSelect object(s) to be CUTEDED: ")
      (setq SS (ssget))
    )
    (progn (setq SS (ssget))
      )
    )
  (princ "\n")
  (setq PT1 (getpoint "Selecione o ponto base: (0,0,0)"))
  (setq NAMECOPY (strcat (getvar "exedir") "Temporary File/VCAD_Copyclip_X0"))
  (command "filedia" "0")
  (command "wblock" NAMECOPY "Y" "" PT1 SS "")
  (command "filedia" "1")
  (command "regen")
  )

(defun c:pasteblock ()
  (princ "\n")
  (setq NAMECOPY (strcat (getvar "exedir") "Temporary File/VCAD_Copyclip_X0"))
  (command "insert" NAMECOPY "s" 1 "r" 0 pause)
  (progn
    (setq V_BLOCK 0)
    (while (tblsearch "block" (strcat "VCAD_Copyclip_X" (itoa V_BLOCK))) 
      (setq V_BLOCK (+ V_BLOCK 1))
      )
    )
  (command "rename" "block" "VCAD_Copyclip_X0" (strcat "VCAD_Copyclip_X" (itoa V_BLOCK)))
  (command "regen")
  )



;;(func_icomscad_ler "VCAD_Find.lsp")

;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
^       Programador     : VINICIUS PONTES RODRIGUES
^       Empresa         : RCTASK
^
^       Modulo          : 
^       Data de Entrega : 
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

(defun ChangeChar ( string a b / Nstring i size byte char)
       (setq i 1 Nstring "" size (strlen a))

       (while (<= i (strlen string) )

                  (setq char (substr string i size))
                  (if (= (strcase char) (strcase a) )
                         (progn
                               (setq Nstring (strcat Nstring b))
                               (setq i (+ i size))
                         )
                         (progn
                               (setq byte (substr string i 1))
                               (setq Nstring (strcat Nstring byte))
                               (setq i (+ i 1))
                         )
                  )
       )
       Nstring
)

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
    

    (if (= reler 1)
    	(progn
   	    (setq ifind_ListaEnt  nil   ifind_ListaPontos nil  ifind_DadosDaEntidade nil)

	    (if  (= ifind_opt3 "1")  (ifind_FilterEnt   "TEXT"      ))
	    (if  (= ifind_opt3 "1")  (ifind_FilterEnt   "MTEXT"     ))
	    (if  (= ifind_opt4 "1")  (ifind_FilterEnt   "INSERT"    ))
	    (setq ifind_LastListFind ifind_ListaEnt)
	    (alert "End of Search !!!")
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
                         	(ifind_GeraPonto ifind_PontoDoZoom  -5 -5 0)
                         	(ifind_GeraPonto ifind_PontoDoZoom (atoi ifind_zoomw) (atoi ifind_zoomw) 0)
                         	
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
  (setq form  (load_dialog (strcat (getvar "exedir") "SMART/dcl/VCAD_find.dcl")))
  (new_dialog "IFIND" form)
  (setq ifind_cmd nil)
 
 
  (if (= ifind_find    nil) (setq ifind_find    ""))
  (if (= ifind_replace nil) (setq ifind_replace ""))
  (if (= ifind_cmdpo   nil) (setq ifind_cmdpo  "0"))
  (if (= ifind_zoomw   nil) (setq ifind_zoomw  "10"))

  
  (ifind_Localizar 0)

  (if (= ifind_opt1 nil) (setq ifind_opt1 "0"))
  (if (= ifind_opt2 nil) (setq ifind_opt2 "0"))
  (if (= ifind_opt3 nil) (setq ifind_opt3 "1"))
  (if (= ifind_opt4 nil) (setq ifind_opt4 "1"))
  (if (= ifind_opt5 nil) (setq ifind_opt5 "0"))

  (set_tile  "find"     ifind_find)
  (set_tile  "replace"  ifind_replace)
  (set_tile  "zoomw"    ifind_zoomw)

  (set_tile "opt1" ifind_opt1)
  (set_tile "opt2" ifind_opt2)
  (set_tile "opt3" ifind_opt3)
  (set_tile "opt4" ifind_opt4)
  (set_tile "opt5" ifind_opt5)

  (action_tile  "find"               "(setq ifind_find      (get_tile \"find\"))")
  (action_tile  "replace"            "(setq ifind_replace   (get_tile \"replace\"))")
  (action_tile  "zoomw"              "(setq ifind_zoomw     (get_tile \"zoomw\"))")

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



;;(func_icomscad_ler "VCAD_ClearFile.lsp")

(defun c:CFile (/ V1_SSGET V1_DIA V1_LAYOUT V1_ListEnt V1_TotalEnt V1_Prin V1_NameEnt V1_LenName V1_Count 1_form V1_TypeEnt)
  (command)
  (setq V1_SSGET 0)
  (while (/= V1_SSGET nil)
    (if (= V1_SSGET 0)
      (CLEAR_FILE)
      (progn
	(setq V1_SSGET 0)
	(setq V1_DIA (getvar "filedia"))
	(if (= V1_LAYOUT "1")
	  (COPY_LAYOUTS)
	  )
	(CLEAR_DWG)
	(MAKE_NEW)
	)
      )
    )
  )

(defun CLEAR_FILE ()
  (setq 1_form  (load_dialog (strcat var_icomscad_install "dcl/VCAD_ClearFile.dcl")))
  (new_dialog "CLEARFILERCTASK" 1_form)
  (setq V1_TypeEnt (list "BLOCKs" "LAYERs" "DIMSTYLEs" "STYLEs" "LINETYPEs" "UCSs"))
  (start_list "Li_Ent")
  (mapcar 'add_list V1_TypeEnt)
  (end_list)
  (set_tile "Li_Ent" "0")
  (action_tile "Botao_OK" "(CL_OK)")
  (action_tile "Botao_CA" "(CL_CA)")
  (Li_Ent)
  (start_dialog)
  )

(defun Li_Ent ()
  (set_tile "Type_Ent" (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt))
  (setq V1_Prin t)
  (setq V1_ListEnt (list ))
  (setq V1_TotalEnt 0)
  (while (setq V1_NameEnt (cdr (assoc 2 (tblnext (substr (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt) 1 (- (strlen (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt)) 1)) V1_Prin))))
    (progn
      (setq V1_LenName (strlen V1_NameEnt))
      (setq V1_Count 1)
      (setq V1_TotalEnt (+ V1_TotalEnt 1))
      (while (<= V1_Count V1_LenName)
	(progn
	  (setq V1_Carac (substr V1_NameEnt V1_Count 1))
	  (setq V1_Vasc (ascii V1_Carac))
	  (if
	    (or
	      (and (>= V1_Vasc 48)(<= V1_Vasc 57))   ; 0 1 2 ..9
	      (and (>= V1_Vasc 65)(<= V1_Vasc 90))   ; A B C D ...Z
	      (and (>= V1_Vasc 97)(<= V1_Vasc 122))   ; a b c d ...z
	      (= V1_Vasc 45)(= V1_Vasc 95)(= V1_Vasc 32)(= V1_Vasc 42)(= V1_Vasc 124) ; "-" "_" " " "*" "|"
	      )
	    (progn
	      (setq V1_Count (+ V1_Count 1))
	      )
	    (progn
	      (setq V1_ListEnt (append V1_ListEnt (list V1_NameEnt)))
	      (setq V1_Count (+ V1_LenName 1))
	      )
	    )
	  )
	)
      (if (= V1_Prin t)
	(setq V1_Prin nil)
	)
      )
    )
  (if (= (length V1_ListEnt) 0)
    (progn
      (setq V1_ListEnt (append V1_ListEnt (list (strcat "* None " (substr (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt) 1 (- (strlen (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt)) 1)) " with bad name was founded. *" ))))
      (set_tile "QtdBadEnt" "0")
      )
    (progn
      (set_tile "QtdBadEnt" (itoa (length V1_ListEnt)))
      )
    )
  (start_list "Li_Bad_Ent")
  (mapcar 'add_list V1_ListEnt)
  (end_list)
  (set_tile "Total_Scan" (itoa V1_TotalEnt))
  (Ren_Set)
  )

(defun Ren_Set ()  
  (if (= (get_tile "QtdBadEnt") "0")
    (progn
      (mode_tile "V1_Bad_NAME" 1)
      (mode_tile "V1_New_NAME" 1)
      (mode_tile "Aut_Ren_OK"  1)
      (mode_tile "V1_Ren_OK"   1)
      (set_tile "V1_Bad_NAME" "")
      (set_tile "V1_New_NAME" "")
      )
    (progn
      (mode_tile "V1_Bad_NAME" 1)
      (mode_tile "V1_New_NAME" 1)
      (mode_tile "Aut_Ren_OK"  1)
      (mode_tile "V1_Ren_OK"   0)
      (set_tile "Aut_Ren_OK" "1")
      (set_tile "V1_Bad_NAME" "click in some name of the list to rename manually...")
      (set_tile "V1_New_NAME" "")
      )
    )
  )

(defun Ren_Set1 ()
  (if (/= (get_tile "QtdBadEnt") "0")
    (progn
      (set_tile "Aut_Ren_OK" "0")
      (mode_tile "V1_Bad_NAME" 0)
      (mode_tile "V1_New_NAME" 0)
      (mode_tile "Aut_Ren_OK"  0)
      (set_tile "V1_Bad_NAME" (nth (atoi (get_tile "Li_Bad_Ent")) V1_ListEnt))
      )
    )
  )

(defun Ren_Set2 ()
  (if (= (get_tile "Aut_Ren_OK") "0")
    (progn
      (mode_tile "V1_Bad_NAME" 0)
      (mode_tile "V1_New_NAME" 0)
      )
    (progn
      (mode_tile "V1_Bad_NAME" 1)
      (mode_tile "V1_New_NAME" 1)
      )
    )
  )

(defun Ren_Set3 ()
  (if (= (get_tile "Aut_Ren_OK") "0")
    (R_MAN)
    (R_AUT)
    )
  )

(defun R_MAN ()
  (if (= (get_tile "V1_New_NAME") "")
    (progn
      (alert "A new name is necessary. Try again...")
      )
    (progn
      (if (tblsearch (substr (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt) 1 (- (strlen (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt)) 1)) (get_tile "V1_Bad_NAME"))
	(if (tblsearch (substr (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt) 1 (- (strlen (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt)) 1)) (get_tile "V1_New_NAME"))
	  (alert "This layer already it exists. Try again...")
	  (progn
	    (command "rename" (substr (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt) 1 (- (strlen (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt)) 1)) (get_tile "V1_Bad_NAME") (get_tile "V1_New_NAME"))
	    (Li_Ent)
	    )
	  )
	(alert "The bad name was modified. Try again...")
	)
      )
    )
  )

(defun R_AUT (/ V1_Renamed V1_Total_List V1_SetName V1_SUFIX)
  (setq V1_Renamed 0)
  (setq V1_Total_List (atoi (get_tile "QtdBadEnt")))
  (setq V1_SUFIX 1)
  (while (< V1_Renamed V1_Total_List)
    (progn
      (setq V1_NameEnt (nth 0 V1_ListEnt))
      (setq V1_SetName nil)
      (setq V1_LenName (strlen V1_NameEnt))
      
      (setq V1_Count 1)
      (while (<= V1_Count V1_LenName)
	(progn
	  (setq V1_Carac (substr V1_NameEnt V1_Count 1))
	  (setq V1_Vasc (ascii V1_Carac))
	  (if
	    (or
	      (and (>= V1_Vasc 48)(<= V1_Vasc 57))   ; 0 1 2 ..9
	      (and (>= V1_Vasc 65)(<= V1_Vasc 90))   ; A B C D ...Z
	      (and (>= V1_Vasc 97)(<= V1_Vasc 122))   ; a b c d ...z
	      (= V1_Vasc 45)(= V1_Vasc 95)(= V1_Vasc 32)(= V1_Vasc 42)(= V1_Vasc 124) ; "-" "_" " " "*" "|"
	      )
	    (if V1_SetName
	      (progn
		(setq V1_Count (+ V1_Count 1))
		(setq V1_SetName (strcat V1_SetName V1_Carac))
		)
	      (progn
		(setq V1_Count (+ V1_Count 1))
		(setq V1_SetName V1_Carac)
		)
	      )
	    (progn
	      (setq V1_Count (+ V1_Count 1))
	      )
	    )
	  )
	)
      (if (tblsearch (substr (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt) 1 (- (strlen (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt)) 1)) V1_SetName)
	(while (tblsearch (substr (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt) 1 (- (strlen (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt)) 1)) V1_SetName)
	  (progn
	    (setq V1_SetName (strcat V1_SetName "_" (itoa V1_SUFIX)))
	    (setq V1_SUFIX (+ V1_SUFIX 1))
	    )
	  )
	)
      (command "rename" (substr (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt) 1 (- (strlen (nth (atoi (get_tile "Li_Ent")) V1_TypeEnt)) 1)) (nth 0 V1_ListEnt) V1_SetName)
      (Li_Ent)
      (setq V1_Total_List (atoi (get_tile "QtdBadEnt")))
      )
    )
  )

(defun COPY_LAYOUTS ()
  (alert "COPY_LAYOUTS")
  )

(defun CLEAR_DWG ( / PT1 SS)
  (C:LAYTHW)
  (C:LAYON)
  (C:LAYULK)
  (command "plan" "w")
  (command "zoom" "1/2xp")
  (if (not (setq SS (ssget "i")))
    (progn
      (prompt "\nSelect object(s) will be clear: ")
      (setq SS (ssget))
    )
    (progn (setq SS (ssget))
      )
    )
  (setq PT1 "0,0,0")
  (setq V1_FILECLEAROWN (getvar "savename"))
  (setq FILECLEAR (strcat (getvar "exedir") "Temporary File/VCAD_ClearFile_X0.dwg"))
  (setvar "filedia" 0)
  (command "wblock" FILECLEAR "" PT1 SS "")
  (command "oops")
  (command "zoom" "previous")
  (print "Saving this drawing. Please Whait...")
  (command "qsave")
  (print "Closing this drawing. Please Whait...")
  (command "close")
  )

(defun MAKE_NEW ()
  (if (= V1_MAKE "0")
    (progn
      (command "open" FILECLEAR)
      (setvar "filedia" V1_DIA)
      (print "Saving this drawing. Please Whait...")
      (command "saveas" "" V1_FILECLEAROWN)
;;;      (command "xref" "r" "")
      (command "zoom" "extents")
      )
    (progn
      (command "open" FILECLEAR)
      (setvar "filedia" V1_DIA)
      (print "Saving this drawing as a new file. Please Whait...")
      (command "saveas" "" (strcat (substr V1_FILECLEAROWN 1 (- (strlen V1_FILECLEAROWN) 4)) "_Clean.dwg"))
;;;      (command "xref" "r" "")
      (command "zoom" "extents")
      )
    )
  )

(defun CL_OK ()
  (setq V1_SSGET 1)
  (setq V1_MAKE (get_tile "Make_OK"))
  (setq V1_LAYOUT (get_tile "Layout_OK"))
  (done_dialog 0)
  )

(defun CL_CA ()
  (setq V1_SSGET nil)
  (done_dialog)
  )

(defun AU_RE2 ()
  (if (= (get_tile "Auto_OK") "1")
    (progn
      (mode_tile "Bad_Name" 1)
      (mode_tile "New_Name" 1)
      )
    (progn
      (mode_tile "Bad_Name" 0)
      (mode_tile "New_Name" 0)
      )
    )
  )

(defun PS_OK2 ()
  (if (= (get_tile "UsePF_OK") "0")
    (progn
      (mode_tile "Prefix_OK" 1)
      (mode_tile "Sufix_OK" 1)
      )
    (progn
      (mode_tile "Prefix_OK" 0)
      (mode_tile "Sufix_OK" 0)
      )
    )
  )



;;(func_icomscad_ler "VCAD_refedit.LSP")

(defun c:REFEDIT (/ Edit_layout ATT_REQ)

;;(GETSTRING)
;  (princ "\n")


  (setq ent9 0)
  (while (= ent9 0)
  (progn
     (setq ent9 0)
     (setq ent1 (entsel "\nSelect block:"))
     (setq d_ent1 (entget (car ent1))) 
     (setq n_block (cdr (assoc 2 d_ent1))) 
     (setq tipo_ent (cdr (assoc 0 d_ent1)))
     (if (= tipo_ent "INSERT") (setq ent9 1))    
  ))

    


  (if (= tipo_ent "INSERT")
     (command "setvar" "vcad_block" n_block)
  )

  (if (= tipo_ent "XREF")
     (command "setvar" "vcad_XREF" n_block)
  )
 
	

;  (setq d_ent1	
 ;   vcad_xref
;  (command "setvar" "vcad_block" "v")
  (setq Edit_layout "Block Editor")
  (command "layout" "delete" Edit_layout)
  (princ "\n")
  (princ)
  (command "layout" "new" Edit_layout)
  (setvar "ctab" Edit_layout)
  (setq ATT_REQ (getvar "attreq"))
  (setvar "attreq" 0)
  (command "insert" (getvar "VCAD_BLOCK") "s" 1 "r" 0 "0,0,0")
  (setvar "attreq" ATT_REQ)
  (command "explode" "last")
  (command "zoom" "extents")
  (setq ATT_REQ nil)
  (princ "\n")
  (princ)
  )

(defun C:X_edit ()
  (princ "\n")
  (command "filedia" "0")
  (command "open" (getvar "VCAD_XREF"))
  (command "filedia" "1")
  (command "zoom" "extents")
  (princ)
  )

(defun B_exit ()
  (princ "\n")
  (setvar "ctab" "Block Editor")
  (if (= "Block Editor" (getvar "ctab"))
    (progn
      (if (tblsearch "block" (getvar "VCAD_BLOCK"))
	(command "-block" (getvar "VCAD_BLOCK") "y" "0,0,0" "all" "")
	;(command "-block" (getvar "VCAD_BLOCK") "0,0,0" "all" "")
	)
      (setq Edit_layout (getvar "ctab"))
      (command "layout" "delete" Edit_layout)
      (setvar "ctab" "Model")
      (setq Edit_layout nil)
      (print (strcat "\"Block Editor\" was closed and the \"Block " (getvar "VCAD_BLOCK") "\" was updated."))
      (command "setvar" "VCAD_BLOCK" ".")
      (princ)
      )
    (progn
      (print)
      (Alert "Block Editor are closed.")
      )
    )
  )

(defun B_exit2 ()
  (princ "\n")
  (setvar "ctab" "Block Editor")
  (if (= "Block Editor" (getvar "ctab"))
    (progn
      (setq Edit_layout (getvar "ctab"))
      (command "layout" "delete" Edit_layout)
      (setvar "ctab" "Model")
      (setq Edit_layout nil)
      (command "setvar" "VCAD_BLOCK" ".")
      (princ)
      )
    (progn
      (print)
      (Alert "Block Editor are closed.")
      )
    )
  )

(defun X_exit ()
  (princ "\n")
;;;  (setq V1_XREF_NAME (getvar "dwgname"))
;;;  (setq V1_XREF_NAME (substr V1_XREF_NAME 1 (- (strlen V1_XREF_NAME) 4)))
  (command "qsave")
  (command "close")
  (command "setvar" "VCAD_XREF" ".")
  (princ)
  )

(defun X_exit2 ()
  (princ "\n")
  (command "setvar" "VCAD_XREF" ".")
  (command "-vbarun" "refclose")
  (princ)
  )

(defun C:REFSAVE ()
  (command)
  (princ "\n")
  (if (/= (getvar "VCAD_XREF") "")
    (if (= (getvar "VCAD_XREF") (getvar "savename"))
      (if (/= (getvar "VCAD_BLOCK") "")
	(if (= "Block Editor" (getvar "ctab"))
	  (b_exit)
	  (progn
	    (initget "Block Xref All")
	    (setq X_CLOSE (getkword "To close the Block Editor/Xref file/All? <B/X/A/Enter to cancel>"))
	    (if (/= X_CLOSE nil)
	      (cond
		((= X_CLOSE "Block")
		 (progn
		   (setq X_CLOSE nil)
		   (b_exit)
		   (print "Block Editor was saved and closed.")
		   )
		 )
		((= X_CLOSE "Xref")
		 (progn
		   (setq X_CLOSE nil)
		   (x_exit)
		   (print "External Reference was saved and closed. You must reload External Reference.")
		   )
		 )
		((= X_CLOSE "All")
		 (progn
		   (setq X_CLOSE nil)
		   (b_exit)
		   (x_exit)
		   (print "External Reference and Block Editor were saved and closed. You must reload External Reference.")
		   )
		 )
		)
	      )
	    )
	  )
	(progn
	  (x_exit)
	  (print "External Reference was saved and closed. You must reload External Reference.")
	  )
	)
      (if (/= (getvar "VCAD_BLOCK") "")
	(b_exit)
	(alert "None Block opened for edition, but a External Reference was opened for edition and was not closed by \"Close RefEdit\".")
	)
      )
    (if (/= (getvar "VCAD_BLOCK") "")
      (b_exit)
      (print "None External Reference or Block opened for edition.")
      )
    )
  )


(defun C:REFEXIT ()
  (command)
  (princ "\n")
  (if (/= (getvar "VCAD_XREF") "")
    (if (= (getvar "VCAD_XREF") (getvar "savename"))
      (if (/= (getvar "VCAD_BLOCK") "")
	(if (= "Block Editor" (getvar "ctab"))
	  (b_exit2)
	  (progn
	    (initget "Block Xref All")
	    (setq X_CLOSE (getkword "To close the Block/Xref file/All? <B/X/A/Enter to cancel>"))
	    (if (/= X_CLOSE nil)
	      (cond
		((= X_CLOSE "Block")
		 (progn
		   (setq X_CLOSE nil)
		   (b_exit2)
		   (print "Block Editor was closed.")
		   )
		 )
		((= X_CLOSE "Xref")
		 (progn
		   (setq X_CLOSE nil)
		   (x_exit2)
		   (print "External Reference was closed.")
		   )
		 )
		((= X_CLOSE "All")
		 (progn
		   (setq X_CLOSE nil)
		   (x_exit2)
		   (print "External Reference and Block were closed.")
		   )
		 )
		)
	      )
	    )
	  )
	(progn
	  (x_exit2)
	  (print "External Reference was closed.")
	  )
	)
      (if (/= (getvar "VCAD_BLOCK") "")
	(b_exit2)
	(alert "None Block opened for edition, but a External Reference was opened for edition and was not closed by \"Close RefEdit\".")
	)
      )
    (if (/= (getvar "VCAD_BLOCK") "")
      (b_exit2)
      (print "None External Reference or Block opened for edition.")
      )
    )
  )




;;(func_icomscad_ler "VCAD_edge.lsp")

(defun edge_setCmdEcho ( newVal / _oldEnvVal)
  ; Only do it if the value is different than the current value
  (if (/= newVal (getvar "CMDECHO"))
    (progn
      (setq _oldEnvVal (getenv "acedChangeCmdEchoWithoutUndo"))
      ; If not set yet, use 0 for default
      (if (not _oldEnvVal)
          (setq _oldEnvVal "0"))
      (setenv "acedChangeCmdEchoWithoutUndo" "1")
      (setvar "cmdecho" newVal)
      (setenv "acedChangeCmdEchoWithoutUndo" _oldEnvVal)
    )
  )
)

;;; ----------------------------- CREATE NEW *ERROR* -------------------------;

(defun edge-er (n) 
  (if (/= s "Function cancelled") 
    (princ (strcat "\nError: " n))
  ) 
  (command) 
  (command "_.UCS" "_P") 
  (setvar "osmode" o1)
  (setvar "gridmode" g1)
  (setvar "aperture" a1)
  (setvar "splframe" v1)
  (setvar "ucsfollow" u1)
  (setq n1 -1)
  (repeat (sslength faclst) 
    (redraw (entupd (ssname faclst (setq n1 (1+ n1)))))
  )  
  (command "_.UNDO" "_E")
  ;; Restore CMECHO without undo recording
  (edge_setCmdEcho _edge_oldCmdEcho)
  (setq *error* lisp-er)
  (prin1)
) 
;;; ---------------------------- COMMONLY USED MACROS ------------------------;

(defun getval (n e) 
  (cdr (assoc n e))
) 

(defun fltfac (ss / n1) 
  (setq n1 0)
  (if ss 
    (repeat (sslength ss) 
      (if (/= (getval 0 (entget (setq e1 (ssname ss n1)))) "3DFACE") 
        (ssdel e1 ss) 
        (setq n1 (1+ n1))
      )
    )
  ) 
  ss
) 

;;; ------------------------- FORCE DISPLAY OF ALL EDGES ---------------------;

(defun dsply (/ ss n1 t1) 
  (setvar "osmode" 0)
  (initget "All Select") 
  (setq ss (if (eq (getkword "\nEnter selection method for display of hidden edges [Select/All] <All>: ") "Select") 
             (fltfac (ssget)) 
             (ssget "_x" '((0 . "3dface")))
           ) 
        n1 -1)
  (setvar "osmode" 2)
  (cond (ss (princ "\n** Regenerating 3DFACE objects...") 
            (repeat (sslength ss) 
              (ssadd (setq t1 (ssname ss (setq n1 (1+ n1)))) faclst) 
              (shohdn (entget (entupd t1)))) 
            (princ "done.") T) 
    (T (princ "\nNo 3DFACE objects found.") nil)
  )
) 
;;; ----------------------------- SHOW HIDDEN EDGES --------------------------;

(defun shohdn (e / b1 p1 p2 p3 p4) 
  (setq b1 (getval 70 e))
  (mapcar '(lambda (j k) (set j (getval k e))) 
          '(p1 p2 p3 p4) 
          '(10 11 12 13)) 
  (if (= (logand b1 1) 1) 
    (grdraw p1 p2 c1 1)
  ) 
  (if (= (logand b1 2) 2) 
    (grdraw p2 p3 c1 1)
  ) 
  (if (= (logand b1 4) 4) 
    (grdraw p3 p4 c1 1)
  ) 
  (if (= (logand b1 8) 8) 
    (grdraw p4 p1 c1 1)
  )
) 

;;; --------------------------- GET ENTITY TO EDIT ---------------------------;

(defun getfce (pt / ll ur n1 ss e1 p1) 
  (setq p1 (trans pt 0 2) 
        ll (trans (polar P1 (/ (* pi 5) 4) h1) 2 0) 
        ur (trans (polar P1 (/ pi 4) h1) 2 0) 
        n1 0)
  (setvar "osmode" 0)
  (if (setq ss (ssget "_c" ll ur))
    (setq ss (fltfac ss))
  ) 
  (setvar "osmode" 2)
  ss
) 

;;; --------------------- MODIFY 3DFACE EDGE VISIBILITY FLAG -----------------;

(defun modfce (ss pt / n1 e1 e0 p0 b1 b2 b3) 
  (setq n1 0)
  (repeat (sslength ss) 
    (setq e1 (entget (ssname ss n1)) 
          e0 (getval -1 e1))
    (ssadd e0 faclst) 
    (mapcar '(lambda (j k) (set j (getval k e1))) 
            '(p1 p2 p3 p4) 
            '(10 11 12 13)) 
    (setq p0 (if (equal (distance p3 p4) 0 1e-8) 
               (mapcar '(lambda (j k l) (/ (+ j k l) 3)) p1 p2 p3) 
               (mapcar '(lambda (j k l m) (/ (+ j k l m) 4)) p1 p2 p3 p4)
             ))
    (setq b1 (getval 70 e1) 
          b2 (cond ((equal pt (inters p0 pt p1 p2) h1) 1) 
               ((equal pt (inters p0 pt p2 p3) h1) 2) 
               ((equal pt (inters p0 pt p3 p4) h1) 4) 
               ((equal pt (inters p0 pt p4 p1) h1) 8) 
               (T 0)
             ) 
          b3 (+ b1 (if (= (logand b1 b2) b2) 
                     (- b2) 
                     b2
                   )
             ) 
          e1 (shohdn (entmod (subst (cons 70 b3) (assoc 70 e1) e1))) 
          n1 (1+ n1))
  ) 
  T
) 
;;; ------------------------------ MAIN PROGRAM ------------------------------;

(defun c:HIEDGE (/ lisp-er s1 o1 g1 a1 v1 h1 u1 faclst c1 r1 t1 ss pt n e n1)
  (command)
  (setq lisp-er *error* 
        *error* edge-er 
        s1 (getvar "cmdecho") 
        _edge_oldCmdEcho s1
        o1 (getvar "osmode") 
        g1 (getvar "gridmode") 
        a1 (getvar "aperture") 
        v1 (getvar "splframe") 
        u1 (getvar "ucsfollow") 
        h1 (/ (getvar "viewsize") 100) 
        faclst (ssadd) 
        c1 7 
        r1 T)
   ; Set CMDECHO without undo recording
  (edge_setCmdEcho 0)
  (command "_.UNDO" "_GROUP") 
  (setvar "osmode" 2)
  (setvar "gridmode" 0)
  (setvar "aperture" 5)
  (setvar "splframe" 1)
  (setvar "ucsfollow" 0)
  (command "_.UCS" "_W") 
  (while r1 
    (initget "Display") 
    (setq t1 (getpoint "\nSpecify edge of 3dface to toggle visibility or [Display]: ") 
          r1 (cond ((eq t1 "Display") (dsply)) 
               ((eq (type t1) 'LIST) (setq ss (getfce t1))
                (cond ((null ss) (princ " No 3DFACE edges found.")) 
                  ((= (sslength ss) 0) (princ " Object is not a 3DFACE.")) 
                  (t (modfce ss t1))
                )
               ) 
               (T nil)
             ))
  ) 
  (command "_.UCS" "_P") 
  (setvar "osmode" o1)
  (setvar "gridmode" g1)
  (setvar "aperture" a1)
  (setvar "splframe" v1)
  (setvar "ucsfollow" u1)
  (setq n1 -1)
  (repeat (sslength faclst) 
    (redraw (entupd (ssname faclst (setq n1 (1+ n1)))))
  ) 
  (redraw) ; to remove highlighted screen graphics
  (command "_.UNDO" "_E") 
  ;; Restore CMECHO without undo recording
  (edge_setCmdEcho _edge_oldCmdEcho)

  (setq *error* lisp-er)
  (prin1)
) 


(defun C:showedge ()
    (command)
  (setq V1_EDGE (getvar "SPLFRAME"))
  (if (= V1_EDGE 0)
    (progn
      (setvar "SPLFRAME" 1)
      (print "Show invisible edges = ON")
      )
    (progn
      (setvar "SPLFRAME" 0)
      (print "Show invisible edges = OFF")
      )
    )
  )



;;(func_icomscad_ler "VCAD_Isometric.lsp")

(defun c:isosnap ()
  (command)
  (setq V1_Snap (getvar "SNAPSTYL"))
  (if (= V1_Snap 0)
    (progn
      (setvar "SNAPSTYL" 1)
      (princ "Isometric Snap = ON")
      )
    (progn
      (setvar "SNAPSTYL" 0)
      (princ "Isometric Snap = OFF")
      )
    )
  )



;;(func_icomscad_ler "VCAD_PLine_Auto.lsp")

(defun c:PAUTO ()
  (command)
  (setq FILE_ref (getfiled "File coordenate reference" "c:/" "txt" 2))
  (setq LENG_ref (strlen FILE_ref))
  (setq CHAR_BASE (substr FILE_ref 1 1))
  (setq FILE_BASE CHAR_BASE)
  (setq CHAR_ref 2)
  (while (<= CHAR_ref LENG_ref)
    (setq CHAR_BASE (substr FILE_ref CHAR_ref 1))
    (if (= CHAR_BASE "\\")
      (setq CHAR_BASE "/")
      )
    (setq FILE_BASE (strcat FILE_BASE CHAR_BASE))
    (setq CHAR_ref (+ 1 CHAR_ref))
    )
  (setq FILE_ref (open FILE_BASE "r"))
  (setq PL_Point (read-line FILE_ref))
  (setq PL_Point_2 (read-line FILE_ref))
  (command "point" PL_Point )
  (command "polyline" PL_Point PL_Point_2 "")
  (while (/= PL_Point nil)
    (setq PL_Point (read-line FILE_ref))
    (setq PL_Point_2 (read-line FILE_ref))
    (if (/= PL_Point_2 nil)
      (command "polyline" "" PL_Point PL_Point_2 "")
      (command "polyline" "" PL_Point "")
      )
    )
  (command "pedit" "l" "j" "all" "" "")
  (command "pedit" "l" "j" "all" "" "")
  (close FILE_ref)
  )





;;(func_icomscad_ler "VCAD_Blk_X_Grp.lsp")


(defun C:bgroup ( / V1_Ent V1_type V1_CDIA V1_BlkName V1_BlkIns V1_Descr)
  (command)
  (terpri)
  (setq V1_Ent (entsel "Select a block:"))
  (setq V1_type (strcase (cdr (assoc 0 (entget (car V1_Ent))))))
  (if (= V1_type "INSERT")
    (progn
      (setq V1_CDIA (getvar "cmddia"))
      (setvar "cmddia" 0)
      (setq V1_BlkName (cdr (assoc 2 (entget (car V1_Ent)))))
      (setq V1_BlkIns (strcat (rtos (car (car (cdr V1_Ent)))) "," (rtos (car (cdr (car (cdr V1_Ent))))) "," (rtos (last (car (cdr V1_Ent)))) ) )
      (setq V1_Descr (strcat "Group of exploded block \"" V1_BlkName "\"."))
      (command "explode" V1_BlkIns)
      (command "group" "Create" V1_BlkName V1_Descr "previous" "")
      (setvar "cmddia" V1_CDIA)
      (command "regen")
      (print (strcat "The group of exploded block \"" V1_BlkName "\" was created successfully."))
      )
    (progn
      (princ)
      (alert "This is not a block. Please try again...")
      (print)
      )
    )
  )



;;(func_icomscad_ler "VCAD_Clear_Bock.LSP")

(defun C:BClear ()
  (command "-vbarun" "block_clear")
  )

(defun c:B_Clear (/ Edit_layout ATT_REQ V1_ECHO V1_Block1)
  (princ "\n")
;;;  (setq V1_ECHO (getvar "cmdecho"))
;;;  (setvar "cmdecho" 0)
  (setq Edit_layout "Block Clear")
  (command "layout" "delete" Edit_layout)
  (princ "\n")
  (princ)
  (command "layout" "new" Edit_layout)
  (setvar "ctab" Edit_layout)
  (setq ATT_REQ (getvar "attreq"))
  (setvar "attreq" 0)
  (setq V1_Block1 (getvar "VCAD_BLOCK"))
  (command "insert" V1_Block1 "s" 1 "r" 0 "0,0,0")
  (setvar "attreq" ATT_REQ)
  (command "explode" "last")
  (command "zoom" "extents")
  (while (ssget "p" '((0 . "insert")))
    (command "explode" (ssget "x" '((0 . "insert"))))
    )
  (if (tblsearch "block" (getvar "VCAD_BLOCK"))
	(command "-block" (getvar "VCAD_BLOCK") "y" "0,0,0" "all" "")
	;(command "-block" (getvar "VCAD_BLOCK") "0,0,0" "all" "")
	)
  (command "layout" "delete" Edit_layout)
  (setvar "ctab" "Model")
  (command "setvar" "VCAD_BLOCK" ".")
;;;  (setvar "cmdecho" V1_ECHO)
  (princ "\n")
  (princ)
  (print (strcat "All blocks finded inside of Block \"" V1_Block1 "\" ware exploded."))
;;;  (command "setvar" "VCAD_BLOCK" ".")
  )

(defun C:X_Clear ()
  (princ "\n")
  (print "This is a External Reference. Please try again...")
  )



;;(func_icomscad_ler "VCAD_filter.lsp")


;;;----------------------------------------------------------------------------
;;;  DESCRIPTION
;;;
;;;  Dialogue front end to (ssget).  Allows customers to create, save and
;;;  apply filter lists for entity selection via a dialogue interface.
;;;  Uses FILTER.DCL.
;;;
;;;----------------------------------------------------------------------------
;;;
;;; Avoid (gc)s on load to improve load time.
;;;
(defun do_alloc (/ old_allod new_alloc)
  (setq old_alloc (alloc 2000) new_alloc (alloc 2000))
  (expand (1+ (/ 11500 new_alloc)))
  (alloc old_alloc)
)
(do_alloc)
(setq do_alloc nil)
;;;
;;; ===========================================================================
;;; ===================== load-time error checking ============================
;;;

  (defun ai_abort (app msg)
     (defun *error* (s)
        (if old_error (setq *error* old_error))
        (princ)
     )
     (if msg
       (alert (strcat " Application error: "
                      app
                      " \n\n  "
                      msg
                      "  \n"
              )
       )
     )
     (exit)
  )

;;; Check to see if vcad_ai_utils is loaded, If not, try to find it,
;;; and then try to load it.
;;;
;;; If it can't be found or it can't be loaded, then abort the
;;; loading of this file immediately, preserving the (autoload)
;;; stub function.

  (cond
     (  (and ai_dcl (listp ai_dcl)))          ; it's already loaded.

     (  (not (findfile (strcat (getvar "exedir") "SMART/LISP/" "vcad_3.lsp")))                     ; find it
        (ai_abort "FILTER"
                  (strcat "Can't locate file vcad_3.LSP."
                          "\n Check support directory.")))

     (  (eq "failed" (load (strcat (getvar "exedir") "SMART/LISP/" "vcad_3.lsp") "failed"))            ; load it
        (ai_abort "\nApplying filter to selection.  " "Can't load file vcad_3.LSP"))
  )

  ;(if (not (ai_acadapp))               ; defined in vcad_3.LSP
   ;   (ai_abort "\nApplying filter to selection.  " nil)         ; a Nil <msg> supresses
  ;)                                    ; ai_abort's alert box dialog.

;;; ==================== end load-time operations ===========================

;;;----------------------------------------------------------------------------
;;; The Main function.  Variables are initialised, and the dialogue box is
;;; prepared and activated.  A while loop is used to allow the dialogue box
;;; to be hidded for entity selection.
;;;----------------------------------------------------------------------------
(defun c:xfilter(/ 
            a                  filter_lisp_list   load_log      selection_list
            add_to_list        filter_list        lts           single_table
            after_errno        filter_main        make_list     str_name
            all_lisp_list      filter_nfl         n             str_pos
            appid_str          filter_str_list    n1            str_val
            bit_flag           gc_name            name          str1
            c1                 globals            named_lists   str2
            c2                 good_value         new_length    string
            check_color        group_0            new_lisp      table_item
            check_int          group_10           new_str       table_list
            clear_list         group_210          nfl_lisp      table_match
            cmd                group_-3           nfl_str       table_name
            cnum               group_40           olderr        temp
            color_no           group_50           op            temp_lisp_list
            current_filter     group_62           ops_3         temp_list
            current_line       group_8            pat           temp_ss
            dcl_id             hmmm               pat_match     temp_str
            delete_list        huh                pick          the_list
            dp1                i                  pick_list     title
            dp2                init_lists         poly_val      update
            edit_item          item               pos           val
            edit_this          item_index         pr            value
            enable_disable     item1              redefine      what_is_it
            entity_ename       item2              remove        what_next
            entity_lisp        j                  remove_flag   which_box
            entity_lisp_init   just_name          ret_list      which_list
            entity_lisp_list   label              ri_ops        ws
            entity_type        lisp_error         rm_item       x_op
            error_msg          lisp_pos           rs_err        x_value
            f_err              list_name          s             y_op
            filename           list_str           save_all      y_value
            filter_err         list1              save_as       z_op
            filter_gc          load_err           select        z_value
             )
  ;;
  ;; Action on Add Selected Entity button.
  ;;
  (defun do_select_entity ()
    (setq edit_item (atoi (get_tile "filter_str_list")))
    (done_dialog 2)
  )
  ;;
  ;; Action on Remove button.
  ;;
  (defun do_remove ()
    (setq remove_flag 1)
    (remove)
    (setq remove_flag 0)
  )
  ;;
  ;; Initialise the English list and corresponding group code list.  The list
  ;; of operators is also initialised.
  ;;
  ;; This is the only thing that has to be translated to each language.
  ;; the rest of the program MUST, remain in english, and don't worry
  ;; the messages to screen will appear in language.
  ;;
  ;; To add a new entity, add to this list as well as the list of group codes
  ;; below this list. Note that this IS order dependent and should not be changed
  ;; in one list without corresponding changes in the group codes list.
  ;;
  (defun init_lists()
    (setq filter_list (list 
                        "Arc"          
                        "Arc Center"         
                        "Arc Radius"
                        "Attribute"    
                        "Attribute Position" 
                        "Attribute Tag" 
                        "Body"
                        "Block"        
                        "Block Name"         
                        "Block Position"
                        "Block Rotation"
                        "Circle"       
                        "Circle Center"      
                        "Circle Radius" 
                        "Color"         
                        "Dimension"    
                        "Dimension Style" 
                        "Elevation"     
                        "Ellipse"      
                        "Ellipse Center"
                        "Hatch"
                        "Hatch Pattern Name"
                        "Image"
                        "Image Position"
                        "Layer"
                        "Leader"
                        "Line"         
                        "Line Start"         
                        "Line End"
                        "Linetype"
                        "Linetype Scale"
                        "MultiLine"    
                        "MultiLine Style"
                        "Normal Vector"
                        "Point"        
                        "Point Position"
                        "Polyline" 
                        "Ray"
                        "Region"
                        "Shape"        
                        "Shape Position"     
                        "Shape Name"                                            
                        "Solid"
                        "Solid Body"
                        "Spline"
                        "Text"         
                        "Text Position"      
                        "Text Value"
                        "Text Style Name"    
                        "Text Height" 
                        "Text Rotation"
                        "Trace"
                        "3dface"
                        "Thickness"
                        "Tolerance"
                        "Viewport"     
                        "Viewport Center" 
                        "Xdata ID"
                        "Xline"
                        "** Begin  AND"
                        "** End    AND"
                        "** Begin  OR"
                        "** End    OR"
                        "** Begin  XOR"
                        "** End    XOR"
                        "** Begin  NOT"
                        "** End    NOT"
                  )
    )

    (setq filter_gc (list 
                         0      ;|"Arc"               |;
                         10     ;|"Arc Center"        |;
                         40     ;|"Arc Radius"        |;
                              
                         0      ;|"Attribute"         |;
                         10     ;|"Attribute Position"|;
                         2      ;|"Attribute Tag"|;
                          
                         0      ;|"Body"              |;

                         0      ;|"Block"             |;
                         2      ;|"Block Name"        |;
                         10     ;|"Block Position"    |;
                         50     ;|"Block Rotation"    |;

                         0      ;|"Circle"            |;
                         10     ;|"Circle Center"     |;
                         40     ;|"Circle Radius"     |;

                         62     ;|"Color"             |;

                         0      ;|"Dimension"         |;
                         3      ;|"Dimension Style"   |;

                         38     ;|"Elevation"         |;

                         0      ;|"Ellipse"           |;
                         10     ;|"Ellipse Center"    |;

                         0      ;|"Hatch"			  |;
                         2      ;|"Hatch Pattern Name" |;

                         0      ;|"Image"             |;
                         10     ;|"Image Position"    |;

                         8      ;|"Layer"             |;

                         0      ;|"Leader"            |;

                         0      ;|"Line"              |;
                         10     ;|"Line Start"        |;
                         11     ;|"Line End"          |;

                         6      ;|"Linetype"          |;
                         48     ;|"Linetype Scale"    |;

                         0      ;|"MultiLine"         |;
                         2      ;|"MultiLine Style"   |;

                         210    ;|"Normal Vector"     |;

                         0      ;|"Point"             |;
                         10     ;|"Point Position"    |;

                         0      ;|"Polyline"          |;

                         0      ;|"Ray"               |;

                         0      ;|"Region"            |;

                         0      ;|"Shape"             |;
                         10     ;|"Shape Position"    |;
                         2      ;|"Shape Name"        |;

                         0      ;|"Solid"             |;

                         0      ;|"3D Solid"          |;

                         0      ;|"Spline"            |;


                         0      ;|"Text"              |;
                         10     ;|"Text Position"     |;
                         1      ;|"Text Value"        |;
                         7      ;|"Text Style Name"   |;
                         40     ;|"Text Height"       |;
                         50     ;|"Text Rotation"     |;

                         0      ;|"Trace"             |;

                         0      ;|"3dface"            |;

                         39     ;|"Thickness"         |;

                         0      ;|"Tolerance"         |;

                         0      ;|"Viewport"          |;
                         10     ;|"Viewport Center"   |;

                         -3     ;|"Xdata ID"          |;

                         0      ;|"Xline"             |;

                         "<AND" ;|"** Begin  AND"     |;
                         "AND>" ;|"** End    AND"     |;
                         "<OR"  ;|"** Begin  OR"      |;
                         "OR>"  ;|"** End    OR"      |;
                         "<XOR" ;|"** Begin  XOR"     |;
                         "XOR>" ;|"** End    XOR"     |;
                         "<NOT" ;|"** Begin  NOT"     |;
                         "NOT>" ;|"** End    NOT"     |;
        )
    )

    (setq ri_ops (list "=" "!=" "<" "<=" ">" ">=" "*"))  
  )
  ;;
  ;; Function to reset the error tile.
  ;;
  (defun rs_err()
    (set_tile "error" "")
  )
  ;;
  ;; Function called by SELECT button.  Used to bring the Color dialogue and
  ;; the symbol table dialogues.  Groups and Mline Styles not supported yet...
  ;;
  (defun select (/ current_filter selection_list color_no poly_val str 
                   table_name lay_clr
                )
    (setq current_filter (nth (atoi (get_tile "filter_by")) filter_list_english))
    (cond 
      ((= "Color" current_filter)   ; if Color 
        ;; Get current layer's color, for use in BYLAYER color swatch.
        (setq lay_clr (cdr (assoc 62 (tblsearch "layer" (getvar "clayer")))))
        (if (setq color_no (acad_colordlg 1 T lay_clr)) ; and a color is selected
          (set_tile "x_value" (itoa color_no))     
        )
      )
      (t (cond 
           ((= "Block Name"      current_filter) (setq table_name "Block"))
           ((= "Dimension Style" current_filter) (setq table_name "Dimstyle")) 
           ((= "Layer"           current_filter) (setq table_name "Layer"))
           ((= "Linetype"        current_filter) (setq table_name "Ltype"))
           ((= "Text Style Name" current_filter) (setq table_name "Style"))
           ((= "Xdata ID"  current_filter) (setq table_name "Appid"))
           (t (princ "Programming error in select"))
         )
         (setq pregun (en_to_loc current_filter)) ;Added for loc.
         (if (setq selection_list (reverse (single_table table_name 
                   (strcat "Select " pregun "(s)" ))))
           (progn 
             (setq n   0
                   str "")
             (while (< n (length selection_list))
               (setq str (strcat (nth n selection_list) "," str))
               (setq n (1+ n))
             )
             (set_tile "x_value" (substr str 1 (1- (strlen str))))
           )
        )
      )
    )
  )
  ;;
  ;;  Deletes the current named list from the list of named lists.
  ;;
  (defun delete_list()
    (if (/= 0 (setq pick_list (atoi (get_tile "named_lists"))))
      (progn 
        (setq all_lisp_list (rm_item pick_list all_lisp_list))
        (save_all)
        (start_list "named_lists")
        (mapcar 'add_list all_lisp_list)
        (end_list)
        (set_tile "named_lists" "0")
        (setq filter_str_list ai_str|*unnamed)
        (setq filter_lisp_list ai_lisp|*unnamed)
        (start_list "filter_str_list")
        (mapcar 'add_list filter_str_list)
        (end_list)
      )
      (set_tile "error" "Cannot delete *unnamed Filter list.")
    )
  )
  ;;
  ;; Retrieves the named lists from file. (NFL = Named Filter Lists)
  ;;
  (defun load_log(/ filter_nfl nfl_lisp nfl_str current_line)
    ;; Look for .nfl file in the standard places. 
    (if (not (setq filename (findfile "filter.nfl")))
      (setq filename "filter.nfl")
    )
    (if (setq filter_nfl (open filename "r"))
      (progn 
        (setq current_line (read-line filter_nfl))
        (while (and (/= "" current_line)
                    (/= nil current_line)
                    (/= ":" (substr current_line 1 1))) ; skip comments
         (setq current_line (read-line filter_nfl))
        )
        (while current_line                       ; get lisp
          (setq name (substr current_line 10))     ; get list name
          (setq all_lisp_list (cons name all_lisp_list))
          (setq current_line (read-line filter_nfl))
          (while (/= ":" (substr current_line 1 1))
            (setq nfl_lisp (cons (read current_line) nfl_lisp))
            (setq current_line (read-line filter_nfl))
          )
          (set (read (strcat "ai_lisp|" name)) (reverse nfl_lisp))
          (setq nfl_lisp '())
          (setq current_line (read-line filter_nfl))         ; get str
          (set (read (strcat "ai_str|" name)) '())
          (while (and current_line (/= ":" (substr current_line 1 1)))
            (setq nfl_str (cons current_line nfl_str))
            (setq current_line (read-line filter_nfl))
          )
          (set (read (strcat "ai_str|" name)) (reverse (cons "" nfl_str)))
          (setq nfl_str '())
        )
        (if (and all_lisp_list 
                 (< (length all_lisp_list) (getvar "maxsort"))
            )
          (setq all_lisp_list (acad_strlsort all_lisp_list))
        )
        (start_list "named_lists")
        (mapcar 'add_list all_lisp_list)
        (end_list)
        (set_tile "named_lists" "0")
        (close filter_nfl)
      )
    )
  )
  ;;
  ;;  Saves named lists to file.
  ;;
  (defun save_all(/ filter_nfl)
    ;; Look for .nfl file in the standard places. 
    (if (not (setq filename (findfile "filter.nfl")))
      (setq filename "filter.nfl")
    )
    (if (setq filter_nfl (open filename "w"))
      (progn
        (write-line "Filter.nfl  --  Do not edit this file." filter_nfl)
        (if (< 1 (length all_lisp_list))
          (progn
            (foreach n all_lisp_list
              (if (/= n "*unnamed")
                (progn
                  (write-line (strcat ":ai_lisp|" n) filter_nfl)
                  (foreach n1 
                    (reverse (lts (eval (read (strcat "ai_lisp|" n))) 1))
                    (write-line n1 filter_nfl)
                  )
                  (write-line (strcat ":ai_str|" n) filter_nfl)
                  (foreach n1 (eval (read (strcat "ai_str|" n)))
                    (if (/= "" n1) (write-line n1 filter_nfl))
                  )
                )
              )
            )
          )
        )
        (close filter_nfl)
      )
      (alert (strcat "Cannot save Filter list to file \n"
                     " - directory must have write permission."
             )
      )
    )
  )
  ;;
  ;; If not the *unnamed list, make current the selected one.
  ;;
  (defun named_lists()
;    (cond
;      ((/= "0" (get_tile "named_lists"))
        (setq list_name (nth (atoi (get_tile "named_lists")) all_lisp_list))
        ;; Localization fix 
        (if (= list_name "*unnamed") 
             (setq list_name "*unnamed")
        )
        (setq filter_lisp_list 
              (eval (read 
                      (strcat "ai_lisp|" list_name)
              ))
        )
        (setq filter_str_list 
              (eval (read 
                      (strcat "ai_str|" list_name)
              ))
        )
        (start_list "filter_str_list")
        (mapcar 'add_list filter_str_list)
        (end_list)
;      )
;    )
  )

  ;;
  ;; Check the entered name and if valid, save it.
  ;;
  (defun save_as()
    (setq list_name (ai_strtrim (get_tile "new_name")))
    (cond
      ((or (= nil list_name)(= "" list_name))
        (set_tile "error" "Null Filter name not allowed.")
      )
      ((wcmatch list_name "*[]`#`@`.`?`*`~`[`,`'!%^&()+={}|`\\:;\"<>/]*")
        (set_tile "error" "Invalid characters in Filter name.")
      )
      ((= "*unnamed" list_name) 
        (set_tile "error" "Invalid Filter name.")
      )
      ((and (member list_name all_lisp_list) (not (redefine))))
      ((lisp_error)) 
      (T 
        (set (read (eval (strcat "ai_lisp|" list_name))) filter_lisp_list)
        (set (read (eval (strcat "ai_str|" list_name))) filter_str_list)
        (if (not (member list_name all_lisp_list)) ; add if not member
          (progn
            (setq all_lisp_list (cons list_name all_lisp_list))
            (if (and all_lisp_list
                     (< (length all_lisp_list) (getvar "maxsort"))
                )
              (setq all_lisp_list (acad_strlsort all_lisp_list))
            )
          )
        )
        (start_list "named_lists")
        (mapcar 'add_list all_lisp_list)
        (end_list)
        (set_tile "named_lists" (itoa (what_pos list_name all_lisp_list)))
        (save_all)
      ) 
    )
  )
  ;;
  ;; If the entered name for the filter list matches an existing name, call
  ;; dialogue for confirmation to redefine it.  T is returned if OK to redefine.
  ;;
  (defun redefine ()
    (if (not (new_dialog "already_exists" dcl_id)) (exit))   
    (action_tile "redefine" "(done_dialog 2)")
    (action_tile "cancel" "(done_dialog 0)")
    (if (= (start_dialog) 2) t)           ; return t on Redefine, nil on cancel
  )
  ;;
  ;; Debugging routine.
  ;;
  (defun pr()
    (princ filter_str_list)
    (princ filter_lisp_list)
  )
  ;;
  ;;  Routine that updates the current English and Lisp lists to contain the
  ;;  new English and Lisp arguments.
  ;;
  (defun update (new_str new_lisp / str1 str2 i edit_this lisp_pos temp_str)
    ; find current position in filter_lisp_list (list of lists)
    (if (equal (cdr (assoc 0 entity_lisp_init)) "POLYLINE")
       (setq new_lisp(subst (cons 0 "*POLYLINE") (cons 0 "POLYLINE") new_lisp))
    )
    (setq i -1)
    (setq edit_this -1)        ; corresponding item in lisp list.
    (setq lisp_pos -1)         ; so that length below occurs
    (if filter_lisp_list
      (progn
        (while (< edit_this str_pos)  ; until they are equal
          (setq i (1+ i))
          (if (not (and (= -4 (car (nth i filter_lisp_list)))   
                       (not (member 
                              (cdr (nth i filter_lisp_list)) 
                              '("<AND" "AND>" "<OR"  "OR>" 
                               "<XOR" "XOR>" "<NOT" "NOT>")
                            )
                       )
                   )
              )
            (progn 
              (setq edit_this (1+ edit_this))        
            )
          )
        )
        (if (and (< 0 i) 
                 (and (= -4 (car (nth (1- i) filter_lisp_list)))   
                      (not (member 
                             (cdr (nth (1- i) filter_lisp_list)) 
                             '("<AND" "AND>" "<OR"  "OR>" 
                               "<XOR" "XOR>" "<NOT" "NOT>")
                           )
                      )
                 )
            )
          (setq lisp_pos (1- i))
          (setq lisp_pos i)
        )
      )
    )
    ; join lisp lists
    (setq i 0)
    (setq str1 '()) (setq str2 '())
    (if (<= 0 lisp_pos)
      (progn 
        (while (< i lisp_pos)
          (setq str1 (cons (nth i filter_lisp_list) str1))   
          (setq i (1+ i))
        )
        (setq str1 (reverse str1))
        (setq temp_str (reverse filter_lisp_list))
        (setq i 0)
        (while (<= i (- (- (length filter_lisp_list) lisp_pos) 1))
          (setq str2 (cons (nth i temp_str) str2))   
          (setq i (1+ i))
        )
      )
    )
    (setq filter_lisp_list (append str1 new_lisp str2))
    (setq ai_lisp|*unnamed filter_lisp_list)
    ; join string lists
    (setq i 0)
    (setq str1 '()) (setq str2 '())
    (while (< i str_pos)
      (setq str1 (cons (nth i filter_str_list) str1))   
      (setq i (1+ i))
    )
    (setq str1 (reverse str1))
    (setq temp_str (reverse filter_str_list))
    (setq i 0)
    (while (<= i (- (- (length filter_str_list) str_pos) 1))
      (setq str2 (cons (nth i temp_str) str2))   
      (setq i (1+ i))
    )
    (setq filter_str_list (append str1 new_str str2))
    (setq ai_str|*unnamed filter_str_list)
    ; Update displayed string list
    (start_list "filter_str_list")
    (mapcar 'add_list filter_str_list)
    (end_list)
    (setq new_length (length new_str))   ; length of new string list.
    (cond
     ((/= (1- (length filter_str_list)) str_pos)
       (set_tile "filter_str_list" 
                 (itoa (setq str_pos (+ str_pos new_length)))
       )
     )
     ((and (= (1- (length filter_str_list)) str_pos)
           (/= 1 (length filter_str_list))
      )
       (set_tile "filter_str_list" (itoa (1- str_pos)))
     )
     (T)
    )
  )
  ;;
  ;; Disables the controls when an filter is chosen from the list of possible 
  ;; filters
  ;;
  (defun grey_filter ( )
    (setq pick (nth (atoi (get_tile "filter_by")) filter_list_english)) ;Added for loc.
    (enable_disable pick)
  )
  ;;
  ;; Disables the controls according to current selection.
  ;;
  (defun enable_disable(string)
    ;; Localization fix
    (setq tstr string)
    (if (not (setq string (loc_to_en tstr))) (setq string tstr))
    ;; Debug
    ;; (princ "DEBUG> string is: ") (princ string) (princ "\n")
    
    (cond 
      ((member string '(
                      "Arc" "Attribute" "Block" "Circle" "Dimension" "Ellipse" "Hatch"
                      "Image" "Line" "MultiLine" "Point" "Polyline" "Ray" "Region"
                      "Shape"  "Solid" "3D Solid" "Spline" "Trace" "3dface"
                      "Viewport" "Xline"  "Text" "Leader" "Tolerance" "Body"
                       "** Begin  AND" "** End    AND"
                       "** Begin  OR"  "** End    OR"
                       "** Begin  XOR" "** End    XOR"
                       "** Begin  NOT" "** End    NOT"                      
       ))
       (mode_tile "x_op" 1) (mode_tile "x_value" 1) (mode_tile "x_text" 1)
       (mode_tile "y_op" 1) (mode_tile "y_value" 1) (mode_tile "y_text" 1)
       (mode_tile "z_op" 1) (mode_tile "z_value" 1) (mode_tile "z_text" 1)
       (mode_tile "select" 1)
      )
      ((member string '(
                       "Arc Center"
                       "Attribute Position"
                       "Block Position"
                       "Circle Center"
                       "Ellipse Center"
                       "Image Position"
                       "Line Start" "Line End"
                       "Point Position" 
                       "Shape Position"
                       "Solid Point 1" 
                       "Solid Point 2" 
                       "Solid Point 3" 
                       "Solid Point 4"
                       "Text Position"
                       "Trace Point 1" 
                       "Trace Point 2" 
                       "Trace Point 3" 
                       "Trace Point 4"
                       "3dface Point 1" 
                       "3dface Point 2" 
                       "3dface Point 3" 
                       "3dface Point 4"
                       "Viewport Center"
                       )
       )
        (mode_tile "x_op" 0) (mode_tile "x_value" 0) (mode_tile "x_text" 0)
        (mode_tile "y_op" 0) (mode_tile "y_value" 0) (mode_tile "y_text" 0)
        (mode_tile "z_op" 0) (mode_tile "z_value" 0) (mode_tile "z_text" 0)
        (mode_tile "select" 1)
      )
      ((member string '(
                       "Elevation" 
                       "Thickness"
                       "Arc Radius"
                       "Block X Scale" 
                       "Block Y Scale" 
                       "Block Z Scale"
                       "Block Rotation"
                       "Circle Radius"
                       "Linetype Scale"
                       "Text Height" 
                       "Text Rotation"
                       )
       )
        (mode_tile "x_op" 0) (mode_tile "x_value" 0) (mode_tile "x_text" 0)
        (mode_tile "y_op" 1) (mode_tile "y_value" 1) (mode_tile "y_text" 1)
        (mode_tile "z_op" 1) (mode_tile "z_value" 1) (mode_tile "z_text" 1)
        (mode_tile "select" 1)
      )
      ((member string '(
                       "Color"                    
                       )
       )
        (mode_tile "x_op" 0) (mode_tile "x_value" 0) (mode_tile "x_text" 0)
        (mode_tile "y_op" 1) (mode_tile "y_value" 1) (mode_tile "y_text" 1)
        (mode_tile "z_op" 1) (mode_tile "z_value" 1) (mode_tile "z_text" 1)
        (mode_tile "select" 0)
	      )
      ((member string '(
                       "Dimension Type" 
                       "Polyline Flags"
                       "Viewport Status"                   
                       )
       )
        (mode_tile "x_op" 0) (mode_tile "x_value" 0) (mode_tile "x_text" 0)
        (mode_tile "y_op" 1) (mode_tile "y_value" 1) (mode_tile "y_text" 1)
        (mode_tile "z_op" 1) (mode_tile "z_value" 1) (mode_tile "z_text" 1)
        (mode_tile "select" 1)
      )
      ((member string '(
                       "Attribute Tag"  
                       "Text Value"  
                       "Shape Name"
                       "MultiLine Style"
                       "Hatch Pattern Name"
                       )
       )
        (mode_tile "x_op" 1) (mode_tile "x_value" 0) (mode_tile "x_text" 0)
        (mode_tile "y_op" 1) (mode_tile "y_value" 1) (mode_tile "y_text" 1)
        (mode_tile "z_op" 1) (mode_tile "z_value" 1) (mode_tile "z_text" 1)
        (mode_tile "select" 1)
      )
      ((member string '(
                       "Block Name" 
                       "Dimension Style" 
                       "Layer" 
                       "Linetype" 
                       "Text Style Name" 
                       "Xdata ID"
                       )
       )       
        (mode_tile "x_op" 1) (mode_tile "x_value" 0) (mode_tile "x_text" 0)
        (mode_tile "y_op" 1) (mode_tile "y_value" 1) (mode_tile "y_text" 1)
        (mode_tile "z_op" 1) (mode_tile "z_value" 1) (mode_tile "z_text" 1)
        (mode_tile "select" 0)
      )
      ((member string '(
                       "Normal Vector"
                       )
       )       
        (mode_tile "x_op" 0) (mode_tile "x_value" 0) (mode_tile "x_text" 0)
        (mode_tile "y_op" 0) (mode_tile "y_value" 0) (mode_tile "y_text" 0)
        (mode_tile "z_op" 0) (mode_tile "z_value" 0) (mode_tile "z_text" 0)
        (mode_tile "select" 1)
      )
    )
  )
  ;;
  ;; Add the selected filter, operator, and value to list.
  ;;
  (defun add_to_list (/ gc_name op val str_val)
    (setq str_pos (atoi (get_tile "filter_str_list")))  ; item in string list.
    (setq op nil)(setq val nil)(setq str_val nil)
    (setq gc_name (nth (atoi (get_tile "filter_by")) filter_list))

    ;Begining of translation part.
    (setq LOCGC gc_name)
    (setq gc_name (loc_to_en LOCGC))
    ; This is for DEBUGING (princ "JMC En ingles es::::> ")(princ gc_name)
    ; End of new part.

    (check4object_need gc_name ) ;@rk0 
  
    (cond
      ((member gc_name '(
                        "Arc Center"
                        "Attribute Position"
                        "Block Position"
                        "Circle Center"
                        "Ellipse Center"
                        "Image Position"
                        "Line Start"         
                        "Line End"
                        "Point Position" 
                        "Shape Position"
                        "Text Position"
                        "Viewport Center"
                        )
       )     
        (setq op (cons -4 (strcat 
                            (setq x_op (nth (atoi (get_tile "x_op")) ri_ops)) 
                            ","
                            (setq y_op (nth (atoi (get_tile "y_op")) ri_ops)) 
                            ","
                            (setq z_op (nth (atoi (get_tile "z_op")) ri_ops))
                           )
                  )
        )
        (cond
          ((not (setq x_value 
                      (ai_num (get_tile "x_value") "Invalid X coordinate." 0)
                )
           )
           (mode_tile "x_value" 2)
          )
          ((not (setq y_value 
                      (ai_num (get_tile "y_value") "Invalid Y coordinate." 0)
                )
           )
           (mode_tile "y_value" 2)
          )
          ((not (setq z_value 
                      (ai_num (get_tile "z_value") "Invalid Z coordinate." 0)
                )
           )
           (mode_tile "z_value" 2)
          )
          (T (setq val 
                   (list 
                         (nth (what_pos gc_name filter_list_english) filter_gc) ;Added for loc. 
                         x_value 
                         y_value 
                         z_value
                   )
             )
             (setq GCLOC (en_to_loc gc_name)) ;Added for loc.
	     (setq str_val (strcat GCLOC "\tX\t" x_op "\t" (ai_rtos x_value)
                                           "\tY\t" y_op "\t" (ai_rtos y_value)
                                           "\tZ\t" z_op "\t" (ai_rtos z_value)
                           )
             )
          )
        )
      )
      ((member gc_name '("Normal Vector"))
        (setq op (cons -4 (setq x_op (nth (atoi (get_tile "x_op")) ri_ops))))
        (cond
          ((not (setq x_value 
                      (ai_num (get_tile "x_value") "Invalid X coordinate." 0)
                )
           )
           (mode_tile "x_value" 2)
          )
          ((not (setq y_value 
                      (ai_num (get_tile "y_value") "Invalid Y coordinate." 0)
                )
           )
           (mode_tile "y_value" 2)
          )
          ((not (setq z_value 
                      (ai_num (get_tile "z_value") "Invalid Z coordinate." 0)
                )
           )
           (mode_tile "z_value" 2)
          )
          (T (setq val (list 
                             (nth (what_pos gc_name filter_list_english) filter_gc) 
                             x_value 
                             y_value 
                             z_value
                       )
             )
	     (setq GCLOC (en_to_loc gc_name)) ; Added for loc.
             (setq str_val (strcat GCLOC     "\tX\t" x_op "\t" (ai_rtos x_value) 
                                               "\tY\t" x_op "\t" (ai_rtos y_value)
                                               "\tZ\t" x_op "\t" (ai_rtos z_value)
                           )
             )
          )
        )
      )
      ((member gc_name '(
                          "Elevation" 
                          "Thickness"
                          "Arc Radius"
                          "Block X Scale"   
                          "Block Y Scale" 
                          "Block Z Scale"
                          "Circle Radius"
                          "Linetype Scale"
                          "Text Height"    
                        )
       )
        
             
        (setq op (cons -4 (setq x_op (nth (atoi (get_tile "x_op")) ri_ops))))
        (cond
          ((not (setq x_value 
                      (ai_num (get_tile "x_value") "Invalid number." 0)
                )
           )
           (mode_tile "x_value" 2)
          )
          (T (setq val 
                   (cons (nth (what_pos gc_name filter_list_english) filter_gc) 
                         x_value
                   )
             )
             (setq GCLOC (en_to_loc gc_name)) ;Added for loc.
             (setq str_val (strcat GCLOC  "\t\t" x_op "\t" (ai_rtos x_value)))
          )
        )
      )
      ((member gc_name '(
                          "Block Rotation"
                          "Text Rotation"
                        )
       )     
        (setq op (cons -4 (setq x_op (nth (atoi (get_tile "x_op")) ri_ops))))
        (cond
          ((not (setq x_value 
                      (ai_angle (get_tile "x_value") "Invalid angle.")
                )
           )
           (mode_tile "x_value" 2)
          )
          (T (setq val 
                   (cons (nth (what_pos gc_name filter_list_english) filter_gc) 
                         (angtof (get_tile "x_value") (getvar "aunits"))
                   )
             )
	     (setq GCLOC (en_to_loc gc_name)) ; Added for loc.
              (setq str_val (strcat GCLOC  "\t\t" x_op "\t" (get_tile "x_value") ))
          )
        )
      )
      ((member gc_name '(
                         "Color" 
                        )
       )
        (setq op (cons -4 (setq x_op (nth (atoi (get_tile "x_op")) ri_ops))))
        (cond
          ((not (setq x_value 
                      (check_color (get_tile "x_value"))
                )
           )
           (mode_tile "x_value" 2)
          )
          (T (setq val 
                   (cons (nth (what_pos gc_name filter_list_english) filter_gc) 
                         x_value
                   )
             )
             (cond 
               ((= 0 x_value)   (setq x_value "0 - By Block"))
               ((= 1 x_value)   (setq x_value "1 - Red"))
               ((= 2 x_value)   (setq x_value "2 - Yellow"))
               ((= 3 x_value)   (setq x_value "3 - Green"))
               ((= 4 x_value)   (setq x_value "4 - Cyan"))
               ((= 5 x_value)   (setq x_value "5 - Blue"))
               ((= 6 x_value)   (setq x_value "6 - Magenta"))
               ((= 7 x_value)   (setq x_value "7 - White"))
               ((= 256 x_value) (setq x_value "256 - By Layer"))
               (t (setq x_value (itoa x_value)))
             )
             (setq GCLOC (en_to_loc gc_name)) ; Added for loc.
             (setq str_val (strcat GCLOC "\t\t" x_op "\t" x_value))
          )
        )
      )
      ((member gc_name '(
                          "Attribute Tag" 
                          "Block Name" 
                          "Dimension Style" 
                          "Layer" 
                          "Linetype" 
                          "Shape Name"
                          "Text Value" 
                          "Text Style Name" 
                          "MultiLine Style"
                          "Hatch Pattern Name"
                        )
       )
        (cond
          ((= "" (setq x_value (ai_strtrim (get_tile "x_value"))))
            (mode_tile "x_value" 2)
          )
          (T (setq val 
                   (cons (nth (what_pos gc_name filter_list_english) filter_gc) 
                         x_value
                   )
             )
	         (setq GCLOC (en_to_loc gc_name))
             (setq str_val (strcat GCLOC "\t\t=\t" x_value))
          )
        )
      )
      ((member gc_name '("Xdata ID"))
        (cond
          ((= "" (setq x_value (ai_strtrim (get_tile "x_value"))))
            (mode_tile "x_value" 2)
          )
          (T (setq val 
                     (cons 
                       (nth (what_pos gc_name filter_list_english) filter_gc) 
                       (list (list x_value))
                     )
             )
	     (setq GCLOC (en_to_loc gc_name))
             (setq str_val (strcat GCLOC "\t\t=\t" x_value))
          )
        )
      )
      ((member gc_name '(
                        "Arc" "Circle" "Dimension" "Line" "Point" "Polyline"
                        "Shape" "Solid" "Trace" "3dface" "Viewport" "Ellipse"
                        "Ray" "Region" "Xline" "Spline" "Tolerance" "Leader"
                        "Body" "Hatch" "Image"
                        )
       )
        (setq val (cons 0 gc_name))
        (setq str_val (strcat "Object         \t\t=\t" LOCGC)) 
      )
      ((member gc_name '(
                         "Attribute"  
                        )
       )
        (setq val (cons 0 "ATTDEF"))
        (setq str_val (strcat "Object         \t\t=\t" LOCGC)) 
      )
      ((member gc_name '(
                         "Block" 
                        )
       )
        (setq val (cons 0 "INSERT"))
        (setq str_val (strcat "Object         \t\t=\t" LOCGC)) 
      )
      ((member gc_name '(
                         "MultiLine"
                        )
       )
        (setq val (cons 0 "MLINE"))
        (setq str_val (strcat "Object         \t\t=\t" LOCGC))
      )
      ((member gc_name '(
                         "3D Solid"
                        )
       )
        (setq val (cons 0 "3DSOLID"))
        (setq str_val (strcat "Object         \t\t=\t" LOCGC))
      )
      ;; Text and MText
      ((member gc_name '(
                         "Text"
                        )
       )
        (setq val (cons 0 "*TEXT"))
        (setq str_val (strcat "Object         \t\t=\t" LOCGC))
      )
      ((member gc_name '(
                        "** Begin  AND"  "** End    AND"
                        "** Begin  OR"   "** End    OR"
                        "** Begin  XOR"  "** End    XOR"
                        "** Begin  NOT"  "** End    NOT"
                        )
       )
        (setq val (cons -4  (nth (what_pos gc_name filter_list_english) filter_gc)))
	(setq GCLOC (en_to_loc gc_name))
        (setq str_val (strcat GCLOC "\t")) 
      )
      (T)
    )
    (cond 
      ((and op val str_val)
        (update (list str_val) (list op val))
        (set_tile "named_lists" "0")
      )
      ((and val str_val)
        (update (list str_val) (list val))
        (set_tile "named_lists" "0")
      )
      (T)
    )


  )
  ;;
  ;; Check if value passed is a valid color integer.  If valid, return the 
  ;; integer, else nil.
  ;;
  (defun check_color(value)
    (if (or (wcmatch value "*@*,*.*")  ;  alphabetic or nonalphanumeric.
             (>  0 (distof value))
             (<  256 (distof value))
        )
      (progn (set_tile "error" "Invalid Color number.") nil)
      (atoi value) 
    )
  )
  ;;
  ;; Check if value passed is an integer.  If valid, return the integer, else
  ;; nil.
  ;;
  (defun check_int(value)
    (if (and (wcmatch value "*@*,*.*")  ;  
             (<= 0 value)
             (<  256 value))
      (progn (set_tile "error" "Invalid Color number.") nil)
      (atoi value) 
    )
  )
  ;;
  ;; Pass an item and a list and recieve a number showing it's position in  
  ;; the list, nil otherwise.  Item must be in the list, and the list must 
  ;; contain unique names. 0 if first item.                               
  ;;
  (defun what_pos (item the_list / pos)
    (setq pos (- (length the_list)
                 (length (member item the_list)))
    )          
  )
  ;;
  ;; Remove item from English and Lisp lists.
  ;;
  (defun remove()
    (setq str_pos (atoi (get_tile "filter_str_list")))  ; item in string list.
    (if (/= (1- (length filter_str_list)) str_pos) ; don't remove the blank 
      (progn
        ; strip 1 item from string list
        (setq filter_str_list (rm_item str_pos filter_str_list))
        (setq ai_str|*unnamed filter_str_list)
        (setq i -1)
        (setq edit_this -1)        ; corresponding item in lisp list.
        (while (< edit_this str_pos)  ; until they are equal
          (setq i (1+ i))
          (if (not (and (= -4 (car (nth i filter_lisp_list)))  
                        (not (member (cdr (nth i filter_lisp_list)) 
                                  '("<AND" "AND>" "<OR"  "OR>" 
                                    "<XOR" "XOR>" "<NOT" "NOT>")
                             )
                        )
                   )
              )
            (setq edit_this (1+ edit_this))        
          )
        )
        (setq filter_lisp_list (rm_item i filter_lisp_list))
        (setq ai_lisp|*unnamed filter_lisp_list)
        (set_tile "named_lists" "0")
        (if (and (< 0 i) 
                 (and (= -4 (car (nth (1- i) filter_lisp_list)))   
                      (not (member (cdr (nth (1- i) filter_lisp_list)) 
                                  '("<AND" "AND>" "<OR"  "OR>" 
                                    "<XOR" "XOR>" "<NOT" "NOT>")
                           )
                      )
                 )
            )
          (progn
            (setq filter_lisp_list (rm_item (1- i) filter_lisp_list))
            (setq ai_lisp|*unnamed filter_lisp_list)
          )
        )
        (if (= 1 remove_flag)   ; only redisplay if remove, not with substitute
          (progn 
            (start_list "filter_str_list")
            (mapcar 'add_list filter_str_list)
            (end_list)
            ;; set highlight after removing item unless it's a blank list.
            (cond
              ((/= (1- (length filter_str_list)) str_pos)
                (set_tile "filter_str_list" (itoa str_pos))
              )
              ((and (= (1- (length filter_str_list)) str_pos)
                    (/= 1 (length filter_str_list))
               )
                (set_tile "filter_str_list" (itoa (1- str_pos)))
              )
              (T)
            )
          )
        )
      )
    )
  )
  ;;
  ;; Pass a number and a list and recieve the list back with that item missing.
  ;;
  (defun rm_item (value the_list)
    (setq temp_lisp_list '())
    (setq j 0)
    (foreach n the_list
      (if (/= value j)
        (setq temp_lisp_list (cons n temp_lisp_list))
      )
      (setq j (1+ j))
    )
    (setq temp_lisp_list (reverse temp_lisp_list))
  )
  ;;
  ;;  Get the fields of the highlighted item and place them in the edit area.
  ;;
  (defun do_edit()
    (setq edit_item (atoi (get_tile "filter_str_list")))  ;item in string list.
    (if (/= "" (nth edit_item filter_str_list)) 
      (progn 
        (setq i -1)
        (setq edit_this -1)        ; corresponding item in lisp list.
        (while (< edit_this edit_item)  ; until they are equal
          (setq i (1+ i))
          (if (not (and (= -4 (car (nth i filter_lisp_list)))  
                        (not (member (cdr (nth i filter_lisp_list)) 
                                    '("<AND" "AND>" "<OR"  "OR>"
                                      "<XOR" "XOR>" "<NOT" "NOT>")
                             )
                        )
                   )
              )
            (setq edit_this (1+ edit_this))   
          )
        )
        (setq gc_name (nth edit_item filter_str_list))
        (setq a 1)
        (while (/= "\t" (substr gc_name a 1))
          (setq a (1+ a))
        )
        (setq str_name (substr gc_name 1 (1- a)))
        (setq j 1)(setq ws nil)
        (cond 
          ((member (car (nth i filter_lisp_list)) '(-4 -3 1 2 3 6 7 8 38 39 40
                                                    41 43 44 45 48 50 51 62 66
                                                    70 71 10 11 12 13 14 15 
                                                    16 210))
            (set_tile "filter_by" 
                      (itoa (- (length filter_list) 
                               (length (member str_name filter_list))
                            )
                      )
            )
          )
          ((member (car (nth i filter_lisp_list)) '(0))
            ;; HACK  -- when the item is an Object, str_name is set to LINE
            ;; thereby forcing the correct fields to be disabled by 
            ;; (enable_disable).  This string does not need to be translated.
            ;; The alternative is to add a translatable string "Object" or
            ;; fix str_name to be the object name rather than "Object".
            (setq str_name "Line")
            (cond
              ((= "ATTDEF" (cdr (nth i filter_lisp_list)))
                (set_tile "filter_by" 
                          (itoa (what_pos "Attribute" filter_list))
                )
              )
              ((= "INSERT" (cdr (nth i filter_lisp_list)))
                (set_tile "filter_by" (itoa (what_pos "Block" filter_list)))
              )
              ((= "MLINE" (cdr (nth i filter_lisp_list)))
                (set_tile "filter_by" (itoa (what_pos "MultiLine" filter_list)))
              )
              ((= "3DSOLID" (cdr (nth i filter_lisp_list)))
                (set_tile "filter_by" (itoa (what_pos "3D Solid" filter_list)))
              )
              ((= "*TEXT" (cdr (nth i filter_lisp_list)))
                (set_tile "filter_by" (itoa (what_pos "Text" filter_list)))
              )
              (T
                (set_tile "filter_by" 
                          (itoa (- (length filter_list)
                                   (length 
                                     (member 
                                       (strcat 
                                         (substr 
                                           (cdr (nth i filter_lisp_list)) 
                                           1 1
                                         )
                                         (strcase 
                                           (substr 
                                             (cdr (nth i filter_lisp_list)) 
                                             2
                                           ) 
                                           T
                                         )   
                                       )      
                                       filter_list
                                     )
                                   )
                                )
                          )
                    )
                )
            )
          )
          (T (princ "Error in setting by_filter - group code missing"))
        )
        (enable_disable str_name)
        (cond 
          ((member (car (nth i filter_lisp_list)) '(10 11 12 13 14 15 16))
            (set_tile "x_value" (ai_rtos (cadr (nth i filter_lisp_list))))
            (set_tile "y_value" (ai_rtos (caddr (nth i filter_lisp_list))))
            (set_tile "z_value" (ai_rtos (cadddr (nth i filter_lisp_list))))
            (setq ops_3 (cdr (nth (1- i) filter_lisp_list)))
            (setq j 1)
            (setq c1 nil) (setq c2 nil)
            (while (<= j (strlen ops_3))
              (cond 
                ((and (= "," (substr ops_3 j 1))
                      (= nil c1)) 
                  (setq c1 j)
                )
                ((and (= "," (substr ops_3 j 1))
                      (/= nil c1)) 
                  (setq c2 j)
                )
              )
              (setq j (1+ j))
            )
            (set_tile "x_op" 
                      (ai_rtos (- (length ri_ops) 
                               (length 
                                 (member (substr ops_3 1 (- c1 1)) ri_ops))
                               )
                      )
            ) 
            (set_tile "y_op" 
                      (ai_rtos (- (length ri_ops) 
                               (length 
                                 (member 
                                   (substr ops_3 (1+ c1) (1- (- c2 c1))) 
                                   ri_ops
                                 )
                               )
                            )
                      )        
            ) 
            (set_tile "z_op" 
                      (ai_rtos (- (length ri_ops) 
                               (length (member (substr ops_3 (1+ c2)) ri_ops))
                            )
                      )
            )  
          )
          ((member (car (nth i filter_lisp_list)) '(210))
            (set_tile "x_value" (ai_rtos (cadr (nth i filter_lisp_list))))
            (set_tile "y_value" (ai_rtos (caddr (nth i filter_lisp_list))))
            (set_tile "z_value" (ai_rtos (cadddr (nth i filter_lisp_list))))
            (set_tile "x_op" 
                      (ai_rtos (- (length ri_ops)
                               (length 
                                 (member 
                                   (cdr (nth (- i 1) filter_lisp_list)) 
                                   ri_ops
                                 )
                               )
                            )
                      )
            )   
          )
          ((member (car (nth i filter_lisp_list)) '(50))  
            (set_tile "x_value" (ai_angtos (cdr (nth i filter_lisp_list))))
            (set_tile "x_op" 
                      (ai_rtos (- (length ri_ops)
                               (length 
                                 (member 
                                   (cdr (nth (- i 1) filter_lisp_list)) 
                                   ri_ops
                                 )
                               )
                            )
                      )
            )          
          )
          ((member (car (nth i filter_lisp_list)) '(38 39 40 41 44 45 48 51))  
            (set_tile "x_value" (ai_rtos (cdr (nth i filter_lisp_list))))
            (set_tile "x_op" 
                      (ai_rtos (- (length ri_ops)
                               (length 
                                 (member 
                                   (cdr (nth (- i 1) filter_lisp_list)) 
                                   ri_ops
                                 )
                               )
                            )
                      )
            )          
          )
          ((member (car (nth i filter_lisp_list)) '(66 70 71))      ; integers
            (set_tile "x_value" (itoa (cdr (nth i filter_lisp_list))))
            (set_tile "x_op" 
                      (ai_rtos (- (length ri_ops)
                               (length 
                                 (member 
                                   (cdr (nth (- i 1) filter_lisp_list)) 
                                   ri_ops
                                 )
                               )
                            )
                      )
            )    
          )
          ((member (car (nth i filter_lisp_list)) '(62))      ;  Color
            (set_tile "x_value" (itoa (cdr (nth i filter_lisp_list))))
            (set_tile "x_op" 
                      (ai_rtos (- (length ri_ops)
                               (length 
                                 (member 
                                   (cdr (nth (- i 1) filter_lisp_list)) 
                                   ri_ops
                                 )
                               )
                            )
                      )
            )   
          )
          ((member (car (nth i filter_lisp_list)) '(2 3 5))    ; strings
            (set_tile "x_value" (cdr (nth i filter_lisp_list)))
          )
          ((member (car (nth i filter_lisp_list)) '(6 7 8))    ;  table strings
            (set_tile "x_value" (cdr (nth i filter_lisp_list)))
          )
          ((member (car (nth i filter_lisp_list)) '(-3))       ; xdata
            (set_tile "x_value" (caadr (nth i filter_lisp_list)))
          )
          ((member (car (nth i filter_lisp_list)) '(0))    ; 0 code is special
          )
          ((member (car (nth i filter_lisp_list)) '(-4))   ; -4 code is special
          )
        )
      )
    )
  )
  ;;
  ;; Clears the list.
  ;;
  (defun clear_list()
    (setq filter_lisp_list '())
    (setq filter_str_list '(""))
    (setq str_pos 0)
    (setq ai_lisp|*unnamed filter_lisp_list)
    (setq ai_str|*unnamed filter_str_list)
    (set_tile "named_lists" "0")
    (start_list "filter_str_list")
    (mapcar 'add_list filter_str_list)
    (end_list)
  )
  ;;
  ;;  Hide the dialogue, allow user selection of an entity, get the relevant
  ;;  information, translate to English, add both Lisp and English to relevant
  ;;  lists at current cursor position.
  ;;
  (defun get_entity()
    (setq entity_lisp '())
    (if (setq entity_ename (entsel))
      (progn
        (setq entity_lisp_init (cdr (entget (car entity_ename) (list "*"))))
        (setq entity_type (cdar entity_lisp_init))
        (cond 
          ((= entity_type "ARC")            (do_arc))
          ((= entity_type "BODY")           (do_body))
          ((= entity_type "CIRCLE")         (do_circle))
          ((= entity_type "DIMENSION")      (do_dimension))
          ((= entity_type "ELLIPSE")        (do_ellipse))
          ((= entity_type "IMAGE")          (do_image))
          ((= entity_type "INSERT")         (do_block))
          ((= entity_type "LEADER")         (do_leader))
          ((= entity_type "LINE")           (do_line))
          ((= entity_type "MLINE")          (do_mline))
          ((= entity_type "POINT")          (do_point))
          ((= entity_type "POLYLINE")       (do_Polyline))
          ((= entity_type "LWPOLYLINE")     (do_Polyline))
          ((= entity_type "RAY")            (do_ray))
          ((= entity_type "REGION")         (do_region))
          ((= entity_type "SHAPE")          (do_shape))
          ((= entity_type "SOLID")          (do_solid))
          ((= entity_type "3DSOLID")        (do_solids))
          ((= entity_type "SPLINE")         (do_spline))
          ((= entity_type "TEXT")           (do_text))
          ((= entity_type "MTEXT")          (do_text))
          ((= entity_type "ATTDEF")         (do_attdef))
          ((= entity_type "TOLERANCE")      (do_tolerance)) 
          ((= entity_type "TRACE")          (do_trace))
          ((= entity_type "3DFACE")         (do_3dface))
          ((= entity_type "VIEWPORT")       (do_viewport))
          ((= entity_type "XLINE")          (do_xline))
          (T (princ "\nObject not supported."))
        )
        (update (lts entity_lisp 0) entity_lisp_list)
      )
    )
  )
  ;;
  ;;  Arc
  ;;
  (defun do_arc()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Arc"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 10  (car n)) (group_10 "Arc Center"))
        ((= 40  (car n)) (group_40 "Arc Radius"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
        (t)
      )
    )
  )
  ;;
  ;;  Attribute Definition.
  ;;
  (defun do_attdef()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Attribute"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 2   (car n)) (group_8  "Attribute Tag"))
        ((= 10  (car n)) (group_10 "Attribute Position"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  Insert Entity aka block
  ;;
  (defun do_block()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Block"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 2   (car n)) (group_8  "Block Name"))
        ((= 10  (car n)) (group_10 "Block Position"))
        ((= 50  (car n)) (group_50 "Block Rotation"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;; Circle
  ;;
  (defun do_circle()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Circle"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 10  (car n)) (group_10 "Circle Center"))
        ((= 40  (car n)) (group_40 "Circle Radius"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  Dimension
  ;;
  (defun do_dimension()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Dimension"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 3   (car n)) (group_8   "Dimension Style"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  Ellipse
  ;;
  (defun do_ellipse()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Ellipse"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 10  (car n)) (group_10 "Ellipse Center"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  Image
  ;;
  (defun do_image()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Image"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 10  (car n)) (group_10 "Image Position"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  Line
  ;;
  (defun do_line()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Line"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 10  (car n)) (group_10 "Line Start"))
        ((= 11  (car n)) (group_10 "Line End"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  MultiLine
  ;;
  (defun do_mline()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "MultiLine"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 2   (car n)) (group_8  "MultiLine Style"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
    (std_linetype)
  )
  ;;
  ;;  Point
  ;;
  (defun do_point()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Point"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 10  (car n)) (group_10 "Point Position"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  Hatch
  ;;
  (defun do_hatch()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Hatch"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 2   (car n)) (group_8  "Hatch Pattern Name"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  Polyline
  ;;
  (defun do_Polyline()
    (if (equal (cdr (assoc 0 entity_lisp_init)) "LWPOLYLINE")
      (setq entity_lisp_init(subst (cons 0 "POLYLINE") (cons 0 "LWPOLYLINE") entity_lisp_init))
      (progn
        (if (/= (cadddr (assoc 10 entity_lisp_init)) 0.0)
            (setq entity_lisp_init (append entity_lisp_init (list(cons 38 (cadddr (assoc 10 entity_lisp_init))))))
        )
      )
    )

    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Polyline"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  Ray
  ;;
  (defun do_ray()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Ray"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
    (std_color_linetype)
  )
  ;;
  ;;  Tolerance
  ;;
  (defun do_tolerance()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Tolerance"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
    (std_color_linetype)
  )
  ;;
  ;;  Leader
  ;;
  (defun do_leader()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Leader"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
    (std_color_linetype)
  )
  ;;
  ;;  Region
  ;;
  (defun do_region()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Region"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
    (std_color_linetype)
  )
  ;;
  ;;  Shape
  ;;
  (defun do_shape()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Shape"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 10  (car n)) (group_10 "Shape Position"))
        ((= 2   (car n)) (group_8  "Shape Name"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  Solid
  ;;
  (defun do_solid()
    (foreach n entity_lisp_init
      (cond 
        ((= 0   (car n)) (group_0  "Solid"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210)) 
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  Solid Body
  ;;
  (defun do_solids()
    (foreach n entity_lisp_init
      (cond
        ((= 0   (car n)) (group_0  "3D Solid"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210))
        ((= -3  (car n)) (group_-3))
      )
    )
    (std_color_linetype)
  )
  ;;
  ;;  Spline
  ;;
  (defun do_spline()
    (foreach n entity_lisp_init
      (cond
        ((= 0   (car n)) (group_0  "Spline"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210))
        ((= -3  (car n)) (group_-3))
      )
    )
    (std_color_linetype)
  )
  ;;
  ;;  Text
  ;;
  (defun do_text()
    (foreach n entity_lisp_init
      (cond
        ((= 0   (car n)) (group_0  "Text"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 10  (car n)) (group_10 "Text Position"))
        ((= 1   (car n)) (group_8  "Text Value"))
        ((= 7   (car n)) (group_8  "Text Style Name"))
        ((= 40  (car n)) (group_40 "Text Height"))
        ((= 50  (car n)) (group_50 "Text Rotation"))
        ((= 210 (car n)) (group_210))
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;   Trace
  ;;
  (defun do_trace()
    (foreach n entity_lisp_init
      (cond
        ((= 0   (car n)) (group_0  "Trace"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210))
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;   3Dface
  ;;
  (defun do_3dface()
    (foreach n entity_lisp_init
      (cond
        ((= 0   (car n)) (group_0  "3dface"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210))
        ((= -3  (car n)) (group_-3))
      )
    )
    (std_color_linetype)
  )
  ;;
  ;;  Viewport
  ;;
  (defun do_viewport()
    (foreach n entity_lisp_init
      (cond
        ((= 0   (car n)) (group_0  "Viewport"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 39  (car n)) (group_40 "Thickness"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 10  (car n)) (group_10 "Viewport Center"))
        ((= 210 (car n)) (group_210))
        ((= -3  (car n)) (group_-3))
      )
    )
  )
  ;;
  ;;  XLine
  ;;
  (defun do_xline()
    (foreach n entity_lisp_init
      (cond
        ((= 0   (car n)) (group_0  "Xline"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210))
        ((= -3  (car n)) (group_-3))
      )
    )
    (std_color_linetype)
  )
  ;;
  ;;  Body
  ;;
  (defun do_body()
    (foreach n entity_lisp_init
      (cond
        ((= 0   (car n)) (group_0  "Body"))
        ((= 8   (car n)) (group_8  "Layer"))
        ((= 6   (car n)) (group_8  "Linetype"))
        ((= 38  (car n)) (group_40 "Elevation"))
        ((= 62  (car n)) (group_62 "Color"))
        ((= 48  (car n)) (group_40 "Linetype Scale"))
        ((= 210 (car n)) (group_210))
        ((= -3  (car n)) (group_-3))
      )
    )
    (std_color_linetype)
  )
  ;;
  ;;   Group code 0
  ;;
  (defun group_0(label)
    (setq entity_lisp (cons (list "Object \t\t=\t" (en_to_loc label)) entity_lisp))
    (setq entity_lisp_list (list n))
    ;; Added for MText and Text equivalancy.
    (if (or (= label "Text") (= label "MText")) 
      (setq entity_lisp_list (list (cons '0 "*Text")))
    ) 
  )
  ;;
  ;;   Strings
  ;;
  (defun group_8(label)
    (setq entity_lisp (cons (list (en_to_loc label) "\t\t=\t" (cdr n)) entity_lisp))
    (setq entity_lisp_list (reverse (cons n (reverse entity_lisp_list))))
  )
  ;;
  ;;   Coordinate
  ;;
  (defun group_10(label)
    (if (not (assoc 6 entity_lisp_list))
      (progn 
        (setq entity_lisp 
              (cons (list "Linetype\t\t=\t" "BYLAYER") entity_lisp)
        )
        (setq entity_lisp_list 
              (reverse (cons (cons 6 "BYLAYER") (reverse entity_lisp_list)))
        )
      )
    )
    (if (not (assoc 62 entity_lisp_list))
      (progn 
        (setq entity_lisp (cons (list "Color\t\t=\t" "BYLAYER") entity_lisp))
        (setq entity_lisp_list 
              (reverse (cons 
                         (cons 62 256) 
                         (cons (cons -4 "=") (reverse entity_lisp_list))
                       )
               )
        )
      )
    )
    (setq entity_lisp (cons (list (en_to_loc label)
                                   "\tX\t=\t" (ai_rtos (cadr n))
                                   "\tY\t=\t" (ai_rtos (caddr n))
                                   "\tZ\t=\t" (ai_rtos (cadddr n))
                             )
                             entity_lisp))
    (setq entity_lisp_list 
          (reverse 
            (cons n (cons (cons -4 "=,=,=") (reverse entity_lisp_list)))
          )
    )
  )
  ;;
  ;;   Reals
  ;;
  (defun group_40(label)
    (setq entity_lisp (cons (list (en_to_loc label) "\t\t=\t" (ai_rtos (cdr n))) entity_lisp))
    (setq entity_lisp_list 
          (reverse (cons n (cons (cons -4 "=") (reverse entity_lisp_list))))
    )
  )
  ;;
  ;;   Reals
  ;;
  (defun group_50(label)
    (setq entity_lisp (cons (list (en_to_loc label) "\t\t=\t" (ai_angtos (cdr n))) entity_lisp))
    (setq entity_lisp_list 
          (reverse (cons n (cons (cons -4 "=") (reverse entity_lisp_list))))
    )
  )
  ;;
  ;;   Color
  ;;
  (defun group_62(label / str)
    (setq str (cdr n))
    (cond 
      ((= 0 str)   (setq str "0 - By Block"))
      ((= 1 str)   (setq str "1 - Red"))
      ((= 2 str)   (setq str "2 - Yellow"))
      ((= 3 str)   (setq str "3 - Green"))
      ((= 4 str)   (setq str "4 - Cyan"))
      ((= 5 str)   (setq str "5 - Blue"))
      ((= 6 str)   (setq str "6 - Magenta"))
      ((= 7 str)   (setq str "7 - White"))
      ((= 256 str) (setq str "256 - By Layer"))
      (t (setq str (itoa str)))
    )
    (setq entity_lisp (cons (list (en_to_loc label) "\t\t=\t" str) entity_lisp))
    (setq entity_lisp_list 
          (reverse (cons n (cons (cons -4 "=") (reverse entity_lisp_list))))
    )
  )
  ;;
  ;;   Normal Vector
  ;;
  (defun group_210()
    (if (not (assoc 6 entity_lisp_list))
      (progn 
        (setq entity_lisp 
              (cons (list "Linetype\t\t=\t" "BYLAYER") entity_lisp)
        )
        (setq entity_lisp_list 
              (reverse (cons (cons 6 "BYLAYER") (reverse entity_lisp_list)))
        )
      )
    )
    (if (not (assoc 62 entity_lisp_list))
      (progn 
        (setq entity_lisp (cons (list "Color\t\t=\t" "BYLAYER") entity_lisp))
        (setq entity_lisp_list (reverse (cons (cons 62 256) (cons (cons -4 "=") (reverse entity_lisp_list)))))
      ) 
    )
    (setq entity_lisp (cons (list "Normal Vector" 
                                   "\tX\t=\t" (ai_rtos (cadr n))
                                   "\tY\t=\t" (ai_rtos (caddr n))
                                   "\tZ\t=\t" (ai_rtos (cadddr n))
                             )
                             entity_lisp))

   (setq entity_lisp_list 
          (reverse (cons n (cons (cons -4 "=") (reverse entity_lisp_list))))
   )
  )
  ;;
  ;;    Xdata ID
  ;;
  (defun group_-3()
    (setq appid_str "")
    (if (< 1 (length n)) 
      (progn 
        (foreach n1 (cdr n) 
          (setq appid_str (strcat (car n1) "," appid_str))
        )
        (setq appid_str (substr appid_str 1 (1- (strlen appid_str))))
        (setq entity_lisp (cons (list "Xdata ID \t\t=\t" appid_str) entity_lisp))
        (setq entity_lisp_list 
              (reverse 
                (cons (list -3 (list appid_str)) (reverse entity_lisp_list))
              )
        )
      )
    )
  )
  ;;
  ;; Addition of default color and linetype.  Used in group_10 and group_210
  ;;
  (defun std_color_linetype()
    (if (not (assoc 6 entity_lisp_list))
      (progn 
        (setq entity_lisp 
              (cons (list "Linetype\t\t=\t" "BYLAYER") entity_lisp)
        )
        (setq entity_lisp_list 
              (reverse (cons (cons 6 "BYLAYER") (reverse entity_lisp_list)))
        )
      )
    )
    (if (not (assoc 62 entity_lisp_list))
      (progn 
        (setq entity_lisp (cons (list "Color\t\t=\t" "BYLAYER") entity_lisp))
        (setq entity_lisp_list 
              (reverse (cons 
                         (cons 62 256) 
                         (cons (cons -4 "=") (reverse entity_lisp_list))
                       )
               )
        )
      )
    )
  )
  ;;
  ;; Addition of default linetype.  Used by MLine.
  ;;
  (defun std_linetype()
    (if (not (assoc 6 entity_lisp_list))
      (progn 
        (setq entity_lisp 
              (cons (list "Linetype\t\t=\t" "BYLAYER") entity_lisp)
        )
        (setq entity_lisp_list 
              (reverse (cons (cons 6 "BYLAYER") (reverse entity_lisp_list)))
        )
      )
    )
  )
  ;;
  ;; Changes list of lists to list of strings, if bit_flag = 1 return parens.
  ;;
  (defun lts (the_list bit_flag / n n1 dp1 dp2)       
    (setq list_str '())       ; for display in list box.
    (foreach n the_list 
      (cond
        ((= -3 (car n)) 
          (setq str (strcat "( -3" "(" "\"" (caadr n) "\"" "))" ))
        )
        ((/= (type (cdr n)) 'LIST)     ; is it a dotted pair or a list.
          (setq str "")
          (setq dp1 (what_is_it (car n)))  ; broken out for clarity.
          (setq dp2 (what_is_it (cdr n)))
          ; cdrs are strings except for color, elevation, and thickness
          (if (member (car n) '(38 39 40 41 42 43 48 50 51 62))
            (setq str (strcat "(" dp1 " . " dp2 ")"))
            (setq str (strcat "(" dp1 " . " "\"" dp2 "\""  ")"))
          )
        )
        (T
          (setq str "")
          (cond 
            ((= 1 bit_flag)
              (foreach n1 n
                (setq str (strcat str (what_is_it n1) " "))
              )
            )
            ((= 0 bit_flag)
              (foreach n1 n
                (setq str (strcat str (what_is_it n1)))
              )
            )
          )
          ; get rid of last white space
          (if (= 1 bit_flag)
            (setq str (strcat "(" (substr str 1 (- (strlen str) 1)) ")" ))
          )
        )
      )
      (setq list_str (cons str list_str))   
    )
  )
  ;;
  ;;  What type is it ?? 
  ;;
  (defun what_is_it (huh / hmmm)
    (cond  
      ((= (type huh) 'INT)  (setq hmmm (itoa huh)))
      ((= (type huh) 'REAL) (setq hmmm (rtos huh 2 15)))
      ((= (type huh) 'STR)  (setq hmmm huh ))
    ) 
    hmmm      
  )    
  ;;
  ;; Check Lisp list for errors.
  ;;
  (defun lisp_error(/ after_errno temp_ss)
    (setq temp_ss (ssget "_X" filter_lisp_list))
    (setq after_errno (getvar "errno"))
    (cond
      ((= 56 after_errno) 
        (set_tile "error" "Invalid Filter list - Premature end.")
      )
      ((= 57 after_errno) 
        (set_tile "error" "Invalid Filter list - Missing Test Operand.")
      )
       ((= 58 after_errno) 
       (set_tile "error" "Invalid Filter list - Invalid op_code string.")
      )
      ((= 59 after_errno) 
        (set_tile "error" "Invalid Filter list - Empty clause/bad nesting.")
      )
      ((= 60 after_errno) 
        (set_tile "error" "Invalid Filter list - Begin/end clause mismatch.")
      )
      ((= 61 after_errno) 
        (set_tile "error" 
                  "Invalid Filter list - Wrong number of XOR/NOT operands."
        )
      )
      ((= 62 after_errno) 
        (set_tile "error" "Invalid Filter list - Maximum nesting exceeded.")
      )
      ((= 63 after_errno) 
        (set_tile "error" "Invalid Filter list - Invalid group code.")
      )
      ((= 64 after_errno) 
        (set_tile "error" "Invalid Filter list - Invalid string test.")
      )
      ((= 65 after_errno) 
        (set_tile "error" "Invalid Filter list - Invalid vector test.")
      )
      ((= 66 after_errno) 
        (set_tile "error" "Invalid Filter list - Invalid real test.")
      )
      ((= 67 after_errno) 
        (set_tile "error" "Invalid Filter list - Invalid integer test.")
      )
      (t nil)
    )
  )
  ;;
  ;; Puts up dialogue for table selection, returns a list of strings on OK and
  ;; nil on Cancel.
  ;;
  (defun single_table (table_name title / pat what_next selection_list)
    (if (not (new_dialog "single_table" dcl_id)) (exit))
    (setq table_list (ai_table table_name 8)) ; List items in specified table.
    (setq pat "*")                ; Set pattern to all items initially.
    (set_tile "pattern" pat)        ; Set the pattern to *.
    (set_tile "title" title)  ; Set the dialogue title to whatever.
    (pat_match pat "table_match")   

    ;; Define what happens when each button is pressed.
    (action_tile "pattern" 
                 "(set_tile \"error\" \"\")(pat_match (setq pat (xstrcase $value)) \"table_match\")")

    (action_tile "table_match" "(set_tile \"error\" \"\")(make_list)")
	(action_tile "accept" "(check_string_length selection_list)")
    ;; return the selection_list on OK.
    (setq what_next (start_dialog))
    (if (= 1 what_next) selection_list nil)  ; return list on OK
  )
  ;;
  ;; Ensure that the string of all selected items do does exceed 256 (add_list limit)
  ;; 
  (defun check_string_length(selection_list / a)
    (setq a 0)
	; Add up length of all individual strings.
	(foreach n selection_list (setq a (+ a (strlen n))))	
	; Add in the comma seperator.
	(setq a (+ a (length selection_list)))	
	; Post message in errtile if too long.
	(if (< 200 a)
	  (set_tile "error" "Error - Selected items exceed 200 characters.")
	  (done_dialog 1)
	)
  )
  ;;
  ;; Add to Selection List.
  ;;
  (defun make_list (/ item_index string temp_list a)
    (setq selection_list '())     ; initialise list
    (setq string (get_tile "table_match"))
    (setq a 0)
    (while (/= (read string) nil)
      (setq item_index (itoa (read string))) 
      (setq string (substr string (+ 2 (strlen item_index))))
      (setq selection_list 
             (cons (nth (atoi item_index) table_match) selection_list))
      (setq a (1+ a))
    )
    (setq selection_list (reverse selection_list))
;;  Commented out as table_name is not always in the english list.  It's OK
;;  for items such as LAYER whose english name is the same as AutoCAD's 
;;  internal name, but that's not the case for Dimension Style etc.  The
;;  easiest fix is to remove GCCLOC for the message string and just have
;;  a message like "1 selected" but it's too late to remove the (s).  So
;;  no message is posted.
;   (setq GCCLOC (en_to_loc table_name))
;   (set_tile "error" (strcat (itoa a) " " GCCLOC "(s) selected."))
  )
  ;;
  ;; This function displays the table list based on the pattern.
  ;;
  (defun pat_match (pat which_box / which_list a)
    (setq which_list '())
    (setq a 0)
    (foreach n table_list 
      (if (wcmatch n pat) 
        (progn 
          (setq which_list (cons n which_list))
        )
      )
      (setq a (1+ a))
    )    
    ;; Alphabetize the matched list.
    (if (and which_list 
             (< (length which_list) (getvar "maxsort"))
        )
      (setq which_list (acad_strlsort which_list))
    ) 
    (start_list which_box)
    (mapcar 'add_list which_list)
    (end_list)
    (set (read (eval which_box)) which_list)
  )
  ;;
  ;; If an error occurs on reading filter.nfl, it is due to a syntax error 
  ;; introduced by someone editing the file.   
  ;;
  (defun load_error (s)                     
    (princ "\nSyntax error in Named Filter List file.  Delete filter.nfl.")
    (if filter_nfl (close filter_nfl))
    (if old_error (setq *error* old_error))   ; Restore old *error* handler
    (princ)
  )

  ;; 
  ;; Put up the dialogue.
  ;;
  (defun filter_main( / our_dimzin old_error old_cmd)


    ;; Set up error function.
    (setq old_cmd (getvar "cmdecho")    ; save current setting of cmdecho
          old_error  *error*            ; save current error function
          *error* load_error              ; new error function
	  our_dimzin (getvar "dimzin")
    )
    (if (equal (getvar "cmdnames") "")
        (sssetfirst nil nil)
    );if
    (setvar "cmdecho" 0)
    (setvar "dimzin" 0)

    (setq str_pos           nil
          what_next         3
          filter_str_list   '("")
          filter_lisp_list  '()
          all_lisp_list     '("*unnamed")
    )
    (load_log)     ; if there is a file containing named filter lists, load it.

    (setq *error* ai_error)  ; After loading reset error to normal error.

    (init_lists)   ; initialise the big lists.
    (init_lists_english)   ; This is the initialization of English keywords. Added for loc.

    (while (< 1 what_next)             ; loop for hiding dialogue.
      (if (not (new_dialog "filter" dcl_id)) (exit))
      (set_tile "x_value" "0.0000")   ; some default values
      (set_tile "y_value" "0.0000")
      (set_tile "z_value" "0.0000")
      (mode_tile "x_text" 1)(mode_tile "y_text" 1)(mode_tile "z_text" 1)
      (mode_tile "x_op" 1) (mode_tile "x_value" 1)
      (mode_tile "y_op" 1) (mode_tile "y_value" 1)
      (mode_tile "z_op" 1) (mode_tile "z_value" 1)
      (mode_tile "select" 1)

      (start_list "filter_by")           ; the list of possible filters
      (mapcar 'add_list filter_list)
      (end_list)

      (start_list "filter_str_list")     ; the list of chosen filters
      (mapcar 'add_list filter_str_list)
      (end_list)

      (start_list "named_lists")         ; the list of named filter lists
      (mapcar 'add_list all_lisp_list)
      (end_list)
    
      (start_list "x_op")                ; the list of X coordinate filters
      (mapcar 'add_list ri_ops)
      (end_list)

      (start_list "y_op")
      (mapcar 'add_list ri_ops)          ; the list of Y coordinate filters
      (end_list)

      (start_list "z_op")                ; the list of Z coordinate filters
      (mapcar 'add_list ri_ops)
      (end_list)
   
      (if (not str_pos) (setq str_pos 0)) ; position within string list

      (if (not pick)                   ; current selection in possible filters
        (progn 
          (setq pick "Arc")
          (set_tile "filter_by" "0")
        )
        (progn 
          (set_tile "filter_by" (itoa (what_pos pick filter_list)))
          (grey_filter)
        )
      )
      ;; Get the default named list from ai_defaults.
      (if (and (= 3 what_next)
               (setq last_name (cadr (assoc "filter" ai_defaults)))
          )
        (progn
          (if (not (member last_name all_lisp_list))  ; may no longer exist.
            (setq last_name "*unnamed")
          )
          ;; Localization fix
          (if (= last_name "*unnamed") 
               (setq last_name "*unnamed")
          )
          (setq pick_list (what_pos last_name all_lisp_list))
          (set_tile "named_lists" (itoa pick_list))
          (setq filter_str_list (eval (read (strcat "ai_str|" last_name))))
          (setq filter_lisp_list (eval (read (strcat "ai_lisp|" last_name))))
          (start_list "filter_str_list")
          (mapcar 'add_list filter_str_list)
          (end_list)
        )
        (progn
          (setq pick_list 0)
          (set_tile "named_lists" "0") 
          (setq last_name "*unnamed")
        )
      )

      (set_tile "filter_str_list" (itoa str_pos))

      (action_tile "filter_str_list" "(rs_err)(setq str_pos (atoi $value))")
      (action_tile "select_entity"   "(rs_err)(do_select_entity)")
      (action_tile "edit"            "(rs_err)(do_edit)")
      (action_tile "clear_list"      "(rs_err)(clear_list)")
      (action_tile "remove"          "(rs_err)(do_remove)")
      (action_tile "filter_by"       "(rs_err)(grey_filter)")
      (action_tile "select"          "(rs_err)(select)")
      (action_tile "add_to_list"     "(rs_err)(add_to_list)")
      (action_tile "substitute"      "(rs_err)(remove)(add_to_list)")
      (action_tile "apply"           "(if (not (lisp_error))(done_dialog 1))")
      (action_tile "save_as"         "(rs_err)(save_as)")
      (action_tile "named_lists"     "(rs_err)(named_lists)")
      (action_tile "delete_list"     "(rs_err)(delete_list)")
      (action_tile "help"            "(help \"\" \"filter\")")

      (setq what_next (start_dialog))
      (if (= 2 what_next) (get_entity))
    )    
    (if (= 1 what_next) 
      (progn
        ;; Use this name as the default next time.
        (if (not list_name) (setq list_name "*unnamed"))
        (if (assoc "filter" ai_defaults)
          (setq ai_defaults (subst (list "filter" list_name) 
                                   (assoc "filter" ai_defaults)
                                   ai_defaults
                            )
          )
          (setq ai_defaults (cons (list "filter" list_name) ai_defaults))
        )
        (princ "\nApplying filter to selection.  ")

        ;; This is where the main changes needed to be made to support
        ;; lwpolylines transparently. By the time filter gets here,
        ;; the list used by ssget has been constructed. Here we will
        ;; alter the list if a 0 group exists with "POLYLINE" as its cdr
        ;; or if there are 38 or 39 groups included in the list. In
        ;; such cases, the group is replaced with a 'or' surrounded option
        ;; that will pertain to both legacy and lwpolylines.
        (setq list_len (length filter_lisp_list) i 0)
        (setq newtmp nil)
        (while (< i list_len)
          (setq tmp (list (nth i filter_lisp_list)))
          (cond
            ((equal (cdr (assoc 0 tmp)) "POLYLINE")
              (setq tmp(subst (cons 0 "*POLYLINE") (cons 0 "POLYLINE") tmp)))

            ((equal (cdr (assoc 0 tmp)) "Polyline")
              (setq tmp(subst (cons 0 "*POLYLINE") (cons 0 "Polyline") tmp)))

            ((= (caar tmp) 38)
              (setq tmp (list (cons 44 (cdar tmp))(cons 38 (cdar tmp))(cons 10 (list 0.0 0.0 (cdar tmp)))(cons -4 "OR>"))))

            ((= (caar tmp) 39)
              (setq tmp (list (cons 45 (cdar tmp))(cons 39 (cdar tmp))(cons -4 "OR>"))))

            ((= (caar tmp) -4)
              (progn
                (setq tx (+ i 1))
                (setq lookahead (list (nth tx filter_lisp_list)))
                (if (= (caar lookahead) 38)
                    (setq tmp (list (cons -4 "<OR")))
                )
                (if (= (caar lookahead) 39)
                    (setq tmp (list (cons -4 "<OR")))
                )
              ))
		  )
          (setq i (1+ i))
          (if (/= nil tmp)
              (setq newtmp (append newtmp tmp))
          )
        )
        (setq filter_lisp_list newtmp)

        (setq ret_list (ssget filter_lisp_list))
        (princ "\nExiting filtered selection.  ")
      )
    )
    (foreach n all_lisp_list      ; set all named lists to nil
      (if (/= n "*unnamed")
        (progn 
          (set (read (strcat "ai_str|" n)) nil)
          (set (read (strcat "ai_lisp|" n)) nil)
        )
      )
    )
    (setq *error* old_error) 
    (setvar "cmdecho" old_cmd)
    (setvar "dimzin" our_dimzin)
  )

  (cond
     ;(  (not (ai_transd)))                       ; transparent OK
     ;(  (not (ai_acadapp)))                      ; ACADAPP.EXP xloaded?
     (  (not (setq dcl_id (ai_dcl "VCAD_filter"))))  ; is .DCL file loaded?
     (t (filter_main))                          ; proceed!
  )

  ;;;Randy Kintzley 12:48 PM 11/4/98
  ;;;If a command is currently active then return the selection set.
  ;;;If no command is active then use sssetfirst to grip
  ;;;highlight/select the resultant filtered selection set.
  ;;;
  (if (and (= 1 what_next)
           (/= "" (getvar "cmdnames"))
      );and
      ret_list
      (progn
       (if (and (equal (getvar "pickfirst") 1)
                ret_list
                (equal 'PICKSET (type ret_list))
           );and 
           (sssetfirst ret_list ret_list)
       );if
       (princ) ;;;shhhhh
      );progn else
  );if
)


;;;
;;;  New modules to make the lisp routine language independent by only
;;;  translating the first list.
;;;  Do not touch the order of the list or TRANSLATE. This part should
;;;  remain as it is.
;;;  Have fun.
;;;
(defun loc_to_en(palab / engl)
	(setq where (what_pos palab filter_list))
        (setq engl (nth where filter_list_english))
)

(defun en_to_loc(palab / loc)
        (setq where (what_pos palab filter_list_english))
        (setq loc (nth where filter_list))
)

(defun init_lists_english()
    (setq filter_list_english (list 
                        "Arc"          
                        "Arc Center"         
                        "Arc Radius"
                        "Attribute"    
                        "Attribute Position" 
                        "Attribute Tag" 
                        "Body"
                        "Block"        
                        "Block Name"         
                        "Block Position"
                        "Block Rotation"
                        "Circle"       
                        "Circle Center"      
                        "Circle Radius" 
                        "Color"         
                        "Dimension"    
                        "Dimension Style" 
                        "Elevation"     
                        "Ellipse"      
                        "Ellipse Center"
                        "Hatch"
                        "Hatch Pattern Name"
                        "Image"
                        "Image Position"
                        "Layer"
                        "Leader"
                        "Line"         
                        "Line Start"         
                        "Line End"
                        "Linetype"
                        "Linetype Scale"
                        "MultiLine"    
                        "MultiLine Style"
                        "Normal Vector"
                        "Point"        
                        "Point Position"
                        "Polyline"
                        "Ray"
                        "Region"
                        "Shape"        
                        "Shape Position"
                        "Shape Name"
                        "Solid"
                        "3D Solid"
                        "Spline"
                        "Text"         
                        "Text Position"      
                        "Text Value"
                        "Text Style Name"    
                        "Text Height" 
                        "Text Rotation"
                        "Trace"
                        "3dface"
                        "Thickness"
                        "Tolerance"
                        "Viewport"     
                        "Viewport Center" 
                        "Xdata ID"
                        "Xline"
                        "** Begin  AND"
                        "** End    AND"
                        "** Begin  OR"
                        "** End    OR"
                        "** Begin  XOR"
                        "** End    XOR"
                        "** Begin  NOT"
                        "** End    NOT"
                  )
    )
)

;check4object_need added 11/96 by Randy Kintzley
;This function checks for the selection of certain specific filters 
;that specify a characteristic of a particular type of object.
;It then adds the specific object type to the filter list if it is not 
;already there.
;I.E. A Selected filter of "Text Height" alone could result in a selection 
;that includes ANY type of object that has a 40 dxf group code value that matches 
;the user specified value. In other words, The resulting selection set may include
;types of objects OTHER than text. 
;  So the fix that this function is performing is to automatically add object=text 
;to the filter list when "Text Height" is specified by the user and the text object 
;type is not already present in the filter list.
;That way when the user specifies "Text Height" he/she will only get text objects.
;
;@rk1 filter_lisp_list filter_list_english 
(defun check4object_need (gc_name / )

(if (member gc_name 
            (list
             "Attribute Position"
             "Attribute Tag" 
             "Arc Center"        
             "Arc Radius" 
             "Circle Center"     
             "Circle Radius" 
             "Block Name"        
             "Block Rotation"    
             "Block Position"    
             "Hatch Pattern Name" 
             "Image Position"    
             "MultiLine Style"   
             "Shape Name"        
             "Shape Position"    
             "Ellipse Center"    
             "Line Start"        
             "Point Position"    
             "Text Height" 
             "Text Position"     
             "Text Rotation"
             "Viewport Center"   
            )
     );member
     (progn
      (cond 
       ((and (member gc_name '("Attribute Position"
                               "Attribute Tag"
                              )
             )
             (not (present "ATTDEF" filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "Attribute" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #1   
       ((and (member gc_name '("Arc Center"        
                               "Arc Radius"                               
                              )
             )
             (not (present "Arc" filter_lisp_list))
             ;(not (member '(0 . "Arc") filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "Arc" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #2   
       ((and (member gc_name '("Circle Center"     
                               "Circle Radius"
                              )
             )
             (not (present "CIRCLE" filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "Circle" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #3   
       ((and (member gc_name '( "Block Name"        
                                "Block Rotation"    
                                "Block Position"
                              )
             )
             (not (present "INSERT" filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "Block" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #4   
       ((and (member gc_name '("Hatch Pattern Name")
              )
             (not (present "HATCH" filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "Hatch" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #5   
       ((and (member gc_name '("MultiLine Style")
             )
             (not (present "MLINE" filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "MultiLine" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #6   
       ((and (member gc_name '("Shape Name"        
                               "Shape Position"
                              )
             )
             (not (present "SHAPE" filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "Shape" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #7   
       ((and (member gc_name '("Ellipse Center")
             )
             (not (present "ELLIPSE" filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "Ellipse" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #8   
       ((and (member gc_name '("Line Start")
             )
             (not (present "LINE" filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "Line" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #9   
       ((and (member gc_name '("Point Position")
             )
             (not (present "POINT" filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "Point" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #10   
       ((and (member gc_name '("Text Height" 
                               "Text Position"     
                               "Text Rotation"
                              )
             )
             (not (present "*TEXT" filter_lisp_list))
        );and
        (set_tile "filter_by" (itoa (what_pos "Text" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #11   
       ((and (member gc_name '("Viewport Center")
             )
             (not (present "VIEWPORT" filter_lisp_list))
        );and 
        (set_tile "filter_by" (itoa (what_pos "Viewport" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #12   
       ((and (member gc_name '("Image Position"
                              )
             )
             (not (present "IMAGE" filter_lisp_list))
        );and
        (set_tile "filter_by" (itoa (what_pos "Image" filter_list_english)))
        (add_to_list)
        (set_tile "filter_by" (itoa (what_pos gc_name filter_list_english)))
       );cond #13   
      );cond close 
     );progn then 
);if
nil
);defun check4object_need

;This function checks to see if a particular entity 
;type is specified in an ssget filter list. 
;Returns True if it is.
;It's case insensative
;@rk
(defun present ( a lst / b c d flag )

(setq flag nil);setq
(setq a (strcase a T)
      c (strcat (strcase (substr a 1 1)) (substr a 2))
      d (strcase a) 
);setq
(while (and (not flag)
            lst
            (setq b (assoc 0 lst))
            (not (or (setq flag (equal a (cdr b)));setq
                     (setq flag (equal c (cdr b)));setq
                     (setq flag (equal d (cdr b)));setq
            )    )
            (setq lst (cdr (member b lst)))
        );and
);while
flag 
);defun present


;;;----------------------------------------------------------------------------
;;;(princ "  FILTER loaded.  ")
;;;(princ)



;;;(func_icomscad_ler "VCAD_ConvertFiles.LSP")

(defun c:converter (/ 1_form V1_ListToConvert V1_STOP V1_SearchType V1_ConvertType V1_FILETYPE  V1_FILETYPE V1_PATHSEARCH V1_PATHSEARCH2 V1_LENPATH V1_FULLLIST V1_FULLLIST2 V1_LengFullList V1_FILETOCONVERT)
  (if (/= (getvar "DWGTITLED") nil)
      (alert "You must to close all drawings and type in Command Line \"CONVERTER\".")
      (progn
	(setq 1_form  (load_dialog (strcat var_icomscad_install "dcl/VCAD_ConvertFiles.dcl")))
	(new_dialog "CONVERTDWGRCTASK" 1_form)
	(action_tile "Start_OK" "(START_STOP)")
	(action_tile "Over_OK" "(OVERWRITE_OK)")
	(action_tile "V1_ADDALL" "(ADDALL)")
	(action_tile "V1_ADDFILE" "(ADDTOLIST)")
	(action_tile "V1_REMFILE" "(REMFILE)")
	(action_tile "V1_REVLIST" "(REVLIST)")
	(action_tile "V1_CLRLIST" "(CLRLIST)")
	(setq V1_ListToConvert nil)
	(setq V1_STOP 0)
	(setq V1_SearchType (list "Standard Drawing File (DWG)" "Drawing Exchange Format (DXF)" "Design Web Format (DWF)" "Drawing Tamplate (DWT)"))
	(start_list "Search_List")
	(mapcar 'add_list V1_SearchType)
	(end_list)
	(set_tile "Search_List" "0")
	(setq V1_ConvertType (list "2007 (DWG)" "2007 ASCII(DXF)" "2007 Binary (DXF)"
				   "2004 (DWG)" "2004 ASCII(DXF)" "2004 Binary (DXF)"
				   "2000 (DWG)" "2000 ASCII(DXF)" "2000 Binary (DXF)"
				   "LT95 (DWG)"
				   "Release 14 (DWG)" "Release 14 ASCII(DXF)" "Release 14 Binary (DXF)"
				   "Release 13 (DWG)" "Release 13 ASCII(DXF)" "Release 13 Binary (DXF)"
				   "Release 12 (DWG)" "Release 12 ASCII(DXF)" "Release 12 Binary (DXF)"
				   "Release 11 (DWG)" "Release 11 ASCII(DXF)" "Release 11 Binary (DXF)"
				   "Release 10 ASCII(DXF)" "Release 10 Binary (DXF)"
				   "Release 9 ASCII(DXF)" "Release 9 Binary (DXF)"
				   "Release 2.6 ASCII(DXF)" "Release 2.6 Binary (DXF)"
				   "Release 2.5 ASCII(DXF)" "Release 2.5 Binary (DXF)"
				   "Drawing Tamplate (DWT)")
	      )
	(setq V1_ListToConvert nil)
	(start_list "Convert_List")
	(mapcar 'add_list V1_ConvertType)
	(end_list)
	(set_tile "Convert_List" "0")
	(start_dialog)
      )
    )
  )

(defun ADDALL ()
  (setq V1_FILETYPE (nth (atoi (get_tile "Search_List")) V1_SearchType))
  (cond
    (
     (= V1_FILETYPE "Standard Drawing File (DWG)")
     (setq V1_FILETYPE "dwg")
     )
    (
     (= V1_FILETYPE "Drawing Exchange Format (DXF)")
     (setq V1_FILETYPE "dxf")
     )
    (
     (= V1_FILETYPE "Design Web Format (DWF)")
     (setq V1_FILETYPE "dwf")
     )
    (
     (= V1_FILETYPE "Drawing Tamplate (DWT)")
     (setq V1_FILETYPE "dwt")
     )
    )
  (setq V1_PATHSEARCH (getfiled "Select some file" "c:/" V1_FILETYPE 2))
  (setq V1_PATHSEARCH2 V1_PATHSEARCH)
  (if (/= V1_PATHSEARCH nil)
    (progn
      (setq V1_LENPATH (- (strlen V1_PATHSEARCH) 4))
      (while (/= (substr V1_PATHSEARCH V1_LENPATH 1) "\\")
	(progn
	  (setq V1_LENPATH (- V1_LENPATH 1))
	  )
	)
;;;      (setq V1_LENPATH (- V1_LENPATH 1))
      (setq V1_PATHSEARCH (substr V1_PATHSEARCH 1 V1_LENPATH))
;;;      (set_tile "V1_PATHSEARCH" V1_PATHSEARCH)
      (setq V1_FULLLIST (listfiles (strcat V1_PATHSEARCH "*." V1_FILETYPE)))
      (setq V1_LISTTOCONVERT (append V1_LISTTOCONVERT V1_FULLLIST))
;;;      (setq V1_FULLLIST2 V1_FULLLIST)
;;;      (setq V1_LengFullList (length V1_FULLLIST))
;;;      (while (> V1_LengFullList 0)
;;;	(setq V1_FILETOCONVERT (car V1_FULLLIST))
;;;	(setq V1_FILETOCONVERT (list (substr V1_FILETOCONVERT (+ V1_LENPATH 1) 1000)))
;;;	(if (= V1_LengFullList 1)
;;;	  (progn
;;;	    (setq V1_LISTTOCONVERT (append V1_LISTTOCONVERT V1_FILETOCONVERT))
;;;	    (setq V1_LengFullList (- V1_LengFullList 1))
;;;	    )
;;;	  (progn
;;;	    (setq V1_LISTTOCONVERT (append V1_LISTTOCONVERT V1_FILETOCONVERT))
;;;	    (setq V1_FULLLIST (cdr V1_FULLLIST))
;;;	    (setq V1_LengFullList (- V1_LengFullList 1))
;;;	    )
;;;	  )
;;;	)
      (start_list "V1_ListToConvert")
      (mapcar 'add_list V1_LISTTOCONVERT)
      (end_list)
      (set_tile "Size_List" (itoa (length V1_ListToConvert)))
      )
    )
  )

(defun ADDTOLIST ()
  (setq V1_FILETYPE (nth (atoi (get_tile "Search_List")) V1_SearchType))
  (cond
    (
     (= V1_FILETYPE "Standard Drawing File (DWG)")
     (setq V1_FILETYPE "dwg")
     )
    (
     (= V1_FILETYPE "Drawing Exchange Format (DXF)")
     (setq V1_FILETYPE "dxf")
     )
    (
     (= V1_FILETYPE "Design Web Format (DWF)")
     (setq V1_FILETYPE "dwf")
     )
    (
     (= V1_FILETYPE "Drawing Tamplate (DWT)")
     (setq V1_FILETYPE "dwt")
     )
    )
  (setq V1_PATHSEARCH (getfiled "Select some file" "c:/" V1_FILETYPE 2))
  (setq V1_LISTTOCONVERT (append V1_LISTTOCONVERT (list V1_PATHSEARCH)))
;;;  (setq V1_PATHSEARCH2 V1_PATHSEARCH)
;;;  (if (/= V1_PATHSEARCH nil)
;;;    (progn
;;;      (setq V1_LENPATH (- (strlen V1_PATHSEARCH) 4))
;;;      (while (/= (substr V1_PATHSEARCH V1_LENPATH 1) "\\")
;;;	(progn
;;;	  (setq V1_LENPATH (- V1_LENPATH 1))
;;;	  )
;;;	)
;;;      (setq V1_LENPATH (- V1_LENPATH 1))
;;;      (setq V1_PATHSEARCH (substr V1_PATHSEARCH 1 V1_LENPATH))
;;;      (set_tile "V1_PATHSEARCH" V1_PATHSEARCH)
;;;      (setq V1_FILETOCONVERT (substr V1_PATHSEARCH2 (+ V1_LENPATH 1) 1000))
;;;      (setq V1_LISTTOCONVERT (append V1_LISTTOCONVERT (list V1_FILETOCONVERT)))
      (start_list "V1_ListToConvert")
      (mapcar 'add_list V1_LISTTOCONVERT)
      (end_list)
      (set_tile "Size_List" (itoa (length V1_ListToConvert)))
;;;      (setq V1_FULLLIST2 (append V1_FULLLIST2 (list V1_PATHSEARCH2)))
      )

(defun REMFILE (/ V1_LOOP V1_POSFILE)
  (if (= V1_ListToConvert nil)
    (Alert "The list is empty.")
    (if (> (length V1_ListToConvert) 0)
      (progn
	(setq V1_POSFILE (atoi (get_tile "V1_ListToConvert")))
	(setq V1_ListTemp V1_ListToConvert)
;;;	(setq V1_ListTemp2 V1_FULLLIST2)
	(setq V1_ListToConvert nil)
;;;	(setq V1_FULLLIST2 nil)
	(setq V1_LOOP 0)
	(if (= V1_POSFILE 0)
	  (progn
	    (setq V1_ListToConvert (cdr V1_ListTemp))
;;;	    (setq V1_FULLLIST2 (cdr V1_ListTemp2))
	    )
	  (progn
	    (while (< V1_LOOP V1_POSFILE)
	      (setq V1_ListToConvert (append V1_ListToConvert (list (car V1_ListTemp))))
;;;	      (setq V1_FULLLIST2 (append V1_FULLLIST2 (list (car V1_ListTemp2))))
	      (setq V1_ListTemp (cdr V1_ListTemp))
;;;	      (setq V1_ListTemp2 (cdr V1_ListTemp2))
	      (setq V1_LOOP (+ V1_LOOP 1))
	      )
	    (if (= V1_LOOP V1_POSFILE)
	      (setq V1_ListToConvert (append V1_ListToConvert (cdr V1_ListTemp)))
;;;	      (setq V1_FULLLIST2 (append V1_FULLLIST2 (cdr V1_ListTemp2)))
	      )
	    )
	  )
	(start_list "V1_ListToConvert")
	(mapcar 'add_list V1_LISTTOCONVERT)
	(end_list)
	(set_tile "Size_List" (itoa (length V1_ListToConvert)))
	)
      )
    )
  )

(defun REVLIST ()
    (if (= V1_ListToConvert nil)
    (Alert "The list is empty.")
    (progn
      (setq V1_ListToConvert (reverse V1_ListToConvert))
      ;;;  (setq V1_FULLLIST2 (reverse V1_FULLLIST2))
      (start_list "V1_ListToConvert")
      (mapcar 'add_list V1_LISTTOCONVERT)
      (end_list)
      (set_tile "Size_List" (itoa (length V1_ListToConvert)))
      )
    )
  )

;;;(defun CLRLIST ()
;;;  (setq V1_ListToConvert (cdr (list (car V1_ListToConvert))))
;;;;;;  (setq V1_FULLLIST2 (cdr (list (car V1_FULLLIST2))))
;;;  (start_list "V1_ListToConvert")
;;;  (mapcar 'add_list V1_LISTTOCONVERT)
;;;  (end_list)
;;;  (set_tile "Size_List" (itoa (length V1_ListToConvert)))
;;;  )

(defun START_STOP ()
  (if (/= V1_ListToConvert nil)
    (progn
      (START_CONVERTION)
      (alert "All files were converted.")
      (done_dialog)
      )
    (Alert "The list is empty.")
    )
;;;  (progn
;;;;;;	(command "qsave" "close")
;;;;;;	(if (= V1_STOP 0)
;;;;;;	  (setq V1_STOP 1)
;;;;;;	  (setq V1_STOP 0)
;;;;;;	  )
;;;;;;	(print V1_STOP)
;;;	
;;;	)
  )

(defun START_CONVERTION (/ V1_FILEOPEN FILE_OUT)
  (setq FILE_OUT (nth (atoi (get_tile "Convert_List")) V1_ConvertType))
  (setq V1_DIAG (getvar "filedia"))
;;;  (setq V1_ECHO (getvar "cmdecho"))
  (setvar "filedia" 0)
;;;  (setvar "cmdecho" 0)
  (setq V1_CONVERTED 0)
  (while (= V1_STOP 0)
    (setq V1_FILEOPEN (car V1_ListToConvert))
    (OPEN_FILE)
;;;    (print (strcat "Converting the file \"" V1_FILEOPEN "\" now. Please waith..."))
    (command "zoom" "extents")
    (CONVERT)
    (setvar "filedia" V1_DIAG)
;;;    (setvar "filedia" V1_ECHO)
    (setq V1_CONVERTED (+ V1_CONVERTED 1))
    (set_tile "Total_List" (itoa V1_CONVERTED))
    (print (strcat "The file \"" V1_FILEOPEN "\" was converted to format \"" FILE_OUT "\" sussesfully."))
;;;    (alert (strcat "The file \"" V1_FILEOPEN "\" was converted to format \"" FILE_OUT "\" sussesfully."))
    (if (= (length V1_ListToConvert) 1)
      (setq V1_STOP 1)
      (progn
	(setq V1_ListToConvert (cdr V1_ListToConvert))
	)
      )
    )
  (setvar "filedia" V1_DIAG)
;;;  (setvar "filedia" V1_ECHO)
  )

(defun OPEN_FILE ()
  (command "open" V1_FILEOPEN)
  )

;;;;;;(defun OVERWRITE_OK ()
;;;;;;  (setq V1_OVER (get_tile "Over_OK"))
;;;;;;  (if (= V1_OVER "1")
;;;;;;    (alert "All files will be fucked !")
;;;;;;    (print V1_OVER)
;;;;;;    )
;;;;;;  )

(defun CONVERT ()
   (cond
    (
     (= FILE_OUT "2007 (DWG)")
     (progn
       (command "saveas" "A2007" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "2004 (DWG)")
     (progn
       (command "saveas" "A2004" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "2000 (DWG)")
     (progn
       (command "saveas" "A2K" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "LT95 (DWG)")
     (progn
       (command "saveas" "LT95" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 14 (DWG)")
     (progn
       (command "saveas" "R14" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 13 (DWG)")
     (progn
       (command "saveas" "R13" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 12 (DWG)")
     (progn
       (command "saveas" "R12" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 11 (DWG)")
     (progn
       (command "saveas" "R11" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 11 (DWG)")
     (progn
       (command "saveas" "R11" "")
       (command "close")
       )
     )

;;;    ==================

    (
     (= FILE_OUT "2007 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "A2007" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "2004 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "A2004" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "2000 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "A2K" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 14 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R14" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 13 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R13" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 12 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R12" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 11 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R11" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 10 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R10" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 9 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R9" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 2.6 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R2.6" "")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 2.5 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R2.5" "")
       (command "close")
       )
     )

;;;    ==========

        (
     (= FILE_OUT "2007 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "A2007" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "2004 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "A2004" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "2000 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "A2K" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 14 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R14" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 13 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R13" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 12 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R12" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 11 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R11" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 10 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R10" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 9 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R9" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 2.6 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R2.6" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Release 2.5 ASCII(DXF)")
     (progn
       (command "dxfout" "" "v" "R2.5" "b")
       (command "close")
       )
     )
    (
     (= FILE_OUT "Drawing Tamplate (DWT)")
     (progn
       (command "saveas" "A2007" (strcat (substr V1_FILEOPEN 1 (- (strlen V1_FILEOPEN) 4)) ".dwt"))
       (command "close")
       )
     )
    )
  )


;;;(func_icomscad_ler "VCAD_Check_Template.lsp")

(defun c:PD (/ V1_TBL V1_NEXT V1_OK1
	     V1_LIST_LAYERS  V1_LIST_BLOCKS  V1_LIST_DIMSTY  V1_LIST_TXTSTY  V1_CHECK_LAYER  V1_LIST_BLOCKS  V1_LIST_DIMSTY  V1_LIST_TXTSTY
	     V1_LIST_LAYERS2 V1_LIST_BLOCKS2 V1_LIST_DIMSTY2 V1_LIST_TXTSTY2 V1_CHECK_LAYER2 V1_LIST_BLOCKS2 V1_LIST_DIMSTY2 V1_LIST_TXTSTY2
	     V1_LIST_LAYERS3 V1_LIST_BLOCKS3 V1_LIST_DIMSTY3 V1_LIST_TXTSTY3 V1_CHECK_LAYER3 V1_LIST_BLOCKS3 V1_LIST_DIMSTY3 V1_LIST_TXTSTY3
	     V1_LIST_LAYERS4 V1_LIST_BLOCKS4 V1_LIST_DIMSTY4 V1_LIST_TXTSTY4 V1_CHECK_LAYER4 V1_LIST_BLOCKS4 V1_LIST_DIMSTY4 V1_LIST_TXTSTY4)
  
  (if (= (getvar "DWGTITLED") 0)
    (alert "É necessário salvar o arquivo primeiro.")
    (progn

      (setq V1_RELAT (open (strcat (getvar "exedir") "templates\\Relatorio.txt") "w"))
      (close V1_RELAT)
      (setq V1_RELAT (open (strcat (getvar "exedir") "templates\\Relatorio.txt") "a"))
      (write-line "Relatório de padronização:" V1_RELAT)
      (write-line "" V1_RELAT)
      (write-line "" V1_RELAT)
      (write-line "Arquivo verificado:" V1_RELAT)
      (write-line (getvar "savename") V1_RELAT)
      (write-line "" V1_RELAT)
      (write-line "" V1_RELAT)
            
      (command "open" (strcat (getvar "exedir") "templates\\padrao.dwt"))

      (setq V1_LIST_LAYERS (list ))
      (setq V1_LIST_BLOCKS (list ))
      (setq V1_LIST_DIMSTY (list ))
      (setq V1_LIST_TXTSTY (list ))
      
      (setq V1_TBL "T")
      (while (setq V1_NEXT (tblnext "layer" V1_TBL))
	(progn
	  (setq V1_LIST_LAYERS (append V1_LIST_LAYERS (list V1_NEXT)))
	  (setq V1_TBL nil)
	  (setq V1_NEXT nil)
	  )
	)
      (setq V1_LIST_LAYERS2 V1_LIST_LAYERS)
      (setq V1_LIST_LAYERS3 V1_LIST_LAYERS)
      (setq V1_LIST_LAYERS4 V1_LIST_LAYERS)
      
      (setq V1_TBL "T")
      (while (setq V1_NEXT (tblnext "block" V1_TBL))
	(progn
	  (setq V1_LIST_BLOCKS (append V1_LIST_BLOCKS (list V1_NEXT)))
	  (setq V1_TBL nil)
	  (setq V1_NEXT nil)
	  )
	)
      (setq V1_LIST_BLOCKS2 V1_LIST_BLOCKS)
      (setq V1_LIST_BLOCKS3 V1_LIST_BLOCKS)
      (setq V1_LIST_BLOCKS4 V1_LIST_BLOCKS)
      
      (setq V1_TBL "T")
      (while (setq V1_NEXT (tblnext "dimstyle" V1_TBL))
	(progn
	  (setq V1_LIST_DIMSTY (append V1_LIST_DIMSTY (list V1_NEXT)))
	  (setq V1_TBL nil)
	  (setq V1_NEXT nil)
	  )
	)
      (setq V1_LIST_DIMSTY2 V1_LIST_DIMSTY)
      (setq V1_LIST_DIMSTY3 V1_LIST_DIMSTY)
      (setq V1_LIST_DIMSTY4 V1_LIST_DIMSTY)
      
      (setq V1_TBL "T")
      (while (setq V1_NEXT (tblnext "style" V1_TBL))
	(progn
	  (setq V1_LIST_TXTSTY (append V1_LIST_TXTSTY (list V1_NEXT)))
	  (setq V1_TBL nil)
	  (setq V1_NEXT nil)
	  )
	)
      (setq V1_LIST_TXTSTY2 V1_LIST_TXTSTY)
      (setq V1_LIST_TXTSTY3 V1_LIST_TXTSTY)
      (setq V1_LIST_TXTSTY4 V1_LIST_TXTSTY)
      
      (command "close")

      (progn

      (write-line "===============================================================================" V1_RELAT)
      (write-line "Confere com a padronização:" V1_RELAT)
      (write-line "" V1_RELAT)

      (if (/= (length V1_LIST_LAYERS) 0)
	(progn
	  (setq V1_CHECK_LAYER (cdr (assoc 2 (car V1_LIST_LAYERS))))
	  (setq V1_LIST_LAYERS (cdr V1_LIST_LAYERS))
	  (while (/= V1_CHECK_LAYER nil)
	    (if (tblsearch "layer" V1_CHECK_LAYER)
	      (progn
		(write-line (strcat "O Layer   | " V1_CHECK_LAYER " |   confere.") V1_RELAT)
		)
	      )
	    (setq V1_CHECK_LAYER (cdr (assoc 2 (car V1_LIST_LAYERS))))
	    (setq V1_LIST_LAYERS (cdr V1_LIST_LAYERS))
	    )
	  (write-line "" V1_RELAT)
	  )
	)
      
      (if (/= (length V1_LIST_BLOCKS) 0)
	(progn
	  (setq V1_CHECK_BLOCK (cdr (assoc 2 (car V1_LIST_BLOCKS))))
	  (setq V1_LIST_BLOCKS (cdr V1_LIST_BLOCKS))
	  (while (/= V1_CHECK_BLOCK nil)
	    (if (tblsearch "block" V1_CHECK_BLOCK)
	      (progn
		(write-line (strcat "O Bloco   | " V1_CHECK_BLOCK " |   confere.") V1_RELAT)
		)
	      )
	    (setq V1_CHECK_BLOCK (cdr (assoc 2 (car V1_LIST_BLOCKS))))
	    (setq V1_LIST_BLOCKS (cdr V1_LIST_BLOCKS))
	    )
	  (write-line "" V1_RELAT)
	  )
	)
      
      (if (/= (length V1_LIST_DIMSTY) 0)
	(progn
	  (setq V1_CHECK_DIMSTY (cdr (assoc 2 (car V1_LIST_DIMSTY))))
	  (setq V1_LIST_DIMSTY (cdr V1_LIST_DIMSTY))
	  (while (/= V1_CHECK_DIMSTY nil)
	    (if (tblsearch "dimstyle" V1_CHECK_DIMSTY)
	      (progn
		(write-line (strcat "O Dimension Style   | " V1_CHECK_DIMSTY " |   confere.") V1_RELAT)
		)
	      )
	    (setq V1_CHECK_DIMSTY (cdr (assoc 2 (car V1_LIST_DIMSTY))))
	    (setq V1_LIST_DIMSTY (cdr V1_LIST_DIMSTY))
	    )
	  (write-line "" V1_RELAT)
	  )
	)
      
      (if (/= (length V1_LIST_TXTSTY) 0)
	(progn
	  (setq V1_CHECK_TXTSTY (cdr (assoc 2 (car V1_LIST_TXTSTY))))
	  (setq V1_LIST_TXTSTY (cdr V1_LIST_TXTSTY))
	  (while (/= V1_CHECK_TXTSTY nil)
	    (if (tblsearch "style" V1_CHECK_TXTSTY)
	      (progn
		(write-line (strcat "O Text Style   | " V1_CHECK_TXTSTY " |   confere.") V1_RELAT)
		)
	      )
	    (setq V1_CHECK_TXTSTY (cdr (assoc 2 (car V1_LIST_TXTSTY))))
	    (setq V1_LIST_TXTSTY (cdr V1_LIST_TXTSTY))
	    )
	  (write-line "" V1_RELAT)
	  )
	)
      )
      (write-line "" V1_RELAT)


      (progn
	
      (write-line "===============================================================================" V1_RELAT)
      (write-line "Estão ausentes:" V1_RELAT)
      (write-line "" V1_RELAT)

      (if (/= (length V1_LIST_LAYERS2) 0)
	(progn
	  (setq V1_CHECK_LAYER (cdr (assoc 2 (car V1_LIST_LAYERS2))))
	  (setq V1_LIST_LAYERS2 (cdr V1_LIST_LAYERS2))
	  (while (/= V1_CHECK_LAYER nil)
	    (if (tblsearch "layer" V1_CHECK_LAYER)
	      ()
	      (progn
		(write-line (strcat "Layer   | " V1_CHECK_LAYER " |  ausente.") V1_RELAT)
		)
	      )
	    (setq V1_CHECK_LAYER (cdr (assoc 2 (car V1_LIST_LAYERS2))))
	    (setq V1_LIST_LAYERS2 (cdr V1_LIST_LAYERS2))
	    )
	  (write-line "" V1_RELAT)
	  )
	)
      
      (if (/= (length V1_LIST_BLOCKS2) 0)
	(progn
	  (setq V1_CHECK_BLOCK (cdr (assoc 2 (car V1_LIST_BLOCKS2))))
	  (setq V1_LIST_BLOCKS2 (cdr V1_LIST_BLOCKS2))
	  (while (/= V1_CHECK_BLOCK nil)
	    (if (tblsearch "block" V1_CHECK_BLOCK)
	      ()
	      (progn
		(write-line (strcat "Bloco   | " V1_CHECK_BLOCK " |   ausente.") V1_RELAT)
		)
	      )
	    (setq V1_CHECK_BLOCK (cdr (assoc 2 (car V1_LIST_BLOCKS2))))
	    (setq V1_LIST_BLOCKS2 (cdr V1_LIST_BLOCKS2))
	    )
	  (write-line "" V1_RELAT)
	  )
	)
      
      (if (/= (length V1_LIST_DIMSTY2) 0)
	(progn
	  (setq V1_CHECK_DIMSTY (cdr (assoc 2 (car V1_LIST_DIMSTY2))))
	  (setq V1_LIST_DIMSTY2 (cdr V1_LIST_DIMSTY2))
	  (while (/= V1_CHECK_DIMSTY nil)
	    (if (tblsearch "dimstyle" V1_CHECK_DIMSTY)
	      ()
	      (progn
		(write-line (strcat "Dimension Style   | " V1_CHECK_DIMSTY " |   ausente.") V1_RELAT)
		)
	      )
	    (setq V1_CHECK_DIMSTY (cdr (assoc 2 (car V1_LIST_DIMSTY2))))
	    (setq V1_LIST_DIMSTY2 (cdr V1_LIST_DIMSTY2))
	    )
	  (write-line "" V1_RELAT)
	  )
	)
      
      (if (/= (length V1_LIST_TXTSTY2) 0)
	(progn
	  (setq V1_CHECK_TXTSTY (cdr (assoc 2 (car V1_LIST_TXTSTY2))))
	  (setq V1_LIST_TXTSTY2 (cdr V1_LIST_TXTSTY2))
	  (while (/= V1_CHECK_TXTSTY nil)
	    (if (tblsearch "style" V1_CHECK_TXTSTY)
	      ()
	      (progn
		(write-line (strcat "Text Style   | " V1_CHECK_TXTSTY " |   ausente.") V1_RELAT)
		)
	      )
	    (setq V1_CHECK_TXTSTY (cdr (assoc 2 (car V1_LIST_TXTSTY2))))
	    (setq V1_LIST_TXTSTY2 (cdr V1_LIST_TXTSTY2))
	    )
	  (write-line "" V1_RELAT)
	  )
	)
      )


      (write-line "===============================================================================" V1_RELAT)
      (write-line "Não confere com o template comparado:" V1_RELAT)
      (write-line "" V1_RELAT)

      (setq V1_TBL "T")
      (setq V1_OK1 0)
      (setq V1_CHECK_LAYER (cdr (assoc 2 (car V1_LIST_LAYERS3))))
      (setq V1_LIST_LAYERS3 (cdr V1_LIST_LAYERS3))
      (while (setq V1_NEXT (cdr (assoc 2 (tblnext "layer" V1_TBL))))
	(progn
	  (while (/= V1_CHECK_LAYER nil)
	    (if (= V1_NEXT V1_CHECK_LAYER)
	      (progn
		(setq V1_OK1 1)
		(setq V1_CHECK_LAYER nil)
		)
	      (progn
		(setq V1_CHECK_LAYER (cdr (assoc 2 (car V1_LIST_LAYERS3))))
		(setq V1_LIST_LAYERS3 (cdr V1_LIST_LAYERS3))
		)
	      )
	    )
	  (if (= V1_OK1 0)
	    (write-line (strcat "O Layer   | " V1_NEXT " |   . Layer definido pelo usuário.") V1_RELAT)
	    )
	  (setq V1_OK1 0)
	  (setq V1_TBL nil)
	  (setq V1_LIST_LAYERS3 V1_LIST_LAYERS4)
	  (setq V1_CHECK_LAYER (cdr (assoc 2 (car V1_LIST_LAYERS3))))
	  (setq V1_LIST_LAYERS3 (cdr V1_LIST_LAYERS3))
	  )
	)

      (write-line "" V1_RELAT)

      (setq V1_TBL "T")
      (setq V1_OK1 0)
      (setq V1_CHECK_BLOCK (cdr (assoc 2 (car V1_LIST_BLOCKS3))))
      (setq V1_LIST_BLOCKS3 (cdr V1_LIST_BLOCKS3))
      (while (setq V1_NEXT (cdr (assoc 2 (tblnext "block" V1_TBL))))
	(progn
	  (while (/= V1_CHECK_BLOCK nil)
	    (if (= V1_NEXT V1_CHECK_BLOCK)
	      (progn
		(setq V1_OK1 1)
		(setq V1_CHECK_BLOCK nil)
		)
	      (progn
		(setq V1_CHECK_BLOCK (cdr (assoc 2 (car V1_LIST_BLOCKS3))))
		(setq V1_LIST_BLOCKS3 (cdr V1_LIST_BLOCKS3))
		)
	      )
	    )
	  (if (= V1_OK1 0)
	    (write-line (strcat "O Block   | " V1_NEXT " |   . Bloco definido pelo usuário.") V1_RELAT)
	    )
	  (setq V1_OK1 0)
	  (setq V1_TBL nil)
	  (setq V1_LIST_BLOCKS3 V1_LIST_BLOCKS4)
	  (setq V1_CHECK_BLOCK (cdr (assoc 2 (car V1_LIST_BLOCKS3))))
	  (setq V1_LIST_BLOCKS3 (cdr V1_LIST_BLOCKS3))
	  )
	)

      (write-line "" V1_RELAT)

      (setq V1_TBL "T")
      (setq V1_OK1 0)
      (setq V1_CHECK_DIMSTY (cdr (assoc 2 (car V1_LIST_DIMSTY3))))
      (setq V1_LIST_DIMSTY3 (cdr V1_LIST_DIMSTY3))
      (while (setq V1_NEXT (cdr (assoc 2 (tblnext "dimstyle" V1_TBL))))
	(progn
	  (while (/= V1_CHECK_DIMSTY nil)
	    (if (= V1_NEXT V1_CHECK_DIMSTY)
	      (progn
		(setq V1_OK1 1)
		(setq V1_CHECK_DIMSTY nil)
		)
	      (progn
		(setq V1_CHECK_DIMSTY (cdr (assoc 2 (car V1_LIST_DIMSTY3))))
		(setq V1_LIST_DIMSTY3 (cdr V1_LIST_DIMSTY3))
		)
	      )
	    )
	  (if (= V1_OK1 0)
	    (write-line (strcat "O Dimension Style   | " V1_NEXT " |   . Dimension definido pelo usuário.") V1_RELAT)
	    )
	  (setq V1_OK1 0)
	  (setq V1_TBL nil)
	  (setq V1_LIST_DIMSTY3 V1_LIST_DIMSTY4)
	  (setq V1_CHECK_DIMSTY (cdr (assoc 2 (car V1_LIST_DIMSTY3))))
	  (setq V1_LIST_DIMSTY3 (cdr V1_LIST_DIMSTY3))
	  )
	)

      (write-line "" V1_RELAT)

      (setq V1_TBL "T")
      (setq V1_OK1 0)
      (setq V1_CHECK_TXTSTY (cdr (assoc 2 (car V1_LIST_TXTSTY3))))
      (setq V1_LIST_TXTSTY3 (cdr V1_LIST_TXTSTY3))
      (while (setq V1_NEXT (cdr (assoc 2 (tblnext "style" V1_TBL))))
	(progn
	  (while (/= V1_CHECK_TXTSTY nil)
	    (if (= V1_NEXT V1_CHECK_TXTSTY)
	      (progn
		(setq V1_OK1 1)
		(setq V1_CHECK_TXTSTY nil)
		)
	      (progn
		(setq V1_CHECK_TXTSTY (cdr (assoc 2 (car V1_LIST_TXTSTY3))))
		(setq V1_LIST_TXTSTY3 (cdr V1_LIST_TXTSTY3))
		)
	      )
	    )
	  (if (= V1_OK1 0)
	    (write-line (strcat "O Text Style   | " V1_NEXT " |   . Style definido pelo usuário.") V1_RELAT)
	    )
	  (setq V1_OK1 0)
	  (setq V1_TBL nil)
	  (setq V1_LIST_TXTSTY3 V1_LIST_TXTSTY4)
	  (setq V1_CHECK_TXTSTY (cdr (assoc 2 (car V1_LIST_TXTSTY3))))
	  (setq V1_LIST_TXTSTY3 (cdr V1_LIST_TXTSTY3))
	  )
	)

      (close V1_RELAT)

      )
    )
  )



(princ "\nSMART Utilities loaded sucessfully...\n")
(princ)
;;(prompt "Welcome to VCAD 2009")
;;(princ)
)
)











































































































































;;end load
;;========================================================================================================


















































































































































;;end load
;;=======================================================================================================
