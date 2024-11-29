*** Settings ***
Library    Browser
Library    FakerLibrary
Library    Screenshot

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
${NOME}                 Super Man
${SENHA}                crypto
${LOGO_SERVEREST}       //img[@height='65']
${BTN_ENTRAR}           //button[contains(.,'Entrar')]
${BTN_LOGOUT}           //button[@data-testid='logout'][contains(.,'Logout')]
${TITLE_LISTAR}        //h5[contains(.,'Listar Usuários')]
${TITLE_PRODUTOS}        //h5[contains(.,'Cadastrar Produtos')]
${BTN_LISTAR}           //a[@data-testid='listarUsuarios'][contains(.,'Listar')]
${NOME_CADASTRADO}        (//td[contains(.,'Super Man')])[1]
${SENHA_CADASTRADA}       (//td[contains(.,'crypto')])[1]
${CADASTRAR_PRODUTOS}     //a[contains(@data-testid,'cadastrarProdutos')]
${BTN_PRODUTOS}            //a[@data-testid='cadastrarProdutos'][contains(.,'Cadastrar')]
${CAMPO_NOME_PRODUTO}      id=nome
${NOME_PRODUTO}            Liquidifcador
${PRECO}                   id=price
${DESCRICAO}               id=description
${QUANTIDADE}              id=quantity
${BTN_UPLOAD}              id=imagem

*** Keywords ***
#CT01 - Validar lista de cadastro com sucesso
que estou na tela principal
    New Browser    browser=${BROWSER}
    ...            headless=${HEADLESS}
    New Context    viewport={'width': 1280, 'height': 720}
    New Page       url=${URL_SERVEREST}
    ${title}       Get Title  ==  Front - ServeRest
    Log    ${title}

preencho todas os dados solicitados
    Click          ${BTN_CADASTRAR}
    Type Text      ${NOME_FIELD}    ${NOME}
    ${EMAIL}       FakerLibrary.Email
    Type Text      ${EMAIL_FIELD}   ${EMAIL}
    Type Text      ${SENHA_FIELD}   ${SENHA}
    Click          ${BTN_ADMINISTRADOR}
    Check Checkbox    ${BTN_ADMINISTRADOR}  

o cadastro deverá ser realizado com sucesso
    Click        ${CADASTRAR} 
    Take Screenshot
    Sleep    2s

ao selecionar Listar Usuários deverá aparecer o usuário cadastrado
    Get Text  ${TITLE_LISTAR}  ==  Listar Usuários
    Get Element States    ${BTN_LISTAR}  validate    value & visible
    Click       ${BTN_LISTAR}
    Get Text    ${NOME_CADASTRADO}   ==   Super Man
    Get Text    ${SENHA_CADASTRADA}  ==   crypto
    Scroll To Element    ${NOME_CADASTRADO}
    Sleep    2s
    Take Screenshot


#CT02 - Validar cadastro de produtos no serveRest
preencher os dados para cadastro do produto
    Sleep    5s
    Get Text    ${TITLE_PRODUTOS}    ==  Cadastrar Produtos
    Get Element States    ${BTN_PRODUTOS}    validate    value & visible
    Click       ${BTN_PRODUTOS}
    Get Text    h1    ==    Cadastro de Produtos
    Type Text    ${CAMPO_NOME_PRODUTO}    ${NOME_PRODUTO}
    Type Text    ${PRECO}        2500
    ${INFO_PRODUTO}       FakerLibrary.Texts
    Type Text    ${DESCRICAO}    ${INFO_PRODUTO}
    Type Text    ${QUANTIDADE}   5
    Scroll To Element     ${BTN_UPLOAD}   
    Upload File By Selector    ${BTN_UPLOAD}    liquidificador.jpg  
    Click        ${CADASTRAR} 

o produto deverá ser cadastrado com sucesso
    Click       xpath = //a[@data-testid='listar-produtos'][contains(.,'Listar Produtos')]
    ${produto}  Get Table Cell Element    css=table    "Nome"    "${NOME_PRODUTO}"
    ${nome}      Get Text     ${produto}  ==  Liquidifcador
    Log   ${nome}
    Scroll By    ${produto}
    Highlight Elements    ${NOME_PRODUTO}
    Take Screenshot