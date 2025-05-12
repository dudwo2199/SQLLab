---------------- 실습 문제 ----------------
-- 1. DEPARTMENT 테이블과 LOCATION 테이블의 조인하여 부서 코드, 부서명, 지역 코드, 지역명을 조회
SELECT
    DEPT_ID AS "부서 코드"
    , DEPT_TITLE AS "부서명"
    , LOCATION_ID AS "지역 코드"
    , LOCAL_NAME AS "지역명"
FROM
    DEPARTMENT D
    JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE;

-- 2. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명을 조회
SELECT
    EMP_ID 사번
    , EMP_NAME 사원명
    , BONUS 보너스
    , D.DEPT_TITLE 부서명
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE E.BONUS IS NOT NULL;

-- 3. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 인사관리부가 아닌 사원들의 사원명, 부서명, 급여를 조회
SELECT
    E.EMP_NAME 사원명
    , D.DEPT_TITLE 부서명
    , E.SALARY 급여
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE
    D.DEPT_TITLE != '인사관리부';

-- 4. EMPLOYEE 테이블, DEPARTMENT 테이블, LOCATION 테이블의 조인해서 사번, 사원명, 부서명, 지역명 조회
SELECT
    E.EMP_ID 사번
    , E.EMP_NAME 사원명
    , D.DEPT_TITLE 부서명
    , L.LOCAL_NAME 지역명
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE;

-- 5. 사번, 사원명, 부서명, 지역명, 국가명 조회
SELECT
    E.EMP_ID 사번
    , E.EMP_NAME 사원명
    , D.DEPT_TITLE 부서명
    , L.LOCAL_NAME 지역명
    , N.NATIONAL_NAME 국가명
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
    JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;

-- 6. 사번, 사원명, 부서명, 지역명, 국가명, 급여 등급 조회 (NON EQUAL JOIN 후에 실습 진행)
SELECT
    E.EMP_ID 사번
    , E.EMP_NAME 사원명
    , D.DEPT_TITLE 부서명
    , L.LOCAL_NAME 지역명
    , N.NATIONAL_NAME 국가명
    , S.SAL_LEVEL 급여등급
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
    JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
    JOIN SAL_GRADE S ON E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

------------------------- 종합 실습 문제 -------------------------

-- 1. 직급이 대리이면서 ASIA 지역에서 근무하는 직원들의 사번, 사원명, 직급명, 부서명, 근무지역, 급여를 조회하세요.
SELECT
    E.EMP_ID 사번
    , E.EMP_NAME 사원명
    , J.JOB_NAME 직급명
    , D.DEPT_TITLE 부서명
    , L.LOCAL_NAME 근무지역
    , E.SALARY 급여
FROM 
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
    JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE
    L.LOCAL_NAME LIKE '%ASIA%';

-- 2. 70년대생 이면서 여자이고, 성이 전 씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하세요.
SELECT
    EMP_NAME 사원명
    , EMP_NO 주민번호
    , D.DEPT_TITLE 부서명
    , J.JOB_NAME 직급명
FROM 
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE 
    SUBSTR(EMP_NO, 1, 2) BETWEEN 70 AND 79
    AND SUBSTR(EMP_NO, 8, 1) = '2'
    AND EMP_NAME LIKE '전%';

-- 3. 보너스를 받는 직원들의 사원명, 보너스, 연봉, 부서명, 근무지역을 조회하세요.
SELECT
    E.EMP_NAME 사원명
    , E.BONUS 보너스
    , e.SALARY * 12 연봉
    , D.DEPT_TITLE 부서명
    , L.LOCAL_NAME 근무지역
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE
    E.BONUS IS NOT NULL;

-- 4. 한국과 일본에서 근무하는 직원들의 사원명, 부서명, 근무지역, 근무 국가를 조회하세요.
SELECT
    E.EMP_NAME 사원명
    , D.DEPT_TITLE 부서명
    , L.LOCAL_NAME 근무지역
    , N.NATIONAL_NAME AS "근무 국가"
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
    JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE 
    N.NATIONAL_NAME IN ('한국', '일본');

-- 5. 각 부서별 평균 급여를 조회하여 부서명, 평균 급여(정수 처리)를 조회하세요.
SELECT 
    D.DEPT_TITLE 부서명
    , FLOOR(AVG(E.SALARY)) AS "평균 급여"
FROM 
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
GROUP BY D.DEPT_TITLE;

-- 6. 각 부서별 총 급여의 합이 1000만원 이상인 부서명, 급여의 합을 조회하시오.
SELECT 
    D.DEPT_TITLE 부서명
    , SUM(E.SALARY) AS "급여의 합"
FROM 
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
GROUP BY D.DEPT_TITLE
HAVING SUM(E.SALARY) >= 10000000;

-- 7. 사번, 사원명, 직급명, 급여 등급, 구분을 조회 (NON EQUAL JOIN 후에 실습 진행)
SELECT
    E.EMP_ID 사번
    , E.EMP_NAME 사원명
    , J.JOB_NAME 직급명
    , S.SAL_LEVEL AS "급여 등급"
    --, 구분 ??
FROM 
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
    JOIN SAL_GRADE S ON E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

-- 8. 보너스를 받지 않는 직원들 중 직급 코드가 J4 또는 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
SELECT
    E.EMP_NAME 사원명
    , J.JOB_NAME 직급명
    , E.SALARY 급여
FROM 
    EMPLOYEE E
    JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE
    E.BONUS IS NULL
    AND E.JOB_CODE IN ('J4', 'J7');

-- 9. 부서가 있는 직원들의 사원명, 직급명, 부서명, 근무 지역을 조회하시오.
SELECT
    E.EMP_NAME 사원명
    , J.JOB_NAME 직급명
    , D.DEPT_TITLE 부서명
    , L.LOCAL_NAME AS "근무 지역"
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
    JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE
    E.DEPT_CODE IS NOT NULL;

-- 10. 해외영업팀에 근무하는 직원들의 사원명, 직급명, 부서 코드, 부서명을 조회하시오
SELECT
    E.EMP_NAME 사원명
    , J.JOB_NAME 직급명
    , D.DEPT_ID AS "부서 코드"
    , D.DEPT_TITLE 부서명
FROM
    EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE
    D.DEPT_TITLE LIKE '%해외%';

-- 11. 이름에 '형'자가 들어있는 직원들의 사번, 사원명, 직급명을 조회하시오.
SELECT
    E.EMP_ID 사번
    , E.EMP_NAME 사원명
    , J.JOB_NAME 직급명
FROM
    EMPLOYEE E
    JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE
    E.EMP_NAME LIKE '%형%';