USE LibraryManagementSystem;
GO
ALTER PROCEDURE sp_GetBorrowersWithOverdueBooksUsingTempTable
AS
BEGIN
    -- Create a temporary table to store borrowers with overdue books
    CREATE TABLE #TempBorrowersWithOverdueBooks (
        BorrowerID INT,
        FirstName NVARCHAR(100),
        LastName NVARCHAR(100)
    );

    -- Insert borrowers with overdue books into the temporary table
    INSERT INTO #TempBorrowersWithOverdueBooks (BorrowerID, FirstName, LastName)
    SELECT
        B.BorrowerID,
        B.FirstName,
        B.LastName
    FROM
        Borrowers B
    INNER JOIN Loans L ON B.BorrowerID = L.BorrowerID
    WHERE
        L.DateReturned IS NULL  -- Book has not been returned
        AND L.DueDate < GETDATE();  -- Due date is in the past

    -- Query to list out specific overdue books for each borrower from the temporary table
    SELECT
        T.BorrowerID,
        T.FirstName,
        T.LastName,
        L.LoanID,
        L.BookID,
        L.DateBorrowed,
        L.DueDate
    FROM
        #TempBorrowersWithOverdueBooks T
    INNER JOIN Loans L ON T.BorrowerID = L.BorrowerID
    WHERE
        L.DateReturned IS NULL  -- Book has not been returned
        AND L.DueDate < GETDATE()  -- Due date is in the past

    -- Drop the temporary table after use
    DROP TABLE #TempBorrowersWithOverdueBooks;
END;



----------TESTING---------------
-- Execute the stored procedure
EXEC sp_GetBorrowersWithOverdueBooks;

-------------
-- FOR TESTING I WANTED TO RETURN ALL THE OVERDUE BOOS ALONG WITH THEIR BORROWERS AND ADDITIONAL INFO
-- Create a temporary table to store borrowers with overdue books and their details
CREATE TABLE #BorrowersWithOverdueBooks (
    BorrowerID INT,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    BookID INT,
    BookTitle NVARCHAR(100),
    DateBorrowed DATE,
    DueDate DATE
);

-- Insert borrowers with overdue books and their details into the temporary table
INSERT INTO #BorrowersWithOverdueBooks (BorrowerID, FirstName, LastName, BookID, BookTitle, DateBorrowed, DueDate)
SELECT
    B.BorrowerID,
    B.FirstName,
    B.LastName,
    L.BookID,
    BK.Title AS BookTitle,
    L.DateBorrowed,
    L.DueDate
FROM
    Borrowers B
INNER JOIN Loans L ON B.BorrowerID = L.BorrowerID
INNER JOIN Books BK ON L.BookID = BK.BookID
WHERE
    L.DateReturned IS NULL  -- Book has not been returned
    AND L.DueDate < GETDATE();  -- Due date is in the past

-- Select the result from the temporary table
SELECT
    BorrowerID,
    FirstName,
    LastName,
    BookID,
    BookTitle,
    DateBorrowed,
    DueDate
FROM
    #BorrowersWithOverdueBooks
ORDER BY
    BorrowerID;  -- Order by BorrowerID

-- Drop the temporary table after use
DROP TABLE #BorrowersWithOverdueBooks;
