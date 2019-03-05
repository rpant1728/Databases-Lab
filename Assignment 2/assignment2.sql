CREATE DATABASE assignment2;
USE assignment2;

CREATE TABLE department(
    dept_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30)
);

INSERT INTO department (name) VALUES ("CSE");
INSERT INTO department (name) VALUES ("ECE");

CREATE TABLE course( 
   course_id VARCHAR(10) PRIMARY KEY,
   name VARCHAR(30),
   dept_id INT NOT NULL,
   FOREIGN KEY (dept_id) REFERENCES department (dept_id)
);

INSERT INTO course (course_id, name, dept_id) VALUES ("CS345", "Databases", 1);
INSERT INTO course (course_id, name, dept_id) VALUES ("CS346", "Databases Lab", 1);
INSERT INTO course (course_id, name, dept_id) VALUES ("EE101", "Introduction to Electricals", 2);

CREATE TABLE lecturer(
    lec_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES department (dept_id) 
);

INSERT INTO lecturer (name, dept_id) VALUES ("Sanasam Ranbir Singh", 1);
INSERT INTO lecturer (name, dept_id) VALUES ("Amit Awekar", 1);
INSERT INTO lecturer (name, dept_id) VALUES ("Tony Jacob", 2);

CREATE TABLE student(
    roll_no INT NOT NULL PRIMARY KEY,
    name VARCHAR(30),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES department (dept_id) 
);

INSERT INTO student (roll_no, name, dept_id) VALUES (160101049, "Rohit Pant", 1);
INSERT INTO student (roll_no, name, dept_id) VALUES (160101048, "Nitin Kedia", 1);
INSERT INTO student (roll_no, name, dept_id) VALUES (160101039, "Kapil Goyal", 1);
INSERT INTO student (roll_no, name, dept_id) VALUES (160101046, "Namit Kumar", 2);

CREATE TABLE study (
    stud_id INT NOT NULL,
    course_id VARCHAR(10),
    PRIMARY KEY (stud_id, course_id),
    FOREIGN KEY (stud_id) REFERENCES student (roll_no),
    FOREIGN KEY (course_id) REFERENCES course (course_id)
);

INSERT INTO study (stud_id, course_id) VALUES (160101049, "CS345");
INSERT INTO study (stud_id, course_id) VALUES (160101049, "CS346");
INSERT INTO study (stud_id, course_id) VALUES (160101049, "EE101");
INSERT INTO study (stud_id, course_id) VALUES (160101048, "CS345");
INSERT INTO study (stud_id, course_id) VALUES (160101039, "CS346");
INSERT INTO study (stud_id, course_id, marks) VALUES (160101046, "CS345", 65);

-- DROP TRIGGER IF EXISTS check_dept;
-- CREATE TRIGGER check_dept BEFORE INSERT ON teach 
-- FOR EACH ROW BEGIN
--     SET @dept = (SELECT dept_id FROM lecturer WHERE lec_id=NEW.lec_id LIMIT 1);
--     SET @dept1 = (SELECT dept_id FROM course WHERE course_id=NEW.course_id LIMIT 1);
--     IF (@dept <=> NULL) OR (@dept1 <=> NULL) OR @dept1 != @dept
--         THEN
--             SIGNAL SQLSTATE '45000'
--                 SET MESSAGE_TEXT = 'Lecturer department id does not match course id!';
--     END IF;
-- END

-- DROP TRIGGER IF EXISTS check_dept1;
-- CREATE TRIGGER check_dept1 BEFORE INSERT ON study 
-- FOR EACH ROW BEGIN
--     SET @dept = (SELECT dept_id FROM course WHERE course_id=NEW.course_id LIMIT 1);
--     IF @dept <=> NULL
--         THEN
--             SIGNAL SQLSTATE '45000'
--                 SET MESSAGE_TEXT = 'Course department is NULL!';
--     END IF;
-- END

-- CREATE TABLE teach (
--     lec_id INT NOT NULL,
--     course_id VARCHAR(10),
--     PRIMARY KEY (lec_id, course_id),
--     FOREIGN KEY (lec_id) REFERENCES lecturer (lec_id),
--     FOREIGN KEY (course_id) REFERENCES course (course_id)
-- );

CREATE TABLE teach (
    lec_id INT NOT NULL,
    course_id VARCHAR(10),
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id, lec_id) REFERENCES lecturer (dept_id, lec_id),
    FOREIGN KEY (dept_id, course_id) REFERENCES course (dept_id, course_id),
    PRIMARY KEY (lec_id, course_id, dept_id)
);

INSERT INTO teach (lec_id, course_id, dept_id) VALUES (1, "CS345", 1);
INSERT INTO teach (lec_id, course_id, dept_id) VALUES (1, "CS346", 1);
INSERT INTO teach (lec_id, course_id, dept_id) VALUES (2, "CS346", 1);
INSERT INTO teach (lec_id, course_id, dept_id) VALUES (3, "EE101", 2);

1 SELECT * FROM student WHERE roll_no IN (
    SELECT stud_id FROM study WHERE course_id = "CS345"
  );

2 SELECT * FROM student WHERE roll_no IN (
    SELECT stud_id FROM study WHERE course_id IN (
        SELECT course_id FROM teach WHERE lec_id=1
    )
  );

3 SELECT * FROM course WHERE course_id IN (
    SELECT course_id FROM study WHERE stud_id=160101049
    ) AND dept_id != (SELECT dept_id FROM student WHERE roll_no=160101049
  ); 

4 INSERT INTO study (stud_id, course_id, marks) VALUES (160101046, "CS347", 65);

5 DELETE FROM course WHERE course_id="EE101";

6 SELECT * FROM course WHERE course_id IN (
    SELECT course_id FROM study WHERE stud_id=160101049
  ); 

7 SELECT * FROM student WHERE roll_no IN (
    SELECT stud_id FROM study WHERE course_id IN (
        SELECT course_id FROM study WHERE stud_id=160101049
    )
  );

8 SELECT * FROM course WHERE course_id IN (
    SELECT course_id FROM study WHERE stud_id IN (
        SELECT roll_no FROM student WHERE dept_id!=1
    )
  );

9 SELECT * FROM student WHERE roll_no IN (
    SELECT stud_id FROM study WHERE marks>75 AND marks<96 AND course_id="CS345"
  );

10 INSERT INTO teach (lec_id, course_id, dept_id) VALUES (2, "EE101", 2);






