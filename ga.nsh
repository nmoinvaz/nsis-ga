Var GaVisitorId
Var GaRequests
!macro GoogleGetLocale
    System::Call 'kernel32::GetSystemDefaultLangID() i .r0'
    System::Call 'kernel32::GetLocaleInfoA(i 1024, i 0x59, t .r1, i ${NSIS_MAX_STRLEN}) i r0'
    StrCpy $2 "$1"
    System::Call 'kernel32::GetSystemDefaultLangID() i .r0'
    System::Call 'kernel32::GetLocaleInfoA(i 1024, i 0x5A, t .r1, i ${NSIS_MAX_STRLEN}) i r0'
    StrCpy $0 "$2-$1"
!macroend
!macro GoogleGetUserAgent
    !insertmacro GoogleGetLocale
    StrCpy $0 "Mozilla/4.0 (compatible; $0; NSIS; Windows"
    ClearErrors
    ReadRegStr $1 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\" "CurrentVersion"
    ${If} ${Errors}
        ReadRegStr $1 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\" "CurrentVersion"
    ${Else}
        StrCpy $0 "$0 NT"
    ${EndIf}
    StrCpy $0 "$0 $1)"
!macroend
!macro GoogleGuid
    System::Alloc 80 
    System::Alloc 16 
    System::Call 'ole32::CoCreateGuid(i sr1) i' 
    System::Call 'ole32::StringFromGUID2(i r1, i sr2, i 80) i' 
    System::Call 'kernel32::WideCharToMultiByte(i 0, i 0, i r2, i 80, t .r0, i ${NSIS_MAX_STRLEN}, i 0, i 0) i' 
    System::Free $1 
    System::Free $2
    StrCpy $2 $0
    StrCpy $1 0
    StrCpy $0 ""
    ${While} $1 < 16 
        StrCpy $3 $2 1
        StrCpy $2 $2 -1 1
        ${If} $3 != "{"
        ${AndIf} $3 != "}"
        ${AndIf} $3 != "-"
            StrCpy $0 "$0$3"
            IntOp $1 $1 + 1
        ${EndIf}
    ${EndWhile}
!macroend
!macro GoogleGetScreenSize
    System::Call 'user32::GetSystemMetrics(i 0) i .r0'
    System::Call 'user32::GetSystemMetrics(i 1) i .r1'
    StrCpy $0 "$0x$1"
!macroend
!macro GoogleGetScreenDepth
    System::Call 'user32::GetWindowDC(i $HWNDPARENT) i .r0'
    System::Call 'gdi32::GetDeviceCaps(i $0, i 12) i .r0'
    StrCpy $0 "$0-bit"
!macroend
!macro GoogleAnalytics Account Category Action Label Value
    Push $0
    Push $1
    Push $2
    Push $3
    Push $4
    ${If} $GaRequests == ""
        StrCpy $GaRequests 0
    ${EndIf}
    IntOp $GaRequests $GaRequests + 1
    ${If} $GaVisitorId == ""
        !insertmacro GoogleGuid
        StrCpy $GaVisitorId $0
    ${EndIf}
    !insertmacro GoogleGetLocale
    StrCpy $4 $0
    StrCpy $3 "http://www.google-analytics.com/__utm.gif"
    StrCpy $3 "$3?utmwv=5.3.6&utmhn=&utmr=-&utmp=&utmac=${Account}&utmcc=__utma%3D999.999.999.999.999.1%3B"
    StrCpy $3 "$3&utms=$GaRequests&utmvid=0x$GaVisitorId&guid=on&utmt=event&utme=5(${Category}*${Action}"
    ${If} "${Label}" != ""
        StrCpy $3 "$3*${Label}"
    ${EndIf}
    StrCpy $3 "$3)"
    ${If} "${Value}" != ""
        StrCpy $3 "$3(${Value})"
    ${EndIf}
    !insertmacro GoogleGetScreenSize
    StrCpy $3 "$3&utmsr=$0"
    !insertmacro GoogleGetScreenDepth
    StrCpy $3 "$3&utmsc=$0"
    !insertmacro GoogleGetUserAgent
    GetTempFileName $2
    inetc::get /SILENT /CONNECTTIMEOUT 5 /HEADER "Accept-Language: $4" /USERAGENT $0 /RECEIVETIMEOUT 5 $3 $2 /END
    Delete $2
    Pop $4
    Pop $3
    Pop $2
    Pop $1
    Pop $0
!macroend