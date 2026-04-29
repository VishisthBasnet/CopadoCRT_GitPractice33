*** Settings ***
Resource               ../resources/common.robot
Resource               ../resources/locator.robot
Resource               ../resources/variable.robot
Library                DateTime
Library                String
Library                QForce
Library                QVision
Library                FakerLibrary
Suite Setup            Setup Browsers
Suite Teardown         End suite

*** Keywords ***
Setup Browsers
    ${prefs}=    Create Dictionary
    ...    download.prompt_for_download=${False}
    ...    download.directory_upgrade=${True}
    ...    plugins.always_open_pdf_externally=${True}
    ...    safebrowsing.enabled=${False}
    Open Browser    about:blank    chrome
    ...    options=add_argument("--start-maximized");add_experimental_option("prefs", ${prefs})
    SetConfig    LineBreak       ${EMPTY}
    SetConfig    DefaultTimeout  45s
    SetConfig    Delay           0.3
    Set Library Search Order                          QForce    QWeb

Download PDF via JavaScript
    # Extract the PDF URL from the embedded viewer's src attribute
    ${pdf_url}=    GetAttribute    //iframe[contains(@src,'.pdf')]    src
    # Navigate to the URL directly to trigger download
    ExpectFileDownload
    GoTo    ${pdf_url}
    VerifyFileDownload    timeout=30s

*** Test Cases ***

TC_01 Document Reading 
    [Documentation]    Lead Creation on salesforce CPQ application
    [Tags]             Leadcreation                P1

    #Login to salesforce
    Appstate           Home

    #launch app  Salesforce CPQ
    LaunchApp          Salesforce CPQ
    GoTo               https://cpqlimited-dev-ed.develop.lightning.force.com/lightning/r/SBQQ__Quote__c/a0qbm000008trVJAAY/view

    ClickText          Generate Document
    ClickText          Preview

    Download PDF via JavaScript
    
    SetConfig    ShadowDOM    True
    QVision.ClickText          Download 
    Qvision.ClickText    Download    recognition_mode=vision
    # ClickElement              xpath=//cr-icon-button[contains(@title,'Download')]
    # ClickItem    Download     tag=cr-icon-button    
