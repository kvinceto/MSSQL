USE Softuni
GO

--1)
SELECT TOP(5)
	e.EmployeeID,
	e.JobTitle,
	e.AddressID,
	a.AddressText
FROM [Employees] AS e
	INNER JOIN [Addresses] AS a ON e.AddressID = a.AddressID
ORDER BY [AddressID] ASC

--2)
SELECT TOP(50)
	e.[FirstName],
	e.[LastName],
	t.[Name],
	a.[AddressText]
FROM [Employees] AS [e]
	JOIN [Addresses] AS [a]
	ON e.[AddressID] = a.[AddressID]
	JOIN [Towns] AS [t]
	ON a.[TownID] = t.[TownID]
ORDER BY e.[FirstName], e.[LastName]

--3)
SELECT e.[EmployeeID], e.[FirstName], e.[LastName], d.[Name]
FROM [Employees] AS e
	JOIN [Departments] AS d ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY EmployeeID ASC

--4)
SELECT TOP(5)
	e.[EmployeeID], e.[FirstName], e.[Salary], d.[Name]
FROM [Employees] AS e
	JOIN [Departments] AS d ON e.DepartmentID = d.DepartmentID
WHERE e.[Salary] > 15000
ORDER BY d.[DepartmentID] ASC

--5)
SELECT TOP(3)
	e.[EmployeeID], e.[FirstName]
FROM [Employees] AS e
	LEFT JOIN [EmployeesProjects] AS ep
	ON e.[EmployeeID] = ep.[EmployeeID]
WHERE ep.[ProjectID] IS NULL
ORDER BY EmployeeID

--6)
SELECT e.[FirstName], e.[LastName], e.[HireDate], d.[Name]
FROM [Employees] AS e
	JOIN [Departments] AS d
	ON e.DepartmentID = d.DepartmentID
WHERE [HireDate] > '1999-01-01' AND d.[Name] IN('Sales', 'Finance')
ORDER BY [HireDate] ASC

--7}
SELECT TOP(5)
	e.[EmployeeID], e.[FirstName], p.[Name]
FROM [Employees] AS e
	JOIN [EmployeesProjects] AS ep
	ON e.[EmployeeID] = ep.[EmployeeID]
	JOIN [Projects] AS p
	ON p.[ProjectID] = ep.[ProjectID]
WHERE p.[StartDate] > '2002-08-13' AND p.[EndDate] IS NULL
ORDER BY EmployeeID ASC

--8)
SELECT e.EmployeeID,
	e.FirstName,
	CASE 
		WHEN p.StartDate >= '2005-01-01' THEN NULL
		ELSE p.Name
	END AS ProjectName
FROM Employees AS e
	JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
	JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE e.EmployeeID = 24

--9)
SELECT e.EmployeeID, e.FirstName, e.ManagerID, e2.FirstName AS [ManagerName]
FROM Employees AS e
	JOIN Employees AS e2 ON e.ManagerID = e2.EmployeeID
WHERE e2.EmployeeID IN(3, 7)
ORDER BY EmployeeID ASC

--10)
SELECT TOP(50)
	e.EmployeeID,
	CONCAT(e.FirstName, ' ', e.LastName) AS [EmployeeName],
	CONCAT(e2.FirstName, ' ', e2.LastName) AS [ManagerName],
	d.Name AS [DepartmentName]
FROM Employees AS e
	JOIN Employees AS e2 ON e.ManagerID = e2.EmployeeID
	JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY EmployeeID ASC

--11)
SELECT
	MIN(a.AverageSalary) AS MinAverageSalary
FROM
	(
	SELECT
		e.DepartmentID,
		AVG(e.Salary) AS [AverageSalary]
	FROM Employees AS e
	GROUP BY e.DepartmentID
) AS a

GO
USE [Geography]

GO

--12)
SELECT c.CountryCode,
	m.MountainRange,
	p.PeakName,
	p.Elevation
FROM Countries AS c
	JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
	JOIN Mountains AS m ON m.Id = mc.MountainId
	JOIN Peaks AS p ON p.MountainId = m.Id
WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY Elevation DESC

--13)

SELECT
	mc.CountryCode,
	COUNT(m.MountainRange) AS [MountainRanges]
FROM MountainsCountries AS mc
	JOIN Mountains AS m
	ON mc.MountainId = m.Id
WHERE mc.CountryCode IN ('BG', 'RU', 'US')
GROUP BY mc.CountryCode

--14)
SELECT TOP(5)
	c.CountryName,
	r.RiverName
FROM Countries AS c
	LEFT JOIN CountriesRivers AS cr
	ON c.CountryCode = cr.CountryCode
	LEFT JOIN Rivers AS r
	ON cr.RiverId = r.Id
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

--15)

SELECT
	[r].ContinentCode,
	[r].CurrencyCode,
	[r].CurrencyUsage
FROM
	(
	SELECT
		c.[ContinentCode],
		c.[CurrencyCode],
		COUNT(c.[CurrencyCode]) AS [CurrencyUsage],
		DENSE_RANK() OVER
	  (
		PARTITION BY c.[ContinentCode] 
		ORDER BY COUNT(c.[CurrencyCode]) DESC
	  ) AS [CurrencyRank]
	FROM [Countries] AS [c]
	GROUP BY c.[ContinentCode],c.[CurrencyCode]
	HAVING COUNT(c.[CurrencyCode]) > 1
) AS [r]
WHERE [r].CurrencyRank = 1
ORDER BY [r].ContinentCode

--16)
SELECT
	COUNT(c.[CountryCode]) AS [Count]
FROM [Countries] AS [c]
	LEFT JOIN [MountainsCountries] AS [mc]
	ON c.[CountryCode] = mc.[CountryCode]
WHERE mc.MountainId IS NULL

--17)

SELECT TOP(5)
	c.[CountryName],
	MAX(p.[Elevation]) AS [HighestPeakElevation],
	MAX(r.[Length]) AS [LongestRiverLength]
FROM [Countries] AS [c]
JOIN [MountainsCountries] AS [mc]
	ON c.[CountryCode] = mc.[CountryCode] 
JOIN [Peaks] AS [p]
	ON p.[MountainId] = mc.[MountainId]
JOIN [CountriesRivers] AS [cr]
	ON cr.[CountryCode] = c.[CountryCode]
JOIN [Rivers] AS [r]
	ON r.[Id] = cr.[RiverId]
GROUP BY [CountryName]
ORDER BY 
	[HighestPeakElevation] DESC,
	[LongestRiverLength] DESC,
	[CountryName] ASC

--18)
SELECT TOP(5)
	[Country],
	CASE
		WHEN [PeakName] IS NULL THEN '(no highest peak)'
		ELSE [PeakName]
	END AS [Highest Peak Name],
	CASE
		WHEN [Elevation] IS NULL THEN 0
		ELSE [Elevation]
	END AS [Highest Peak Elevation],
	CASE
		WHEN [MountainRange] IS NULL THEN '(no mountain)'
		ELSE [MountainRange]
	END AS [Mountain]

FROM
(
	SELECT 
		c.[CountryName] AS [Country],
		m.[MountainRange],
		p.[PeakName],
		p.[Elevation],
		DENSE_RANK() OVER
		(
			PARTITION BY c.[CountryName] 
			ORDER BY p.[Elevation] DESC
		) AS [PeakRank]
	FROM [Countries] AS [c]
	LEFT JOIN [MountainsCountries] AS [mc]
		ON mc.[CountryCode] = c.[CountryCode]
	LEFT JOIN [Mountains] AS [m]
		ON mc.[MountainId] = m.[Id]
	LEFT JOIN [Peaks] AS [p]
		ON p.[MountainId] = m.[Id]
) AS [PeakRankingTable]
WHERE [PeakRank] = 1
ORDER BY [Country], [Highest Peak Name] 