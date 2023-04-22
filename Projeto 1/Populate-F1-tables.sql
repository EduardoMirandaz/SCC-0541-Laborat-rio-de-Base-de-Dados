
-- Inserção dos dados da tabela CIRCUITS(circuitos)
COPY CIRCUITS
FROM '/tmp/DadosLabBD/circuits.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

-- Inserção dos dados da tabela CONSTRUCTORS(construtores)
COPY CONSTRUCTORS
FROM '/tmp/DadosLabBD/constructors.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

-- Inserção dos dados da tabela SEASONS (temporadas)
COPY SEASONS
FROM '/tmp/DadosLabBD/seasons.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

-- Inserção dos dados da tabela STATUS
COPY STATUS
FROM '/tmp/DadosLabBD/status.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);
	
-- Inserção dos dados da tabela AIRPORTS (aeroportos)
COPY AIRPORTS
FROM '/tmp/DadosLabBD/airports.csv'
WITH (DELIMITER ',', NULL '', HEADER true, FORMAT CSV);

-- Inserção dos dados da tabela RACES (corridas)
COPY RACES
FROM '/tmp/DadosLabBD/races.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

-- Inserção dos dados da tabela COUNTRIES (países)
COPY COUNTRIES
FROM '/tmp/DadosLabBD/countries.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV);

-- Inserção dos dados da tabela GEOCITIES15K (*)
COPY GEOCITIES15K
FROM '/tmp/DadosLabBD/Cities15000.tsv'
WITH (DELIMITER '	', NULL '', HEADER false, FORMAT CSV)

-- Inserção dos dados da tabela DRIVER_STANDINGS (classificação)
COPY DRIVER_STANDINGS
FROM '/tmp/DadosLabBD/driver_standings.csv'
WITH (DELIMITER ',', NULL '', HEADER true, FORMAT CSV)

-- Inserção dos dados da tabela DRIVER_STANDINGS (classificação)
COPY DRIVER_STANDINGS
FROM '/tmp/DadosLabBD/driver_standings.csv'
WITH (DELIMITER ',', NULL '', HEADER true, FORMAT CSV)

-- Inserção dos dados da tabela LAPTIMES (tempos de volta)
COPY LAPTIMES
FROM '/tmp/DadosLabBD/lap_times.csv'
WITH (DELIMITER ',', NULL '', HEADER true, FORMAT CSV)

-- Inserção dos dados da tabela PITSTOPS (*)
COPY PITSTOPS
FROM '/tmp/DadosLabBD/pit_stops.csv'
WITH (DELIMITER ',', NULL '', HEADER true, FORMAT CSV)

-- Inserção dos dados da tabela QUALIFYING (qualificatória)

-- Aqui, precisaremos criar uma tabela temporária, devido à inconsistência nos dados
-- do arquivo CSV quando inseridos com o tipo INTERVAL.
CREATE TEMPORARY TABLE TEMP_QUALIFYING (
  	QUALIFYING_ID INT NOT NULL,
	RACE_ID INT,
	DRIVER_ID INT,
	CONSTRUCTOR_ID INT,
  	NUMBER INT,
	POSITION INT,
  	Q1 CHAR(10),
  	Q2 CHAR(10),
  	Q3 CHAR(10)
);

-- Importando os dados para a tabela temporária para executar os ajustes
COPY temp_qualifying 
FROM '/tmp/DadosLabBD/qualifying.csv' 
WITH (DELIMITER ',', FORMAT CSV, HEADER true, NULL '\N');

-- Inserindo na tabela qualifying aplicando os ajustes de conversão de tipo de dado
-- e removendo os vazios(setando eles para null na inserção).
INSERT INTO QUALIFYING
SELECT
    QUALIFYING_ID,
    RACE_ID,
    DRIVER_ID,
    CONSTRUCTOR_ID,
    NUMBER,
    POSITION,
    NULLIF(Q1, '')::INTERVAL,
    NULLIF(Q2, '')::INTERVAL,
    NULLIF(Q3, '')::INTERVAL
FROM
    TEMP_QUALIFYING;

DROP TABLE temp_qualifying;

-- Inserção dos dados da tabela RESULTS (Resultados)
COPY RESULTS
FROM '/tmp/DadosLabBD/results.csv'
WITH (DELIMITER ',', NULL '\N', HEADER true, FORMAT CSV)



