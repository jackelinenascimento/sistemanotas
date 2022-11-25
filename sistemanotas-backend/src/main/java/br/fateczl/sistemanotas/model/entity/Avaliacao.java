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
public class Avaliacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long codigo;

    private String tipo;

    @JsonCreator
    public Avaliacao(@JsonProperty("tipo") String tipo) {
        this.tipo = tipo;
    }
}
