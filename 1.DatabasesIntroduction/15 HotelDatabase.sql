--15)
CREATE DATABASE Hotel;

CREATE TABLE Employees
(
    Id INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    Title VARCHAR(30) NOT NULL,
    Notes VARCHAR(MAX)
)

INSERT INTO Employees
VALUES
    ('firstName1', 'lastName1', 'title1', null),
    ('firstName2', 'lastName2', 'title2', null),
    ('firstName3', 'lastName3', 'title3', null)


CREATE TABLE Customers
(
    AccountNumber BIGINT PRIMARY KEY,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    PhoneNumber VARCHAR(10),
    EmergencyName VARCHAR(30),
    EmergencyNumber VARCHAR(10),
    Notes VARCHAR(MAX)
)

INSERT INTO Customers
VALUES
    (12345678910, 'fName1', 'lName1', null, null, null, null),
    (12345678911, 'fName2', 'lName2', 0878455755, null, null, null),
    (12345678912, 'fName3', 'lName3', 0879555444, null, null, null)

CREATE TABLE RoomStatus
(
    RoomStatus VARCHAR(10) NOT NULL PRIMARY KEY,
    Notes VARCHAR(MAX)
)

INSERT INTO RoomStatus
VALUES
    ('FREE', NULL),
    ('OCUPATE', NULL),
    ('VIP', NULL)

CREATE TABLE RoomTypes
(
    RoomType VARCHAR(10) NOT NULL PRIMARY KEY,
    Notes VARCHAR(MAX)
)

INSERT INTO RoomTypes
VALUES
    ('SINGLE', NULL),
    ('DOUBLE', NULL),
    ('APARTMENT', NULL)

CREATE TABLE BedTypes
(
    BedType VARCHAR(10) NOT NULL PRIMARY KEY,
    Notes VARCHAR(MAX)
)

INSERT INTO BedTypes
VALUES
    ('NORMAL', NULL),
    ('QUENSIZE', NULL),
    ('KINGSIZE', NULL)


CREATE TABLE Rooms
(
    RoomNumber TINYINT NOT NULL PRIMARY KEY,
    RoomType VARCHAR(10) NOT NULL FOREIGN KEY (RoomType) REFERENCES RoomTypes(RoomType),
    BedType VARCHAR(10) NOT NULL FOREIGN KEY (BedType) REFERENCES BedTypes(BedType),
    Rate DECIMAL(15,2) NOT NULL,
    RoomStatus VARCHAR(10) NOT NULL FOREIGN KEY (RoomStatus) REFERENCES RoomStatus(RoomStatus),
    Notes VARCHAR(MAX)
)

INSERT INTO Rooms
VALUES
    (25, 'SINGLE', 'QUENSIZE', 25.4, 'FREE', NULL),
    (26, 'SINGLE', 'QUENSIZE', 25.4, 'FREE', NULL),
    (27, 'SINGLE', 'QUENSIZE', 25.4, 'FREE', NULL)


CREATE TABLE Payments
(
    Id INT PRIMARY KEY IDENTITY,
    EmployeeId INT NOT NULL FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    PaymentDate DATETIME2 DEFAULT GETDATE(),
    AccountNumber BIGINT,
    FirstDateOccupied DATETIME2,
    LastDateOccupied DATETIME2,
    TotalDays TINYINT,
    AmountCharged DECIMAL(15,2) DEFAULT 0.00,
    TaxRate DECIMAL(15,2) DEFAULT 0.00,
    TaxAmount DECIMAL(15,2) DEFAULT 0.00,
    PaymentTotal DECIMAL(15,2) DEFAULT 0.00,
    Notes VARCHAR(MAX)
)

INSERT INTO Payments
VALUES
    (1, NULL, 12345678910, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
    (2, NULL, 12345678911, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
    (3, NULL, 12345678912, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)



CREATE TABLE Occupancies
(
    Id INT PRIMARY KEY IDENTITY,
    EmployeeId INT NOT NULL FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    DateOccupied DATETIME2 DEFAULT GETDATE(),
    AccountNumber BIGINT,
    RoomNumber TINYINT NOT NULL FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber),
    RateApplied DECIMAL(15,2) DEFAULT 0.00,
    PhoneCharge FLOAT(2),
    Notes VARCHAR(MAX)
)

INSERT INTO Occupancies (EmployeeId, AccountNumber, RoomNumber)
VALUES
    (1, NULL, 25),
    (2, NULL, 26),
    (3, NULL, 27)