USE [LibraryManagementSystem]
GO
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Author NVARCHAR(255) NOT NULL,
    ISBN NVARCHAR(20) UNIQUE NOT NULL,
    PublishedDate DATE,
    Genre NVARCHAR(100),
    ShelfLocation NVARCHAR(50),
    CurrentStatus NVARCHAR(20) CHECK (CurrentStatus IN ('Available', 'Borrowed'))
);

CREATE TABLE Borrowers (
    BorrowerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    DateOfBirth DATE,
    MembershipDate DATE NOT NULL
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT,
    BorrowerID INT,
    DateBorrowed DATE NOT NULL,
    DueDate DATE NOT NULL,
    DateReturned DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (BorrowerID) REFERENCES Borrowers(BorrowerID)
);
