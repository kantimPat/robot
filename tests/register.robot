*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime

*** Variables ***
${BASE_URL}        https://robot-lab-five.vercel.app/
${BROWSER}         chrome
${VALID_PASSWORD}  myPassword123
${FIRST_NAME}      Boss
${LAST_NAME}       Tester

*** Keywords ***
Generate New Email
    ${rand}=    Generate Random String    6    [LOWER]
    ${NEW_EMAIL}=    Set Variable    testuser_${rand}@gmail.com
    [Return]    ${NEW_EMAIL}

*** Test Cases ***
Test Register Successful
    [Documentation]    ทดสอบการสมัครสมาชิกสำเร็จ
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # คลิกปุ่ม Register
    Wait Until Element Is Visible    xpath=//button[contains(@class,'nav-btn-register')]    10s
    Click Element    xpath=//button[contains(@class,'nav-btn-register')]
    Sleep    3s
    
    # กรอกข้อมูลสมัครสมาชิก
    Input Text    id=firstName    ${FIRST_NAME}
    Sleep    1s
    Input Text    id=lastName     ${LAST_NAME}
    Sleep    1s
    
    ${email}=    Generate New Email
    Input Text    id=email     ${email}
    Sleep    1s
    Input Text    id=password   ${VALID_PASSWORD}
    Sleep    1s
    
    # คลิกปุ่ม Submit
    Click Element    xpath=//button[@type='submit']
    Sleep    5s
    
    # ตรวจสอบข้อความสมัครสมาชิกสำเร็จ
    Wait Until Element Is Visible    xpath=//*[contains(text(),'สมัครสมาชิกสำเร็จ')]    10s
    Element Should Be Visible    xpath=//*[contains(text(),'สมัครสมาชิกสำเร็จ')]
    
    # Capture screenshot เมื่อสมัครสมาชิกสำเร็จ
    ${timestamp}    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    register_success_${timestamp}.png
    
    Log    Registration successful with email: ${email}
    
    Close Browser

Test Register With Existing Email
    [Documentation]    ทดสอบการสมัครสมาชิกด้วย email ที่มีอยู่แล้ว
    ${existing_email}    Set Variable    testuser_abc@gmail.com
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # คลิกปุ่ม Register
    Wait Until Element Is Visible    xpath=//button[contains(@class,'nav-btn-register')]    10s
    Click Element    xpath=//button[contains(@class,'nav-btn-register')]
    Sleep    3s
    
    # กรอกข้อมูลสมัครสมาชิก
    Input Text    id=firstName    ${FIRST_NAME}
    Sleep    1s
    Input Text    id=lastName     ${LAST_NAME}
    Sleep    1s
    Input Text    id=email        ${existing_email}
    Sleep    1s
    Input Text    id=password     ${VALID_PASSWORD}
    Sleep    1s
    
    # คลิกปุ่ม Submit
    Click Element    xpath=//button[@type='submit']
    Sleep    5s
    
    # ตรวจสอบข้อความ error (email ที่มีอยู่แล้ว)
    Wait Until Element Is Visible    xpath=//*[contains(text(),'อีเมลนี้ถูกใช้แล้ว') or contains(text(),'Email already exists')]    10s
    Element Should Be Visible    xpath=//*[contains(text(),'อีเมลนี้ถูกใช้แล้ว') or contains(text(),'Email already exists')]
    
    # Capture screenshot
    ${timestamp}    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    register_existing_email_${timestamp}.png
    
    Close Browser

Test Register With Invalid Data
    [Documentation]    ทดสอบการสมัครสมาชิกด้วยข้อมูลไม่ถูกต้อง
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # คลิกปุ่ม Register
    Wait Until Element Is Visible    xpath=//button[contains(@class,'nav-btn-register')]    10s
    Click Element    xpath=//button[contains(@class,'nav-btn-register')]
    Sleep    3s
    
    # กรอกข้อมูลไม่ครบถ้วน (ไม่กรอก email)
    Input Text    id=firstName    ${FIRST_NAME}
    Sleep    1s
    Input Text    id=lastName     ${LAST_NAME}
    Sleep    1s
    Input Text    id=password     ${VALID_PASSWORD}
    Sleep    1s
    
    # คลิกปุ่ม Submit
    Click Element    xpath=//button[@type='submit']
    Sleep    3s
    
    # ตรวจสอบข้อความ error
    ${error_visible}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    xpath=//*[contains(text(),'กรุณากรอกข้อมูลให้ครบถ้วน') or contains(text(),'Please fill in all fields')]    5s
    
    # Capture screenshot
    ${timestamp}    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    register_invalid_data_${timestamp}.png
    
    Should Be True    ${error_visible}    Error message should be displayed for incomplete data
    
    Close Browser

Test Register Form Validation
    [Documentation]    ทดสอบการตรวจสอบฟอร์มสมัครสมาชิก
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # คลิกปุ่ม Register
    Wait Until Element Is Visible    xpath=//button[contains(@class,'nav-btn-register')]    10s
    Click Element    xpath=//button[contains(@class,'nav-btn-register')]
    Sleep    3s
    
    # ตรวจสอบว่าฟอร์มแสดงอย่างถูกต้อง
    Element Should Be Visible    id=firstName
    Element Should Be Visible    id=lastName
    Element Should Be Visible    id=email
    Element Should Be Visible    id=password
    Element Should Be Visible    xpath=//button[@type='submit']
    
    # กรอก email ไม่ถูกต้อง
    Input Text    id=firstName    ${FIRST_NAME}
    Sleep    1s
    Input Text    id=lastName     ${LAST_NAME}
    Sleep    1s
    Input Text    id=email        invalid-email
    Sleep    1s
    Input Text    id=password     ${VALID_PASSWORD}
    Sleep    1s
    
    # คลิกปุ่ม Submit
    Click Element    xpath=//button[@type='submit']
    Sleep    3s
    
    # Capture screenshot
    ${timestamp}    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    register_form_validation_${timestamp}.png
    
    Close Browser