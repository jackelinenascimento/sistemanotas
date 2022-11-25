package br.fateczl.sistemanotas.service;

import br.fateczl.sistemanotas.model.entity.Aluno;
import br.fateczl.sistemanotas.repository.AlunoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AlunoService {

    @Autowired
    private AlunoRepository alunoRepository;

    public List<Aluno> listarAlunos() {
        return alunoRepository.findAll();
    }

    public void salvarAluno(Aluno aluno){
        alunoRepository.save(new Aluno(aluno.getNome()));
    }
}
