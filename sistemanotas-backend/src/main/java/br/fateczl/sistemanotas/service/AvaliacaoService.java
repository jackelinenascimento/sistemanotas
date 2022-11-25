package br.fateczl.sistemanotas.service;

import br.fateczl.sistemanotas.model.entity.Avaliacao;
import br.fateczl.sistemanotas.repository.AvaliacaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AvaliacaoService {

    @Autowired
    private AvaliacaoRepository avaliacaoRepository;

    public List<Avaliacao> listarAvaliacao() {
        return  avaliacaoRepository.findAll();
    }

    public void salvarAvaliacao(Avaliacao avaliacao){
        avaliacaoRepository.save(new Avaliacao(avaliacao.getTipo()));
    }
}
