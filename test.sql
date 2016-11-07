
DROP TABLE IF EXISTS test.log;
DROP TABLE IF EXISTS test.user;
DROP TABLE IF EXISTS test.employee;
DROP TABLE IF EXISTS test.pilot;
DROP TABLE IF EXISTS test.administrator;
DROP TABLE IF EXISTS test.attendant;
DROP TABLE IF EXISTS test.customer;
DROP TABLE IF EXISTS test.authentication;
DROP TABLE IF EXISTS test.reservation;
DROP TABLE IF EXISTS test.flight;
DROP TABLE IF EXISTS test.model;
DROP TABLE IF EXISTS test.equipment;
DROP TABLE IF EXISTS test.pilot_model;
DROP TABLE IF EXISTS test.pilot_flight;
DROP TABLE IF EXISTS test.attendant_flight;

CREATE TABLE user (
  user_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  PRIMARY KEY (user_id)
);

CREATE TABLE log (
 log_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
 ip_address INT UNSIGNED NOT NULL,
 action_date DATE NOT NULL,
 action VARCHAR(255),
 PRIMARY KEY(log_id),
 fk_user INT UNSIGNED NOT NULL REFERENCES user(user_id)
);

CREATE TABLE employee (
  employee_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  role VARCHAR(1),
  fk_user_id INT UNSIGNED NOT NULL REFERENCES user(user_id),
  PRIMARY KEY(employee_id)
);

CREATE TABLE customer (
  customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  age INT UNSIGNED,
  fk_user_id INT UNSIGNED NOT NULL REFERENCES user(user_id),
  PRIMARY KEY(customer_id)
);

CREATE TABLE authentication (
  password VARCHAR(20) NOT NULL,
  fk_emp_id INT UNSIGNED NOT NULL REFERENCES employee(employee_id),
  PRIMARY KEY(fk_emp_id)
);

CREATE TABLE administrator (
  fk_employee_id INT UNSIGNED NOT NULL REFERENCES employee(employee_id),
  admin_rank VARCHAR(20) NOT NULL,
  PRIMARY KEY(fk_employee_id)
);

CREATE TABLE pilot (
  fk_employee_id INT UNSIGNED NOT NULL REFERENCES employee(employee_id),
  status BOOLEAN NOT NULL,
  flight_hours INT UNSIGNED,
  pilot_rank VARCHAR(20),
  PRIMARY KEY(fk_employee_id),
);

CREATE TABLE attendant (
  fk_employee_id INT UNSIGNED NOT NULL REFERENCES employee(employee_id),
  attendant_rank VARCHAR(20),
  PRIMARY KEY(fk_employee_id),
);

CREATE TABLE model (
  plane_model VARCHAR(20) NOT NULL,
  num_pilots INT UNSIGNED ,
  num_attendants INT UNSIGNED,
  num_passengers INT UNSIGNED,
  PRIMARY KEY(plane_model)
);

CREATE TABLE pilot_model (
  fk_employee_id INT UNSIGNED NOT NULL REFERENCES pilot(employee_id),
  fk_plane_model VARCHAR(20) NOT NULL REFERENCES model(plane_model),
  PRIMARY KEY(fk_employee_id, fk_plane_model)
);

CREATE TABLE flight (
  flight_num INT NOT NULL AUTO_INCREMENT,
  departing_city VARCHAR(50),
  destination_city VARCHAR(50),
  price FLOAT(3,2),
  days VARCHAR(20),
  fk_plane_id INT UNSIGNED NOT NULL REFERENCES equipment(plane_id),
  PRIMARY KEY(flight_num)
);

CREATE TABLE pilot_flight (
  fk_employee_id INT UNSIGNED NOT NULL REFERENCES pilot(employee_id),
  fk_flight_num INT UNSIGNED NOT NULL REFERENCES flight(flight_num),
  PRIMARY KEY(fk_employee_id, fk_flight_num)
);

CREATE TABLE attendant_flight (
  fk_employee_id INT UNSIGNED NOT NULL REFERENCES attendant(employee_id),
  fk_flight_num INT UNSIGNED NOT NULL REFERENCES flight(flight_num),
  PRIMARY KEY(fk_employee_id, fk_flight_num)
);

CREATE TABLE equipment (
  plane_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  fk_plane_model VARCHAR(20) NOT NULL REFERENCES model(plane_model),
  PRIMARY KEY(plane_id)
);

CREATE TABLE reservation (
  fk_flight_num VARCHAR(20) NOT NULL REFERENCES flight(flight_num),
  fk_customer_id INT UNSIGNED NOT NULL REFERENCES customer(customer_id),
  date_reserved DATE,
  num_bags INT UNSIGNED,
  total_price FLOAT(3,2)
);
