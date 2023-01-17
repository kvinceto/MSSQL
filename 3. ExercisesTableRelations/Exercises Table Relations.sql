USE [master]
CREATE DATABASE [Table Relations]
GO

USE [Table Relations]

GO

--1)
CREATE TABLE [Passports]
(
    PassportID INT PRIMARY KEY IDENTITY(101, 1),
    PassportNumber VARCHAR(10) NOT NULL
)

CREATE TABLE [Persons]
(
    PersonID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(20) NOT NULL,
    Salary DECIMAL(15,2) NOT NULL,
    PassportID INT NOT NULL FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)
)

GO

INSERT INTO [Passports]
VALUES
    ('N34FG21B'),
    ('K65LO4R7'),
    ('ZE657QP2')

INSERT INTO [Persons]
VALUES
    ('Roberto', 43300.00, 102),
    ('Tom', 56100.00, 103),
    ('Yana', 60200.00, 101)

 GO

--2)
CREATE TABLE [Manufacturers]
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] VARCHAR(20) NOT NULL,
    EstablishedOn DATETIME NOT NULL
)

CREATE TABLE [Models]
(
    ModelID INT PRIMARY KEY IDENTITY(101, 1),
    [Name] VARCHAR(20) NOT NULL,
    ManufacturerID INT NOT NULL FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(Id)
)

GO

INSERT INTO [Manufacturers]
VALUES
    ('BMW', 07/03/1916),
    ('Tesla', 01/01/2003),
    ('Lada', 01/05/1966)

INSERT INTO [Models]
VALUES
    ('X1', 1),
    ('i6', 1),
    ('Model S', 2),
    ('Model X', 2),
    ('Model 3', 2),
    ('Nova', 3)

GO

--3)
CREATE TABLE [Students]
(
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    [Name] VARCHAR(20) NOT NULL
)

CREATE TABLE [Exams]
(
    ExamID INT PRIMARY KEY IDENTITY(101,1),
    [Name] VARCHAR(20) NOT NULL
)

CREATE TABLE [StudentsExams]
(
    StudentID INT NOT NULL FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    ExamID INT NOT NULL FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),
    CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentID, ExamID)
)

INSERT INTO [Students]
VALUES
    ('Mila'),
    ('Toni'),
    ('Ron')

INSERT INTO [Exams]
VALUES
    ('SpringMVC'),
    ('Neo4j'),
    ('Oracle 11g')

INSERT INTO [StudentsExams]
VALUES
    (1, 101),
    (1, 102),
    (2, 101),
    (3, 103),
    (2, 102),
    (2, 103)

GO

--4)
CREATE TABLE [Teachers]
(
    TeacherID INT NOT NULL PRIMARY KEY IDENTITY(101, 1),
    [Name] VARCHAR(20) NOT NULL,
    ManagerID INT NULL FOREIGN KEY (ManagerID) REFERENCES Teachers(TeacherID)
)

INSERT INTO [Teachers]
VALUES
    ('John', NUll),
    ('Maya', 106),
    ('Silvia', 106),
    ('Ted', 105),
    ('Mark', 101),
    ('Greta', 101)

GO

--5)
CREATE DATABASE [Online Store Database]

USE [Online Store Database]

CREATE TABLE [Cities]
(
    CityID INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] VARCHAR(20) NOT NULL
)

CREATE TABLE [Customers]
(
    CustomerID INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] VARCHAR(20) NOT NULL,
    Birthday DATE NOT NULL,
    CityID INT NOT NULL FOREIGN KEY (CityID) REFERENCES Cities(CityID)
)

CREATE TABLE [Orders]
(
    OrderID INT NOT NULL PRIMARY KEY IDENTITY,
    CustomerID INT FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

CREATE TABLE [ItemTypes]
(
    ItemTypeID INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] VARCHAR(20) NOT NULL
)

CREATE TABLE [Items]
(
    ItemID INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] VARCHAR(20) NOT NULL,
    ItemTypeID INT NOT NULL FOREIGN KEY (ItemTypeID) REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE [OrderItems]
(
    OrderID INT NOT NULL FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    ItemID INT NOT NULL FOREIGN KEY (ItemID) REFERENCES Items(ItemID),
    CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID, ItemID)
)

GO

--6)
CREATE DATABASE [University Database]

GO

USE [University Database]

CREATE TABLE [Majors]
(
    MajorID INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Students]
(
    StudentID INT NOT NULL PRIMARY KEY IDENTITY,
    StudentNumber VARCHAR(10) NOT NULL,
    StudentName VARCHAR(50) NOT NULL,
    MajorID INT NOT NULL FOREIGN KEY (MajorID) REFERENCES Majors(MajorID)
)

CREATE TABLE [Payments]
(
    PaymentID INT NOT NULL PRIMARY KEY IDENTITY,
    PaymentDate DATETIME2 NOT NULL,
    PaymentAmount DECIMAL(15,2) NOT NULL,
    StudentID INT NOT NULL FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
)

CREATE TABLE [Subjects]
(
    SubjectID INT NOT NULL PRIMARY KEY IDENTITY,
    SubjectName VARCHAR(50) NOT NULL
)

CREATE TABLE [Agenda]
(
    StudentID INT NOT NULL FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    SubjectID INT NOT NULL FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
    CONSTRAINT PK_Agenda PRIMARY KEY (StudentID, SubjectID)
)

GO

--9)

USE [Geography]

SELECT [Mountains].[MountainRange], [Peaks].[PeakName], [Peaks].[Elevation]
FROM [Mountains]
    JOIN [Peaks] ON [Mountains].[Id]  = [Peaks].[MountainId]
WHERE [Mountains].[MountainRange] = 'Rila'
ORDER BY [Peaks].[Elevation] DESC