USE LibraryManagementSystem;
GO
-- Defining Indexes for improving the Library database Managment System

-- Firstly on the book table, we have the primary key index (Book id): normally this primary key acts as a primary clustered index on the book table.

-- Other types of indexes:

-- (1) Partional composite index on both title and author
  -- Justification: In libraries, books are commonly organized based on these two columns, so they are most likely coupled together in queries.

  -- Query execution plan before creating the index:


SET STATISTICS TIME ON;
SET STATISTICS IO ON;


SELECT b.BookID, b.Title, b.Author, l.LoanID, l.DateBorrowed
FROM Books b
JOIN Loans l ON b.BookID = l.BookID
WHERE b.Title LIKE '%Book Title 1%' AND b.Author = 'Stephen King' ;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- Creating Composite Index: Book Title+ Author
CREATE INDEX idx_books_title_author ON Books(Title, Author);
--

SET STATISTICS TIME ON;
SET STATISTICS IO ON;


SELECT b.BookID, b.Title, b.Author, l.LoanID, l.DateBorrowed
FROM Books b
JOIN Loans l ON b.BookID = l.BookID
WHERE b.Title LIKE '%Book Title 1%' AND b.Author = 'Stephen King';


SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;


-- (2): Creating the Secondary Index on Genre
-- Justification: Creating a secondary index on Genre is essential due to the possible frequent use of genre in query operations for filtering and grouping. 

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT BookID, Title, Author
FROM Books
WHERE Genre = 'Fiction';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--

CREATE INDEX idx_books_genre ON Books(Genre);

--
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT BookID, Title, Author
FROM Books
WHERE Genre = 'Fiction';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- (3): Creating the composite Index on CurrentStatus and Book_ID
-- Justification: Creating a composite index on BookID and CurrentStatus is crucial for optimizing queries that filter by both columns. This index helps quickly identify active loans and improve the performance of status-check queries.

--Before:
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    b.BookID, 
    b.Title, 
    b.Author, 
    b.Genre, 
    b.PublishedDate, 
    b.ShelfLocation,
    CASE 
        WHEN l.DateReturned IS NULL AND l.BookID IS NOT NULL THEN 'Borrowed'
        ELSE 'Available'
    END AS CurrentStatus
FROM 
    Books b
LEFT JOIN 
    Loans l ON b.BookID = l.BookID AND l.DateReturned IS NULL;


SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;


CREATE INDEX idx_books_bookid_status ON Books(BookID, CurrentStatus);


-- After:

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    b.BookID, 
    b.Title, 
    b.Author, 
    b.Genre, 
    b.PublishedDate, 
    b.ShelfLocation,
    CASE 
        WHEN l.DateReturned IS NULL AND l.BookID IS NOT NULL THEN 'Borrowed'
        ELSE 'Available'
    END AS CurrentStatus
FROM 
    Books b
LEFT JOIN 
    Loans l ON b.BookID = l.BookID AND l.DateReturned IS NULL;


SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;