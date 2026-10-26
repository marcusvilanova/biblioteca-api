package com.app.biblioteca.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "autor")
public class Autor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "O nome do autor é obrigatório.")
    @Size(max = 100, message = "O nome do autor deve ter no máximo 100 caracteres.")
    private String nome;

    @NotBlank(message = "A nacionalidade do autor é obrigatória.")
    @Size(max = 50, message = "A nacionalidade deve ter no máximo 50 caracteres.")
    private String nacionalidade;

    public Autor() {
    }

    public Autor(String nome, String nacionalidade) {
        this.nome = nome;
        this.nacionalidade = nacionalidade;
    }

    // Monta um texto com o nome e a nacionalidade do autor
    public String apresentar() {
        return nome + " (" + nacionalidade + ")";
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getNacionalidade() {
        return nacionalidade;
    }

    public void setNacionalidade(String nacionalidade) {
        this.nacionalidade = nacionalidade;
    }
}
