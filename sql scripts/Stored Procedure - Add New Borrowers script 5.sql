CREATE OR ALTER PROCEDURE sp_AddNewBorrower
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @DateOfBirth DATE,
    @MembershipDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @BorrowerID INT;

    -- if the email already exists
    IF EXISTS (SELECT 1 FROM Borrowers WHERE Email = @Email)
    BEGIN
        -- Email already exists, return error message
        SELECT 'Error: Email already exists in the system.' AS Result;
    END
    ELSE
    BEGIN
        -- Email doesn't exist, proceed to insert new borrower
        BEGIN TRY
            INSERT INTO Borrowers (FirstName, LastName, Email, DateOfBirth, MembershipDate)
            VALUES (@FirstName, @LastName, @Email, @DateOfBirth, @MembershipDate);

            -- Retrieve the newly inserted BorrowerID
            SET @BorrowerID = SCOPE_IDENTITY();

            -- Return the BorrowerID
            SELECT @BorrowerID AS BorrowerID;
        END TRY
        BEGIN CATCH
            -- Return error message if insertion fails
            SELECT 'Error: Failed to add new borrower.' AS Result;
        END CATCH
    END
END


--  Adding a new borrower successfully
EXEC sp_AddNewBorrower 
    @FirstName = 'Jane',
    @LastName = 'Smith',
    @Email = 'jane.smith@example.com',
    @DateOfBirth = '1995-08-10',
    @MembershipDate = '2024-06-26';

--  Failed insertion due to an existing email or other error
EXEC sp_AddNewBorrower 
    @FirstName = 'John',
    @LastName = 'Doe',
    @Email = 'jane.smith@example.com', -- Existing email is used here to make the violations to cause insertion failure
    @DateOfBirth = '1992-03-25',
    @MembershipDate = '2024-06-26';

