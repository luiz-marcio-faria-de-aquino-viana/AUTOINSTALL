; K22c0/TRANSlate V1.0toV2.1 - Mai/92

(setvar "cmdecho" 0)

(if (null
      (tblsearch "block" "SET0bc01")
    );endnull
 (progn
  (prompt "\n--- Execcutando programa TRANSlate ---\nAguarde... ")
  (setvar "dimtsz" 0.05)
  (setq
    nnivel '("ARQ-arquitetura" "ARQ-textos"
             "F-pl_teto" "F-vg_teto" "F-vg_piso" "F-furacao" "F-textos"
             "EL-prumadas" "EL-dt_teto" "EL-dt_piso" "EL-dt_aparente" "EL-pontos" "EL-furacao" "EL-vigas" "EL-textos" "EL-detalhe"
             "ES-colunas" "ES-primario" "ES-secundario" "ES-ventilacao" "ES-apluvial" "ES-bujao" "ES-pontos" "ES-furacao" "ES-vigas" "ES-textos" "ES-detalhe"
             "H-colunas" "H-tb_afria" "H-tb_aquente" "H-tb_incendio" "H-pontos" "H-furacao" "H-vigas" "H-Textos" "H-detalhe"
             "G-prumadas" "G-tb_teto" "G-tb_piso" "G-pontos" "G-furacao" "G-vigas" "G-textos" "G-detalhe"
             "TE-prumadas" "TE-tb_teto" "TE-tb_piso" "TE-pontos" "TE-furacao" "TE-vigas" "TE-textos" "TE-detalhe"
             "TI-prumadas" "TI-tb_teto" "TI-tb_piso" "TI-pontos" "TI-furacao" "TI-vigas" "TI-textos" "TI-detalhe"
             "IE-prumadas" "IE-tvfm" "IE-som" "IE-circ_tv" "IE-pararaio" "IE-pontos" "IE-furacao" "IE-vigas" "IE-textos" "IE-detalhe"
             "AR-colunas" "AR-agelada" "AR-dutos" "AR-pontos" "AR-furacao" "AR-vigas" "AR-textos" "AR-detalhe"

             "ARQ-projecao" "ARQ-banheiro"
             "F-pl_piso"
             "EL-setas" "EL-circuitos" "EL-qd_carga" "EL-diagramas" "EL-carimbo"
             "ES-setas" "ES-conexao" "ES-carimbo"
             "H-setas" "H-conexao" "H-carimbo"
             "G-setas" "G-tubulacao" "G-esquemas" "G-conexao" "G-carimbo"
             "TE-setas" "TE-carimbo"
             "TI-setas" "TI-carimbo"
             "IE-dt_continuous" "IE-dt_tr-pt" "IE-dt_tr-2pt" "IE-dt_2tr-pt" "IE-dt_3tr" "IE-setas")
    lnivel '("continuous" "continuous"
             "continuous" "dashdot" "divide" "continuous" "continuous"
             "continuous" "continuous" "hidden" "dashdot" "continuous" "continuous" "continuous" "continuous" "continuous"
             "continuous" "continuous" "hidden" "dot" "dashdot" "continuous" "continuous" "continuous" "continuous" "continuous" "continuous"
             "continuous" "continuous" "hidden" "dashdot" "continuous" "continuous" "continuous" "continuous" "continuous"

             "continuous" "continuous" "hidden" "continuous" "continuous" "dashdot" "continuous" "continuous"
             "continuous" "hidden" "continuous" "continuous" "continuous" "dashdot" "continuous" "continuous"
             "continuous" "hidden" "continuous" "continuous" "continuous" "dashdot" "continuous" "continuous"
             "continuous" "divide" "border" "phantom" "center" "continuous" "continuous" "dashdot" "continuous" "continuous"
             "continuous" "continuous" "continuous" "continuous" "continuous" "dashdot" "continuous" "continuous"

             "continuous" "continuous"
             "divide"
             "continuous" "continuous" "continuous" "continuous" "continuous"
             "continuous" "continuous" "continuous"
             "continuous" "continuous" "continuous"
             "continuous" "hidden" "continuous" "continuous" "continuous"
             "continuous" "continuous"
             "continuous" "continuous"
             "continuous" "dashdot" "divide" "border" "phantom" "continuous")
    cnivel '("yellow" "yellow"
             "yellow" "yellow" "yellow" "yellow" "yellow"
             "green" "blue" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
             "green" "blue" "blue" "blue" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
             "green" "blue" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"

             "green" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
             "green" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
             "green" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
             "green" "blue" "blue" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"
             "green" "blue" "blue" "green" "yellow" "yellow" "yellow" "yellow"

             "yellow" "yellow"
             "yellow"
             "yellow" "yellow" "yellow" "yellow" "yellow"
             "yellow" "yellow" "yellow"
             "yellow" "yellow" "yellow"
             "yellow" "blue" "yellow" "yellow" "yellow"
             "yellow" "yellow"
             "yellow" "yellow"
             "blue" "blue" "blue" "blue" "blue" "yellow")
    flag 0
  );endsetq

  (command
      "layer" "t" "*"
  );endcommand

  (foreach pnivel nnivel
   (progn
    (command
      "m" pnivel
      "lt" (nth flag lnivel) pnivel
      "c" (nth flag cnivel) pnivel
    );endcommand
    (setq flag (1+ flag))
  ));endprogn,foreach

  (command
      "s" "0"
      "lt" "continuous" "0"
      "c" "blue" "0" ""

      "insert" (V:AID "SET/SET0bc01") "0,0" "1,1" 0
  );endcommand
  (setq
    nnivel nil
    lnivel nil
    cnivel nil
    pnivel nil
    flag nil
  );endsetq
  (prompt"Ok.")
)) ;endif,progn
(princ)
