package br.fateczl.sistemanotas.controller;

import br.fateczl.sistemanotas.model.entity.Avaliacao;
import br.fateczl.sistemanotas.service.AvaliacaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*", allowedHeaders = "*")
@RequestMapping("/avaliacoes")
public class AvaliacaoController {

    @Autowired
    private AvaliacaoService avaliacaoService;

    @GetMapping
    public ResponseEntity<List<Avaliacao>> listarAvaliacao(){
        return new ResponseEntity<>(avaliacaoService.listarAvaliacao(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<HttpStatus> salvarAvaliacao(@RequestBody Avaliacao avaliacao){
        avaliacaoService.salvarAvaliacao(avaliacao);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}
