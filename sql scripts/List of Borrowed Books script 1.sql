USE LibraryManagementSystem;
GO

DECLARE @BorrowerID INT;
SET @BorrowerID = 4502;

SELECT B.BookID, B.Title, B.Author, L.DateBorrowed, L.DueDate, L.DateReturned
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
WHERE L.BorrowerID = @BorrowerID;

