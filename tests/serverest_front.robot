*** Settings ***
Resource    ../resources/serverest_front.resource
Suite Teardown    Close Browser    ALL

*** Test Cases ***
CT01 - Realizar cadastro com sucesso
    [Documentation]    Teste para realização de cadastro na Severest
    [Tags]             Cadastro
    Given que estou na tela principal
    When preencho todas os dados solicitados
    Then o cadastro deverá ser realizado com sucesso

CT02 - Realizar login com sucesso
    [Documentation]    Teste para realização de login com sucesso
    [Tags]             login
    Given que estou na tela principal
    When insiro e-mail e senha cdastrados
    Then o login deverá ser realizado com sucesso

CT03 - Realizar teste via requisição http
    [Documentation]    Teste para realização de requisição http
    [Tags]             login
    Given que estou na tela principal
    When realizo um cadastro via requisição http
    Then o login deverá ser concluido

CT04 - Realizar cadastro e login via api
    [Documentation]    Teste para realização login via requisição
    [Tags]             login por requisição
    Given cadastrar usuário e logar
    Then abrir o site já logado