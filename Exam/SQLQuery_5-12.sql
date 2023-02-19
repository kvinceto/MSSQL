USE Boardgames
GO

--5)

SELECT
    b.Name,
    b.Rating
FROM Boardgames AS b
ORDER BY b.YearPublished ASC, b.Name DESC

--6)

SELECT
    b.Id,
    b.Name,
    b.YearPublished,
    c.Name AS [CategoryName]
FROM Boardgames AS b
    JOIN Categories AS c
    ON b.CategoryId = c.Id
WHERE b.CategoryId IN
(
SELECT c.Id
FROM Categories AS c
WHERE c.Name IN('Strategy Games', 'Wargames')
)
ORDER BY b.YearPublished DESC

--7)

SELECT
    c.Id,
    CONCAT(c.FirstName, ' ', c.LastName) AS [CreatorName],
    c.Email
FROM Creators AS c
    LEFT JOIN CreatorsBoardgames AS cb
    ON c.Id = cb.CreatorId
WHERE cb.BoardgameId IS NULL
ORDER BY CreatorName ASC

--8)

SELECT TOP(5)
    b.Name,
    b.Rating,
    c.Name AS [CategoryName]
FROM Boardgames AS b
    JOIN PlayersRanges AS pr
    ON b.PlayersRangeId = pr.Id
    JOIN Categories AS c
    ON b.CategoryId = c.Id
WHERE (b.Rating > 7.00 AND b.Name LIKE '%a%') OR
    (b.Rating > 7.50 AND (pr.PlayersMin >= 2 AND pr.PlayersMax <= 5))
ORDER BY b.Name ASC, b.Rating DESC

--9)


SELECT
    FullName,
    Email,
    MAX(Rating) AS [Rating]
FROM
    (
SELECT
        c.Id,
        CONCAT(c.FirstName, ' ', c.LastName) AS [FullName],
        c.Email
    FROM Creators AS c
    WHERE C.Email LIKE '%.com'
) AS cr
    LEFT JOIN CreatorsBoardgames AS cb
    ON cr.Id = cb.CreatorId
    JOIN Boardgames AS b
    ON b.Id = cb.BoardgameId
GROUP BY FullName, cr.Email
ORDER BY FullName ASC

--10)

SELECT
    LastName,
    CEILING(AVG(b.Rating)) AS [AverageRating],
    p.Name AS [PublisherName]
FROM CreatorsBoardgames AS cb
    JOIN Creators AS c
    ON cb.CreatorId = c.Id
    JOIN Boardgames AS b
    ON cb.BoardgameId = b.Id
    JOIN Publishers AS p
    ON p.Id = b.PublisherId
WHERE p.Name = 'Stonemaier Games'
GROUP BY c.LastName, b.Rating, p.Name
ORDER BY CASE 
    WHEN LastName = 'Leacock' THEN 1
    WHEN LastName = 'Matsuuchi' THEN 2
    WHEN LastName = 'Pfister' THEN 3
    WHEN LastName = 'Cathala' THEN 4
    WHEN LastName = 'Rosenberg' THEN 5
    ELSE 6 END


--11)

GO

CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(30))
RETURNS INT
AS 
BEGIN
    DECLARE @count INT;
    SET @count = 
    (
    SELECT
        COUNT( DISTINCT cb.BoardgameId )
    FROM Creators AS c
        LEFT JOIN CreatorsBoardgames AS cb
        ON c.Id = cb.CreatorId
    WHERE c.FirstName = @name
    );

    RETURN @count;
END

GO

SELECT dbo.udf_CreatorWithBoardgames('Bruno')

--12)

GO

CREATE PROCEDURE usp_SearchByCategory(@category VARCHAR(50))
AS
BEGIN

    SELECT 
        b.Name,
        b.YearPublished,
        b.Rating,
        c.Name AS [CategoryName],
        p.Name AS [PublisherName],
        CONCAT(pr.PlayersMin, ' people') AS [MinPlayers],
        CONCAT(pr.PlayersMax, ' people') AS [MaxPlayers]
    FROM Boardgames AS b
        JOIN Categories AS c
        ON b.CategoryId = c.Id
        JOIN PlayersRanges AS pr 
        ON b.PlayersRangeId = pr.Id
        JOIN Publishers AS p 
        ON b.PublisherId = p.Id
    WHERE c.Name = 'Wargames'
    ORDER BY p.Name ASC, b.YearPublished DESC

END

GO
