package br.fateczl.sistemanotas.repository;

import br.fateczl.sistemanotas.model.entity.Aluno;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AlunoRepository extends JpaRepository<Aluno, Long> {
}
