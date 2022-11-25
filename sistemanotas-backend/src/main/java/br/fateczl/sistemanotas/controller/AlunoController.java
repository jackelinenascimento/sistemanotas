package br.fateczl.sistemanotas.controller;

import br.fateczl.sistemanotas.model.entity.Aluno;
import br.fateczl.sistemanotas.service.AlunoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*", allowedHeaders = "*")
@RequestMapping("/alunos")
public class AlunoController {

    @Autowired
    private AlunoService alunoService;

    @GetMapping
    public ResponseEntity<List<Aluno>> listarAlunos(){
        return new ResponseEntity<>(alunoService.listarAlunos(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<HttpStatus> salvarAluno(@RequestBody Aluno aluno){
        alunoService.salvarAluno(aluno);
        return new ResponseEntity(HttpStatus.CREATED);
    }

}
