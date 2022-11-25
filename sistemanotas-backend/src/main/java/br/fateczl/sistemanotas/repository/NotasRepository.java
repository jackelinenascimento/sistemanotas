package br.fateczl.sistemanotas.repository;

import br.fateczl.sistemanotas.model.entity.Notas;
import org.springframework.data.jpa.repository.JpaRepository;
<<<<<<< HEAD
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface NotasRepository extends JpaRepository<Notas, Long> {

    @Query(nativeQuery = true, value = "SELECT DBO.fn_MASK_CARD(:text)")
    String callMaskCard(@Param("text") String text);
=======

public interface NotasRepository extends JpaRepository<Notas, Long> {
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999
}
