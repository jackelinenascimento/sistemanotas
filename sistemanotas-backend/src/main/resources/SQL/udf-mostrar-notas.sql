CREATE FUNCTION fn_selectNotas(@disciplina_id INT)
RETURNS @table TABLE(
aluno_ra INT,
nome_aluno VARCHAR(100),
disciplina VARCHAR(50), -- Para mostrar no relatorio do jasper
turno VARCHAR(10), -- Para mostrar no relatorio do jasper
nota1 DECIMAL(7,2),
nota2 DECIMAL(7,2),
nota3 DECIMAL(7,2),
pre_exame DECIMAL(7,2),
nota4 DECIMAL(7,2),
media DECIMAL(7,2),
situacao VARCHAR(20)
)
AS
BEGIN
	DECLARE @aluno_ra INT,
		@nome_aluno VARCHAR(100),
		@disciplina VARCHAR(50),
		@turno VARCHAR(10),
		@cod_disciplina CHAR(8),
		@codigo_avaliacao INT,
		@nota1 DECIMAL(7,2),
		@nota2 DECIMAL(7,2),
		@nota3 DECIMAL(7,2),
		@nota4 DECIMAL(7,2),
		@pre_exame DECIMAL(7,2),
		@media DECIMAL(7,2),
		@peso DECIMAL(7,2),
		@nota DECIMAL(7,2),
		@situacao VARCHAR(20),
		@num_faltas INT,
		@limite_faltas INT
	DECLARE c CURSOR FOR SELECT aluno_ra, disciplina_id, avaliacao_codigo, nota FROM Notas WHERE disciplina_id = @disciplina_id
	OPEN c
	FETCH NEXT FROM c INTO @aluno_ra, @disciplina_id, @codigo_avaliacao, @nota
	INSERT INTO @table (aluno_ra)
		SELECT DISTINCT aluno_ra FROM Notas WHERE disciplina_id = @disciplina_id

	SET @disciplina = (SELECT nome FROM Disciplina WHERE id = @disciplina_id)
	SET @cod_disciplina = (SELECT codigo FROM Disciplina WHERE id = @disciplina_id)

	IF(@cod_disciplina = '4203-020' OR @cod_disciplina = '4213-013')
	BEGIN
		SET @turno = 'Noite'
	END
	ELSE
	BEGIN
		SET @turno = 'Tarde'
	END

	-- Pega o limite de faltas da disciplina
	IF(@cod_disciplina = '4208-010' OR @cod_disciplina = '5005-220')
	BEGIN
		SET @limite_faltas = 10
	END
	ELSE
	BEGIN
		SET @limite_faltas = 20
	END

	SET @media = 0
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		SET @num_faltas = (SELECT total_faltas FROM fn_selectFaltas(@cod_disciplina) WHERE aluno_ra = @aluno_ra)
		IF(@num_faltas > @limite_faltas)
		BEGIN
			SET @situacao = 'Reprovado por falta'
			UPDATE @table
			SET situacao = @situacao
			WHERE aluno_ra = @aluno_ra
		END
		ELSE
		BEGIN
			SET @situacao = 'Calcular Media'
		END

		UPDATE @table
		SET disciplina = @disciplina
		WHERE aluno_ra = @aluno_ra

		UPDATE @table
		SET turno = @turno
		WHERE aluno_ra = @aluno_ra

		SET @nome_aluno = (SELECT nome FROM Aluno WHERE ra = @aluno_ra)
		-- P1 ou MC
		IF(@codigo_avaliacao = 1 OR @codigo_avaliacao = 6)
		BEGIN
			SET @nota1 = @nota * @peso
		END
		ELSE
		BEGIN
			-- P2 ou MR
			IF(@codigo_avaliacao = 2 OR @codigo_avaliacao = 7)
			BEGIN
				SET @nota2 = @nota * @peso
			END
			ELSE
			BEGIN
				-- T ou (P3 no caso de LBD)
				IF(@codigo_avaliacao = 3)
				BEGIN
					SET @nota3 = @nota * @peso
				END
				ELSE
				BEGIN
					-- PE
					IF(@codigo_avaliacao = 5)
					BEGIN
						SET @pre_exame = @nota * @peso
					END
					ELSE
					-- P3
					BEGIN
						SET @nota4 = @nota
					END
				END
			END
		END

		SET @media = (ISNULL(@nota1, 0) + ISNULL(@nota2, 0) + ISNULL(@nota3, 0))

		IF(@situacao != 'Reprovado por falta')
		BEGIN
			IF(@nota1 IS NOT NULL AND @nota2 IS NOT NULL)
			BEGIN
				IF(@media >= 3 AND @media < 6 AND @pre_exame IS NOT NULL)
				BEGIN
					SET @media = @media + @pre_exame
				END
				IF(@media >= 3 AND @media < 6 AND @nota4 IS NULL)
				BEGIN
					SET @situacao = 'Exame'
				END
				ELSE
				BEGIN
					IF(@media >= 3 AND @media < 6 AND @nota4 IS NOT NULL)
					BEGIN
						SET @media = (@media + @nota4) / 2
						IF(@media < 6)
						BEGIN
							SET @situacao = 'Reprovado'
						END
					END
					ELSE
					BEGIN
						IF(@media >= 6)
						BEGIN
							SET @situacao = 'Aprovado'
						END
						ELSE
						BEGIN
							SET @situacao = 'Reprovado'
						END
					END
				END
			END
			ELSE
			BEGIN
				SET @situacao = 'Cursando'
			END
		END

		UPDATE @table
		SET nome_aluno = @nome_aluno, nota1 = @nota1, nota2 = @nota2, nota3 = @nota3,pre_exame = @pre_exame, nota4 = @nota4, media = @media, situacao = @situacao
		WHERE aluno_ra = @aluno_ra

		FETCH NEXT FROM c INTO @aluno_ra, @cod_disciplina, @codigo_avaliacao, @nota, @peso
	END
	CLOSE c
	DEALLOCATE c
	RETURN
END