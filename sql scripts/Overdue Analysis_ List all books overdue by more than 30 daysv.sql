USE LibraryManagementSystem;
GO
SELECT
    L.LoanID,
    B.BookID,
    B.Title AS BookTitle,
    B.Author,
    BR.BorrowerID,
    BR.FirstName AS BorrowerFirstName,
    BR.LastName AS BorrowerLastName,
    L.DateBorrowed,
    L.DueDate,
    L.DateReturned,
    DATEDIFF(DAY, L.DueDate, GETDATE()) AS DaysOverdue
FROM
    Loans L
JOIN
    Books B ON L.BookID = B.BookID
JOIN
    Borrowers BR ON L.BorrowerID = BR.BorrowerID
WHERE
    L.DateReturned IS NULL  -- Book has not been returned yet
    AND DATEDIFF(DAY, L.DueDate, GETDATE()) > 30  -- Overdue by more than 30 days
ORDER BY
    DaysOverdue DESC; 
