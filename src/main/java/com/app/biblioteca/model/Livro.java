package com.app.biblioteca.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;

@Entity
@Table(name = "livro")
public class Livro {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "O título do livro é obrigatório.")
    @Size(max = 150, message = "O título deve ter no máximo 150 caracteres.")
    private String titulo;

    @Min(value = 1, message = "O ano de publicação deve ser maior que zero.")
    private int anoPublicacao;

    // Muitos livros para um autor (chave estrangeira autor_id)
    @NotNull(message = "O autor é obrigatório.")
    @ManyToOne
    @JoinColumn(name = "autor_id")
    private Autor autor;

    // Classifica o livro pela idade dele (ano atual menos o ano de publicação)
    public String classificar(int anoAtual) {
        int idade = anoAtual - anoPublicacao;
        if (idade <= 2) {
            return "Lançamento";
        }
        if (idade >= 50) {
            return "Clássico";
        }
        return "Comum";
    }

    // Esse getter faz a classificação aparecer no JSON do livro
    public String getClassificacao() {
        return classificar(LocalDate.now().getYear());
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public int getAnoPublicacao() {
        return anoPublicacao;
    }

    public void setAnoPublicacao(int anoPublicacao) {
        this.anoPublicacao = anoPublicacao;
    }

    public Autor getAutor() {
        return autor;
    }

    public void setAutor(Autor autor) {
        this.autor = autor;
    }
}
