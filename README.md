Google Analytics for NSIS

This script will allow you to add google analytics event tracking into your NSIS installer. It is useful for tracking installer based events such as the number of successful installs. With Google Analytics you'll be able to determine where most of your installs are coming from. If you have a donate button or offer you can use the event tracking to determine how many people donated or accepted the offer.

Specify the include at the top of your nsh script:

!include "ga.nsh"

To track an event use the following

!insertmacro GoogleAnalytics "UA-12312312-3" "Category" "Action" "Label" "Value"

Example events to track:

```
Function .onInit
    !insertmacro GoogleAnalytics "UA-12312312-3" "Install" "Started" "" ""
FunctionEnd
Function .onInstFailed
    !insertmacro GoogleAnalytics "UA-12312312-3" "Install" "Failed" "" ""
FunctionEnd
Function .onInstSuccess
    !insertmacro GoogleAnalytics "UA-12312312-3" "Install" "Success" "" ""
FunctionEnd
Function .onGUIEnd
    !insertmacro GoogleAnalytics "UA-12312312-3" "Install" "Ended" "" ""
FunctionEnd

Function un.onInit
    !insertmacro GoogleAnalytics "UA-12312312-3" "Uninstall" "Started" "" ""
FunctionEnd
Function un.onUninstFailed
    !insertmacro GoogleAnalytics "UA-12312312-3" "Uninstall" "Failed" "" ""
FunctionEnd
Function un.onUninstSuccess
    !insertmacro GoogleAnalytics "UA-12312312-3" "Uninstall" "Success" "" ""
FunctionEnd
Function un.onGUIEnd
    !insertmacro GoogleAnalytics "UA-12312312-3" "Uninstall" "Ended" "" ""
FunctionEnd
```