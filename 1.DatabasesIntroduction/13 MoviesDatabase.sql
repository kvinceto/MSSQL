--13)
CREATE DATABASE Movies;

-- Directors (Id, DirectorName, Notes)
CREATE TABLE Directors(
    Id INT PRIMARY KEY IDENTITY, 
    DirectorName NVARCHAR(100) NOT NUll, 
    Notes NVARCHAR(MAX)
)
-- Genres (Id, GenreName, Notes)
CREATE TABLE Genres(
    Id INT PRIMARY KEY IDENTITY, 
    GenreName NVARCHAR(100) NOT NUll, 
    Notes NVARCHAR(MAX)
)
-- Categories (Id, CategoryName, Notes)
CREATE TABLE Categories(
    Id INT PRIMARY KEY IDENTITY, 
    CategoryName NVARCHAR(100) NOT NUll, 
    Notes NVARCHAR(MAX)
)
-- Movies (Id, Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
CREATE TABLE Movies(
    Id INT PRIMARY KEY IDENTITY, 
    Title NVARCHAR(100) NOT NULL,
    DirectorId INT NOt NULL,
    CopyrightYear DATETIME2,
    [Length] SMALLINT,
    GenreId INT NOT NUll,
    CategoryId INT NOT NULL,
    Rating TINYINT,
    Notes NVARCHAR(MAX)
)

INSERT INTO Directors
VALUES
    ('name1', NUll),
    ('name2', NUll),
    ('name3', NUll),
    ('name4', NUll),
    ('name5', NUll)

INSERT INTO Genres
VALUES
    ('ganreName1', NUll),
    ('ganreName2', NUll),
    ('ganreName3', NUll),
    ('ganreName4', NUll),
    ('ganreName5', NUll)

INSERT INTO Categories
VALUES
    ('categoryName1', NUll),
    ('categoryName2', NUll),
    ('categoryName3', NUll),
    ('categoryName4', NUll),
    ('categoryName5', NUll)

INSERT INTO Movies
VALUES
    ('title1', 1, NULL, NULL, 1, 1, NULL, 'notes'),
    ('title2', 2, NULL, NULL, 2, 2, NULL, 'notes'),
    ('title3', 3, NULL, NULL, 3, 3, NULL, 'notes'),
    ('title4', 4, NULL, NULL, 4, 4, NULL, 'notes'),
    ('title5', 5, NULL, NULL, 5, 5, NULL, 'notes')