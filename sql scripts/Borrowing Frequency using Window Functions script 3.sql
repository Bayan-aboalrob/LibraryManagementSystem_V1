WITH BorrowerLoanCounts AS (
    SELECT 
        BorrowerID,
        COUNT(*) AS TotalLoans
    FROM 
        Loans
    GROUP BY 
        BorrowerID
)
SELECT 
    BorrowerID,
    TotalLoans,
    DENSE_RANK() OVER (ORDER BY TotalLoans DESC) AS BorrowingRank
FROM 
    BorrowerLoanCounts
ORDER BY 
    BorrowingRank;
