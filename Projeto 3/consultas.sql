-- Questão 1

    -- Parte 2
        SELECT C.Name, C.Nationality, S.Status, COUNT(*) quantidadeDeAcidentesNaHistoria
        FROM Results Re
        JOIN Constructors C ON C.ConstructorID = Re.ConstructorID
        JOIN Status S ON S.StatusID = Re.StatusID AND S.status = 'Accident'
        GROUP BY GROUPING SETS((C.Name, S.Status), (C.Nationality, S.Status))
        ORDER BY COUNT (*) DESC;

    -- Parte 3
        SELECT C.Name, C.Nationality, S.Status, COUNT(*) quantidadeDeAcidentesNaHistoria
        FROM Results Re
        JOIN Constructors C ON C.ConstructorID = Re.ConstructorID AND C.nationality = 'British'
        JOIN Status S ON S.StatusID = Re.StatusID AND S.status = 'Accident'
        GROUP BY ROLLUP((C.Name, S.Status), (C.Nationality, S.Status))
        ORDER BY COUNT (*) DESC;

    -- Parte 4
        SELECT C.Name, C.Nationality, S.Status, COUNT(*) quantidadeDeAcidentesNaHistoria
        FROM Results Re
        JOIN Constructors C ON C.ConstructorID = Re.ConstructorID AND C.nationality = 'Brazilian'
        JOIN Status S ON S.StatusID = Re.StatusID AND S.status = 'Accident'
        GROUP BY ROLLUP((C.Name, S.Status), (C.Nationality, S.Status))
        ORDER BY COUNT (*) DESC;



-- Questão 2
    SELECT 
        C.name,
        A.city,
        COUNT (A.ident) as CONTAGEM
    FROM airports A
    JOIN countries C
    ON A.isocountry = C.code
    GROUP BY 
        ROLLUP (C.name, A.city)
    HAVING COUNT(A.ident) > 12
    ORDER BY 
        C.name, CONTAGEM DESC, A.city;

-- Questão 3

    -- Parte 1
        SELECT C.name, COUNT(R."position") AS "Total de vitórias"
        FROM constructors C
        JOIN results R ON C.constructorid = R.constructorid 
        JOIN races RA ON R.raceid = RA.raceid 
        WHERE R."position" = 1 AND c."name" = 'Alfa Romeo'
        GROUP BY ROLLUP(C.name)

    -- Parte 2
        SELECT C.name, COUNT(R."position") AS "Total de vitórias", RA."year" AS "Ano da corrida"
        FROM constructors C
        JOIN results R ON C.constructorid = R.constructorid 
        JOIN races RA ON R.raceid = RA.raceid 
        WHERE R."position" = 1 AND RA."year" = 2020
        GROUP BY ROLLUP (C.name, RA."year")
        ORDER BY "Total de vitórias" DESC;




-- Questão 4

    -- Parte 1
        SELECT (Dr.forename || ' ' || Dr.surname) AS nomeCompleto, Ra."name", AVG(Lap.milliseconds)/1000 tempoMedio	
        FROM RACES Ra
            JOIN LAPTIMES Lap ON  Ra.raceid = Lap.raceid
            JOIN DRIVER Dr ON Dr.driverid = Lap.driverid
        WHERE Ra.YEAR = '2022'
        AND Ra."name" LIKE '%Brazilian Grand Prix%'
        GROUP BY ROLLUP(Ra."name", nomeCompleto);

    -- Parte 2
        SELECT (Dr.forename || ' ' || Dr.surname) AS nomeCompleto, Ra."name", AVG(Lap.milliseconds)/1000 tempoMedio	
        FROM RACES Ra
            JOIN LAPTIMES Lap ON  Ra.raceid = Lap.raceid
            JOIN DRIVER Dr ON Dr.driverid = Lap.driverid
        WHERE Ra.YEAR = '2022'
        AND (Dr.forename || ' ' || Dr.surname) = 'Yuki Tsunoda'
        AND Ra."name" LIKE '%Japanese Grand Prix%'
        GROUP BY ROLLUP(Ra."name", nomeCompleto);
