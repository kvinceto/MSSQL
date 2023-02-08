--5)
USE Zoo
GO

SELECT
    v.Name,
    v.PhoneNumber,
    v.Address,
    v.AnimalId,
    v.DepartmentId
FROM Volunteers AS v
ORDER BY v.Name, v.AnimalId, v.DepartmentId

--6)

SELECT
    a.Name,
    [at].AnimalType,
    FORMAT(a.BirthDate, 'dd.MM.yyyy') AS [BirthDate]
FROM Animals AS a
    JOIN AnimalTypes AS [at]
    ON a.AnimalTypeId = at.Id
ORDER BY a.Name

--7)

SELECT TOP(5)
    o.Name,
    COUNT(*) AS [CountOfAnimals]
FROM Owners AS o
    JOIN Animals AS a
    ON o.Id = a.OwnerId
GROUP BY o.Name
ORDER BY CountOfAnimals DESC

--8)

SELECT
    CONCAT(o.Name, '-', a.Name) AS [OwnersAnimals],
    o.PhoneNumber,
    ac.CageId AS [CageId]
FROM Owners AS o
    JOIN Animals AS a
    ON o.Id = a.OwnerId
    JOIN AnimalsCages AS ac
    ON ac.AnimalId = a.Id
    JOIN AnimalTypes AS [at]
    ON a.AnimalTypeId = [at].Id
WHERE [at].[AnimalType] = 'Mammals'
ORDER BY o.Name, a.Name DESC

--9)

SELECT
    v.Name,
    v.PhoneNumber,
    TRIM(REPLACE(REPLACE(v.Address, 'Sofia', ''), ', ', '')) AS [Address]
FROM Volunteers AS v
WHERE v.DepartmentId = (
                            SELECT vd.Id
    FROM VolunteersDepartments AS vd
    WHERE vd.DepartmentName = 'Education program assistant'
                       )
    AND v.Address LIKE '%Sofia%'
ORDER BY v.Name

--10)

SELECT 
    a.Name,
     DATEPART(YEAR, a.BirthDate) AS [BirthYear] ,
    [at].AnimalType
FROM Animals AS a
JOIN AnimalTypes AS [at]
ON a.AnimalTypeId = [at].Id
WHERE a.OwnerId IS NULL AND DATEDIFF(YEAR,a.BirthDate,'01/01/2022') < 5
    AND a.AnimalTypeId <> (
                                SELECT AnimalTypes.Id
                                FROM AnimalTypes 
                                WHERE AnimalTypes.AnimalType = 'Birds'
                          )
ORDER BY a.Name

--11)
GO

CREATE FUNCTION udf_GetVolunteersCountFromADepartment (@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS 
BEGIN
        DECLARE @departmentId INT;
        SET @departmentId = (
                                SELECT VolunteersDepartments.Id
                                FROM VolunteersDepartments 
                                WHERE VolunteersDepartments.DepartmentName = @VolunteersDepartment
                            );
        DECLARE @result INT;
        SET @result = (
                            SELECT 
                                COUNT(*)
                            FROM Volunteers 
                            WHERE Volunteers.DepartmentId = @departmentId
                      );
        RETURN @result;
END

GO
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Guest engagement')
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Zoo events')

--12)

GO

CREATE PROCEDURE usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR(30))
AS
BEGIN
        SELECT 
            Animals.Name,
            ISNULL(Owners.Name, 'For adoption') AS [OwnersName]
        FROM Animals
        LEFT JOIN Owners 
        ON Animals.OwnerId = Owners.Id
        WHERE Animals.Name = @AnimalName
END

GO

EXEC usp_AnimalsWithOwnersOrNot 'Pumpkinseed Sunfish'
EXEC usp_AnimalsWithOwnersOrNot 'Hippo'
EXEC usp_AnimalsWithOwnersOrNot 'Brown bear'