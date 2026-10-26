# API Biblioteca

API REST para cadastrar autores e livros. Trabalho do 3º Checkpoint de DevOps Tools & Cloud Computing (FIAP).

O projeto foi migrado para o Azure DevOps (Boards, Repos e Pipelines) e roda na Azure com um Web App e um Banco SQL (PaaS).

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

O livro também mostra a `classificacao`, que é calculada pelo ano de publicação.

Os JSONs para testar estão na pasta `json` e os comandos curl estão em `json/comandos-curl.txt`.

## Variáveis de ambiente

A aplicação não tem senha no código. Ela lê o banco destas variáveis:

- SPRING_DATASOURCE_URL
- SPRING_DATASOURCE_USERNAME
- SPRING_DATASOURCE_PASSWORD

## Infra na Azure

Os recursos são criados por scripts da pasta `infra` (rodar no Cloud Shell, em Bash):

1. `01-criar-banco.sh` cria o grupo de recursos, o servidor SQL, o banco e as tabelas
2. `02-criar-webapp.sh` cria o plano, o Web App e configura as variáveis de ambiente
3. `03-excluir-recursos.sh` apaga tudo no final

Os scripts perguntam a senha do SQL na hora de rodar.

## Pipelines

- CI: compila com Maven, roda os testes JUnit e publica o JAR
- CD (Release): publica o JAR no Web App

Para rodar os testes na máquina: `mvn clean package`
