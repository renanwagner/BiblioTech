# BiblioTechDB - Sistema de Gestão de Biblioteca Universitária

Este repositório contém os scripts SQL para a criação e manipulação do banco de dados do Sistema de Gestão de Biblioteca Universitária (BiblioTech), desenvolvido como parte da disciplina de Modelagem de Banco de Dados.

## 📚 Visão Geral do Projeto

O BiblioTechDB é um sistema de banco de dados relacional projetado para gerenciar o acervo de uma biblioteca universitária, controlando usuários (alunos, professores, funcionários), itens do acervo (livros físicos, e-books, periódicos, teses), empréstimos, reservas, multas e notificações. O modelo foi normalizado até a 3ª Forma Normal para garantir a integridade e eficiência dos dados.

## ✨ Funcionalidades Principais

-   **Gestão de Usuários:** Cadastro e controle de diferentes perfis (Aluno, Professor, Funcionário).
-   **Gestão de Acervo:** Catalogação detalhada de diversos tipos de materiais.
-   **Empréstimos e Devoluções:** Controle completo do ciclo de empréstimos, incluindo renovações e prazos.
-   **Sistema de Reservas:** Fila de espera para itens indisponíveis e notificações automáticas.
-   **Controle de Multas e Bloqueios:** Cálculo automático de multas por atraso e bloqueio de usuários inadimplentes.
-   **Relatórios:** Base para geração de relatórios gerenciais sobre o uso da biblioteca.

## 🛠️ Tecnologias Utilizadas

-   **Sistema de Gerenciamento de Banco de Dados (SGBD):** MySQL 8.x (os scripts são compatíveis com PostgreSQL com pequenas adaptações para `AUTO_INCREMENT` para `SERIAL`).
-   **Ferramenta de Desenvolvimento:** MySQL Workbench (recomendado para execução dos scripts e visualização do DER).
-   **Versionamento de Código:** Git / GitHub.

## 🚀 Como Configurar e Executar o Projeto

Siga os passos abaixo para configurar o banco de dados e executar os scripts.

### Pré-requisitos

1.  **MySQL Server:** Certifique-se de ter o MySQL Server (versão 8.x ou superior) instalado e em execução.
2.  **MySQL Workbench:** Instale o MySQL Workbench para facilitar a conexão, execução de scripts e visualização do DER.

### Passo a Passo

1.  **Clone o Repositório:**
    git clone https://github.com/Renan/BiblioTechDB.git

2.  **Conecte-se ao MySQL Workbench:**
    *   Abra o MySQL Workbench.
    *   Crie ou use uma conexão existente para o seu servidor MySQL.

3.  **Execute o Script de Criação das Tabelas:**
    *   No MySQL Workbench, abra o arquivo `V001__criar_tabelas.sql`.
    *   Execute todo o script (clique no ícone de raio). Isso criará o banco de dados `BiblioTechDB` e todas as suas tabelas.
    *   Após a execução, clique com o botão direito sobre a seção `SCHEMAS` no painel Navigator e selecione `Refresh All` para ver o novo banco de dados.

4.  **Povoar o Banco de Dados com Dados de Exemplo:**
    *   Abra o arquivo `V002__inserir_dados.sql` no MySQL Workbench.
    *   Execute todo o script. Isso inserirá dados de exemplo em todas as tabelas, respeitando as dependências de chaves estrangeiras.

5.  **Executar Consultas (SELECT):**
    *   Abra o arquivo `V003__consultas.sql` no MySQL Workbench.
    *   Execute cada consulta individualmente para ver os resultados e entender como os dados são recuperados.

6.  **Executar Atualizações e Exclusões (UPDATE e DELETE)::**
    *   Abra o arquivo `V004__atualizacoes_deletar.sql` no MySQL Workbench.
    *   **ATENÇÃO:** Execute os comandos `UPDATE` e `DELETE` com cautela, um por um, e observe os resultados. Eles modificam e removem dados. O script inclui comentários explicando cada operação.

## 📊 Diagrama Entidade-Relacionamento (DER)

O diagrama lógico do banco de dados `BiblioTechDB` pode ser gerado diretamente no MySQL Workbench através da função de Engenharia Reversa (`Database > Reverse Engineer...`) após a criação das tabelas.

![DER_BiblioTechDB](docs/DER_BiblioTechDB.png)

## 🤝 Contribuição

Sinta-se à vontade para explorar, testar e sugerir melhorias.

