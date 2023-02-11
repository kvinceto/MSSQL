--5)

USE [Service]
GO

SELECT
    r.[Description],
    FORMAT(r.OpenDate, 'dd-MM-yyyy') AS [OpenDate]
FROM Reports AS r
WHERE r.EmployeeId IS NULL
ORDER BY r.OpenDate ASC, r.[Description] DESC

--6)
SELECT
    r.[Description],
    c.Name
FROM Reports AS r
    JOIN Categories AS c
    ON r.CategoryId = c.Id
WHERE r.CategoryId IS NOT NULL
ORDER BY r.[Description] ASC, c.Name ASC

--7)
SELECT TOP(5)
    c.Name AS [CategoryName],
    COUNT(r.Id) AS [ReportsNumber]
FROM Reports AS r
    JOIN Categories AS c
    ON c.Id = r.CategoryId
GROUP BY c.Name
ORDER BY ReportsNumber DESC, c.Name ASC

--8)

SELECT
    u.Username,
    c.Name AS [CategoryName]
FROM Reports AS r
    JOIN Users AS u
    ON r.UserId = u.Id
    JOIN Categories AS c
    ON r.CategoryId = c.Id
WHERE DATEPART(MONTH, r.OpenDate) = DATEPART(MONTH, u.Birthdate)
    AND DATEPART(DAY, r.OpenDate) = DATEPART(DAY, u.Birthdate)
ORDER BY u.Username, c.Name

--9)

SELECT
    CONCAT(e.FirstName, ' ', e.LastName) AS [FullName],
    COUNT( DISTINCT r.UserId) AS [UsersCount]
FROM Employees AS e
    LEFT JOIN Reports AS r
    ON e.Id = r.EmployeeId
GROUP BY e.FirstName, e.LastName
ORDER BY UsersCount DESC, FullName ASC

--10)
SELECT
    ISNULL(CONCAT(e.FirstName, ' ', e.LastName),'None') AS [Employee],
    ISNULL(d.Name,'None')  AS [Department],
    ISNULL(c.Name,'None') AS [Category],
    ISNULL(r.[Description],'None')AS [Description],
    ISNULL(r.OpenDate,'None') AS [OpenDate],
    ISNULL(s.Label,'None') AS [Status],
    CASE 
        WHEN U.Name IS NULL THEN 'None'
        ELSE u.Name
    END  AS [User]
FROM Reports AS r
    LEFT JOIN Employees AS e
    ON r.EmployeeId = e.Id
    JOIN Departments AS d
    ON d.Id = e.DepartmentId
    JOIN Categories AS c
    ON c.Id = r.CategoryId
    JOIN [Status] AS s
    ON r.StatusId = s.Id
    JOIN Users AS u
    ON r.UserId = u.Id
ORDER BY e.FirstName DESC, e.LastName DESC, d.Name ASC, c.Name ASC, 
            r.[Description] ASC, r.OpenDate ASC, s.Label ASC, u.Name ASC

--11)
GO

CREATE PROCEDURE usp_AssignEmployeeToReport(@EmployeeId INT,
    @ReportId INT)
AS
BEGIN
    DECLARE @employeeDepartmentId INT;
    SET @employeeDepartmentId = (
                                    SELECT Employees.DepartmentId
                                    FROM Employees
                                    WHERE Employees.Id = @EmployeeId
                                );
    DECLARE @reportDepartmentId INT;
    SET @reportDepartmentId = (
                                SELECT Categories.DepartmentId
                                FROM Reports 
                                JOIN Categories
                                ON Reports.CategoryId = Categories.Id
                                WHERE Reports.Id = @ReportId
                              );

    IF (@employeeDepartmentId <> @reportDepartmentId)
    BEGIN
        ;THROW 50001, 'Employee doesn''t belong to the appropriate department!', 1
    END

    UPDATE Reports
    SET Reports.EmployeeId = @EmployeeId
    WHERE Reports.Id = @ReportId
END

GO

EXEC usp_AssignEmployeeToReport 30, 1

EXEC usp_AssignEmployeeToReport 17, 2