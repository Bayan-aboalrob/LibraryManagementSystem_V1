USE LibraryManagementSystem;
GO

-- Create a table to hold first and last names temporarily
CREATE TABLE #TempFirstNames (
    FirstNameID INT IDENTITY(1,1),
    FirstName NVARCHAR(255)
);

CREATE TABLE #TempLastNames (
    LastNameID INT IDENTITY(1,1),
    LastName NVARCHAR(255)
);

-- Insert a list of first names
INSERT INTO #TempFirstNames (FirstName)
VALUES 
('John'), ('Jane'), ('Michael'), ('Emily'), 
('Chris'), ('Jessica'), ('David'), ('Sarah'), 
('Daniel'), ('Laura'), ('James'), ('Emma'), 
('Robert'), ('Olivia'), ('William'), ('Sophia'), 
('Joseph'), ('Isabella'), ('Charles'), ('Mia'),
('Thomas'), ('Amelia'), ('Matthew'), ('Harper'),
('George'), ('Evelyn'), ('Henry'), ('Abigail'),
('Paul'), ('Ella');

-- Insert a list of last names
INSERT INTO #TempLastNames (LastName)
VALUES 
('Smith'), ('Johnson'), ('Williams'), ('Brown'), 
('Jones'), ('Garcia'), ('Miller'), ('Davis'), 
('Rodriguez'), ('Martinez'), ('Hernandez'), ('Lopez'), 
('Gonzalez'), ('Wilson'), ('Anderson'), ('Thomas'), 
('Taylor'), ('Moore'), ('Jackson'), ('Martin'),
('Lee'), ('Perez'), ('Thompson'), ('White'),
('Harris'), ('Sanchez'), ('Clark'), ('Ramirez'),
('Lewis'), ('Robinson');

-- Insert 1000 borrowers into the Borrowers table with unique emails
DECLARE @i INT = 1;
DECLARE @maxBorrowers INT = 1000;
DECLARE @firstNameCount INT;
DECLARE @lastNameCount INT;
DECLARE @startDate DATE = '2000-01-01';
DECLARE @endDate DATE = GETDATE();

SELECT @firstNameCount = COUNT(*) FROM #TempFirstNames;
SELECT @lastNameCount = COUNT(*) FROM #TempLastNames;

WHILE @i <= @maxBorrowers
BEGIN
    DECLARE @FirstName NVARCHAR(255);
    DECLARE @LastName NVARCHAR(255);
    DECLARE @Email NVARCHAR(255);
    DECLARE @DateOfBirth DATE;
    DECLARE @MembershipDate DATE;
    
    -- Generate random borrower details
    SET @FirstName = (SELECT FirstName FROM #TempFirstNames WHERE FirstNameID = ((@i % @firstNameCount) + 1));
    SET @LastName = (SELECT LastName FROM #TempLastNames WHERE LastNameID = ((@i % @lastNameCount) + 1));
    
    -- Append row number to ensure email uniqueness
    SET @Email = LOWER(REPLACE(@FirstName + '.' + @LastName + '_' + CAST(@i AS NVARCHAR(10)) + '@example.com', ' ', '')); 
    
    -- Generate a random date of birth between 1950 and 2010
    SET @DateOfBirth = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % DATEDIFF(DAY, '1950-01-01', '2010-01-01')), '1950-01-01');
    
    -- Generate a random membership date between 2015 and now
    SET @MembershipDate = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % DATEDIFF(DAY, '2015-01-01', @endDate)), '2015-01-01');
    
    -- Insert into Borrowers table
    INSERT INTO Borrowers (FirstName, LastName, Email, DateOfBirth, MembershipDate)
    VALUES (@FirstName, @LastName, @Email, @DateOfBirth, @MembershipDate);
    
    PRINT CONCAT('Inserted row ', @i); -- Print debug information
    
    SET @i = @i + 1;
END

-- Drop the temporary tables
DROP TABLE #TempFirstNames;
DROP TABLE #TempLastNames;
GO
