USE LibraryManagementSystem;
GO
ALTER PROCEDURE sp_BorrowedBooksReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    -- Set NOCOUNT to ON to prevent extra result sets from interfering with the output
    SET NOCOUNT ON;

    SELECT 
        L.LoanID,
        B.BookID,
        B.Title,
        B.Author,
        BR.BorrowerID,
        BR.FirstName + ' ' + BR.LastName AS BorrowerName,
        L.DateBorrowed,
        L.DueDate,
        L.DateReturned
    FROM 
        Loans L
    JOIN 
        Books B ON L.BookID = B.BookID
    JOIN 
        Borrowers BR ON L.BorrowerID = BR.BorrowerID
    WHERE 
        L.DateBorrowed BETWEEN @StartDate AND @EndDate
    ORDER BY 
        L.DateBorrowed;

END;
------------------TESTING----------------
EXEC sp_BorrowedBooksReport '2023-01-01', '2023-8-31';







