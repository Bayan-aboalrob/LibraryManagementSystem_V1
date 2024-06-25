USE LibraryManagementSystem;
GO

-- A table to hold author names temporarily
CREATE TABLE #TempAuthors (
    AuthorID INT IDENTITY(1,1),
    AuthorName NVARCHAR(255)
);

-- Inserting a list of authors into authors TempAuthors table
INSERT INTO #TempAuthors (AuthorName)
VALUES 
('J.K. Rowling'), ('Stephen King'), ('J.R.R. Tolkien'), ('George R.R. Martin'), 
('Agatha Christie'), ('Mark Twain'), ('Ernest Hemingway'), 
('Jane Austen'), ('Charles Dickens'), ('F. Scott Fitzgerald'),
('Leo Tolstoy'), ('William Shakespeare'), ('Virginia Woolf'), 
('Harper Lee'), ('Gabriel Garcia Marquez'), ('Franz Kafka'), 
('Fyodor Dostoevsky'), ('John Steinbeck'), ('Herman Melville'), 
('James Joyce'), ('Oscar Wilde'), ('Aldous Huxley'), 
('Arthur Conan Doyle'), ('C.S. Lewis'), ('H.G. Wells'), 
('Emily Brontë'), ('Mary Shelley'), ('Bram Stoker'), 
('Edgar Allan Poe'), ('Robert Louis Stevenson');

-- Insert 1000 books into the Books table
DECLARE @i INT = 1;
DECLARE @maxBooks INT = 1000;
DECLARE @authorCount INT;
DECLARE @startDate DATE = '2000-01-01';
DECLARE @endDate DATE = GETDATE();

SELECT @authorCount = COUNT(*) FROM #TempAuthors;

WHILE @i <= @maxBooks
BEGIN
    DECLARE @Title NVARCHAR(255);
    DECLARE @Author NVARCHAR(255);
    DECLARE @ISBN NVARCHAR(20);
    DECLARE @PublishedDate DATE;
    DECLARE @Genre NVARCHAR(50);
    DECLARE @ShelfLocation NVARCHAR(10);
    DECLARE @CurrentStatus NVARCHAR(10);
    
    -- Generating random book details
    SET @Title = 'Book Title ' + CAST(@i AS NVARCHAR(255));
    SET @Author = (SELECT AuthorName FROM #TempAuthors WHERE AuthorID = ((@i % @authorCount) + 1));
    SET @ISBN = 'ISBN' + RIGHT('0000' + CAST(@i AS NVARCHAR(4)), 4);
    -- Generating a random date between @startDate and @endDate, with duplicates possible
    SET @PublishedDate = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % DATEDIFF(DAY, @startDate, @endDate)), @startDate);
    SET @Genre = CASE (ABS(CHECKSUM(NEWID())) % 5)
                    WHEN 0 THEN 'Fiction'
                    WHEN 1 THEN 'Science'
                    WHEN 2 THEN 'History'
                    WHEN 3 THEN 'Biography'
                    WHEN 4 THEN 'Fantasy'
                 END;
    SET @ShelfLocation = 'Shelf ' + CHAR(65 + (@i % 26)) + CAST((@i % 10) AS NVARCHAR(10));
    SET @CurrentStatus = 'Available';
    
    -- Insert into Books table
    INSERT INTO Books (Title, Author, ISBN, PublishedDate, Genre, ShelfLocation, CurrentStatus)
    VALUES (@Title, @Author, @ISBN, @PublishedDate, @Genre, @ShelfLocation, @CurrentStatus);
    
    SET @i = @i + 1;
END

-- Drop the temporary table
DROP TABLE #TempAuthors;
GO
