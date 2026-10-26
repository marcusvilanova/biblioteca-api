package com.app.biblioteca.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

class AutorTest {

    @Test
    void apresentacaoMostraNomeENacionalidade() {
        Autor autor = new Autor("Machado de Assis", "Brasileira");

        assertEquals("Machado de Assis (Brasileira)", autor.apresentar());
    }

    @Test
    void autorNovoAindaNaoTemId() {
        Autor autor = new Autor("Clarice Lispector", "Brasileira");

        assertNull(autor.getId());
    }
}
