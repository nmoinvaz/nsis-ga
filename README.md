Google Analytics for NSIS

This script will allow you to add google analytics event tracking into your NSIS installer. It is useful for tracking installer based events such as the number of successful installs that occured, or the number of offers accepted, or the number of users who clicked the donate button.

Specify the include at the top of your nsh script:

```
!include "ga.nsh"
```

To track an event use the following

```
!insertmacro GoogleAnalytics "YOUR_ACCOUNT_ID" "Category" "Action" "Label" "Value"
```

Example events to track:

```
Function .onInit
    !insertmacro GoogleAnalytics "YOUR_ACCOUNT_ID" "Install" "Started" "" ""
FunctionEnd
Function .onInstFailed
    !insertmacro GoogleAnalytics "YOUR_ACCOUNT_ID" "Install" "Failed" "" ""
FunctionEnd
Function .onInstSuccess
    !insertmacro GoogleAnalytics "YOUR_ACCOUNT_ID" "Install" "Success" "" ""
FunctionEnd
Function .onGUIEnd
    !insertmacro GoogleAnalytics "YOUR_ACCOUNT_ID" "Install" "Ended" "" ""
FunctionEnd

Function un.onInit
    !insertmacro GoogleAnalytics "YOUR_ACCOUNT_ID" "Uninstall" "Started" "" ""
FunctionEnd
Function un.onUninstFailed
    !insertmacro GoogleAnalytics "YOUR_ACCOUNT_ID" "Uninstall" "Failed" "" ""
FunctionEnd
Function un.onUninstSuccess
    !insertmacro GoogleAnalytics "YOUR_ACCOUNT_ID" "Uninstall" "Success" "" ""
FunctionEnd
Function un.onGUIEnd
    !insertmacro GoogleAnalytics "YOUR_ACCOUNT_ID" "Uninstall" "Ended" "" ""
FunctionEnd
```
This script requires the use of the [inetc](http://nsis.sourceforge.net/Inetc_plug-in) plugin