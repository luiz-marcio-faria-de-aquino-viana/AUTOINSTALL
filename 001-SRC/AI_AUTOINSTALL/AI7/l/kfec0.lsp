
;;
;; KFEC0.lsp
;; Copyright (C) 2019 by Luiz Marcio F A Viana, 13/11/19
;;

(setq DEF_QRCODEGEN_BASEDIR "C:/ACADAPPL/QRCODEGEN/Temp/")

(defun strSerial(cVal n / result val oVal)
  (setq result "")
  (if (> n 0)
    (setq 
	  val (* 10.0 cVal)
	  oVal (fix val)
	  newVal (- val oVal)
	  newN (- n 1)
	  result (strcat (rtos oVal 2 0) (strSerial newVal newN))
    ) ; end progn
  ) ; end if
  result
) ; end defun

;; c:ai_genQrCode(): rotina para geracao do QrCode
(defun c:ai_qrCodeGen(/ oldech imageFile imageFullFile imageScl_1cm imageScl pti ffName cmdCall)
  (setq oldech (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  
  (setq 
    cVal (/ (getvar "cdate") 100000000.0)
    n 20
  ) ; end setq

  (setq imageFile (strcat (strSerial cVal n) ".jpg"))
  
  (setq imageFullFile (strcat DEF_QRCODEGEN_BASEDIR imageFile))

  (setq imageScl_1cm (* 10.0 (#SCL)))
  (setq imageScl (* 3.0 imageScl_1cm))
  
  (setq pti (getpoint "\nPonto de insercao do codigo: "))
  (if pti
    (progn
      (setq ffName (strcat "\"" (getvar "dwgprefix") (getvar "dwgname") "\""))

      (setq cmdCall (strcat
	                  "call "
					  "runqrcode.bat "
                      ffName
					  " "
					  imageFullFile)) 
	  (prompt (strcat "\nInDWG = " ffName))
	  
      (command ".shell" cmdCall)
      (command "-image" "a" imageFullFile pti imageScl 0.0)
    ) ; end progn
  ) ; end if
	  
  (setvar "cmdecho" oldech)
  (princ)
) ; end defun

(princ)
