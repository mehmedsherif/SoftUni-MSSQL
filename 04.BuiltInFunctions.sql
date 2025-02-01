USE SoftUni

GO
--Problem 01
SELECT FirstName,
       LastName
FROM Employees
WHERE FirstName LIKE 'Sa%'

--Problem 02
SELECT FirstName,
       LastName 
FROM Employees
WHERE LastName LIKE '%ei%'

--Problem 03
SELECT FirstName
FROM Employees
WHERE (DepartmentID) IN (3,10)
AND DATEPART(YEAR,HireDate) BETWEEN 1995 AND 2005 


--Problem 04
SELECT FirstName,
       LastName
FROM Employees
WHERE CHARINDEX('engineer', JobTitle)=0

--Problem 05
SELECT [Name]
FROM Towns
WHERE LEN ([Name]) IN (5,6)
ORDER BY [Name]

--Problem 06
SELECT *
FROM Towns
WHERE LEFT ([Name],1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name]
--Problem 07
SELECT * FROM [Towns]
WHERE LEFT([Name], 1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]

--Problem 08
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName FROM Employees
WHERE DATEPART(YEAR, HireDate) > 2000

--Problem 09
SELECT FirstName, LastName FROM Employees
WHERE LEN(LastName) = 5

--Problem 10
SELECT EmployeeID,
       FirstName,
	   LastName,
	   Salary,
	   DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID)
	   AS Rank
       FROM Employees
	   WHERE Salary BETWEEN 10000 AND 50000
	ORDER BY Salary DESC

--Problem 11
CREATE VIEW v_EmployeesRankedByEmployeeID
AS
(
SELECT EmployeeID,
       FirstName,
	   LastName,
	   Salary,
	   DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID)
	   AS Rank
       FROM Employees
	   WHERE Salary BETWEEN 10000 AND 50000
)
SELECT *
FROM dbo.v_EmployeesRankedByEmployeeID
WHERE Rank = 2
ORDER BY Salary DESC

--second

SELECT * 
FROM
(
SELECT EmployeeID,
       FirstName,
	   LastName,
	   Salary,
	   DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID)
	   AS Rank
       FROM Employees
	   WHERE Salary BETWEEN 10000 AND 50000
)
AS e
WHERE Rank = 2
ORDER BY Salary DESC

--Problem 12
SELECT [CountryName], [IsoCode]
FROM [Countries]
WHERE [CountryName] LIKE '%a%a%a%'
ORDER BY [IsoCode]

--Problem 13
SELECT 
    p.PeakName,
    r.RiverName,
    LOWER(CONCAT(SUBSTRING(p.PeakName, 1, LEN(p.PeakName) - 1), r.RiverName)) AS Mix
FROM 
    Peaks AS p
JOIN 
    Rivers AS r 
ON 
    RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
ORDER BY 
    Mix;
--Problem 14

SELECT TOP(50) 
	 [Name], 	
	 FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM [Games]
WHERE YEAR([Start]) IN (2011, 2012)
ORDER BY [Start], [Name]

--Problem 15
USE Diablo
SELECT Username,
SUBSTRING ([Email], CHARINDEX('@', [Email])+1, LEN([Email])-CHARINDEX('@', [Email]))
AS [Email Provider]
FROM Users
ORDER BY [Email Provider], [Username]

--Problem 16

SELECT Username, IpAddress
FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--Problem 17
SELECT
   [Name] AS Game,
   CASE 
      WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
      WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
      WHEN DATEPART(HOUR, [Start]) BETWEEN 18 AND 24 THEN 'Evening'
   END AS [Part of the day],

   CASE
      WHEN Duration <= 3 THEN 'Extra Short'
      WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
      WHEN Duration > 6 THEN 'Long'
      WHEN Duration IS NULL THEN 'Extra Long'
   END AS [Duration]
FROM Games
ORDER BY Game, Duration, [Part of the day]

--Problem 18
SELECT ProductName, OrderDate,
       DATEADD(DAY, 3, OrderDate) AS [Pay Due],
       DATEADD(MONTH, 1, OrderDate) AS [Deliver Due]
FROM Orders