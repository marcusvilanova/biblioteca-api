# API Biblioteca

API REST para cadastrar autores e livros. Trabalho do 3º Checkpoint de DevOps Tools & Cloud Computing (FIAP).

O projeto foi migrado para o Azure DevOps (Boards, Repos e Pipelines) e roda na Azure com um Web App e um Banco SQL (PaaS).

## Integrantes

| Nome | RM |
| --- | --- |
| Bruno Ferreira | 563489 |
| Hebert Lopes do Santos | 563192 |
| Nicolas Monteiro Ramiro | 562380 |
| Marcus Vinícius Vila Nova da Silva | 558771 |
| Gabriel Robertoni Padilha | 566293 |

Projeto no Azure DevOps: https://dev.azure.com/RM562380/Biblioteca

## Tecnologias

- Java 17
- Spring Boot 3.3 (Web, Data JPA e Validation)
- Maven e JUnit 5
- Azure SQL Database
- Azure App Service (Linux)

## Tabelas

- `autor` (id, nome, nacionalidade)
- `livro` (id, titulo, ano_publicacao, autor_id)

Um autor pode ter vários livros. O `autor_id` é a chave estrangeira para a tabela `autor`. O DDL está no arquivo `script.sql`.

## Rotas

| Método | Rota | O que faz |
| --- | --- | --- |
| GET | /api/autores | lista os autores |
| GET | /api/autores/{id} | busca um autor |
| POST | /api/autores | cadastra um autor |
| PUT | /api/autores/{id} | atualiza um autor |
| DELETE | /api/autores/{id} | remove um autor (só se ele não tiver livros) |
| GET | /api/livros | lista os livros |
| GET | /api/livros/{id} | busca um livro |
| POST | /api/livros | cadastra um livro (informar o id do autor) |
| PUT | /api/livros/{id} | atualiza um livro |
| DELETE | /api/livros/{id} | remove um livro |

O livro também mostra a `classificacao`, calculada pelo ano de publicação: `Lançamento` (até 2 anos), `Clássico` (50 anos ou mais) e `Comum` (o resto).

## Variáveis de ambiente

A aplicação não tem senha no código. Ela lê o banco destas variáveis:

- SPRING_DATASOURCE_URL
- SPRING_DATASOURCE_USERNAME
- SPRING_DATASOURCE_PASSWORD

## O que tem no repositório

- `src`: código da API e testes JUnit
- `script.sql`: DDL das tabelas
- `infra`: scripts da Azure CLI (`01-criar-banco.sh`, `02-criar-webapp.sh` e `03-excluir-recursos.sh`)
- `json`: JSONs do CRUD e os comandos curl (`comandos-curl.txt`)
- `azure-pipelines.yml`: pipeline de CI (Maven, testes e publicação do JAR)
- `azure-pipelines-cd.yml`: pipeline de CD (deploy do JAR no Web App)

## Passo a passo

Antes de começar você precisa de uma assinatura da Azure, de uma organização no Azure DevOps e do Cloud Shell (Bash) aberto no Portal. Onde aparecer `rm562380` ou `RM562380`, troque pelo seu RM.

### 1. Projeto e Task (Azure Boards)

1. Crie o projeto no Azure DevOps com Git e o processo Agile.
2. Em Boards, crie a Task `Implementar API Biblioteca no Azure Devops`, atribua ao seu usuário e mude o estado para `Active`.

### 2. Repositório e políticas (Azure Repos)

1. Em Repos, use Import repository com o endereço deste repositório do GitHub.
2. Abra a Task e, em Development, clique em Create a branch (aqui foi `livro-lancamento`).
3. Proteja a `main` em Branch policies: mínimo de 1 revisor, Work Item obrigatório e um revisor padrão (o seu RM). Deixe permitido que quem abriu o PR aprove o próprio PR.

### 3. Infraestrutura na Azure (Cloud Shell, Bash)

1. Clone o repositório do Azure Repos no Cloud Shell e entre na pasta.
2. Abra os scripts da pasta `infra` e confira as variáveis do começo (`RM` e `LOCATION`). Use uma região que a sua assinatura permita.
3. Rode `bash infra/01-criar-banco.sh`. Ele cria o grupo de recursos, o servidor SQL, o banco `db-biblioteca`, a regra de firewall e as tabelas do `script.sql`. A senha do SQL é pedida na hora (ou vem da variável `SQL_SENHA`) e não fica salva em arquivo.
4. Rode `bash infra/02-criar-webapp.sh`. Ele cria o plano, o Web App (Java 17) e as variáveis `SPRING_DATASOURCE_*` nas configurações do Web App.
5. No Portal, confira se o grupo `rg-biblioteca-api` tem o plano, o Web App, o servidor SQL e o banco.

### 4. Conexão com a Azure e pipelines (Azure Pipelines)

1. Em Project settings > Service connections, crie uma conexão Azure Resource Manager chamada `MyAzureSubscription`, apontando para o grupo `rg-biblioteca-api`.
2. Em Pipelines > New pipeline > Azure Repos Git > Existing Azure Pipelines YAML file, escolha `/azure-pipelines.yml` e salve com o nome `Biblioteca-CI`.
3. Crie o segundo pipeline com `/azure-pipelines-cd.yml` e o nome `Biblioteca-CD`. O CI precisa se chamar exatamente `Biblioteca-CI`, porque é ele que dispara o CD.
4. Rode o CI à mão (Run pipeline) e veja os testes na aba Tests. Depois rode o CD à mão. Na primeira vez o Azure DevOps pode pedir permissão para usar a conexão e o ambiente: clique em Permit.

### 5. Passo 06: alterar o código e abrir o PR

1. Na branch da Task, altere o código e um teste direto no Repos (aqui foi a regra `Lançamento` em `Livro.java` e o teste novo em `LivroTest.java`). A mudança tem que ser de código, não do README.
2. Faça o commit com `#<número da Task>` na mensagem.
3. Abra um Pull Request da branch para a `main`. O Work Item e o revisor padrão entram sozinhos. Aprove e conclua com Complete.
4. Na tela de conclusão marque `Complete associated work items after merging` e não marque `Delete branch after merging`. A Task fecha sozinha.

### 6. Passo 07: pipelines automáticos

1. O merge na `main` dispara o CI. Quando o CI termina, o CD dispara sozinho e entrega o JAR no Web App.
2. Abra o log de cada tarefa dos dois pipelines e a aba Tests do CI.

### 7. Testar o CRUD na nuvem

1. No Cloud Shell, entre na pasta do repositório e rode os comandos de `json/comandos-curl.txt`: primeiro o autor, depois o livro e por fim os DELETE. O autor só pode ser removido depois que os livros dele saírem (senão a API responde 409).
2. Depois de cada operação, confira o banco com um SELECT, por exemplo:

```bash
export SQL_SENHA='<senha do administrador do SQL>'
pwsh -NoProfile -Command "Invoke-Sqlcmd -ServerInstance 'sql-biblioteca-rm562380-centralus.database.windows.net' -Database 'db-biblioteca' -Username 'user-biblioteca' -Password \$env:SQL_SENHA -Query 'SELECT * FROM autor' | Format-Table"
```

Troque a tabela e o nome do servidor quando precisar. O Editor de consultas do Portal também serve.

### 8. Entrega

1. Inclua o professor no projeto: Organization settings > Users > Add users, com acesso Basic, projeto `Biblioteca` e os grupos Project Administrators e Contributors.
2. Grave o vídeo dos passos 06 e 07, do CRUD e dos SELECTs, explicando o que aparece.
3. Gere o PDF `<nomeGrupo>_pipelines.pdf` (folha de rosto com nome do grupo, RM e nome de todos, link do projeto e link do YouTube) e envie pelo Teams. Só o representante do grupo faz o envio.
4. Só depois da correção rode `bash infra/03-excluir-recursos.sh` para apagar os recursos da Azure.

## Rodar os testes na máquina

`mvn clean package`
