-- Store name origins (language or region of origin for the names)
CREATE TABLE IF NOT EXISTS origins (
    id_origin INTEGER,
    origin TEXT NOT NULL,
    PRIMARY KEY (id_origin)
);

-- Store groups ("original" version of the names) and meanings
CREATE TABLE IF NOT EXISTS groups (
    id_group INTEGER,
    base_name TEXT NOT NULL,
    id_origin INTEGER NOT NULL,
    meaning TEXT NOT NULL,
    PRIMARY KEY (id_group),
    FOREIGN KEY(id_origin) REFERENCES origins(id_origin)
);

-- Store all names
CREATE TABLE IF NOT EXISTS names_list (
    id_name INTEGER,
    name TEXT NOT NULL,
    gender TEXT NOT NULL,
    id_origin INTEGER NOT NULL,
    id_group INTEGER NOT NULL,
    PRIMARY KEY (id_name),
    FOREIGN KEY(id_origin) REFERENCES origins(id_origin),
    FOREIGN KEY(id_group) REFERENCES groups(id_group)
);

-- Cross-reference all tables
CREATE VIEW full_version AS
SELECT
    n.name,
    o1.origin AS 'name_origin',
    g.base_name,
    g.meaning,
    o2.origin AS 'group_origin',
    n.gender
FROM names_list n
JOIN origins o1 ON n.id_origin = o1.id_origin
JOIN groups g ON n.id_group = g.id_group
JOIN origins o2 ON g.id_origin = o2.id_origin;

-- Cross-reference names and origins
CREATE VIEW names_origins AS
SELECT n.name, o.origin FROM names_list n
JOIN origins o ON n.id_origin = o.id_origin;

-- Cross-reference groups and origins
CREATE VIEW groups_origins AS
SELECT g.base_name, o.origin FROM groups g
JOIN origins o ON g.id_origin = o.id_origin;

-- Create indexes
CREATE INDEX origins_index ON origins (id_origin, origin);
CREATE INDEX group_id_index ON groups (id_group);
CREATE INDEX names_index ON names_list (id_name, name);


