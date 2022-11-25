package br.fateczl.sistemanotas.repository;

import br.fateczl.sistemanotas.model.entity.Notas;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface NotasRepository extends JpaRepository<Notas, Long> {

//    @Query(nativeQuery = true, value = "SELECT DBO.fn_MASK_CARD(:text)")
//    String callMaskCard(@Param("text") String text);
}
