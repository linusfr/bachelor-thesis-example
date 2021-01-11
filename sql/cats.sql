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
    ('Alice', 'Blau');