*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime

*** Variables ***
${BASE_URL}        https://robot-lab-five.vercel.app/
${BROWSER}         chrome
${VALID_PASSWORD}  myPassword123

*** Test Cases ***
Test Login Successful
    [Documentation]    ทดสอบการเข้าสู่ระบบสำเร็จ
    ${email}    Set Variable    testuser_abc@gmail.com
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # คลิกปุ่ม Login
    Wait Until Element Is Visible    xpath=//button[contains(@class,'nav-btn-login')]    10s
    Click Element    xpath=//button[contains(@class,'nav-btn-login')]
    Sleep    2s
    
    # กรอกข้อมูลเข้าสู่ระบบ
    Input Text    id=loginEmail    ${email}
    Sleep    1s
    Input Text    id=loginPassword    ${VALID_PASSWORD}
    Sleep    1s
    
    # คลิกปุ่ม Submit
    Click Element    xpath=//button[@type='submit']
    Sleep    3s
    
    # ตรวจสอบข้อความเข้าสู่ระบบสำเร็จ
    Wait Until Element Is Visible    xpath=//*[contains(text(),'เข้าสู่ระบบสำเร็จ')]    5s
    Element Should Be Visible    xpath=//*[contains(text(),'เข้าสู่ระบบสำเร็จ')]
    
    # Capture screenshot เมื่อเข้าสู่ระบบสำเร็จ
    ${timestamp}    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    login_success_${timestamp}.png
    
    # ตรวจสอบข้อความยินดีต้อนรับ
    Wait Until Element Is Visible    xpath=//*[contains(text(),'ยินดีต้อนรับ')]    5s
    ${welcome_text}    Get Text    xpath=//*[contains(text(),'ยินดีต้อนรับ')]
    Should Contain    ${welcome_text}    testuser_abc@gmail.com
    Log    Welcome message: ${welcome_text}
    
    # Capture screenshot ข้อความยินดีต้อนรับ
    Capture Page Screenshot    welcome_message_${timestamp}.png
    
    Close Browser

Test Dashboard Access Without Login
    [Documentation]    ทดสอบเข้า Dashboard โดยไม่ได้เข้าสู่ระบบ
    Open Browser    ${BASE_URL}/dashboard    ${BROWSER}
    Maximize Browser Window
    
    # รอและตรวจสอบข้อความต้องเข้าสู่ระบบ
    Wait Until Element Is Visible    xpath=//*[contains(text(),'กรุณาเข้าสู่ระบบก่อน')]    10s
    Element Should Be Visible    xpath=//*[contains(text(),'กรุณาเข้าสู่ระบบก่อน')]
    
    # Capture screenshot 
    ${timestamp}    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    dashboard_no_login_${timestamp}.png
    
    Close Browser

Test Logout Functionality
    [Documentation]    ทดสอบการออกจากระบบ
    ${email}    Set Variable    testuser_abc@gmail.com
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # เข้าสู่ระบบ
    Wait Until Element Is Visible    xpath=//button[contains(@class,'nav-btn-login')]    10s
    Click Element    xpath=//button[contains(@class,'nav-btn-login')]
    Sleep    2s
    Input Text    id=loginEmail    ${email}
    Sleep    1s
    Input Text    id=loginPassword    ${VALID_PASSWORD}
    Sleep    1s
    Click Element    xpath=//button[@type='submit']
    Sleep    3s
    
    # รอให้เข้าสู่หน้า Dashboard
    Wait Until Element Is Visible    xpath=//h1[contains(text(),'Dashboard')]    10s
    
    # ตรวจสอบและคลิกปุ่ม Logout
    Wait Until Element Is Visible    xpath=//button[contains(text(),'Logout') or contains(text(),'ออกจากระบบ')]    5s
    Element Should Be Visible    xpath=//button[contains(text(),'Logout') or contains(text(),'ออกจากระบบ')]
    
    # Capture screenshot ก่อน logout
    ${timestamp}    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    before_logout_${timestamp}.png
    
    # คลิกปุ่ม logout
    Click Element    xpath=//button[contains(text(),'Logout') or contains(text(),'ออกจากระบบ')]
    Sleep    3s
    
    # ตรวจสอบว่าถูกนำกลับไปหน้าแรก
    Wait Until Element Is Visible    xpath=//button[contains(@class,'nav-btn-login')]    5s
    Element Should Be Visible    xpath=//button[contains(@class,'nav-btn-login')]
    
    # Capture screenshot หลัง logout
    Capture Page Screenshot    after_logout_${timestamp}.png
    
    Close Browser