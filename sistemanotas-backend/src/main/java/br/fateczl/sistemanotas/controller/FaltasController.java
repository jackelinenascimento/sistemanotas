package br.fateczl.sistemanotas.controller;

import br.fateczl.sistemanotas.model.dto.FaltasDto;
import br.fateczl.sistemanotas.model.entity.Faltas;
import br.fateczl.sistemanotas.service.FaltasService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*", allowedHeaders = "*")
@RequestMapping("/faltas")
public class FaltasController {

    @Autowired
    private FaltasService faltasService;

    @GetMapping
    public ResponseEntity<List<Faltas>> listarFaltas(){
        return new ResponseEntity<>(faltasService.listarFaltas(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<HttpStatus> salvarFalta(@RequestBody FaltasDto faltasDto){
        faltasService.salvarFalta(faltasDto);
        return new ResponseEntity(HttpStatus.CREATED);
    }

}
