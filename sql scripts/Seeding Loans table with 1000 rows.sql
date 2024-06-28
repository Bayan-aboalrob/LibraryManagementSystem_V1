USE LibraryManagementSystem;
GO

-- Seed the Loans table with existing BookID and BorrowerID
DECLARE @i INT = 1;
DECLARE @maxLoans INT = 2000;

WHILE @i <= @maxLoans
BEGIN
    -- Generate random dates
    DECLARE @DateBorrowed DATE = DATEADD(DAY, -FLOOR(RAND() * 365), GETDATE()); -- Borrowed date within the last year
    DECLARE @DueDate DATE = DATEADD(DAY, 7 + FLOOR(RAND() * 14), @DateBorrowed); -- Due date is 7-21 days after DateBorrowed

    -- Randomly decide if the book has been returned
    DECLARE @DateReturned DATE = NULL;
    IF RAND() < 0.9 -- 90% chance of being returned
    BEGIN
        SET @DateReturned = DATEADD(DAY, FLOOR(RAND() * 30), @DateBorrowed); -- DateReturned is between DateBorrowed and 30 days later
    END

    -- Get existing BookID and BorrowerID
    DECLARE @BookID INT = (SELECT TOP 1 BookID FROM Books ORDER BY NEWID());
    DECLARE @BorrowerID INT = (SELECT TOP 1 BorrowerID FROM Borrowers ORDER BY NEWID());

    -- Insert into Loans table
    INSERT INTO Loans (BookID, BorrowerID, DateBorrowed, DueDate, DateReturned)
    VALUES (@BookID, @BorrowerID, @DateBorrowed, @DueDate, @DateReturned);

    SET @i = @i + 1;
END
GO
