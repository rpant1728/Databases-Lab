CREATE DATABASE assignment3;
USE assignment3;

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
SELECT DISTINCT * FROM student INNER JOIN study ON roll_no = stud_id WHERE study.course_id NOT IN (SELECT course_id FROM study WHERE stud_id = 160101039);

2
SELECT DISTINCT roll_no, name FROM student INNER JOIN study AS sx ON roll_no = stud_id
WHERE NOT EXISTS(
    SELECT p.course_id FROM study as p WHERE stud_id = 160101046
    AND course_id NOT IN (SELECT sp.course_id FROM study as sp WHERE sp.stud_id = sx.stud_id)
);
 
3
SELECT DISTINCT * FROM student INNER JOIN study ON roll_no = stud_id
WHERE course_id IN (
    SELECT course_id FROM teach WHERE lec_id = 1 OR lec_id = 2
);

4
SELECT * FROM student 
WHERE roll_no IN (
        SELECT stud_id FROM study WHERE course_id IN (
            SELECT course_id FROM teach WHERE lec_id = 1
        )
    )
    AND roll_no NOT IN (
        SELECT stud_id FROM study WHERE course_id IN (
            SELECT course_id FROM teach WHERE lec_id = 2
        )
    ) OR
    roll_no IN (
        SELECT stud_id FROM study WHERE course_id IN (
            SELECT course_id FROM teach WHERE lec_id = 2
        )
    )
    AND roll_no NOT IN (
        SELECT stud_id FROM study WHERE course_id IN (
            SELECT course_id FROM teach WHERE lec_id = 1
        )
    );


-- SELECT roll_no FROM student as A
-- WHERE 1 = (SELECT COUNT(stud_id) FROM (
--     SELECT stud_id, lec_id FROM study JOIN teach as C ON study.course_id = teach.course_id)
--     WHERE C.stud_id=roll_no);

-- SELECT roll_no FROM student
-- WHERE 1 = (SELECT COUNT(stud_id) FROM (
--     SELECT stud_id, lec_id FROM study s JOIN teach t ON s.course_id = t.course_id WHERE lec_id = 1 OR lec_id = 2) C
--     WHERE stud_id=roll_no
-- );

SELECT DISTINCT roll_no, name FROM student INNER JOIN study AS sx ON roll_no = stud_id
WHERE NOT EXISTS(
    SELECT p.course_id FROM study as p WHERE stud_id = 160101046
    AND course_id NOT IN (SELECT sp.course_id FROM study as sp WHERE sp.stud_id = sx.stud_id)
);

5
SELECT DISTINCT name, roll_no FROM student INNER JOIN study ON roll_no = stud_id 
WHERE course_id = "CS345" 
AND marks > (SELECT AVG(marks) FROM study WHERE course_id = "CS346");

6
SELECT COUNT(d.dept_id), d.dept_id FROM department d INNER JOIN lecturer l ON d.dept_id = l.dept_id GROUP BY l.dept_id;

7
SELECT * FROM student WHERE roll_no NOT IN(
    SELECT stud_id FROM study WHERE course_id IN (
        SELECT course_id FROM teach WHERE lec_id = 2
    )
);
-- SELECT DISTINCT roll_no, name FROM student INNER JOIN study ON roll_no = stud_id WHERE course_id IN (SELECT course_id FROM teach WHERE lec_id = 1);

8
SELECT AVG(marks), d.dept_id, course_id FROM student d INNER JOIN study s ON roll_no = stud_id GROUP BY course_id, d.dept_id;

9
SELECT f1.marks, f1.dept, course FROM
(SELECT MAX(marks) AS marks, dept FROM (
SELECT AVG(marks) as marks, s.dept_id as dept, course_id as course FROM student s INNER JOIN study AS t1 ON roll_no = stud_id GROUP BY course_id, s.dept_id)
AS T GROUP BY dept) as f1
INNER JOIN 
(SELECT AVG(marks) as marks, s.dept_id as dept, course_id as course FROM student s INNER JOIN study AS t2 ON roll_no = stud_id GROUP BY course_id, s.dept_id) AS f2
ON f1.marks = f2.marks AND f1.dept = f2.dept;

10
SELECT 'F' AS grade, count(marks) FROM study WHERE course_id = "CS345" AND marks < 40
UNION
SELECT 'B' AS grade, count(marks) FROM study WHERE course_id = "CS345" AND marks >= 40 AND marks < 70
UNION
SELECT 'A' AS grade, count(marks) FROM study WHERE course_id = "CS345" AND marks > 70;


















