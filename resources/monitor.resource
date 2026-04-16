*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    DateTime
Library    OperatingSystem

*** Variables ***
${TIMEOUT}           10
${MAX_RESPONSE_MS}   5000
&{HEADERS}           User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36

*** Keywords ***
Check Endpoint Is Up
    [Arguments]    ${name}    ${url}    ${expected_status}=200
    ${start}=    Get Current Date    result_format=epoch
    ${response}=    GET    ${url}    expected_status=any    timeout=${TIMEOUT}    verify=${True}    headers=${HEADERS}
    ${end}=    Get Current Date    result_format=epoch
    ${duration_ms}=    Evaluate    round((${end} - ${start}) * 1000)
    Log    ${name}: status=${response.status_code} | ${duration_ms}ms    console=True
    Run Keyword If    ${response.status_code} != ${expected_status}
    ...    Fail    ${name} est DOWN ! Status: ${response.status_code} (attendu: ${expected_status})
    Should Be True    ${duration_ms} < ${MAX_RESPONSE_MS}
    ...    ${name} est trop lent : ${duration_ms}ms (max: ${MAX_RESPONSE_MS}ms)
    RETURN    ${response.status_code}    ${duration_ms}

Check Endpoint Responds
    [Documentation]    Vérifie qu'un serveur répond (peu importe le status code).
    ...                Utile pour les sites qui bloquent les bots (403) mais sont bien UP.
    [Arguments]    ${name}    ${url}
    ${start}=    Get Current Date    result_format=epoch
    ${response}=    GET    ${url}    expected_status=any    timeout=${TIMEOUT}    verify=${True}    headers=${HEADERS}
    ${end}=    Get Current Date    result_format=epoch
    ${duration_ms}=    Evaluate    round((${end} - ${start}) * 1000)
    # 5xx = serveur en erreur = DOWN. Tout le reste (200, 301, 403...) = le serveur tourne.
    Should Be True    ${response.status_code} < 500
    ...    ${name} est DOWN ! Status: ${response.status_code}
    Should Be True    ${duration_ms} < ${MAX_RESPONSE_MS}
    ...    ${name} est trop lent : ${duration_ms}ms (max: ${MAX_RESPONSE_MS}ms)
    Log    ${name}: UP (status=${response.status_code}) | ${duration_ms}ms    console=True
    RETURN    ${response.status_code}    ${duration_ms}

Check Status Page
    [Arguments]    ${name}    ${status_url}
    ${response}=    GET    ${status_url}    expected_status=any    timeout=${TIMEOUT}
    Log    ${name} Status Page: ${response.status_code}    console=True
    Should Be True    ${response.status_code} == 200
    ...    Impossible d'accéder à la page de status de ${name}
    RETURN    ${response}

Check Status Page For Incidents
    [Arguments]    ${name}    ${status_api_url}
    ${response}=    GET    ${status_api_url}    expected_status=any    timeout=${TIMEOUT}
    IF    ${response.status_code} != 200
        Log    ${name}: impossible de récupérer le status (HTTP ${response.status_code})    console=True    level=WARN
        RETURN    UNKNOWN
    END
    ${json}=    Set Variable    ${response.json()}
    ${status_text}=    Set Variable    ${json}[status][description]
    Log    ${name}: ${status_text}    console=True
    RETURN    ${status_text}
