package br.fateczl.sistemanotas.service;

import br.fateczl.sistemanotas.model.dto.FaltasDto;
import br.fateczl.sistemanotas.model.entity.Aluno;
import br.fateczl.sistemanotas.model.entity.Disciplina;
import br.fateczl.sistemanotas.model.entity.Faltas;
import br.fateczl.sistemanotas.repository.AlunoRepository;
import br.fateczl.sistemanotas.repository.DisciplinaRepository;
import br.fateczl.sistemanotas.repository.FaltasRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
public class FaltasService {

    @Autowired
    private FaltasRepository faltasRepository;

    @Autowired
    private AlunoRepository alunoRepository;

    @Autowired
    private DisciplinaRepository disciplinaRepository;

    public List<Faltas> listarFaltas() {
        return faltasRepository.findAll();
    }

    public void salvarFalta(FaltasDto faltasDto) {

        Optional<Aluno> aluno = alunoRepository.findById(faltasDto.getAluno());
        
        Optional<Disciplina> disciplina = disciplinaRepository.findById(faltasDto.getDisciplina());

<<<<<<< HEAD
        faltasRepository.save(new Faltas(aluno.get(), disciplina.get(), faltasDto.getPresenca()));
=======
        faltasRepository.save(new Faltas(aluno.get(), Collections.singletonList(disciplina.get()), faltasDto.getPresenca()));
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999

    }
}
