*** Variables ***

${Portal_link}  https://robotsparebinindustries.com/#/robot-order           # The portal in which bot has to perform the task
${Csv_Url}  https://robotsparebinindustries.com/orders.csv                  # the link from which bot has to download the order.csv file
${Output_Path}  Reciepts
${Order_Csv}  orders.csv                                                    #Name of the csv file
${Order_Csv_Path}    ${CURDIR}${/}${Order_Csv}
${Zipfile_Path}       ${CURDIR}${/}PDF_Files.zip
${Images_Path}  ${CURDIR}${/}Images
${PDF_Path}  ${CURDIR}${/}Reciepts
