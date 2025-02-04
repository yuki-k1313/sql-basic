USE practice_sql;

CREATE TABLE employee (
	employee_number INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20),
	age INT,
    department_code VARCHAR(2)
);

CREATE TABLE department (
	department_code VARCHAR(2) PRIMARY KEY,
    name VARCHAR(30),
    tel_number VARCHAR(15)
);

ALTER TABLE employee
ADD CONSTRAINT employee_department_code_fk
FOREIGN KEY (department_code)
REFERENCES department (department_code);

ALTER TABLE employee
DROP CONSTRAINT employee_department_code_fk;

INSERT INTO department VALUES ('A', '영업부', '051-111-1111');
INSERT INTO department VALUES ('B', '인사부', '051-111-2222');
INSERT INTO department VALUES ('C', '총무부', '051-111-3333');

INSERT INTO employee (name, age, department_code)
VALUES ('홍길동', 23, 'A');
INSERT INTO employee (name, age, department_code)
VALUES ('이영희', 32, 'D');
INSERT INTO employee (name, age, department_code)
VALUES ('김철수', 23, 'B');
INSERT INTO employee (name, age, department_code)
VALUES ('이성계', 40, 'A');
INSERT INTO employee (name, age, department_code)
VALUES ('왕건', 18, 'D');

SELECT * FROM department;
SELECT * FROM employee;

-- Alias : 쿼리문에서 사용되는 별칭
-- 컬럼 및 테이블에서 사용가능
-- 결과 혹은 원래 이름을 다르게 지정하고 싶을 때 사용
SELECT 
	employee_number AS '사번', 
	name AS '사원 이름', 
    age AS '사원 나이', 
    department_code AS '부서 코드'
FROM employee AS e;

-- JOIN : 두 개 이상의 테이블을 특정 조건에 따라 조합하여 결과를 조회하고자 할때 사용하는 명령어

-- INNER JOIN : 두 테이블에서 조건이 일치하는 레코드만 반환
-- SELECT column, ... FROM 기준테이블 INNER JOIN 조합할테이블 ON 조인조건
SELECT 
	E.employee_number '사원 번호',
    E.name '사원 이름',
    E.age '사원 나이',
    D.department_code '부서 코드',
    D.name '부서 이름',
    D.tel_number '부서 전화번호'
FROM employee E INNER JOIN department D
ON E.department_code = D.department_code;

-- JOIN이 포함된 WHERE 작업은 JOIN 결과에서 조건을 검사함
SELECT 
	E.employee_number '사원 번호',
    E.name '사원 이름',
    E.age '사원 나이',
    D.department_code '부서 코드',
    D.name '부서 이름',
    D.tel_number '부서 전화번호'
FROM employee E INNER JOIN department D
ON E.department_code = D.department_code
WHERE E.age > 20;

-- LEFT OUTER JOIN (LEFT JOIN) : 기준 테이블의 모든 레코드와 조합할 테이블 중 조건에 일치하는 레코드만 반환
-- 만약, 조합할 테이블에 조건에 부합하는 레코드가 존재하지 않으면 null로 채움
SELECT 
	E.employee_number '사원 번호',
    E.name '사원 이름',
    E.age '사원 나이',
    D.department_code '부서 코드',
    D.name '부서 이름',
    D.tel_number '부서 전화번호'
FROM employee E LEFT JOIN department D
ON E.department_code = D.department_code;

-- RIGHT OUTER JOIN (RIGHT JOIN) : 조합할 테이블의 모든 레코드와 기준 테이블 중 조건에 일치하는 레코드만 반환
-- 만약, 조합할 테이블에 조건에 부합하는 레코드가 존재하지 않으면 null로 채움
SELECT 
	E.employee_number '사원 번호',
    E.name '사원 이름',
    E.age '사원 나이',
    D.department_code '부서 코드',
    D.name '부서 이름',
    D.tel_number '부서 전화번호'
FROM employee E RIGHT JOIN department D
ON E.department_code = D.department_code;

-- FULL OUTER JOIN (FULL JOIN) : 기준 테이블의 모든 레코드와 조합할 테이블의 모든 레코드를 반환
-- 만약 기준 테이블 혹은 조합할 테이블에 조건에 부합하는 레코드가 존재하지 않으면 NULL로 반환
-- MYSQL에서는 FULL OUTER JOIN을 문법상으로 지원하지 않음
-- FULL JOIN = LEFT JOIN + RIGHT JOIN
SELECT 
	E.employee_number '사원 번호',
    E.name '사원 이름',
    E.age '사원 나이',
    D.department_code '부서 코드',
    D.name '부서 이름',
    D.tel_number '부서 전화번호'
FROM employee E LEFT JOIN department D
ON E.department_code = D.department_code
UNION
SELECT 
	E.employee_number '사원 번호',
    E.name '사원 이름',
    E.age '사원 나이',
    D.department_code '부서 코드',
    D.name '부서 이름',
    D.tel_number '부서 전화번호'
FROM employee E RIGHT JOIN department D
ON E.department_code = D.department_code;

-- CROSS JOIN : 기준 테이블의 각 레코드를 조합할 테이블의 각 레코드와 조합하여 반환
-- CROSS JOIN 결과 레코드 수 = 기준 테이블 레코드 수 * 조합할 테이블의 레코드 수
-- CROSS JOIN에서는 ON 조건절이 필요없음
SELECT *
FROM employee E CROSS JOIN department D;

-- MYSQL에서 기본 조인이 CROSS JOIN 임
SELECT *
FROM employee E JOIN department D;

SELECT *
FROM employee E, department D;

-- 부서코드가 A인 사원에 대해 사번, 사원의 이름, 부서명을 조회하시오.
SELECT 
	E.employee_number '사번', 
	E.name '사원이름',
    D.name '부서명'
FROM employee E INNER JOIN department D
ON E.department_code = D.department_code
WHERE E.department_code = 'A';

-- 부서명이 '영업부'인 사원에 대해 사번, 이름, 나이를 조회하시오
SELECT 
	E.employee_number '사번',
    E.name '이름',
    E.age '나이'
FROM employee E INNER JOIN department D
ON E.department_code = D.department_code
WHERE D.name = '영업부';

-- 서브쿼리 : 쿼리 내부에 존재하는 또 다른 쿼리, 쿼리 결과를 조건이나 테이블로 사용할 수 있도록 함

-- WHERE 절에서 서브쿼리 : 조회 결과를 조건으로 사용하여 조건을 동적으로 지정할 수 있도록 함 
-- WHERE 절에서 비교 연산등으로 사용할 때 서브쿼리의 결과 컴럼 및 레코드 수 주의 
SELECT employee_number, name, age
FROM employee
WHERE department_code = (
	SELECT department_code 
	FROM department 
	WHERE name = '영업부'
);

-- WHERE 조건절에서 서브쿼리를 사용할 땐 일반적으로 해당 서브쿼리의 결과 컬럼은 1개가 와야함
SELECT employee_number, name, age
FROM employee
WHERE department_code = (
	SELECT *
	FROM department 
	WHERE name = '영업부'
);

-- WHERE 조건절에서 서브쿼리를 사용할 땐 연산자에 따라 레코드의 개수를 잘 확인해야함 
SELECT employee_number, name, age
FROM employee
WHERE department_code = (
	SELECT department_code
	FROM department 
);

SELECT employee_number, name, age
FROM employee
WHERE department_code IN (
	SELECT *
	FROM department 
);

-- FROM 절에서 서브쿼리 : 조회 결과 테이블을 다시 FROM 절에서 재사용
SELECT * 
FROM employee E INNER JOIN (
	SELECT * FROM department WHERE name = '영업부'
) D
ON E.department_code = D.department_code;