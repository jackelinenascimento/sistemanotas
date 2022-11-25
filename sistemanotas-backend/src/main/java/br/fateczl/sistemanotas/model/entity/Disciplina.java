package br.fateczl.sistemanotas.model.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.*;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Disciplina {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "codigo",unique=true, nullable = false)
    private String codigo;

    @Column(name = "nome", nullable = false)
    private String nome;

    @Column(name = "sigla", nullable = false)
    private String sigla;

    @Column(name = "turno", nullable = false)
    private String turno;

    @Column(name = "num_aulas", nullable = false)
    private Integer numAulas;

    @JsonCreator
    public Disciplina(String codigo, String nome, String sigla, String turno, Integer numAulas) {
        this.codigo = codigo;
        this.nome = nome;
        this.sigla = sigla;
        this.turno = turno;
        this.numAulas = numAulas;
    }
}
