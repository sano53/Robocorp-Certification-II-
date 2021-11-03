#Start of development
*** Settings ***
Documentation   This is Robocorp Certification process automated by Sanobar Khan. In this process bot will
...             simply order multiple bots from robotsarebin industries, then bot will save all
...             the HTML reciepts in a pdf formate, Bot will then take screenshoot of each robot
...             and attach to pdf file. At the end bot will zip all the files in single file
Resource        Functions.robot
*** Tasks ***
Main task
    Emtpty Directory
    Check PDF And Image Directory Existance
    ${Data}  Download and Get Data From CSV
    Bot Creation and Generation Of Receipts  ${Data}
