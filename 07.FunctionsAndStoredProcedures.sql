USE SoftUni

GO
--Problem 01
   CREATE
       OR
    ALTER
PROCEDURE dbo.usp_GetEmployeesSalaryAbove35000
       AS (
	         SELECT FirstName,
			        LastName
			   FROM Employees
			  WHERE Salary > 35000

		  )

GO

EXEC dbo.usp_GetEmployeesSalaryAbove35000

GO

--Problem 02
   CREATE
       OR
    ALTER
PROCEDURE dbo.usp_GetEmployeesSalaryAboveNumber @minSalary DECIMAL(18,4)
       AS (
	         SELECT FirstName,
			        LastName
			   FROM Employees
			  WHERE Salary >= @minSalary

		  )

GO

--Problem 03
CREATE
OR
ALTER
PROCEDURE dbo.usp_GetTownsStartingWith @parameter VARCHAR(50)
AS
(
SELECT [Name]
AS Town
FROM Towns
WHERE SUBSTRING([Name], 1, LEN(@parameter)) = @parameter

)
GO
--Problem 04
   CREATE
       OR
    ALTER
PROCEDURE dbo.usp_GetEmployeesFromTown @townName VARCHAR(50)
       AS
	   (
	   SELECT e.FirstName,
	          e.LastName
		 FROM Employees
		   AS e
    LEFT JOIN Addresses
	       AS a
		   ON e.AddressID=a.AddressID
	LEFT JOIN Towns
	       AS t
		   ON a.TownID = t.TownID
		WHERE t.[Name] = @townName
	   )

GO
--Problem 05
CREATE
OR
ALTER
FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10) AS
BEGIN
DECLARE @result VARCHAR(10) = 'Average';

IF(@salary < 30000)
BEGIN
  SET @result = 'Low'
END

ELSE IF(@salary > 50000)
BEGIN
  SET @result = 'High'
END

RETURN @result
END

GO
--Problem 06
CREATE PROCEDURE usp_EmployeesBySalaryLevel (@levelOfSalary VARCHAR(7))
AS
SELECT FirstName,
       LastName
  FROM Employees
  WHERE dbo.ufn_GetSalaryLevel(Salary) = @levelOfSalary

  GO
--Problem 07
CREATE
OR
ALTER
FUNCTION dbo.ufn_IsWordComprised (@setOfLetters VARCHAR(100), @word VARCHAR(70))
RETURNS
BIT
AS
BEGIN
     DECLARE @wordIndex TINYINT = 1;
	 WHILE (@wordIndex <= LEN (@word))
	 BEGIN
	     DECLARE @currentLetter CHAR(1);
		 SET @currentLetter= SUBSTRING (@word, @wordIndex, 1);

		 IF(CHARINDEX(@currentLetter, @setOfLetters) = 0)
		 BEGIN
		     RETURN 0;
		 END

		 SET @wordIndex += 1;
		 END

		 RETURN 1;

		 END


GO

--Problem 08
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT NULL
	
	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN
	(
		SELECT EmployeeID FROM Employees
		WHERE DepartmentID = @departmentId
	)

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN
	(
		SELECT EmployeeID FROM Employees
		WHERE DepartmentID = @departmentId
	)
	
	UPDATE Departments
	SET ManagerID = NULL
	WHERE DepartmentID = @departmentId
	
 	DELETE FROM Employees
	WHERE DepartmentID = @departmentId

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId

	SELECT COUNT(*) FROM Employees
	WHERE DepartmentID = @departmentId
END

GO

USE Bank

GO
--Problem 09
CREATE PROCEDURE usp_GetHoldersFullName
AS
SELECT
CONCAT(FirstName, ' ', LastName) AS [Full Name]
FROM AccountHolders
GO
--Problem 10
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan (@number DECIMAL(18,4))
AS
SELECT
     ah.FirstName,
     ah.LastName
FROM AccountHolders AS ah
JOIN
(
          SELECT
               AccountHolderId,
               SUM(Balance) AS TotalMoney
          FROM Accounts
          GROUP BY AccountHolderId
) AS a ON ah.Id = a.AccountHolderId

WHERE a.TotalMoney > @number
ORDER BY ah.FirstName, ah.LastName

--Problem 11
CREATE
OR
ALTER
FUNCTION dbo.ufn_CalculateFutureValue (@initialSum DECIMAL (22,6), @interestRate FLOAT, @years INT)
RETURNS
DECIMAL(20,4)
AS
BEGIN
DECLARE @futureValue DECIMAL(22,6);
SET @futureValue = @initialSum * (POWER((1 + @interestRate), @years));

RETURN ROUND(@futureValue,4);
END
--Problem 12
   CREATE
       OR
    ALTER
PROCEDURE usp_CalculateFutureValueForAccount(@accId INT, @interestRate FLOAT)
AS
SELECT a.Id
      ,ah.FirstName AS [First Name]
	  ,ah.LastName AS [Last Name]
	  ,a.Balance AS [Current Balance]
	  ,dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, 5) AS [Balance in 5 years]
FROM AccountHolders AS ah
JOIN Accounts AS a ON ah.Id = a.AccountHolderId
WHERE a.Id = @accId

GO

USE Diablo

GO

--Problem 13
CREATE FUNCTION ufn_CashInUsersGames (@gameName VARCHAR(50))
RETURNS 
TABLE
AS
	RETURN SELECT
	SUM(Cash) AS SumCash
	FROM
	(
		SELECT 
			u.GameId,		
			u.Cash,
			ROW_NUMBER() OVER(ORDER BY u.Cash DESC) AS RowNumber
		FROM UsersGames AS u
		JOIN Games AS g ON u.GameId = g.Id	
		WHERE g.[Name] = @gameName
		GROUP BY u.GameId, u.Cash
	) AS t
	WHERE t.RowNumber % 2 = 1