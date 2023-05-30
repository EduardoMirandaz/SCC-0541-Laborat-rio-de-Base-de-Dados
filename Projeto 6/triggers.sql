

----------            ----------
----------            ----------
---------- Exercício 1 ---------- 
----------            ----------
----------            ----------

CREATE OR REPLACE FUNCTION VerificaAeroporto() 
	RETURNS TRIGGER AS 
	$$
	BEGIN
	    IF NEW.city IS NOT NULL AND 
	    	NOT EXISTS (SELECT 1 FROM GEOCITIES15K gc WHERE gc.name = NEW.city) 
	    	THEN RAISE EXCEPTION 'Cidade não encontrada! Operação cancelada.';
	    RETURN NULL;
	    END IF;
	    RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER TR_Airports
BEFORE INSERT OR UPDATE ON AIRPORTS
FOR EACH ROW
EXECUTE FUNCTION VerificaAeroporto();


SELECT * FROM airports a 

INSERT INTO Airports (Ident, Type, Name, LatDeg, LongDeg, ElevFt, Continent, ISOCountry, ISORegion, City, Scheduled_service, GPSCode, IATACode, LocalCode, HomeLink, WikipediaLink, Keywords)
VALUES ('00025A', 'heliport', 'Total Rf Heliport', 40.07080078125, -74.93360137939453, 11, 'NA', 'US', 'US-PA', 
	'São Carlos', 
'no', '00A', '00A', '', '', '', '');

UPDATE Airports
	SET City = 'Nárnia'
	WHERE Ident = '00025A';



----------            ----------
----------            ----------
---------- Exercício 2 ---------- 
----------            ----------
----------            ----------


CREATE TABLE results_status (
	StatusID INTEGER PRIMARY KEY,
	Contagem INTEGER,
	FOREIGN KEY (StatusID) REFERENCES status(StatusID)
);
INSERT INTO results_status
	SELECT S.StatusId , COUNT (*)
		FROM Status S JOIN Results R ON R.StatusID = S.StatusID
		GROUP BY S.StatusId , S.Status;


	-- Trigger e função para as questões a b e c;
CREATE OR REPLACE FUNCTION AtualizaContagem() 
	RETURNS TRIGGER AS $$
	DECLARE
	    nova_contagem INTEGER; -- Variável para armazenar a nova contagem
	    nova_contagem_old INTEGER;
	BEGIN
	    IF NOT EXISTS 
	    	(SELECT 1 FROM STATUS s WHERE s.statusid = NEW.statusid OR s.statusid = OLD.statusid) 
	    	THEN RAISE EXCEPTION 'Status não encontrado! Impossível operacionar com este resultado.';
	    	RETURN NULL;
	    END IF;
		IF TG_OP = 'INSERT' THEN
    		UPDATE results_status SET contagem = contagem + 1 WHERE statusid = NEW.statusid RETURNING contagem INTO nova_contagem;
    		RAISE NOTICE 'StatusID: %, Contagem: %.', NEW.statusid, nova_contagem; -- exibindo mensagem da nova inserção
    		RETURN NEW;
	    END IF;
   		IF TG_OP = 'DELETE' THEN
    		UPDATE results_status SET contagem = contagem - 1 WHERE statusid = OLD.statusid RETURNING contagem INTO nova_contagem;
    		RAISE NOTICE 'StatusID: %, Contagem: %.', OLD.statusid, nova_contagem; -- exibindo mensagem da nova deleçao
    		RETURN OLD;
	    END IF;
   		IF TG_OP = 'UPDATE' THEN
	        IF NEW.statusid <> OLD.statusid THEN -- Esse IF me garante que o atributo statusId foi modificado
	        	UPDATE results_status SET contagem = contagem - 1 WHERE statusid = OLD.statusid RETURNING contagem INTO nova_contagem_old;
	        	UPDATE results_status SET contagem = contagem + 1 WHERE statusid = NEW.statusid RETURNING contagem INTO nova_contagem;
	        	RAISE NOTICE 'StatusID sendo atualizado'; -- exibindo mensagem da nova edição
                RAISE NOTICE 'StatusID Anterior: %, Contagem: %', OLD.statusid, nova_contagem_old;
	            RAISE NOTICE 'StatusID Atual: %, Contagem: %', NEW.statusid, nova_contagem;
				RETURN NEW;
           	END IF;
	    END IF;
	END;
	$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TR_ResultsStatus
BEFORE INSERT OR UPDATE OR DELETE ON Results
	FOR EACH ROW
	EXECUTE FUNCTION AtualizaContagem();

	-- Trigger e função para questão d;
CREATE OR REPLACE FUNCTION VerificaStatus() 
	RETURNS TRIGGER AS $$
	BEGIN
	    IF NEW.statusid < 0 THEN
			RAISE NOTICE 'StatusID Negativo! Operação cancelada.'; -- exibindo mensagem de erro por status negativo.
			RETURN NULL;
	    END IF;
	   	RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TR_Results
BEFORE INSERT OR UPDATE ON Results
	FOR EACH ROW
	EXECUTE FUNCTION VerificaStatus();

-- Testes de inserção, deleção e edição na tabela Results

----------------------------------------------------------------------------
-------------------------- [ QUESTÃO A ] ----------------------------------------
--  Inserindo um novo resultado para um dado status ID e validando que o valor aumentou

-- 1. Selecionando um resultado de status id aleatório para adicionar mais um na tabela results.
SELECT * FROM RESULTS_STATUS rs WHERE rs.statusId = 2;

-- 2. Inserindo o novo resultado!
INSERT INTO Results (ResultId, RaceId, DriverId, ConstructorId, Number, Grid, Position, PositionText, PositionOrder, Points, Laps, Time, Milliseconds, FastestLap, Rank, FastestLapTime, FastestLapSpeed, StatusId)
VALUES (999999, 18, 1, 1, 22, 1, 1, '1', 1, 10.0, 58, '1:34:50.616', 5690616, 39, 2, '1:27.452', '218.300', 1564658);

-- 3. Recuperando a quantidade para o mesmo status e validando que o valor diminuiu 1.
SELECT * FROM RESULTS_STATUS rs WHERE rs.statusId = 2;

----------------------------------------------------------------------------
-------------------------- [ QUESTÃO B ] ----------------------------------------

-- 1. Selecionando um resultado de status id aleatório para apagar um da tabela results.
SELECT * FROM RESULTS_STATUS rs WHERE rs.statusId = 116;

-- 2. Recuperando algum resultId aleatório que corresponde aquele statusId
SELECT * FROM RESULTS rs WHERE rs.statusId = 116;

-- 3. Deletando o resultado!
DELETE FROM RESULTS rs WHERE rs.resultid = 19598;

-- 4. Recuperando a quantidade para o mesmo status e validando que o valor diminuiu 1.
SELECT * FROM RESULTS_STATUS rs WHERE rs.statusId = 116;

----------------------------------------------------------------------------
-------------------------- [ QUESTÃO C ] ----------------------------------------

-- 1. Selecionando 2 status ID aleatórios, um irá reduzir a contagem e o outro irá incrementar.
SELECT * FROM RESULTS_STATUS rs WHERE rs.statusId = 3 OR rs.statusId = 12 ;

-- 2. Recuperando algum resultId aleatório que contém o statusId supracitado. (Decidi trocar um 12 por um 3)
SELECT * FROM RESULTS rs WHERE rs.statusId = 12;

-- 3. Realizando o update. 
UPDATE RESULTS 
SET statusId = 3
WHERE resultId = 1948;


-- 4. Recuperando a quantidade para o mesmo status e validando que um valor diminuiu 1 e o outro aumentou 1, respectivamente 12 e 3.
SELECT * FROM RESULTS_STATUS rs WHERE rs.statusId = 116;

----------------------------------------------------------------------------
-------------------------- [ QUESTÃO D ] ----------------------------------------

-- Garantindo que valores negativos para o statusId não sao aceitos
SELECT * FROM RESULTS r

INSERT INTO Results (ResultId,
 RaceId,
 DriverId,
 ConstructorId,
 Number,
 Grid,
 Position,
 PositionText,
 PositionOrder,
 Points,
 Laps,
 Time,
 Milliseconds,
 FastestLap,
 Rank,
 FastestLapTime,
 FastestLapSpeed,
 StatusId)
VALUES (525256, 18, 1, 1, 22, 1, 1, '1', 1, 10.0, 58, '1:34:50.616', 5690616, 39, 2, '1:27.452', '218.300', -20);
