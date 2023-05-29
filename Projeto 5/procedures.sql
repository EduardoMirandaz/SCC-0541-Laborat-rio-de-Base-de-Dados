--- Questao 1

CREATE OR REPLACE FUNCTION NomeNacionalidade(construtor_nome TEXT)
  RETURNS TEXT AS
$$
DECLARE
  nacionalidade TEXT;
BEGIN
  SELECT nationality  INTO nacionalidade
  FROM constructors
  WHERE name = construtor_nome;

  RETURN nacionalidade;
END;
$$
LANGUAGE plpgsql;

SELECT NomeNacionalidade('Mercedes') AS nacionalidade;


-- Questao 2

CREATE OR REPLACE FUNCTION PilotosNacionalidade(nacionalidade TEXT)
  RETURNS VOID AS
$$
DECLARE
  contador INT := 1;
  piloto RECORD;
BEGIN
  FOR piloto IN SELECT CONCAT(forename , ' ' , surname) AS nome_completo FROM driver WHERE nationality  = nacionalidade LOOP
    RAISE NOTICE '% Nome: %', contador, piloto.nome_completo;
    contador := contador + 1;
  END LOOP;
END;
$$
LANGUAGE plpgsql;

SELECT PilotosNacionalidade('Brazilian');


-- Questão 3

CREATE OR REPLACE PROCEDURE CidadeChamada(nome_cidade TEXT)
AS $$
DECLARE
  contagem INT := 0;
  cidade RECORD;
BEGIN
  FOR cidade IN SELECT name, population , country FROM geocities15k WHERE name = nome_cidade LOOP
    contagem := contagem + 1;
    RAISE NOTICE 'Contagem: %', contagem;
    RAISE NOTICE 'Nome: %, População: %, País: %', cidade.name, cidade.population, cidade.country;
  END LOOP;

  IF contagem = 0 THEN
    RAISE NOTICE 'Nenhuma cidade encontrada com o nome %.', nome_cidade;
  END IF;
END;
$$
LANGUAGE plpgsql;

CALL CidadeChamada('São Paulo');
CALL CidadeChamada('Dubai');
CALL CidadeChamada('São Carlos');
CALL CidadeChamada('Campinas');
CALL CidadeChamada('Cachoeiro de Itapimirim');
CALL CidadeChamada('Londrina');
CALL CidadeChamada('Belleville');


-- Questão 4 


-- Questão 5

CREATE OR REPLACE FUNCTION Pais_Continente()
RETURNS TABLE (Nome TEXT, Continente CHAR(2)) AS $$
DECLARE
    country RECORD;
BEGIN
    FOR country 
    IN (
    	SELECT Name, Continent FROM Countries WHERE LENGTH(Name
    ) <= 15) 
    LOOP
        Nome := country.Name;
        Continente := country.Continent;
        RETURN NEXT;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;


SELECT count(*) FROM Pais_Continente();
