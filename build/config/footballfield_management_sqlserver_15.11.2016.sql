/*
author: pvhuy84
date: 16-11-2016
database: sqlserver2008 r2
*/

/*
CREATE DATABASE footballfield_management
*/
IF EXISTS(select * from sys.databases where name='footballfield_management') DROP DATABASE footballfield_management
CREATE DATABASE footballfield_management
GO

/* Notice: execute commands one by one*/

/*
CREATE TABLES IN DATABASE "footballfield_management"
*/

CREATE TABLE [user] (
	phonenumber varchar (15),
	password varchar (25),
	name nvarchar (25),
	role INT,
	PRIMARY KEY (phonenumber)
)
GO

CREATE TABLE type (
	type INT,
	price INT,
	PRIMARY KEY (type)
)
GO

CREATE TABLE field (
	field_id varchar (4),
	status varchar (10),
	PRIMARY KEY (field_id)
)
GO

CREATE TABLE timepacket (
	timepacket_id int not null,
	description varchar(15) not null,
	type INT not null,
	PRIMARY KEY (timepacket_id),
	FOREIGN KEY (type) REFERENCES type(type)
)
GO

CREATE TABLE bookfield (
	phonenumber varchar(15) not null,
	field_id varchar(4) not null,
	timepacket_id INT not null,
	day DATE not null,
	status varchar (15) not null,
	primary key (field_id, timepacket_id, day),
	FOREIGN KEY (phonenumber) REFERENCES [user](phonenumber),
	FOREIGN KEY (field_id) REFERENCES field(field_id),
	FOREIGN KEY (timepacket_id) REFERENCES timepacket(timepacket_id)
)
GO

/*
INSERT DATA TO TABLES OF DATABASE
*/

INSERT INTO [user] (phonenumber, password, name, role) 
VALUES
	('01222333333', '123456', N'Hoàng Thành Công', 0),
	('01666555555', '123456', N'Nguyễn Khánh Thọ', 1),
	('01222222222', '123456', N'Nguyễn Duy Tiến', 0),
	('01666666666', '123456', N'Phạm Hồng Nguyên', 0),
	('01222444444', '123456', N'Lê Văn Khoa', 0),
	('0111', '123', N'Phạm Văn Huy', 1)
GO

INSERT INTO type(type, price) 
VALUES
	(1, 50000),
	(2, 60000),
	(3, 70000);
GO

INSERT INTO field (field_id, status) 
VALUES
	('F01', 'normal'),
	('F02', 'normal'),
	('F03', 'repairing');
GO

INSERT INTO timepacket (timepacket_id, description, type) 
VALUES
	(1, '07:00 - 08:00', 1),
	(2, '08:00 - 09:00', 2),
	(3, '09:00 - 10:00', 2),
	(4, '11:00 - 12:00', 1),
	(5, '13:00 - 14:00', 2),
	(6, '14:00 - 15:00', 2),
	(7, '15:00 - 16:00', 3),
	(8, '16:00 - 17:00', 3),
	(9, '17:00 - 18:00', 3),
	(10, '18:00 - 19:00', 3),
	(11, '19:00 - 20:00', 2),
	(12, '20:00 - 21:00', 2);
GO

INSERT INTO bookfield (phonenumber, field_id, timepacket_id, day, status) 
VALUES
	('01222333333', 'F01', 4, '2016-11-16', 'confirmed'),
	('01666555555', 'F02', 10, '2016-11-17', 'unconfirmed'),
	('01222222222', 'F01', 1, '2016-11-16', 'confirmed'),
	('01666666666', 'F02', 2, '2016-11-17', 'unconfirmed'),
	('01222444444', 'F01', 11, '2016-11-16', 'unconfirmed'),
	('01666555555', 'F02', 6, '2016-11-17', 'unconfirmed'),
	('01222444444', 'F01', 7, '2016-11-16', 'confirmed'),
	('01666666666', 'F02', 8, '2016-11-17', 'unconfirmed'),
	('123', 'F02', 5, '2016-11-17', 'unconfirmed'),
	('123', 'F01', 9, '2016-11-16', 'confirmed'),
	('123', 'F02', 8, '2016-11-18', 'unconfirmed')
GO

/*
Select field have book for user or admin
*/
SELECT bookfield.field_id, bookfield.day, bookfield.timepacket_id, timepacket.description, bookfield.status 
FROM bookfield 
	JOIN timepacket
		ON  bookfield.timepacket_id=timepacket.timepacket_id
WHERE bookfield.phonenumber='123'
GO

/*
Select field not booked
*/
SELECT field.field_id 
FROM field
WHERE field.field_id
	NOT IN (
		SELECT bookfield.field_id
		FROM bookfield 
			JOIN timepacket
				ON  bookfield.timepacket_id=timepacket.timepacket_id
		WHERE bookfield.day='2016-11-16' AND bookfield.timepacket_id='7'
		)
GO
