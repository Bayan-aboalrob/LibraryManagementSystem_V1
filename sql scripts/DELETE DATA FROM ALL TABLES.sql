USE LibraryManagementSystem;
GO

-- Disable foreign key constraints to allow deletion
ALTER TABLE Loans NOCHECK CONSTRAINT ALL;
ALTER TABLE Borrowers NOCHECK CONSTRAINT ALL;
ALTER TABLE Books NOCHECK CONSTRAINT ALL;

-- Delete data from child table first
DELETE FROM Loans;

-- Delete data from parent tables
DELETE FROM Borrowers;
DELETE FROM Books;

-- Re-enable foreign key constraints after deletion
ALTER TABLE Loans CHECK CONSTRAINT ALL;
ALTER TABLE Borrowers CHECK CONSTRAINT ALL;
ALTER TABLE Books CHECK CONSTRAINT ALL;
