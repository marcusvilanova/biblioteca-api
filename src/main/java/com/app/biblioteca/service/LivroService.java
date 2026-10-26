package com.app.biblioteca.service;

import com.app.biblioteca.model.Autor;
import com.app.biblioteca.model.Livro;
import com.app.biblioteca.repository.IAutorRepository;
import com.app.biblioteca.repository.ILivroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LivroService {

    @Autowired
    private ILivroRepository livroRepository;

    @Autowired
    private IAutorRepository autorRepository;

    // Retorna todos os livros
    public List<Livro> listarTodos() {
        return livroRepository.findAll();
    }

    // Busca um livro pelo ID (retorna null se não achar)
    public Livro buscarPorId(Long id) {
        return livroRepository.findById(id).orElse(null);
    }

    // Cria ou atualiza um livro. O autor precisa existir no banco
    public Livro salvar(Livro livro) {
        Autor autor = null;
        if (livro.getAutor().getId() != null) {
            autor = autorRepository.findById(livro.getAutor().getId()).orElse(null);
        }
        if (autor == null) {
            throw new RuntimeException("Autor não encontrado. Cadastre o autor antes do livro.");
        }
        livro.setAutor(autor);
        return livroRepository.save(livro);
    }

    // Remove um livro pelo ID
    public void remover(Long id) {
        livroRepository.deleteById(id);
    }
}
