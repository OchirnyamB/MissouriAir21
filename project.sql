DROP TABLE IF EXISTS 'user';
CREATE TABLE `user` (
`user_id` int(10) NOT NULL AUTO_INCREMENT,
`fname` varchar(15),
`lname` varchar(15),
PRIMARY KEY (`user_id`)
);

DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
`log_id` int(10) NOT NULL AUTO_INCREMENT,
`ip_address` varchar(10) NOT NULL,
`action_date` date NOT NULL,
`action` varchar(50) NOT NULL,
`user_id` int(10) NOT NULL,
PRIMARY KEY(`log_id`),
FOREIGN KEY(`user_id`) REFERENCES `user` (`user_id`)
);

DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
`employee_id` int(10) NOT NULL,
`role` varchar(10),
PRIMARY KEY(`employee_id`),
FOREIGN KEY (`employee_id`) REFERENCES `user` (`user_id`)
);

DROP TABLE IF EXISTS `authentication`;
CREATE TABLE `authentication`(
`employee_id` int(10) NOT NULL,
`password` varchar(30) NOT NULL,
`role` varchar(10),
PRIMARY KEY(`employee_id`),
FOREIGN KEY(`employee_id`) REFERENCES `employee` (`employee_id`)
);

DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
`customer_id` int(10) NOT NULL,
`age` int(3) NOT NULL,
PRIMARY KEY (`customer_id`),
FOREIGN KEY (`customer_id`) REFERENCES `user` (`user_id`)
);

DROP TABLE IF EXISTS `administrator`;
CREATE TABLE `administrator`(
`admin_id` int(10) NOT NULL,
`admin_rank` varchar(10),
PRIMARY KEY (`admin_id`),
FOREIGN KEY (`admin_id`) REFERENCES `employee` (`employee_id`)
);

DROP TABLE IF EXISTS `pilot`;
CREATE TABLE `pilot` (
`pilot_id` int(10) NOT NULL,
`status` varchar(10) NOT NULL,
`flight_hours` int(10),
`pilot_rank` varchar(10) NOT NULL,
PRIMARY KEY (`pilot_id`),
FOREIGN KEY (`pilot_id`) REFERENCES `employee` (`employee_id`)
);

DROP TABLE IF EXISTS `attendant`;
CREATE TABLE `attendant` (
`attendant_id` int(10) NOT NULL,
`attendant_rank` varchar(10) NOT NULL,
PRIMARY KEY (`attendant_id`),
FOREIGN KEY (`attendant_id`) REFERENCES `employee` (`employee_id`)
);

DROP TABLE IF EXISTS `model`;
CREATE TABLE `model`(
`plane_model` varchar(15) NOT NULL,
`num_pilots` int(2) NOT NULL,
`num_attendants` int(2) NOT NULL,
`num_passengers` int(4) NOT NULL,
PRIMARY KEY (`plane_model`)
);

DROP TABLE IF EXISTS `equipment`;
CREATE TABLE `equipment`(
`plane_id` int(10) NOT NULL AUTO_INCREMENT,
`plane_model` varchar(15) NOT NULL,
PRIMARY KEY(`plane_id`),
FOREIGN KEY(`plane_model`) REFERENCES `model` (`plane_model`)
);

DROP TABLE IF EXISTS `flight`;
CREATE TABLE `flight`(
`flight_id` int(10) NOT NULL AUTO_INCREMENT,
`departing_city` varchar(30) NOT NULL,
`destination_city` varchar(30) NOT NULL,
--price should not be in the flight table; price should be in reservation table
`plane_id` int(10) NOT NULL,
`days` varchar(10) NOT NULL, --i've forgotten what this is??
PRIMARY KEY (`flight_id`),
FOREIGN KEY (`plane_id`) REFERENCES `equipment` (`plane_id`)
);

DROP TABLE IF EXISTS `reservation`;
CREATE TABLE `reservation`(
`flight_id` int(10) NOT NULL,
`customer_id` int(10) NOT NULL,
`date_reserved` date NOT NULL,
`num_bags` int(2) NOT NULL,
--for normalization, price should be calculated on the fly based on num_bags
PRIMARY KEY (`flight_id`, `customer_id`),
FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`)
);

DROP TABLE IF EXISTS `pilot_model`;
CREATE TABLE `pilot_model`(
`pilot_id` int(10) NOT NULL,
`plane_model` varchar(15) NOT NULL,
PRIMARY KEY (`pilot_id`, `plane_model`),
FOREIGN KEY (`pilot_id`) REFERENCES `pilot` (`pilot_id`),
FOREIGN KEY (`plane_model`) REFERENCES `model`(`plane_model`)
);

DROP TABLE IF EXISTS `pilot_flight`;
CREATE TABLE `pilot_flight` (
`pilot_id` int(10) NOT NULL,
`flight_id` int(10) NOT NULL,
PRIMARY KEY (`pilot_id`, `flight_id`),
FOREIGN KEY (`pilot_id`) REFERENCES `pilot` (`pilot_id`),
FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`)
);

DROP TABLE IF EXISTS `attendant_flight`;
CREATE TABLE `attendant_flight`(
`attendant_id` int(10) NOT NULL,
`flight_id` int(10) NOT NULL,
PRIMARY KEY (`attendant_id`, `flight_id`),
FOREIGN KEY (`attendant_id`) REFERENCES `attendant` (`attendant_id`),
FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`)
);