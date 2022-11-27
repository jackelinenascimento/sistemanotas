package br.fateczl.sistemanotas.controller;

import br.fateczl.sistemanotas.model.dto.NotasDto;
import br.fateczl.sistemanotas.model.entity.Notas;
import br.fateczl.sistemanotas.service.NotasService;
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
@RequestMapping("/notas")
public class NotasController {

    @Autowired
    private NotasService notasService;

    @GetMapping
    public ResponseEntity<List<Notas>> listarNotas(){
        return new ResponseEntity<>(notasService.listarNotas(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<HttpStatus> salvarNota(@RequestBody NotasDto notasDto){
        notasService.salvarFalta(notasDto);
        return new ResponseEntity(HttpStatus.CREATED);
    }

    @GetMapping("/relatorio/{codigoDisciplina}")
    public void getRelatorio(HttpServletResponse response, @PathVariable String codigoDisciplina){
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", String.format("inline; filename=\"RelatorioNotasTurma.pdf\""));
        try {
            OutputStream out = response.getOutputStream();
            notasService.exportRelatorio(codigoDisciplina, out);

            System.out.println(out.toString());

        } catch (JRException | IOException e) {
            System.out.println(e.getMessage());
        }
    }

}
