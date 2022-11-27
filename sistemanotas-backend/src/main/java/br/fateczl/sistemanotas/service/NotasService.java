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

        Double peso = calculaPeso(disciplina, avaliacao);

        notasRepository.save(new Notas(
                aluno.get(),
                disciplina.get(),
                avaliacao.get(),
                notasDto.getNota(),
                peso
        ));
    }

    private Double calculaPeso(Optional<Disciplina> disciplina, Optional<Avaliacao> avaliacao) {

        Double peso = 0.0;

        String disciplinaCodigo = disciplina.get().getCodigo();
        String avaliacaoTipo = avaliacao.get().getTipo();

        if(disciplinaCodigo == "4203-010" || disciplinaCodigo == "4203-020" || disciplinaCodigo == "4208-010" || disciplinaCodigo == "4226-004"){
            if(avaliacaoTipo == "P1"){
                peso = 0.3;
            }
            if(avaliacaoTipo == "P2"){
                peso = 0.5;
            }
            if(avaliacaoTipo == "T"){
                peso = 0.2;
            }
            if(avaliacaoTipo == "P3"){
                peso = 0.5;
            }
        }

        if(disciplinaCodigo == "4213-003" || disciplinaCodigo == "4213-013"){
            if(avaliacaoTipo == "P1"){
                peso = 0.35;
            }
            if(avaliacaoTipo == "P2"){
                peso = 0.35;
            }
            if(avaliacaoTipo == "P3"){
                peso = 0.3;
            }
            if(avaliacaoTipo == "P4"){
                peso = 0.5;
            }
        }

        if(disciplinaCodigo == "4233-005"){
            if(avaliacaoTipo == "P1"){
                peso = 0.333;
            }
            if(avaliacaoTipo == "P2"){
                peso = 0.333;
            }
            if(avaliacaoTipo == "P3"){
                peso = 0.333;
            }
            if(avaliacaoTipo == "P4"){
                peso = 0.5;
            }
        }

        if(disciplinaCodigo == "5005-220"){
            if(avaliacaoTipo == "M"){
                peso = 0.8;
            }
            if(avaliacaoTipo == "MR"){
                peso = 0.2;
            }
            if(avaliacaoTipo == "P3"){
                peso = 0.5;
            }
        }

        return peso;
    }
}
