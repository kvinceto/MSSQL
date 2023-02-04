USE Gringotts
GO

--1)
SELECT COUNT(w.Id)
FROM WizzardDeposits AS w

--2)
SELECT MAX(w.MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits AS w

--3)
SELECT
    w.DepositGroup,
    MAX(w.MagicWandSize) AS [LongestMagicWand]
FROM [WizzardDeposits] AS w
GROUP BY w.DepositGroup

--4)
SELECT TOP(2)
    [DepositGroup]
FROM [WizzardDeposits]
GROUP BY [DepositGroup]
ORDER BY AVG(MagicWandSize)

--5)
SELECT
    DepositGroup,
    SUM(DepositAmount)
FROM WizzardDeposits
GROUP BY DepositGroup

--6)
SELECT
    DepositGroup,
    SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits AS wd
WHERE wd.MagicWandCreator = 'Ollivander family'
GROUP BY wd.DepositGroup

--7)
SELECT *
FROM
    (
SELECT
        DepositGroup,
        SUM(DepositAmount) AS [TotalSum]
    FROM WizzardDeposits AS wd
    WHERE wd.MagicWandCreator = 'Ollivander family'
    GROUP BY wd.DepositGroup
) AS r
WHERE TotalSum < 150000
ORDER BY TotalSum DESC

--8)
SELECT
    DepositGroup,
    MagicWandCreator,
    MIN([DepositCharge]) AS [MinDepositCharge]
FROM WizzardDeposits AS wd
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup ASC

--9)
SELECT
    AgeGroup,
    COUNT(AgeGroup) AS [WizardCount]
FROM
    (
SELECT
        CASE
            WHEN Age <= 10 THEN '[0-10]'
            WHEN [Age] > 10 AND [Age] <= 20 THEN '[11-20]'
			WHEN [Age] > 20 AND [Age] <= 30 THEN '[21-30]'
			WHEN [Age] > 30 AND [Age] <= 40 THEN '[31-40]'
			WHEN [Age] > 40 AND [Age] <= 50 THEN '[41-50]'
			WHEN [Age] > 50 AND [Age] <= 60 THEN '[51-60]'
			ELSE '[61+]'
            END AS [AgeGroup]
    FROM WizzardDeposits
) AS a
GROUP BY AgeGroup

--10)
SELECT
    DISTINCT [FirstLetter]
FROM
    (
	SELECT
        SUBSTRING([FirstName], 1, 1) AS [FirstLetter]
    FROM [WizzardDeposits]
    WHERE [DepositGroup] = 'Troll Chest'
) AS [letters]

--11)
SELECT
    DepositGroup,
    IsDepositExpired,
    AVG(w.DepositInterest) AS [AverageInterest]
FROM WizzardDeposits AS w
WHERE w.DepositStartDate > '1985-01-01'
GROUP BY w.DepositGroup, w.IsDepositExpired
ORDER BY DepositGroup DESC, w.IsDepositExpired ASC

--12)

SELECT
    SUM(w1.[DepositAmount] - w2.[DepositAmount]) AS [SumDifference]
FROM [WizzardDeposits] AS [w1]
    LEFT JOIN [WizzardDeposits] AS [w2]
    ON w1.[Id] = w2.[Id] - 1

--13)
USE SoftUni
GO

SELECT
    e.DepartmentID,
    SUM(e.Salary) AS [TotalSalary]
FROM Employees AS e
GROUP BY e.DepartmentID

--14)
SELECT
    e.DepartmentID,
    MIN(e.Salary) AS [MinimumSalary]
FROM Employees AS e
WHERE e.DepartmentID IN(2,5,7) AND e.HireDate > '2000-01-01'
GROUP BY e.DepartmentID

--15)
GO

SELECT *
INTO [NewTable]
FROM Employees
WHERE Salary > 30000

DELETE 
FROM NewTable
WHERE ManagerID = 42

UPDATE NewTable
SET Salary += 5000
WHERE DepartmentID = 1

SELECT
    DepartmentID,
    AVG(Salary) AS [AverageSalary]
FROM NewTable
GROUP BY DepartmentID

GO

--16)

SELECT
    e.DepartmentID,
    MAX(e.Salary) AS [MaxSalary]
FROM Employees AS e
GROUP BY e.DepartmentID
HAVING MAX(e.Salary) NOT BETWEEN 30000 AND 70000

--17)
SELECT
    COUNT(e.Salary) AS [Count]
FROM Employees AS e
WHERE e.ManagerID IS NULL

--18)
SELECT
    t.DepartmentID,
    MAX(t.Salary) AS [ThirdHighestSalary]
FROM
    (
	SELECT
        e.DepartmentID,
        e.Salary,
        DENSE_RANK() OVER (PARTITION BY e.DepartmentID ORDER BY e.Salary DESC) AS [Rank]
    FROM Employees AS e
) AS [t]
WHERE [Rank] = 3
GROUP BY DepartmentID
--19)


SELECT TOP 10
	e.FirstName,
	e.LastName,
	e.DepartmentID
FROM Employees AS e
JOIN
(
	SELECT
		e.DepartmentID,
		AVG(e.Salary) AS [AverageSalary]
	FROM Employees AS e
	GROUP BY e.DepartmentID
) AS [AVER]
	ON e.DepartmentID = AVER.DepartmentID
WHERE e.Salary > AVER.AverageSalary