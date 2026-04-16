*** Settings ***
Documentation    Moniteur de disponibilité des services IA
Resource         ../../resources/monitor.resource
Library          RequestsLibrary
Library          Collections

*** Variables ***
# -- Endpoints principaux --
${CLAUDE_URL}           https://claude.ai
${ANTHROPIC_API_URL}    https://api.anthropic.com
${CHATGPT_URL}          https://chatgpt.com
${OPENAI_API_URL}       https://api.openai.com
${GEMINI_URL}           https://gemini.google.com
${MISTRAL_URL}          https://chat.mistral.ai
${PERPLEXITY_URL}       https://www.perplexity.ai
${HUGGINGFACE_URL}      https://huggingface.co

# -- Status pages (API Atlassian Statuspage) --
${OPENAI_STATUS_API}       https://status.openai.com/api/v2/status.json
${CLAUDE_STATUS_URL}       https://status.claude.com
${ANTHROPIC_STATUS_API}    https://status.anthropic.com/api/v2/status.json

*** Test Cases ***
# ===== DISPONIBILITÉ (le serveur répond ?) =====

Claude Est Accessible
    [Tags]    ia    claude    ping
    Check Endpoint Responds    Claude    ${CLAUDE_URL}

API Anthropic Est Accessible
    [Tags]    ia    claude    api    ping
    Check Endpoint Responds    Anthropic API    ${ANTHROPIC_API_URL}

ChatGPT Est Accessible
    [Tags]    ia    chatgpt    ping
    Check Endpoint Responds    ChatGPT    ${CHATGPT_URL}

API OpenAI Est Accessible
    [Tags]    ia    chatgpt    api    ping
    Check Endpoint Responds    OpenAI API    ${OPENAI_API_URL}

Gemini Est Accessible
    [Tags]    ia    gemini    ping
    Check Endpoint Responds    Gemini    ${GEMINI_URL}

Mistral Est Accessible
    [Tags]    ia    mistral    ping
    Check Endpoint Responds    Mistral    ${MISTRAL_URL}

Perplexity Est Accessible
    [Tags]    ia    perplexity    ping
    Check Endpoint Responds    Perplexity    ${PERPLEXITY_URL}

HuggingFace Est Accessible
    [Tags]    ia    huggingface    ping
    Check Endpoint Responds    HuggingFace    ${HUGGINGFACE_URL}

# ===== STATUS PAGES (incidents en cours ?) =====

Claude Status Page Est Accessible
    [Tags]    ia    claude    status
    Check Endpoint Responds    Claude Status    ${CLAUDE_STATUS_URL}

Anthropic (Claude) N'a Pas D'incident
    [Tags]    ia    claude    status
    ${status}=    Check Status Page For Incidents    Anthropic    ${ANTHROPIC_STATUS_API}
    Should Be Equal As Strings    ${status}    All Systems Operational
    ...    INCIDENT ANTHROPIC : ${status}

OpenAI (ChatGPT) N'a Pas D'incident
    [Tags]    ia    chatgpt    status
    ${status}=    Check Status Page For Incidents    OpenAI    ${OPENAI_STATUS_API}
    Should Be Equal As Strings    ${status}    All Systems Operational
    ...    INCIDENT OPENAI : ${status}
