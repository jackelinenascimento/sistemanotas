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