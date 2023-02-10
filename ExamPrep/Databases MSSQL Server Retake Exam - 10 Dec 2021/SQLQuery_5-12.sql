
--5)
USE Airport
GO


SELECT
    a.Manufacturer,
    a.Model,
    a.FlightHours,
    a.Condition
FROM Aircraft AS a
ORDER BY a.FlightHours DESC

--6)
SELECT
    p.FirstName,
    p.LastName,
    a.Manufacturer,
    a.Model,
    a.FlightHours
FROM Pilots AS p
    JOIN PilotsAircraft AS pa
    ON p.Id = pa.PilotId
    JOIN Aircraft AS a
    ON pa.AircraftId = a.Id
WHERE a.FlightHours IS NOT NULL AND a.FlightHours <= 304
ORDER BY a.FlightHours DESC, p.FirstName ASC

--7)
SELECT TOP(20)
    fld.Id AS [DestinationId],
    fld.[Start] AS [Start],
    p.FullName AS [FullName],
    a.AirportName AS [AirportName],
    fld.TicketPrice AS [TicketPrice]
FROM FlightDestinations AS fld
    LEFT JOIN Airports AS a
    ON fld.AirportId = a.Id
    LEFT JOIN Passengers AS p
    ON p.Id = fld.PassengerId
WHERE DAY(fld.[Start]) % 2 = 0
ORDER BY fld.TicketPrice DESC, a.AirportName ASC

--8)

SELECT *
FROM
    (
SELECT
        a.Id,
        a.Manufacturer,
        a.FlightHours,
        COUNT(fld.Id) AS [FlightDestinationsCount],
        ROUND(AVG(fld.TicketPrice), 2) AS [AvgPrice]
    FROM Aircraft AS a
        LEFT JOIN FlightDestinations AS fld
        ON a.Id = fld.AircraftId
    GROUP BY a.Id, a.Manufacturer, a.FlightHours
) AS r
WHERE [FlightDestinationsCount] >= 2
ORDER BY FlightDestinationsCount DESC, Id ASC

--9)

SELECT *
FROM
    (
    SELECT
        FullName,
        COUNT(fld.Id) AS [CountOfAircraft],
        SUM(TicketPrice) AS [TotalPayed]
    FROM FlightDestinations AS fld
        JOIN Passengers AS p
        ON fld.PassengerId = p.Id
    GROUP BY FullName
    ) AS r
WHERE CountOfAircraft >= 2 AND FullName LIKE '_a%'
ORDER BY FullName ASC

--10)
SELECT
    ap.AirportName,
    fld.[Start] AS [DayTime],
    fld.TicketPrice,
    p.FullName,
    a.Manufacturer,
    a.Model
FROM FlightDestinations AS fld
    JOIN Passengers AS p
    ON fld.PassengerId = p.Id
    JOIN Aircraft AS a
    ON fld.AircraftId = a.Id
    JOIN Airports AS ap
    ON ap.Id = fld.AirportId
WHERE FORMAT(fld.[Start],'HH:mm') BETWEEN '06:00' AND '20:00'
    AND fld.TicketPrice > 2500
ORDER BY a.Model ASC

--11)
GO

CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50)) 
RETURNS INT
AS 
BEGIN
    DECLARE @count INT;
    SET @count = (
                    SELECT
                        COUNT(*)
                    FROM Passengers AS p
                        JOIN FlightDestinations AS fld
                        ON p.Id = fld.PassengerId
                    WHERE p.Email = @email
                    GROUP BY p.FullName);
    
    IF (@count IS NULL)
    BEGIN
        SET @count = 0
    END

    RETURN @count;
END

GO
SELECT dbo.udf_FlightDestinationsByEmail ('PierretteDunmuir@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('Montacute@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('MerisShale@gmail.com')

--12)
GO

CREATE PROCEDURE usp_SearchByAirportName @airportName VARCHAR(70)
AS
BEGIN
    SELECT 
        ap.AirportName,
        p.FullName,
        CASE 
            WHEN fld.TicketPrice <= 400 THEN 'Low'
            WHEN fld.TicketPrice > 400 AND fld.TicketPrice <= 1500 THEN 'Medium' 
            ELSE 'High' 
        END AS [LevelOfTickerPrice],
        a.Manufacturer,
        a.Condition,
        [at].TypeName
    FROM Airports as ap 
    JOIN FlightDestinations AS fld
    ON ap.Id = fld.AirportId
    JOIN Passengers AS p 
    ON p.Id = fld.PassengerId
    JOIN Aircraft AS a 
    ON fld.AircraftId = a.Id
    JOIN AircraftTypes AS [at]
    ON [at].Id = a.TypeId
    WHERE ap.AirportName = @airportName
    ORDER BY a.Manufacturer, p.FullName
END

GO

EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'