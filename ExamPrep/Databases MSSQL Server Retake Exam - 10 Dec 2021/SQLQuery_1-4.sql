CREATE DATABASE Airport
GO

USE Airport
GO

--1)

CREATE TABLE Passengers
(
    Id INT PRIMARY KEY IDENTITY,
    FullName VARCHAR(100) NOT NULL UNIQUE,
    Email VARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Pilots
(
    Id INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(30) NOT NULL UNIQUE,
    LastName VARCHAR(30) NOT NULL UNIQUE,
    Age TINYINT NOT NULL CHECK (Age >= 21 AND Age <= 62),
    Rating DECIMAL(3,1) NULL CHECK (Rating >= 0.0 AND Rating <= 10.0)
)

CREATE TABLE AircraftTypes
(
    Id INT PRIMARY KEY IDENTITY,
    TypeName VARCHAR(30) NOT NULL UNIQUE
)

CREATE TABLE Aircraft
(
    Id INT PRIMARY KEY IDENTITY,
    Manufacturer VARCHAR(25) NOT NULL,
    Model VARCHAR(30) NOT NULL,
    [Year] INT NOT NULL,
    FlightHours INT NULL,
    Condition CHAR(1) NOT NULL,
    TypeId INT NOT NULL FOREIGN KEY REFERENCES AircraftTypes(Id)
)

CREATE TABLE PilotsAircraft
(
    AircraftId INT NOT NULL FOREIGN KEY REFERENCES Aircraft(Id),
    PilotId INT NOT NULL FOREIGN KEY REFERENCES Pilots(Id),
    PRIMARY KEY (AircraftId, PilotId)
)

CREATE TABLE Airports
(
    Id INT PRIMARY KEY IDENTITY,
    AirportName VARCHAR(70) NOT NULL UNIQUE,
    Country VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE FlightDestinations
(
    Id INT PRIMARY KEY IDENTITY,
    AirportId INT NOT NULL FOREIGN KEY REFERENCES Airports(Id),
    [Start] DATETIME NOT NULL,
    AircraftId INT NOT NULL FOREIGN KEY REFERENCES Aircraft(Id),
    PassengerId INT NOT NULL FOREIGN KEY REFERENCES Passengers(Id),
    TicketPrice DECIMAL(18,2) NOT NULL DEFAULT 15
)

--2)
GO

CREATE PROCEDURE udp_InsertPassengers
AS
BEGIN
    DECLARE @pilotId TINYINT;
    SET @pilotId = 5;
    WHILE @pilotId <= 15
    BEGIN

        DECLARE @passengersName VARCHAR(70);
        SET @passengersName = (
                                    SELECT
            CONCAT(p.FirstName, ' ', p.LastName) AS [FullName]
        FROM Pilots AS p
        WHERE p.Id = @pilotId
                              );
        DECLARE @passengersEmail VARCHAR(70);
        SET @passengersEmail = (
                                    SELECT
            CONCAT(p.FirstName, p.LastName, '@gmail.com') AS [Email]
        FROM Pilots AS p
        WHERE p.Id = @pilotId
                               );
        INSERT INTO Passengers
            (FullName, Email)
        VALUES
            (@passengersName, @passengersEmail)

        SET @pilotId = @pilotId + 1;
    END
END

GO

EXEC udp_InsertPassengers;

GO

--3)

UPDATE Aircraft
SET Aircraft.Condition = 'A'
WHERE Aircraft.Condition IN('C', 'B') AND
    (Aircraft.FlightHours IS NULL OR Aircraft.FlightHours BETWEEN 0 AND 100) AND
    Aircraft.[Year] >= 2013

--4)
DELETE FROM Passengers
WHERE LEN(Passengers.FullName) BETWEEN 0 AND 10

