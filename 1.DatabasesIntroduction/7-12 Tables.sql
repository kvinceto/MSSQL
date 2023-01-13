--7)
CREATE TABLE People(
    Id INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(200) NOT NULL,
    Picture VARBINARY(MAX),
    Height FLOAT(2),
    [Weight] FLOAT(2),
    Gender CHAR(1) NOT NULL,
    Birthdate DATETIME2 NOT NULL,
    Biography NVARCHAR(MAX)
)

INSERT INTO People
VALUES
('Ivan',    NULL, 1.80, 80.2, 'm', '2020-12-23 15:40:45', NULL),
('Petar',   NULL, 1.80, 80.2, 'm', '2020-12-23 15:40:45', NULL),
('Georgi',  NULL, 1.80, 80.2, 'm', '2020-12-23 15:40:45', NULL),
('Dimitar', NULL, 1.80, 80.2, 'm', '2020-12-23 15:40:45', NULL),
('Maria',   NULL, 1.80, 80.2, 'f', '2020-12-23 15:40:45', NULL)

--8)
CREATE TABLE Users(
    Id INT PRIMARY KEY IDENTITY,
    Username VARCHAR(30) NOT NULL,
    [Password] VARCHAR(26) NOT NULL,
    ProfilePicture VARBINARY(MAX),
    LastLoginTime DATETIME2,
    IsDeleted BIT
)

INSERT INTO Users
VALUES
    ('Ivan1', '1234567890', NULL, NUll, NUll),
    ('Ivan2', '1234567890', NULL, NUll, NUll),
    ('Ivan3', '1234567890', NULL, NUll, NUll),
    ('Ivan4', '1234567890', NULL, NUll, NUll),
    ('Ivan5', '1234567890', NULL, NUll, NUll)

--9)
ALTER TABLE [Users]
	DROP CONSTRAINT PK_Users

ALTER TABLE [Users]
	ADD CONSTRAINT PK_Users 
	PRIMARY KEY (Id, Username)

--10)
ALTER TABLE [Users]
ADD CONSTRAINT Check_Password 
	CHECK (LEN([Password]) >= 5)

--11)
ALTER TABLE [Users]
ADD CONSTRAINT df_LastLoginTime
DEFAULT GETDATE() FOR [LastLoginTime]
--12)
ALTER TABLE [Users]
DROP PK__Users__3214EC07326EBEC6

ALTER TABLE [Users]
ADD CONSTRAINT PK__Users__3214EC07326EBEC6 PRIMARY KEY (Id) ;

ALTER TABLE [Users]
ADD CONSTRAINT CHK_Usernames CHECK (LEN(Username) >= 3)