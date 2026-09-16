
;;
;; ACAD1.lsp: Rotine to correct general systems data
;; =================================================

;;
;;

;;
;; Adjust of linetype scale factor

(command "ltscale" (* (#SCL) 10.0) )

;;
;; Load oldest version of LdDet

(loadf "olddet")

;;
;; Load oldest version of pspace

(loadf "oldpspc")

;;
;; Load program FIXTEXT

(loadf "k4fc0")

;;
;; Load program SNAME

(loadf "k5fc0")

;;
;; Load program UNIPLINE

(loadf "k64c0")

(princ)
