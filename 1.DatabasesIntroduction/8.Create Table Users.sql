USE [MINIONS]

CREATE TABLE [Users]
(
		[Id] INT PRIMARY KEY IDENTITY,
		[Username] VARCHAR(30) NOT NULL,
		[Password] VARCHAR(26) NOT NULL,
		[ProfilePicture] IMAGE,
		[LastLoginTime] DATETIME2,
		[IsDeleted] BIT 
)

INSERT INTO [Users] VALUES
		('User1', 'Pass1', NULL, NULL, 0),
		('User2', 'Pass2', NULL, NULL, 1),
		('User3', 'Pass3', NULL, NULL, 0),
		('User4', 'Pass4', NULL, NULL, 1),
		('User5', 'Pass5', NULL, NULL, 0)