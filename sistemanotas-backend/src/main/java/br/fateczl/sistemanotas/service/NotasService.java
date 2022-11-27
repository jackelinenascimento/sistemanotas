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
import net.sf.jasperreports.engine.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;

import javax.sql.DataSource;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    @Autowired
    private DataSource dataSource;

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

        if(disciplinaCodigo.contains("4203-010") || disciplinaCodigo.contains("4203-020") || disciplinaCodigo.contains("4208-010") || disciplinaCodigo.contains("4226-004")){
            if(avaliacaoTipo.contains("P1")){
                peso = 0.3;
            }
            if(avaliacaoTipo.contains("P2")){
                peso = 0.5;
            }
            if(avaliacaoTipo.contains("T")){
                peso = 0.2;
            }
            if(avaliacaoTipo.contains("P3")){
                peso = 0.5;
            }
        }

        if(disciplinaCodigo.contains("4213-003") || disciplinaCodigo.contains("4213-013")){
            if(avaliacaoTipo.contains("P1")){
                peso = 0.35;
            }
            if(avaliacaoTipo.contains("P2")){
                peso = 0.35;
            }
            if(avaliacaoTipo.contains("P3")){
                peso = 0.3;
            }
            if(avaliacaoTipo.contains("P4")){
                peso = 0.5;
            }
        }

        if(disciplinaCodigo.contains("4233-005")){
            if(avaliacaoTipo.contains("P1")){
                peso = 0.333;
            }
            if(avaliacaoTipo.contains("P2")){
                peso = 0.333;
            }
            if(avaliacaoTipo.contains("P3")){
                peso = 0.333;
            }
            if(avaliacaoTipo.contains("P4")){
                peso = 0.5;
            }
        }

        if(disciplinaCodigo.contains("5005-220")){
            if(avaliacaoTipo.contains("M")){
                peso = 0.8;
            }
            if(avaliacaoTipo.contains("MR")){
                peso = 0.2;
            }
            if(avaliacaoTipo.contains("P3")){
                peso = 0.5;
            }
        }

        return peso;
    }

    public void exportRelatorio(String codigoDisciplina, OutputStream os) throws JRException {

        Disciplina disc = disciplinaRepository.findByCodigo(codigoDisciplina);
        getExportManager(codigoDisciplina, disc.getNome(), os);
        
    }

    private void getExportManager(String codigoDisciplina, String nomeDisciplina, OutputStream os) throws JRException {

        JasperPrint jasperPrint = getJasperPrint(codigoDisciplina, nomeDisciplina);
        JasperExportManager.exportReportToPdfStream(jasperPrint, os);

    }

    private JasperPrint getJasperPrint(String codigoDisciplina, String nomeDisciplina) {

        try {
            Connection connection = dataSource.getConnection();

            File file = ResourceUtils.getFile("classpath:relatorioUDFNota.jrxml");

            JasperReport jasperReport = JasperCompileManager.compileReport(file.getAbsolutePath());

            Map<String, Object> parameters = new HashMap<>();
            parameters.put("codDisc", codigoDisciplina);
            parameters.put("nomeDisc", nomeDisciplina);

            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);
            return jasperPrint;

        } catch (FileNotFoundException | JRException | SQLException e) {
            System.err.println(e.getStackTrace());
            return null;
        }

    }
}
