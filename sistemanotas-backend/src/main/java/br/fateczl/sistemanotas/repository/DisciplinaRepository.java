package br.fateczl.sistemanotas.repository;

import br.fateczl.sistemanotas.model.entity.Disciplina;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DisciplinaRepository extends JpaRepository<Disciplina, Long> {
}
