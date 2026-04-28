*** Settings ***
Resource               ../resources/common.robot
Resource               ../resources/locator.robot
Resource               ../resources/variable.robot
Library                DateTime
Library                String
Library                QForce
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

*** Test Cases ***
TC_01 Document Reading
    [Documentation]    Download and read a CPQ generated document
    [Tags]             Leadcreation    P1

    # Login to Salesforce
    Appstate           Home

    # Launch Salesforce CPQ
    LaunchApp          Salesforce CPQ
    GoTo               https://cpqlimited-dev-ed.develop.lightning.force.com/lightning/r/SBQQ__Quote__c/a0qbm000008trVJAAY/view

    # Start listening for a file download BEFORE triggering the action
    ExpectFileDownload

    ClickText          Generate Document
    ClickText          Preview

    # Wait for Chrome to auto-download (plugins.always_open_pdf_externally=True handles this)
    # VerifyFileDownload returns the full path of the downloaded file automatically
    ${downloaded_file}=    VerifyFileDownload    timeout=60s

    Log To Console     Downloaded file: ${downloaded_file}

    # Read the downloaded PDF content
    UsePdf             ${downloaded_file}
    ${text}=           GetPdfText
    Log To Console     PDF Content: ${text}
