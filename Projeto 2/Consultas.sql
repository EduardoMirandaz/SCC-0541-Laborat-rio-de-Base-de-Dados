--  # Exercicio 1)
-- Liste o total de pontos obtidos por cada piloto por ano em ordem descendente
-- de pontuacao.
SELECT D.driverref, S.year, SUM(DS.points) as total_points
FROM DRIVER D
JOIN DRIVERSTANDINGS DS
	ON D.driverid = DS.driverid
JOIN RACES R
	ON R.raceid = DS.raceid
RIGHT JOIN SEASONS S 
	ON R."year" = S."year"
GROUP BY D.driverref, S.year
ORDER BY S.year, total_points DESC;

-- Exercício 2) Liste a quantidade de corridas por ano, apresentando 
-- o ano e o núumero decorridas, em ordem descendente de número de corridas.
SELECT YEAR, COUNT(RACEID) AS "Quantidade de corridas"
FROM 
	RACES
GROUP BY 
	YEAR
ORDER BY 
	"Quantidade de corridas" DESC;


-- Exercício 3) Liste o número de aeroportos por tipo de aeroporto em cada continente.

SELECT A."type" AS TIPO_DE_AEROPORTO, C.CONTINENT, COUNT(A.CONTINENT)
FROM COUNTRIES C
JOIN AIRPORTS A
	ON A.CONTINENT = C.CODE
GROUP BY TIPO_DE_AEROPORTO, C.CONTINENT
ORDER BY c.continent;


-- 4) Crie uma nova coluna, de nome Podium_Position, na tabela QUALIFYING utilizando o comando ALTER TABLE. 
-- Depois, atualize o valor dessa coluna para conter o texto
-- ’Podium’ no caso da tupla conter o valor 1 a 3 para o atributo Position.

ALTER TABLE QUALIFYING ADD COLUMN Podium_Position CHAR(6);

UPDATE QUALIFYING
SET Podium_Position = 'Podium'
WHERE Position >= 1 AND Position <= 3;

SELECT * FROM QUALIFYING
ORDER BY POSITION DESC;

-- Exercício 5) Para todos os pilotos de nacionalidade brasileira (valor’Brazilian’no atrib-uto’Nationality), 
-- atualize o atributo’Nationalitypara’BR’

UPDATE DRIVER 
SET 
	NATIONALITY = 'BR'
WHERE 
	NATIONALITY = 'Brazilian';

-- Exercício 6) Selecione  o  nome  do  piloto  que  partiu  mais  
-- vezes  em  primeiro  lugar  (poleposition) da histÓoria.  
-- Apresente o nome completo do piloto e a quantidade de vezes.
-- Dica:Considere a tabelaQUALIFYING.
SELECT p.forename || ' ' || p.surname AS "Nome completo", COUNT(*) AS "Total de poles"
FROM 
	qualifying q
	JOIN driver p ON p.driverid = q.driverid  
WHERE 
    q.position = 1
GROUP BY 
    q.POSITION, p.forename, p.surname
ORDER BY 
    "Total de poles" DESC
LIMIT 1;

-- Exercıcio 7) Para cada paÍs que sedia corridas, liste o número de cidades e o n´umero
-- de aeroportos totais que o pa´ıs tem. Considere que o atributo Country em GEOCITIES15K e o
-- atributo ISOCountry em AIRPORTS se referem ao Code da tabela AIRPORTS.
-- Dica: Conte separadamente a quantidade de aeroportos e de cidades.

-- Selecionar todos os países que possuem menos de 10 aeroportos
-- selecionar cada pais que tem pelo menos uma corrida
-- feito isso, listar o numero de cidades, do pais

SELECT DISTINCT(c.code), c."name",  
	(SELECT COUNT(*) 
    	FROM Airports a 
    	WHERE a.isocountry = c.code) AS qtd_aeroportos,
    (SELECT COUNT(*) 
    	FROM geocities15k gk 
    	WHERE gk.country = c.code) AS qtd_cidades
FROM Countries c
	JOIN circuits c2 
	ON c."name"  = c2.country
		JOIN races r 
		ON c2.circuitid = r.circuitid 
	ORDER BY c.code 
;

-- Exercıcio 8) 

-- Gere uma tabela de nome COUNTRIESv2 com a mesma estrutura da tabela
-- COUNTRIES. Essa tabela deve conter apenas os países que tenham menos que 10 aeroportos. 
-- É obrigat´orio usar o comando DELETE nesse comando.
-- Dica: use a clausula NOT IN.

CREATE TABLE COUNTRIESV2 AS
SELECT * FROM COUNTRIES;

DELETE FROM COUNTRIESV2;

-- Selecionar todos os países que possuem menos de 10 aeroportos
SELECT c.*
FROM Countries c
WHERE (
    SELECT COUNT(*) 
    FROM Airports a 
    WHERE a.isocountry = c.code
) < 10;


INSERT INTO COUNTRIESV2 (
	SELECT c.*
	FROM Countries c
	WHERE (
	    SELECT COUNT(*) 
	    FROM Airports a 
	    WHERE a.isocountry = c.code
	) < 10
);


SELECT * FROM geocities15k gk 

