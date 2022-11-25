package br.fateczl.sistemanotas.model.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import javax.persistence.*;

@Getter
@Setter
@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Aluno {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long ra;

    @Column(name = "nome", nullable = false)
    private String nome;

    @JsonCreator
    public Aluno(@JsonProperty("nome") String nome) {
        this.nome = nome;
    }
}
