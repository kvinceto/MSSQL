USE [master]
CREATE DATABASE CigarShop
GO

USE CigarShop
GO

--1)
CREATE TABLE Sizes
(
    Id INT PRIMARY KEY IDENTITY,
    [Length] INT NOT NULL CHECK ([Length] >= 10 AND [Length] <= 25),
    RingRange DECIMAL(4,2) CHECK (RingRange >= 1.5 AND RingRange <= 7.5)
)

CREATE TABLE Tastes
(
    Id INT PRIMARY KEY IDENTITY,
    TasteType VARCHAR(20) NOT NULL,
    TasteStrength VARCHAR(15) NOT NULL,
    ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Brands
(
    Id INT PRIMARY KEY IDENTITY,
    BrandName VARCHAR(30) NOT NULL UNIQUE,
    BrandDescription VARCHAR(MAX) NULL
)

CREATE TABLE Cigars
(
    Id INT PRIMARY KEY IDENTITY,
    CigarName VARCHAR(80) NOT NULL,
    BrandId INT NOT NULL FOREIGN KEY REFERENCES Brands(Id),
    TastId INT NOT NULL FOREIGN KEY REFERENCES Tastes(Id),
    SizeId INT NOT NULL FOREIGN KEY REFERENCES Sizes(Id),
    PriceForSingleCigar DECIMAL(18,2) NOT NULL,
    ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Addresses
(
    Id INT PRIMARY KEY IDENTITY,
    Town VARCHAR(30) NOT NULL,
    Country NVARCHAR(30) NOT NULL,
    Streat NVARCHAR(100) NOT NULL,
    ZIP VARCHAR(20) NOT NULL
)

CREATE TABLE Clients
(
    Id INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NOT NULL,
    Email NVARCHAR(50) NOT NULL,
    AddressId INT NOT NULL FOREIGN KEY REFERENCES Addresses(Id)
)

CREATE TABLE ClientsCigars
(
    ClientId INT NOT NULL FOREIGN KEY REFERENCES Clients(Id),
    CigarId INT NOT NULL FOREIGN KEY REFERENCES Cigars(Id)
        PRIMARY KEY (ClientId, CigarId)
)

--2)
INSERT INTO Cigars
    (CigarName, BrandId, TastId, SizeId, PriceForSingleCigar, ImageURL)
VALUES
    ('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg'),
    ('COHIBA SIGLO I', 9, 1, 10, 410, 'cohiba-siglo-i-stick_12.jpg'),
    ('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg'),
    ('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32, 'hoyo-de-san-juan-stick_20.jpg'),
    ('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses
    (Town, Country, Streat, ZIP)
VALUES
    ('Sofia', 'Bulgaria', '18 Bul. Vasil levski', '1000'),
    ('Athens', 'Greece', '4342 McDonald Avenue', '10435'),
    ('Zagreb', 'Croatia', '4333 Lauren Drive', '10000')

--3)
UPDATE Cigars
SET Cigars.PriceForSingleCigar += Cigars.PriceForSingleCigar * 0.2
WHERE Cigars.TastId = (
                    SELECT t.Id
                    FROM Tastes AS t
                    WHERE t.TasteType = 'Spicy'
                      )

--4)

DELETE 
FROM ClientsCigars
WHERE ClientsCigars.ClientId IN(
                    SELECT c.Id
                    FROM Clients AS c 
                    WHERE c.AddressId IN(
                        SELECT a.Id
                        FROM Addresses AS a 
                        WHERE a.Country LIKE 'C%')
                    )

DELETE
FROM Clients
WHERE Clients.AddressId  IN(
                         SELECT a.Id
                         FROM Addresses AS a 
                         WHERE a.Country LIKE 'C%'
                         )

DELETE
FROM Addresses
WHERE Addresses.Country LIKE 'C%'