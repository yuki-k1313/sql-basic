 USE practice_sql;
 
 -- 제약조건 : 데이터베이스 테이블 컬럼에 삽입, 수정, 삭제 시 규칙을 적용하는 방법 
 
 -- NOT NULL 제약조건 : 해당 컬럼에 null을 지정하지 못하도록 하는 제약
 -- [자기 자신 테이블의 INSERT, UPDATE에 영향을 미침]
CREATE TABLE not_null_table (
	null_column INT NULL,
	not_null_column INT NOT NULL
); 

-- NOT NULL 제약조건이 지정된 컬럼을 삽입시 선택하지 않았을 경우 
-- Error Code : 1364
INSERT INTO not_null_table (null_column) VALUES (1);

-- NOT NULL 제약조건이 지정된 컬럼에 null을 지정할 경우
-- Error code : 1048
INSERT INTO not_null_table VALUES (1, null);

-- NOT NULL 제약조건이 지정된 컬럼에 null을 지정할 경우
-- Error code : 1048
UPDATE not_null_table SET not_null_column = null;

INSERT INTO not_null_table VALUES (1, 1);
INSERT INTO not_null_table VALUES (null, 1);
INSERT INTO not_null_table (not_null_column) VALUES (3);

-- ------------------------------------------------------------------
-- UNIQUE 제약 조건: 해당 컬럼에 중복된 데이터를 지정할 수 없도록 하는 제약
-- [자기 자신 테이블의 INSERT, UPDATE 영향을 미침]
CREATE TABLE unique_table (
	unique_column INT UNIQUE,
    not_unique_column INT
);

INSERT INTO unique_table VALUES (1, 1);
-- UNIQUE 제약조건이 지정된 컬럼에 중복된 데이터를 지정하려는 경우
-- Error Code : 1062
INSERT INTO unique_table VALUES (1, 1);

INSERT INTO unique_table VALUES (2, 1);

-- UNIQUE 제약조건이 지정된 컬럼에 중복된 데이터로 수정하려 하는 경우
-- Error Code : 1062
UPDATE unique_table SET unique_column = 1;

-- ------------------------------------------------------------------
-- KEY : 레코드의 구분을 위한 컬럼의 조합 (1, ~) 
-- 슈퍼키 (Super Key) : 컬럼의 조합으로 독립적인 레코드를 구분할 수 있는 키
-- 후보키 (Candidate Key) : 최소한의 컬럼으로 레코드를 구분할 수 있는 키
-- 기본키 (Primary Key) : 후보키에서 프로세스에 맞게 선택된 레코드를 구분할 수 있는 키
-- 대체키 (Alternate Key) : 후보키에서 기본키로 선택되지 않은 나머지 키
-- 복합키 (Composite Key) : 두 개 이상의 컬럼의 조합으로 레코드를 구분할 수 있는 기본 키

-- PRIMARY KY 제약조건 : 해당 컬럼을 기본키로 지정하는 제약
-- (NOT NULL + UNIQUE)
-- [자기자신의 테이블 뿐만 아니라 다른 테이블에도 INSERT, UPDATE 영향을 미침]
CREATE TABLE pk_table (
	primary_column INT PRIMARY KEY,
    other_column INT NOT NULL UNIQUE
);

-- PRIMARY 제약조건은 NOT NULL 과 UNIQUE 제약조건을 모두 가지고 있음
INSERT INTO pk_table VALUES (null, 1);
INSERT INTO pk_table (other_column) VALUES (2);

INSERT INTO pk_table VALUES (1, 1);
INSERT INTO pk_table VALUES (1, 2);

-- PRIMARY KEY 제약조건을 두 개 이상 지정 불가능
CREATE TABLE composite_table (
	pk1 INT PRIMARY KEY,
    pk2 INT PRIMARY KEY
);

-- 제약조건 지정 방법
-- CONSTRAINT 제약조건의이름 제약조건 (선택할 컬럼)
CREATE TABLE composite_table (
	pk1 INT,
    pk2 INT,
    CONSTRAINT composite_table_pk PRIMARY KEY (pk1, pk2) 
);

-- 제약조건 수정
-- 1. ALTER 테이블명 MODIFY COLUMN 컬럼명 데이터타입 제약조건
-- 2. ALTER 테이블명 DROP CONSTARINT 제약조건이름
-- 3. ALTER 테이블명 ADD CONSTRAINT 제약조건이름

-- 주의 : 제약조건 변경시 실데 데이터가 유효한지 검증을 먼저 수행해야 함
SELECT * FROM not_null_table;

UPDATE not_null_table SET null_column = 1
WHERE null_column IS NULL;

ALTER TABLE not_null_table 
MODIFY COLUMN null_columm INT NOT NULL;

ALTER TABLE not_null_table
ADD CONSTRAINT not_null_table_uq UNIQUE (null_column);

-- FOREIGN KEY 제약조건 : 특정 컬럼을 다른 테이블 혹은 같은 테이블의 기본 키 컬럼과 연결하는 제약
-- FOREIGN KEY 제약조건이 지정되는 컬럼은 참조하고자하는 컬럼의 데이터 타입과 일치해야함

CREATE TABLE fk_Table (
	pk_column INT PRIMARY KEY,
    fk_column INT,
    CONSTRAINT fk_table_fk FOREIGN KEY (fk_Column)
    REFERENCES pk_table(primary_column)
);

SELECT * FROM pk_table;
SELECT * FROM fk_table;

-- FOREIGN KEY 제약조건이 지정된 커럼은 참조하고 있는 테이블 컬럼에 값이 존재하지 않으면 삽입, 수정이 불가능
-- Error Code : 1452
-- 단, 해당 컬럼이 NOT NULL이 아니라면 NULL은 지정할 수 있음
INSERT INTO fk_table VALUES (1, 0);
INSERT INTO fk_table VALUES (1, null);
UPDATE fk_table SET fk_column = 1 WHERE pk_column = 1;

-- FOREIGN KEY 제약조건으로 참조 해주는 테이블 컬럼을 수정, 삭제 작업이 불가능
-- Error Code : 1451
UPDATE pk_table SET primary_column = 2 WHERE primary_column = 1;
DELETE FROM pk_table; 

-- ON UPDATE / ON DELETE 옵션
-- ON UPDATE : 부모 테이블의 기본키가 변경될 때 동작
-- ON DELETE : 부모 테이블의 기본키가 삭제될 때 동작

-- RESTRICE : 부모 테이블의 기본키의 수정 및 삭제를 불가능하게 함 (기본값)
-- CASCADE : 부모 테이블의 기본키가 삭제 또는 수정된다면, 자식 테이블의 외래키도 같이 삭제 또는 수정됨
-- SET NULL : 부모 테이블의 기본키가 삭제 또는 수정된다면, 자식 테이블의 왜리키는 null로 지정
CREATE TABLE optional_fk_table (
	pk_column INT PRIMARY KEY,
    fk_column INT,
	FOREIGN (fk_column) 
    REFERENCES pk_table (primary_column)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

INSERT INTO optionam_fk_table VALUES (1, 1);
SELECT * FROM optionam_fk_table;
SELECT * FROM pk_table;
DROP TABLE fk_table;
UPDATE pk_table SET primary_column = 2 WHERE primary_column = 1;
DELETE FROM pk_table;

-- CHECK 제약조건 : 특정 컬럼에 값을 제한하는 제약
-- [자기 자신 테이블 INSERT, UPDATE에 영향을 미침]
CREATE Table check_table (
	check_column VARCHAR(5) CHECK(check_column IN('남','여'))
);
-- CHECK 제약조건이 지정된 컬럼에 조건에 부합하지 않는 값으로 삽입,수정 불가능
-- Error Code : 3819
INSERT INTO check_table VALUES ('남자');
INSERT INTO check_table VALUES ('남');
UPDATE check_table SET check_column = '여자';

-- DEFAULT 제약조건 : 특정컬럼에 삽입시 값이 지정되지 않으면 기본값을 지정하는 제약
-- [자기자신 테이블 INSERT에 영향을 미침]
CREATE TABLE default_table (
	-- AUTO_INCREMENT : 기본키에서 데이터타입이 정수형일 때 값을 1씩 증가하는 값으로 자동 지정
	ai_column INT PRIMARY KEY AUTO_INCREMENT,
    default_column INT DEFAULT 99,
    column1 INT
);

INSERT INTO default_table (column1) VALUES (1);
INSERT INTO default_table VALUES (5, 1, 0);
SELECT * FROM default_table;