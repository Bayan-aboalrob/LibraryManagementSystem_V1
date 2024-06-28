USE LibraryManagementSystem;
GO

WITH AgeGroups AS (
    SELECT
        B.BorrowerID,
        BK.Genre,
        CASE
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 0 AND 10 THEN '0-10'
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 11 AND 20 THEN '11-20'
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 21 AND 30 THEN '21-30'
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 31 AND 40 THEN '31-40'
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
            WHEN DATEDIFF(YEAR, B.DateOfBirth, GETDATE()) BETWEEN 51 AND 60 THEN '51-60'
            ELSE '60+'
        END AS AgeGroup
    FROM
        Borrowers B
    JOIN
        Loans L ON B.BorrowerID = L.BorrowerID
    JOIN
        Books BK ON L.BookID = BK.BookID
),
GenreCounts AS (
    SELECT
        AgeGroup,
        Genre,
        COUNT(*) AS GenreCount
    FROM
        AgeGroups
    GROUP BY
        AgeGroup,
        Genre
),
PreferredGenres AS (
    SELECT
        AgeGroup,
        Genre,
        GenreCount,
        DENSE_RANK() OVER (PARTITION BY AgeGroup ORDER BY GenreCount DESC) AS GenreRank
    FROM
        GenreCounts
)
SELECT
    AgeGroup,
    Genre,
    GenreCount
FROM
    PreferredGenres
WHERE
    GenreRank = 1
ORDER BY
    AgeGroup;

