


Create Schema LIBRARY;
Use LIBRARY;



-- 1)

CREATE TABLE PUBLISHER ( 
Name VARCHAR(60) NOT NULL,
Address VARCHAR(80) NOT NULL,
Phone CHAR(20),
PRIMARY KEY (Name)
);

CREATE TABLE BOOK ( 
Book_id CHAR(25) NOT NULL,
Title VARCHAR(80) NOT NULL,
Publisher_name VARCHAR(60),
PRIMARY KEY (Book_id),
FOREIGN KEY (Publisher_name) REFERENCES PUBLISHER (Name)  ON UPDATE CASCADE 
);


CREATE TABLE BOOK_AUTHORS (
Book_id CHAR(25) NOT NULL,
Author_name VARCHAR(60) NOT NULL,
PRIMARY KEY (Book_id, Author_name),
FOREIGN KEY (Book_id) REFERENCES BOOK (Book_id) ON DELETE CASCADE   ON UPDATE CASCADE 
);



CREATE TABLE LIBRARY_BRANCH ( 
Branch_id int NOT NULL,  
Branch_name VARCHAR(80) NOT NULL,
Address VARCHAR(80) NOT NULL,
PRIMARY KEY (Branch_id) 
);



CREATE TABLE BOOK_COPIES ( 
Book_id CHAR(25) NOT NULL,
Branch_id int NOT NULL,
No_of_copies int NOT NULL,
PRIMARY KEY (Book_id, Branch_id),
FOREIGN KEY (Book_id) REFERENCES BOOK (Book_id)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH (Branch_id)
ON DELETE CASCADE ON UPDATE CASCADE 
);



CREATE TABLE BORROWER ( 
Card_no int NOT NULL,
Name VARCHAR(60) NOT NULL,
Address VARCHAR(80) NOT NULL,
Phone CHAR(20),
PRIMARY KEY (Card_no) 
);



CREATE TABLE BOOK_LOANS ( 
Book_id CHAR(25) NOT NULL,
Branch_id INT NOT NULL,
Card_no INT NOT NULL,
Date_out DATE NOT NULL,
Due_date DATE NOT NULL,
PRIMARY KEY (Book_id, Branch_id, Card_no),
FOREIGN KEY (Card_no) REFERENCES BORROWER (Card_no)  ON UPDATE CASCADE,
FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH (Branch_id)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (Book_id) REFERENCES BOOK (Book_id)  ON UPDATE CASCADE 
);





-- 2)

INSERT INTO  PUBLISHER VALUES ('Ahmed','8 shore st.','03-2367955') ;

UPDATE PUBLISHER 
SET phone= '03-2344985'  
WHERE Name= 'Ahmed' ;

DELETE FROM PUBLISHER 
WHERE Name= 'Ahmed' ;



-- 3)

INSERT INTO  PUBLISHER VALUES ('Adel','15 shore st.','03-4767955') ;
INSERT INTO  PUBLISHER VALUES ('Abdelrahman','10 shore st.','03-1117955') ;


INSERT INTO BOOK VALUES ( '254' , 'The War of Art' , 'Adel' ) ;
INSERT INTO BOOK VALUES ( '200' , 'JAVA' , 'Abdelrahman' ) ;

UPDATE PUBLISHER 
SET  Name= 'Mohamed'   
WHERE Name= 'Adel' ;

-- In the previous query we updated a tuple in PUBLISHER which is referenced by a tuple in BOOK and we use CASCADE ON UPDATE so when we
-- updated the tuple and set the name to 'Mohamed' instead of 'Adel' ,then the tuple in BOOK is automatically updated and the named is changed 
-- to 'Mohamed' and this is clear in the following query  

SELECT *
FROM BOOK 
WHERE Book_id= '254' ;


DELETE FROM PUBLISHER 
WHERE Name= 'Mohamed' ;

-- In the previous query we tried to delete a tuple in PUBLISHER which is referenced by a tuple in BOOK and we use REJECT ON DELETE (this is the default) 
-- so when we tried to delete  the tuple where the name is 'Mohamed', the DBMS give an error as we cannot delete the referenced row becuase then
-- the foreign key constraint will fail 




-- 4)



-- a)

SELECT NO_OF_COPIES 
FROM BOOK_COPIES  AS R
WHERE R.Book_id IN (SELECT Book_iD FROM BOOK WHERE Title = "The Lost Tribe") AND
R.Branch_id IN (SELECT Branch_id FROM LIBRARY_BRANCH WHERE Branch_name = "Sharpstown") ;


-- c)

SELECT BORROWER.Name 
FROM BORROWER 
WHERE(
BORROWER.Card_no  NOT IN( SELECT Card_no FROM BOOK_LOANS)  );




-- e)


SELECT Branch_name, COUNT(*) 
FROM  LIBRARY_BRANCH ,BOOK_LOANS
WHERE  LIBRARY_BRANCH.Branch_id =  BOOK_LOANS.Branch_id 
GROUP BY  Branch_name ;






-- g)

SELECT Title, NO_of_copies 
FROM (((BOOK_AUTHORS  NATURAL JOIN BOOK) NATURAL JOIN BOOK_COPIES) NATURAL JOIN LIBRARY_BRANCH)
WHERE Author_name = "Stephen King"  AND BRANCH_ID IN (SELECT BRANCH_ID FROM LIBRARY_BRANCH WHERE BRANCH_NAME = "Central");















