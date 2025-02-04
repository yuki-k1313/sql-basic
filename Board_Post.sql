CREATE DATABASE crud;
USE crud;

CREATE TABLE user (
	id VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    CONSTRAINT user_pk PRIMARY KEY (id)
);

SELECT * FROM user;

CREATE TABLE board (
	board_number INT NOT NULL UNIQUE AUTO_INCREMENT,
    title TEXT NOT NULL,
    contents TEXT NOT NULL,
    write_date DATE NOT NULL,
    writer_id VARCHAR(20) NOT NULL,
    
    CONSTRAINT board_pk PRIMARY KEY (board_number),
    CONSTRAINT board_writer_fk FOREIGN KEY (writer_id) REFERENCES user (id)
);

SELECT * FROM board;

SELECT title, writer_id, write_date, contents FROM board;

SELECT 
	B.title,
	U.nickname,
    B.write_date,
    B.contents
FROM board B INNER JOIN user U
ON B.writer_id = U.id
WHERE B.board_number = 1;

CREATE VIEW board_view AS
SELECT 
	B.board_number board_number,
	B.title title,
	U.nickname writer_nickname,
    B.write_date write_date,
    B.contents contents
FROM board B INNER JOIN user U
ON B.writer_id = U.id;

SELECT * FROM board_view
ORDER BY board_number DESC;
