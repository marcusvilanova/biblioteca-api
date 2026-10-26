package com.app.biblioteca.service;

import com.app.biblioteca.model.Autor;
import com.app.biblioteca.repository.IAutorRepository;
import com.app.biblioteca.repository.ILivroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AutorService {

    @Autowired
    private IAutorRepository autorRepository;

    @Autowired
    private ILivroRepository livroRepository;

    // Retorna todos os autores
    public List<Autor> listarTodos() {
        return autorRepository.findAll();
    }

    // Busca um autor pelo ID (retorna null se não achar)
    public Autor buscarPorId(Long id) {
        return autorRepository.findById(id).orElse(null);
    }

    // Cria ou atualiza um autor
    public Autor salvar(Autor autor) {
        return autorRepository.save(autor);
    }

    // Remove um autor, mas só se ele não tiver livros
    public void remover(Long id) {
        if (livroRepository.existsByAutorId(id)) {
            throw new RuntimeException("O autor possui livros cadastrados. Remova os livros primeiro.");
        }
        autorRepository.deleteById(id);
    }
}
