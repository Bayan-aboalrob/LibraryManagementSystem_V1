-- Indexing on Borrowes Table:

-- The primary clustered index is created on Borrower_ID since it's declared as a primary key

-- (1):Unique Index on Email:

--Justification: it ensures that  each borrower's email address is unique, which is important for user management and preventing duplicate entries. This index also optimizes queries that search for borrowers by email.


USE LibraryManagementSystem;
GO

-- Example query: Before creating the index
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    b.BorrowerID, 
    b.FirstName, 
    b.LastName, 
    b.Email, 
    COUNT(l.LoanID) AS TotalLoans,
    MAX(l.DateBorrowed) AS LastLoanDate
FROM 
    Borrowers b
JOIN 
    Loans l ON b.BorrowerID = l.BorrowerID
WHERE 
    b.Email LIKE '%example.com%'
GROUP BY 
    b.BorrowerID, 
    b.FirstName, 
    b.LastName, 
    b.Email
HAVING 
    COUNT(l.LoanID) > 5
ORDER BY 
    LastLoanDate DESC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
--

CREATE UNIQUE INDEX idx_borrowers_email ON Borrowers(Email);
--

-- After creating the index:
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    b.BorrowerID, 
    b.FirstName, 
    b.LastName, 
    b.Email, 
    COUNT(l.LoanID) AS TotalLoans,
    MAX(l.DateBorrowed) AS LastLoanDate
FROM 
    Borrowers b
JOIN 
    Loans l ON b.BorrowerID = l.BorrowerID
WHERE 
    b.Email LIKE '%example.com%'
GROUP BY 
    b.BorrowerID, 
    b.FirstName, 
    b.LastName, 
    b.Email
HAVING 
    COUNT(l.LoanID) > 5
ORDER BY 
    LastLoanDate DESC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- (2): Non-clustered index on Last name
-- Justification: Optimizes queries that search or sort by full name, which is common in user interfaces and reports.


SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SELECT 
    BorrowerID, 
    FirstName, 
    LastName, 
    Email 
FROM 
    Borrowers
WHERE 
    LastName = 'Smith';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

CREATE INDEX idx_borrowers_lastname ON Borrowers(LastName);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SELECT 
    BorrowerID, 
    FirstName, 
    LastName, 
    Email 
FROM 
    Borrowers
WHERE 
    LastName = 'Smith';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
--


-- (3): Composite Index on MembershipDate and BorrowerID:
-- Justification: Useful for queries that filter or sort borrowers by their membership date, optimizing range queries.

--Before:

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT BorrowerID, FirstName, LastName, Email 
FROM Borrowers
WHERE MembershipDate > '2020-01-01';


SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- Creating composite index on MembershipDate and BorrowerID
CREATE INDEX idx_borrowers_membershipdate_borrowerid ON Borrowers(MembershipDate, BorrowerID);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT BorrowerID, FirstName, LastName, Email 
FROM Borrowers
WHERE MembershipDate > '2020-01-01';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
