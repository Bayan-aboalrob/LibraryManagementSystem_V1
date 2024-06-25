USE LibraryManagementSystem;
SELECT
    Author,
    BorrowingFrequency,
    DENSE_RANK() OVER (ORDER BY BorrowingFrequency DESC) AS AuthorRank
FROM
    (SELECT
        B.Author,
        COUNT(L.LoanID) AS BorrowingFrequency
    FROM
        Books B
    JOIN
        Loans L ON B.BookID = L.BookID
    GROUP BY
        B.Author
    ) AS AuthorBorrowingFrequency
ORDER BY
    AuthorRank;
