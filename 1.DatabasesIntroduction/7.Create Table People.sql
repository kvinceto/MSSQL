USE [MINIONS]

CREATE TABLE [People]
(
		[Id] INT PRIMARY KEY IDENTITY,
		[Name] VARCHAR(200) NOT NULL,
		[Picture] IMAGE,
		[Height] DECIMAL(3, 2),
		[Weight] DECIMAL(4, 2),
		[Gender] CHAR(1) NOT NULL,
		[Birthdate] DATE NOT NULL,
		[Biography] NVARCHAR(MAX),
)

INSERT INTO [People] VALUES
		('Alex', NULL, 1.78, 82.00, 'm', '1993-06-01', 'Alex biography'),
		('Beth', NULL, 1.65, 62.00, 'f', '1996-08-11', 'Beth biography'),
		('Carl', NULL, 1.82, 92.00, 'm', '1991-02-25', 'Carl biography'),
		('Dexter', NULL, 1.92, 95.00, 'm', '1986-06-15', 'Dexter biography'),
		('Eve', NULL, 1.67, 51.00, 'f', '1992-05-24', 'Eve biography')