/*

Banco de dados da API Biblioteca (Azure SQL Database)

Tabelas: autor e livro
Relacionamento: um autor pode ter varios livros (livro.autor_id -> autor.id)

Esse script e executado pelo infra/01-criar-banco.sh logo depois de criar o banco.
Ele so cria a tabela se ela ainda nao existir, entao pode rodar mais de uma vez.

*/

-- Tabela AUTOR
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'autor' AND xtype = 'U')
BEGIN
  CREATE TABLE autor (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50) NOT NULL
  );
END;

-- Tabela LIVRO (autor_id e a chave estrangeira para AUTOR)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'livro' AND xtype = 'U')
BEGIN
  CREATE TABLE livro (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    ano_publicacao INT NOT NULL,
    autor_id BIGINT NOT NULL,
    CONSTRAINT FK_livro_autor FOREIGN KEY (autor_id) REFERENCES autor(id)
  );
END;

-- Consultas usadas para conferir os dados depois de cada operacao da API
-- SELECT * FROM autor;
-- SELECT * FROM livro;
-- SELECT l.id, l.titulo, l.ano_publicacao, a.nome AS autor FROM livro l JOIN autor a ON a.id = l.autor_id;
