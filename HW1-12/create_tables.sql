-- Drop if exists ------------------------------
DROP TABLE IF EXISTS Student_Placement_Assignments;
DROP TABLE IF EXISTS Student_Placements;
DROP TABLE IF EXISTS Organization_Staff;
DROP TABLE IF EXISTS Student_Interviews;
DROP TABLE IF EXISTS Organizations;
DROP TABLE IF EXISTS Ref_Organization_Types;

DROP TABLE IF EXISTS Ref_Interview_Outcomes;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Ref_Degree_Courses;
----------------------------------------------

-- Специализации

CREATE TABLE Ref_Degree_Courses (
	degree_course_code SERIAL NOT NULL,
	degree_level varchar(50) NOT NULL,
	academic_department varchar(100) NOT NULL,
	degree_course_description varchar(100),

	CONSTRAINT PK_Ref_Degree_Courses PRIMARY KEY(degree_course_code)
);

INSERT INTO Ref_Degree_Courses
( degree_level, academic_department, degree_course_description) VALUES
( 'бакалавр', 'Московский физико-технический институт и Яндекс',        'Машинное обучение и анализ данных'),
( 'бакалавр', 'Московский физико-технический институт и Яндекс',       'Искусство разработки на современном C++'),
( 'бакалавр', 'Mail.Ru Group & ФРОО & Moscow Institute of Physics and Technology',       'Программирование на Python'),
( 'бакалавр', 'Московский физико-технический институт и Яндекс',       'Разработка интерфейсов: вёрстка и JavaScript'),
( 'магистр',  'Университет Мичигана', 'Python для каждого'),
( 'бакалавр', 'НИУ Высшая Школа Экономики','Основы Digital Маркетинга'),
( 'магистр',  'НИУ Высшая Школа Экономики',  'Финансовые инструменты для частного инвестора'),
( 'магистр',  'deeplearning.ai', 'Deep Learning'),
( 'магистр',  'НИУ Высшая Школа Экономики', 'Advanced Machine Learning');

-- Студенты

CREATE TABLE Students (
	student_id SERIAL NOT NULL,
	degree_course_code int NOT NULL,
	first_name varchar(50) NOT NULL,
	middle_name varchar(50),
	last_name varchar(50) NOT NULL,
	other_student_details varchar(100),

	CONSTRAINT PK_Students PRIMARY KEY(student_id),
	CONSTRAINT FK_Students_Ref_Degree_Courses FOREIGN KEY(degree_course_code) REFERENCES Ref_Degree_Courses(degree_course_code)
);

INSERT INTO Students
( degree_course_code, first_name, middle_name, last_name, other_student_details) VALUES
( 1,'Иван','Иванович', 'Иванов', 'тест'),
( 2, 'Петр','Павлович','Петров', 'магистр'),
( 3, 'Марат','Григорьевич','Сидоров', 'абитуриент'),
( 4, 'Михаил','Николаевич','Кореньков', 'бакалавр'),
( 5, 'Денис','Сергеевич','Карначёв', 'магистр'),
( 6, 'Илья','Сергеевич','Громов', 'бакалавр'),
( 7, 'Никита','Сергеевич','Логинов', 'магистр'),
( 8, 'Олег','Юрьевич','Журбенко', 'бакалавр'),
( 9, 'Владимир','Игоревич','Стуканов', 'бакалавр');

-- Результаты

CREATE TABLE Ref_Interview_Outcomes (
	interview_outcome_code SERIAL NOT NULL,
	interview_outcome_description varchar(100) NOT NULL,
    score int,

	CONSTRAINT PK_Outcomes PRIMARY KEY(interview_outcome_code)
);

INSERT INTO Ref_Interview_Outcomes
( interview_outcome_description) VALUES
('сдал'),
('не сдал'),
('сдал'),
('сдал'),
('сдал'),
('не сдал'),
('сдал'),
('не сдал'),
('сдал');

-- Типы организаций

CREATE TABLE Ref_Organization_Types (
	org_type_code SERIAL NOT NULL,
	org_type_description varchar(100) NOT NULL,

	CONSTRAINT PK_Organization_Types PRIMARY KEY(org_type_code)
);

INSERT INTO Ref_Organization_Types
( org_type_description) VALUES
('финансы и страхование'),
('торговля'),
('информационные технологии'),
('туристическая сфера'),
('транспорт'),
('производство');

-- Организации

CREATE TABLE Organizations (
	org_id SERIAL NOT NULL,
	org_type_code int NOT NULL,
	org_name varchar(50) NOT NULL,
	org_phone varchar(30) NOT NULL,
	org_email varchar(30),
	org_adress varchar(100),
	other_org_details varchar(100),

	CONSTRAINT PK_Organizations PRIMARY KEY(org_id),
	CONSTRAINT FK_Organization_Type FOREIGN KEY(org_type_code) REFERENCES Ref_Organization_Types(org_type_code)
);

INSERT INTO Organizations
( org_type_code, org_name, org_phone, org_email, org_adress, other_org_details) VALUES
(  1, 'ВТБ', '8884', '1@mail.ru', 'msk','something details' ),
(  1, 'Сбербанк', '7774', '2@mail.ru', 'msk','something details' ),
(  3, 'Яндекс', '5555', '3@mail.ru', 'msk','something details' ),
(  4, 'Аэрофлот', '5556', '4@mail.ru','msk', 'something details' ),
(  2, 'Авито', '5534', '5@mail.ru', 'msk','something details' );

-- Экзамены

CREATE TABLE Student_Interviews (
	student_id int NOT NULL,
	org_id int NOT NULL,
	interview_outcome_code int NOT NULL,
	interview_date date,
	comments_by_org varchar(100),
	comments_by_student varchar(100),
	other_interview_details varchar(100),

	CONSTRAINT PK_Student_Interviews PRIMARY KEY(student_id, org_id),
	CONSTRAINT FK_Interviews_Outcome FOREIGN KEY(interview_outcome_code) REFERENCES Ref_Interview_Outcomes(interview_outcome_code),
	CONSTRAINT FK_Interview_Student FOREIGN KEY(student_id) REFERENCES Students(student_id),
	CONSTRAINT FK_Interview_Organization FOREIGN KEY(org_id) REFERENCES Organizations(org_id)
);

INSERT INTO Student_Interviews
( student_id, org_id, interview_outcome_code, interview_date, comments_by_org, comments_by_student, other_interview_details) VALUES
(  1, 1, '1', '05/10/2020', 'good','good','something details' ),
(  2, 2, '2', '08/12/2020', 'good','good','something details' ),
(  3, 3, '3', '12/10/2020', 'good','good','something details' ),
(  4, 4, '4', '05/12/2020','good', 'middle','something details' ),
(  5, 5, '5', '22/10/2020', 'middle','good','something details' ),
(  6, 4, '6', '18/11/2020', 'middle','good','something details' ),
(  7, 5, '7', '01/10/2020', 'middle','good','something details' ),
(  8, 1, '8', '03/10/2020','middle', 'good','something details' ),
(  9, 3, '9', '05/11/2020', 'bad','good','something details' );

-- Персонал

CREATE TABLE Organization_Staff (
	staff_id SERIAL NOT NULL,
	org_id int NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	job_title varchar(50),
	phone_number varchar(30), 
	email_adress varchar(30),
	other_staff_details varchar(100),

	CONSTRAINT PK_Org_Staff PRIMARY KEY(staff_id),
	CONSTRAINT FK_Staff_Organizations FOREIGN KEY(org_id) REFERENCES Organizations(org_id)
);

INSERT INTO Organization_Staff
( org_id, first_name, last_name, job_title, phone_number, email_adress, other_staff_details) VALUES
(  1, 'Василий', 'Князев', 'директор', '123','test1@mail.ru','good' ),
(  2, 'Виталий', 'Лебедев', 'директор', '123','test2@mail.ru','good' ),
(  3, 'Виктор', 'Крамбери', 'директор', '123','test3@mail.ru','good' ),
(  4, 'Венеамин', 'Перышкин', 'директор','123', 'test4@mail.ru','good' ),
(  5, 'Сергей', 'Гаврилов', 'директор', '123','test5@mail.ru','good' ),
(  1, 'Александр', 'Петров', 'инженер', '123','test6@mail.ru','good' ),
(  2, 'Иван', 'Грозный', 'инженер', '456','test7@mail.ru','good' ),
(  4, 'Евгений', 'Викентьев', 'инженер','456', 'test8@mail.ru','good' ),
(  3, 'Алексей', 'Тихомиров', 'инженер', '465','test23@mail.ru','good' );

-- Дисциплины

CREATE TABLE Student_Placements (
	student_id int NOT NULL,
	org_id int NOT NULL,
	placement_start_date date NOT NULL DEFAULT CURRENT_DATE,
	placement_manager_staff_id int NOT NULL,
	placement_end_date date,
	comments_by_org varchar(100),
	comments_by_student varchar(100),
	other_placement_details varchar(100),

	CONSTRAINT PK_Stud_Placements PRIMARY KEY(student_id, org_id, placement_start_date),
	CONSTRAINT FK_Placement_Staff FOREIGN KEY(placement_manager_staff_id) REFERENCES Organization_Staff(staff_id),
    CONSTRAINT FK_Placement_Interview FOREIGN KEY(student_id, org_id) REFERENCES Student_Interviews(student_id, org_id)
);

INSERT INTO Student_Placements
( student_id, org_id, placement_start_date, placement_manager_staff_id, 
placement_end_date, comments_by_org,comments_by_student, other_placement_details) VALUES
(  1, 1, '01/07/2020', 6, '05/12/2020','good','normally' ,'programming'),
(  2, 2, '01/07/2020', 2, '05/12/2020','good','normally' ,'oop'),
(  3, 3, '01/07/2020', 9, '05/12/2020','good','normally' ,'algoritms'),
(  4, 4, '01/08/2020', 4, '05/12/2020','good','normally' ,'financial strategies'),
(  5, 5, '01/08/2020', 5, '05/12/2020','good','normally' ,'devops'),
(  6, 4, '01/08/2020', 8, '05/12/2020','middle','normally' ,'management'),
(  7, 5, '01/08/2020', 5, '05/12/2020','good','normally' ,'sales'),
(  8, 1, '01/08/2020', 1, '05/12/2020','good','normally' ,'research'),
(  9, 3, '01/08/2020', 3, '05/12/2020','good','normally' ,'logics');

-- Стажировки

CREATE TABLE Student_Placement_Assignments (
    student_id int NOT NULL,
	org_id int NOT NULL,
	placement_start_date date NOT NULL,
	assignment_start_date date NOT NULL DEFAULT CURRENT_DATE,
	supervisor_staff_id int NOT NULL,
	assignment_end_date date,
	comments_by_supervisor varchar(100),
	comments_by_student varchar(100),
	other_assignment_details varchar(100),

	CONSTRAINT PK_Stud_Placement_Assignments PRIMARY KEY(student_id, org_id, placement_start_date, assignment_start_date),
    CONSTRAINT FK_Assignment_Staff FOREIGN KEY(supervisor_staff_id) REFERENCES Organization_Staff(staff_id),
    CONSTRAINT FK_Assignment_Placement FOREIGN KEY(student_id, org_id, placement_start_date) REFERENCES Student_Placements(student_id, org_id, placement_start_date)
);

INSERT INTO Student_Placement_Assignments
( student_id, org_id, placement_start_date, assignment_start_date, supervisor_staff_id, 
assignment_end_date, comments_by_supervisor,comments_by_student, other_assignment_details) VALUES
(  1, 1, '01/07/2020','01/10/2020', 1, '01/12/2020','good job!','ok' ,'practice '),
(  2, 2, '01/07/2020','01/10/2020', 2, '01/12/2020','good job!','ok' ,'oop'),
(  3, 3, '01/07/2020','01/10/2020', 3, '01/12/2020','good job!','ok' ,'algoritms'),
(  4, 4, '01/08/2020','01/10/2020', 8, '01/12/2020','good job!','good' ,'financial strategies'),
(  5, 5, '01/08/2020','01/10/2020', 5, '01/12/2020','norm','excellent' ,'devops'),
(  6, 4, '01/08/2020','01/10/2020', 4, '01/12/2020','excellent','cool' ,'management'),
(  7, 5, '01/08/2020','01/10/2020', 5, '01/12/2020','all right','normally' ,'sales'),
(  8, 1, '01/08/2020','01/10/2020', 6, '01/12/2020','normally','badly' ,'research'),
(  9, 3, '01/08/2020','01/10/2020', 9, '01/12/2020','stable','good' ,'logics');
