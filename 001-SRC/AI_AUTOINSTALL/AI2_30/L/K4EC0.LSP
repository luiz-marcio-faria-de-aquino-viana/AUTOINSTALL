
;;
;; MKLAY.lsp
;; Copyright (C) 1995 by Luiz Marcio F A Viana, 12/9/95
;;

;;
;; MKLAY: rotina para criar a estrutura de layers
;;

(defun c:mklay(/ oldech f dat la lt cl)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (setq f (open "layer.prn" "r"))
  (command ".layer")
  (read-line f)
  (read-line f)
  (while (setq dat (read-line f))
    (setq
      la (rtrim (substr dat  1 15))
      lt (rtrim (substr dat 17 15))
      cl (rtrim (substr dat 33 15))
    ) ; end setq
    (if (not (tblsearch "LAYER" la)) (command "m" la "lt" lt "" "c" cl "") )
  ) ; end while
  (command "t" "0" "s" "0" "")
  (setq f (close f))
  (setvar "cmdecho" oldech)
) ; end defun

(princ)
