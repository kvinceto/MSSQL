--USE [master]
--DROP DATABASE CigarShop
--GO

USE [CigarShop]
GO

--5)

SELECT
    c.CigarName,
    c.PriceForSingleCigar,
    c.ImageURL
FROM Cigars AS c
ORDER BY c.PriceForSingleCigar, c.CigarName DESC

--6)

SELECT
    c.Id,
    c.CigarName,
    c.PriceForSingleCigar,
    t.TasteType,
    t.TasteStrength
FROM Cigars AS c
    JOIN Tastes AS t
    ON c.TastId = t.Id
WHERE t.TasteType IN('Earthy', 'Woody')
ORDER BY c.PriceForSingleCigar DESC

--7)
SELECT
    c.Id,
    CONCAT(c.FirstName, ' ', c.LastName) AS [ClientName],
    c.Email
FROM Clients AS c
    LEFT JOIN ClientsCigars AS cc
    ON c.Id = cc.ClientId
WHERE cc.CigarId IS NULL
ORDER BY ClientName

--8)
SELECT TOP(5)
    c.CigarName,
    c.PriceForSingleCigar,
    c.ImageURL
FROM Cigars AS c
    JOIN Sizes AS s
    ON c.SizeId = s.Id
WHERE (s.Length >= 12 AND c.CigarName LIKE '%ci%')
    OR (c.PriceForSingleCigar > 50 AND s.RingRange > 2.55)
ORDER BY c.CigarName ASC, c.PriceForSingleCigar DESC

--9)
SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS [FullName],
    a.Country,
    a.ZIP,
    CONCAT('$', MAX(ci.PriceForSingleCigar)) AS [CigarPrice ]
FROM Clients AS c
    JOIN Addresses AS a
    ON c.AddressId = a.Id
    JOIN ClientsCigars AS cc
    ON cc.ClientId = c.Id
    JOIN Cigars AS ci
    ON cc.CigarId = ci.Id
WHERE ISNUMERIC(a.ZIP) = 1
GROUP BY c.FirstName, c.LastName, a.Country, a.ZIP
ORDER BY FullName

--10)
SELECT
    cl.LastName,
    CEILING(AVG(s.Length)) AS [CiagrLength],
    CEILING(AVG(s.RingRange)) AS [CiagrRingRange]
FROM Clients AS cl
    JOIN ClientsCigars AS cc
    ON cl.Id = cc.ClientId
    JOIN Cigars AS ci
    ON ci.Id = cc.CigarId
    JOIN Sizes AS s
    ON ci.SizeId = s.Id
GROUP BY cl.LastName
ORDER BY CiagrLength DESC

--11)

GO

CREATE FUNCTION udf_ClientWithCigars(@name NVARCHAR(30))
RETURNS INT
AS 
BEGIN
    DECLARE @count INT;
    SET @count = (SELECT
        COUNT(cc.CigarId)
    FROM Clients AS cl
        JOIN ClientsCigars AS cc
        ON cl.Id = cc.ClientId
    WHERE cl.FirstName = @name
    GROUP BY cl.FirstName)

    RETURN @count;
END
    
GO

SELECT dbo.udf_ClientWithCigars('Betty')

--12)

GO

CREATE PROCEDURE usp_SearchByTaste(@taste VARCHAR(20))
AS
BEGIN

    SELECT
        ci.CigarName,
        CONCAT('$', ci.PriceForSingleCigar) AS [Price],
        t.TasteType,
        b.BrandName,
        CONCAT(s.Length, ' cm') AS [CigarLength],
        CONCAT(s.RingRange, ' cm') AS [CigarRingRange]
    FROM Cigars AS ci
        JOIN Tastes AS t
        ON ci.TastId = t.Id
        JOIN Brands AS b
        ON ci.BrandId = b.Id
        JOIN Sizes AS s
        ON ci.SizeId = s.Id
    WHERE t.TasteType = @taste
    ORDER BY CigarLength ASC, CigarRingRange DESC

END

GO
EXEC usp_SearchByTaste 'Woody'
