GO

USE SoftUni

GO

--Problem 01
SELECT TOP 5
e.EmployeeID,
e.JobTitle,
e.AddressID,
a.AddressText
FROM Employees AS e
JOIN Addresses AS a
ON e.AddressID = a.AddressID
ORDER BY e.AddressID

--Problem 02 
SELECT TOP 50
e.FirstName,
e.LastName,
t.[Name] AS Town,
a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID=a.AddressID
JOIN Towns AS t ON a.TownID=t.TownID
ORDER BY FirstName,LastName ASC

--Problem 03
SELECT 
e.EmployeeID,
e.FirstName,
e.LastName,
d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID=d.DepartmentID
WHERE d.[Name]='Sales'
ORDER BY e.EmployeeID

--Problem 04
SELECT TOP 5
e.EmployeeID,
e.FirstName,
e.Salary,
d.Name
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID=d.DepartmentID
WHERE e.Salary>15000
ORDER BY e.DepartmentID

--Problem 05
SELECT TOP 3
e.EmployeeID,
e.FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep
ON ep.EmployeeID = e.EmployeeID
WHERE ep.ProjectID IS NULL
ORDER BY e.EmployeeID

--Problem 06
SELECT
e.FirstName,
e.LastName,
e.HireDate,
d.[Name] AS DeptName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID=d.DepartmentID
WHERE
e.HireDate>'1999-01-01'
AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.HireDate ASC

--Problem 07
SELECT TOP 5
ep.EmployeeID,
e.FirstName,
p.[Name]
FROM EmployeesProjects AS ep
JOIN Employees AS e
ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p
ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > '08/13/2002'
AND p.EndDate IS NULL
ORDER BY ep.EmployeeID

--Problem 08
SELECT 
    e.EmployeeID, 
    e.FirstName, 
    CASE 
        WHEN p.StartDate >= '2005-01-01' THEN NULL 
        ELSE p.Name
    END AS ProjectName
FROM EmployeesProjects AS ep
JOIN Employees AS e ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24;

--Problem 09
SELECT e1.EmployeeID,
e1.FirstName,
e1.ManagerID,
e2.FirstName AS ManagerName
FROM Employees AS e1
LEFT JOIN Employees AS e2
ON e1.ManagerID=e2.EmployeeID
WHERE e1.ManagerID IN (3,7)
ORDER BY e1.EmployeeID

--Problem 10
SELECT TOP 50
e.EmployeeID
,CONCAT_WS(' ', e.FirstName, e.LastName) AS EmployeeName
,CONCAT_WS(' ', m.FirstName, m.LastName) AS ManagerName
,d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID=d.DepartmentID
JOIN Employees AS m ON e.ManagerID=m.EmployeeID
ORDER BY e.EmployeeID ASC

--Problem 11
SELECT MIN(avs.MinAvgSalary) AS MinAverageSalary FROM
(SELECT
    AVG(Salary) AS MinAvgSalary
	FROM Employees
	GROUP BY DepartmentID) AS avs

--Problem 12
SELECT mc.CountryCode
      ,m.MountainRange
	  ,P.PeakName
	  ,p.Elevation
FROM Mountains AS m
JOIN Peaks AS p ON m.Id = p.MountainId
JOIN MountainsCountries AS mc ON mc.MountainId = m.Id
WHERE p.Elevation > 2835 AND mc.CountryCode = 'BG'
ORDER BY p.Elevation DESC

--Problem 13
GO

USE Geography

GO

SELECT c.CountryCode,
COUNT (mc.MountainId)
AS MountainRanges
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
ON mc.CountryCode=c.CountryCode
WHERE c.CountryName IN ('United States', 'Russia', 'Bulgaria')
GROUP BY c.CountryCode

--Problem 14 
SELECT TOP(5)
       c.CountryName
      ,r.RiverName
FROM Countries AS c
       LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
	   LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
	   WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

--Problem 15 
SELECT 
    ContinentCode,
    CurrencyCode,
    CurrencyUsage
FROM (
    SELECT 
        cu.ContinentCode,
        cu.CurrencyCode,
        cu.CurrencyUsage,
        DENSE_RANK() OVER (PARTITION BY cu.ContinentCode ORDER BY cu.CurrencyUsage DESC) AS CurrencyRank
    FROM (
        SELECT 
            cn.ContinentCode,
            c.CurrencyCode,
            COUNT(*) AS CurrencyUsage
        FROM Continents AS cn
        LEFT JOIN Countries AS c 
            ON c.ContinentCode = cn.ContinentCode
        GROUP BY cn.ContinentCode, c.CurrencyCode
        HAVING COUNT(*) > 1
    ) AS cu
) AS rankedCurrencies
WHERE CurrencyRank = 1
ORDER BY ContinentCode;

--Problem 16
SELECT COUNT(*) FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
WHERE mc.CountryCode IS NULL

--Problem 17
SELECT TOP(5) 
      c.CountryName
     ,CASE WHEN p.Elevation = NULL
	  THEN NULL
	  ELSE MAX(p.Elevation)
	  END AS HighestPeakElevation

	  ,CASE WHEN r.[Length] = NULL
	  THEN NULL
	  ELSE MAX(r.[Length])
	  END AS LongestRiverLength
FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Peaks AS p ON mc.MountainId = p.MountainId
JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
JOIN Rivers AS r ON cr.RiverId = r.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName