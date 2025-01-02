*** Settings ***
Library      RequestsLibrary
Library      Collections
Library      JSONLibrary
Resource    ../Config/RestfulBookerEnvironmental.robot
Variables    ../Variables/jsonbookingdata.py

*** Keywords ***
Get token
    ${body}     Create Dictionary       username=admin      password=password123
    ${auth_response}    POST        ${restfulBooker_baseUrl}/auth    json=${body}
    ...     expected_status=200
    ${bookingAuthToken}=    Set Variable    ${auth_response.json()}[token]
    Log    token is set: ${bookingAuthToken}
    [RETURN]    ${bookingAuthToken}

Get all Bookings
    create session      getBookingSession   ${restfulBooker_baseUrl}    verify=true
    # Get Request
    ${response}=     GET On Session    getBookingSession   ${Booking_ENDPOINT}
     #Validation
    ${status_code}=     convert to string       ${response.status_code}
    should be equal     ${status_code}      200
    ${res_body}=        convert to string       ${response.content}
    should contain    ${res_body}      bookingid

Get Booking Data By Specific ID
    [Arguments]     ${id}
    create session      getBookingByIdSession   ${restfulBooker_baseUrl}    verify=true
    ${header}=          create dictionary      Accept=application/json
    # Get Request
    ${get_response}     GET On Session     getBookingByIdSession  ${Booking_ENDPOINT}/${id}  headers=${header}  expected_status=200
    #[RETURN]    ${get_response}
    Log    Successful getting data by posted booking id is: ${id}

Create Booking
    ${booking_dates}=    create dictionary
        ...      checkin=2024-03-14     checkout=2024-05-01

    ${body}=        Create Dictionary      firstname=Omar
     ...    lastname=Salam      totalprice=3434        depositpaid=false
     ...    bookingdates=${booking_dates}    additionalneeds=Dinner

     Create Session     POST    ${restfulBooker_baseUrl}     disable_warnings=1
     ${post_response}        POST On Session     POST    ${Booking_ENDPOINT}     json=${body}

     Status Should Be    200
     ${booking_Id}      Set Variable    ${post_response.json()}[bookingid]
     Log    Posted BookingID value is: ${booking_Id}
     [RETURN]    ${booking_Id}

Delete Booking
    [Arguments]     ${id}
    ${token}=    Get token
    create session      deleteBookingSession         ${restfulBooker_baseUrl}    verify=true
    ${header}=       create dictionary   Content-Type=application/json     Cookie=token=${token}
    ${response}=     delete on session     deleteBookingSession        ${Booking_ENDPOINT}/${id}      headers=${header}
    Log    Booking is deleted successfully for this booking_Id: ${id}


Create Booking Using Json Data
    Create Session    booker    url=${restfulBooker_baseUrl}   headers=${headers}   disable_warnings=True
    # Create Booking
    ${post_response}    POST On Session    booker    /booking    json=${booking}
    Status Should Be    200

    # Log response and retrieve booking via GET
    ${response}    GET On Session    booker    /booking/${post_response.json()}[bookingid]
    # Assertions with Validation
    Should Be Equal    ${response.json()}[lastname]    ${booking}[lastname]
    Should Be Equal    ${response.json()}[firstname]    ${booking}[firstname]
    Should Be Equal As Numbers    ${response.json()}[totalprice]    ${booking}[totalprice]
    Should Be Equal As Strings    ${response.json()}[depositpaid]    ${booking}[depositpaid]
    Should Be Equal    ${response.json()}[bookingdates][checkin]    ${booking}[bookingdates][checkin]
    Should Be Equal    ${response.json()}[bookingdates][checkout]    ${booking}[bookingdates][checkout]
    Should Be Equal    ${response.json()}[additionalneeds]    ${booking}[additionalneeds]
    ${booking_Id}      Set Variable    ${post_response.json()}[bookingid]
    [RETURN]    ${booking_Id}
    Log    Successful getting posted data that\'s booking id is: ${booking_Id}



Update Booking Data using Data Driven-CSV
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

Create Booking using Data Driven-Excel

    [Arguments]     ${firstname}     ${lastname}    ${totalprice}   ${depositpaid}  ${checkin}  ${checkout}  ${additionalneeds}
    ${booking_dates}=    create dictionary
        ...      checkin=${checkin}    checkout=${checkout}

    ${body}=        Create Dictionary      firstname=${firstname}
     ...    lastname=${lastname}      totalprice=${totalprice}        depositpaid=${depositpaid}
     ...    bookingdates=${booking_dates}    additionalneeds=${additionalneeds}


    Create Session     POST    ${restfulBooker_baseUrl}     disable_warnings=1
    ${post_response}        POST On Session     POST    ${Booking_ENDPOINT}     json=${body}
    Status Should Be    200

Create Booking Data using Data Driven-CSV
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

Update-Put Booking Data
    [Arguments]     ${booking_Id}   ${checkin}  ${checkout}  ${firstname}  ${lastname}  ${totalprice}  ${depositpaid}  ${additionalneeds}
    ${token}=    Get token
    ${header}=  create dictionary   Content-Type=application/json   Accept=application/json  Cookie=token=${token}
    ${booking_dates}=    create dictionary
        ...      checkin=${checkin}   checkout=${checkout}
    ${body}=        Create Dictionary      firstname=${firstname}
     ...    lastname=${lastname}   totalprice=${totalprice}      depositpaid=${depositpaid}
     ...    bookingdates=${booking_dates}    additionalneeds=${additionalneeds}
     Create Session    UpdateBookingData    ${restfulBooker_baseUrl}     headers=${header}   disable_warnings=True
     ${put_response}=    PUT On Session  UpdateBookingData   ${Booking_ENDPOINT}/${booking_Id}     json=${body}     #expected_status=200
     Status Should Be    200
     Log    Booking Data are updated successfully for needed booking id: ${booking_Id}

