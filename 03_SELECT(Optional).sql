--춘 대학교 워크북 과제
--SQL03_SELECT(Option)

-- 1번
-- 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름으로 오름차순 표시하도록 한다.
SELECT
    STUDENT_NAME AS "학생 이름"
    , STUDENT_ADDRESS 주소지
FROM 
    TB_STUDENT;

-- 2번
-- 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오
SELECT
    STUDENT_NAME 이름
    , STUDENT_SSN 주민번호
FROM 
    TB_STUDENT
ORDER BY STUDENT_SSN DESC;

-- 3번
-- 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 주소를 이름의 오름차순으로 화면에 출력하시오.
-- 단, 출력헤더에는 "학생이름", "학번", "거주지 주소"가 출력되도록 한다.
SELECT
    STUDENT_NAME 학생이름
    , STUDENT_NO 학번
    , STUDENT_ADDRESS AS "가주지 주소"
FROM 
    TB_STUDENT
WHERE 
    (STUDENT_ADDRESS LIKE '%강원도%'
    OR STUDENT_ADDRESS LIKE '%경기도%')
    AND EXTRACT(YEAR FROM ENTRANCE_DATE) BETWEEN 1900 AND 1999;

-- 4번
-- 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을 작성하시오.
-- (법학과의 '학과 코드'는 학과 테이블을 조회해서 찾아 내도록 하자)
SELECT 
    PROFESSOR_NAME
FROM 
    TB_PROFESSOR
WHERE DEPARTMENT_NO =  (
                            SELECT 
                                DEPARTMENT_NO
                            FROM
                                TB_DEPARTMENT
                            WHERE
                                DEPARTMENT_NAME LIKE '법학과'
                        )
ORDER BY PROFESSOR_SSN;

-- 5번
-- 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 
-- 학점이 높은 학생부터 표시하고,
-- 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해 보시오.
-- 워크북 결과와 동일하게 소수점 아래 2자리까지 0으로 표현하기 위해서 TO_CHAR(NUMBER, 'FM9.00') 포맷 사용

SELECT
    STUDENT_NAME 이름
    , TO_CHAR(POINT, 'FM9.00') 학점
FROM
TB_GRADE
WHERE  
    g.TERM_NO = 200402
    AND g.CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO;

-- 6번
-- 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL문을 작성하시오.
SELECT
    STUDENT_NO 학번
    , STUDENT_NAME 이름
    , DEPARTMENT_NAME 학과
FROM 
    TB_STUDENT S
    JOIN TB_DEPARTMENT D ON S.DEPARTMENT_NO = D.DEPARTMENT_NO
ORDER BY STUDENT_NAME;

-- 7번
-- 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL문장을 작성하시오.
SELECT
    C.CLASS_NAME 과목
    , D.DEPARTMENT_NAME 학과
FROM
    TB_CLASS C
    JOIN TB_DEPARTMENT D ON C.DEPARTMENT_NO = D.DEPARTMENT_NO
ORDER BY 2, 1;
-- 8번
-- 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL문을 작성하시오.
SELECT
    CLASS_NAME 이름
    , PROFESSOR_NAME AS "교수 이름"
FROM 
    TB_CLASS C
    , TB_PROFESSOR P 
    , TB_CLASS_PROFESSOR CP
WHERE
    C.CLASS_NO = CP.CLASS_NO
    AND CP.PROFESSOR_NO = P.PROFESSOR_NO
ORDER BY 2, 1;


-- 9번
-- 8번의 결과 중 '인문 사회' 계열에 속한 과목의 교수 이름을 찾으려고 한다.
-- 이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL문을 작성하시오.
SELECT
    CLASS_NAME 과목
    , PROFESSOR_NAME AS "교수 이름"
FROM 
    TB_CLASS C
    , TB_PROFESSOR P
    , TB_CLASS_PROFESSOR CP
    , TB_DEPARTMENT D
WHERE
    C.CLASS_NO = CP.CLASS_NO
    AND CP.PROFESSOR_NO = P.PROFESSOR_NO
    AND P.DEPARTMENT_NO = D.DEPARTMENT_NO
    AND D.CATEGORY LIKE '%인문사회%'
ORDER BY 2, 1;

-- 10번
-- '음악학과' 학생들의 평점을 구하려고 한다. 
-- 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL 문장을 작성하시오.
-- (단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)
SELECT
    S.STUDENT_NO AS "학번"
    , S.STUDENT_NAME AS "학생 이름"
    , ROUND(AVG(G.POINT), 1) AS "전체 평점"
FROM 
    TB_STUDENT S
    JOIN TB_GRADE G ON S.STUDENT_NO = G.STUDENT_NO
GROUP BY S.DEPARTMENT_NO, S.STUDENT_NO, S.STUDENT_NAME
HAVING S.DEPARTMENT_NO = 
(
    SELECT 
        DEPARTMENT_NO
    FROM 
        TB_DEPARTMENT
    WHERE
        DEPARTMENT_NAME LIKE '%음악학과%'
)
ORDER BY 1;

-- 11번
-- 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 
-- 학과 이름, 학생 이름과 지도 교수 이름이 필요하다.
-- 이때 사용할 SQL문을 작성하시오.
SELECT
    D.DEPARTMENT_NAME AS "학과 이름"
    , S.STUDENT_NAME AS "학생 이름"
    , P.PROFESSOR_NAME AS "지도 교수"
FROM
    TB_STUDENT S
    JOIN TB_DEPARTMENT D ON S.DEPARTMENT_NO = D.DEPARTMENT_NO
    JOIN TB_PROFESSOR P ON S.COACH_PROFESSOR_NO = P.PROFESSOR_NO
WHERE
    STUDENT_NO = 'A313047';

-- 12번
-- 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아 
-- 학생이름과 수강학기를 표시하는 SQL 문장을 작성하시오.
SELECT 
    S.STUDENT_NAME 이름
    , SUBSTR(G.TERM_NO, 5, 2) 수강학기
FROM 
    TB_GRADE G
    JOIN TB_STUDENT S ON G.STUDENT_NO = S.STUDENT_NO
WHERE 
    CLASS_NO = (SELECT CLASS_NO FROM TB_CLASS WHERE CLASS_NAME LIKE '%인간관계론%')
    AND SUBSTR(G.TERM_NO, 1, 4) LIKE '%2007%';

-- 13번
-- 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 
-- 그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
-- 결과 행의 수는 동일하나 정렬 기준이 없어 다른 순서를 보임
SELECT 
    C.CLASS_NAME 과목
    , D.DEPARTMENT_NAME 학과
FROM 
    TB_CLASS C
    JOIN TB_DEPARTMENT D ON C.DEPARTMENT_NO = D.DEPARTMENT_NO
    LEFT JOIN TB_CLASS_PROFESSOR CP ON C.CLASS_NO = CP.CLASS_NO
WHERE 
    D.CATEGORY = '예체능'
    AND CP.PROFESSOR_NO IS NULL
ORDER BY 2, 1;


-- 14번
-- 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 
-- 학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우
-- "지도교수 미지정"으로 표시하도록 하는 SQL 문을 작성하시오. 
-- 단 출력헤더는 "학생이름", "지도교수"로 표시하며 고학번 학생이 먼저 표시되도록 한다.
SELECT 
    S.STUDENT_NAME AS 학생이름,
    NVL(P.PROFESSOR_NAME, '지도교수 미지정') AS 지도교수
FROM
    TB_STUDENT S
    LEFT JOIN TB_PROFESSOR P ON S.COACH_PROFESSOR_NO = P.PROFESSOR_NO
    JOIN TB_DEPARTMENT D ON S.DEPARTMENT_NO = D.DEPARTMENT_NO
WHERE
    D.DEPARTMENT_NAME = '서반아어학과'
ORDER BY S.STUDENT_NO;

-- 15번
-- 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 
-- 그 학생의 학번, 이름, 학과, 이름, 평점을 출력하는 SQL문을 작성하시오.
SELECT
    S.STUDENT_NO 학번
    , S.STUDENT_NAME 이름
    , D.DEPARTMENT_NAME 학과
    , ROUND(AVG(G.POINT), 1) AS 평점
FROM
    TB_STUDENT S
    JOIN TB_DEPARTMENT D ON S.DEPARTMENT_NO = D.DEPARTMENT_NO
    JOIN TB_GRADE G ON S.STUDENT_NO = G.STUDENT_NO
WHERE
    S.ABSENCE_YN = 'N'
GROUP BY S.STUDENT_NO, S.STUDENT_NAME, D.DEPARTMENT_NAME
HAVING AVG(G.POINT) >= 4.0;

-- 16번
-- 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.
SELECT
    C.CLASS_NO
    , C.CLASS_NAME 과목
    , ROUND(AVG(G.POINT), 1) 평점
FROM 
    TB_DEPARTMENT D
    JOIN TB_CLASS C ON D.DEPARTMENT_NO = C.DEPARTMENT_NO
    LEFT JOIN TB_GRADE G ON C.CLASS_NO = G.CLASS_NO
WHERE
    D.DEPARTMENT_NAME = '환경조경학과'
    AND CLASS_TYPE LIKE '%전공%'
GROUP BY C.CLASS_NO, C.CLASS_NAME
ORDER BY 1;
-- 17번
-- 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL 문을 작성하시오.
SELECT 
    STUDENT_NAME 이름
    , STUDENT_ADDRESS 주소
FROM 
    TB_STUDENT
WHERE 
    DEPARTMENT_NO = (
                        SELECT
                            DEPARTMENT_NO
                        FROM
                            TB_STUDENT
                        WHERE 
                            STUDENT_NAME = '최경희'
                    );

-- 18번
-- 국어국문학과에서 총점수가 가장 높은 학생의 이름과 학번을 표시하는 SQL문을 작성하시오
SELECT
    이름
    , 학번
FROM 
    (
        SELECT 
            S.STUDENT_NAME 이름
            , S.STUDENT_NO 학번
            , SUM(G.POINT)
            , AVG(G.POINT)
        FROM 
            TB_DEPARTMENT D
            JOIN TB_STUDENT S ON D.DEPARTMENT_NO = S.DEPARTMENT_NO
            JOIN TB_GRADE G ON G.STUDENT_NO = S.STUDENT_NO
        WHERE 
            D.DEPARTMENT_NAME = '국어국문학과'
        GROUP BY S.STUDENT_NAME, S.STUDENT_NO
        ORDER BY 3 DESC
    )
WHERE 
    ROWNUM = 1;


-- 19번
-- 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 
-- 학과 별 전공과목 평점을 파악하기 위한 적절한 SQL문을 찾아내시오.
-- 단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 
-- 평점은 소수점 한자리까지만 반올림하여 표시되도록 한다.
SELECT 
    D.DEPARTMENT_NAME AS "계열 학과명"
    , ROUND(AVG(NVL(G.POINT, 0)), 1) 전공평점
FROM
    TB_DEPARTMENT D
    JOIN TB_CLASS C ON D.DEPARTMENT_NO = C.DEPARTMENT_NO
    LEFT JOIN TB_GRADE G ON C.CLASS_NO = G.CLASS_NO
WHERE
    D.CATEGORY = (
                    SELECT
                        CATEGORY
                    FROM
                        TB_DEPARTMENT
                    WHERE
                        DEPARTMENT_NAME = '환경조경학과'
                )
    AND CLASS_TYPE LIKE '%전공%'   
GROUP BY D.DEPARTMENT_NAME
ORDER BY 1;
