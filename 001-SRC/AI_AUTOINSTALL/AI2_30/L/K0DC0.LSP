; K0dc0/INSert3 - Mai/92

(defun C:INSert3(/ blck pt1 ang)
  (setvar "cmdecho" 0)
  (if (or (null #blck)
          (= #blck "")
      );endor
    (progn
      (initget 1)
      (setq
        blck (getstring "\nInsert block name: ")
    ) );endsetq,progn
    (setq
      blck (getstring (strcat
                        "\nInsert block name <"
                        #blck ">: "
           )          );endstrcat,get
    );endsetq
  );endif
  (if (/= blck "") (setq #blck blck))

  (initget 1)
  (setq
    pt1 (getpoint "\nPonto de insercao: ")
  );endsetq
  (if (null ang) (setq ang 0))

  (command
    "insert" (V:AID blck) pt1 #scl
  );endcommand
  (setvar "cmdecho" 1) (command "")
  (setvar "cmdecho" 0) (command pause)
  (princ)
);enddefun
