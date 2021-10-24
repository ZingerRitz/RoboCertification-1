*** Settings ***
Documentation  robot that logs into the internet 
#Library        RPA.Browser
Library        RPA.HTTP
Library        RPA.Excel.Files
Library        RPA.Browser.Selenium
Library        RPA.PDF


*** Keywords ***
open the browser 
    Open Available Browser              https://robotsparebinindustries.com/#/

*** Keywords ***
Login
    Input Text    id:username    maria
    Input Password    id:password    thoushallnotpass
    Submit Form
    #Wait Until Element Contains               
    Wait Until Element Is Visible    id:sales-form

*** Keywords ***
filling the internal data
    [Arguments]     ${sales_reps}
    Input Text    id:firstname    ${sales_reps}[First Name]
    Input Text    id:lastname   ${sales_reps}[Last Name]
    Input Text    id:salesresult    ${sales_reps}[Sales]
    #Select All From List    id:salestarget  10000
    ${target_as_string}=    Convert To String    ${sales_reps}[Sales Target]
    Select From List By Value    id:salestarget  ${target_as_string} 
    Submit Form


*** Keywords ***
Downlaoding Excel
    Download    https://robotsparebinindustries.com/SalesData.xlsx  overwrite=True

*** Keywords ***
Reading Excel
     Open Workbook    SalesData.xlsx
     ${sales_reps}=    Read Worksheet As Table    header=True
     Close Workbook
     FOR    ${sales_reps}    IN    @{sales_reps}
         filling the internal data  ${sales_reps}
     END

*** Keywords ***
Collect the Results
    Capture Element Screenshot    css:.alert  ${CURDIR}${/}output${/}sales_summary.png

*** Keywords ***
Creating a PDF
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}=    Get Element Attribute    id:sales-results    outerHTML
    Html To Pdf    ${sales_results_html}    ${CURDIR}${/}output${/}sales_results.pdf


*** Keywords ***
Closing App
    Click Button    id:logout
    Close Browser

*** Tasks ***
open the internt and log in 
    open the browser 
    Login
    Downlaoding Excel
    #filling the internal data
    Reading Excel
    #filling the internal data
    Collect the Results
    Creating a PDF
    [Teardown]  Closing App
