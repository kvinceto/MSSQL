--17)
--18)
INSERT INTO Towns
VALUES
    ('Sofia'),
    ('Plovdiv'),
    ('Varna'),
    ('Burgas')

INSERT INTO Departments
VALUES
    ('Engineering'),
    ('Sales'),
    ('Marketing'),
    ('Software Development'),
    ('Quality Assurance')

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)
VALUES
    ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, 01/02/2013, 3500.00),
    ('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, 02/03/2004, 4000.00),
    ('Maria', 'Petrova', 'Ivanova', 'Intern', 5, 28/08/2016, 525.25),
    ('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, 09/12/2007., 3000.00),
    ('Peter', 'Pan', 'Pan', 'Intern', 3, 28/08/2016, 599.88)

    --19)
    SELECT * FROM Towns
    SELECT * FROM Departments
    SELECT * FROM Employees

    --20)
    SELECT * FROM Towns ORDER BY [Name] ASC
    SELECT * FROM Departments ORDER BY [Name] ASC
    SELECT * FROM Employees ORDER BY [Salary] DESC

    --21)
    SELECT [Name] FROM [Towns] ORDER BY [Name] ASC
    SELECT [Name] FROM Departments ORDER BY [Name] ASC
    SELECT [FirstName], [LastName], [JobTitle], [Salary] FROM Employees ORDER BY [Salary] DESC

    --22)
    UPDATE Employees SET Salary = Salary * 1.1
    SELECT [Salary] FROM [Employees]