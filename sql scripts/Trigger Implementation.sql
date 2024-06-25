USE LibraryManagementSystem;
GO
CREATE TABLE AuditLog (
    AuditLogID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT NOT NULL,
    StatusChange NVARCHAR(50) NOT NULL,
    ChangeDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TRIGGER trg_BookStatusChange
ON Books
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into AuditLog for status changes
    INSERT INTO AuditLog (BookID, StatusChange, ChangeDate)
    SELECT 
        i.BookID,
        CASE
            WHEN i.CurrentStatus = 'Borrowed' AND d.CurrentStatus = 'Available' THEN 'Available to Borrowed'
            WHEN i.CurrentStatus = 'Available' AND d.CurrentStatus = 'Borrowed' THEN 'Borrowed to Available'
            ELSE NULL
        END AS StatusChange,
        GETDATE() AS ChangeDate
    FROM 
        inserted i
    INNER JOIN 
        deleted d ON i.BookID = d.BookID
    WHERE 
        (i.CurrentStatus = 'Borrowed' AND d.CurrentStatus = 'Available')
        OR (i.CurrentStatus = 'Available' AND d.CurrentStatus = 'Borrowed');
END;
GO

---------------------TESTING----------------------

-- Test case: Change status from Available to Borrowed
UPDATE Books
SET CurrentStatus = 'Borrowed'
WHERE BookID = 7727248;

-- Test case: Change status from Borrowed to Available
UPDATE Books
SET CurrentStatus = 'Available'
WHERE BookID = 7727248;

-- Check the AuditLog table
SELECT * FROM AuditLog;
