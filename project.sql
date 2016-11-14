
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
`pilot_rank` ENUM('pilot', 'copilot') NOT NULL,
PRIMARY KEY (`pilot_id`),
FOREIGN KEY (`pilot_id`) REFERENCES `employee` (`employee_id`)  ON DELETE CASCADE
);

DELIMITER @@
CREATE TRIGGER check_flight_hours BEFORE INSERT ON `pilot`
FOR EACH ROW
BEGIN
IF NEW.flight_hours<0 THEN
SET NEW.flight_hours=0;
END IF;
END@@
DELIMITER;

CREATE TABLE `attendant` (
`attendant_id` int(10) NOT NULL,
`attendant_rank` ENUM('senior', 'junior') NOT NULL,
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
`plane_id` int(10) NOT NULL AUTO_INCREMENT,
`plane_model` varchar(15) NOT NULL,
PRIMARY KEY(`plane_id`),
FOREIGN KEY(`plane_model`) REFERENCES `model` (`plane_model`)
);

CREATE TABLE `flight`(
`flight_id` int(10) NOT NULL AUTO_INCREMENT,
`departing_city` varchar(30) NOT NULL,
`destination_city` varchar(30) NOT NULL,
`plane_id` int(10) NOT NULL,
`days` varchar(10) NOT NULL,
PRIMARY KEY (`flight_id`),
FOREIGN KEY (`plane_id`) REFERENCES `equipment` (`plane_id`)
);

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

/* OLD
SELECT reservation.flight_id, departing_city, destination_city, fname, lname, num_bags*20 AS price FROM flight, reservation, user, customer WHERE user_id = customer.customer_id AND customer.customer_id = reservation.customer_id AND reservation.flight_id = flight.flight_id GROUP BY flight.flight_id;

SELECT flight.flight_id, departing_city, destination_city, COUNT(reservation.flight_id) AS Passengers, SUM(reservation.num_bags*20) AS Revenue FROM flight, reservation WHERE reservation.flight_id = flight.flight_id;
*/

INSERT INTO `user` (`fname`, `lname`, `role`) VALUES ('John', 'Doe', 'pilot'), ('Jane', 'Smith', 'Admin'), ('Gus', 'Tomer', 'customer'), ('Ann', 'Smiley', 'attendant');
INSERT INTO `employee` (`employee_id`) VALUES (1), (2), (4);
INSERT INTO `customer` (`customer_id`, `age`) VALUES (3, 20);
INSERT INTO `admin` (`admin_id`) VALUES (2);
INSERT INTO `pilot` (`pilot_id`, `status`, `flight_hours`, `pilot_rank`) VALUES (1, 'active', 104, 'pilot');
INSERT INTO `attendant` (`attendant_id`, `attendant_rank`) VALUES (4, 'senior');
INSERT INTO `authentication` (`user_id`, `password`) VALUES (1, 'PilotPass'), (2, 'AdminPass'), (3, 'CustPass'), (4, 'AttPass');
INSERT INTO `model` (`plane_model`, `num_pilots`, `num_attendants`, `num_passengers`) VALUES ('Denali', 2, 1, 6), ('Longitude', 2, 1, 8);
INSERT INTO `equipment` (`plane_model`) VALUES ('Denali'), ('Denali'), ('Denali'), ('Longitude'), ('Longitude');
INSERT INTO `flight` (`departing_city`, `destination_city`, `plane_id`, `days`) VALUES ('Columbia', 'KansasCity', 2, 'Monday');
INSERT INTO `pilot_flight` (`pilot_id`, `flight_id`) VALUES (1, 1);
INSERT INTO `pilot_model` (`pilot_id`, `plane_model`) VALUES (1, 'Denali');
INSERT INTO `attendant_flight` (`attendant_id`, `flight_id`) VALUES (4, 1);
INSERT INTO `reservation` (`flight_id`, `customer_id`, `date_reserved`, `num_bags`) VALUES (1, 3, '2016-04-30', 4);

--new pilot
INSERT INTO `user` (`fname`, `lname`, `role`) VALUES ('Red', 'Baron', 'pilot');
INSERT INTO `employee` (`employee_id`) VALUES (5);
INSERT INTO `pilot` (`pilot_id`, `status`, `flight_hours`, `pilot_rank`) VALUES (5, 'active', 351, 'pilot');
INSERT INTO `authentication` (`user_id`, `password`) VALUES (5, 'B100dyB4r0n!');
INSERT INTO `pilot_model` (`pilot_id`, `plane_model`) VALUES (5, 'Denali'), (5, 'Longitude');

--new flight
INSERT INTO `flight` (`departing_city`, `destination_city`, `plane_id`, `days`) VALUES ('StLouis', 'Kickapoo', 4, 'Friday');
INSERT INTO `pilot_flight` (`pilot_id`, `flight_id`) VALUES (5, 2);

-- Show pilot name, source City, sink City, and plane model of flights
select fname, lname, departing_city, destination_city, plane_model, days from user, flight, pilot_flight, equipment where user_id=pilot_flight.pilot_id and pilot_flight.flight_id=flight.flight_id and equipment.plane_id=flight.plane_id;

--new flight to and from same city (if db is done properly, this shouldn't work [functionality not yet implemented; this should still work])
INSERT INTO `flight` (`departing_city`, `destination_city`, `plane_id`, `days`) VALUES ('JeffersonCity', 'JeffersonCity', 5, 'Saturday');
INSERT INTO `pilot_flight` (`pilot_id`, `flight_id`) VALUES (5, 3);

--new pilot with 0 flight hours (if db is done properly, this should set Zap Branigan's flight hours to 0 even though we're saying he's got -6 hours)
INSERT INTO `user` (`fname`, `lname`, `role`) VALUES ('Zap', 'Branigan', 'pilot');
INSERT INTO `employee` (`employee_id`) VALUES (6);
INSERT INTO `pilot` (`pilot_id`, `status`, `flight_hours`, `pilot_rank`) VALUES (6, 'active', -6, 'pilot');

