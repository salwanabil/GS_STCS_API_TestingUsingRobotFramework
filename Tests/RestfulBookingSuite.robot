*** Settings ***
Resource    ../Resources/Keywords/RestfulBookingKeywords.robot

*** Test Cases ***
TC1 - Booking - Get All Booking IDs
    Get all Bookings

TC2 - Booking - Get Booking Data By Specific Booking ID
    ${booking_Id}=   Create Booking
    Get Booking Data By Specific ID     ${booking_Id}

TC3 - Delete Booking by passing booking ID
    ${booking_Id}=   Create Booking
    Get Booking Data By Specific ID     ${booking_Id}
    Delete Booking   ${booking_Id}

TC4 - Create Booking From Json Data
    ${booking_Id}=   Create Booking Using Json Data
    Log    Verifying that posted data are then fetched by created booking id: ${booking_Id}
    Get Booking Data By Specific ID    ${booking_Id}

TC5 - Update Booking Data
    ${booking_Id}=   Create Booking Using Json Data
    Update-Put Booking Data     ${booking_Id}   "9/12/1010"     "9/13/2010"     "Waheed"    "Ahmed"     9998    "True"  "Super"

