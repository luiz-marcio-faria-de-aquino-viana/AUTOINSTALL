; K16c0/Porta - Fev/92
  
; Variaveis:
;    Ptchave - Contem opcao de porta simples ou de correr - Entrada
;    Ptbase  - Ponto base para insercao da porta          - Entrada
;    Ptini   - Ponto inicial (insercao) da porta          - Entrada
;    Ptlarg  - Ponto que marca a larg da porta            - Entrada
;    Ptespc  - Ponto que marca a espec da parede          - Entrada
;    Ptcorn  - Ponto auxiliar determinado p/micro         - Interno
;    #Und    - Unidade de trabalho (mm)                   - Sistema

(defun c:PORTA (/ ptchave ptbase ptini ptlarg ptespc ptcorn)  
  (setvar "cmdecho" 0)
  
  (initget 1 "Correr")
  (setq
    ptchave (getpoint "\nPonto base (ou inicial)/Porta (C)orrer: ")
  );endsetq
  (if (= ptchave "Correr")
    (progn
      (initget 1)
      (setq
        ptbase (getpoint "\nPonto base (ou inicial): ")
      );endsetq
    );endprogn
    (setq ptbase ptchave)
  );endif
  (setq
    ptini (getpoint ptbase "\nPonto inicial (ou ENTER): ")
  );endsetq
  (if (null ptini)
    (setq ptini ptbase)
  );endif
  (initget 1)
  (setq
    ptlarg (getpoint ptini "\nMarque largura da porta: ")
  );endsetq
  (initget 1)
  (setq
    ptespc (getpoint ptini "\nMarque especura da parede: ")
  );endsetq
  
  (setq
    ptcorn (polar ptespc (angle ptini ptlarg) (distance ptini ptlarg))
  );endsetq
  (command
    "line" ptini ptespc ""
    "line" ptlarg ptcorn ""
    "break"
      (polar ptini (angle ptini ptlarg) (/ (distance ptini ptlarg) 2.0))
      "first" ptini ptlarg
    "break"
      (polar ptespc (angle ptini ptlarg) (/ (distance ptini ptlarg) 2.0))
      "first" ptespc ptcorn
  );endcommand
  (if (= ptchave "Correr")
    (command
      "line"
        (polar ptini (angle ptini ptespc) (/ (distance ptini ptespc) 2.0))
        (polar ptlarg (angle ptini ptespc) (/ (distance ptini ptespc) 2.0)) ""
      "line"
        (polar
          ptini (angle ptini ptespc)
          (+ (/ (distance ptini ptespc) 2.0) (/ 30.0 #und))
        );endpolar
        (polar
          (getvar "lastpoint")
          (angle ptini ptlarg)
          (/ (distance ptini ptlarg) 2.0)
        );endpolar
        (polar (getvar "lastpoint") (angle ptespc ptini) (/ 60.0 #und))
        (polar
          (getvar "lastpoint")
          (angle ptini ptlarg)
          (/ (distance ptini ptlarg) 2.0)
        );endpolar
        ""
    );endcommand
    (command
      "line"
        ptini (polar ptini (angle ptini ptlarg) (/ 30.0 #und))
        (polar (getvar "lastpoint") (angle ptespc ptini) (distance ptini ptlarg))
        (polar (getvar "lastpoint") (angle ptlarg ptini) (/ 30.0 #und)) "c"
    );endcommand
  );endif
  (princ)
);enddefun
