CREATE TRIGGER t_insertNotas ON Notas
FOR INSERT
AS
BEGIN
	DECLARE @codigo_disciplina CHAR(8),
			@codigo_avaliacao INT,
			@ra_aluno INT,
			@id_disciplina INT

	SET @ra_aluno = (SELECT aluno_ra FROM inserted)
	SET @id_disciplina = (SELECT disciplina_id FROM inserted)
	SET @codigo_disciplina = (SELECT codigo FROM Disciplina WHERE id = @id_disciplina)
	SET @codigo_avaliacao = (SELECT avaliacao_codigo FROM inserted)

	-- AOC, LHW, BDD
	IF(@codigo_disciplina = '4203-010' OR @codigo_disciplina = '4203-020'
		OR @codigo_disciplina = '4208-010' OR @codigo_disciplina = '4226-004')
	BEGIN
		IF(@codigo_avaliacao = 1) -- P1
		BEGIN
			UPDATE Notas SET peso = 0.3 WHERE aluno_ra = @ra_aluno
		END
		ELSE
		BEGIN
			IF(@codigo_avaliacao = 2) -- P2
			BEGIN
				UPDATE Notas SET peso = 0.5 WHERE aluno_ra = @ra_aluno
			END
			ELSE
			BEGIN
				IF(@codigo_avaliacao = 3) -- T
				BEGIN
					UPDATE Notas SET peso = 0.2 WHERE aluno_ra = @ra_aluno
				END
			END
		END
	END
	ELSE
	BEGIN
		-- SOI
		IF(@codigo_disciplina = '4213-003' OR @codigo_disciplina = '4213-013')
		BEGIN
			IF(@codigo_avaliacao = 1 OR @codigo_avaliacao = 2) -- P1 e P2
			BEGIN
				UPDATE Notas SET peso = 0.35 WHERE aluno_ra = @ra_aluno
			END
			ELSE
			BEGIN
				IF(@codigo_avaliacao = 3) -- T
				BEGIN
					UPDATE Notas SET peso = 0.3 WHERE aluno_ra = @ra_aluno
				END
				ELSE
				BEGIN
					IF(@codigo_avaliacao = 5) -- PE
					BEGIN
						UPDATE Notas SET peso = 0.2 WHERE aluno_ra = @ra_aluno
					END
				END
			END
		END
		ELSE
		BEGIN
			-- LBD
			IF(@codigo_disciplina = '4233-005')
			BEGIN
				IF(@codigo_avaliacao = 1 OR @codigo_avaliacao = 2 OR @codigo_avaliacao = 3) -- P1, P2 e P3
				BEGIN
					UPDATE Notas SET peso = 0.33 WHERE aluno_ra = @ra_aluno
				END
			END
			ELSE
			BEGIN
				-- MPC
				IF(@codigo_avaliacao = 6) -- MC
				BEGIN
					UPDATE Notas SET peso = 0.8 WHERE aluno_ra = @ra_aluno
				END
				ELSE -- MR
				BEGIN
					UPDATE Notas SET peso = 0.2 WHERE aluno_ra = @ra_aluno
				END
			END
		END
	END
END