USE SoftUni
GO


--1)


CREATE PROCEDURE [usp_GetEmployeesSalaryAbove35000]
AS
BEGIN
    SELECT
        e.FirstName,
        e.LastName
    FROM Employees AS e
    WHERE e.Salary > 35000
END

EXEC [usp_GetEmployeesSalaryAbove35000]

GO
--2)
CREATE PROCEDURE [usp_GetEmployeesSalaryAboveNumber]
    @number DECIMAL(18,4)
AS
BEGIN
    SELECT
        e.FirstName,
        e.LastName
    FROM Employees AS e
    WHERE e.Salary >= @number
END

EXEC [usp_GetEmployeesSalaryAboveNumber] 48100
GO

--3)

CREATE PROCEDURE [usp_GetTownsStartingWith]
    @string VARCHAR(50)
AS
BEGIN
    SELECT
        t.Name AS [Town]
    FROM Towns AS t
    WHERE SUBSTRING(t.Name, 1, LEN(@string)) = @string
END

EXEC [usp_GetTownsStartingWith] 'B'
GO

--4)

CREATE OR ALTER PROC usp_GetEmployeesFromTown
    (@townName VARCHAR(50))
AS
SELECT
    e.[FirstName] AS [First Name],
    e.[LastName] AS [Last Name]
FROM [Employees] AS [e]
    JOIN [Addresses] AS [a] ON e.[AddressID] = a.[AddressID]
    JOIN [Towns] AS [t] ON a.[TownID] = t.[TownID]
WHERE t.[Name] = @townName

EXEC [usp_GetEmployeesFromTown] 'Sofia'

GO

--5)

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(7)
BEGIN
    RETURN  CASE 
        WHEN @salary < 30000 THEN 'Low'
        WHEN @salary >= 30000 AND @salary <= 50000 THEN 'Average'
        WHEN @salary > 50000 THEN'High'
    END
End

GO

--6)

CREATE PROCEDURE usp_EmployeesBySalaryLevel
    @salaryLevel VARCHAR(7)
AS
BEGIN
    SELECT
        e.FirstName,
        e.LastName
    FROM Employees AS e
    WHERE [dbo].ufn_GetSalaryLevel(e.Salary) = @salaryLevel
END

EXEC [dbo].usp_EmployeesBySalaryLevel 'High'
GO

--7)
CREATE FUNCTION ufn_IsWordComprised
(@setOfLetters VARCHAR(50), @word VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @counter INT = 1
    WHILE (@counter <= LEN(@word))
	BEGIN
        IF @setOfLetters NOT LIKE '%' + SUBSTRING(@word, @counter, 1) + '%' RETURN 0
        SET @counter += 1
    END
    RETURN 1
END

GO

--8)
CREATE PROC usp_DeleteEmployeesFromDepartment
    (@departmentId INT)
AS
BEGIN
    ALTER TABLE [Departments]
	ALTER COLUMN [ManagerID] INT NULL

    DELETE FROM [EmployeesProjects]	
	WHERE [EmployeeID] IN
	(
		SELECT [EmployeeID]
    FROM [Employees]
    WHERE [DepartmentID] = @departmentId
	)

    UPDATE [Employees]
	SET [ManagerID] = NULL
	WHERE [ManagerID] IN
	(
		SELECT [EmployeeID]
    FROM [Employees]
    WHERE [DepartmentID] = @departmentId
	)

    UPDATE [Departments]
	SET [ManagerID] = NULL
	WHERE [DepartmentID] = @departmentId

    DELETE FROM [Employees]
	WHERE [DepartmentID] = @departmentId

    DELETE FROM [Departments]
	WHERE [DepartmentID] = @departmentId

    SELECT COUNT(*)
    FROM [Employees]
    WHERE [DepartmentID] = @departmentId
END

GO

--9)
USE Bank
GO

CREATE PROCEDURE usp_GetHoldersFullName
AS
BEGIN
    SELECT
        CONCAT(ah.FirstName, ' ', ah.LastName) AS [Full Name]
    FROM AccountHolders AS ah
END

EXEC usp_GetHoldersFullName 

GO

--10)

CREATE PROC usp_GetHoldersWithBalanceHigherThan
    (@number DECIMAL(18,4))
AS
SELECT
    a.FirstName,
    a.LastName
FROM AccountHolders AS a
    JOIN
    (
		SELECT
        AccountHolderId,
        SUM(Balance) AS TotalMoney
    FROM Accounts
    GROUP BY AccountHolderId
	) AS acc ON a.Id = acc.AccountHolderId
WHERE acc.TotalMoney > @number
ORDER BY a.FirstName, a.LastName

GO

--11)
CREATE FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(18,4), @yearlyInterestRate FLOAT, @years INT )
RETURNS DECIMAL(18,4)
AS 
    BEGIN

    RETURN @sum * POWER(1 + @yearlyInterestRate, @years)
END

GO

--12)
CREATE PROC usp_CalculateFutureValueForAccount
    (@accountId INT,
    @annualRate FLOAT)
AS
SELECT
    acc.[Id] AS [Account Id],
    h.[FirstName] AS [First Name],
    h.[LastName] AS [Last Name],
    acc.[Balance] AS [Current Balance],
    dbo.ufn_CalculateFutureValue(acc.[Balance], @annualRate, 5) AS [Balance in 5 years]
FROM [Accounts] AS [acc]
    JOIN [AccountHolders] AS [h]
    ON acc.[AccountHolderId] = h.[Id]
WHERE acc.[Id] = @accountId
GO

--13
USE Diablo
GO

