--Problem 01
CREATE TRIGGER tr_AddToLogsOnAccountUpdate
ON [Accounts] FOR UPDATE
AS
INSERT INTO [Logs] VALUES
(
	(SELECT [Id] FROM inserted), 
	(SELECT [Balance] FROM deleted), 
	(SELECT [Balance] FROM inserted)
)

--Problem 02
CREATE TRIGGER tr_CreateNewEmailOnNewLogEntry
ON Logs FOR INSERT
AS
INSERT INTO [NotificationEmails] VALUES
(
	(SELECT AccountId FROM inserted),
	(SELECT 'Balance change for account: ' + CAST(AccountId AS VARCHAR(255)) FROM inserted),
	(SELECT 'On ' + 
			FORMAT(GETDATE(), 'MMM dd yyyy h:mmtt') + 
			' your balance was changed from ' + 
			CAST(OldSum AS VARCHAR(255)) + 
			' to ' + 
			CAST(NewSum AS VARCHAR(255)) + 
			'.' 
	FROM inserted)
)

--Problem 03
CREATE PROC usp_DepositMoney
(@accountId INT, @moneyAmount DECIMAL(18, 4))
AS
	IF (@moneyAmount < 0) THROW 50001, 'Invalid amount', 1
	UPDATE Accounts
	SET Balance += @moneyAmount
	WHERE Id = @accountId

--Problem 04
 CREATE PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount MONEY)
     AS
  BEGIN TRANSACTION
 UPDATE Accounts
    SET Balance -= @MoneyAmount
  WHERE Id = @AccountId
DECLARE @LeftBalance MONEY = (SELECT Balance FROM Accounts WHERE Id = @AccountId)
	 IF(@LeftBalance < 0)
	  BEGIN
	   ROLLBACK
	   RAISERROR('',16,2)
	   RETURN
	  END
COMMIT
--Problem 05

CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount MONEY)
AS
BEGIN TRANSACTION
EXEC usp_DepositMoney @ReceiverId, @Amount
EXEC usp_WithdrawMoney @SenderId, @Amount
COMMIT
 
 --Problem 08
CREATE PROC usp_AssignProject
(@emloyeeId INT, @projectID INT)
AS
BEGIN TRANSACTION
	DECLARE @projectsCount INT =
	(
		SELECT
			COUNT(ProjectID)
		FROM EmployeesProjects
		WHERE EmployeeID = @emloyeeId
	)

	IF (@projectsCount >= 3) 
	BEGIN
		RAISERROR('The employee has too many projects!', 16, 1)
		ROLLBACK		
	END

	INSERT INTO EmployeesProjects VALUES
		(@emloyeeId, @projectID)
COMMIT TRANSACTION

--Problem 09
CREATE TRIGGER tr_AddEntityToDeletedEmployeesTable
ON Employees FOR DELETE
AS
INSERT INTO Deleted_Employees
	SELECT		
		FirstName,
		LastName,
		MiddleName,
		JobTitle,
		DepartmentID,
		Salary
	FROM deleted