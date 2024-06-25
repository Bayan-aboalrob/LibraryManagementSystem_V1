USE LibraryManagementSystem;
GO

DECLARE @i INT = 1;
DECLARE @maxLoans INT = 1000; -- Change this to the desired number of loans to insert

DECLARE @StartBookID INT = 7727248; -- Start BookID from 1001
DECLARE @EndBookID INT = (SELECT MAX(BookID) FROM Books); -- Get maximum existing BookID

DECLARE @StartBorrowerID INT = 4502; -- Start BorrowerID from 1001
DECLARE @EndBorrowerID INT = (SELECT MAX(BorrowerID) FROM Borrowers); -- Get maximum existing BorrowerID

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

    -- Select BookID ensuring it exists in the Books table and within the specified range
    DECLARE @BookID INT;
    SELECT @BookID = BookID
    FROM Books
    WHERE BookID BETWEEN @StartBookID AND @EndBookID
    ORDER BY NEWID();

    -- Select BorrowerID ensuring it exists in the Borrowers table and within the specified range
    DECLARE @BorrowerID INT;
    SELECT @BorrowerID = BorrowerID
    FROM Borrowers
    WHERE BorrowerID BETWEEN @StartBorrowerID AND @EndBorrowerID
    ORDER BY NEWID();

    -- Insert into Loans table
    INSERT INTO Loans (BookID, BorrowerID, DateBorrowed, DueDate, DateReturned)
    VALUES (@BookID, @BorrowerID, @DateBorrowed, @DueDate, @DateReturned);

    SET @i = @i + 1;
END
GO
