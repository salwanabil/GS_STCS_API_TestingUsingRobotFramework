*** Settings ***
Library      RequestsLibrary
Library    JSONLibrary
Resource    ../Config/eSportsEnvironmental.robot


*** Variables ***
${discover_members_url}  /api/team-club/v1/members/discover-members
${organization_url}      /api/customer/v1/organization-level/org
${penality_url}          /api/penalty/v1/penalty
${accountDetails_url}    /api/uaa/user/account-details
${crm_requests_url}    /api/team-club/v1/requests/status
${penality_filterBy}    testing update Salwa club Owner

*** Keywords ***
Login To Esport
    [Arguments]    ${username}   ${password}
    ${body}     Create Dictionary       username=${username}      password=${password}    grant_type=password     client_id=WEB
    ${headers}      Create Dictionary   Content-Type=application/x-www-form-urlencoded      Connection=keep-alive
    Create Session      loginSessions      ${esport_base_url}      headers=${headers}      disable_warnings=True
    ${response}    POST On Session     loginSessions     ${Login_Service_Url}      data=${body}
    ...     expected_status=200
    ${esport_token}      Set Variable    ${response.json()}[access_token]
    #Log To Console    esport access Token: ${esport_token}
    [Return]    ${esport_token}
