!include "StrFunc.nsh"
Var GaVisitorId
Var GaRequests
!macro GoogleAnalytics Account Category Action Label Value
    Push $0
    Push $1
    Push $2
    Push $3
    Push $4
    Push $5
    Push $6
    ${If} $GaRequests == ""
        StrCpy $GaRequests 0
    ${EndIf}
    IntOp $GaRequests $GaRequests + 1
    ${If} $GaVisitorId == ""
        System::Alloc 80 
        System::Alloc 16 
        System::Call 'ole32::CoCreateGuid(i sr1) i' 
        System::Call 'ole32::StringFromGUID2(i r1, i sr2, i 80) i' 
        System::Call 'kernel32::WideCharToMultiByte(i 0, i 0, i r2, i 80, t .r0, i ${NSIS_MAX_STRLEN}, i 0, i 0) i' 
        System::Free $1 
        System::Free $2
        StrCpy $2 ""
        StrCpy $3 $0
        StrCpy $0 0
        ${While} $0 < 16 
            StrCpy $4 $3 1
            StrCpy $3 $3 -1 1
            ${If} $4 != "{"
            ${AndIf} $4 != "}"
            ${AndIf} $4 != "-"
                StrCpy $2 "$2$4"
                IntOp $0 $0 + 1
            ${EndIf}
        ${EndWhile}
        StrCpy $GaVisitorId $2
    ${EndIf}
    StrCpy $0 "Mozilla/4.0 (compatible; NSIS; Windows"
    ClearErrors
    ReadRegStr $1 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\" "CurrentVersion"
    ${If} ${Errors}
        ReadRegStr $1 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\" "CurrentVersion"
    ${Else}
        StrCpy $0 "$0 NT"
    ${EndIf}
    StrCpy $0 "$0 $1"
    System::Call 'kernel32::GetSystemDefaultLangID() i .r1'
    System::Call 'kernel32::GetLocaleInfoA(i 1024, i 0x59, t .r2, i ${NSIS_MAX_STRLEN}) i r1'
    System::Call 'kernel32::GetLocaleInfoA(i 1024, i 0x5A, t .r3, i ${NSIS_MAX_STRLEN}) i r1'
    StrCpy $2 "$2-$3"
    StrCpy $0 "$0; $2"
    StrCpy $0 "$0)"
    System::Call 'user32::GetSystemMetrics(i 0) i .r1'
    System::Call 'user32::GetSystemMetrics(i 1) i .r5'
    StrCpy $1 "$1x$5"
    System::Call 'user32::GetWindowDC(i $HWNDPARENT) i .r5'
    System::Call 'gdi32::GetDeviceCaps(i $5, i 12) i .r6'
    StrCpy $4 "http://www.google-analytics.com/__utm.gif?utmwv=5.3.6&utmhn=&utmr=-&utmp=&utmac=${Account}&utmcc=__utma%3D999.999.999.999.999.1%3B"
    StrCpy $4 "$4&utmt=event&utme=5(${Category}*${Action}*${Label})(${Value})&utmvid=0x$GaVisitorId&utmsr=$1&utmsc=$6-bit&utms=$GaRequests&guid=on"
    GetTempFileName $3
    inetc::get /SILENT /CONNECTTIMEOUT 5 /HEADER "Accept-Language: $2" /USERAGENT $0 /RECEIVETIMEOUT 5 $4 $3
    Delete $3
    Pop $6
    Pop $5
    Pop $4
    Pop $3
    Pop $2
    Pop $1
    Pop $0
!macroend

