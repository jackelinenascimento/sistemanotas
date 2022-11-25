package br.fateczl.sistemanotas.model.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.*;

import javax.persistence.*;
<<<<<<< HEAD
=======
import java.util.List;
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999

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

<<<<<<< HEAD
    @OneToOne
    private Aluno aluno;

    @OneToOne
    private Disciplina disciplina;

    @OneToOne
    private Avaliacao avaliacao;
=======
    @ManyToOne
    private Aluno aluno;

    @ManyToMany
    private List<Disciplina> disciplina;

    @ManyToMany
    private List<Avaliacao> avaliacao;
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999

    private Long nota;

    @JsonCreator
<<<<<<< HEAD
    public Notas(Aluno aluno, Disciplina disciplina, Avaliacao avaliacao, Long nota){
=======
    public Notas(Aluno aluno, List<Disciplina> disciplina, List<Avaliacao> avaliacao, Long nota){
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999
        this.aluno = aluno;
        this.disciplina = disciplina;
        this.avaliacao = avaliacao;
        this.nota = nota;
    }
}
