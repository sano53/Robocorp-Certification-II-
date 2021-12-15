*** Settings ***
Documentation   This is Robocorp Certification process automated by Sanobar Khan. In this process bot will
...             simply order multiple bots from robotsarebin industries, then bot will save all
...             the HTML reciepts in a pdf formate, Bot will then take screenshoot of each robot
...             and attach to pdf file. At the end bot will zip all the files in single file
Variables       Config.py    # Here we will get username name and password from python script
Resource        Variables.robot
Library         RPA.Browser
Library         RPA.PDF
Library         RPA.Tables
Library         RPA.Archive
Library         RPA.HTTP
Library         RPA.Robocloud.Secrets
Library         RPA.FileSystem
Library         RPA.Dialogs
Library           RPA.JSON
*** Keywords ***
Get Credential From End User
    Add heading    Get User Credentials
    Add text input    username    label=Username
    Add text input    password  label=Password
    ${dialog}=    Run dialog
    &{Credential}=    Create dictionary      username=${dialog.username}  password=${dialog.password}
    Save JSON to file    ${Credential}    valut.json
Emtpty Directory
    # Bot has to empty the directory if exist
    Remove File  ${Order_Csv_Path}
    ${chk}=  Does Directory Exist  ${PDF_Path}
    Run keyword if  '${chk}'=='True'  Remove Directory  ${PDF_Path}  recursive=True
    ${chk}=  Does Directory Exist  ${Images_Path}
    Run keyword if  '${chk}'=='True'  Remove Directory  ${Images_Path}  recursive=True
Check PDF And Image Directory Existance
    # Bot will check if PDF_Path directory and Images_Path directory exist, If exist then skip else then create the Directories
    ${chk}=  Does Directory Exist  ${PDF_Path}
    Run keyword if  '${chk}'=='False'  Create Directory  ${PDF_Path}
    ${chk}=  Does Directory Exist  ${Images_Path}
    Run keyword if  '${chk}'=='False'  Create Directory  ${Images_Path}
Download and Get Data From CSV
    # read the csv file and return the table.
    Download  ${Csv_Url}  ${Order_Csv}
    sleep  2s
    ${Data}  Read Table from Csv  ${Order_Csv}  header=True
    Return From Keyword  ${Data}
Server Error Handling
    # In This piece of code Bot will handle the error which may occure during the process
    FOR  ${i}  IN RANGE  15
            ${status}=  Is Element Visible  //div[@class="alert alert-danger"]        # If this element visible yhen it means bot have face the error, bot will try to recover the error by trying it for 15 times if still error appears then bot will terminate the process
            Run Keyword If  '${status}'=='True'  Click Button  //button[@id="order"]
            Exit For Loop If  '${status}'=='False'
    END
    Run Keyword If  '${status}'=='True'  Close Browser      #If error still exist after multiple itration
Bot Creation and Generation Of Receipts
    [Arguments]  ${Data}
    Open Available Browser  ${Portal_link}
    Maximize Browser Window
    FOR  ${current_record}  IN  @{Data}
        Wait Until Page Contains Element  //button[@class="btn btn-dark"]
        Click Button  //button[@class="btn btn-dark"]
        Sleep  0.5s
        Select From List By Value  //select[@name="head"]  ${current_record}[Head]
        Click Element  //input[@value="${current_record}[Body]"]
        Sleep  0.5s
        Input Text  //input[@placeholder="Enter the part number for the legs"]  ${current_record}[Legs]
        Sleep  0.5s
        Input Text  //input[@name="address"]  ${current_record}[Address]
        Sleep  0.5s
        Click Button  //button[@id="preview"]
        Sleep  2s
        Click Button    //*[@id="order"]
        Sleep  0.5s
        Server Error Handling
        ${reciept}  ${PDF}  ${Image}=  Set PDF and Image File Names and Capture Image
        Sleep  2s
        Creating the PDF files  ${PDF}  ${Image}  ${reciept}
        Sleep  3s
        Click Element  //button[@id="order-another"]
    END
    Close browser
    Create Zip File  ${PDF_Path}  ${Zipfile_Path}
Set PDF and Image File Names and Capture Image
    ${id}=  Get Text  //*[@id="receipt"]/p[1]
    Set Local Variable  ${PDF}  ${id}.pdf
    Set Local Variable  ${Image}  ${id}.png
    Capture Element Screenshot      //*[@id="robot-preview-image"]    ${Images_Path}${/}${Image}
    ${reciept}=  Get Element Attribute  //div[@id="receipt"]  outerHTML
    Return From Keyword  ${reciept}  ${PDF}  ${Image}
Create Zip File
    [Arguments]  ${PDF_Path}  ${Zipfile_Path}
    Archive Folder With ZIP     ${PDF_Path}  ${Zipfile_Path}   recursive=True  include=*.pdf
Creating the PDF files
    [Arguments]  ${PDF}  ${Image}  ${reciept}
    Html To Pdf  ${reciept}  ${PDF_Path}${/}${PDF}
    Add Watermark Image To Pdf  ${Images_Path}${/}${Image}  ${PDF_Path}${/}${PDF}  ${PDF_Path}${/}${PDF}
    Close PDF           ${PDF_Path}${/}${PDF}
    Open PDF        ${PDF_Path}${/}${PDF}
    @{files}=       Create List     ${Images_Path}${/}${Image}
    Add Files To PDF    ${files}    ${PDF_Path}${/}${PDF}     ${True}
    Close PDF           ${PDF_Path}${/}${PDF}


