USE NationalTouristSitesOfBulgaria
GO

--5)
SELECT
    t.Name,
    t.Age,
    t.PhoneNumber,
    t.Nationality
FROM Tourists AS t
ORDER BY t.Nationality ASC, t.Age DESC, t.Name ASC

--6)

SELECT
    sl.Site, sl.Location, sl.Establishment, c.Name AS [Category]
FROM
    (
    SELECT
        s.Name AS [Site], l.Name  AS [Location], s.Establishment, s.CategoryId
    FROM Sites AS s
        JOIN Locations AS l
        ON s.LocationId = l.Id
) AS sl
    JOIN Categories AS c
    ON sl.CategoryId = c.Id
ORDER BY Category DESC, [Location] ASC, [Site] ASC

--7)
SELECT
    l.Province,
    l.Municipality,
    l.Name AS [Location],
    COUNT(*) AS [CountOfSites]
FROM Locations AS l
    INNER JOIN Sites AS s
    ON l.Id = s.LocationId
WHERE l.Province = 'Sofia'
GROUP BY Province, Municipality, l.Name
ORDER BY [CountOfSites] DESC, l.Name

--8)
SELECT
    s.Name AS [Site],
    l.Name AS [Location],
    l.Municipality,
    l.Province,
    s.Establishment
FROM Sites AS s
    INNER JOIN Locations AS l
    ON s.LocationId = l.Id
WHERE s.Establishment LIKE '%BC%' AND
    s.Name NOT LIKE 'B%'AND
    s.Name NOT LIKE 'M%'AND
    s.Name NOT LIKE 'D%'
ORDER BY [Site]

--9)

SELECT
    t.Name,
    t.Age,
    t.PhoneNumber,
    t.Nationality,
    ISNULL(bp.Name, '(no bonus prize)') AS [Reward]
FROM Tourists AS t
    LEFT JOIN TouristsBonusPrizes AS tbp
    ON t.Id = tbp.TouristId
    LEFT JOIN BonusPrizes AS bp
    ON tbp.BonusPrizeId = bp.Id
ORDER BY t.Name

--10)

SELECT
    DISTINCT SUBSTRING(t.Name, CHARINDEX(' ', t.Name), LEN(t.Name) - CHARINDEX(' ', t.Name) + 1) AS [LastName],
    t.Nationality,
    t.Age,
    t.PhoneNumber
FROM
    (
SELECT s.Id AS SiteId
    FROM Categories AS c
        JOIN Sites AS s
        ON c.Id = s.CategoryId
    WHERE c.Name = 'History and archaeology'
) AS r
    INNER JOIN SitesTourists AS st
    ON r.SiteId = st.SiteId
    INNER JOIN Tourists AS t
    ON st.TouristId = t.Id
ORDER BY [LastName]

--11)
GO

CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(100)) 
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    SET @count = (
        SELECT
        COUNT(*)
    FROM SitesTourists
    WHERE SitesTourists.SiteId = 
                                    (
                                    SELECT Sites.Id
    FROM Sites
    WHERE Sites.Name = @Site
                                    )
                );
    RETURN @count
END

GO
SELECT dbo.udf_GetTouristsCountOnATouristSite ('Regional History Museum – Vratsa')

--12)
GO

CREATE PROCEDURE usp_AnnualRewardLottery(@TouristName VARCHAR(50))
AS
BEGIN

    DECLARE @count INT;
    SET @count = 
                (
                SELECT
                     COUNT(*)
                FROM SitesTourists AS st
                    LEFT JOIN Tourists AS t
                    ON st.TouristId = t.Id
                WHERE t.Name = @TouristName
                GROUP BY t.Name
                );
    DECLARE @reward VARCHAR(15);
    SET @reward = 
                CASE 
                    WHEN @count >= 100 THEN 'Gold badge'
                    WHEN @count >= 50 THEN 'Silver badge'
                    WHEN @count >= 25 THEN 'Bronze badge'
                    ELSE NULL 
                END

    UPDATE Tourists
    SET Tourists.Reward = @reward
    WHERE Tourists.Name = @TouristName

    SELECT Tourists.Name, Tourists.Reward
    FROM Tourists
    WHERE Tourists.Name = @TouristName
END

GO
EXEC usp_AnnualRewardLottery 'Gerhild Lutgard'
EXEC usp_AnnualRewardLottery 'Teodor Petrov'
EXEC usp_AnnualRewardLottery 'Zac Walsh'
EXEC usp_AnnualRewardLottery 'Brus Brown'
