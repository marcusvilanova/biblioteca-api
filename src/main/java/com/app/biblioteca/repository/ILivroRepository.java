package com.app.biblioteca.repository;

import com.app.biblioteca.model.Livro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ILivroRepository extends JpaRepository<Livro, Long> {

    // Verifica se o autor já tem algum livro cadastrado
    boolean existsByAutorId(Long autorId);
}
