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
public class Notas {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    private Aluno aluno;

    @OneToOne
    private Disciplina disciplina;

    @OneToOne
    private Avaliacao avaliacao;

    private Long nota;

    private Double peso;

    @JsonCreator
    public Notas(Aluno aluno, Disciplina disciplina, Avaliacao avaliacao, Long nota, Double peso){
        this.aluno = aluno;
        this.disciplina = disciplina;
        this.avaliacao = avaliacao;
        this.nota = nota;
        this.peso = peso;
    }
}
