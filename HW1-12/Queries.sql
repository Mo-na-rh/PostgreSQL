--Most used queries

-- change column type
ALTER TABLE Ref_Degree_Courses ALTER COLUMN degree_level TYPE varchar(50);

-- select organizations by student
select s.first_name, s.last_name, o.org_name, i.interview_date from Students as s
join Student_Interviews AS i ON i.student_id = s.student_id
join Organizations AS o ON i.org_id = o.org_id
where s.student_id = 5;

-- select performance by student_name
select s.first_name, s.last_name, o.interview_outcome_description, i.interview_date from Students as s
join Student_Interviews AS i ON i.student_id = s.student_id
join Ref_Interview_Outcomes AS o ON i.interview_outcome_code = o.interview_outcome_code
where s.first_name like 'Денис';

-- views 

--TRIGGERS


-- Цель триггера -- записывать в журнал
-- изменения наименований организаций

-- Создадим журнал изменений наименований организаций
DROP TABLE IF EXISTS org_names;
CREATE TABLE org_names (
   id int GENERATED ALWAYS AS IDENTITY,
   org_id int NOT NULL,
   org_name varchar(50) NOT NULL,
   changed_on timestamp(6) NOT NULL
);

-- Создадим функцию для триггера,
-- которая будет делать запись в журнал,
-- если у организации изменяется наименование
CREATE OR REPLACE FUNCTION log_org_name_changes()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
BEGIN
	IF NEW.org_name <> OLD.org_name THEN
		INSERT INTO org_names(org_id, org_name, changed_on)
		VALUES(OLD.org_id, OLD.org_name, now());
	END IF;
	RETURN NEW;
END;
$$;

-- Создадим триггер, который вызывает функцию
-- перед обновлением
DROP TRIGGER IF EXISTS org_name_changes on Organizations;
CREATE TRIGGER org_name_changes
BEFORE UPDATE
ON Organizations
FOR EACH ROW
EXECUTE PROCEDURE log_org_name_changes();

-- Проверим результат
UPDATE Organizations SET org_name = 'СБЕР'
WHERE org_id = 2;

SELECT * FROM org_names;


-- second trigger 

-- Цель 
-- мониторить изменения оценок в журнале

-- Создадим журнал изменений результатов экзаменов
DROP TABLE IF EXISTS interview_outcome_descr;
CREATE TABLE interview_outcome_descr (
   id int GENERATED ALWAYS AS IDENTITY,
   interview_outcome_code int NOT NULL,
   interview_outcome_description varchar(100) NOT NULL,
   chng_on timestamp(6) NOT NULL
);
-- Создадим функцию для триггера,
-- которая будет делать запись в журнал,
-- если у результат экзамена изменяется 
CREATE OR REPLACE FUNCTION log_outcome_description_changes()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
BEGIN
	IF NEW.interview_outcome_description <> OLD.interview_outcome_description THEN
		INSERT INTO interview_outcome_descr(interview_outcome_code, interview_outcome_description, chng_on)
		VALUES(OLD.interview_outcome_code, OLD.interview_outcome_description, now());
	END IF;
	RETURN NEW;
END;
$$;

-- Создадим триггер, который вызывает функцию
-- перед обновлением
DROP TRIGGER IF EXISTS interview_outcomes_changes on Ref_Interview_Outcomes;
CREATE TRIGGER interview_outcomes_changes
BEFORE UPDATE
ON Ref_Interview_Outcomes
FOR EACH ROW
EXECUTE PROCEDURE log_outcome_description_changes

-- Проверим результат
UPDATE Ref_Interview_Outcomes SET interview_outcome_description = 'не сдал'
WHERE interview_outcome_code = 1;

SELECT * FROM Ref_Interview_Outcomes;

---------------------- PROCEDURES-----------------------------------------------------------
-- Процедура, позволяющая снизить балл за экзамен
CREATE OR REPLACE PROCEDURE reduce_score (
   id int
)
LANGUAGE PLPGSQL   
AS
$$
DECLARE
    stud_score int;
BEGIN
    -- Сначала проверим текущий уровень привилегий
    stud_score := (SELECT score FROM Ref_Interview_Outcomes WHERE interview_outcome_code = id);
    IF stud_score = 1 THEN
        RAISE EXCEPTION 'Студент имеет минимальный балл.';
    END IF;

    -- Если все ОК, то повышаем уровень
    UPDATE Ref_Interview_Outcomes SET score = score - 1
    WHERE interview_outcome_code = id;

    COMMIT;
END;
$$;

-- Процедура, позволяющая снизить балл за экзамен
CREATE OR REPLACE PROCEDURE boost_score (
   id int
)
LANGUAGE PLPGSQL   
AS
$$
DECLARE
    stud_score int;
BEGIN
    -- Сначала проверим текущий уровень привилегий
    stud_score := (SELECT score FROM Ref_Interview_Outcomes WHERE interview_outcome_code = id);
    IF stud_score = 10 THEN
        RAISE EXCEPTION 'Студент имеет максимальный балл.';
    END IF;

    -- Если все ОК, то повышаем уровень
    UPDATE Ref_Interview_Outcomes SET score = score + 1
    WHERE interview_outcome_code = id;

    COMMIT;
END;
$$;

-- проверка
select * from Ref_Interview_Outcomes where interview_outcome_code = 1;
call reduce_score(1);

-------------------------------------------- Оконные функции -------------------------------

select row_number() over() as row_num, s.first_name, s.last_name, o.interview_outcome_description, i.interview_date from Students as s
join Student_Interviews AS i ON i.student_id = s.student_id
join Ref_Interview_Outcomes AS o ON i.interview_outcome_code = o.interview_outcome_code
order by row_num asc;

-------------------------------------------- Общие табличные выражения -----------------------
 -- суммирование чисел от 1 до 100
 WITH RECURSIVE t(n) AS (
    VALUES (1)
  UNION ALL
    SELECT n+1 FROM t WHERE n < 100
)
SELECT sum(n) FROM t;


