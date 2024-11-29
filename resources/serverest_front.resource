*** Settings ***
Library    Browser
...        enable_presenter_mode=${true}
Library    FakerLibrary
Library    Screenshot
Library    DateTime

#Variaveis globais
*** Variables ***
${BROWSER}              chromium
${HEADLESS}             ${false}
${URL_SERVEREST}        https://front.serverest.dev/login 
${BTN_CADASTRAR}        //a[contains(.,'Cadastre-se')]
${NOME_FIELD}           id=nome
${EMAIL_FIELD}          id=email 
${SENHA_FIELD}          id=password
${BTN_ADMINISTRADOR}    id=administrador
${CADASTRAR}            //button[contains(.,'Cadastrar')]
${EMAIL_CADASTRADO}     jasonsanchez@example.org
${SENHA_CADASTRADA}     a#8Wes*cOS
${LOGO_SERVEREST}       //img[@height='65']
${BTN_ENTRAR}           //button[contains(.,'Entrar')]
${BTN_LOGOUT}           //button[@data-testid='logout'][contains(.,'Logout')]

*** Keywords ***
que estou na tela principal
    New Browser    browser=${BROWSER}
    ...            headless=${HEADLESS}
    
    ${TRACE_NAME}    FakerLibrary.Uuid 4
    ${NOW}           Get Current Date    result_format=%d-%m-%Y_%H%M%S
    New Context    viewport={'width': 1280, 'height': 720}
    ...            tracing=${OUTPUT_DIR}/evidencies/traces/${NOW}/${TRACE_NAME}.zip
    ...            recordVideo={'dir' : '${OUTPUT_DIR}/evidencies/videos/${NOW}'}
    New Page       url=${URL_SERVEREST}
    ${title}       Get Title  ==  Front - ServeRest
    Log    ${title}

preencho todas os dados solicitados
    Click          ${BTN_CADASTRAR}
    ${NOME}      FakerLibrary.First Name Female
    Type Text    ${NOME_FIELD}    ${NOME}
    ${EMAIL}     FakerLibrary.Email
    Type Text    ${EMAIL_FIELD}   ${EMAIL}
    ${SENHA}     FakerLibrary.Password
    Type Text    ${SENHA_FIELD}   ${SENHA}
    Click        ${BTN_ADMINISTRADOR}
    Check Checkbox    ${BTN_ADMINISTRADOR}  

o cadastro deverá ser realizado com sucesso
    Click        ${CADASTRAR} 
    #Take Screenshot
    Sleep    2s

insiro e-mail e senha cdastrados
    Type Text    ${EMAIL_FIELD}         ${EMAIL_CADASTRADO}
    Type Text    ${SENHA_FIELD}         ${SENHA_CADASTRADA}
    Click        ${BTN_ENTRAR}

o login deverá ser realizado com sucesso
    Wait For Elements State             ${LOGO_SERVEREST}     visible  
    Get Text  h1  ==   Bem Vindo Stephanie   
    Get Element States                   ${BTN_LOGOUT}        validate    value & visible

realizo um cadastro via requisição http
    ${NOVO_EMAIL}    FakerLibrary.Email
    Set Test Variable    ${NOVO_EMAIL}

    ${response}    Http    url=https://serverest.dev/usuarios
    ...                    method=POST
    ...                    body={"nome": "Bob Esponja","email": "${NOVO_EMAIL}","password": "abacaxi","administrador": "true"}
    Should Be Equal As Integers    ${response["status"]}    201

o login deverá ser concluido
    ${response}     Http    url=https://serverest.dev/login
    ...                   method=POST
    ...                   body={"email": "${NOVO_EMAIL}","password": "abacaxi"}
    
    Should Be Equal As Integers    ${response["status"]}    200

    LocalStorage Set Item    serverest/userEmail    ${NOVO_EMAIL}
    LocalStorage Set Item    serverest/userToken    ${response["body"]["authorization"]}
    LocalStorage Set Item    serverest/userNome     Bob Esponja
    
    Go To    url=https://front.serverest.dev/admin/home
    Take Screenshot

cadastrar usuário e logar
    New Browser
    New Page    url=${URL_SERVEREST}
    realizo um cadastro via requisição http
    o login deverá ser concluido
    ${STORAGE_FILE}    Save Storage State
    Set Suite Variable    ${STORAGE_FILE}

abrir o site já logado
    New Browser    browser=${BROWSER}
    ...            headless=${HEADLESS}
    New Context    viewport={'width': 1280, 'height': 720}
    ...            storageState=${STORAGE_FILE}
    New Page       url=https://front.serverest.dev/admin/home
    Take Screenshot     