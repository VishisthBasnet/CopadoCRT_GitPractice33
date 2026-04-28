*** Settings ***
Resource                        ../resources/common.robot
Resource                        ../resources/locator.robot
Resource                        ../resources/variable.robot
Library                         DateTime
Library                         String
Library                         QForce
Library                         FakerLibrary
Library                         OperatingSystem
Suite Setup                     Setup Browsers
Suite Teardown                  End suite

*** Variables ***
${DOWNLOAD_DIR}                 %{HOME}${/}Downloads

*** Keywords ***
Setup Browsers
    ${prefs}=                   Create Dictionary
    ...                         download.prompt_for_download=${False}
    ...                         download.directory_upgrade=${True}
    ...                         plugins.always_open_pdf_externally=${True}
    ...                         safebrowsing.enabled=${False}
    Open Browser                about:blank                 chrome
    ...                         options=add_argument("--start-maximized");add_experimental_option("prefs", ${prefs})
    SetConfig                   LineBreak                   ${EMPTY}
    SetConfig                   DefaultTimeout              45s
    SetConfig                   Delay                       0.3

Click Download Via Shadow DOM
    [Documentation]             Pierces ALL nested shadow roots recursively to find and click the Download button.
    ...                         Used when ClickText, ClickItem and vision all fail due to deep shadow DOM nesting.
    ExecuteJavascript
    ...                         const pierce = (root) => {
    ...                         const selectors = [
    ...                         'cr-icon-button[title="Download"]',
    ...                         'cr-icon-button[aria-label="Download"]',
    ...                         'button[title="Download"]',
    ...                         '[title="Download"]',
    ...                         '[aria-label="Download"]'
    ...                         ];
    ...                         for (const sel of selectors) {
    ...                         const el = root.querySelector(sel);
    ...                         if (el) { el.click(); return true; }
    ...                         }
    ...                         for (const host of root.querySelectorAll('*')) {
    ...                         if (host.shadowRoot) {
    ...                         if (pierce(host.shadowRoot)) return true;
    ...                         }
    ...                         }
    ...                         return false;
    ...                         };
    ...                         pierce(document);
    

*** Test Cases ***
TC_01 Document Reading
    [Documentation]             Download and read a CPQ generated document
    [Tags]                      Leadcreation                P1

    # Login to Salesforce
    Appstate                    Home

    # Launch app Salesforce CPQ
    LaunchApp                   Salesforce CPQ
    GoTo                        https://cpqlimited-dev-ed.develop.lightning.force.com/lightning/r/SBQQ__Quote__c/a0qbm000008trVJAAY/view

    ClickText                   Generate Document
    ClickText                   Preview

    # Wait for the preview/PDF viewer to fully load
    Sleep                       5

    # Attempt 1: Chrome auto-download (works if plugins.always_open_pdf_externally kicks in)
    ${downloaded}=              Run Keyword And Return Status
    ...                         Sleep                       10

    # Attempt 2: Pierce ALL shadow roots with JavaScript and click Download button
    Click Download Via Shadow DOM
    Sleep                       10

    # Find the latest downloaded PDF in Downloads folder
    ${pdf_files}=               OperatingSystem.List Files In Directory                 ${DOWNLOAD_DIR}           *.pdf    absolute=True
    Log To Console              Found PDF files: ${pdf_files}

    # Pick the most recently modified PDF
    ${latest_pdf}=              Evaluate                    max(${pdf_files}, key=lambda f: __import__('os').path.getmtime(f))
    Log To Console              Using PDF: ${latest_pdf}

    # Read PDF content
    UsePdf                      ${latest_pdf}
    ${text}=                    GetPdfText
    Log To Console              PDF Content: ${text}
