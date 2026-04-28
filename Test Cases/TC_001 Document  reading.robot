*** Settings ***
Resource               ../resources/common.robot
Resource               ../resources/locator.robot
Resource               ../resources/variable.robot
Library                DateTime
Library                String
Library                QForce
Library                FakerLibrary
Library                OperatingSystem
Suite Setup            Setup Browsers
Suite Teardown         End suite

*** Variables ***
${DOWNLOAD_DIR}         ${CURDIR}${/}..${/}Downloads${/}

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

*** Test Cases ***
TC_01 Document Reading
    [Documentation]    Lead Creation on salesforce CPQ application
    [Tags]             Leadcreation    P1

    # Login to Salesforce
    Appstate           Home

    # Launch app Salesforce CPQ
    LaunchApp          Salesforce CPQ
    GoTo               https://cpqlimited-dev-ed.develop.lightning.force.com/lightning/r/SBQQ__Quote__c/a0qbm000008trVJAAY/view

    ClickText          Generate Document
    ClickText          Preview

    # Chrome auto-downloads the PDF — wait for it to complete
    Sleep              15

    # Find the latest downloaded PDF and read its content
    ${pdf_files}=      OperatingSystem.List Files In Directory    ${DOWNLOAD_DIR}    *.pdf
    Log To Console     Found PDF files: ${pdf_files}
    ${pdf_file}=       Set Variable    ${pdf_files}[0]
    Log To Console     Using PDF: ${pdf_file}

    UsePdf             ${DOWNLOAD_DIR}${/}${pdf_file}
    ${text}=           GetPdfText
    Log To Console     PDF Content: ${text}
