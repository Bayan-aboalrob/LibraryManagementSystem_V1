-- Indexing on the Loans table
-- (1) Index on BookID
-- Justification: Queries often join the Loans table with the Books table using BookID. An index on BookID will optimize these join operations and any filtering by BookID.

-- Before
SET STATISTICS TIME ON;
SET STATISTICS IO ON;


SELECT 
    l.LoanID, l.BookID, l.BorrowerID, l.DateBorrowed, l.DueDate, l.DateReturned
FROM 
    Loans l
JOIN 
    Books b ON l.BookID = b.BookID
WHERE 
    b.BookID = 7727250;


SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

CREATE INDEX idx_loans_bookid ON Loans(BookID);


--AFTER
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    l.LoanID, l.BookID, l.BorrowerID, l.DateBorrowed, l.DueDate, l.DateReturned
FROM 
    Loans l
JOIN 
    Books b ON l.BookID = b.BookID
WHERE 
    b.BookID = 7727250;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;


--(2) Index on BorrowerID:
-- Justification: Queries often join the Loans table with the Borrowers table using BorrowerID. An index on BorrowerID will optimize these join operations and any filtering by BorrowerID.
-- BEFORE
SET STATISTICS TIME ON;
SET STATISTICS IO ON;


SELECT 
    l.LoanID, l.BookID, l.BorrowerID, l.DateBorrowed, l.DueDate, l.DateReturned
FROM 
    Loans l
JOIN 
    Borrowers b ON l.BorrowerID = b.BorrowerID
WHERE 
    b.BorrowerID = 4505;


SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;


CREATE INDEX idx_loans_borrowerid ON Loans(BorrowerID);
 --AFTER
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    l.LoanID, l.BookID, l.BorrowerID, l.DateBorrowed, l.DueDate, l.DateReturned
FROM 
    Loans l
JOIN 
    Borrowers b ON l.BorrowerID = b.BorrowerID
WHERE 
    b.BorrowerID = 4505;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;



-- (3): Composite Index on DateReturned and BookID:
-- Justification: Queries frequently filter by DateReturned to check if a book is still borrowed or returned. Including BookID helps with identifying the specific book in these filters.
--BEFORE
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    l.LoanID, l.BookID, l.BorrowerID, l.DateBorrowed, l.DueDate, l.DateReturned
FROM 
    Loans l
WHERE 
    l.DateReturned IS NULL;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

CREATE INDEX idx_loans_datereturned_bookid ON Loans(DateReturned, BookID);
--AFTER
SET STATISTICS TIME ON;
SET STATISTICS IO ON;


SELECT 
    l.LoanID, l.BookID, l.BorrowerID, l.DateBorrowed, l.DueDate, l.DateReturned
FROM 
    Loans l
WHERE 
    l.DateReturned IS NULL;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;


-- (4): Composite Index on DateBorrowed and DueDate:

-- Justification: Queries that filter or sort loans by DateBorrowed and DueDate will benefit from this composite index, optimizing date range searches and overdue analysis.

--BEFORE
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    l.LoanID, l.BookID, l.BorrowerID, l.DateBorrowed, l.DueDate, l.DateReturned
FROM 
    Loans l
WHERE 
    l.DateBorrowed > '2023-01-01';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

CREATE INDEX idx_loans_dateborrowed_duedate ON Loans(DateBorrowed, DueDate);

-- AFTER
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    l.LoanID, l.BookID, l.BorrowerID, l.DateBorrowed, l.DueDate, l.DateReturned
FROM 
    Loans l
WHERE 
    l.DateBorrowed > '2023-01-01';
---------------------------------Testing Insert, Update , and delete after adding the indexes----------------------------------------------


-- UPDATE OPERATION
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

UPDATE Loans
SET DateReturned = GETDATE()
WHERE DateReturned IS NULL;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;



---INSETING OPERATION

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

USE LibraryManagementSystem;
GO

INSERT INTO Loans (BookID, BorrowerID, DateBorrowed, DueDate, DateReturned)
VALUES 
    (1, 1, '2024-06-01', '2024-06-15', NULL),
    (2, 2, '2024-06-02', '2024-06-16', NULL),
    (3, 3, '2024-06-03', '2024-06-17', NULL),
    (4, 4, '2024-06-04', '2024-06-18', NULL),
    (5, 5, '2024-06-05', '2024-06-19', NULL);
