package com.app.biblioteca.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class LivroTest {

    // Cria um livro só com o ano de publicação, que é o que a classificação usa
    private Livro criarLivro(int ano) {
        Livro livro = new Livro();
        livro.setTitulo("Livro de teste");
        livro.setAnoPublicacao(ano);
        return livro;
    }

    @Test
    void livroComMaisDeCinquentaAnosEhClassico() {
        Livro livro = criarLivro(1899);

        assertEquals("Clássico", livro.classificar(2026));
    }

    @Test
    void livroComExatamenteCinquentaAnosEhClassico() {
        Livro livro = criarLivro(1976);

        assertEquals("Clássico", livro.classificar(2026));
    }

    @Test
    void livroComMenosDeCinquentaAnosEhComum() {
        Livro livro = criarLivro(2010);

        assertEquals("Comum", livro.classificar(2026));
    }

    @Test
    void livroPublicadoHaDoisAnosOuMenosEhLancamento() {
        Livro livro = criarLivro(2025);

        assertEquals("Lançamento", livro.classificar(2026));
    }

    @Test
    void livroGuardaOAutor() {
        Livro livro = criarLivro(1990);
        livro.setAutor(new Autor("Jorge Amado", "Brasileira"));

        assertEquals("Jorge Amado", livro.getAutor().getNome());
    }
}
