USE [master]

GO

DROP DATABASE Boardgames
GO


CREATE DATABASE Boardgames

GO

--1)
USE Boardgames
GO


CREATE TABLE Categories
(
    Id INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses
(
    Id INT NOT NULL PRIMARY KEY IDENTITY,
    StreetName NVARCHAR(100) NOT NULL,
    StreetNumber INT NOT NULL,
    Town VARCHAR(30) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    ZIP INT NOT NULL
)

CREATE TABLE Publishers
(
    Id INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] VARCHAR(30) NOT NULL UNIQUE,
    AddressId INT NOT NULL FOREIGN KEY REFERENCES Addresses(Id),
    Website NVARCHAR(40) NULL,
    Phone NVARCHAR(20) NULL
)

CREATE TABLE PlayersRanges
(
    Id INT NOT NULL PRIMARY KEY IDENTITY,
    PlayersMin INT NOT NULL,
    PlayersMax INT NOT NULL
)

CREATE TABLE Boardgames
(
    Id INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(30) NOT NULL,
    YearPublished INT NOT NULL,
    Rating DECIMAL(18,2) NOT NULL,
    CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
    PublisherId INT NOT NULL FOREIGN KEY REFERENCES Publishers(Id),
    PlayersRangeId INT NOT NULL FOREIGN KEY REFERENCES PlayersRanges(Id)
)

CREATE TABLE Creators
(
    Id INT NOT NULL PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(30) NULL,
    LastName NVARCHAR(30) NULL,
    Email NVARCHAR(30) NULL
)

CREATE TABLE CreatorsBoardgames
(
    CreatorId INT NOT NULL FOREIGN KEY REFERENCES Creators(Id),
    BoardgameId INT NOT NULL FOREIGN KEY REFERENCES Boardgames(Id)
        PRIMARY KEY(CreatorId, BoardgameId)
)

--2)

INSERT INTO Publishers
    ([Name], AddressId, Website, Phone)
VALUES
    ('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
    ('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
    ('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')

INSERT INTO Boardgames
    ([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
VALUES
    ('Deep Blue', 2019, 5.67, 1, 15, 7),
    ('Paris', 2016, 9.78, 7, 1, 5),
    ('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
    ('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
    ('One Small Step', 2019, 5.75, 5, 9, 2)

--3)

UPDATE PlayersRanges
SET PlayersRanges.PlayersMax += 1
WHERE PlayersRanges.PlayersMin >= 2 AND PlayersRanges.PlayersMax <= 2

UPDATE Boardgames
SET Boardgames.Name = CONCAT(Boardgames.Name, 'V2')
WHERE Boardgames.YearPublished >= 2020

--4)

DELETE
FROM CreatorsBoardgames 
WHERE BoardgameId IN
(
SELECT b.Id
FROM Boardgames AS b 
WHERE b.PublisherId IN
(
SELECT p.Id
FROM Publishers AS p
WHERE p.AddressId IN
(
SELECT a.Id
FROM Addresses AS a
WHERE a.Country IN
(
SELECT a.Country
FROM Addresses AS a
WHERE a.Town LIKE 'L%'
)
)  
)
)

DELETE
FROM Boardgames
WHERE PublisherId IN
(
SELECT p.Id
FROM Publishers AS p
WHERE p.AddressId IN
(
SELECT a.Id
FROM Addresses AS a
WHERE a.Country IN
(
SELECT a.Country
FROM Addresses AS a
WHERE a.Town LIKE 'L%'
)
)  
)

DELETE
FROM Publishers
WHERE AddressId IN
(
SELECT a.Id
FROM Addresses AS a
WHERE a.Country IN
(
SELECT a.Country
FROM Addresses AS a
WHERE a.Town LIKE 'L%'
)
)

DELETE
FROM Addresses
WHERE Country IN
(
SELECT a.Country
FROM Addresses AS a
WHERE a.Town LIKE 'L%'
)