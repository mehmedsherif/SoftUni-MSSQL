--Problem 01
CREATE DATABASE [Minions]

GO

USE [Minions]

GO
--Problem 02
CREATE TABLE [Minions](
[Id] INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
[Age] INT

)

CREATE TABLE [Towns](
[Id] INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(85) NOT NULL

)

--Problem 03
--Alter is command to update STRUCTURE and CONSTRAINTS of the Table
ALTER TABLE [Minions]
ADD [TownId] INT

ALTER TABLE [Minions]
ADD CONSTRAINT [FK_Minions_Towns_Id]
FOREIGN KEY ([TownID]) REFERENCES [Towns]([Id])

--Problem 04

INSERT INTO [Towns]([Id], [Name])
VALUES
(1,'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO [Minions]([Id], [Name], [Age], [TownId])
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

--Problem 05
--TRUNCATE = Factory Reset = Delete All Data
TRUNCATE TABLE [Minions]
--Problem 07
CREATE TABLE People (
    Id INT PRIMARY KEY IDENTITY(1,1), 
    Name NVARCHAR(200) NOT NULL,
    Picture VARBINARY(MAX), 
    Height DECIMAL(4,2), 
    Weight DECIMAL(5,2),
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('m', 'f')),
    Birthdate DATE NOT NULL,
    Biography NVARCHAR(MAX)
);

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES
('John Doe', NULL, 1.80, 75.50, 'm', '1990-05-15', 'John is a software engineer from California.'),
('Jane Smith', NULL, 1.65, 62.30, 'f', '1985-08-22', 'Jane is a graphic designer with a love for art.'),
('Alice Brown', NULL, 1.70, 68.20, 'f', '1992-03-12', 'Alice enjoys outdoor activities and photography.'),
('Bob Johnson', NULL, 1.75, 80.10, 'm', '1988-11-30', 'Bob is a fitness enthusiast and a personal trainer.'),
('Eve Davis', NULL, 1.60, 55.40, 'f', '1995-07-08', 'Eve is a student studying environmental science.');

--Problem 08
CREATE TABLE [Users](
[Id] BIGINT PRIMARY KEY IDENTITY NOT NULL,
[Username] VARCHAR(30) UNIQUE NOT NULL,
[Password] VARCHAR(26) NOT NULL,
[ProfilePicture] VARBINARY(MAX),
[LastLoginTime] DATETIME2,
[IsDeleted] BIT

)
INSERT INTO [Users] ([Username], [Password], [ProfilePicture], [LastLoginTime], [IsDeleted])
VALUES
('Pesho', '123456', NULL, GETDATE(), NULL),
('Gosho', '12345678', NULL, GETUTCDATE(), 0),
('Ivan', '1234', NULL, NULL, 1),
('Dragan', '123456789', NULL, NULL, 0),
('Mariq', '123', NULL, GETDATE(), 1)

--Problem 09
ALTER TABLE [Users]
DROP [PK__Users__3214EC079650E24E]

ALTER TABLE [Users]
ADD CONSTRAINT [PK_Composite_Id_Username]
PRIMARY KEY([Id],[Username])

--Problem 10
ALTER TABLE [Users]
ADD CONSTRAINT [CK_Password_Min_Length_5]
CHECK(LEN([Password]) >=5)

--Problem 11
ALTER TABLE [Users]
ADD CONSTRAINT [DF_LastLoginTime_Current_Time]
DEFAULT GETDATE() FOR [LastLoginTime]
--Problem 13
-- Create the Movies database entities

-- Create Directors table
CREATE TABLE Directors (
    Id INT PRIMARY KEY IDENTITY(1,1),
    DirectorName NVARCHAR(100) NOT NULL,
    Notes NVARCHAR(MAX)
);

-- Create Genres table
CREATE TABLE Genres (
    Id INT PRIMARY KEY IDENTITY(1,1),
    GenreName NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(MAX)
);

-- Create Categories table
CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(MAX)
);

-- Create Movies table
CREATE TABLE Movies (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200) NOT NULL,
    DirectorId INT NOT NULL FOREIGN KEY REFERENCES Directors(Id),
    CopyrightYear INT NOT NULL CHECK (CopyrightYear >= 1800),
    Length INT CHECK (Length > 0), -- Length in minutes
    GenreId INT NOT NULL FOREIGN KEY REFERENCES Genres(Id),
    CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
    Rating DECIMAL(2,1) CHECK (Rating BETWEEN 0.0 AND 10.0),
    Notes NVARCHAR(MAX)
);

-- Insert records into Directors
INSERT INTO Directors (DirectorName, Notes)
VALUES
('Steven Spielberg', 'Famous for Jurassic Park, E.T., and Schindler''s List'),
('Christopher Nolan', 'Known for Inception, Interstellar, and The Dark Knight'),
('Quentin Tarantino', 'Director of Pulp Fiction and Kill Bill'),
('Martin Scorsese', 'Renowned for The Irishman and Goodfellas'),
('James Cameron', 'Known for Titanic and Avatar');

-- Insert records into Genres
INSERT INTO Genres (GenreName, Notes)
VALUES
('Action', 'High-energy and explosive sequences'),
('Drama', 'Focus on emotional narratives'),
('Comedy', 'Designed to make audiences laugh'),
('Sci-Fi', 'Themes of science and futuristic settings'),
('Horror', 'Designed to scare and thrill');

-- Insert records into Categories
INSERT INTO Categories (CategoryName, Notes)
VALUES
('Feature Film', 'Full-length movies usually over 40 minutes'),
('Short Film', 'Movies shorter than 40 minutes'),
('Documentary', 'Non-fictional storytelling'),
('Animated', 'Primarily created using animation techniques'),
('Independent', 'Produced outside of major studio systems');

-- Insert records into Movies
INSERT INTO Movies (Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
VALUES
('Jurassic Park', 1, 1993, 127, 1, 1, 8.2, 'A groundbreaking dinosaur adventure'),
('Inception', 2, 2010, 148, 4, 1, 8.8, 'A mind-bending thriller about dreams'),
('Pulp Fiction', 3, 1994, 154, 2, 1, 8.9, 'An iconic film with nonlinear storytelling'),
('The Irishman', 4, 2019, 209, 2, 1, 7.8, 'A deep dive into mob history'),
('Avatar', 5, 2009, 162, 4, 1, 7.9, 'A visual masterpiece set on Pandora');

--Problem 14
-- Create Categories table
CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(50) NOT NULL,
    DailyRate DECIMAL(10, 2) NOT NULL,
    WeeklyRate DECIMAL(10, 2) NOT NULL,
    MonthlyRate DECIMAL(10, 2) NOT NULL,
    WeekendRate DECIMAL(10, 2) NOT NULL
);

-- Create Cars table
CREATE TABLE Cars (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PlateNumber VARCHAR(15) UNIQUE NOT NULL,
    Manufacturer VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    CarYear INT NOT NULL,
    CategoryId INT NOT NULL,
    Doors INT NOT NULL,
    Picture NVARCHAR(MAX),
    Condition VARCHAR(50) NOT NULL,
    Available BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
);

-- Create Employees table
CREATE TABLE Employees (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Title VARCHAR(50) NOT NULL,
    Notes NVARCHAR(MAX)
);

-- Create Customers table
CREATE TABLE Customers (
    Id INT PRIMARY KEY IDENTITY(1,1),
    DriverLicenceNumber VARCHAR(20) UNIQUE NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Address VARCHAR(150) NOT NULL,
    City VARCHAR(50) NOT NULL,
    ZIPCode VARCHAR(10) NOT NULL,
    Notes NVARCHAR(MAX)
);

-- Create RentalOrders table
CREATE TABLE RentalOrders (
    Id INT PRIMARY KEY IDENTITY(1,1),
    EmployeeId INT NOT NULL,
    CustomerId INT NOT NULL,
    CarId INT NOT NULL,
    TankLevel DECIMAL(3, 1) NOT NULL,
    KilometrageStart INT NOT NULL,
    KilometrageEnd INT,
    TotalKilometrage INT,
    StartDate DATE NOT NULL,
    EndDate DATE,
    TotalDays INT,
    RateApplied DECIMAL(10, 2) NOT NULL,
    TaxRate DECIMAL(4, 2) NOT NULL,
    OrderStatus VARCHAR(50) NOT NULL,
    Notes NVARCHAR(MAX),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
    FOREIGN KEY (CarId) REFERENCES Cars(Id)
);

-- Insert records into Categories
INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES
('Economy', 30.00, 200.00, 700.00, 50.00),
('SUV', 60.00, 400.00, 1400.00, 100.00),
('Luxury', 100.00, 700.00, 2500.00, 150.00);

-- Insert records into Cars
INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
VALUES
('ABC123', 'Toyota', 'Corolla', 2020, 1, 4, NULL, 'Good', 1),
('XYZ789', 'Ford', 'Explorer', 2021, 2, 4, NULL, 'Excellent', 1),
('LMN456', 'Mercedes', 'S-Class', 2022, 3, 4, NULL, 'New', 1);

-- Insert records into Employees
INSERT INTO Employees (FirstName, LastName, Title, Notes)
VALUES
('John', 'Doe', 'Manager', 'Experienced manager with 10 years in car rentals'),
('Jane', 'Smith', 'Sales Representative', NULL),
('Emily', 'Jones', 'Technician', 'Specialized in car maintenance');

-- Insert records into Customers
INSERT INTO Customers (DriverLicenceNumber, FullName, Address, City, ZIPCode, Notes)
VALUES
('DL12345', 'Michael Brown', '123 Elm St', 'Springfield', '12345', NULL),
('DL67890', 'Sarah Wilson', '456 Oak Ave', 'Lincoln', '67890', 'Preferred customer'),
('DL11223', 'David Johnson', '789 Pine Dr', 'Fairview', '11223', NULL);

-- Insert records into RentalOrders
INSERT INTO RentalOrders (EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes)
VALUES
(1, 1, 1, 0.8, 10000, 10200, 200, '2025-01-01', '2025-01-03', 2, 30.00, 0.07, 'Completed', 'No issues during the rental'),
(2, 2, 2, 1.0, 2000, 2200, 200, '2025-01-05', '2025-01-07', 2, 60.00, 0.07, 'Completed', NULL),
(3, 3, 3, 0.5, 500, NULL, NULL, '2025-01-10', NULL, NULL, 100.00, 0.07, 'Ongoing', 'Customer extended the rental period');
--Problem 15
-- Create Employees table
CREATE TABLE Employees (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Title VARCHAR(50) NOT NULL,
    Notes NVARCHAR(MAX)
);

-- Create Customers table
CREATE TABLE Customers (
    AccountNumber INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    EmergencyName VARCHAR(50),
    EmergencyNumber VARCHAR(15),
    Notes NVARCHAR(MAX)
);

-- Create RoomStatus table
CREATE TABLE RoomStatus (
    RoomStatus VARCHAR(50) PRIMARY KEY,
    Notes NVARCHAR(MAX)
);

-- Create RoomTypes table
CREATE TABLE RoomTypes (
    RoomType VARCHAR(50) PRIMARY KEY,
    Notes NVARCHAR(MAX)
);

-- Create BedTypes table
CREATE TABLE BedTypes (
    BedType VARCHAR(50) PRIMARY KEY,
    Notes NVARCHAR(MAX)
);

-- Create Rooms table
CREATE TABLE Rooms (
    RoomNumber INT PRIMARY KEY,
    RoomType VARCHAR(50) NOT NULL,
    BedType VARCHAR(50) NOT NULL,
    Rate DECIMAL(10, 2) NOT NULL,
    RoomStatus VARCHAR(50) NOT NULL,
    Notes NVARCHAR(MAX),
    FOREIGN KEY (RoomType) REFERENCES RoomTypes(RoomType),
    FOREIGN KEY (BedType) REFERENCES BedTypes(BedType),
    FOREIGN KEY (RoomStatus) REFERENCES RoomStatus(RoomStatus)
);

-- Create Payments table
CREATE TABLE Payments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    EmployeeId INT NOT NULL,
    PaymentDate DATE NOT NULL,
    AccountNumber INT NOT NULL,
    FirstDateOccupied DATE NOT NULL,
    LastDateOccupied DATE NOT NULL,
    TotalDays INT NOT NULL,
    AmountCharged DECIMAL(10, 2) NOT NULL,
    TaxRate DECIMAL(4, 2) NOT NULL,
    TaxAmount DECIMAL(10, 2) NOT NULL,
    PaymentTotal DECIMAL(10, 2) NOT NULL,
    Notes NVARCHAR(MAX),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    FOREIGN KEY (AccountNumber) REFERENCES Customers(AccountNumber)
);

-- Create Occupancies table
CREATE TABLE Occupancies (
    Id INT PRIMARY KEY IDENTITY(1,1),
    EmployeeId INT NOT NULL,
    DateOccupied DATE NOT NULL,
    AccountNumber INT NOT NULL,
    RoomNumber INT NOT NULL,
    RateApplied DECIMAL(10, 2) NOT NULL,
    PhoneCharge DECIMAL(10, 2),
    Notes NVARCHAR(MAX),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
    FOREIGN KEY (AccountNumber) REFERENCES Customers(AccountNumber),
    FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber)
);

-- Insert records into Employees
INSERT INTO Employees (FirstName, LastName, Title, Notes)
VALUES
('John', 'Doe', 'Manager', 'Oversees hotel operations'),
('Jane', 'Smith', 'Receptionist', 'Handles check-ins and check-outs'),
('Emily', 'Jones', 'Housekeeping', 'Ensures rooms are clean and tidy');

-- Insert records into Customers
INSERT INTO Customers (FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes)
VALUES
('Michael', 'Brown', '123-456-7890', 'Sarah Brown', '987-654-3210', NULL),
('Sarah', 'Wilson', '234-567-8901', 'John Wilson', '876-543-2109', 'VIP customer'),
('David', 'Johnson', '345-678-9012', 'Emily Johnson', '765-432-1098', NULL);

-- Insert records into RoomStatus
INSERT INTO RoomStatus (RoomStatus, Notes)
VALUES
('Available', 'Room is ready for occupancy'),
('Occupied', 'Room is currently occupied'),
('Maintenance', 'Room is under maintenance');

-- Insert records into RoomTypes
INSERT INTO RoomTypes (RoomType, Notes)
VALUES
('Single', 'Single occupancy room'),
('Double', 'Double occupancy room'),
('Suite', 'Luxury suite');

-- Insert records into BedTypes
INSERT INTO BedTypes (BedType, Notes)
VALUES
('Twin', 'Two single beds'),
('Queen', 'One queen-size bed'),
('King', 'One king-size bed');

-- Insert records into Rooms
INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)
VALUES
(101, 'Single', 'Twin', 100.00, 'Available', 'Near the lobby'),
(102, 'Double', 'Queen', 150.00, 'Occupied', 'With a balcony'),
(201, 'Suite', 'King', 300.00, 'Maintenance', 'Top floor suite');

-- Insert records into Payments
INSERT INTO Payments (EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes)
VALUES
(1, '2025-01-01', 1, '2025-01-01', '2025-01-03', 2, 200.00, 0.07, 14.00, 214.00, 'Paid in full'),
(2, '2025-01-05', 2, '2025-01-05', '2025-01-07', 2, 300.00, 0.07, 21.00, 321.00, 'Paid in full'),
(3, '2025-01-10', 3, '2025-01-10', '2025-01-12', 2, 600.00, 0.07, 42.00, 642.00, 'Paid with card');

-- Insert records into Occupancies
INSERT INTO Occupancies (EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)
VALUES
(1, '2025-01-01', 1, 101, 100.00, 10.00, 'No issues reported'),
(2, '2025-01-05', 2, 102, 150.00, 15.00, 'Customer requested late checkout'),
(3, '2025-01-10', 3, 201, 300.00, 20.00, 'Room under maintenance during stay');


--Problem 16
CREATE DATABASE [SoftUni]

GO

USE [SoftUni]

CREATE TABLE [Towns](
[Id] INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(85) NOT NULL
)

CREATE TABLE [Addresses](
[Id] INT PRIMARY KEY IDENTITY NOT NULL,
[AddressText] NVARCHAR(147) NOT NULL,
[TownId] INT FOREIGN KEY REFERENCES [Towns]([Id])
)

CREATE TABLE [Departments](
[Id] INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(70) NOT NULL
) 

CREATE TABLE [Employees](
[Id] INT PRIMARY KEY IDENTITY NOT NULL,
[FirstName] NVARCHAR(36) NOT NULL,
[MiddleName] NVARCHAR(36),
[LastName] NVARCHAR(36) NOT NULL,
[JobTitle] NVARCHAR(40) NOT NULL,
[DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]) NOT NULL,
[HireDate] DATE NOT NULL DEFAULT (GETDATE()),
[Salary] DECIMAL (18,2) NOT NULL,
[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL

)

--Problem 19
SELECT *
FROM [Towns]

SELECT *
FROM [Departments]

SELECT *
FROM [Employees]

--Problem 20
SELECT *
FROM [Towns]
ORDER BY [Name]

SELECT *
FROM [Departments]
ORDER BY [Name]

SELECT *
FROM [Employees]
ORDER BY [Salary] DESC

--Problem 21 
SELECT [Name]
FROM [Towns]
ORDER BY [Name]

SELECT [Name]
FROM [Departments]
ORDER BY [Name]

SELECT [FirstName], [LastName], [JobTitle], [Salary]
FROM [Employees]
ORDER BY [Salary] DESC

--Problem 22
UPDATE Employees
SET Salary = Salary * 1.10;

SELECT Salary
FROM Employees;

--Problem 23
UPDATE Payments
SET TaxRate = TaxRate - 0.03;
SELECT TaxRate
FROM Payments;

--Problem 24
DELETE FROM Occupancies;
SELECT * FROM Occupancies;
