  programa {

    inclua biblioteca Util --> u
    inclua biblioteca Tipos --> t 

    // Tamanho máximo para suportar os novos cadastros na memória
    const inteiro TOTAL_USUARIOS = 50  // total de usuários com login e senha para acessar o app

    // Vetores globais para armazenar os cadastros de login e senha
    cadeia usuarios[TOTAL_USUARIOS] 
    cadeia senhas[TOTAL_USUARIOS] 
    
    // --- NÍVEIS DE ACESSO E CONTROLE DO SISTEMA ---
    inteiro niveis_acesso[TOTAL_USUARIOS] 
    inteiro g_qtd_usuarios = 5 // Começamos com os 5 usuários iniciais já definidos
    inteiro g_nivel_logado = 0   //zero é sem acesso ao sistema
    logico g_sistema_rodando = verdadeiro // O laço que mantém o programa funcionando mesmo após o logout
    // -----------------------------------------------------------------------------------------------

    // DADOS DA EMPRESA
    cadeia g_nome_empresa = "" // "" para inicializar uma string vazia que mais tarde vai receber dados 
    cadeia g_razao_social = "" 
    cadeia g_cnpj = "" 

    // variáveis globais do cadastro de USUÁRIOS GESTORES
    cadeia g_user_equipes = ""   
    cadeia g_user_rh = ""        
    cadeia g_user_lideranca = "" 
    cadeia g_user_sst = ""       
    cadeia g_user_medicos = ""   

    //Armazena as Senhas de USUÁRIOS GESTORES
    cadeia pass_equipes = "" 
    cadeia pass_rh = ""
    cadeia pass_lideranca = ""
    cadeia pass_sst = ""
    cadeia pass_medicos = ""

    // variáveis globais do cadastro de SETORES
    const inteiro MAX_SETOR = 50 // número maximo de setores que podem ser cadastrados. Alterar conforme necessidade.
    const inteiro MAX_FUNCIONARIOS = 10000  // número maximo de funcionarios que podem ser cadastrados. Alterar conforme necessidade.
    cadeia setores[MAX_SETOR]  
    inteiro funcionarios_setor[MAX_FUNCIONARIOS] 
    inteiro respostas_por_setor[MAX_FUNCIONARIOS]
    inteiro qtd_setores = 0 // inicializa a quantidade de setores em zero


    // Variáveis globais para a lógica do cadastro de setores
    inteiro qtd_func_total = 0 // 
    inteiro funcionarios_restantes
    inteiro qtd_funcionarios_setor
    cadeia nome_setor
    inteiro contador_setores = 1

    // DADOS DO RELATÓRIO GLOBAL DA EMPRESA (Anônimo e Geral)
    real g_soma_score_global = 0.0
    inteiro g_total_pesquisas = 0

    // Vetores simulando o banco de dados de resultados INDIVIDUAIS
    cadeia relatorios_setor[MAX_SETOR]
    inteiro relatorios_criticidade[MAX_SETOR]
    inteiro qtd_relatorios = 0
    
    // Matriz para acumular a soma das notas de cada dimensão por setor
    // 50 setores (linhas) x 7 dimensões de risco (colunas)
    real matriz_dimensoes_setor[50][7] 
    
    //Constantes para identificar cada coluna
    const inteiro COL_DEMANDAS = 0
    const inteiro COL_CONTROLE = 1
    const inteiro COL_CHEFIA   = 2
    const inteiro COL_COLEGAS  = 3
    const inteiro COL_RELACOES = 4
    const inteiro COL_PAPEL    = 5
    const inteiro COL_MUDANCAS = 6

    funcao inicio()
    {
      // [NOVO] Garante que todo o banco de dados comece zerado e limpo
        para (inteiro i = 0; i < 50; i++) {
            respostas_por_setor[i] = 0
            para (inteiro j = 0; j < 7; j++) {
                matriz_dimensoes_setor[i][j] = 0.0
            }
            }
    
        // 1. Inicializa os usuários padrão APENAS UMA VEZ ao abrir o programa
        usuarios_cadastrados()

        // O laço mantém o programa vivo mesmo após o logout
        enquanto (g_sistema_rodando == verdadeiro)
        {
            tela_inicial()

            // O programa decide o que abrir baseado no nível salvo no login
            se (g_nivel_logado == 2) 
            {
                menu_escolha()
            } 
            senao se (g_nivel_logado == 1) 
            {
                escreva("\n[!] Acesso Nível 1: Redirecionando para o Painel de Resultados...\n")
                u.aguarde(2000)
                
                resultados()
                
                escreva("\nSessão encerrada. Voltando para a tela de login...\n")
                u.aguarde(3000)
            }
            senao
            {
                escreva("\nErro: Nível de acesso inválido ou não configurado.\n")
                g_sistema_rodando = falso 
            }
        }
        
        escreva("\nSistema encerrado completamente. Todos os dados da memória foram apagados. Até logo!\n")
    }

    funcao tela_inicial() {
      cadeia usuario_digitado
      cadeia senha_digitada
      logico login_sucesso = falso

      enquanto (login_sucesso == falso)
      {
        escreva(" \n"," \n"," \n")
        escreva("  -----------------------------------------------------------------------------------------------------\n")
        escreva(" |                                                                                                     |\n")
        escreva(" | Bem vindos ao NR1 EM DIA!                                                                           |\n")
        escreva(" | Projetado para trazer tranquilidade em manter sua empresa em acordo com a nova NR1.                 |\n")  
        escreva(" |                                                                                                     |\n")
        escreva(" | Um Sistema de Avaliação Ergonômica Preliminar com metodologia reconhecida HSE                       |\n")
        escreva(" | e relatórios acionáveis que:                                                                         |\n")
        escreva(" |                                                                                                     |\n")
        escreva(" |   * Identificam                                                                                      |\n")
        escreva(" |   * Avaliam e                                                                                        |\n")
        escreva(" |   * Monitoram os Riscos Psicossociais da sua Empresa.                                                |\n")
        escreva(" |                                                                                                     |\n")
        escreva(" | ================================================                                                    |\n")
        escreva(" |                                                    |   Sistema de Avaliação Ergonômica Preliminar   ||\n")
        escreva(" |                                                    |================================================||\n")
        escreva(" |                                                    |======= FAÇA LOGIN PARA ACESSAR O SISTEMA ======||\n")
        escreva(" |                                                    |================================================||\n")
        escreva(" |                                                    |                                                ||\n")
        escreva(" |                                                    | Digite aqui o email cadastrado como Usuário.   ||\n")
        escreva(" |                                                    | Usuário: ")
        leia(usuario_digitado)
        escreva(" |                                                    | Digite aqui sua senha temporária.              ||\n")
        escreva(" |                                                    | Senha: ")
        leia(senha_digitada)
        escreva("  -----------------------------------------------------------------------------------------------------\n")
      
        limpa()

        login_sucesso = verificar_login(usuario_digitado, senha_digitada)

        se (login_sucesso == falso)
        {
          escreva("⚠️⚠️⚠️Aviso: Usuário ou senha incorretos! Tente novamente!\n")
        }
      }

      escreva("\n[SUCESSO]🔑Login efetuado com sucesso! Bem-vindo ao sistema.\n")
      u.aguarde(2000)
      limpa()
    }

    // Função que armazena os dados dos múltiplos usuários fixos iniciais
    funcao usuarios_cadastrados()
    {
      usuarios[0] = "admin"
      senhas[0]   = "1234"
      niveis_acesso[0] = 2 

      usuarios[1] = "suporte"
      senhas[1]   = "9878"
      niveis_acesso[1] = 2 

      usuarios[2] = "ergonomista"
      senhas[2]   = "8868"
      niveis_acesso[2] = 2 

      usuarios[3] = "medico"
      senhas[3]   = "4727"
      niveis_acesso[3] = 1 
    
      usuarios[4] = "lider"
      senhas[4]   = "1202"
      niveis_acesso[4] = 1 
    }

    // NOVA FUNÇÃO: Grava o novo usuário no vetor global para permitir o login
    funcao cadastrar_novo_usuario(cadeia novo_user, cadeia nova_senha, inteiro nivel)
    {
        se (g_qtd_usuarios < TOTAL_USUARIOS)
        {
            usuarios[g_qtd_usuarios] = novo_user
            senhas[g_qtd_usuarios] = nova_senha
            niveis_acesso[g_qtd_usuarios] = nivel
            g_qtd_usuarios++ 
        }
    }

    // NOVA FUNÇÃO: Lê o nível digitado, valida se é número e se é 1 ou 2
    funcao inteiro ler_nivel_valido()
    {
        cadeia entrada
        inteiro nivel_convertido
        logico valido = falso

        enquanto (valido == falso)
        {
            escreva("    Defina o Nível (1 - Apenas Resultados | 2 - Acesso Total): ")
            leia(entrada)

            // Valida se a pessoa digitou algo que pode ser convertido em número
            se (t.cadeia_e_inteiro(entrada, 10))
            {
                nivel_convertido = t.cadeia_para_inteiro(entrada, 10)
                
                // Valida se o número é estritamente 1 ou 2
                se (nivel_convertido == 1 ou nivel_convertido == 2)
                {
                    valido = verdadeiro
                    retorne nivel_convertido
                }
                senao
                {
                    escreva("    ❌ Erro: O nível de acesso deve ser exatamente 1 ou 2.\n")
                }
            }
            senao
            {
                escreva("    ❌ Erro: Caractere inválido. Digite apenas os números 1 ou 2.\n")
            }
        }
        retorne 1 // Retorno de segurança (nunca deve chegar aqui sem validar)
    }

    // Função de verificação agora usa g_qtd_usuarios em vez de varrer até 50 vazio
    funcao logico verificar_login(cadeia usuario, cadeia senha)
    {
      para (inteiro i = 0; i < g_qtd_usuarios; i++)
      {
        se (usuarios[i] == usuario e senhas[i] == senha)
        {
          g_nivel_logado = niveis_acesso[i] 
          retorne verdadeiro 
        }
      }
      retorne falso
    }

    funcao menu_escolha()
    {
        cadeia opcao = "0" 

        enquanto (opcao != "5" e opcao != "6")
        {
          escreva("\n|================================================|\n")
          escreva("|                 MENU PRINCIPAL                 |\n")
          escreva("|================================================|\n")
          escreva("| 1. Cadastrar Empresa                           |\n")
          escreva("| 2. Abrir Formulário e Iniciar Pesquisa         |\n")
          escreva("| 3. Gerenciar Empresa                           |\n")
          escreva("| 4. Visualizar resultados                       |\n")
          escreva("| 5. Fazer Logout (Trocar de Usuário)            |\n")
          escreva("| 6. Encerrar Sistema                            |\n")
          escreva("|================================================|\n")
          escreva("Escolha uma opção: ")
          leia(opcao)
          limpa()

          escolha (opcao)
          {
            caso "1":
              qtd_setores = 0
              inteiro nivel_escolhido = 0
              
              escreva("|================================================|\n")
              escreva("| CADASTRAR MINHA EMPRESA                        |\n")
              escreva("|================================================|\n\n")
            
              escreva(" Nome da Empresa: ")
              leia(g_nome_empresa)
              escreva(" Razão Social: ")
              leia(g_razao_social)
              escreva(" CNPJ: ")
              leia(g_cnpj)
              u.aguarde(1000)
            
              escreva("\n ==========================================\n")
              escreva("|--- CADASTRO DE GESTORES POR PERMISSÃO ---|\n")  
              escreva(" ==========================================\n")

              // --- BLOCO ATUALIZADO COM VALIDAÇÃO E CADASTRO REAL ---
              escreva("\n[ ] Administrador de Equipes - Email: ")
              leia(g_user_equipes)
              escreva("    Senha: ")
              leia(pass_equipes)
              nivel_escolhido = ler_nivel_valido()
              cadastrar_novo_usuario(g_user_equipes, pass_equipes, nivel_escolhido)

              escreva("\n[ ] Administrador de RH - Email: ")
              leia(g_user_rh)
              escreva("    Senha: ")
              leia(pass_rh)
              nivel_escolhido = ler_nivel_valido()
              cadastrar_novo_usuario(g_user_rh, pass_rh, nivel_escolhido)

              escreva("\n[ ] Administrador de Liderança - Email: ")
              leia(g_user_lideranca)
              escreva("    Senha: ")
              leia(pass_lideranca)
              nivel_escolhido = ler_nivel_valido()
              cadastrar_novo_usuario(g_user_lideranca, pass_lideranca, nivel_escolhido)

              escreva("\n[ ] Administrador de SST - Email: ")
              leia(g_user_sst)
              escreva("    Senha: ")
              leia(pass_sst)
              nivel_escolhido = ler_nivel_valido()
              cadastrar_novo_usuario(g_user_sst, pass_sst, nivel_escolhido)

              escreva("\n[ ] Administrador de Médicos - Email: ")
              leia(g_user_medicos)
              escreva("    Senha: ")
              leia(pass_medicos)
              nivel_escolhido = ler_nivel_valido()
              cadastrar_novo_usuario(g_user_medicos, pass_medicos, nivel_escolhido)
              // -------------------------------------------------------
              
              escreva("\n✅ Gestores Cadastrados com Sucesso!\n")
              u.aguarde(2000)
              limpa()

              inteiro funcionarios_restantes
              qtd_funcionarios_setor = 0
              contador_setores = 1
              cadeia entrada_auxiliar 

              escreva("\n ==========================================\n")
              escreva("|---  CADASTRO DE SETORES DA EMPRESA   ---|\n")            
              escreva(" ==========================================\n\n")
            
              escreva("Quantidade total de funcionários da empresa: ")
              leia(entrada_auxiliar)
              se (t.cadeia_e_inteiro(entrada_auxiliar, 10)) {
                qtd_func_total = t.cadeia_para_inteiro(entrada_auxiliar, 10)
              } senao {
                escreva("❌ Opção inválida! Definido como 0.\n")
                qtd_func_total = 0
                u.aguarde(1500)
              }
            
              funcionarios_restantes = qtd_func_total

              enquanto (funcionarios_restantes > 0)
              {
                escreva("\nFuncionários ainda não alocados: ", funcionarios_restantes, "\n")
                escreva("Nome do setor nº ", contador_setores, ": ")
                leia(nome_setor)
              
                escreva("Quantidade de funcionários no setor: ")
                leia(entrada_auxiliar)
                
                se (t.cadeia_e_inteiro(entrada_auxiliar, 10)) {
                  qtd_funcionarios_setor = t.cadeia_para_inteiro(entrada_auxiliar, 10)
                  
                  se (qtd_funcionarios_setor > funcionarios_restantes) {
                      escreva("\n❌ Erro: O setor tem mais funcionários do que o disponível na empresa!\n")
                      u.aguarde(1500)
                  } senao se (qtd_funcionarios_setor <= 0) {
                      escreva("\n❌ Erro: A quantidade deve ser maior que zero!\n")
                      u.aguarde(1500)
                  } senao {
                      funcionarios_restantes = funcionarios_restantes - qtd_funcionarios_setor
                      setores[qtd_setores] = nome_setor
                      funcionarios_setor[qtd_setores] = qtd_funcionarios_setor
                      qtd_setores++   
                      contador_setores++
                      escreva("✅ Setor cadastrado!\n")
                      u.aguarde(1000)
                  }
                } senao {
                  escreva("❌ Digite um número válido.\n")
                  u.aguarde(1500)
                }
                limpa()
              }

              escreva("|================================================|\n")
              escreva("| EMPRESA CADASTRADA COM SUCESSO!                |\n")
              escreva("|================================================|\n")
              escreva("\nPressione Enter para voltar ao Menu Principal...")
              cadeia pausa
              leia(pausa)
              limpa()
              pare

            caso "2":
              se (g_nome_empresa == "" ou qtd_setores == 0) {
                  escreva("❌ ERRO: Nenhuma Empresa ou Setor cadastrado!\n")
                  escreva("   Por favor, vá em '1. Cadastrar Empresa' primeiro.\n")
                  u.aguarde(3000)
                  limpa()
                  pare
              }

              escreva("|================================================================|\n")
              escreva("| FORMULÁRIO DE PESQUISA COMPLETO E FLUXO DE RISCO NR1           |\n")
              escreva("|================================================================|\n\n")

              escreva(" Empresa Avaliada: ", g_nome_empresa, " (CNPJ: ", g_cnpj, ")\n")
              escreva("\n Escolha qual setor irá responder à pesquisa:\n")
              
              para(inteiro i = 0; i < qtd_setores; i++) {
                  escreva(" [", i+1, "] - ", setores[i], " (", funcionarios_setor[i], " funcionários registrados)\n")
              }

              cadeia entrada_setor
              inteiro indice_escolhido = -1
              logico setor_valido = falso

              enquanto (setor_valido == falso) {
                  escreva("\n Digite o número correspondente ao setor: ")
                  leia(entrada_setor)
                  
                  se (t.cadeia_e_inteiro(entrada_setor, 10)) {
                      inteiro op = t.cadeia_para_inteiro(entrada_setor, 10)
                      se (op >= 1 e op <= qtd_setores) {
                          indice_escolhido = op - 1
                          setor_valido = verdadeiro
                      } senao {
                          escreva(" ❌ Setor não encontrado. Escolha um número válido da lista.\n")
                      }
                  } senao {
                      escreva(" ❌ Entrada inválida. Digite apenas números.\n")
                  }
              }

              cadeia nome_setor_pesquisa = setores[indice_escolhido]
              inteiro tamanho_setor = funcionarios_setor[indice_escolhido]

              limpa()
              escreva(" >> Setor selecionado: ", nome_setor_pesquisa, "\n")
              escreva(" >> Total de funcionários do sertor: ", tamanho_setor, "\n")
              u.aguarde(2000)
              
              // Aviso de segurançapara garantia do anonimato antes do preenchimento
              se (tamanho_setor < 5) {
                  limpa()
                  escreva("=================================================================\n")
                  escreva(" ⚠️ AVISO: REGRA DO N MÍNIMO DE ANONIMATO\n")
                  escreva("=================================================================\n")
                  escreva(" O setor '", nome_setor_pesquisa, "' possui apenas ", tamanho_setor, " funcionários.\n")
                  escreva(" Para proteger sua identidade, não haverá um relatório individual para o seu setor.\n")
                  escreva(" Suas respostas são muito importantes e serão computadas de forma\n")
                  escreva(" 100% anônima no Relatório Geral da Empresa.\n")
                  escreva("=================================================================\n")
                  escreva("\nPressione Enter para continuar para as perguntas...")
                  cadeia pausa_n
                  leia(pausa_n)
                  limpa()
              }

              limpa()
              inteiro resp[36] 
              inteiro nota_digitada
              cadeia nota_auxiliar

              escreva("=======================================================================================\n")
              escreva(" INSTRUÇÕES - PARTE 1: Responda usando a escala de FREQUÊNCIA:\n")
              escreva(" 1 = Nunca  | 2 = Raramente  |  3 = Às vezes  |  4 = Frequentemente  | 5 = Sempre\n")
              escreva("========================================================================================\n\n")
              
              para(inteiro p = 1; p <= 35; p++) {
                se(p == 24) {
                    limpa()
                    escreva("===========================================================================================\n")
                    escreva(" INSTRUÇÕES - PARTE 2: Responda usando a escala de CONCORDÂNCIA:\n")
                    escreva(" 1 = Discordo Total  |  2 = Discordo  |  3 = Neutro  |  4 = Concordo  |  5 = Concordo Total\n")
                    escreva("===========================================================================================\n\n")
                }

                logico resposta_valida = falso
                
                enquanto (resposta_valida == falso) {
                    escolha(p) {
                        caso 1: escreva("[1/35 - Demandas] Eu tenho prazos inalcançáveis.\nNota: ") pare
                        caso 2: escreva("[2/35 - Demandas] Eu tenho que trabalhar muito rapidamente.\nNota: ") pare
                        caso 3: escreva("[3/35 - Demandas] Eu tenho que deixar de fazer algumas tarefas por ter trabalho em excesso.\nNota: ") pare
                        caso 4: escreva("[4/35 - Demandas] Sinto-me pressionado devido a prazos longos ou sobrecarga de tempo.\nNota: ") pare
                        caso 5: escreva("[5/35 - Controle] Posso decidir quando fazer uma pausa.\nNota: ") pare
                        caso 6: escreva("[6/35 - Controle] Tenho direito a opinar sobre a velocidade ou ritmo do meu trabalho.\nNota: ") pare
                        caso 7: escreva("[7/35 - Controle] Tenho flexibilidade e escolha sobre os métodos que uso para trabalhar.\nNota: ") pare
                        caso 8: escreva("[8/35 - Controle] Tenho oportunidade de planejar a minha rotina e minhas tarefas diárias.\nNota: ") pare
                        caso 9: escreva("[9/35 - Controle] Posso decidir a ordem e a sequência de como realizo minhas atividades.\nNota: ") pare
                        caso 10: escreva("[10/35 - Controle] Meu horário de trabalho é flexível ou adaptável às minhas necessidades.\nNota: ") pare
                        caso 11: escreva("[11/35 - Apoio Chefia] Meu chefe imediato me incentiva e apoia no cumprimento das metas.\nNota: ") pare
                        caso 12: escreva("[12/35 - Apoio Chefia] Sinto que recebo feedback de apoio sobre o trabalho que realizo.\nNota: ") pare
                        caso 13: escreva("[13/35 - Apoio Chefia] Posso contar com meu gestor quando surgem problemas difíceis.\nNota: ") pare
                        caso 14: escreva("[14/35 - Apoio Chefia] Meu superior me ouve e considera minhas opiniões de forma respeitosa.\nNota: ") pare
                        caso 15: escreva("[15/35 - Apoio Colegas] Meus colegas de equipe são amigáveis e prestativos comigo.\nNota: ") pare
                        caso 16: escreva("[16/35 - Apoio Colegas] Recebo a ajuda prática necessária da parte dos meus colegas de trabalho.\nNota: ") pare
                        caso 17: escreva("[17/35 - Apoio Colegas] Meus colegas de trabalho me respeitam profissionalmente.\nNota: ") pare
                        caso 18: escreva("[18/35 - Apoio Colegas] Existe cooperação mútua entre os funcionários para resolver gargalos.\nNota: ") pare
                        caso 19: escreva("[19/35 - Relacionamentos] Sou submetido a cobranças agressivas ou comentários humilhantes.\nNota: ") pare
                        caso 20: escreva("[20/35 - Relacionamentos] Há atritos e conflitos interpessoais não resolvidos na equipe.\nNota: ") pare
                        caso 21: escreva("[21/35 - Relacionamentos] Sinto que sou alvo de piadas de mau gosto ou isolamento social.\nNota: ") pare
                        caso 22: escreva("[22/35 - Relacionamentos] Situações de assédio (moral ou verbal) ocorrem no setor.\nNota: ") pare
                        caso 23: escreva("[23/35 - Papel/Cargo] Tenho clareza absoluta sobre os objetivos gerais do meu setor.\nNota: ") pare
                        caso 24: escreva("[24/35 - Demandas] É esperado que eu faça horas extras excessivas para dar conta do fluxo.\nNota: ") pare
                        caso 25: escreva("[25/35 - Demandas] Diferentes grupos ou pessoas me dão ordens ou exigências contraditórias.\nNota: ") pare
                        caso 26: escreva("[26/35 - Papel/Cargo] Eu sei exatamente o que se espera de mim no meu cargo.\nNota: ") pare
                        caso 27: escreva("[27/35 - Papel/Cargo] Sei claramente quais são as minhas responsabilidades e atribuições.\nNota: ") pare
                        caso 28: escreva("[28/35 - Papel/Cargo] Sinto que desempenho funções que deveriam ser de outro cargo.\nNota: ") pare
                        caso 29: escreva("[29/35 - Papel/Cargo] Entendo perfeitamente como o meu trabalho se conecta aos objetivos da firma.\nNota: ") pare
                        caso 30: escreva("[30/35 - Papel/Cargo] Meus objetivos de trabalho são bem definidos pela gerência.\nNota: ") pare
                        caso 31: escreva("[31/35 - Mudanças] A gerência me consulta antes de implementar mudanças no meu setor.\nNota: ") pare
                        caso 32: escreva("[32/35 - Mudanças] Quando ocorrem mudanças, a empresa explica os motivos de forma clara.\nNota: ") pare
                        caso 33: escreva("[33/35 - Mudanças] Sou bem informado sobre como as mudanças impactarão meu dia a dia.\nNota: ") pare
                        caso 34: escreva("[34/35 - Relacionamentos] Relacionamentos ruins ou desgastados no trabalho me desmotivam.\nNota: ") pare
                        caso 35: escreva("[35/35 - Relacionamentos] Se o clima esquenta no setor, as coisas são resolvidas com grosseria.\nNota: ") pare
                    }

                    leia(nota_auxiliar)
                    
                    se (t.cadeia_e_inteiro(nota_auxiliar, 10)) {
                        nota_digitada = t.cadeia_para_inteiro(nota_auxiliar, 10)
                        se (nota_digitada >= 1 e nota_digitada <= 5) {
                          resp[p] = nota_digitada
                          resposta_valida = verdadeiro 
                        } senao {
                          escreva("\n❌ ERRO: Digite apenas uma opção entre 1 e 5!\n\n")
                        }
                    } senao {
                        escreva("\n❌ ERRO: Opção vazia ou inválida! Digite apenas números de 1 a 5.\n\n")
                    }
                }
              }
              limpa()

              resp[1] = 6 - resp[1]   resp[2] = 6 - resp[2]   resp[3] = 6 - resp[3]   resp[4] = 6 - resp[4]
              resp[19] = 6 - resp[19] resp[20] = 6 - resp[20] resp[21] = 6 - resp[21] resp[22] = 6 - resp[22]
              resp[24] = 6 - resp[24] resp[25] = 6 - resp[25] resp[34] = 6 - resp[34] resp[35] = 6 - resp[35]
              resp[28] = 6 - resp[28]

              real d_demandas = (resp[1] + resp[2] + resp[3] + resp[4] + resp[24] + resp[25]) / 6.0
              real d_controle = (resp[5] + resp[6] + resp[7] + resp[8] + resp[9] + resp[10]) / 6.0
              real d_apoio_chefia = (resp[11] + resp[12] + resp[13] + resp[14]) / 4.0
              real d_apoio_colegas = (resp[15] + resp[16] + resp[17] + resp[18]) / 4.0 
              real d_relacionamentos = (resp[19] + resp[20] + resp[21] + resp[22] + resp[34] + resp[35]) / 6.0
              real d_papel = (resp[23] + resp[26] + resp[27] + resp[28] + resp[29] + resp[30]) / 6.0
              real d_mudancas = (resp[31] + resp[32] + resp[33]) / 3.0


              
              real score_global = (d_demandas + d_controle + d_apoio_chefia + d_apoio_colegas + d_relacionamentos + d_papel + d_mudancas) / 7.0 
              
              // ====================================================================
              // [NOVO] ETAPA 1: ACUMULAR OS DADOS NA MATRIZ DO SETOR SELECIONADO
              // ====================================================================
              matriz_dimensoes_setor[indice_escolhido][0] = matriz_dimensoes_setor[indice_escolhido][0] + d_demandas
              matriz_dimensoes_setor[indice_escolhido][1] = matriz_dimensoes_setor[indice_escolhido][1] + d_controle
              matriz_dimensoes_setor[indice_escolhido][2] = matriz_dimensoes_setor[indice_escolhido][2] + d_apoio_chefia
              matriz_dimensoes_setor[indice_escolhido][3] = matriz_dimensoes_setor[indice_escolhido][3] + d_apoio_colegas
              matriz_dimensoes_setor[indice_escolhido][4] = matriz_dimensoes_setor[indice_escolhido][4] + d_relacionamentos
              matriz_dimensoes_setor[indice_escolhido][5] = matriz_dimensoes_setor[indice_escolhido][5] + d_papel
              matriz_dimensoes_setor[indice_escolhido][6] = matriz_dimensoes_setor[indice_escolhido][6] + d_mudancas

              // Incrementa o contador de respostas que de fato recebemos para este setor
              respostas_por_setor[indice_escolhido] = respostas_por_setor[indice_escolhido] + 1
              // ====================================================================

              inteiro probabilidade = 1
              se (score_global <= 2.2) { probabilidade = 3 } 
              senao se (score_global <= 3.8) { probabilidade = 2 }
                

              


              inteiro severidade = 2
              inteiro criticidade = probabilidade * severidade

              // --- ALIMENTANDO O BANCO DE DADOS GERAL DA EMPRESA ---
              g_soma_score_global = g_soma_score_global + score_global
              g_total_pesquisas = g_total_pesquisas + 1

              // --- ALIMENTANDO BANCO INDIVIDUAL ---
              
              // ====================================================================
              // [AJUSTADO] AGORA A VALIDAÇÃO USA O CONTADOR DE RESPOSTAS REAIS
              // ====================================================================
              se (respostas_por_setor[indice_escolhido] >= 5) {
                  
                  // Grava no relatório antigo apenas para não quebrar o resto do seu código
                  relatorios_setor[qtd_relatorios] = nome_setor_pesquisa 
                  relatorios_criticidade[qtd_relatorios] = criticidade
                  qtd_relatorios++
             

                  escreva("|================================================================|\n")
                  escreva("| RELATÓRIO INDIVIDUAL GERADO E ARMAZENADO                       |\n")
                  escreva("|================================================================|\n")
                  escreva(" Setor Monitorado: ", nome_setor_pesquisa, "\n")
                  escreva(" Criticidade: ", criticidade, "\n")
                  escreva("----------------------------------------------------------------\n")
                  escreva(" DESEMPENHO DETALHADO POR DIMENSÃO:\n")
                  escreva("  • [Demandas Ocupacionais]:    ", d_demandas, "\n")
                  escreva("  • [Controle / Autonomia]:     ", d_controle, "\n")
                  escreva("  • [Suporte da Liderança]:     ", d_apoio_chefia, "\n")
                  escreva("  • [Suporte dos Colegas]:      ", d_apoio_colegas, "\n")
                  escreva("  • [Relações Interpessoais]:   ", d_relacionamentos, "\n")
                  escreva("  • [Clareza de Papel/Cargo]:   ", d_papel, "\n")
                  escreva("  • [Gestão de Mudanças]:       ", d_mudancas, "\n\n")
                  
                  escreva("----------------------------------------------------------------\n")
                  escreva(" ANÁLISE AUTOMÁTICA DO SISTEMA (DIAGNÓSTICO ALGORÍTMICO)\n")
                  escreva("----------------------------------------------------------------\n")

                  se (criticidade >= 6) { 
                      escreva(" [!] FLUXO ACIONADO: ALERTA DE POSSÍVEL ADOECIMENTO COLETIVO\n\n")
                      escreva(" O sistema detectou um ambiente criticamente tóxico.\n")
                      escreva(" ➡️ AÇÃO: Encaminha p/ AET em caráter emergencial.\n")
                      escreva(" ➡️ AÇÃO: Notifica equipe SST e Médica para imediata investigação clínica.\n")
                  } senao se (criticidade >= 4) { 
                      escreva(" [!] FLUXO ACIONADO: RISCO IDENTIFICADO = SIM (Criticidade Média/Alta)\n\n")
                      escreva(" O sistema detectou fatores de risco, mas sem adoecimento iminente.\n")
                      escreva(" ➡️ AÇÃO: Gera Plano de Ação Preventivo.\n")
                  } senao { 
                      escreva(" [!] FLUXO ACIONADO: RISCO IDENTIFICADO = NÃO (Risco Baixo/Aceitável)\n\n")
                      escreva(" O ambiente está favorável e dentro das métricas de saúde psicossocial.\n")
                      escreva(" ➡️ AÇÃO: Nenhuma intervenção corretiva exigida no momento.\n")
                  }
                  escreva("================================================================\n")
                  
              } senao {
                  escreva("|================================================================|\n")
                  escreva("| QUESTIONÁRIO FINALIZADO COM SUCESSO!                           |\n")
                  escreva("|================================================================|\n")
                  escreva(" Muito obrigado pelas suas respostas.\n")
                  escreva(" Devido à regra do N mínimo (< 5), o relatório individual não será exibido.\n")
                  escreva(" Respostas coletadas neste setor até agora: ", respostas_por_setor[indice_escolhido], " / 5 necessárias.\n")
                  escreva(" Seus dados foram somados com sucesso ao Relatório Geral da Empresa.\n")
                  escreva("=================================================================\n")
              }

              escreva("\nPressione Enter para retornar ao Menu Principal...")
              cadeia pausa_fim
              leia(pausa_fim)
              limpa()
              pare

            caso "3":
              cadeia op_gerenciar = ""

              enquanto(op_gerenciar != "9")
              {
                  escreva("|================================================|\n")
                  escreva("|            GERENCIAR MINHA EMPRESA             |\n")
                  escreva("|================================================|\n")
                  escreva("  🔷 Empresa: ", g_nome_empresa,"\n")
                  escreva("  🔷 Razão Social: ", g_razao_social, "\n")
                  escreva("  🔷 CNPJ: ", g_cnpj, "\n")
                  escreva("-----------------------------------------------------------------------\n")
                  escreva(" SETORES CADASTRADOS E QUANTIDADE DE FUNCIONÁRIOS:\n")
                  
                  para (inteiro i = 0; i < qtd_setores; i++)
                  {
                      escreva("  🔷  Setor: ", setores[i], " | Qtdade Funcionários: ", funcionarios_setor[i], "\n")
                  }
                  escreva("-----------------------------------------------------------------------\n")
                  escreva("  🔷  Número total de funcionários da Empresa:",qtd_func_total,"\n") 
                  escreva("-----------------------------------------------------------------------\n")
                  escreva("\n--- LISTA DE USUÁRIOS CADASTRADOS ---\n")
                  escreva("  🔷  Equipes   -> ", g_user_equipes, "\n")
                  escreva("  🔷  RH        -> ", g_user_rh, "\n")
                  escreva("  🔷  Liderança -> ", g_user_lideranca, "\n")
                  escreva("  🔷  SST       -> ", g_user_sst, "\n")
                  escreva("  🔷  Médicos   -> ", g_user_medicos, "\n")
                  escreva("=======================================================================\n")

                  escreva("\n")
                  escreva("1 - Visualizar Setores\n")
                  escreva("2 - Alterar Nome da Empresa\n")
                  escreva("3 - Alterar Razão Social\n")
                  escreva("4 - Alterar CNPJ\n")
                  escreva("5 - Adicionar Setor\n")
                  escreva("6 - Editar Setor\n")
                  escreva("7 - Excluir Setor\n")
                  escreva("8 - Gerenciar Gestores (Apenas Visualização nesta versão)\n")
                  escreva("9 - Voltar\n")

                  escreva("\nEscolha: ")
                  leia(op_gerenciar)
                  limpa()

                  escolha(op_gerenciar)
                  {
                      caso "1":
                          escreva("=== SETORES CADASTRADOS ===\n\n")
                          se(qtd_setores == 0) {
                              escreva("Nenhum setor cadastrado.\n")
                          } senao {
                              para(inteiro i = 0; i < qtd_setores; i++) {
                                  escreva(i + 1," - ",setores[i]," (",funcionarios_setor[i]," funcionários)\n")
                              }
                          }
                          cadeia pausa1
                          escreva("\nPressione Enter...")
                          leia(pausa1)
                          limpa()
                          pare

                      caso "2":
                          escreva("Nome atual: ", g_nome_empresa, "\nNovo nome: ")
                          leia(g_nome_empresa)
                          escreva("\nAlterado com sucesso!")
                          u.aguarde(1500)
                          limpa()
                          pare

                      caso "3":
                          escreva("Razão social atual: ", g_razao_social, "\nNova razão social: ")
                          leia(g_razao_social)
                          escreva("\nAlterado com sucesso!")
                          u.aguarde(1500)
                          limpa()
                          pare

                      caso "4":
                          escreva("CNPJ atual: ", g_cnpj, "\nNovo CNPJ: ")
                          leia(g_cnpj)
                          escreva("\nAlterado com sucesso!")
                          u.aguarde(1500)
                          limpa()
                          pare

                      caso "5":
                          se(qtd_setores < MAX_SETOR) {
                              escreva("Nome do novo setor: ")
                              leia(setores[qtd_setores])
                              escreva("Quantidade de funcionários: ")
                              leia(funcionarios_setor[qtd_setores])
                              qtd_func_total = qtd_func_total + (funcionarios_setor[qtd_setores])
                              qtd_setores++
                              escreva("\nSetor cadastrado com sucesso!")
                          } senao {
                              escreva("Limite máximo de setores atingido.")
                          }
                          u.aguarde(1500)
                          limpa()
                          pare

                      caso "6":
                          se(qtd_setores == 0) {
                              escreva("Nenhum setor cadastrado.\n")
                              u.aguarde(2000)
                              limpa()
                              pare
                          }

                          escreva("=== SETORES ===\n\n")
                          para(inteiro i=0; i<qtd_setores; i++) {
                              escreva(i+1, " - ", setores[i], " (", funcionarios_setor[i], " funcionários)\n")
                          }

                          inteiro editar
                          escreva("\nQual setor deseja editar? ")
                          leia(editar)
                          editar-- 

                          se(editar >= 0 e editar < qtd_setores) {
                              escreva("Novo nome do setor: ")
                              leia(setores[editar])

                              inteiro nova_quantidade
                              escreva("Nova quantidade de funcionários: ")
                              leia(nova_quantidade)

                              qtd_func_total = qtd_func_total - funcionarios_setor[editar]
                              qtd_func_total = qtd_func_total + nova_quantidade
                              funcionarios_setor[editar] = nova_quantidade

                              escreva("\n✅ Setor atualizado com sucesso!\n")
                          } senao {
                              escreva("\n❌ Setor inválido.")
                          }
                          
                          u.aguarde(2000)
                          limpa()
                          pare

                      caso "7":
                          se(qtd_setores == 0) {
                              escreva("Nenhum setor cadastrado.\n")
                              u.aguarde(2000)
                              limpa()
                              pare
                          }

                          inteiro excluir
                          escreva("Qual setor deseja excluir?\n\n")
                          para(inteiro i=0; i<qtd_setores; i++) {
                              escreva(i+1, " - ", setores[i], " (", funcionarios_setor[i], " funcionários)\n")
                          }

                          escreva("\nEscolha: ")
                          leia(excluir)
                          excluir--

                          se(excluir >= 0 e excluir < qtd_setores) {
                              qtd_func_total = qtd_func_total - funcionarios_setor[excluir]

                              para(inteiro i=excluir; i < qtd_setores - 1; i++) {
                                  setores[i] = setores[i+1]
                                  funcionarios_setor[i] = funcionarios_setor[i+1]
                              }

                              qtd_setores-- 
                              escreva("\n✅ Setor removido com sucesso!")
                          } senao {
                              escreva("\n❌ Setor inválido.")
                          }

                          u.aguarde(2000)
                          limpa()
                          pare

                      caso "8":
                          escreva("|===============================|\n")
                          escreva("| GERENCIAR GESTORES            |\n")
                          escreva("|===============================|\n")
                          escreva(" Para manter a segurança da sessão, edite novos usuários na próxima reinicialização.\n")
                          cadeia op_voltar
                          escreva("\nPressione Enter para voltar...")
                          leia(op_voltar)
                          limpa()
                          pare

                      caso "9":
                          limpa()
                          pare

                      caso contrario:
                          escreva("Opção inválida!")
                          u.aguarde(1500)
                          limpa()
                          pare
                  }
              } 
              pare

            caso "4": 
              resultados()
              pare
            
            caso "5":
              escreva("Fazendo logout... Retornando à tela de login.\n")
              u.aguarde(1500)
              limpa()
              pare

            caso "6":
              escreva("Encerrando o sistema e apagando dados da memória...\n")
              g_sistema_rodando = falso
              u.aguarde(1500)
              limpa()
              pare

            caso contrario:
              escreva("Opção inválida! Tente novamente.\n")
              u.aguarde(1500)
              limpa()
              pare
          } 
        } 
    }
      
    funcao resultados() {
      limpa()
      escreva("|================================================================|\n")
      escreva("| PAINEL DE RESULTADOS E MEDIDAS PREVENTIVAS (NR1)               |\n")
      escreva("|================================================================|\n\n")
              
      se (g_total_pesquisas == 0) {
        escreva(" Nenhum questionário foi respondido até o momento.\n")
      } senao { 
          
        real media_global = g_soma_score_global / g_total_pesquisas
        inteiro crit_geral = 1 
        
        se (media_global <= 1.5) { crit_geral = 5 }       
        senao se (media_global <= 2.5) { crit_geral = 4 } 
        senao se (media_global <= 3.5) { crit_geral = 3 } 
        senao se (media_global <= 4.5) { crit_geral = 2 } 
        senao { crit_geral = 1 }                          

        escreva(" 🏢 RELATÓRIO GERAL DA EMPRESA: ", g_nome_empresa, "\n")
        escreva(" Total de questionários respondidos: ", g_total_pesquisas, "\n")
        escreva(" Criticidade Média Organizacional: Nível ", crit_geral, "\n")
                  
        se (crit_geral >= 5) {
          escreva("    Nível de Risco Geral: 🔴 CRÍTICO OU EXTREMO\n")
          escreva("    Ação Global: Risco intolerável. Intervenção organizacional urgente e imediata.\n")
        } senao se (crit_geral == 4) {
          escreva("    Nível de Risco Geral: 🟠 ALTO\n")
          escreva("    Ação Global: Exige medidas de controle imediatas e priorização no PGR.\n")
        } senao se (crit_geral == 3) {
          escreva("    Nível de Risco Geral: 🟡 MÉDIO\n")
          escreva("    Ação Global: Revisão de processos e plano de ação preventivo a curto/médio prazo.\n")
        } senao se (crit_geral == 2) {
          escreva("    Nível de Risco Geral: 🟢 ACEITÁVEL\n")
          escreva("    Ação Global: Risco tolerável. Manter medidas de controle e monitoramento.\n")
        } senao {
          escreva("    Nível de Risco Geral: 🔵 BAIXO\n")
          escreva("    Ação Global: Clima organizacional saudável e riscos triviais. Manter rotina.\n")
        }

        escreva("\n----------------------------------------------------------------\n")
        escreva(" 📊 RELATÓRIOS INDIVIDUAIS POR SETOR (Apenas Setores com 5+ Func.)\n")
        escreva("----------------------------------------------------------------\n")


        se (qtd_relatorios == 0) {
          escreva(" Nenhum setor atingiu o N Mínimo para ter seus resultados detalhados.\n")
        } senao {
          para (inteiro i = 0; i < qtd_relatorios; i++) {
            escreva(" 📌 Setor Avaliado: ", relatorios_setor[i], " | Nível de Criticidade: ", relatorios_criticidade[i], "\n")
                          
            se (relatorios_criticidade[i] >= 5) {
              escreva("    Nível de Risco: 🔴 CRÍTICO OU EXTREMO\n")
              escreva("    Medidas Recomendadas (NR-1):\n")
              escreva("      - Paralisação de atividades específicas ou intervenção urgente.\n")
              escreva("      - Encaminhar imediatamente para AET (Análise Ergonômica do Trabalho).\n")
              escreva("      - Notificar a equipe médica e de SST de imediato.\n")
            } senao se (relatorios_criticidade[i] == 4) {
              escreva("    Nível de Risco: 🟠 ALTO\n")
              escreva("    Medidas Recomendadas (NR-1):\n")
              escreva("      - Adoção rápida de medidas de controle (Engenharia ou Administrativas).\n")
              escreva("      - Inserir no PGR como prioridade de ação a curto prazo.\n")
            } senao se (relatorios_criticidade[i] == 3) {
              escreva("    Nível de Risco: 🟡 MÉDIO\n")
              escreva("    Medidas Recomendadas (NR-1):\n")
              escreva("      - Gerar Plano de Ação Preventivo.\n")
              escreva("      - Alimentar o inventário de riscos do PGR e monitorar.\n")
            } senao se (relatorios_criticidade[i] == 2) {
              escreva("    Nível de Risco: 🟢 ACEITÁVEL\n")
              escreva("    Medidas Recomendadas (NR-1):\n")
              escreva("      - Manter as medidas de controle já existentes.\n")
              escreva("      - Nenhuma intervenção corretiva drástica é exigida.\n")
            } senao {
              escreva("    Nível de Risco: 🔵 BAIXO\n")
              escreva("    Medidas Recomendadas (NR-1):\n")
              escreva("      - Risco trivial / irrelevante.\n")
              escreva("      - Manter acompanhamento de rotina.\n")
            }
            escreva("................................................................\n")

            escreva("\n")
            escreva(" ========================================================\n")
            escreva(" 📊 MATRIZ DE RISCO (Probabilidade x Severidade)         \n")
            escreva(" ========================================================\n\n")
      
            escreva("   P   5 | 🟡 | 🟠 | 🟠 | 🔴 | 🔴 |\n")
            escreva("   R   4 | 🟢 | 🟡 | 🟠 | 🔴 | 🔴 |\n")
            escreva("   O   3 | 🟢 | 🟢 | 🟡 | 🟠 | 🔴 |\n")
            escreva("   B   2 | 🔵 | 🟢 | 🟡 | 🟡 | 🟠 |\n")
            escreva("   .   1 | 🔵 | 🔵 | 🟢 | 🟢 | 🟡 |\n")
            escreva("         -------------------------\n")
            escreva("           1    2    3    4    5  \n")
            escreva("             SEVERIDADE (Impacto) \n\n")

            escreva(" LEGENDA:\n")
            escreva(" 🔵 Nível 1 - Baixo      | 🟠 Nível 4 - Alto\n")
            escreva(" 🟢 Nível 2 - Aceitável  | 🔴 Nível 5 - Crítico/Extremo\n")
            escreva(" 🟡 Nível 3 - Médio      |\n")
            escreva(" --------------------------------------------------------\n\n")
          }
        }
      }
              
      escreva("\nPressione Enter para voltar ao Menu Principal...")
      cadeia pausa_resultados
      leia(pausa_resultados)
      limpa()
    }
  }