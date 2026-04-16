*** Settings ***
Documentation    Moniteur de disponibilité AWS & Cloudflare
Resource         ../../resources/monitor.resource
Library          RequestsLibrary
Library          Collections

*** Variables ***
# -- Status pages --
${CLOUDFLARE_STATUS_API}    https://yh6f0r4529hb.statuspage.io/api/v2/status.json
${AWS_STATUS_API}           https://health.aws.amazon.com/health/status

# -- Endpoints directs --
${AWS_URL}              https://aws.amazon.com
${CLOUDFLARE_URL}       https://www.cloudflare.com

*** Test Cases ***
# ===== DISPONIBILITÉ =====

AWS Est Accessible
    [Tags]    cloud    aws    ping
    Check Endpoint Is Up    AWS    ${AWS_URL}

Cloudflare Est Accessible
    [Tags]    cloud    cloudflare    ping
    Check Endpoint Is Up    Cloudflare    ${CLOUDFLARE_URL}

# ===== INCIDENTS =====

Cloudflare N'a Pas D'incident
    [Tags]    cloud    cloudflare    status
    ${status}=    Check Status Page For Incidents    Cloudflare    ${CLOUDFLARE_STATUS_API}
    Should Be Equal As Strings    ${status}    All Systems Operational
    ...    INCIDENT CLOUDFLARE : ${status}
