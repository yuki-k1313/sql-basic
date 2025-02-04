-- 학교 데이터베이스

-- 학생 (학번, 이름, 주소, 전화번호)
-- 수업 (수업코드, 수업 이름, 교실, 담당교사)
-- 교실 (교실번호, 층, 좌석)
-- 교사 (교번, 이름, 주소, 전화번호, 직책)

-- 개발자 계정: school_developer @ % / school123
-- 개발자 계정: school_developer @ localhost / school123

-- 1. 학교 데이터베이스 생성
CREATE DATABASE school;
-- 2. 학교 데이터베이스 선택
USE school;
-- 3. 학생 테이블 생성
CREATE TABLE student (
    student_number VARCHAR(5),
    name VARCHAR(15),
    address TEXT,
    tel_number VARCHAR(13)
);
-- 4. 수업 테이블 생성
CREATE TABLE class (
    class_code VARCHAR(3),
    name VARCHAR(25),
    class_room INT,
    charge_teacher VARCHAR(10)
);
-- 5. 교실 테이블 생성
CREATE TABLE class_room (
    class_room_number INT,
    floor INT,
    seats INT
);
-- 6. 교사 테이블 생성
CREATE TABLE teacher (
    teacher_number VARCHAR(10),
    name VARCHAR(15),
    address TEXT,
    tel_number VARCHAR(13),
    position VARCHAR(50)
);
-- 7. 개발자 계정 생성
CREATE USER 'school_developer'@'%' IDENTIFIED BY 'school123';
CREATE USER 'school_developer'@'localhost' IDENTIFIED BY 'school123';

-- 축구 경기(football) 데이터베이스 

-- 참가팀(team) [국가명(nation), 조(seed), 감독(manager), 피파랭킹(lanking)]
-- 선수(player) [이름(name), 생년월일(birth), 포지션(position), 등번호(uniform_number), 국가(country)]
-- 경기장(stadium) [이름(name), 주소(address), 좌석(seats)]
-- 심판(referee) [이름(name), 생년월일(birth), 국가(country), 포지션(position)]

-- 사용자 : football_developer @ % / foot!@
--         football_broadcast @ % / foot#$

-- 참가팀 [대한민국, A, 홍길동, 30]
-- 선수 [이성계, 1998-01-15, 공격수, 10, 대한민국]
-- 경기장 [한양메인스타디움, 대한민국 서울특별시 강남구, 2000]
-- 심판 [이방원, 1994-06-05, 대한민국, 주심]

-- 1. 축구 경기 데이터베이스 생성
CREATE DATABASE football;
-- 2. 축구 경기 데이터베이스 선택
USE football;
-- 3. 참가팀 테이블 생성
CREATE TABLE team (
    nation VARCHAR(60),
    seed VARCHAR(3),
    manager VARCHAR(100),
    lanking INT
);
-- 4. 선수 테이블 생성
CREATE TABLE player (
    name VARCHAR(100),
    birth VARCHAR(10),
    position VARCHAR(12),
    uniform_number INT,
    country VARCHAR(60)
);
-- 5. 경기장 테이블 생성
CREATE TABLE stadium (
    name VARCHAR(255),
    address TEXT,
    seats INT
);
-- 6. 심판 테이블 생성
CREATE TABLE referee (
    name VARCHAR(100),
    birth VARCHAR(10),
    country VARCHAR(60),
    position VARCHAR(6)
);
-- 7. 계정 생성
CREATE USER 'football_developer'@'%' IDENTIFIED BY 'foot!@';
CREATE USER 'football_broadcast'@'%' IDENTIFIED BY 'foot#$';
-- 8. 심판과 선수의 birth 컬럼의 데이터 타입을 DATE로 변경
ALTER TABLE player MODIFY COLUMN birth DATE;
ALTER TABLE referee CHANGE birth birth DATE;