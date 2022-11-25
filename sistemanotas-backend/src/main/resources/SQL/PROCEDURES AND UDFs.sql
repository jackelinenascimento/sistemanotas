<<<<<<< HEAD
=======
-- Procedure de inserir as notas
CREATE PROCEDURE sp_insertNotas(@ra_aluno INT, @codigo_disciplina CHAR(8), @codigo_avaliacao INT, @nota DECIMAL(7,2))
AS
	INSERT INTO Notas VALUES
	(@ra_aluno, @codigo_disciplina, @codigo_avaliacao, @nota, NULL)

-- Procedure de inserir as faltas
CREATE PROCEDURE sp_insertFaltas(@ra_aluno INT, @codigo_disciplina CHAR(8), @presenca INT)
AS
	DECLARE @data_falta DATE
	SET @data_falta = (SELECT MAX(data_falta) 
		FROM Faltas 
		WHERE ra_aluno = @ra_aluno AND codigo_disciplina = @codigo_disciplina)
	
	IF(@codigo_disciplina = '4203-010' OR @codigo_disciplina = '4203-020')
	BEGIN
		IF(@data_falta IS NULL)
		BEGIN
			SET @data_falta = '28/07/2021'
		END
		ELSE
		BEGIN
			SET @data_falta = (DATEADD(DAY, 7, @data_falta))
		END
	END
	ELSE
	BEGIN
		IF(@codigo_disciplina = '4208-010' OR @codigo_disciplina = '4226-004')
		BEGIN
			IF(@data_falta IS NULL)
			BEGIN
				SET @data_falta = '29/07/2021'
			END
			ELSE
			BEGIN
				SET @data_falta = (DATEADD(DAY, 7, @data_falta))
			END
		END
		ELSE
		BEGIN
			IF(@codigo_disciplina = '4213-003' OR @codigo_disciplina = '4213-013')
			BEGIN
				IF(@data_falta IS NULL)
				BEGIN
					SET @data_falta = '30/07/2021'
				END
				ELSE
				BEGIN
					SET @data_falta = (DATEADD(DAY, 7, @data_falta))
				END
			END
			ELSE
			BEGIN
				IF(@codigo_disciplina = '4233-005')
				BEGIN
					IF(@data_falta IS NULL)
					BEGIN
						SET @data_falta = '02/08/2021'
					END
					ELSE
					BEGIN
						SET @data_falta = (DATEADD(DAY, 7, @data_falta))
					END
				END
				ELSE
				BEGIN
					IF(@data_falta IS NULL)
					BEGIN
						SET @data_falta = '03/08/2021'
					END
					ELSE
					BEGIN
						SET @data_falta = (DATEADD(DAY, 7, @data_falta))
					END
				END
			END
		END
	END
	INSERT INTO Faltas VALUES
	(@ra_aluno, @codigo_disciplina, @data_falta, @presenca)
>>>>>>> 55558b360cafdd4b9f2c420f824f2cea74730999

-- Function que mostra as notas da turma
CREATE FUNCTION fn_selectNotas(@cod_disciplina CHAR(8))
RETURNS @table TABLE(
ra_aluno INT,
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
	DECLARE @ra_aluno INT,
		@nome_aluno VARCHAR(100),
		@disciplina VARCHAR(50),
		@turno VARCHAR(10),
		@codigo_disciplina CHAR(8),
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
	DECLARE c CURSOR FOR SELECT ra_aluno, codigo_disciplina, codigo_avaliacao, nota, peso FROM Notas WHERE codigo_disciplina = @cod_disciplina
	OPEN c
	FETCH NEXT FROM c INTO @ra_aluno, @codigo_disciplina, @codigo_avaliacao, @nota, @peso
	INSERT INTO @table (ra_aluno)
		SELECT DISTINCT ra_aluno FROM Notas WHERE codigo_disciplina = @cod_disciplina

	SET @disciplina = (SELECT nome FROM Disciplina WHERE codigo = @cod_disciplina)
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
		SET @num_faltas = (SELECT total_faltas FROM fn_selectFaltas(@cod_disciplina) WHERE ra_aluno = @ra_aluno)
		IF(@num_faltas > @limite_faltas)
		BEGIN
			SET @situacao = 'Reprovado por falta'
			UPDATE @table
			SET situacao = @situacao
			WHERE ra_aluno = @ra_aluno
		END
		ELSE
		BEGIN
			SET @situacao = 'Calcular Media'
		END

		UPDATE @table
		SET disciplina = @disciplina
		WHERE ra_aluno = @ra_aluno

		UPDATE @table
		SET turno = @turno
		WHERE ra_aluno = @ra_aluno

		SET @nome_aluno = (SELECT nome FROM Aluno WHERE ra = @ra_aluno)
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
		WHERE ra_aluno = @ra_aluno
		
		FETCH NEXT FROM c INTO @ra_aluno, @codigo_disciplina, @codigo_avaliacao, @nota, @peso
	END
	CLOSE c
	DEALLOCATE c
	RETURN
END

-- Function que mostra as Faltas da turma
CREATE FUNCTION fn_selectFaltas(@codigo_disciplina CHAR(8))
RETURNS @table TABLE(
ra_aluno INT,
nome_aluno VARCHAR(100),
disciplina VARCHAR(50), -- Para mostrar no relatorio do jasper
turno VARCHAR(10), -- Para mostrar no relatorio do jasper
data1 CHAR(5),
data2 CHAR(5),
data3 CHAR(5),
data4 CHAR(5),
data5 CHAR(5),
data6 CHAR(5),
data7 CHAR(5),
data8 CHAR(5),
data9 CHAR(5),
data10 CHAR(5),
data11 CHAR(5),
data12 CHAR(5),
data13 CHAR(5),
data14 CHAR(5),
data15 CHAR(5),
data16 CHAR(5),
data17 CHAR(5),
data18 CHAR(5),
data19 CHAR(5),
data20 CHAR(5),
presenca_data1 VARCHAR(4),
presenca_data2 VARCHAR(4),
presenca_data3 VARCHAR(4),
presenca_data4 VARCHAR(4),
presenca_data5 VARCHAR(4),
presenca_data6 VARCHAR(4),
presenca_data7 VARCHAR(4),
presenca_data8 VARCHAR(4),
presenca_data9 VARCHAR(4),
presenca_data10 VARCHAR(4),
presenca_data11 VARCHAR(4),
presenca_data12 VARCHAR(4),
presenca_data13 VARCHAR(4),
presenca_data14 VARCHAR(4),
presenca_data15 VARCHAR(4),
presenca_data16 VARCHAR(4),
presenca_data17 VARCHAR(4),
presenca_data18 VARCHAR(4),
presenca_data19 VARCHAR(4),
presenca_data20 VARCHAR(4),
total_faltas INT
)
AS
BEGIN
	DECLARE @ra_aluno INT,
		@nome_aluno VARCHAR(100),
		@disciplina VARCHAR(50),
		@turno VARCHAR(10),
		@data_falta DATE,
		@presenca INT,
		@presenca_fp VARCHAR(4),
		@total_faltas INT,
		@cont INT
	SET @cont = 1
	DECLARE c CURSOR FOR SELECT ra_aluno, data_falta, presenca FROM Faltas WHERE codigo_disciplina = @codigo_disciplina
	OPEN c
	FETCH NEXT FROM c INTO @ra_aluno, @data_falta, @presenca
	INSERT INTO @table (ra_aluno)
		SELECT DISTINCT ra_aluno FROM Faltas WHERE codigo_disciplina = @codigo_disciplina
	SET @data_falta = (SELECT TOP 1 data_falta FROM Faltas WHERE codigo_disciplina = @codigo_disciplina AND ra_aluno = @ra_aluno)
	SET @disciplina = (SELECT nome FROM Disciplina WHERE codigo = @codigo_disciplina)

	IF(@codigo_disciplina = '4203-020' 
		OR @codigo_disciplina = '4213-013')
	BEGIN
		SET @turno = 'Noite'
	END
	ELSE
	BEGIN
		SET @turno = 'Tarde'
	END

	WHILE(@@FETCH_STATUS = 0)
	BEGIN

		UPDATE @table
		SET disciplina = @disciplina
		WHERE ra_aluno = @ra_aluno

		UPDATE @table
		SET turno = @turno
		WHERE ra_aluno = @ra_aluno

		SET @total_faltas = 0

		SET @nome_aluno = (SELECT nome FROM Aluno WHERE ra = @ra_aluno)
		UPDATE @table
		SET nome_aluno = @nome_aluno
		WHERE ra_aluno = @ra_aluno

		-- Lá vem mais
		IF(@codigo_disciplina = '4208-010' OR @codigo_disciplina = '5005-220')
		BEGIN
			IF(@presenca = 0)
			BEGIN
				SET @presenca_fp = 'PP'
			END
			ELSE
			BEGIN
				IF(@presenca = 1)
				BEGIN
					SET @presenca_fp = 'FP'
					SET @total_faltas = 1
				END
				ELSE
				BEGIN
					SET @presenca_fp = 'FF'
					SET @total_faltas = 2
				END
			END
		END
		ELSE
		BEGIN
			IF(@presenca = 0)
			BEGIN
				SET @presenca_fp = 'PPPP'
			END
			ELSE
			BEGIN
				IF(@presenca = 1)
				BEGIN
					SET @presenca_fp = 'FPPP'
					SET @total_faltas = 1
				END
				ELSE
				BEGIN
					IF(@presenca = 2)
					BEGIN
						SET @presenca_fp = 'FFPP'
						SET @total_faltas = 2
					END
					ELSE
					BEGIN
						IF(@presenca = 3)
						BEGIN
							SET @presenca_fp = 'FFFP'
							SET @total_faltas = 3
						END
						ELSE
						BEGIN
							SET @presenca_fp = 'FFFF'
							SET @total_faltas = 4
						END
					END
				END
			END
		END -- Fim dos If's de presencas

		UPDATE @table SET total_faltas = ISNULL(total_faltas, 0) + @total_faltas WHERE ra_aluno = @ra_aluno
		
		-- Lá vem mais
		IF(@cont = 1)
		BEGIN
			UPDATE @table 
			SET data1 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data1 = @presenca_fp 
			WHERE ra_aluno = @ra_aluno
		END
		ELSE
		BEGIN
			IF(@cont = 2)
			BEGIN
				UPDATE @table 
				SET data2 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data2 = @presenca_fp 
				WHERE ra_aluno = @ra_aluno
			END
			ELSE
			BEGIN
				IF(@cont = 3)
				BEGIN
					UPDATE @table 
					SET data3 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data3 = @presenca_fp 
					WHERE ra_aluno = @ra_aluno
				END
				ELSE
				BEGIN
					IF(@cont = 4)
					BEGIN
						UPDATE @table 
						SET data4 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data4 = @presenca_fp 
						WHERE ra_aluno = @ra_aluno
					END
					ELSE
					BEGIN
						IF(@cont = 5)
						BEGIN
							UPDATE @table 
							SET data5 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data5 = @presenca_fp 
							WHERE ra_aluno = @ra_aluno
						END
						ELSE
						BEGIN
							IF(@cont = 6)
							BEGIN
								UPDATE @table 
								SET data6 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data6 = @presenca_fp 
								WHERE ra_aluno = @ra_aluno
							END
							ELSE
							BEGIN
								IF(@cont = 7)
								BEGIN
									UPDATE @table 
									SET data7 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data7 = @presenca_fp 
									WHERE ra_aluno = @ra_aluno
								END
								ELSE
								BEGIN
									IF(@cont = 8)
									BEGIN
										UPDATE @table 
										SET data8 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data8 = @presenca_fp 
										WHERE ra_aluno = @ra_aluno
									END
									ELSE
									BEGIN
										IF(@cont = 9)
										BEGIN
											UPDATE @table 
											SET data9 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data9 = @presenca_fp 
											WHERE ra_aluno = @ra_aluno
										END
										ELSE
										BEGIN
											IF(@cont = 10)
											BEGIN
												UPDATE @table 
												SET data10 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data10 = @presenca_fp 
												WHERE ra_aluno = @ra_aluno
											END
											ELSE
											BEGIN
												IF(@cont = 11)
												BEGIN
													UPDATE @table 
													SET data11 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data11 = @presenca_fp 
													WHERE ra_aluno = @ra_aluno
												END
												ELSE
												BEGIN
													IF(@cont = 12)
													BEGIN
														UPDATE @table 
														SET data12 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data12 = @presenca_fp 
														WHERE ra_aluno = @ra_aluno
													END
													ELSE
													BEGIN
														IF(@cont = 13)
														BEGIN
															UPDATE @table 
															SET data13 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data13 = @presenca_fp 
															WHERE ra_aluno = @ra_aluno
														END
														ELSE
														BEGIN
															IF(@cont = 14)
															BEGIN
																UPDATE @table 
																SET data14 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data14 = @presenca_fp 
																WHERE ra_aluno = @ra_aluno
															END
															ELSE
															BEGIN
																IF(@cont = 15)
																BEGIN
																	UPDATE @table 
																	SET data15 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data15 = @presenca_fp 
																	WHERE ra_aluno = @ra_aluno
																END
																ELSE
																BEGIN
																	IF(@cont = 16)
																	BEGIN
																		UPDATE @table 
																		SET data16 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data16 = @presenca_fp 
																		WHERE ra_aluno = @ra_aluno
																	END
																	ELSE
																	BEGIN
																		IF(@cont = 17)
																		BEGIN
																			UPDATE @table 
																			SET data17 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data17 = @presenca_fp 
																			WHERE ra_aluno = @ra_aluno
																		END
																		ELSE
																		BEGIN
																			IF(@cont = 18)
																			BEGIN
																				UPDATE @table 
																				SET data18 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data18 = @presenca_fp 
																				WHERE ra_aluno = @ra_aluno
																			END
																			ELSE
																			BEGIN
																				IF(@cont = 19)
																				BEGIN
																					UPDATE @table 
																					SET data19 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data19 = @presenca_fp 
																					WHERE ra_aluno = @ra_aluno
																				END
																				ELSE
																				BEGIN
																					UPDATE @table 
																					SET data20 = (SELECT CONVERT(CHAR(5),@data_falta,103)), presenca_data20 = @presenca_fp 
																					WHERE ra_aluno = @ra_aluno

																					SET @cont = 0

																					SET @data_falta = (SELECT TOP 1 data_falta FROM Faltas WHERE codigo_disciplina = @codigo_disciplina AND ra_aluno = @ra_aluno)
																				END
																			END
																		END
																	END
																END
															END
														END
													END
												END
											END
										END
									END
								END
							END
						END
					END
				END
			END
		END -- Fim dos If's da data da semana
		SET @cont = @cont + 1
		FETCH NEXT FROM c INTO @ra_aluno, @data_falta, @presenca
	END -- Fim do WHILE
	CLOSE c
	DEALLOCATE c
	RETURN
END