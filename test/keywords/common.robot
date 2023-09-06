*** Settings ***
Library             AppiumLibrary
Library             FakerLibrary        locale=en_IN
Library             String

*** Variables ***
${BROWSER}          chromium
${HEADLESS}         ${True}
${BROWSER_TIMEOUT}  60 seconds
${SHOULD_TIMEOUT}   0.3 seconds
${IS_EMULATOR}      ${True}

${STATE}            Evaluate  json.loads('''{}''')  json
${ANDROID_AUTOMATION_NAME}    UIAutomator2
${ANDROID_APP}                ${CURDIR}/../../build/app/outputs/flutter-apk/app-debug.apk
${ANDROID_PLATFORM_NAME}      Android
${ANDROID_PLATFORM_VERSION}   %{ANDROID_PLATFORM_VERSION=11}

*** Keywords ***
Login to admin
  When Click "Bỏ qua" button
  When Click "Bắt đầu" button
  When Enter "email" in "Địa chỉ Email" with "admin@gmail.com"
  When Enter "text" in "Mật khẩu" with "123123"
  When Click "Đăng nhập" button

#### Setup e Teardown
Setup
  IF    ${IS_EMULATOR}
    # Open Application  http://127.0.0.1:4723/wd/hub  automationName=${ANDROID_AUTOMATION_NAME}
    # ...  platformName=${ANDROID_PLATFORM_NAME}  platformVersion=${ANDROID_PLATFORM_VERSION}
    # ...  app=${ANDROID_APP}  appPackage=com.uberental.uberental  appActivity=com.uberental.uberental.MainActivity
    Open Application
    ...  http://localhost:4723/wd/hub
    ...  platformName=Android
    ...  deviceName=emulator-5554
    ...  appPackage=com.flutter.flutter.flutter_app
    ...  appActivity=com.flutter.flutter.flutter_app.MainActivity
    ...  automationName=UIAutomator2
    ...  app=${ANDROID_APP}
  ELSE
    Open Application
    ...  http://localhost:4723/wd/hub
    ...  platformName=Android
    ...  deviceName=LMV500N896a582a
    ...  appPackage=com.flutter.flutter.flutter_app
    ...  appActivity=com.flutter.flutter.flutter_app.MainActivity
    ...  automationName=UIAutomator2
  END

Tear Down
  Close All Applications

Check Keyboard
  ${check}=       Is Keyboard Shown
  IF  ${check} and ${IS_EMULATOR} == ${False}
    Hide Keyboard
  ELSE IF  ${IS_EMULATOR} == ${True}
    Hide Keyboard
  END

Check Text
  [Arguments]               ${text}
  ${containsS}=             Get Regexp Matches                ${text}                       _@(.+)@_                    1
  ${cntS}=                  Get length                        ${containsS}
  IF  ${cntS} > 0
    ${text}=                Set Variable                      ${STATE["${containsS[0]}"]}
  END
  [Return]    ${text}

###  -----  Form  -----  ###
Get Random Text
  [Arguments]               ${type}                           ${text}
  ${symbol}                 Set Variable                      _RANDOM_
  ${new_text}               Set Variable
  ${containsS}=             Get Regexp Matches                ${text}                       _@(.+)@_                    1
  ${cntS}=                  Get length                        ${containsS}
  ${contains}=              Get Regexp Matches                ${text}                       ${symbol}
  ${cnt}=                   Get length                        ${contains}
  IF  ${cntS} > 0
    ${new_text}=            Set Variable                      ${STATE["${containsS[0]}"]}
    ${symbol}=              Set Variable                      _@${containsS[0]}@_
  ELSE IF  ${cnt} > 0 and '${type}' == 'test name'
    ${random}=              FakerLibrary.Sentence             nb_words=3
    ${words}=               Split String                      ${TEST NAME}                  ${SPACE}
    ${new_text}=            Set Variable                      ${words[0]} ${random}
  ELSE IF  ${cnt} > 0 and '${type}' == 'number'
    ${new_text}=            FakerLibrary.Random Int
    ${new_text}=            Convert To String                 ${new_text}
  ELSE IF  ${cnt} > 0 and '${type}' == 'percentage'
    ${new_text}=            FakerLibrary.Random Int           max=100
    ${new_text}=            Convert To String                 ${new_text}
  ELSE IF  ${cnt} > 0 and '${type}' == 'paragraph'
    ${new_text}=            FakerLibrary.Paragraph
  ELSE IF  ${cnt} > 0 and '${type}' == 'email'
    ${new_text}=            FakerLibrary.Email
  ELSE IF  ${cnt} > 0 and '${type}' == 'phone'
    ${new_text}=            FakerLibrary.Random Int           min=55555555                  max=999999999999
    ${new_text}=            Convert To String                 ${new_text}
  ELSE IF  ${cnt} > 0 and '${type}' == 'color'
    ${new_text}=            FakerLibrary.Safe Hex Color
  ELSE IF  ${cnt} > 0 and '${type}' == 'date'
    ${new_text}=            FakerLibrary.Date  	              pattern=%d-%m-%Y
  ELSE IF  ${cnt} > 0 and '${type}' == 'word'
    ${new_text}=            FakerLibrary.Sentence             nb_words=2
  ELSE IF  ${cnt} > 0
    ${new_text}=            FakerLibrary.Sentence
  END
    ${cnt}=                 Get Length                        ${text}
  IF  ${cnt} > 0
    ${text}=                Replace String                    ${text}                       ${symbol}                   ${new_text}
  END
  [Return]    ${text}

Get Element Form Item By Name
  [Arguments]               ${name}                           ${xpath}=${EMPTY}
  [Return]                  //android.widget.EditText/android.view.View[@content-desc="${name}"]${xpath}

Required message "${name}" displayed under "${text}" field
  ${element}=               Get Element Form Item By Name     ${name}                       /ancestor::android.widget.EditText/android.view.View[@content-desc="${text}"]
  Wait Until Element Is Visible                               ${element}
  
Get Select Option Element Form Item By Name
  [Arguments]               ${name}                           ${xpath}=${EMPTY}
  [Return]                  //android.view.View/android.view.View[@content-desc="${name}"]${xpath}
  
Required message from select option "${name}" displayed under "${text}" field
  ${element}=               Get Select Option Element Form Item By Name         ${name}                      /ancestor::android.view.View//android.view.View[@content-desc="${text}"]
  Wait Until Element Is Visible                               ${element}

  # ${element}=               Set Variable                      //android.view.View/android.view.View[@content-desc="${name}"]
  # ${element}=               Set Variable                      //android.view.View[@content-desc="${name}"]/ancestor::android.view.View//android.view.View[@content-desc="${text}"]

Enter "${type}" in "${name}" with "${text}"
  ${text}=                  Get Random Text                   ${type}                       ${text}
  ${element}=               Get Element Form Item By Name     ${name}                       /ancestor::android.widget.EditText

  Sleep                     ${SHOULD_TIMEOUT}
  Wait Until Page Contains Element                            ${element}
  Scroll                    ${element}                        ${element}/ancestor::android.view.View[1]
  Click Element             ${element}
  Clear Text                ${element}
  Input Text                ${element}                        ${text}
  ${cnt}=                   Get Length                        ${text}
  IF  ${cnt} > 0
    Set Global Variable     ${STATE["${name}"]}               ${text}
  END
  Check Keyboard

Scroll to "${name}" element
  Sleep                     ${SHOULD_TIMEOUT}
  ${element}=               Set Variable                      //android.view.View[@content-desc="${name}"]/parent::*
  Wait Until Page Contains Element                            ${element}
  Scroll                    ${element}                        ${element}/ancestor::android.view.View[1]

#Enter "${type}" in textarea "${name}" with "${text}"
#  ${text}=                  Get Random Text                   ${type}                       ${text}
#  ${element}=               Get Element Form Item By Name     ${name}                       //textarea
#  Clear Text                ${element}
#  Fill Text                 ${element}                        ${text}
#  ${cnt}=                   Get Length                        ${text}
#  IF  ${cnt} > 0
#    Set Global Variable     ${STATE["${name}"]}               ${text}
#  END
#
#Enter date in "${name}" with "${text}"
#  ${text}=                  Get Random Text                   date                          ${text}
#  ${element}=               Get Element Form Item By Name     ${name}                       //*[contains(@class, "ant-picker-input")]/input
#  Click                     ${element}
#  Clear Text                ${element}
#  Fill Text                 ${element}                        ${text}
#  Press Keys                ${element}                        Tab
#  Press Keys                ${element}                        Tab
#  ${cnt}=                   Get Length                        ${text}
#  IF  ${cnt} > 0
#      Set Global Variable   ${STATE["${name}"]}               ${text}
#  END
#
Click select "${name}" with "${text}"
  ${text}=                  Get Random Text                   Text                          ${text}
  ${element}=               Set Variable                      //android.view.View/android.view.View[@content-desc="${name}"]
  Wait Until Page Contains Element                            ${element}
  Scroll                     ${element}/ancestor::android.view.View[1]                       ${element}/ancestor::android.view.View[2]
  Click Element             ${element}
  ${element}=               Set Variable                      //android.view.View[@content-desc="${name}"]/ancestor::android.view.View//android.view.View[@content-desc="${text}"]
  Wait Until Page Contains Element                            ${element}
  Click Element             ${element}
  ${cnt}=                   Get Length                        ${text}
  IF  ${cnt} > 0
    Set Global Variable     ${STATE["${name}"]}               ${text}
  END

#Enter "${type}" in editor "${name}" with "${text}"
#  ${text}=                  Get Random Text                   ${type}                       ${text}
#  ${element}=               Get Element Form Item By Name     ${name}                       //*[contains(@class, "ce-paragraph")]
#  Clear Text                                                  ${element}
#  Fill Text                                                   ${element}                    ${text}
#
#Select file in "${name}" with "${text}"
#  ${element}=               Get Element Form Item By Name     ${name}                       //input[@type = "file"]
#  Upload File By Selector   ${element}                        test/upload/${text}
#
#Click radio "${name}" in line "${text}"
#  ${element}=               Get Element Form Item By Name     ${name}                       //*[contains(@class, "ant-radio-button-wrapper")]/span[contains(text(), "${text}")]
#  Click                     ${element}
#
#Click switch "${name}" to be activated
#  ${element}=               Get Element Form Item By Name     ${name}                       //button[contains(@class, "ant-switch")]
#  Click                     ${element}
#
#Click tree select "${name}" with "${text}"
#  ${text}=                  Get Random Text                   Text                          ${text}
#  ${element}=               Get Element Form Item By Name     ${name}                       //*[contains(@class, "ant-tree-select")]
#  Click                     ${element}
#  Fill Text                 ${element}//input                 ${text}
#  Click                     xpath=//*[contains(@class, "ant-select-tree-node-content-wrapper") and @title="${text}"]
#
#Click assign list "${list}"
#  ${words}=                 Split String                      ${list}                       ,${SPACE}
#  FOR    ${word}    IN    @{words}
#    Click                   xpath=//*[contains(@class, "ant-checkbox-wrapper")]/*[text()="${word}"]
#  END
#  Click                     xpath=//*[contains(@class, "ant-transfer-operation")]/button[2]


###  -----  Table  -----  ###
#Get Element Item By Name
#  [Arguments]               ${name}                           ${xpath}=${EMPTY}
#  [Return]                  xpath=//*[contains(@class, "item-text") and contains(text(), "${name}")]/ancestor::*[contains(@class, "item")]${xpath}
#
#Click on the "${text}" button in the "${name}" item line
#  Wait Until Element Spin
#  ${name}=                  Check Text                        ${name}
#  ${element}=               Get Element Item By Name          ${name}                       //button[@title = "${text}"]
#  Click                     ${element}
#  Click Confirm To Action
#
#Get Element Table Item By Name
#  [Arguments]               ${name}                           ${xpath}
#  [Return]                  xpath=//*[contains(@class, "ant-table-row")]//*[contains(text(), "${name}")]/ancestor::tr${xpath}
#
#Click on the "${text}" button in the "${name}" table line
#  Wait Until Element Spin
#  ${name}=                  Check Text                        ${name}
#  ${element}=               Get Element Table Item By Name    ${name}                       //button[@title = "${text}"]
#  Click                     ${element}
#  Click Confirm To Action


###  -----  Tree  -----  ###
#Get Element Tree By Name
#  [Arguments]               ${name}                           ${xpath}=${EMPTY}
#  [Return]                  xpath=//*[contains(@class, "ant-tree-node-content-wrapper") and @title = "${name}"]/*[contains(@class, "group")]${xpath}
#
#Click on the previously created "${name}" tree to delete
#  Wait Until Element Spin
#  ${name}=                  Check Text                        ${name}
#  ${element}=               Get Element Tree By Name          ${name}
#  Scroll To Element         ${element}
#  Mouse Move Relative To    ${element}                        0
#  Click                     ${element}//*[contains(@class, "la-trash")]
#  Click Confirm To Action
#
#Click on the previously created "${name}" tree to edit
#  Wait Until Element Spin
#  ${name}=                  Check Text                        ${name}
#  ${element}=               Get Element Tree By Name          ${name}
#  Click                     ${element}


###  -----  Element  -----  ###
Click "${text}" button
  ${element}=                       Set Variable  //android.widget.Button[@content-desc="${text}"]
  Wait Until Page Contains Element  ${element}
  Click Element                     ${element}

#Click "${text}" tab button
#  Click                     xpath=//*[contains(@class, "ant-tabs-tab-btn") and contains(text(), "${text}")]
#
#Select on the "${text}" item line
#  Wait Until Element Spin
#  ${element}=               Get Element Item By Name          ${text}
#  Click                     ${element}
#
#Click "${text}" menu
#  Click                     xpath=//li[contains(@class, "menu") and descendant::span[contains(text(), "${text}")]]
#
#Click "${text}" sub menu to "${url}"
#  Wait Until Element Spin
#  Click                     xpath=//a[contains(@class, "sub-menu") and descendant::span[contains(text(), "${text}")]]
#  ${curent_url}=            Get Url
#
User look message "${message}" with title "${title}" popup
  Sleep                     0.1
  ${contains}=              Get Regexp Matches                ${message}                    _@(.+)@_                    1
  ${cnt}=                   Get length                        ${contains}
  IF  ${cnt} > 0
    ${message}=             Replace String                    ${message}                    _@${contains[0]}@_          ${STATE["${contains[0]}"]}
  END
  Wait Until Page Contains   ${title}
  Wait Until Page Contains   ${message}
#
#Click Confirm To Action
#  ${element}                Set Variable                      xpath=//*[contains(@class, "ant-popover")]//*[contains(@class, "ant-btn-primary")]
#  ${count}=                 Get Element Count                 ${element}
#  IF    ${count} > 0
#    Click                   ${element}
#    Sleep                   ${SHOULD_TIMEOUT}
#  END
#
#Wait Until Element Spin
#  Sleep                     ${SHOULD_TIMEOUT}
#  ${element}                Set Variable                      xpath=//*[contains(@class, "ant-spin-spinning")]
#  ${count}=                 Get Element Count                 ${element}
#  IF    ${count} > 0
#    Wait Until Page Does Not Contain Element                  ${element}
#  END
