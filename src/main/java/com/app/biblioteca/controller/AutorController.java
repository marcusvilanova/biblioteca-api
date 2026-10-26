package com.app.biblioteca.controller;

import com.app.biblioteca.model.Autor;
import com.app.biblioteca.service.AutorService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/autores")
public class AutorController {

    @Autowired
    private AutorService autorService;

    // Lista todos os autores
    @GetMapping
    public List<Autor> listar() {
        return autorService.listarTodos();
    }

    // Busca um autor pelo ID
    @GetMapping("/{id}")
    public ResponseEntity<Autor> buscar(@PathVariable Long id) {
        Autor autor = autorService.buscarPorId(id);
        if (autor == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(autor);
    }

    // Cadastra um novo autor
    @PostMapping
    public ResponseEntity<Autor> cadastrar(@Valid @RequestBody Autor autor) {
        autor.setId(null);
        Autor salvo = autorService.salvar(autor);
        return ResponseEntity.status(HttpStatus.CREATED).body(salvo);
    }

    // Atualiza um autor que já existe
    @PutMapping("/{id}")
    public ResponseEntity<Autor> atualizar(@PathVariable Long id, @Valid @RequestBody Autor autor) {
        if (autorService.buscarPorId(id) == null) {
            return ResponseEntity.notFound().build();
        }
        autor.setId(id);
        return ResponseEntity.ok(autorService.salvar(autor));
    }

    // Remove um autor pelo ID
    @DeleteMapping("/{id}")
    public ResponseEntity<?> remover(@PathVariable Long id) {
        if (autorService.buscarPorId(id) == null) {
            return ResponseEntity.notFound().build();
        }
        try {
            autorService.remover(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        }
    }
}
