CREATE DATABASE board;

USE board;

CREATE TABLE user (
	email VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    nickname VARCHAR(20) NOT NULL UNIQUE,
    tel_number VARCHAR(15) NOT NULL UNIQUE,
    address TEXT NOT NULL,
    address_detail TEXT,
    profile_image TEXT,
    agreed_personal TINYINT NOT NULL,
    
     CONSTRAINT email PRIMARY KEY (email)
);

CREATE TABLE board (
	board_number INT NOT NULL AUTO_INCREMENT ,
    title VARCHAR(255) NOT NULL,
    contents TEXT NOT NULL,
    write_datetime DATETIME NOT NULL DEFAULT now(),
    favorite_count INT NOT NULL DEFAULT 0,
    comment_count INT NOT NULL DEFAULT 0,
    view_count INT NOT NULL DEFAULT 0,
    writer_email VARCHAR(50) NOT NULL,
    
	CONSTRAINT board_number PRIMARY KEY (board_number),
    CONSTRAINT writer FOREIGN KEY (writer_email) REFERENCES user (email)
);

CREATE TABLE comment (
	comment_number INT NOT NULL,
    contents TEXT NOT NULL,
    write_datetime DATETIME NOT NULL DEFAULT now(),
    user_email VARCHAR(50) NOT NULL,
    board_number INT NOT NULL,
    
    CONSTRAINT comment_number PRIMARY KEY (comment_number),
	CONSTRAINT comment_writer FOREIGN KEY (user_email) REFERENCES user (email),
    CONSTRAINT board_comment FOREIGN KEY (board_number) REFERENCES board (board_number)
);
INSERT INTO comment (comment_number, contents, write_datetime ,user_email, board_number)
VALUES (2 ,"하하", now(),"email@email.com", 1);
select * from comment;

CREATE TABLE favorite (
	user_email VARCHAR(50) NOT NULL,
    board_board_number INT NOT NULL,
    
	PRIMARY KEY (user_email,board_board_number),
	KEY favorite (board_board_number),
    CONSTRAINT user_favorite FOREIGN KEY (user_email) REFERENCES user (email),
    CONSTRAINT board_favorite FOREIGN KEY (board_board_number) REFERENCES board (board_number)
);

CREATE TABLE board_image (
	sequence INT NOT NULL AUTO_INCREMENT,
    board_number INT NOT NULL,
    image_url TEXT,
    
	CONSTRAINT sequence PRIMARY KEY (sequence),
    CONSTRAINT board_image FOREIGN KEY (board_number) REFERENCES board (board_number)
);

CREATE TABLE search_log (
	sequence INT NOT NULL,
    search_word TEXT NOT NULL,
    relation_word TEXT,
    relation TINYINT NOT NULL,
    
    CONSTRAINT sequence PRIMARY KEY (sequence)
);

-- 1. 
INSERT INTO user (email, password, nickname, tel_number, address, address_detail, agreed_personal) VALUES ('email@email.com', 'P!sswOrd', 'rose', '010-1234-5678', '부산광역시 사하구', '낙동대로', true);
SELECT * FROM user;

-- 2.
INSERT INTO user (email, profile_image)VALUES ('email@email.com' ,'https://cdn.onews.tv/news/photo/202103/62559_62563_456.jpg');

-- 3. 부모 테이블인 user에 해당하는 이메일이 존재하지 않아 매칭이 안되기 때문에 에러가 난다.
INSERT INTO board (title, contents, writer_email) VALUES ('첫번째 게시물', '반갑습니다. 처음뵙겠습니다.', 'email2@email.com');

-- 4.
INSERT INTO board (title, contents, writer_email) VALUES ('첫번째 게시물', '반갑습니다. 처음뵙겠습니다.', 'email@email.com');

-- 5.
INSERT INTO board_image (board_number, image_url) VALUES (1, 'https://image.van-go.co.kr/place_main/2022/04/04/12217/035e1737735049018a2ed2964dda596c_750S.jpg');

-- 6.
INSERT INTO favorite VALUES ('email@email.com', 1);

-- 7.
SELECT 
	B.board_number '게시물 번호',
    B.title '게시물 제목',
    B.contents '게시물 내용',
    B.view_count '조회수',
    B.comment_count '댓글수',
    B.favorite_count '좋아요수',
    B.write_datetime '게시물 작성일',
    U.email '작성자 이메일',
    U.profile_image '작성자 프로필 사진',
    U.nickname '작성자 닉네임'
FROM user U JOIN board B ;

-- 8.
CREATE VIEW board_view AS
SELECT 
	B.board_number '게시물 번호',
    B.title '게시물 제목',
    B.contents '게시물 내용',
    B.view_count '조회수',
    B.comment_count '댓글수',
    B.favorite_count '좋아요수',
    B.write_datetime '게시물 작성일',
    U.email '작성자 이메일',
    U.profile_image '작성자 프로필 사진',
    U.nickname '작성자 닉네임'
FROM user U JOIN board B;

-- 9.
SELECT * FROM board_view 
WHERE '게시물 제목' LIKE '%반갑%' || '게시물 내용' LIKE '%반갑%';

-- 10.
CREATE INDEX board_title_idx ON board (title);

-- 11.
SELECT board_number, COUNT(*) FROM comment
WHERE board_number = 1
GROUP BY board_number;	

SELECT board_board_number, COUNT(*) FROM favorite
WHERE board_board_number = 1
GROUP BY board_board_number;

SELECT 
    DISTINCT COUNT(*) over() as TOTAL
FROM user U JOIN board B
WHERE U.email LIKE 'email@email.com'
GROUP BY board_number;

SELECT 
    DISTINCT COUNT(*) over() as TOTAL
FROM board B JOIN comment c
WHERE B.board_number = 1;

SELECT 
    DISTINCT COUNT(*) over() as TOTAL
FROM board B JOIN favorite F
WHERE B.board_number = 1;



 