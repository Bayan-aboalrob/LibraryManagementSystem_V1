USE LibraryManagementSystem;
GO
CREATE FUNCTION fn_BookBorrowingFrequency (@BookID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Frequency INT;

    SELECT @Frequency = COUNT(*)
    FROM Loans
    WHERE BookID = @BookID;

    RETURN @Frequency;
END;


------------Test------------

DECLARE @BookID INT = 7727250; -- Replace with the BookID you want to test

SELECT dbo.fn_BookBorrowingFrequency(@BookID) AS BorrowingFrequency;



SELECT *
FROM Loans
WHERE BookID = 7727250;











