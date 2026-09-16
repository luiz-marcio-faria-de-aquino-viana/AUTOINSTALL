
'''
''' ILCALC.BAS
''' Copyright (C) 1998 by Luiz Marcio F A Viana, 6/10/98
'''

''' DEFINICAO DAS VARIAVEIS
'''  CD - CODIGO DO REFLETOR
'''  FL - FLUXO LUMINOSO POR REFLETOR
'''  IM - INDICE MEDIO DESEJADO
'''  FT - FATOR DE DEPRECIACAO
'''  VT - NUMERO DE VERTICES DA AREA

''' CURVA DE CONTRIBUICAO LUMINOSA DO REFLETOR
DIM GX(20), IX(20)
DIM GY(20), IY(20)

''' VERTICES DA AREA DE CALCULO
DIM VX(20), VY(20)

''' COORDENADAS DOS REFLETORES E RESPECTIVOS FOCOS
DIM RX(50), RY(50), RZ(50)
DIM FX(50), FY(50)

''' CONTROLE DE REFLETOR LIGADO OU DESLIGADO
DIM LG%(50)

''' CONTRIBUICAO DE ILUMINACAO DE CADA REFLETOR POR SETOR
DIM FR%(50,19,30)

''' TOTAL DE ILUMINACAO POR SETOR
DIM ET(19,30)


'''
''' RECUPERANDO DADOS DE ENTRADA
'''

NM$ = COMMAND$
IF NM$ = "" THEN
  PRINT "ERR: Numero invalido de parametros."
  END
END IF

OPEN "I", #1, NM$ + ".IMP"
  INPUT #1, CD, FL, IM, FT, VT
  FOR I = 1 TO 20
    INPUT #1, VX(I), VY(I)
  NEXT I
  INPUT #1, NR
  FOR I = 1 TO 50
    INPUT #1, RX(I), RY(I), RZ(I), FX(I), FY(I)
  NEXT I
  INPUT #1, N
  FOR I = 1 TO 19
    FOR X = 1 TO 19
      INPUT #1, ET(X,I)
    NEXT X
  NEXT I
  FOR K = 1 TO 50
    INPUT #1, LG%(K)
  NEXT K
CLOSE #1


'''
''' RECUPERANDO CURVA DE CONTRIBUICAO DO REFLETOR
'''

CD$ = ENVIRON$("LUMENS")
IF CD$ = "" THEN
  PRINT "ERR: Variavel de ambiente nao definida."
  END
END IF

OPEN "R", #1, CD$ + "IXPRJTRS", 64
OPEN "R", #2, CD$ + "IYPRJTRS", 64

  RG = (CD - 1) * 20
  FOR X = 1 TO 20
    GET #1, RG + X
    INPUT #1, C$

    GX(X) = VAL(MID$(C$, 17, 5)) / 180 * 3.141592
    IX(X) = VAL(MID$(C$, 23, 8))

    GET #2, RG + X
    INPUT #2, C$

    GY(X) = VAL(MID$(C$, 17, 5)) / 180 * 3.141592
    IY(X) = VAL(MID$(C$, 23, 8))
  NEXT X

CLOSE #1
CLOSE #2


'''
''' DELIMITANDO A AREA DE CALCULO (RETANGULO)
'''

X0 = VX(1)
Y0 = VY(1)

XM = X0
YM = Y0

FOR X = 1 TO VT
  IF VX(X) < X0 THEN
    X0 = VX(X)
  ELSE
    IF VX(X) > XM THEN XM = VX(X)
  END IF

  IF VY(X) < Y0 THEN
    Y0 = VY(X)
  ELSE
    IF VY(X) > YM THEN YM = VY(X)
  END IF
NEXT X


'''
''' CALCULANDO VALOR DA AREA INCREMENTAL
'''

''' INCREMENTO DE AREA (DX)
D1 = (XM - X0) / 19

''' NUMERO DE INCREMENTOS DE AREA NA VERTICAL
N = INT((YM - Y0) / D1)

''' INCREMENTO DE AREA (DY)
D2 = (YM - Y0) / N


'''
''' PROCESSAMENTO DO CALCULO DE ILUMINACAO
'''

Y = N
WHILE Y >= 1
  YP = Y0 + D2 / 2 + (Y - 1) * D2

  X=1
  WHILE X <= 19
    XP = X0 + D1 / 2 + (X - 1) * D1

    ET=0
    FOR K=1 TO NR
      LP = SQR((XP - RX(K))^2 + (YP - RY(K))^2 + RZ(K)^2)
      LF = SQR((FX(K) - RX(K))^2 + (FY(K) - RY(K))^2 + RZ(K)^2)

      CT = ((XP - RX(K)) * (FX(K) - RX(K)) + (YP - RY(K)) * (FY(K) - RY(K)) + RZ(K)^2) / (LP * LF)

      IF CT >= 1 THEN CT = 1

      IF CT = 0 THEN TE = 1.570796 : GOTO LOOP1
      TE=ATN(SQR((1/CT^2)-1))
LOOP1:

      HP = SQR((XP - RX(K))^2 + (YP - RY(K))^2)
      HF = SQR((FX(K) - RX(K))^2 + (FY(K) - RY(K))^2)

      IF HP = 0 OR HF = 0 THEN CG = 1 : GOTO LOOP2
      CG = ((XP - RX(K)) * (FX(K) - RX(K)) + (YP - RY(K)) * (FY(K) - RY(K))) / (HP * HF)
      IF CG >= 1 THEN CG = 1
LOOP2:

      IF CG = 0 THEN GA = 1.570796 : GOTO LOOP3
      GA = ATN(SQR((1 / CG^2) - 1))

      IF CT = 1 THEN CA = 1 : GOTO LOOP4
LOOP3:

      A = HP * SQR(1 - CG^2)
      CA = A / (LP * SQR(1 - CT^2))
      IF CA >= 1 THEN CA = 1
LOOP4:
      IF CA = 0 THEN
	AL = 1.57
      ELSE
	AL = ATN(SQR((1 / CA^2) - 1))
      END IF

      ''' EFETUANDO A ANALISE ANGULAR

      W = 0
      U = 0

      FOR T = 2 TO 20
	IF TE < GX(T) AND U = 0 THEN
	  T1 = T
	  U = 1
	END IF
	IF TE < GY(T) AND W = 0 THEN
	  T2 = T
	  W = 1
	END IF
      NEXT T

      IF U = 0 THEN IX = 0 : GOTO LOOP5
      IX = IX(T1 - 1) + ((TE - GX(T1 - 1)) / (GX(T1) - GX(T1 - 1))) * (IX(T1) - IX(T1 - 1))
LOOP5:

      IF W = 0 THEN IY = 0 : GOTO LOOP6
      IY = IY(T2 - 1)+((TE - GY(T2 - 1)) / (GY(T2) - GY(T2 - 1))) * (IY(T2) - IY(T2 - 1))
LOOP6:

      I = IX + AL / 90 * (IY - IX)
      IP = I * FL * (FT / 100) / 1000
      E = IP * RZ(K) / LP^3
      FR%(K, X, Y) = E * 10

      IF LG%(K)=0 THEN GOTO LOOP7
      ET=ET+E
LOOP7:

    NEXT K

    ET(X, Y) = ET
    X = X + 1
  WEND

  Y = Y - 1
WEND


'''
''' CONSTRUINDO ARQUIVO DE SAIDA
'''

OPEN "O", #1, NM$ + ".IMP"
  PRINT #1, CD, FL, IM, FT, VT
  FOR I = 1 TO 20
    PRINT #1, VX(I), VY(I)
  NEXT I
  PRINT #1, NR
  FOR I = 1 TO 50
    PRINT #1, RX(I), RY(I), RZ(I), FX(I), FY(I)
  NEXT I
  PRINT #1, N
  FOR I = 1 TO 19
    FOR X = 1 TO 19
      PRINT #1, ET(X,I)
    NEXT X
  NEXT I
  FOR K = 1 TO 50
    PRINT #1, LG%(K)
  NEXT K
CLOSE #1

FIM:
  END

