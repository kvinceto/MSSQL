USE [master]
CREATE DATABASE NationalTouristSitesOfBulgaria
GO

--1)
CREATE TABLE Categories
(
    Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations
(
    Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    [Name] VARCHAR(50) NOT NULL,
    Municipality VARCHAR(50),
    Province VARCHAR(50)
)

CREATE TABLE Sites
(
    Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    [Name] VARCHAR(100) NOT NULL,
    LocationId INT NOT NULL FOREIGN KEY (LocationId) REFERENCES Locations(Id),
    CategoryId INT NOT NULL FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    Establishment VARCHAR(15)
)

CREATE TABLE Tourists
(
    Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    [Name] VARCHAR(50) NOT NULL,
    Age INT NOT NULL CHECK (Age >= 0 AND Age <= 120),
    PhoneNumber VARCHAR(20) NOT NULL,
    Nationality VARCHAR(30) NOT NULL,
    Reward VARCHAR(20)
)

CREATE TABLE SitesTourists
(
    TouristId INT NOT NULL FOREIGN KEY (TouristId) REFERENCES Tourists(Id),
    SiteId INT NOT NULL FOREIGN KEY (SiteId) REFERENCES Sites(Id)
        CONSTRAINT SitesTouristsPK PRIMARY KEY (TouristId, SiteId)
)

CREATE TABLE BonusPrizes
(
    Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    [Name] VARCHAR(50) NOT NULL,
)

CREATE TABLE TouristsBonusPrizes
(
    TouristId INT NOT NULL FOREIGN KEY (TouristId) REFERENCES Tourists(Id),
    BonusPrizeId INT NOT NULL FOREIGN KEY (BonusPrizeId) REFERENCES BonusPrizes(Id)
        CONSTRAINT TouristsBonusPrizesPK PRIMARY KEY (TouristId, BonusPrizeId)
)

GO

--2)
INSERT INTO Tourists
    ([Name], Age, PhoneNumber, Nationality, Reward)
VALUES
    ('Borislava Kazakova', 52, '+359896354244', 'Bulgaria', NULL),
    ('Peter Bosh', 48, '+447911844141', 'UK', NULL),
    ('Martin Smith', 29, '+353863818592', 'Ireland', 'Bronze badge'),
    ('Svilen Dobrev', 49, '+359986584786', 'Bulgaria', 'Silver badge'),
    ('Kremena Popova', 38, '+359893298604', 'Bulgaria', NULL);

INSERT INTO Sites
    ([Name], LocationId, CategoryId, Establishment)
VALUES
    ('Ustra fortress', 90, 7, 'X'),
    ('Karlanovo Pyramids', 65, 7, NULL),
    ('The Tomb of Tsar Sevt', 63, 8, 'V BC'),
    ('Sinite Kamani Natural Park', 17, 1, NULL),
    ('St. Petka of Bulgaria – Rupite', 92, 6, '1994');

--3)
UPDATE Sites 
SET  Sites.Establishment = '(not defined)'
WHERE Sites.Establishment IS NULL;

--4)
TRUNCATE table TouristsBonusPrizes;
DELETE FROM [dbo].BonusPrizes 
WHERE [Name] = 'Sleeping bag'
