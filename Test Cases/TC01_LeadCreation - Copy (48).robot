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

    # Generate random test data
    ${first_name}=     FakerLibrary.First Name
    ${last_name}=      FakerLibrary.Last Name
    ${company}=        FakerLibrary.Company
    ${phone}=          FakerLibrary.Phone Number
    ${email}=          FakerLibrary.Email

    #Navigate to salesforce CPQ application
    LaunchApp          Salesforce CPQ

    #Lead Creation
    LaunchApp          Leads
    ClickText          New                         anchor=Intelligence View
    UseModal           on

    #Fill the required fields
  VerifyInputValues    ../resources/input_field_values.txt

    PickList           Salutation                  Mr.
    TypeText           First Name                  CRT test:${first_name}
    TypeText           Last Name                   ${last_name} Record
    PickList           Lead Source                 Web
    TypeText           Phone                       ${phone}
    TypeText           Email                       ${email}
    ClickText          Save                        partial_match=False
    VerifyText         Review the following fields
    TypeText           *Company                    CRT test:${company} Record
    ClickText          Save                        partial_match=False
    UseModal           off

    #Verify tabs on UI
    VerifyAll          Details,Chatter,Activity
    
    #close the browser
    End suite



