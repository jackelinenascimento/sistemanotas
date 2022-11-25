package br.fateczl.sistemanotas.service;

import br.fateczl.sistemanotas.model.dto.NotasDto;
import br.fateczl.sistemanotas.model.entity.Aluno;
import br.fateczl.sistemanotas.model.entity.Avaliacao;
import br.fateczl.sistemanotas.model.entity.Disciplina;
import br.fateczl.sistemanotas.model.entity.Notas;
import br.fateczl.sistemanotas.repository.AlunoRepository;
import br.fateczl.sistemanotas.repository.AvaliacaoRepository;
import br.fateczl.sistemanotas.repository.DisciplinaRepository;
import br.fateczl.sistemanotas.repository.NotasRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NotasService {

    @Autowired
    private NotasRepository notasRepository;

    @Autowired
    private AlunoRepository alunoRepository;

    @Autowired
    private DisciplinaRepository disciplinaRepository;

    @Autowired
    private AvaliacaoRepository avaliacaoRepository;

    public List<Notas> listarNotas() {
        return notasRepository.findAll();
    }

    public void salvarFalta(NotasDto notasDto) {

        Optional<Aluno> aluno = alunoRepository.findById(notasDto.getAluno());

        Optional<Disciplina> disciplina = disciplinaRepository.findById(notasDto.getDisciplina());

        Optional<Avaliacao> avaliacao = avaliacaoRepository.findById(notasDto.getAvaliacao());

        notasRepository.save(new Notas(
                aluno.get(),
                disciplina.get(),
                avaliacao.get(),
                notasDto.getNota()
        ));
    }
}
