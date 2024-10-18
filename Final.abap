*&---------------------------------------------------------------------*
*& Report ZR_USER0710_FINAL01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR_USER0710_FINAL01.

*&---------------------------------------------------------------------*
*&
*&  Declarações
*&
*&---------------------------------------------------------------------*

TABLES: ZTCLIENTES0710.

DATA: t_clientes TYPE TABLE OF ZTCLIENTES0710,
      w_clientes TYPE ZTCLIENTES0710.

*&---------------------------------------------------------------------*
*&
*&  Declaração de telas
*&
*&---------------------------------------------------------------------*

" Radiobuttons para opções de escolha
SELECTION-SCREEN BEGIN OF BLOCK opcoes WITH FRAME TITLE TEXT-001.
PARAMETERS: r_rd1 RADIOBUTTON GROUP A,             "Cadastrar Cliente
            r_rd2 RADIOBUTTON GROUP A,             "Editar Cliente
            r_rd3 RADIOBUTTON GROUP A DEFAULT 'X'. "Exibir Relatório de Dados

SELECTION-SCREEN end OF BLOCK opcoes.

"Campos de preenchimento para opção de exibição de relatório
SELECTION-SCREEN BEGIN OF BLOCK relatorio WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS: s_client for ZTCLIENTES0710-Cliente,
                s_rg for ZTCLIENTES0710-RG,
                s_cpf for ZTCLIENTES0710-CPF.
SELECTION-SCREEN end OF BLOCK relatorio.

"Campos de preenchimento para opção de cadastrar cliente
SELECTION-SCREEN BEGIN OF BLOCK cadastro WITH FRAME TITLE TEXT-003. "Cadastrar Cliente
PARAMETERS:p_client type ZTCLIENTES0710-Cliente,
           p_rg type ZTCLIENTES0710-RG,
           p_cpf type ZTCLIENTES0710-CPF,
           p_nasci type ZTCLIENTES0710-Data_de_Nascimento,
           p_ender type ZTCLIENTES0710-Endereco,
           p_fone type ZTCLIENTES0710-Telefone.
SELECTION-SCREEN end OF BLOCK cadastro.

"Campos de preenchimento para opção de editar cliente
SELECTION-SCREEN BEGIN OF BLOCK edit WITH FRAME TITLE TEXT-004. "Editar Cliente
PARAMETERS:p_eclien type ZTCLIENTES0710-Cliente,
           p_erg type ZTCLIENTES0710-RG,
           p_ecpf type ZTCLIENTES0710-CPF,
           p_enasci type ZTCLIENTES0710-Data_de_Nascimento,
           p_eender type ZTCLIENTES0710-Endereco,
           p_efone type ZTCLIENTES0710-Telefone.
SELECTION-SCREEN end OF BLOCK edit.


*&---------------------------------------------------------------------*
*&
*&  Execução
*&
*&---------------------------------------------------------------------*


START-OF-SELECTION.

"Quando a opção Exibir Relatório for marcada:
IF r_rd3 = 'X'.
  SELECT *                                                      "seleciona todos os campos
    FROM ZTCLIENTES0710                                         "na tabela do banco de dados
    INTO TABLE t_clientes                                       "movendo para a tabela interna
    WHERE Cliente IN s_client and RG in s_rg and CPF in s_cpf . "com as seguintes condições

    IF t_clientes is NOT INITIAL. "se a tabela t_clientes estiver preenchida

        Write: /5(15)  'CLIENTE',
                30(10) 'RG',
                50(10) 'CPF',
                70(10) 'DATA DE NASCIMENTO',
                90(10) 'TELEFONE',
                110(20)'ENDERECO'.

      LOOP AT t_clientes into w_clientes. "Ler todos os registros da tabela interna movendo para a linha

        Write: /5(15)   w_clientes-Cliente, " /+ espaço para começar uma nova linha os numeros fora do() indicam o numero da coluna em q o texto vai começar a ser escrito
                30(10)  w_clientes-RG,     "os números dentro do() indicam quantas casas vai possuir o texto
                50(10)  w_clientes-CPF,
                70(10)  w_clientes-data_de_nascimento,
                90(10)  w_clientes-telefone,
                110(20) w_clientes-endereco.


      ENDLOOP.

    ENDIF.



"Quando a opção Cadastrar Cliente for marcada:
ELSEIF r_rd1 = 'X'.
  IF p_client IS INITIAL. "Initial = vazio
    MESSAGE 'Cliente Precisa Ser Informado' TYPE 'E'.

  ELSEIF p_rg IS INITIAL.
    MESSAGE 'RG Precisa Ser Informado' TYPE 'E'.

  ELSEIF p_cpf IS INITIAL.
    MESSAGE 'CPF Precisa Ser Informado' TYPE 'E'.

  ELSE.

    w_clientes-cliente = p_client.
    w_clientes-rg = p_rg.
    w_clientes-cpf = p_cpf.
    w_clientes-data_de_nascimento = p_nasci.
    w_clientes-endereco = p_ender.
    w_clientes-telefone = p_fone.

    insert ZTCLIENTES0710 from w_clientes. "Para inserir um registro no banco de dados

    IF sy-subrc = 0. "Só efetiva a gravação se conseguir inserir
      COMMIT WORK.   "Efetiva a gravação do registro no banco de dados
      MESSAGE 'Cliente Cadastrado Com Sucesso' TYPE 'S'. "Mensagem do tipo S de Sucesso (S maiúsculo)

    else. "Se ele não conseguiu inserir
      MESSAGE 'Cliente Não Pode Ser Cadastrado' TYPE 'E'. "Mensagem do tipo E de Erro (E maiúsculo)

    ENDIF.

  ENDIF.


"Quando a opção Editar Cliente for marcada:
ELSEIF r_rd2 = 'X'.

  IF p_erg IS INITIAL.
    MESSAGE 'RG Precisa Ser Informado' TYPE 'E'.

  ELSEIF p_ecpf IS INITIAL.
    MESSAGE 'CPF Precisa Ser Informado' TYPE 'E'.

  ELSE.

    SELECT *
    FROM ZTCLIENTES0710
    INTO TABLE t_clientes
    WHERE RG = p_erg and CPF = p_ecpf .
      IF sy-subrc = 0.
        "modifica dados
        w_clientes-cliente = p_eclien.
        w_clientes-rg = p_erg.
        w_clientes-cpf = p_ecpf.
        w_clientes-data_de_nascimento = p_enasci.
        w_clientes-endereco = p_eender.
        w_clientes-telefone = p_efone.

        modify ZTCLIENTES0710 from w_clientes.
        IF sy-subrc = 0. "Só efetiva a gravação se conseguir inserir
          COMMIT WORK.   "Efetiva a gravação do registro no banco de dados
          MESSAGE 'Cliente Modificado Com Sucesso' TYPE 'S'. "Mensagem do tipo S de Sucesso (S maiúsculo)

        else. "Se ele não conseguiu inserir
          MESSAGE 'Cliente Não Pode Ser Modificado' TYPE 'E'. "Mensagem do tipo E de Erro (E maiúsculo)

        ENDIF.
      else.
        MESSAGE 'Cliente não cadastrado' TYPE 'E'.

      ENDIF.

  ENDIF.

ENDIF.
