
;;
;; MKLAY.lsp
;; Copyright (C) 1995 by Luiz Marcio F A Viana, 12/9/95
;;

;;
;; MKLAY: rotina para criar a estrutura de layers
;;

(defun mklay(redef / oldech f dat la lt cl)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (if (setq f (open "layer.prn" "r"))
    (progn
      (command ".layer")
      (read-line f)
      (read-line f)
      (while (setq dat (read-line f))
        (setq
          la (rtrim (substr dat 1 30))
          lt (rtrim (substr dat 32 15))
          cl (rtrim (substr dat 48 15))
        ) ; end setq
		(if redef
		  (command "m" la "lt" lt "" "c" cl "")
		  (if (not (tblsearch "LAYER" la)) 
		    (command "m" la "lt" lt "" "c" cl "") )
		) ; end if
      ) ; end while
      (command "t" "0" "s" "0" "")
      (setq f (close f))
    ) ; end progn
  ) ; end if
  (setvar "cmdecho" oldech)
) ; end defun

(defun c:redeflay(/ oldech f dat la lt cl)
  (mklay 't)
) ; end defun

(defun c:mklay(/ oldech f dat la lt cl)
  (mklay nil)
) ; end defun

(princ)
