package com.app.biblioteca.controller;

import com.app.biblioteca.model.Livro;
import com.app.biblioteca.service.LivroService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/livros")
public class LivroController {

    @Autowired
    private LivroService livroService;

    // Lista todos os livros
    @GetMapping
    public List<Livro> listar() {
        return livroService.listarTodos();
    }

    // Busca um livro pelo ID
    @GetMapping("/{id}")
    public ResponseEntity<Livro> buscar(@PathVariable Long id) {
        Livro livro = livroService.buscarPorId(id);
        if (livro == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(livro);
    }

    // Cadastra um novo livro (o JSON precisa informar o id do autor)
    @PostMapping
    public ResponseEntity<?> cadastrar(@Valid @RequestBody Livro livro) {
        livro.setId(null);
        try {
            Livro salvo = livroService.salvar(livro);
            return ResponseEntity.status(HttpStatus.CREATED).body(salvo);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Atualiza um livro que já existe
    @PutMapping("/{id}")
    public ResponseEntity<?> atualizar(@PathVariable Long id, @Valid @RequestBody Livro livro) {
        if (livroService.buscarPorId(id) == null) {
            return ResponseEntity.notFound().build();
        }
        livro.setId(id);
        try {
            return ResponseEntity.ok(livroService.salvar(livro));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Remove um livro pelo ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> remover(@PathVariable Long id) {
        if (livroService.buscarPorId(id) == null) {
            return ResponseEntity.notFound().build();
        }
        livroService.remover(id);
        return ResponseEntity.noContent().build();
    }
}
