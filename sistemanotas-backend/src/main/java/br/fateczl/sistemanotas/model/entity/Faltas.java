package br.fateczl.sistemanotas.model.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Faltas {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    private Aluno aluno;

    @OneToOne
    private Disciplina disciplina;

    private LocalDate data = LocalDate.now();

    private Long presenca;

    @JsonCreator
    public Faltas(Aluno aluno, Disciplina disciplina, Long presenca){
        this.aluno = aluno;
        this.disciplina = disciplina;
        this.presenca = presenca;
    }
}
