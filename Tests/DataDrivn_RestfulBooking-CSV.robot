*** Settings ***
Resource    ../Resources/Keywords/RestfulBookingKeywords.robot
Library     DataDriver  ../Resources/TestData/BookingDataCsv.csv

Test Template   Create Booking using Data Driven

*** Test Cases ***
Create Booking With CSV using firstname: ${firstname} ,lastname: ${lastname} , totalprice: ${totalprice} , depositpaid: ${depositpaid} , checkin: ${checkin} , checkout: ${checkout} and additionalneeds: ${additionalneeds}

*** Keywords ***
Create Booking using Data Driven
    [Arguments]     ${firstname}     ${lastname}    ${totalprice}   ${depositpaid}  ${checkin}  ${checkout}  ${additionalneeds}
    ${booking_dates}=    create dictionary
        ...      checkin=${checkin}    checkout=${checkout}

    ${body}=        Create Dictionary      firstname=${firstname}
     ...    lastname=${lastname}      totalprice=${totalprice}        depositpaid=${depositpaid}
     ...    bookingdates=${booking_dates}    additionalneeds=${additionalneeds}


    Create Session     POST    ${restfulBooker_baseUrl}     disable_warnings=1
    ${post_response}        POST On Session     POST    ${Booking_ENDPOINT}     json=${body}
    Status Should Be    200
    Log To Console    ${post_response.content}
    ${res_body}=        convert to string       ${post_response.content}
    should contain    ${res_body}      id
    Log To Console    ${res_body}      id
