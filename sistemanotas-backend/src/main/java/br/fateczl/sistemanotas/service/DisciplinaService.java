package br.fateczl.sistemanotas.service;

import br.fateczl.sistemanotas.model.entity.Disciplina;
import br.fateczl.sistemanotas.repository.DisciplinaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DisciplinaService {

    @Autowired
    private DisciplinaRepository disciplinaRepository;

    public List<Disciplina> listarDisciplinas() {
        return disciplinaRepository.findAll();
    }

    public void salvarDisciplina(Disciplina disciplina) {

        disciplinaRepository.save(new Disciplina(disciplina.getCodigo(),
                                                 disciplina.getNome(),
                                                 disciplina.getSigla(),
                                                 disciplina.getTurno(),
                                                 disciplina.getNumAulas()));
    }
}
