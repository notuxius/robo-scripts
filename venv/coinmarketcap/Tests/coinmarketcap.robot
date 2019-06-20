*** Settings ***
#Documentation  This is basic info about suite
#Library  SeleniumLibrary
Library  RequestsLibrary
Library  Collections


*** Variables ***


*** Test Cases ***
Show Currencies Lists

    # Execute keyword 8 times
    :FOR  ${running_time}  IN RANGE  8
    \  Run Keyword And Return Status  List Top 10 Currencies In Past 24 Hours By Volume


*** Keywords ***
List Top 10 Currencies In Past 24 Hours By Volume

    # Check timeout
    [Timeout]  500 milliseconds

    ${headers} =  Create Dictionary
    Set To Dictionary  ${headers}  X-CMC_PRO_API_KEY  942855f9-6ddf-4e60-a659-e6d072eddf5d
    Set To Dictionary  ${headers}  Content-Type  application/json

    # Create session
    Create Session  coinmarketcap_session  https://pro-api.coinmarketcap.com  headers=${headers}

    # Make call
    ${response} =  Get Request  coinmarketcap_session  v1/cryptocurrency/listings/latest?start=1&limit=10&sort=volume_24h&convert=USD

    # Check response status
    Should Be Equal As Strings  ${response.status_code}  200

    # Check if response size is less than 10 KB
    ${length} =  Get Length  ${response.content}
    Should Be True  ${length} < 10000

    # Show response body
    ${json} =  Set Variable  ${response.json()}

    :FOR  ${number_of_currency}  IN RANGE  10
    \  Log  ${json['data'][${number_of_currency}]['name']}