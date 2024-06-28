-- Query to find the top 3 days with the highest percentage of loans

USE LibraryManagementSystem;
GO
-- Query to find the top 3 days with the highest percentage of loans
WITH DayLoanCounts AS (
    SELECT
        DATENAME(WEEKDAY, DateBorrowed) AS LoanDayOfWeek,
        COUNT(*) AS NumLoans,
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS LoanPercentage
    FROM
        Loans
    GROUP BY
        DATENAME(WEEKDAY, DateBorrowed)
)
SELECT TOP 3
    LoanDayOfWeek,
    CONVERT(DECIMAL(5, 2), LoanPercentage) AS LoanPercentage
FROM
    DayLoanCounts
ORDER BY
    LoanPercentage DESC;

