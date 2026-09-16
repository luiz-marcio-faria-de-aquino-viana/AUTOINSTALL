
'''
''' ILCALC.BAS
''' Copyright (C) 1998 by Luiz Marcio F A Viana, 6/10/98
'''

''' DEFINICAO DAS CONSTANTES DA CAIXA DE DIALOGO OpenFile
Const OFN_FILEMUSTEXIST = &H1000&
Const OFN_HIDEREADONLY = &H4&

''' DEFINICAO DAS VARIAVEIS
'''  CD - CODIGO DO REFLETOR
'''  FL - FLUXO LUMINOSO POR REFLETOR
'''  IM - INDICE MEDIO DESEJADO
'''  FT - FATOR DE DEPRECIACAO
'''  VT - NUMERO DE VERTICES DA AREA

''' CURVA DE CONTRIBUICAO LUMINOSA DO REFLETOR
Global GX(20) As Double, IX(20) As Double
Global GY(20) As Double, IY(20) As Double

''' VERTICES DA AREA DE CALCULO
Global VX(20) As Double, VY(20) As Double

''' COORDENADAS DOS REFLETORES E RESPECTIVOS FOCOS
Global RX(50) As Double, RY(50) As Double, RZ(50) As Double
Global FX(50) As Double, FY(50) As Double

''' CONTROLE DE REFLETOR LIGADO OU DESLIGADO
Global LG(50) As Integer

''' CONTRIBUICAO DE ILUMINACAO DE CADA REFLETOR POR SETOR
Global FR(50, 19, 30) As Double

''' TOTAL DE ILUMINACAO POR SETOR
Global ET(19, 30) As Double

Sub Delay (T As Integer)
  Ctime = Time
  Do While (Time - Ctime) < (T / 100000#)
    '' nao processa qualquer operacao
  Loop
End Sub

Sub Main ()

Dim NM As String, CDIR As String

Dim IX1 As Double, IY1 As Double
Dim ET1 As Double

Dim i As Integer, K As Integer

Dim X As Integer, Y As Integer

Dim d1 As Double, d2 As Double
Dim N As Integer

Dim Dummy As String
Dim TmpGX As String, TmpIX As String
Dim TmpGY As String, TmpIY As String

'''
''' CARREGA FORMULARIO DE ABERTURA
'''

Load Lumens
Lumens.Show

Lumens.MsgBox.Caption = "Selecione o arquivo de entrada..."
Lumens.MsgBox.Refresh

Lumens!CMDialog1.Flags = OFN_FILEMUSTEXIST Or OFN_HIDEREADONLY
Lumens!CMDialog1.Action = 1


'''
''' RECUPERANDO DADOS DE ENTRADA
'''

Lumens.MsgBox.Caption = "Lendo o arquivo de entrada..."
Lumens.MsgBox.Refresh

NM = Command
If NM = "" Then
  Lumens.MsgBox.Caption = "ERR: Numero invalido de parametros."
  Lumens.MsgBox.Refresh
  Delay 3
  End
End If

Open NM + ".IMP" For Input As #1
  Input #1, CD, FL, IM, FT, VT
  For i = 1 To 20
    Input #1, VX(i), VY(i)
  Next i
  Input #1, NR
  For i = 1 To 50
    Input #1, RX(i), RY(i), RZ(i), FX(i), FY(i)
  Next i
  Input #1, N
  For i = 1 To 19
    For X = 1 To 19
      Input #1, ET(X, i)
    Next X
  Next i
  For K = 1 To 50
    Input #1, LG(K)
  Next K
Close #1


'''
''' RECUPERANDO CURVA DE CONTRIBUICAO DO REFLETOR
'''

Lumens.MsgBox.Caption = "Pesquisando banco de dados de refletores..."
Lumens.MsgBox.Refresh

'''' CDIR = "S:\VBPROG\LUMENS\"
CDIR = Environ("LUMENS")
If CDIR = "" Then
  Lumens.MsgBox.Caption = "ERR: Variavel de ambiente nao definida."
  Delay 3
  End
End If

Open CDIR + "IXPRJTRS.DAT" For Input As #1
Open CDIR + "IYPRJTRS.DAT" For Input As #2

  For X = 1 To CD
    Input #1, Dummy, Dummy
    Input #2, Dummy, Dummy
    For i = 1 To 20
      Input #1, TmpGX, TmpIX
      Input #2, TmpGY, TmpIY
  
      GX(i) = Val(TmpGX) / 180 * 3.141592
      IX(i) = Val(TmpIX)
        
      GY(i) = Val(TmpGY) / 180 * 3.141592
      IY(i) = Val(TmpIY)
    Next i
  Next X

Close #1
Close #2


'''
''' DELIMITANDO A AREA DE CALCULO (RETANGULO)
'''

Lumens.MsgBox.Caption = "Analisando a área de calculo..."
Lumens.MsgBox.Refresh

X0 = VX(1)
Y0 = VY(1)

XM = X0
YM = Y0

For X = 1 To VT
  If VX(X) < X0 Then
    X0 = VX(X)
  Else
    If VX(X) > XM Then XM = VX(X)
  End If

  If VY(X) < Y0 Then
    Y0 = VY(X)
  Else
    If VY(X) > YM Then YM = VY(X)
  End If
Next X


'''
''' CALCULANDO VALOR DA AREA INCREMENTAL
'''

''' INCREMENTO DE AREA (DX)
d1 = (XM - X0) / 19

''' NUMERO DE INCREMENTOS DE AREA NA VERTICAL
N = Int((YM - Y0) / d1)

''' INCREMENTO DE AREA (DY)
d2 = (YM - Y0) / N


'''
''' PROCESSAMENTO DO CALCULO DE ILUMINACAO
'''

Lumens.MsgBox.Caption = "Processando..."
Lumens.MsgBox.Refresh

Y = N
While Y >= 1
  YP = Y0 + d2 / 2 + (Y - 1) * d2

  X = 1
  While X <= 19
    XP = X0 + d1 / 2 + (X - 1) * d1

    ET1 = ET(X, Y)
    For K = 1 To NR
      LP = Sqr((XP - RX(K)) ^ 2 + (YP - RY(K)) ^ 2 + RZ(K) ^ 2)
      LF = Sqr((FX(K) - RX(K)) ^ 2 + (FY(K) - RY(K)) ^ 2 + RZ(K) ^ 2)

      CT = ((XP - RX(K)) * (FX(K) - RX(K)) + (YP - RY(K)) * (FY(K) - RY(K)) + RZ(K) ^ 2) / (LP * LF)

      If CT >= 1 Then CT = 1

      If CT = 0 Then
        TE = 1.570796
      Else
        TE = Atn(Sqr((1 / CT ^ 2) - 1))
      End If

      HP = Sqr((XP - RX(K)) ^ 2 + (YP - RY(K)) ^ 2)
      HF = Sqr((FX(K) - RX(K)) ^ 2 + (FY(K) - RY(K)) ^ 2)

      If HP = 0 Or HF = 0 Then
        CG = 1
      Else
        CG = ((XP - RX(K)) * (FX(K) - RX(K)) + (YP - RY(K)) * (FY(K) - RY(K))) / (HP * HF)
        If CG >= 1 Then CG = 1
      End If

      If CG = 0 Then
        GA = 1.570796
        GoTo LOOP1
      End If
      
      GA = Atn(Sqr((1 / CG ^ 2) - 1))
      
      If CT = 1 Then CA = 1: GoTo LOOP2
      
LOOP1:

      A = HP * Sqr(1 - CG ^ 2)
      CA = A / (LP * Sqr(1 - CT ^ 2))
      If CA >= 1 Then CA = 1
      
LOOP2:

      If CA = 0 Then
        AL = 1.57
      Else
        AL = Atn(Sqr((1 / CA ^ 2) - 1))
      End If

      ''' EFETUANDO A ANALISE ANGULAR

      W = 0
      U = 0

      For T = 2 To 20
        If TE < GX(T) And U = 0 Then
          T1 = T
          U = 1
        End If
        If TE < GY(T) And W = 0 Then
          T2 = T
          W = 1
        End If
      Next T

      If U = 0 Then
        IX1 = 0
      Else
        IX1 = IX(T1 - 1) + ((TE - GX(T1 - 1)) / (GX(T1) - GX(T1 - 1))) * (IX(T1) - IX(T1 - 1))
      End If
      
      If W = 0 Then
        IY1 = 0
      Else
        IY1 = IY(T2 - 1) + ((TE - GY(T2 - 1)) / (GY(T2) - GY(T2 - 1))) * (IY(T2) - IY(T2 - 1))
      End If

      i = IX1 + AL / 90 * (IY1 - IX1)
      IP = i * FL * (FT / 100) / 1000
      E = IP * RZ(K) / LP ^ 3
      FR(K, X, Y) = E * 10

      If LG(K) = -1 Then ET1 = ET1 + E

    Next K

    ET(X, Y) = ET1
    X = X + 1
  Wend

  Y = Y - 1
Wend


'''
''' CONSTRUINDO ARQUIVO DE SAIDA
'''

Lumens.MsgBox.Caption = "Construindo o arquivo de saída..."
Lumens.MsgBox.Refresh

Open NM + ".IMP" For Output As #1
  Print #1, CD
  Print #1, FL
  Print #1, IM
  Print #1, FT
  Print #1, VT
  For i = 1 To 20
    Print #1, VX(i)
    Print #1, VY(i)
  Next i
  Print #1, NR
  For i = 1 To 50
    Print #1, RX(i)
    Print #1, RY(i)
    Print #1, RZ(i)
    Print #1, FX(i)
    Print #1, FY(i)
  Next i
  Print #1, N
  For i = 1 To 19
    For X = 1 To 19
      Print #1, ET(X, i)
    Next X
  Next i
  For K = 1 To 50
    Print #1, LG(K)
  Next K
Close #1


'''
''' DESCARREGANDO O FORMULARIO DE ABERTURA
'''

Unload Lumens

End Sub

