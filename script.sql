/*
  Banco da API Biblioteca (Azure SQL Database)

  Tabelas: autor e livro. Um autor pode ter varios livros (livro.autor_id aponta para autor.id).
  O infra/01-criar-banco.sh roda este arquivo logo depois de criar o banco.
  Cada tabela so e criada se ainda nao existir, entao o script pode rodar mais de uma vez.
*/

-- autor
IF OBJECT_ID(N'dbo.autor', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.autor (
        id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        nacionalidade VARCHAR(50) NOT NULL
    );
END;

-- livro (autor_id e a chave estrangeira para autor)
IF OBJECT_ID(N'dbo.livro', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.livro (
        id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        titulo VARCHAR(150) NOT NULL,
        ano_publicacao INT NOT NULL,
        autor_id BIGINT NOT NULL,
        CONSTRAINT FK_livro_autor FOREIGN KEY (autor_id) REFERENCES dbo.autor (id)
    );
END;

-- Para conferir os dados depois de cada operacao da API:
-- SELECT * FROM autor;
-- SELECT * FROM livro;
-- SELECT l.id, l.titulo, l.ano_publicacao, a.nome AS autor FROM livro l JOIN autor a ON a.id = l.autor_id;