CREATE DATABASE assignment4;
USE assignment4;

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
INSERT INTO study (stud_id, course_id, marks) VALUES (160101046, "CS346", 70);
INSERT INTO study (stud_id, course_id, marks) VALUES (160101046, "EE101", 101);

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

1
CREATE INDEX marks ON study(course_id, marks);

SELECT name FROM study INNER JOIN student ON roll_no = stud_id
WHERE course_id = "CS346" 
AND marks > (SELECT AVG(marks) as Average FROM study WHERE course_id = "CS345");

2
CREATE VIEW get_courses AS 
SELECT c.name, stud_id FROM study s INNER JOIN course c ON s.course_id = c.course_id;

SELECT name FROM get_courses WHERE stud_id = 160101049;

3
DELIMITER //
DROP TRIGGER IF EXISTS check_marks;
CREATE TRIGGER check_marks BEFORE INSERT ON study 
FOR EACH ROW BEGIN
    IF (NEW.marks < 0)
        THEN SET NEW.marks = 0;
    ELSEIF (NEW.marks > 100)
        THEN SET NEW.marks = 100;
    END IF;
END;//
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS check_marks1;
CREATE TRIGGER check_marks1 BEFORE UPDATE ON study 
FOR EACH ROW BEGIN
    IF (NEW.marks < 0)
        THEN SET NEW.marks = 0;
    ELSEIF (NEW.marks > 100)
        THEN SET NEW.marks = 100;
    END IF;
END;//
DELIMITER ;

4
ALTER TABLE study ADD COLUMN attendance INT DEFAULT 75;

UPDATE study SET attendance = 100 WHERE stud_id = 160101049;

5
CREATE INDEX roll_no ON study(stud_id);

SELECT DISTINCT roll_no, name FROM student INNER JOIN study AS sx ON roll_no = stud_id
WHERE NOT EXISTS(
    SELECT p.course_id FROM study as p WHERE stud_id = 160101046
    AND course_id NOT IN (SELECT sp.course_id FROM study as sp WHERE sp.stud_id = sx.stud_id)
);

6
CREATE INDEX roll_no ON study(stud_id);

SELECT * FROM(
    SELECT DISTINCT roll_no, name FROM student INNER JOIN study AS sx ON roll_no = stud_id
    WHERE NOT EXISTS(
        SELECT p.course_id FROM study as p WHERE stud_id = 160101046
        AND course_id NOT IN (SELECT sp.course_id FROM student INNER JOIN study AS sp ON roll_no = stud_id WHERE sp.stud_id = sx.stud_id)
    )
) T WHERE SUBSTRING(T.name, 1, 5) = SUBSTRING((SELECT name FROM student WHERE roll_no = 160101046), 1, 5);

7
CREATE VIEW get_grade AS
    SELECT 'F' AS grade, stud_id, course_id, marks, attendance FROM study WHERE marks < 40
    UNION
    SELECT 'B' AS grade, stud_id, course_id, marks, attendance FROM study WHERE marks >= 40 AND marks < 70
    UNION
    SELECT 'A' AS grade, stud_id, course_id, marks, attendance FROM study WHERE marks >= 70;

SELECT * FROM get_grade WHERE stud_id = 160101049;

8
INSERT INTO get_grade VALUES ("A", 160101049, "CS301");

CREATE VIEW get_grade_mod AS
    SELECT stud_id, course_id, grade FROM study;

INSERT INTO get_grade_mod VALUES ("A", 160101049, "CS301", 50, 80);

9
DELIMITER //
DROP TRIGGER IF EXISTS set_grade;
CREATE TRIGGER set_grade BEFORE INSERT ON study 
FOR EACH ROW BEGIN
    IF (NEW.marks < 40)
        THEN SET NEW.grade = "F";
    ELSEIF (NEW.marks >= 40 AND NEW.marks < 70)
        THEN SET NEW.grade = "B";
    ELSEIF (NEW.marks >= 70)
        THEN SET NEW.grade = "A";
    END IF;
END;//
DELIMITER ;

CREATE TABLE stud_grade(
    roll_no INT NOT NULL,
    course_id VARCHAR(10),
    grade VARCHAR(2)
);

10
DELIMITER //
CREATE TRIGGER set_grade_fin BEFORE INSERT ON study 
FOR EACH ROW BEGIN
    IF (NEW.marks < 40)
        THEN INSERT INTO stud_grade VALUES (NEW.stud_id, NEW.course_id, "F");
    ELSEIF (NEW.marks >= 40 AND NEW.marks < 70)
        THEN INSERT INTO stud_grade VALUES (NEW.stud_id, NEW.course_id, "B");
    ELSEIF (NEW.marks >= 70)
        THEN INSERT INTO stud_grade VALUES (NEW.stud_id, NEW.course_id, "A");
    END IF;
END;//
DELIMITER ;



















