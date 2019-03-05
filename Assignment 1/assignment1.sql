CREATE DATABASE university;
USE university;

CREATE TABLE department(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30)
);
SHOW tables;

INSERT INTO department (name) VALUES ("CSE");
INSERT INTO department (name) VALUES ("ECE");

CREATE TABLE course( 
    id VARCHAR(10) PRIMARY KEY,
   name VARCHAR(30),
   dept_id INT,
   FOREIGN KEY (dept_id) REFERENCES department (id)
);

INSERT INTO course (id, name, dept_id) VALUES ("CS345", "Databases", 1);
INSERT INTO course (id, name, dept_id) VALUES ("CS346", "Databases Lab", 1);

CREATE TABLE lecturer(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES department (id) 
);

INSERT INTO lecturer (name, dept_id) VALUES ("Samit Bhattacharya", 1);
INSERT INTO lecturer (name, dept_id) VALUES ("Tony Jacob", 2);

CREATE TABLE module(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    prof_id INT,
    FOREIGN KEY (prof_id) REFERENCES lecturer (id) 
);

INSERT INTO module (name, prof_id) VALUES ("SQL Databases", "1");
INSERT INTO module (name, prof_id) VALUES ("NoSQL Databases", "2");

CREATE TABLE student(
    roll_no INT NOT NULL PRIMARY KEY,
    name VARCHAR(30),
    gender CHAR(1)
);

INSERT INTO student (roll_no, name, gender) VALUES (160101049, "Rohit Pant", "M");
INSERT INTO student (roll_no, name, gender) VALUES (160101048, "Nitin Kedia", "M");

CREATE TABLE enrolment(
    stud_id INT NOT NULL,
    course_id VARCHAR(10),
    PRIMARY KEY (stud_id, course_id),
    FOREIGN KEY (stud_id) REFERENCES student (roll_no),
    FOREIGN KEY (course_id) REFERENCES course (id)
);

INSERT INTO enrolment (stud_id, course_id) VALUES (160101049, "CS345");
INSERT INTO enrolment (stud_id, course_id) VALUES (160101048, "CS346");

CREATE TABLE study (
    stud_id INT NOT NULL,
    mod_id INT NOT NULL,
    PRIMARY KEY (stud_id, mod_id),
    FOREIGN KEY (stud_id) REFERENCES student (roll_no),
    FOREIGN KEY (mod_id) REFERENCES module (id)
);

INSERT INTO study (stud_id, mod_id) VALUES (160101049, 1);
INSERT INTO study (stud_id, mod_id) VALUES (160101049, 2);

CREATE TABLE tutors (
    lec_id INT NOT NULL,
    stud_id INT NOT NULL,
    PRIMARY KEY (lec_id, stud_id),
    FOREIGN KEY (stud_id) REFERENCES student (roll_no),
    FOREIGN KEY (lec_id) REFERENCES lecturer (id)
);

INSERT INTO tutors (lec_id, stud_id) VALUES (1, 160101049);
INSERT INTO tutors (lec_id, stud_id) VALUES (2, 160101048);

CREATE TABLE course_module (
    course_id VARCHAR(10) NOT NULL,
    mod_id INT NOT NULL,
    PRIMARY KEY (course_id, mod_id),
    FOREIGN KEY (course_id) REFERENCES course (id),
    FOREIGN KEY (mod_id) REFERENCES module (id)
);

INSERT INTO course_module (course_id, mod_id) VALUES ("CS345", 1);
INSERT INTO course_module (course_id, mod_id) VALUES ("CS345", 2);

