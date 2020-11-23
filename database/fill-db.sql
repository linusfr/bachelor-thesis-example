-- create password.txt and fill in the password
-- psql -U test -d test_db
-- help             ->  \?
-- get relations    ->  \d

--------------------------
-- CATS
--------------------------

-- psql -U demo -d cats -c "CREATE TABLE IF NOT EXISTS cat(cat_id serial PRIMARY KEY, name VARCHAR ( 50 ) NOT NULL, color VARCHAR ( 255 ) NOT NULL);"

-- psql -U demo -d cats -c "INSERT INTO cat (name, color) VALUES ('Bob', 'Rot');"


CREATE TABLE cat
(
    cat_id serial PRIMARY KEY,
    name VARCHAR ( 50 ) NOT NULL,
    color VARCHAR ( 255 ) NOT NULL
);

INSERT INTO cat
    (name, color)
VALUES
    ('Bob', 'Rot');
INSERT INTO cat
    (name, color)
VALUES
    ('alice', 'green');

select *
from cat;
delete from cat where name='bob'

--------------------------
-- DOGS
--------------------------

CREATE TABLE dog
(
    dog_id serial PRIMARY KEY,
    name VARCHAR ( 50 ) NOT NULL,
    color VARCHAR ( 255 ) NOT NULL
);

INSERT INTO dog
    (name, color)
VALUES
    ('bob', 'red');
INSERT INTO dog
    (name, color)
VALUES
    ('alice', 'green');

select *
from dog;
delete from dog where name='bob' 