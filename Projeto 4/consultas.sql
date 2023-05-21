-- Exercicio 1

WITH TABELA_MIN_MAX AS (
    SELECT l.lap, r.name, MIN(l.milliseconds), MAX(l.milliseconds) FROM laptimes l
        JOIN RACES r
            ON r.raceid = l.raceid
        GROUP BY l.lap, r.name
        ORDER BY r."name" , l .lap
)
SELECT r.name, r.year, l.lap AS num_volta, t.min, t.max, d1.forename || ' ' || d1.surname AS driverName, l.milliseconds  FROM RACES r
	JOIN LAPTIMES l
		ON l.raceid = r.raceid
	JOIN TABELA_MIN_MAX t
		ON t.name = r."name" AND t.lap = l.lap 
	JOIN DRIVER d1
		ON d1.driverid = l.driverid AND (l.milliseconds = t.min OR l.milliseconds = t.max)
	GROUP BY l.lap, r.name, r.YEAR, t.min, t.max, d1.forename, d1.surname, l.milliseconds 
	ORDER BY r.name, r.YEAR, l.lap
;



-- Exercicio 2

	-- Parte 1
	SELECT c."name", c.nationality, COUNT(c.constructorid) FROM results r
		JOIN constructors c 
			ON c.constructorid = r.constructorid
		WHERE r.position = 1
		GROUP BY c."name", c.nationality
		ORDER BY COUNT(c.constructorid) DESC
	;

	-- Parte 2
	SELECT DISTINCT c.nationality, COUNT(r.constructorid) OVER (PARTITION BY c.nationality) AS count FROM results r
		JOIN constructors c 
			ON c.constructorid = r.constructorid
		WHERE r.position = 1
		ORDER BY count DESC;

	-- Parte 3
	SELECT c.nationality, c.name AS escuderia, COUNT(r.constructorid) AS vitorias,
       RANK() OVER (PARTITION BY c.nationality ORDER BY COUNT(r.constructorid) DESC, c.name) AS ranking
	FROM results r
	JOIN constructors c ON c.constructorid = r.constructorid
	WHERE r.position = 1
	GROUP BY c.nationality, c.name
	ORDER BY c.nationality, vitorias DESC, escuderia;



-- Exercicio 3
	
WITH MEDIA_PITSTOP_PILOTO AS (
	SELECT 
		AVG(p.milliseconds) AS avg, d.driverid, 
		r.raceid, 
		ROW_NUMBER() OVER (PARTITION BY r.raceid ORDER BY AVG(p.milliseconds)) AS posicao_piloto_em_tempo_medio_de_pitstop
	FROM pitstops p
		JOIN driver d ON p.driverid = d.driverid
		JOIN races r ON r.raceid = p.raceid
	GROUP BY d.driverid, r.raceid
)
SELECT ra."name" AS nome_da_corrida, ra."year" AS ano_da_corrida, (d.forename || ' ' || d.surname) AS nome_piloto, 
M.posicao_piloto_em_tempo_medio_de_pitstop AS rank_em_tempo_de_pitstops, M.avg AS media_tempo_pitstop_do_piloto
FROM results re
JOIN races ra ON re.raceid = ra.raceid
JOIN MEDIA_PITSTOP_PILOTO M ON M.driverid = re.driverid AND M.raceid = re.raceid 
JOIN driver d ON d.driverid = re.driverid
ORDER BY ra.raceid, M.avg;



-- Exercicio 4

SELECT nationality, array_agg(constructorref) AS contrutores_do_pais
FROM constructors c 
GROUP BY nationality;



-- Exercicio 5

WITH MELHOR_TEMPO_CADA_CORRIDA AS
(
	SELECT ra.raceid, r.milliseconds
	FROM results r
	JOIN RACES ra ON ra.raceid = r.raceid
	WHERE r."position" = 1
),
TEMPO_TOTAL_DA_CORRIDA AS
(
	SELECT MAX(r.milliseconds) AS tempo_total_corrida, ra.raceid
	FROM results r
	JOIN RACES ra ON ra.raceid = r.raceid
	GROUP BY ra.raceid
)
SELECT 
	ra.raceid, 
	ra."name", 
	ra."year", 
	(d.forename || ' ' || d.surname) AS nome_piloto, 
	re.milliseconds AS tempo_piloto_na_corrida, 
	tt.tempo_total_corrida, 
	(mt.milliseconds - re.milliseconds) AS diferenca_para_o_melhor_tempo,
    re.milliseconds - LAG(re.milliseconds) OVER (PARTITION BY ra.raceid ORDER BY re."position") AS diferenca_de_tempo_para_o_anterior
FROM races ra
JOIN results re ON re.raceid = ra.raceid
JOIN MELHOR_TEMPO_CADA_CORRIDA mt ON mt.raceid = re.raceid
JOIN TEMPO_TOTAL_DA_CORRIDA tt ON tt.raceid = re.raceid
JOIN driver d ON d.driverid = re.driverid
ORDER BY tt.tempo_total_corrida, re."position";