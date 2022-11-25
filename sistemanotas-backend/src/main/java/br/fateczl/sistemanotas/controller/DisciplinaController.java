package br.fateczl.sistemanotas.controller;

import br.fateczl.sistemanotas.model.entity.Disciplina;
import br.fateczl.sistemanotas.service.DisciplinaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*", allowedHeaders = "*")
@RequestMapping("/disciplinas")
public class DisciplinaController {

    @Autowired
    private DisciplinaService disciplinaService;

    @GetMapping
    public ResponseEntity<List<Disciplina>> listarDisciplinas(){
        return new ResponseEntity<>(disciplinaService.listarDisciplinas(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<HttpStatus> salvarDisciplina(@RequestBody Disciplina disciplina){
        disciplinaService.salvarDisciplina(disciplina);
        return new ResponseEntity(HttpStatus.CREATED);
    }

}
