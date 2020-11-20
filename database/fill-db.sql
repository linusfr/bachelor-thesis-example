-- create password.txt and fill in the password
-- psql -U test -d test_db
-- help             ->  \?
-- get relations    ->  \d

--------------------------
-- CATS
--------------------------

CREATE TABLE cat (cat_id serial PRIMARY KEY, name VARCHAR ( 50 ) NOT NULL, color VARCHAR ( 255 ) NOT NULL);

INSERT INTO cat (name, color) VALUES ('bob', 'red');
INSERT INTO cat (name, color) VALUES ('alice', 'green');

select * from cat;
delete from cat where name='bob' 

--------------------------
-- DOGS
--------------------------

CREATE TABLE dog (dog_id serial PRIMARY KEY, name VARCHAR ( 50 ) NOT NULL, color VARCHAR ( 255 ) NOT NULL);

INSERT INTO dog (name, color) VALUES ('bob', 'red');
INSERT INTO dog (name, color) VALUES ('alice', 'green');

select * from dog;
delete from dog where name='bob' 