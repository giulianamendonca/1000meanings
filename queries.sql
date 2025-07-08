-- Queries that users will commonly run on the database

-- Check if a name is on the database
SELECT * FROM names_list
WHERE name = 'Ana';

-- Find the origin of a name
SELECT * FROM names_origins
WHERE name = 'Ana';

-- Find all names from a given origin
SELECT * FROM names_origins
WHERE origin = 'English';

-- Find all names with a given meaning (keyword)
SELECT * FROM full_version
WHERE meaning LIKE '%favor%';

-- Find names with the same meaning (i.e. same group) as a given one
SELECT DISTINCT(n2.name) FROM names_list n1
JOIN names_list n2 ON n1.id_group = n2.id_group
WHERE n1.name = 'Ana' AND n1.id_origin = '10';

-- Display the origin and meaning of a name
SELECT name, name_origin, meaning FROM full_version
WHERE name = 'Ana';

-- Find all names with a given keyword in the meaning
SELECT n.name, g.meaning FROM names_list n
JOIN groups g ON n.id_group = g.id_group
WHERE g.meaning LIKE '%God%';

-- Find all names of a given gender
SELECT name FROM names_list
WHERE gender = 'masculine';

-- Add a new origin
INSERT INTO origins (origin) VALUES
    ('Macedonian');

-- Add a new group
INSERT INTO groups (base_name, id_origin, meaning) VALUES
    ('Cosette', 28, 'little thing of no importance');

-- Add a new name to the list
INSERT INTO names_list (name, gender, id_origin, id_group) VALUES
    ('Ksenija', 'feminine', 62, 208),
    ('Ksenija', 'feminine', 62, 209);

SELECT * FROM full_version WHERE name = 'Ksenija';

-- Update the base name and origin of a group
SELECT * FROM groups WHERE base_name = 'Ksenija';

UPDATE groups SET
    base_name = 'Xenia',
    id_origin = (SELECT id_origin FROM origins WHERE origin = 'Greek')
WHERE base_name = 'Ksenija';

SELECT * FROM groups WHERE base_name = 'Xenia';

-- Update the description of a language
UPDATE origins SET origin = 'Gaelic (Irish)'
WHERE origin = 'Irish Gaelic';

-- Update the origin of a name
UPDATE names_list SET id_origin = 78
WHERE id_name = 1000 OR id_name = 1001;
