*** Settings ***
Resource               ../resources/common.robot
Resource               ../resources/locator.robot
Resource               ../resources/variable.robot
Library                DateTime
Library                String
Library                QForce
Library                FakerLibrary
Suite Setup            Setup Browser
Suite Teardown         End suite


*** Test Cases ***
TC_01 Lead Creation
    [Documentation]    Lead Creation on salesforce CPQ application
    [Tags]             Leadcreation                P1

    #Login to salesforce
    Appstate           Home
