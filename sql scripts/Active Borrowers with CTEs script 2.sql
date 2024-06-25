WITH BorrowerBorrowCounts AS (
    SELECT 
        BorrowerID, 
        COUNT(*) AS TotalBorrowed
    FROM 
        Loans
    GROUP BY 
        BorrowerID
    HAVING 
        COUNT(*) >= 2  -- Borrowers who have borrowed 2 or more books
)
SELECT 
    B.BorrowerID, 
    B.FirstName, 
    B.LastName, 
    B.Email, 
    B.DateOfBirth, 
    B.MembershipDate,
    BBC.TotalBorrowed AS BorrowedBooksCount
FROM 
    Borrowers B
JOIN 
    BorrowerBorrowCounts BBC ON B.BorrowerID = BBC.BorrowerID
WHERE 
    B.BorrowerID IN (
        SELECT 
            BorrowerID
        FROM 
            Loans
        WHERE 
            DateReturned IS NULL  -- Only consider currently borrowed books
    )
ORDER BY 
    B.BorrowerID;
