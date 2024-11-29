*** Settings ***
Resource    ../resources/desafio_cadastro.resource

*** Test Cases ***
CT01 - Validar lista de cadastro com sucesso
    [Documentation]    Teste para validação de lista de cadastro
    [Tags]             Cadastro Usuários
    Given que estou na tela principal
    When preencho todas os dados solicitados
    Then o cadastro deverá ser realizado com sucesso
    Then ao selecionar Listar Usuários deverá aparecer o usuário cadastrado

CT02 - Validar cadastro de produtos no serveRest
    [Documentation]    Teste para validação de cadastro de produto
    [Tags]             Cadastro Produtos
    Given que estou na tela principal
    When preencho todas os dados solicitados
    Then o cadastro deverá ser realizado com sucesso
    And preencher os dados para cadastro do produto
    Then o produto deverá ser cadastrado com sucesso