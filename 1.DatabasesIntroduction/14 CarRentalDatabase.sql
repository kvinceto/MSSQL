--14)
CREATE DATABASE CarRental;

CREATE TABLE Categories
(
    Id INT PRIMARY KEY IDENTITY,
    CategoryName NVARCHAR(50) NOT NULL,
    DailyRate DECIMAL(15,2) NOT NULL,
    WeeklyRate DECIMAL(15,2) NOT NULL,
    MonthlyRate DECIMAL(15,2) NOT NULL,
    WeekendRate DECIMAL(15,2) NOT NULL
)

INSERT INTO Categories
VALUES
    ('categoryName1', 20.50, 100.75, 500.50, 35.40),
    ('categoryName2', 20.50, 100.75, 500.50, 35.40),
    ('categoryName3', 20.50, 100.75, 500.50, 35.40)


CREATE TABLE Cars
(
    Id INT PRIMARY KEY IDENTITY,
    PlateNumber VARCHAR(10) NOT NULL,
    Manufacturer VARCHAR(50) NOT NULL,
    Model VARCHAR(30) NOT NULL,
    CarYear VARCHAR(4) NOT NULL,
    CategoryId INT NOT NULL FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    Doors TINYINT,
    Picture VARBINARY(MAX),
    Condition VARCHAR(100),
    Available BIT NOT NULL
)

INSERT INTO Cars
VALUES
    ('0001', 'FIRM1', 'MODEL1', '2001', 1, 4, NULL, NULL, 1),
    ('0002', 'FIRM2', 'MODEL2', '2002', 2, 2, NULL, NULL, 0),
    ('0003', 'FIRM3', 'MODEL3', '2003', 3, 2, NULL, NULL, 1)

CREATE TABLE Employees
(
    Id INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NOT NULL,
    Title NVARCHAR(30) NOT NULL,
    Notes NVARCHAR(MAX)
)

INSERT INTO Employees
VALUES
    ('firstName1', 'lastName1', 'title1', NULL),
    ('firstName2', 'lastName2', 'title2', 'note'),
    ('firstName3', 'lastName3', 'title3', NULL)

CREATE TABLE Customers
(
    Id INT PRIMARY KEY IDENTITY,
    DriverLicenceNumber VARCHAR(10) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    [Address] VARCHAR(100),
    City VARCHAR(20) NOT NULL,
    ZIPCode CHAR(4),
    Notes VARCHAR(MAX)
)

INSERT INTO Customers
VALUES
    ('1234567891', 'fullName1', NULL, 'Varna', '9000', NULL),
    ('1234567892', 'fullName2', 'addres', 'Varna', '9000', NULL),
    ('1234567893', 'fullName3', NULL, 'Varna', '9000', NULL)

CREATE TABLE RentalOrders
(
    Id INT PRIMARY KEY IDENTITY,
    EmployeeId INT NOT NULL FOREIGN KEY  (EmployeeId) REFERENCES Employees(Id),
    CustomerId INT NOT NULL FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
    CarId INT NOT NULL FOREIGN KEY (CarId) REFERENCES Cars(Id),
    TankLevel FLOAT(2),
    KilometrageStart VARCHAR(6) NOT NULL,
    KilometrageEnd VARCHAR(6) NOT NULL,
    TotalKilometrage VARCHAR(6) NOT NULL,
    StartDate DATETIME2,
    EndDate DATETIME2,
    TotalDays TINYINT,
    RateApplied DECIMAL(15,2),
    TaxRate DECIMAL(15,2),
    OrderStatus BIT,
    Notes VARCHAR(MAX)
)

INSERT INTO RentalOrders
VALUES
    (1, 1, 1, 0.75, 100000, 200000, 100000, NULL, NULL, NULL, NULL, NULL, 0, NULL),
    (2, 2, 2, 0.75, 100000, 200000, 100000, NULL, NULL, NULL, NULL, NULL, 0, NULL),
    (3, 3, 3, 0.75, 100000, 200000, 100000, NULL, NULL, NULL, NULL, NULL, 0, NULL)