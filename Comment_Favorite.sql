USE crud;

CREATE TABLE comment (
	comment_number INT NOT NULL UNIQUE AUTO_INCREMENT,
	contents TEXT NOT NULL, 		
    board_number INT NOT NULL,		
    write_datetime DATETIME NOT NULL,
    writer_id VARCHAR(20) NOT NULL,		
    status BOOLEAN NOT NULL,				
    parent_comment INT,
    
    CONSTRAINT comment_pk PRIMARY KEY (comment_number),
    CONSTRAINT comment_board_fk FOREIGN KEY (board_number) REFERENCES board (board_number),
    CONSTRAINT comment_user_fk FOREIGN KEY (writer_id) REFERENCES user (id),
    CONSTRAINT parent_comment_fk FOREIGN KEY (parent_comment) REFERENCES comment (comment_number)
);

CREATE TABLE favorite(
	id VARCHAR(20) NOT NULL,
    board_number INT NOT NULL,
    
    CONSTRAINT favorite_pk PRIMARY KEY (id, board_number),
    CONSTRAINT favorite_user_fk FOREIGN KEY (id) REFERENCES user (id),
	CONSTRAINT favorite_board_fk FOREIGN KEY (board_number) REFERENCES board (board_number)
);
-- 댓글 달기
INSERT INTO comment (contents, board_number, writer_id, write_datetime, status, parent_comment)
VALUES ("아무말", 1, "qwer1234", now(), true, null);

INSERT INTO comment (contents, board_number, writer_id, write_datetime, status, parent_comment)
VALUES ("자식댓글1", 1, "qwer1234", now(), true, 1);

INSERT INTO comment (contents, board_number, writer_id, write_datetime, status, parent_comment)
VALUES ("자식댓글2", 1, "qwer1234", now(), true, 1);

select * from comment;

-- 댓글 수정
UPDATE comment SET status = false WHERE
comment_number = 2;

-- 댓글 삭제
DELETE FROM comment WHERE comment_number = 2; 

-- 좋아요 수 보기
SELECT * FROM favorite WHERE id = "qwer1234" AND board_number = 1;

-- 좋아요 누르기
INSERT INTO favorite VALUES ("qwer1234", 1);

-- 좋아요 취소
DELETE FROM favorite WHERE id = "qwer1234" AND board_number = 1;

-- 댓글 수 보기
SELECT COUNT(*) FROM comment 
WHERE board_number = 1;

SELECT COUNT(*) FROM favorite
WHERE board_number = 1;

SELECT board_number, COUNT(*) FROM comment
WHERE board_number = 1
GROUP BY board_number;		-- GROUP BY 안 써도 되지만 써주는게 좋다.

SELECT board_number, COUNT(*) FROM favorite
WHERE board_number = 1
GROUP BY board_number;	

SELECT 
	C.board_number 'board_number',
    IFNULL(C.count, 0) 'comment_count',
	IFNULL(F.count, 0) 'favorite_count'
FROM 
(
	SELECT board_number, COUNT(*) count FROM comment
	WHERE board_number = 1
	GROUP BY board_number
) C
LEFT JOIN 
(
	SELECT board_number, COUNT(*) count FROM favorite
	WHERE board_number = 1
	GROUP BY board_number
) F
ON C.board_number = F.board_number;
