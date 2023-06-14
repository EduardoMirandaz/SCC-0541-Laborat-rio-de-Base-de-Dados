CREATE OR REPLACE FUNCTION Mede_Tempo(Query TEXT)
RETURNS TABLE (Name TEXT , Nationality TEXT) AS 
$$
	DECLARE
		TIni TIME; TFim TIME;
		i DOUBLE PRECISION;
		Diff BIGINT;
	BEGIN
		-- Registra o tempo inicial
		TIni := CLOCK_TIMESTAMP();
		FOR i IN 0..100 LOOP
			EXECUTE Query;
		END LOOP;
		-- Registra o tempo final
		TFim := CLOCK_TIMESTAMP();
		-- Calcula a diferenca em milisegundos
		Diff := ROUND( (EXTRACT(EPOCH FROM TFim) -
		EXTRACT(EPOCH FROM TIni) )/10.0);
		RAISE NOTICE '% - % := %', TFim , TIni , Diff;
		-- Retorna o resultado da consulta recebida
		RETURN QUERY EXECUTE Query;
	END;
$$ LANGUAGE plpgsql;

DROP FUNCTION Mede_Tempo

CREATE OR REPLACE FUNCTION Mede_Tempo(Query TEXT)
RETURNS TEXT AS 
$$
	DECLARE
		TIni TIME;
		TFim TIME;
		i DOUBLE PRECISION;
		Diff BIGINT;
		MessageOutput TEXT;
	BEGIN
		-- Registra o tempo inicial
		TIni := CLOCK_TIMESTAMP();
		FOR i IN 0..100 LOOP
			EXECUTE Query;
		END LOOP;
		-- Registra o tempo final
		TFim := CLOCK_TIMESTAMP();
		-- Calcula a diferença em milissegundos
		Diff := ROUND((EXTRACT(EPOCH FROM TFim) - EXTRACT(EPOCH FROM TIni))/10.0);
		MessageOutput := 't0-> ' || TIni || ' | tf-> ' || TFim || ' | diff-> ' || Diff;
		RAISE NOTICE '%', MessageOutput;
		-- Retorna a mensagem de output
		RETURN MessageOutput;
	END;
$$ LANGUAGE plpgsql;



EXPLAIN ANALYZE
	SELECT * FROM constructors c
	WHERE constructorid = 15;


CREATE INDEX IdxNomePiloto ON DRIVER(forename);
CREATE INDEX IdxSobrenomePiloto ON DRIVER(surname);

DROP INDEX IdxNomePiloto;
DROP INDEX IdxSobrenomePiloto;


EXPLAIN ANALYZE
SELECT (d.forename || ' ' || d.surname) AS nome_completo, d.nationality AS nacionalidade
FROM driver d
WHERE d.forename = 'Lewis' AND d.surname = 'Hamilton';


SELECT * FROM Mede_Tempo('
    SELECT (d.forename || d.surname ) AS nome_completo, d.nationality AS nacionalidade
    FROM driver d
    WHERE d.forename = ''Lewis'' AND d.surname = ''Hamilton''
');
-- Execução gerou 0.003539 de tempo gasto com indice.


SELECT * FROM Mede_Tempo('
    SELECT (d.forename || d.surname ) AS nome_completo, d.nationality AS nacionalidade
    FROM driver d
    WHERE d.forename = ''Lewis'' AND d.surname = ''Hamilton''
');

-- Execução gerou 0.004064 de tempo gasto sem índice;



-- QUESTÃO 2


CREATE INDEX IdxCountryGeocities ON GEOCITIES15K(COUNTRY);


SELECT c.name, c.lat, c.long, c.population
FROM geocities15k c
WHERE c.name LIKE 'Co%' AND c.country = 'BR';


EXPLAIN ANALYZE
SELECT c.name, c.lat, c.long, c.population
FROM geocities15k c
WHERE c.name LIKE 'Co%' AND c.country = 'BR';



SELECT * FROM Mede_Tempo('

	SELECT c.name, c.population, c.lat, c.long
	FROM geocities15k c
	WHERE c.name LIKE ''Co%'' AND c.country = ''BR'';

');

-- Com índice no país : 0,017731


DROP INDEX IdxCountryGeocities;

SELECT * FROM Mede_Tempo('

	SELECT c.name, c.population, c.lat, c.long
	FROM geocities15k c
	WHERE c.name LIKE ''Co%'' AND c.country = ''BR'';

');

-- Sem índice no país: 0,381359 

-- O índice melhorou o tempo em aproximadamente 20 vezes!


