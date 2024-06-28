WITH GenreCounts AS (
    SELECT
        b.Genre,
        COUNT(*) AS BorrowCount,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS GenreRank
    FROM
        Loans l
    JOIN
        Books b ON l.BookID = b.BookID
    WHERE
        MONTH(l.DateBorrowed) = 6  -- Example: June (replace with your desired month)
        AND YEAR(l.DateBorrowed) = 2024  -- Example: Year 2024 (if needed)
    GROUP BY
        b.Genre
)
SELECT
    Genre,
    BorrowCount
FROM
    GenreCounts
WHERE
    GenreRank = 1;  -- Select the top ranked genre for the specified month


