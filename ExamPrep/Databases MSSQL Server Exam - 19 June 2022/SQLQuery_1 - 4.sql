CREATE DATABASE Zoo
GO

USE Zoo

GO
--DROP DATABASE Zoo
--GO
--1)


CREATE TABLE Owners
(
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    [Address] VARCHAR(50) NULL
)

CREATE TABLE AnimalTypes
(
    Id INT PRIMARY KEY IDENTITY,
    AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages
(
    Id INT PRIMARY KEY IDENTITY,
    AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
)

CREATE TABLE Animals
(
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(30) NOT NULL,
    BirthDate DATE NOT NULL,
    OwnerId INT NULL FOREIGN KEY REFERENCES Owners(Id),
    AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
)

CREATE TABLE AnimalsCages
(
    CageId INT NOT NULL FOREIGN KEY REFERENCES Cages(Id),
    AnimalId INT NOT NULL FOREIGN KEY REFERENCES Animals(Id)
        PRIMARY KEY (CageId, AnimalId)
)

CREATE TABLE VolunteersDepartments
(
    Id INT NOT NULL PRIMARY KEY IDENTITY,
    DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers
(
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    [Address] VARCHAR(50) NULL,
    AnimalId INT NULL FOREIGN KEY REFERENCES Animals(Id),
    DepartmentId INT NOT NULL FOREIGN KEY REFERENCES VolunteersDepartments(Id)
)


--2)
INSERT INTO Animals
    ([Name], BirthDate, OwnerId, AnimalTypeId)
VALUES
    ('Giraffe', '2018-09-21', 21, 1),
    ('Harpy Eagle', '2015-04-17', 15, 3),
    ('Hamadryas Baboon', '2017-11-02', NULL, 1),
    ('Tuatara', '2021-06-30', 2 , 4)

INSERT INTO Volunteers
    ([Name], PhoneNumber, [Address], AnimalId, DepartmentId)
VALUES
    ('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
    ('Dimitur Stoev', '0877564223', NULL, 42, 4),
    ('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.' , 9, 7),
    ('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
    ('Boryana Mileva', '0888112233', NULL, 31, 5)

--3)

UPDATE Animals
SET Animals.OwnerId = (
                        SELECT Owners.Id
FROM Owners
WHERE Owners.Name = 'Kaloqn Stoqnov'
                      )
WHERE Animals.OwnerId IS NULL

--4)



DELETE FROM Volunteers
WHERE Volunteers.DepartmentId = (
                                    SELECT VolunteersDepartments.Id
                                    FROM VolunteersDepartments
                                    WHERE VolunteersDepartments.DepartmentName = 'Education program assistant'
                                )

DELETE FROM VolunteersDepartments
WHERE VolunteersDepartments.DepartmentName = 'Education program assistant'

