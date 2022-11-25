package br.fateczl.sistemanotas.repository;

import br.fateczl.sistemanotas.model.entity.Avaliacao;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AvaliacaoRepository extends JpaRepository<Avaliacao, Long> {
}
