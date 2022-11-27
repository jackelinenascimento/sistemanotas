package br.fateczl.sistemanotas.repository;

import br.fateczl.sistemanotas.model.entity.Faltas;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FaltasRepository extends JpaRepository<Faltas, Long> {
    List<Faltas> findAllByAluno(Long idAluno);

}
