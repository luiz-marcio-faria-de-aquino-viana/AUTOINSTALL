# Microsoft Developer Studio Project File - Name="aci_base" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 5.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=aci_base - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "aci_base.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "aci_base.mak" CFG="aci_base - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "aci_base - Win32 Release" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE "aci_base - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "aci_base - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /MT /W3 /GX /O2 /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "SDS_MEMORY" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /o NUL /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /o NUL /win32
# ADD BASE RSC /l 0x416 /d "NDEBUG"
# ADD RSC /l 0x416 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386 /force /out:"aci_base.dll"

!ELSEIF  "$(CFG)" == "aci_base - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /FD /c
# ADD CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "SDS_MEMORY" /YX /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o NUL /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o NUL /win32
# ADD BASE RSC /l 0x416 /d "_DEBUG"
# ADD RSC /l 0x416 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /force /out:"aci_base.dll" /pdbtype:sept

!ENDIF 

# Begin Target

# Name "aci_base - Win32 Release"
# Name "aci_base - Win32 Debug"
# Begin Group "src"

# PROP Default_Filter "cpp;c"
# Begin Source File

SOURCE=.\Src\Aci_base.cpp
# End Source File
# Begin Source File

SOURCE=.\Src\Aci_def.cpp
# End Source File
# Begin Source File

SOURCE=.\Src\Aci_err.cpp
# End Source File
# Begin Source File

SOURCE=.\Src\Aci_fil.cpp
# End Source File
# Begin Source File

SOURCE=.\Src\Aci_il.cpp
# End Source File
# Begin Source File

SOURCE=.\Src\Aci_net.cpp
# End Source File
# Begin Source File

SOURCE=.\Src\Aci_rbf.cpp
# End Source File
# Begin Source File

SOURCE=.\Src\Aci_str.cpp
# End Source File
# Begin Source File

SOURCE=.\Src\Aci_xl.cpp
# End Source File
# Begin Source File

SOURCE=.\sds\Entpoint.c
# End Source File
# End Group
# Begin Group "inc"

# PROP Default_Filter "h"
# Begin Source File

SOURCE=.\Inc\Aci_base.h
# End Source File
# Begin Source File

SOURCE=.\Inc\Aci_def.h
# End Source File
# Begin Source File

SOURCE=.\Inc\Aci_err.h
# End Source File
# Begin Source File

SOURCE=.\Inc\Aci_fil.h
# End Source File
# Begin Source File

SOURCE=.\Inc\Aci_il.h
# End Source File
# Begin Source File

SOURCE=.\Inc\Aci_net.h
# End Source File
# Begin Source File

SOURCE=.\Inc\Aci_rbf.h
# End Source File
# Begin Source File

SOURCE=.\Inc\Aci_str.h
# End Source File
# Begin Source File

SOURCE=.\Inc\Aci_xl.h
# End Source File
# Begin Source File

SOURCE=.\inc\All.h
# End Source File
# End Group
# Begin Group "lib"

# PROP Default_Filter "lib"
# Begin Source File

SOURCE=.\sds\sds.lib
# End Source File
# End Group
# End Target
# End Project
