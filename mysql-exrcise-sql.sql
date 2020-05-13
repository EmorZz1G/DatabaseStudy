INSERT INTO course VALUES(2,'数学' ,2.0, 2);
INSERT INTO Course VALUES (6,'数据处理' ,NULL, 2);
INSERT INTO Course VALUES (4, '操作系统',6, 3);
INSERT INTO Course VALUES (7, 'PASCAL语言',6, 4);
INSERT INTO Course VALUES (5,'数据结构', 7, 4);
INSERT INTO Course VALUES (1,'数据库', 5,4);
INSERT INTO Course VALUES (3, '信息系统', 1, 4);

# 1. 查询平均成绩大于80的学生姓名。
SELECT sname
FROM student
JOIN 
(
    SELECT sno,AVG(grade)
    FROM sc
    GROUP BY sno
    HAVING AVG(grade) >80
)p ON student.sno=p.sno;

# 2. 查询课程成绩大于课程平均成绩的选课信息，显示学生姓名、课程名称和成绩。
SELECT sname,cname,grade
FROM student,course,sc X
WHERE grade>=(
                SELECT AVG(grade)
                FROM sc Y
                WHERE x.`sno`=y.`sno`
                )
    AND student.`sno`=x.`sno`
    AND x.`cno`=course.`cno`;

# 3. 查询至少选修了C1和C2课程的学生名单。
SELECT DISTINCT s.*
FROM student s,sc sc1 ,course c
WHERE EXISTS
    (
        SELECT *
        FROM sc sc2
        WHERE sc2.cno=1 
            AND s.`sno`=sc2.`sno`
            AND EXISTS
                    (
                        SELECT * 
                        FROM sc sc3
                        WHERE s.`sno`=sc3.`sno`
                            AND sc3.`cno`=2
                    )
                    
    )
    AND s.`sno`=sc1.`sno`
    AND sc1.`cno`=c.`cno`
    
# 4. 查询选修了C1课程而没有选修C2课程的学生名单。
SELECT DISTINCT s.*
FROM student s,sc sc1 ,course c
WHERE EXISTS
    (
        SELECT *
        FROM sc sc2
        WHERE sc2.cno=1 
            AND s.`sno`=sc2.`sno`
            AND NOT EXISTS
                    (
                        SELECT * 
                        FROM sc sc3
                        WHERE s.`sno`=sc3.`sno`
                            AND sc3.`cno`=2
                    )
                    
    )
    AND s.`sno`=sc1.`sno`
    AND sc1.`cno`=c.`cno`
    
# 5. 统计每门课程成绩大于80分的学生数。
SELECT s.*,sc1.*
FROM sc sc1,student s
WHERE s.`sno`=sc1.`sno`
GROUP BY s.`sno`
HAVING MIN(sc1.`grade`) > 80
# or 有bug，如果查询为空怎么办？？？
SELECT s.*
FROM student s
WHERE 80 < ALL (
                SELECT sc1.`grade`
                FROM sc sc1
                WHERE sc1.`sno`=s.`sno`
                )
                
# 6. 统计计算机系“CS”学生的平均分
SELECT AVG(sc.`grade`)
FROM sc
WHERE sc.`sno` IN
            (
                SELECT student.sno
                FROM student
                WHERE sdept = "MA"
            )

# 7. 统计至少选修了两门课程的学生数
SELECT COUNT(p.sno)
FROM    
    (
    SELECT sc.`sno`
    FROM sc
    GROUP BY sc.`sno`
    HAVING COUNT(sc.`grade`)>=2
    )p
    
# 8. 查询至少选修了两门课程的学生名单
SELECT student.*
FROM    
    (
    SELECT sc.`sno`
    FROM sc
    GROUP BY sc.`sno`
    HAVING COUNT(sc.`grade`)>=2
    )p
    ,student
WHERE student.sno=p.sno

# 9. 查询没有被选修的课程信息
SELECT course.*
FROM course
WHERE 
    NOT EXISTS(
                SELECT *
                FROM sc
                WHERE sc.`cno`=course.cno
              )
              
# 10.查询没有选修C1课程的学生信息
SELECT student.*
FROM student
WHERE
    NOT EXISTS(
                SELECT *
                FROM sc
                WHERE sc.`cno`=1
                    AND student.`sno`=sc.`sno`             
                )
                
# 11.统计没有选修C1课程的学生人数
SELECT COUNT(student.sno)
FROM student
WHERE
    NOT EXISTS(
                SELECT *
                FROM sc
                WHERE sc.`cno`=1
                    AND student.`sno`=sc.`sno`             
                )
                
# 12.查询平均分最高的课程信息
SELECT course.*
FROM course,(
            SELECT sc.`cno`,AVG(sc.`grade`) AVG
            FROM sc
            GROUP BY sc.`cno`
            HAVING AVG(sc.`grade`)
            ORDER BY AVG DESC
            LIMIT 0,1
            )p
WHERE p.cno=course.`cno`

# 13.查询平均分最高的课程的选课信息（学号，姓名，课程名程，成绩）
SELECT student.sno ,student.`sname`,course.`cname`,sc2.grade
FROM student,course,sc sc2,(
            SELECT sc1.`cno`,AVG(sc1.`grade`) AVG
            FROM sc sc1
            GROUP BY sc1.`cno`
            HAVING AVG(sc1.`grade`)
            ORDER BY AVG DESC
            LIMIT 0,1
            )p
WHERE
    p.cno=sc2.cno
    AND sc2.cno=course.`cno`
    AND student.sno=sc2.sno
    
# 14.查询平均分最高的学生所在院系。
SELECT student.`sdept`
FROM student,(
            SELECT sc.`sno`,AVG(sc.`grade`) AVG
            FROM sc
            GROUP BY sc.`cno`
            ORDER BY AVG DESC
            LIMIT 0,1
            )p
WHERE student.sno = p.sno

# 15. 统计学生平均选修课程数。
SELECT AVG(cnt)
FROM (
        SELECT COUNT(sc.`cno`) cnt
        FROM sc
        GROUP BY sc.`sno`
      )p

# 16. 统计各院系学生平均选课数。
SELECT student.`sdept`,AVG(cnt)
FROM student,(
        SELECT sc.`sno`, COUNT(sc.`cno`) cnt
        FROM sc
        GROUP BY sc.`sno`
      )p
WHERE p.sno=student.`sno`
GROUP BY student.`sdept`

# 17. 统计每门课程的选课人数，最高分，平均分和最低分。
SELECT course.`cname`,COUNT(sc.`sno`),MAX(sc.`grade`),AVG(sc.`grade`),MIN(sc.`grade`)
FROM sc,course
WHERE sc.`cno`=course.`cno`
GROUP BY sc.`cno`

# 18. 查询平均分75以上，并且没有不及格成绩的学生信息。
SELECT student.*
FROM sc,student
WHERE NOT EXISTS
                (
                  SELECT *
                  FROM sc sc2
                  WHERE MIN(sc2.`grade`)>=60
                        AND sc2.sno=sc.`sno`
                )
GROUP BY sc.`sno`
HAVING AVG(sc.`grade`)>75

SELECT *
FROM sc sc2
GROUP BY sc2.grade
HAVING MIN(sc2.`grade`)>=60