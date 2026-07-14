# NR1 EM DIA - Sistema de Avaliação Ergonômica Preliminar

O **NR1 EM DIA** é um Sistema de Informação desenvolvido em Portugol como parte do projeto prático do programa **Jovem Programador 2026**. O software foi projetado para auxiliar empresas no cumprimento da nova **Norma Regulamentadora nº 1 (NR1)**, oferecendo uma ferramenta estruturada para a **Avaliação Ergonômica Preliminar (AEP)** com foco no diagnóstico de riscos psicossociais no trabalho.

O sistema utiliza a metodologia internacionalmente reconhecida do **HSE (Health and Safety Executive)** para avaliar o clima organizacional e mapear fatores de estresse e sobrecarga em sete dimensões críticas de saúde coletiva.

---

## 👥 Equipe Desenvolvedora e Metadados

* **Curso:** Jovem Programador 2026 (Parceria SEPROSC / SENAC)
* **Projeto:** Projeto 2 - Sistema de Informação
* **Professor Orientador:** Anderson Doneda ([anderson.doneda@prof.sc.senac.br](https://www.google.com/search?q=mailto%3Aanderson.doneda%40prof.sc.senac.br))
* **Data de Entrega:** 30/06/2026
* **Desenvolvedores:**
* Eduardo Zanatta ([zanattamach@gmail.com](https://www.google.com/search?q=mailto%3Azanattamach%40gmail.com))
* Kevin Hmann ([kevin.hmann@gmail.com](https://www.google.com/search?q=mailto%3Akevin.hmann%40gmail.com))
* Priscila Castaldo ([pri1.castaldo@gmail.com](https://www.google.com/search?q=mailto%3Apri1.castaldo%40gmail.com))
* Victor Ferraz ([victorfontanaa@gmail.com](https://www.google.com/search?q=mailto%3Avictorfontanaa%40gmail.com))



---

## 🎯 Funcionalidades Principais

### 1. Controle de Acesso e Segurança (Níveis de Permissão)

O sistema conta com proteção de acesso através de login e senha, diferenciando o que cada perfil de usuário pode visualizar e operar:

* **Nível 1 (Visualização de Resultados):** Perfis como médicos do trabalho, líderes de setor e gestores de RH externos que necessitam apenas analisar dados consolidados e gerar relatórios, sem poder alterar cadastros da empresa.
* **Nível 2 (Acesso Total):** Administradores, ergonomistas e equipe interna de suporte que realizam configurações de setores, exclusões e cadastros de novos usuários.

### 2. Gestão de Setores (CRUD em Memória)

Permite gerenciar a estrutura física e funcional da empresa em tempo real:

* Cadastro do número total de colaboradores e distribuição proporcional por setor.
* Validação dinâmica para impedir que a soma de colaboradores alocados supere o total de funcionários cadastrados na empresa.
* Ferramentas completas de edição, adição e exclusão de setores diretamente na memória volátil do Portugol.

### 3. Proteção e Anonimato (Regra do $N$ Mínimo)

> **🛡️ Regra Ética de Proteção ao Trabalhador:** Para garantir o anonimato absoluto e a segurança psicológica dos respondentes, o sistema bloqueia relatórios de criticidade individuais para setores que possuam **menos de 5 funcionários cadastrados ou respondentes**. As respostas desses setores são computadas exclusivamente no relatório global da empresa.

### 4. Diagnóstico Psicossocial de 35 Questões (HSE)

O questionário é subdividido em 7 dimensões de risco ergonômico e organizacional:

1. **Demandas Ocupacionais:** Prazos, ritmo e sobrecarga.
2. **Controle e Autonomia:** Flexibilidade de rotina e processos de tomada de decisão.
3. **Suporte da Chefia:** Incentivo, feedbacks e canal aberto com a liderança.
4. **Suporte dos Colegas:** Cooperação, amabilidade e apoio mútuo na equipe.
5. **Relações Interpessoais:** Combate a atritos, assédio e isolamento.
6. **Clareza de Papel/Cargo:** Compreensão de objetivos e atribuições da função.
7. **Gestão de Mudanças:** Transparência de informações em transições de processos.

*O sistema realiza automaticamente a inversão de escala para perguntas formuladas de forma negativa (ex: prazos inalcançáveis, cobranças agressivas), garantindo precisão estatística na consolidação dos scores de 1 a 5.*

### 5. Algoritmo de Tomada de Decisão (Matriz de Criticidade)

A partir do score global do setor, o sistema calcula o nível de risco cruzando dados de **Probabilidade** e **Severidade**:

$$Criticidade = Probabilidade \times Severidade$$

A partir desse resultado, o software aciona fluxos operacionais automatizados:

* **🔴 Risco Crítico ou Extremo (Score $\ge 6$):** Alerta emergencial de adoecimento coletivo. Recomenda paralisação, notificação da medicina do trabalho e abertura imediata de **AET (Análise Ergonômica do Trabalho)**.
* **🟠 Risco Alto (Score $4$ ou $5$):** Priorização no Programa de Gerenciamento de Riscos (PGR) e adoção de medidas de controle imediatas.
* **🟡 Risco Médio (Score $3$):** Geração de planos de ação preventivos e monitoramento cíclico.
* **🟢 Risco Aceitável (Score $2$):** Manutenção das medidas existentes.
* **🔵 Risco Baixo (Score $1$):** Ambiente psicossocial saudável.

---

## 🛠️ Tecnologias Utilizadas

* **Linguagem:** Portugol (compatível com a IDE Portugol Studio).
* **Bibliotecas Nativas:**
* `Util`: Para controle de tempo e efeitos visuais no console (`u.aguarde`).
* `Tipos`: Para validações seguras de entrada de dados, conversões de strings para inteiros e tratamento de erros do usuário final (`t.cadeia_e_inteiro` e `t.cadeia_para_inteiro`).



---

## 🚀 Como Executar o Projeto

1. Faça o download do **[Portugol Studio](https://portugol.dev/)**.
2. Abra a IDE e crie um novo arquivo.
3. Copie o código do arquivo fonte do jogo/sistema e cole na área de desenvolvimento da IDE.
4. Clique no botão **Executar** (ou aperte `F9`).
5. **Credenciais de Acesso Padrão (Cadastrados na Inicialização):**

| Usuário | Senha | Nível de Acesso |
| --- | --- | --- |
| `admin` | `1234` | Nível 2 (Acesso Total) |
| `suporte` | `9878` | Nível 2 (Acesso Total) |
| `ergonomista` | `8868` | Nível 2 (Acesso Total) |
| `medico` | `4727` | Nível 1 (Apenas Resultados) |
| `lider` | `1202` | Nível 1 (Apenas Resultados) |