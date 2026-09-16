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

  (if (tblsearch "block" (getfilename #blck))
    (command ".insert" (getfilename #blck) "s" (#SCL))
    (command ".insert" (V:AID #blck) "s" (#SCL))
  ) ; end if

  (princ)
);enddefun
