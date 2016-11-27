--DB for Group 21 CS3380 Project Fall 2016 - MissouriAir
--DB is Boyce-Codd Normalized

--To drop all tables, execute the following in this order:

DROP TABLE IF EXISTS `attendant_flight`;
DROP TABLE IF EXISTS `pilot_flight`;
DROP TABLE IF EXISTS `pilot_model`;
DROP TABLE IF EXISTS `reservation`;
DROP TABLE IF EXISTS `flight`;
DROP TABLE IF EXISTS `equipment`;
DROP TABLE IF EXISTS `model`;
DROP TABLE IF EXISTS `attendant`;
DROP TABLE IF EXISTS `pilot`;
DROP TABLE IF EXISTS `admin`;
DROP TABLE IF EXISTS `customer`;
DROP TABLE IF EXISTS `authentication`;
DROP TABLE IF EXISTS `employee`;
DROP TABLE IF EXISTS `log`;
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
`user_id` int(10) NOT NULL AUTO_INCREMENT,
`fname` varchar(15) NOT NULL,
`lname` varchar(15) NOT NULL,
`role` ENUM('admin', 'pilot', 'attendant', 'customer') NOT NULL DEFAULT 'customer',
PRIMARY KEY (`user_id`)
);

CREATE TABLE `log` (
`log_id` int(10) NOT NULL AUTO_INCREMENT,
`ip_address` varchar(10) NOT NULL,
`action_date` date NOT NULL,
`action` varchar(50) NOT NULL,
`user_id` int(10) NOT NULL,
PRIMARY KEY(`log_id`),
FOREIGN KEY(`user_id`) REFERENCES `user` (`user_id`)
);

CREATE TABLE `employee` (
`employee_id` int(10) NOT NULL,
PRIMARY KEY(`employee_id`),
FOREIGN KEY (`employee_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
);

CREATE TABLE `authentication`(
`user_id` int(10) NOT NULL,
`passname` varchar(30) NOT NULL,
`password` varchar(30) NOT NULL,
PRIMARY KEY(`user_id`),
FOREIGN KEY(`user_id`) REFERENCES `user` (`user_id`)  ON DELETE CASCADE
);

CREATE TABLE `customer` (
`customer_id` int(10) NOT NULL,
`age` int(3) NOT NULL,
PRIMARY KEY (`customer_id`),
FOREIGN KEY (`customer_id`) REFERENCES `user` (`user_id`)  ON DELETE CASCADE
);

CREATE TABLE `admin`(
`admin_id` int(10) NOT NULL,
PRIMARY KEY (`admin_id`),
FOREIGN KEY (`admin_id`) REFERENCES `employee` (`employee_id`)  ON DELETE CASCADE
);

CREATE TABLE `pilot` (
`pilot_id` int(10) NOT NULL,
`status` ENUM('active', 'inactive') NOT NULL,
`flight_hours` int(10) NOT NULL,
`pilot_rank` ENUM('first officer', 'captain', 'senior captain') NOT NULL,
PRIMARY KEY (`pilot_id`),
FOREIGN KEY (`pilot_id`) REFERENCES `employee` (`employee_id`)  ON DELETE CASCADE
);

DELIMITER $$
CREATE TRIGGER check_flight_hours BEFORE INSERT ON `pilot`
FOR EACH ROW BEGIN
IF NEW.flight_hours<0 THEN
SET NEW.flight_hours=NULL;
END IF;
END $$;
$$
DELIMITER ;

CREATE TABLE `attendant` (
`attendant_id` int(10) NOT NULL,
`attendant_rank` ENUM('senior', 'junior') NOT NULL,
`attendant_status` ENUM('active', 'inactive') NOT NULL,
`attendant_hours` int(10) NOT NULL,
PRIMARY KEY (`attendant_id`),
FOREIGN KEY (`attendant_id`) REFERENCES `employee` (`employee_id`)  ON DELETE CASCADE
);

CREATE TABLE `model`(
`plane_model` varchar(15) NOT NULL,
`num_pilots` int(2) NOT NULL,
`num_attendants` int(2) NOT NULL,
`num_passengers` int(4) NOT NULL,
PRIMARY KEY (`plane_model`)
);

CREATE TABLE `equipment`(
`plane_id` varchar(10) NOT NULL,
`plane_model` varchar(15) NOT NULL,
PRIMARY KEY(`plane_id`),
FOREIGN KEY(`plane_model`) REFERENCES `model` (`plane_model`)
);

CREATE TABLE `flight`(
`flight_id` int(10) NOT NULL AUTO_INCREMENT,
`departing_city` varchar(30) NOT NULL,
`destination_city` varchar(30) NOT NULL,
`plane_id` varchar(10) NOT NULL,
`departure_date` date NOT NULL,
`departure_time` time NOT NULL,
`trip_duration` time NOT NULL,
`base_price` decimal(3,2) NOT NULL,
PRIMARY KEY (`flight_id`),
FOREIGN KEY (`plane_id`) REFERENCES `equipment` (`plane_id`)
);

DELIMITER @@
CREATE TRIGGER check_no_circle_flight BEFORE INSERT ON `flight`
FOR EACH ROW BEGIN
IF NEW.departing_city = NEW.destination_city THEN
SET NEW.destination_city = NULL;
END IF;
END @@;
@@
DELIMITER ;

CREATE TABLE `reservation`(
`flight_id` int(10) NOT NULL,
`customer_id` int(10) NOT NULL,
`date_reserved` date NOT NULL,
`num_bags` int(2) NOT NULL,
PRIMARY KEY (`flight_id`, `customer_id`),
FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`) ON DELETE CASCADE,
FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE
);

CREATE TABLE `pilot_model`(
`pilot_id` int(10) NOT NULL,
`plane_model` varchar(15) NOT NULL,
PRIMARY KEY (`pilot_id`, `plane_model`),
FOREIGN KEY (`pilot_id`) REFERENCES `pilot` (`pilot_id`) ON DELETE CASCADE,
FOREIGN KEY (`plane_model`) REFERENCES `model`(`plane_model`) ON DELETE CASCADE
);

CREATE TABLE `pilot_flight` (
`pilot_id` int(10) NOT NULL,
`flight_id` int(10) NOT NULL,
PRIMARY KEY (`pilot_id`, `flight_id`),
FOREIGN KEY (`pilot_id`) REFERENCES `pilot` (`pilot_id`) ON DELETE CASCADE,
FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`) ON DELETE CASCADE
);

CREATE TABLE `attendant_flight`(
`attendant_id` int(10) NOT NULL,
`flight_id` int(10) NOT NULL,
PRIMARY KEY (`attendant_id`, `flight_id`),
FOREIGN KEY (`attendant_id`) REFERENCES `attendant` (`attendant_id`) ON DELETE CASCADE,
FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`) ON DELETE CASCADE
);


--   --   --   --   --   --   --   --   --   --   --   --   --   --   --   --

-- test queries (note price calculation may not be right in queries: it is (1.05(base_price + 20*num_bags)))
SELECT reservation.flight_id, departing_city, destination_city, fname, lname, num_bags*20 AS price FROM flight, reservation, user, customer WHERE user_id = customer.customer_id AND customer.customer_id = reservation.customer_id AND reservation.flight_id = flight.flight_id GROUP BY flight.flight_id;

SELECT flight.flight_id, departing_city, destination_city, COUNT(reservation.flight_id) AS Passengers, ROUND(SUM((flight.base_price + reservation.num_bags*20)*1.05), 2) AS Revenue FROM flight INNER JOIN reservation WHERE reservation.flight_id = flight.flight_id;


--Create a pilot, an admin, a customer, and an attendant and give them authentication
--Also add some plane models, equipment, and flights
--Give the pilot authorization to fly the Denali
--Also schedule the pilot for the flight
--Also make a reservation by the customer on the flight
INSERT INTO `user` (`fname`, `lname`, `role`) VALUES ('John', 'Doe', 'pilot'), ('Jane', 'Smith', 'Admin'), ('Gus', 'Tomer', 'customer'), ('Ann', 'Smiley', 'attendant');
INSERT INTO `employee` (`employee_id`) VALUES (1), (2), (4);
INSERT INTO `customer` (`customer_id`, `age`) VALUES (3, 20);
INSERT INTO `admin` (`admin_id`) VALUES (2);
INSERT INTO `pilot` (`pilot_id`, `status`, `flight_hours`, `pilot_rank`) VALUES (1, 'active', 104, 'senior captain');
INSERT INTO `attendant` (`attendant_id`, `attendant_rank`, `attendant_status`, `attendant_hours`) VALUES (4, 'senior', 'active', 58);
INSERT INTO `authentication` (`user_id`, `passname`, `password`) VALUES (1, 'PilotUser', 'PilotPass'), (2, 'AdminUser', 'AdminPass'), (3, 'CustUser', 'CustPass'), (4, 'AttUser', 'AttPass');
INSERT INTO `model` (`plane_model`, `num_pilots`, `num_attendants`, `num_passengers`) VALUES ('Denali', 2, 1, 6), ('Longitude', 2, 1, 8);
INSERT INTO `equipment` (`plane_id`, `plane_model`) VALUES ('1', 'Denali'), ('2', 'Denali'), ('3', 'Denali'), ('4', 'Longitude'), ('5', 'Longitude');
INSERT INTO `flight` (`departing_city`, `destination_city`, `plane_id`, `departure_date`, `departure_time`, `trip_duration`, `base_price`) VALUES ('Columbia', 'KansasCity', '2', '2016-05-13', '16:00', '00:30', 100.00);
INSERT INTO `pilot_flight` (`pilot_id`, `flight_id`) VALUES (1, 1);
INSERT INTO `pilot_model` (`pilot_id`, `plane_model`) VALUES (1, 'Denali');
INSERT INTO `attendant_flight` (`attendant_id`, `flight_id`) VALUES (4, 1);
INSERT INTO `reservation` (`flight_id`, `customer_id`, `date_reserved`, `num_bags`) VALUES (1, 3, '2016-04-30', 4);

/*  new pilot:
		Name: Red Baron
		ID: 5 (hardcoded)
		PassWord: B100dyB4r0n!
		Role: Pilot
		Rank: Pilot
		Activity: Active
		Hours: 351
		Can Fly: Denali, Longitude
*/
INSERT INTO `user` (`fname`, `lname`, `role`) VALUES ('Red', 'Baron', 'pilot');
INSERT INTO `employee` (`employee_id`) VALUES (5);
INSERT INTO `pilot` (`pilot_id`, `status`, `flight_hours`, `pilot_rank`) VALUES (5, 'active', 351, 'Senior Captain');
INSERT INTO `authentication` (`user_id`, `passname`, `password`) VALUES (5, 'BaronUser', 'B100dyB4r0n!');
INSERT INTO `pilot_model` (`pilot_id`, `plane_model`) VALUES (5, 'Denali'), (5, 'Longitude');

/*new flight:
	ID: 2
	From: St. Louis
	To: Kickapoo
	Day: Friday
	Plane: 4 (Longitude) 
	PIlot: Red Baron
*/
INSERT INTO `flight` (`departing_city`, `destination_city`, `plane_id`, `departure_date`, `departure_time`, `trip_duration`, `base_price`) VALUES ('StLouis', 'Kickapoo', '4', '2016-11-27', '10:30', '01:15', 100);
INSERT INTO `pilot_flight` (`pilot_id`, `flight_id`) VALUES (5, 2);

-- Show pilot name, source City, sink City, and plane model of flights
select fname, lname, departing_city, destination_city, plane_model, days from user, flight, pilot_flight, equipment where user_id=pilot_flight.pilot_id and pilot_flight.flight_id=flight.flight_id and equipment.plane_id=flight.plane_id;

--new flight to and from same city (if db is done properly, this should set destination city to NULL and therefore cause an error)
INSERT INTO `flight` (`departing_city`, `destination_city`, `plane_id`, `days`, `base_price`) VALUES ('JeffersonCity', 'JeffersonCity', '5', 'Saturday', 100);
INSERT INTO `pilot_flight` (`pilot_id`, `flight_id`) VALUES (5, 3);

--new pilot with 0 flight hours (if db is done properly, this should set Zap Branigan's flight hours to NULL which should result in an error)
INSERT INTO `user` (`fname`, `lname`, `role`) VALUES ('Zap', 'Branigan', 'pilot');
INSERT INTO `employee` (`employee_id`) VALUES (6);
INSERT INTO `pilot` (`pilot_id`, `status`, `flight_hours`, `pilot_rank`) VALUES (6, 'active', -6, 'First Officer');


-- SQL commands to alter flight table to have three fields describing departure instead of just `days` 
ALTER TABLE `flight` DROP COLUMN `days`;
ALTER TABLE `flight` ADD `departure_date` date NOT NULL;
ALTER TABLE `flight` ADD `departure_time` time NOT NULL;
ALTER TABLE `flight` ADD `trip_duration` time NOT NULL;
-- --