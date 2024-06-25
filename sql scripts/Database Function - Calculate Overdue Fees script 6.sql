USE LibraryManagementSystem;
GO
ALTER FUNCTION fn_CalculateOverdueFees (@LoanID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @OverdueFee DECIMAL(10, 2);
    DECLARE @DueDate DATE;
    DECLARE @DateReturned DATE;

    -- Get DueDate and DateReturned for the loan
    SELECT @DueDate = DueDate, @DateReturned = DateReturned
    FROM Loans
    WHERE LoanID = @LoanID;

    -- Check conditions and calculate overdue fee
    IF @DateReturned IS NOT NULL AND @DateReturned <= @DueDate
    BEGIN
        SET @OverdueFee = 0.00; -- Returned on or before due date, no fee
    END
    ELSE IF @DateReturned IS NULL AND @DueDate <= GETDATE() -- Not returned yet and due date has passed
    BEGIN
        DECLARE @OverdueDays INT = DATEDIFF(DAY, @DueDate, GETDATE());

        IF @OverdueDays >= 0 AND @OverdueDays <= 30
        BEGIN
            SET @OverdueFee = CAST(@OverdueDays AS DECIMAL(10, 2)) * 1.00; -- $1/day for up to 30 days overdue
        END
        ELSE IF @OverdueDays > 30
        BEGIN
            SET @OverdueFee = 30.00 + CAST((@OverdueDays - 30) AS DECIMAL(10, 2)) * 2.00; -- $1/day for first 30 days, $2/day thereafter
        END
    END
    ELSE
    BEGIN
        SET @OverdueFee = 0.00; -- In case of any unexpected scenarios, default to 0 fee
    END

    RETURN @OverdueFee;
END;


--------------------------Testing this function------------------------------------------
-- Test cases for fn_CalculateOverdueFees function

--- Firstly , returning the loans with overdue returned date
SELECT
    LoanID,
    BookID,
    BorrowerID,
    DateBorrowed,
    DueDate
FROM
    Loans
WHERE
    DateReturned IS NULL;


-- Test case 1: Loan returned after the due date (expect overdue fees)
DECLARE @LoanID1 INT = 4609;
SELECT
    LoanID,
    DateBorrowed,
    DueDate,
    DateReturned,
    dbo.fn_CalculateOverdueFees(LoanID) AS OverdueFee
FROM Loans
WHERE LoanID = @LoanID1;

-- Test case 2: Loan returned on time or before the due date (no expect overdue fees)

SELECT
    LoanID,
    BookID,
    BorrowerID,
    DateBorrowed,
    DueDate,
    DateReturned
FROM
    Loans
WHERE
    DateReturned IS NOT NULL
    AND DateReturned <= DueDate;

DECLARE @LoanID2 INT = 4506;
UPDATE Loans
SET DateReturned = DATEADD(DAY, 2, DueDate) 
WHERE LoanID = @LoanID2;

SELECT
    LoanID,
    DateBorrowed,
    DueDate,
    DateReturned,
    dbo.fn_CalculateOverdueFees(LoanID) AS OverdueFee
FROM Loans
WHERE LoanID = @LoanID2;

-- Test case 3: Loan not returned yet (current overdue fees calculation)
SELECT
    LoanID,
    BookID,
    BorrowerID,
    DateBorrowed,
    DueDate,
    DATEDIFF(DAY, DueDate, GETDATE()) AS OverdueDays
FROM
    Loans
WHERE
    DateReturned IS NULL
    AND GETDATE() > DueDate; -- Loans that have not been returned and are overdue

DECLARE @LoanID3 INT = 4563;
UPDATE Loans
SET DateReturned = NULL -- Simulate loan not returned yet
WHERE LoanID = @LoanID3;

SELECT
    LoanID,
    DateBorrowed,
    DueDate,
    DateReturned,
    dbo.fn_CalculateOverdueFees(LoanID) AS OverdueFee
FROM Loans
WHERE LoanID = @LoanID3;
