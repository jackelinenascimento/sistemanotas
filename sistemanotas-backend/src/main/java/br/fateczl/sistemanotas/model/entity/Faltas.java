package br.fateczl.sistemanotas.model.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;
<<<<<<< HEAD
=======
import java.util.ArrayList;
import java.util.List;
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999

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

<<<<<<< HEAD
    @OneToOne
    private Aluno aluno;

    @OneToOne
    private Disciplina disciplina;
=======
    @ManyToOne
    private Aluno aluno;

    @ManyToMany(fetch = FetchType.EAGER)
    private List<Disciplina> disciplina = new ArrayList<>();
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999

    private LocalDate data = LocalDate.now();

    private Long presenca;

    @JsonCreator
<<<<<<< HEAD
    public Faltas(Aluno aluno, Disciplina disciplina, Long presenca){
=======
    public Faltas(Aluno aluno, List<Disciplina> disciplina, Long presenca){
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999
        this.aluno = aluno;
        this.disciplina = disciplina;
        this.presenca = presenca;
    }
}
