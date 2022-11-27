package br.fateczl.sistemanotas.controller;

import br.fateczl.sistemanotas.model.dto.FaltasDto;
import br.fateczl.sistemanotas.model.entity.Faltas;
import br.fateczl.sistemanotas.service.FaltasService;
import net.sf.jasperreports.engine.JRException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
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

    @GetMapping("/{id}")
    public ResponseEntity<List<Faltas>> listarFaltasAluno(Long id){
        return new ResponseEntity<>(faltasService.listarFaltasAluno(id), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<HttpStatus> salvarFalta(@RequestBody FaltasDto faltasDto){
        faltasService.salvarFalta(faltasDto);
        return new ResponseEntity(HttpStatus.CREATED);
    }

    @GetMapping("/relatorio/{codigoDisciplina}")
    public void getRelatorio(HttpServletResponse response, @PathVariable String codigoDisciplina){
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", String.format("inline; filename=\"RelatorioFaltaTurma.pdf\""));
        try {
            OutputStream out = response.getOutputStream();
            faltasService.exportRelatorio(codigoDisciplina, out);

            System.out.println(out.toString());

        } catch (JRException | IOException e) {
            System.out.println(e.getMessage());
        }
    }

}
