package br.fateczl.sistemanotas.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class NotasDto {

    @NotNull
    private Long aluno;

    @NotNull
    private Long disciplina;

    @NotNull
    private Long avaliacao;

    @NotNull
    private Long nota;
}
