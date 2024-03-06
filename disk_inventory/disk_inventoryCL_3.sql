 /*
 Project 3 main changes
 1. Add auto increment identities to all primary keys
 2. Add returndate to borrowedDisk
 3. removed term table as borrowedDisk now has borrowedDate & returnDate
 4. Renamed Media to Disk to coincide with project assignment
 5. Filled tables with data, additional comments inline
 */
 --Create a database
USE master;
GO
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'disk_inventoryCL')
DROP DATABASE disk_inventoryCL
GO
CREATE DATABASE disk_inventoryCL;
GO

-- Use database
USE disk_inventoryCL;
GO

-- Create outer tables first
-- All tables check to see if table exists.
-- If table exists, drop table
-- These are stand alone tables that will be used linked via foreign keys to secondary tables
-- Genre
IF EXISTS (SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'genre')
DROP TABLE [dbo].[genre]
GO
-- added auto increment identity
CREATE TABLE genre (
	genreId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	genreDescription VARCHAR(25) NOT NULL
)

-- Artists
IF EXISTS (SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'artists')
DROP TABLE [dbo].[artists]
GO
CREATE TABLE artists (
	artistId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	artistName VARCHAR(50) NOT NULL
)

-- diskType
IF EXISTS (SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'diskType')
DROP TABLE [dbo].[diskType]
GO
CREATE TABLE diskType (
	typeId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	typeDescription VARCHAR(50) NOT NULL
)

-- status
IF EXISTS (SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'diskStatus')
DROP TABLE [dbo].[diskStatus]
GO
CREATE TABLE diskStatus (
	statusId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	statusDescription VARCHAR(50) NOT NULL
)

-- terms
-- REMOVED TERM TABLE
/*
IF EXISTS (SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'terms')
DROP TABLE [dbo].[terms]
GO
CREATE TABLE terms (
	termsId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	startDate DATE NOT NULL,
	endDate DATE NOT NULL
)
*/
-- address
IF EXISTS (SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'addresses')
DROP TABLE [dbo].[addresses]
GO
CREATE TABLE addresses (
	addressId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	addressDescription VARCHAR(50) NOT NULL,
	addressState CHAR(2) NOT NULL,
	addressCity VARCHAR(25) NOT NULL,
	addreessZipcode VARCHAR(5) NOT NULL
)

-- Create secondary tables
-- These tables reference the outer tables and provide foreign keys to be reference by the primary table
-- borrower
IF EXISTS (SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'borrower')
DROP TABLE [dbo].[borrower]
GO
CREATE TABLE borrower (
	borrowerId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	addressId INT FOREIGN KEY REFERENCES addresses(addressId),
	firstName VARCHAR(25) NOT NULL,
	lastName VARCHAR(25) NOT NULL,
	phone VARCHAR(10) NOT NULL,
	email VARCHAR(50) NOT NULL
)

-- disk
IF EXISTS (SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'disk')
DROP TABLE [dbo].[disk]
GO
CREATE TABLE disk (
	diskId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	genreId INT FOREIGN KEY REFERENCES genre(genreId),
	statusId INT FOREIGN KEY REFERENCES diskStatus(statusId),
	artistId INT FOREIGN KEY REFERENCES artists(artistId),
	typeId INT FOREIGN KEY REFERENCES diskType(typeId),
	diskName VARCHAR(50) NOT NULL
)

-- primary table
-- Create borrowedDisk table
-- Check is table exists. If so, drop table.
IF EXISTS (SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'borroweddisk')
DROP TABLE [dbo].borroweddisk
GO
CREATE TABLE borrowedDisk (
	borrowedDiskId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	diskId INT FOREIGN KEY REFERENCES disk(diskId),
	borrowerId INT FOREIGN KEY REFERENCES borrower(borrowerId),
	--termId INT FOREIGN KEY REFERENCES terms(termsId),
	borrowedDate DATE NOT NULL,
	returnDate DATE NULL
)

-- Create diskUserCL
-- Create diskUserCL Login with password if login doesn't exist
IF NOT EXISTS (SELECT name FROM master.sys.server_principals WHERE name = 'diskUserCL')
BEGIN
	CREATE LOGIN diskUserCL WITH PASSWORD='!5ecureP@ssword!'; 
END
GO

-- Create diskUserCL User for Login diskUserCL if user doesn't exists
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'diskUserCL')
BEGIN
	CREATE USER diskUserCL FOR LOGIN diskUserCL
END
GO

-- Grant data reader permissions for diskUserCL
ALTER ROLE db_datareader ADD MEMBER diskUserCL
GO

-- PROJECT 3 : INSERT INTO diskType, genre, diskStatus 5 records
INSERT INTO diskType (typeDescription)
VALUES ('ssd'),('tape'),('cd'),('record'),('floppy');

INSERT INTO genre (genreDescription)
VALUES ('punk'),('rock'),('pop'),('classical'),('rap');

INSERT INTO diskStatus (statusDescription)
VALUES ('available'),('unavailable'),('overdue'),('sold'),('hold');

INSERT INTO artists (artistName)
VALUES ('Taylor Swift'),('Bazzi'),('Michael Jackson'),('ACDC');
GO

-- Insert at least 20 rows of data into the table using realworld disk names
DECLARE @genreId INT = (SELECT genreId FROM genre WHERE genreDescription = 'pop');
DECLARE @stastusId INT = (SELECT statusId FROM diskStatus WHERE statusDescription = 'available');
DECLARE @artistId INT = (SELECT artistId FROM artists WHERE artistName = 'Taylor Swift');
DECLARE @typeId INT = (SELECT typeId FROM diskType WHERE typeDescription = 'cd');

INSERT INTO disk (genreId, statusId, artistId, typeId,diskName)
VALUES (@genreId, @stastusId, @artistId, @typeId, 'Midnights'),
(@genreId, @stastusId, @artistId, @typeId, 'Speak Now'),
(@genreId, @stastusId, @artistId, @typeId, 'Reputation'),
(@genreId, @stastusId, @artistId, @typeId, 'Folklore'),
(@genreId, @stastusId, @artistId, @typeId, '1989');

SET @genreId = (SELECT genreId FROM genre WHERE genreDescription = 'pop');
SET @stastusId = (SELECT statusId FROM diskStatus WHERE statusDescription = 'available');
SET @artistId = (SELECT artistId FROM artists WHERE artistName = 'Bazzi');
SET @typeId = (SELECT typeId FROM diskType WHERE typeDescription = 'cd');

INSERT INTO disk (genreId, statusId, artistId, typeId,diskName)
VALUES (@genreId, @stastusId, @artistId, @typeId, 'Cosmic'),
(@genreId, @stastusId, @artistId, @typeId, 'Infinite Dream'),
(@genreId, @stastusId, @artistId, @typeId, 'Beautiful'),
(@genreId, @stastusId, @artistId, @typeId, 'Soul Searching'),
(@genreId, @stastusId, @artistId, @typeId, 'Unknown');

SET @genreId = (SELECT genreId FROM genre WHERE genreDescription = 'pop');
SET @stastusId = (SELECT statusId FROM diskStatus WHERE statusDescription = 'available');
SET @artistId = (SELECT artistId FROM artists WHERE artistName = 'Michael Jackson');
SET @typeId = (SELECT typeId FROM diskType WHERE typeDescription = 'floppy');

INSERT INTO disk (genreId, statusId, artistId, typeId,diskName)
VALUES (@genreId, @stastusId, @artistId, @typeId, 'Highway to Hell'),
(@genreId, @stastusId, @artistId, @typeId, 'Power Up'),
(@genreId, @stastusId, @artistId, @typeId, 'Back in Black'),
(@genreId, @stastusId, @artistId, @typeId, 'High Voltage'),
(@genreId, @stastusId, @artistId, @typeId, 'Who Made Who');

SET @genreId = (SELECT genreId FROM genre WHERE genreDescription = 'rock');
SET @stastusId = (SELECT statusId FROM diskStatus WHERE statusDescription = 'available');
SET @artistId = (SELECT artistId FROM artists WHERE artistName = 'ACDC');
SET @typeId = (SELECT typeId FROM diskType WHERE typeDescription = 'record');

INSERT INTO disk (genreId, statusId, artistId, typeId,diskName)
VALUES (@genreId, @stastusId, @artistId, @typeId, 'Off the Wall'),
(@genreId, @stastusId, @artistId, @typeId, 'Thriller'),
(@genreId, @stastusId, @artistId, @typeId, 'Bad'),
(@genreId, @stastusId, @artistId, @typeId, 'Dangerous'),
(@genreId, @stastusId, @artistId, @typeId, 'Got to Be There');

-- 2.	Update only 1 row using a where clause
UPDATE disk SET genreId = 1 WHERE diskId = 1;

/*
e.	Borrower table:
1.	Insert at least 21 rows of data into the table using realworld borrower names
2.	Delete only 1 row using a where clause
*/

INSERT INTO addresses (addressDescription, addressState, addressCity, addreessZipcode)
VALUES ('5500 E Opportunity Dr', 'ID', 'Nampa', '83653'),
('1360 S Eagle Flight Way','ID','Boise','83716');

INSERT INTO borrower (addressId, firstName, lastName, phone, email)
VALUES (1,'john','jones','2089990001','email1@example.com'),
(1,'jane','rodriguez','2089990002','email2@example.com'),
(1,'alex','williams','2089990003','email3@example.com'),
(1,'alexis','garcia','2089990041','email4@example.com'),
(1,'bruce','johnson','2089990005','email5@example.com'),
(1,'britney','smith','2089990006','email6@example.com'),
(1,'ryan','wilson','2089990007','email7@example.com'),
(1,'riley','anderson','2089990008','email8@example.com'),
(1,'sara','anderson','2089990009','email9@example.com'),
(1,'mark','brown','2089990010','email10@example.com'),
(1,'ollie','miller','2089990011','email11@example.com'),
(1,'david','davis','2089990021','email12@example.com'),
(1,'cheyenne','gonzalez','2089990031','email13@example.com'),
(1,'kylee','hernandez','2089990041','email14@example.com'),
(1,'david','martinez','2089990051','email15@example.com'),
(1,'cora','taylor','2089990061','email16@example.com'),
(1,'cj','lopez','2089990071','email17@example.com'),
(1,'jimmy','jackson','2089990081','email18@example.com'),
(1,'corbin','nasty','2089990091','email19@example.com'),
(1,'jake','moore','2089990101','email20@example.com'),
(1,'john','thompson','2089990201','email21@example.com');

DELETE FROM borrower WHERE borrowerId = 21;

/*
f.	DiskHasBorrower table:
1.	Insert at least 20 rows of data into the table
2.	Insert at least 2 different disks
3.	Insert at least 2 different borrowers
4.	At least 1 disk has been borrowed by the same borrower 2 different times
5.	At least 1 disk in the disk table does not have a related row here
6.	At least 1 disk must have at least 2 different rows here
7.	At least 1 borrower in the borrower table does not have a related row here
8.	At least 1 borrower must have at least 2 different rows here
*/

-- diskId 1-20
-- borrowerId  2- !21 - 22
-- termId 1
INSERT INTO borrowedDisk (diskId, borrowerId, borrowedDate, returnDate)
VALUES (1,2,GETDATE()-12,GETDATE() -11),
(1,3,GETDATE()-10, null),
(6,2,GETDATE() - 30, GETDATE()-11),
(6,2,GETDATE()-10, NULL),
(7,3,GETDATE()-10, null),
(19,15,GETDATE()-10, GETDATE()),
(18,14,GETDATE()-10, GETDATE()),
(17,13,GETDATE()-10, GETDATE()),
(16,3,GETDATE()-10, GETDATE()),
(15,4,GETDATE()-10, GETDATE()),
(14,5,GETDATE()-10, GETDATE()),
(13,6,GETDATE()-14, GETDATE()-13),
(13,7,GETDATE()-16, GETDATE()-15),
(13,8,GETDATE()-18, GETDATE()-17),
(13,9,GETDATE()-20, GETDATE()-19),
(13,10,GETDATE()-22, GETDATE()-21),
(13,11,GETDATE()-24, GETDATE()-23),
(13,12,GETDATE()-26, GETDATE()-25),
(13,2,GETDATE()-28, GETDATE()-27),
(13,2,GETDATE()-30, GETDATE()-29);

SELECT * FROM borrowedDisk where returnDate IS NULL;