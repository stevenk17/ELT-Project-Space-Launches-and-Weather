--Create tables for data to be loaded into

CREATE TABLE "spacelaunch"(
id INT PRIMARY KEY,
company varchar(255),
year DATE NOT NULL,
launchtime TIME NOT NULL,
launchsite varchar(255),
VehicleType varchar(255)
);
	
CREATE TABLE "spacelaunchdetail"(
name varchar(255) NOT NULL, 
id INT, 
mass INT, 
year DATE NOT NULL, 
Lat DECIMAL (11,8),
Long DECIMAL (10,8)
);


