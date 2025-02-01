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