package br.fateczl.sistemanotas.service;

import br.fateczl.sistemanotas.model.dto.FaltasDto;
import br.fateczl.sistemanotas.model.entity.Aluno;
import br.fateczl.sistemanotas.model.entity.Disciplina;
import br.fateczl.sistemanotas.model.entity.Faltas;
import br.fateczl.sistemanotas.repository.AlunoRepository;
import br.fateczl.sistemanotas.repository.DisciplinaRepository;
import br.fateczl.sistemanotas.repository.FaltasRepository;
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
public class FaltasService {

    @Autowired
    private FaltasRepository faltasRepository;

    @Autowired
    private AlunoRepository alunoRepository;

    @Autowired
    private DisciplinaRepository disciplinaRepository;

    @Autowired
    private DataSource dataSource;

    public List<Faltas> listarFaltas() {
        return faltasRepository.findAll();
    }

    public void salvarFalta(FaltasDto faltasDto) {

        Optional<Aluno> aluno = alunoRepository.findById(faltasDto.getAluno());
        
        Optional<Disciplina> disciplina = disciplinaRepository.findById(faltasDto.getDisciplina());

        faltasRepository.save(new Faltas(aluno.get(), disciplina.get(), faltasDto.getPresenca()));
    }

    public List<Faltas> listarFaltasAluno(Long idAluno) {
        return faltasRepository.findAllByAluno(idAluno);
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
