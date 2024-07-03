
/*
The Genetic Medical Records Database System is designed to manage comprehensive patient information,
including personal details, genetic data, disease diagnoses, treatments, and associated genetic information.
The system integrates multiple tables to store and relate data efficiently, facilitating the analysis and retrieval of detailed medical records.

The benefits of this system are:
- Comprehensive Data Management: Integrates various aspects of patient information, ensuring a holistic view.
- Efficiency in Data Retrieval: Facilitates efficient querying and retrieval of patient records, genetic data, and treatment history.
- Enhanced Analysis: Supports detailed analysis of genetic information and its impact on disease management and treatment outcomes.
- This system aims to streamline the management of genetic medical records, providing a robust framework for healthcare providers to store, 
retrieve, and analyze patient data effectively.
*/

create database GeneticMedicalRecords;
use GeneticMedicalRecords;

-- Stores address information for patients
CREATE TABLE Address (
    StreetAddress VARCHAR(50),
    City VARCHAR(50) NOT NULL,
    PostCode VARCHAR(10),
    County VARCHAR(50) NOT NULL,
    PRIMARY KEY (StreetAddress, PostCode) -- composite primary key of two feilds to make unique entries in the table
);

INSERT INTO Address (StreetAddress, City, PostCode, County)
VALUES ('33 sale road', 'Manchester', 'M23 0QQ', 'Greater Manchester'),
       ('29 T gardens', 'Wakefield', 'WF2 1AD', 'West Yorkshire'),
       ('44 morley', 'Leeds', 'L23 0QQ', 'West Yorkshire'),
       ('23 brichlane', 'Manchester', 'M13 9PT', 'Greater Manchester'),
       ('19 Tingley', 'Wakefield', 'WF3 0DE', 'West Yorkshire');

select * from Address;

-- Stores personal and contact information of patients.
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    Surname VARCHAR(50) NOT NULL,
    Dob DATE,
    PhoneNumber VARCHAR(50) NOT NULL,
    EmailID VARCHAR(50),
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
	StreetAddress VARCHAR(50), 
    PostCode VARCHAR(10), 
	FOREIGN KEY (StreetAddress, PostCode) REFERENCES address(StreetAddress, PostCode)
);

INSERT INTO Patients (FirstName, Surname, Dob, PhoneNumber, EmailID, Gender, StreetAddress, PostCode)
VALUES ('John', 'William', '1990-05-15', '+447348765430', 'john.william@example.com', 'Male', '33 sale road','M23 0QQ'),
       ('Jane', 'Smith', '1985-10-20', '+447248766400', 'jane.smith@example.com', 'Female', '29 T gardens','WF2 1AD'),
       ('Andrew', 'Brown', '1988-11-19', '+447228567400', 'andrew.brown@example.com', 'Male', '44 morley','L23 0QQ'),
       ('Gisela', 'Orozco', '1979-04-16','+44782653421', 'gisela.orozco@example.com', 'Female', '23 brichlane', 'M13 9PT'),
       ('Coby', 'scott', '1999-03-26', '+44725689324', 'coby.scott@example.com', 'Male', '19 Tingley', 'WF3 0DE');

SELECT * FROM Patients;

-- Stores information about genes related to various diseases.
CREATE TABLE Genes (
    GeneSymbol VARCHAR(50) PRIMARY KEY,
    Description TEXT,
    Chromosome VARCHAR(10) NOT NULL,
    StartPosition INT NOT NULL,
    EndPosition INT NOT NULL
);
INSERT INTO Genes(GeneSymbol, Description, Chromosome, StartPosition, EndPosition) VALUES 
('CFTR', 'Cystic Fibrosis Transmembrane Conductance Regulator', 'chr7', 117287120, 117548675),
('HBB', 'Hemoglobin Subunit Beta', 'chr11', 5225464, 5227197), 
('HTT', 'Huntingtin', 'chr4', 3041363, 3243953), 
('DMD', 'Dystrophin', 'chrX', 31119228, 33128427), 
('F8', 'Coagulation Factor VIII', 'chrX', 154835788, 154886317); 

SELECT * FROM Genes;

-- Stores information about different treatments available
CREATE TABLE Treatments (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    TreatmentDescription TEXT,
    Drug VARCHAR(50) NOT NULL
);

INSERT INTO Treatments(TreatmentDescription, Drug) VALUES
('Treatment description 1', 'Drug 1'),
('Treatment description 2', 'Drug 2'),
('Treatment description 3', 'Drug 3'),
('Treatment description 4', 'Drug 4'),
('Treatment description 5', 'Drug 5'),
('Treatment description 6', 'Drug 6'),
('Treatment description 7', 'Drug 7');

SELECT * FROM Treatments;

-- Stores information about various diseases, including their genetic basis and treatments
CREATE TABLE Diseases (
    DiseaseName VARCHAR(100) PRIMARY KEY,
    Description TEXT,
    GeneSymbol VARCHAR(50),
    TreatmentID INT NOT NULL,
	FOREIGN KEY (TreatmentID) REFERENCES Treatments(TreatmentID),
    FOREIGN KEY (GeneSymbol) REFERENCES Genes(GeneSymbol)
);

INSERT INTO Diseases(DiseaseName, Description, GeneSymbol, TreatmentID) VALUES
('Cystic Fibrosis', 'Description of Cystic Fibrosis', 'CFTR', 1),
('Sickle Cell Anemia', 'Description of  Sickle Cell Anemia', 'HBB', 2),
('Huntingtons Disease', 'Description of Huntingtons Disease', 'HTT', 3),
('Duchenne Muscular Dystrophy', 'Description of Duchenne Muscular Dystrophy', 'DMD', 4),
('Hemophilia A', 'Description of Hemophilia A ', 'F8', 5),
('Cardiovasular', 'Description of Cardiovasular', 'HBB', 6),
('Down Syndrome', 'Description of Down Syndrome', NULL, 7);

Select * from Diseases;

-- Stores clinical data about patients, including disease diagnoses and treatment periods
CREATE TABLE ClinicalInformation (
	PatientID INT,         -- referential integrity (as a foreign key) and uniqueness (as a primary key)
	DiseaseName VARCHAR(100),
    DiagnosisDate DATE NOT NULL,
    GeneticTest VARCHAR(100),
    TreatmentStartDate DATE,
    TreatmentEndDate DATE,
    PRIMARY KEY (PatientID, DiseaseName),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DiseaseName) REFERENCES Diseases(DiseaseName)
);

INSERT INTO ClinicalInformation(PatientID, DiseaseName, DiagnosisDate, GeneticTest, TreatmentStartDate, TreatmentEndDate) VALUES
(1, 'Cystic Fibrosis', '2023-01-15', 'Genome testing', '2023-02-01', null),
(2, 'Sickle Cell Anemia', '2022-10-20', 'Karyotyping', '2022-11-01', null),
(3, 'Sickle Cell Anemia', '2019-04-18', 'Karyotyping', '2020-08-06', null),
(2, 'Cardiovasular', '2022-10-20', null, '2022-11-01', null),
(4, 'Down Syndrome', '2021-01-12', 'Karyotyping', null, null),
(5, 'Huntingtons Disease', '2018-06-25', 'Genome testing', '2020-12-09', null);

-- UPDATE ClinicalInformation SET GeneticTest = 'Karyotyping' WHERE PatientID = 3;

SELECT * FROM Clinicalinformation;

-- 	Uing any type of the joins create a view that combines multiple tables in a logical way
-- Generating view from 4 tables to get Pateint information 
CREATE OR REPLACE VIEW CombineMultiTables
AS
SELECT 
p.PatientID, p.FirstName, p.Surname, p.Gender,
c.DiagnosisDate,
d.DiseaseName,
t.TreatmentDescription,
t.Drug,
d.GeneSymbol,
c.GeneticTest
FROM Patients p
JOIN
Clinicalinformation c ON c.PatientID = p.PatientID
JOIN
Diseases d ON d.DiseaseName = c.DiseaseName
JOIN 
Treatments t ON t.TreatmentID = d.TreatmentID
WHERE d.GeneSymbol IS NOT NULL;

-- To view data from the view created
SELECT * FROM GeneticMedicalRecords.combinemultitables;

-- 	In your database, create a stored function that can be applied to a query in your DB
DELIMITER //
CREATE FUNCTION GetFullName(FirstName varchar(50), Surname varchar(50)) 
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    Return CONCAT(FirstName, ' ', Surname);
END;
//DELIMITER ;

-- stored funcion to return full names for all the patients from the Patients table
SELECT
PatientId, FirstName, Surname,
GetFullName(FirstName, Surname) AS FullName
FROM Patients;

-- stored funcion to return full name for a given PatientId from the Patients table 
-- SELECT PatientId, FirstName, Surname, GetFullName(FirstName, Surname) AS FullNamenFROM Patients where patientid=1;

--  In your database, create a stored procedure and demonstrate how it runs
-- This stored procedure to insert values in ClinicalInformation
DELIMITER //
CREATE PROCEDURE InsertClinicalInformation(
    IN p_PatientID INT,
    IN p_DiseaseName VARCHAR(100),
    IN p_DiagnosisDate DATE,
    IN p_GeneticTest VARCHAR(100),
    IN p_TreatmentStartDate DATE,
    IN p_TreatmentEndDate DATE
)
BEGIN
    INSERT INTO ClinicalInformation (PatientID, DiseaseName, DiagnosisDate, GeneticTest, TreatmentStartDate, TreatmentEndDate)
    VALUES (p_PatientID, p_DiseaseName, p_DiagnosisDate, p_GeneticTest, p_TreatmentStartDate, p_TreatmentEndDate);
END //
DELIMITER ;

CALL InsertClinicalInformation(5, 'Hemophilia A', '2024-09-11', 'WGS', '2022-12-15', NULL);

SELECT * FROM ClinicalInformation;

-- Prepare an example query with a subquery to demonstrate how to extract data from your DB for analysis
SELECT FirstName, Surname, PostCode
FROM Patients
WHERE PostCode IN (
SELECT PostCode
FROM Patients
Where PostCode = 'WF2 1AD');

SELECT FirstName, Surname, PostCode
FROM Patients
WHERE PostCode IN (
SELECT PostCode
FROM Address
Where PostCode IN('L23 0QQ', 'M23 0QQ')); 
 
--  Prepare an example query with group by and having to demonstrate how to extract data from your DB
SELECT * FROM ClinicalInformation;

SELECT COUNT(c.GeneticTest) AS TestCount,
c.GeneticTest
FROM ClinicalInformation AS c
GROUP BY c.GeneticTest
HAVING COUNT(c.GeneticTest) > 1;

-- Create a view that uses at least 3-4 base tables;
-- prepare and demonstrate a query that uses the view to produce a logically arranged result set for analysis
-- creating a View that combines information from the Patients, Address, Diseases, Genes, and ClinicalInformation tables
CREATE VIEW PatientDiseaseInfo AS
SELECT 
    p.PatientID, p.FirstName, p.Surname, p.Dob, p.PhoneNumber, p.EmailID, p.Gender,
    a.StreetAddress, a.City, a.PostCode, a.County,
    c.DiseaseName,
    d.Description AS DiseaseDescription,
    g.GeneSymbol, g.Description AS GeneDescription, g.Chromosome, g.StartPosition, EndPosition,
    c.DiagnosisDate, c.GeneticTest, c.TreatmentStartDate, c.TreatmentEndDate, 
    t.TreatmentDescription, t.Drug
FROM 
    Patients p
JOIN 
    Address a ON p.StreetAddress = a.StreetAddress AND p.PostCode = a.PostCode
JOIN 
    ClinicalInformation c ON p.PatientID = c.PatientID
JOIN 
    Diseases d ON c.DiseaseName = d.DiseaseName
JOIN 
    Genes g ON d.GeneSymbol = g.GeneSymbol
JOIN 
    Treatments t ON d.TreatmentID = t.TreatmentID;

SELECT PatientID, DiseaseName, FirstName, Surname, Dob, PhoneNumber, EmailID, Gender, StreetAddress, City, PostCode, County, DiseaseDescription,
    GeneSymbol, GeneDescription,
    Chromosome, StartPosition, EndPosition, DiagnosisDate, GeneticTest, TreatmentStartDate, TreatmentEndDate, TreatmentDescription, Drug
FROM 
    PatientDiseaseInfo
ORDER BY 
    PatientID, DiseaseName;


DELIMITER //

DROP FUNCTION IF EXISTS `GetFullName`;
//
CREATE DEFINER=`root`@`localhost` FUNCTION `GetFullName`(FirstName varchar(50), Surname varchar(50)) RETURNS varchar(100) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    Return CONCAT(FirstName, ' ', Surname);
END;
//

DELIMITER ;



 