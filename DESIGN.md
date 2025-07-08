# Design Document

**1000 Meanings**
By Giuliana Mendonça

Video overview [here](https://youtu.be/N4ZD0j1rB-U)

## Purpose

[20000-names.com](https://www.20000-names.com/) is an online collection of names from a variety of backgrounds, including different languages, cultures, and historical periods. While rich in content, the data on the site is presented in an unstructured, web-page-based format, which makes its contents difficult to search or filter, especially when looking for names by meaning.

The **1000 Meanings** project addresses this limitation by transforming selected data from the site into a relational SQL database designed to support more efficient search functionality. The result is a tool that can assist not only with casual name browsing but also with creative writing or cultural studies involving name etymology and evolution.

This project was developed as the final assignment for the CS50 SQL course and is based on information from [20000-names.com](https://www.20000-names.com/), which I personally formatted, cross-referenced, and structured for database use.

## Scope

The **1000 Meanings** database was designed to power a custom search feature for the [20000-names.com](https://www.20000-names.com/) website. As such, it includes the essential entities required to provide structured, searchable information about:
* Origins: The language or region where a particular name version (spelling) is used.
* Groups: The root name ("first version") shared by a set of name versions, along with their collective meaning and the origin tied to that root.
* Names: A sample of ~1,000 name variations, each associated with an origin, a group, and a gender designation.

Out of scope are non-essential elements, such as free-form notes or themed lists (e.g: [Biblical Names List](https://www.20000-names.com/bible_names_male_biblical_names.htm)).

## Functional Requirements

This database will support:

* Storing and retrieving name data, along with their associated origin, group and gender.
* Grouping different spellings and variations of a name under a shared root version and meaning.
* Associating each name, including root versions, with a language or regional origin.
* Searching names by origin, gender, root version, or meaning.

Please note:
* Although the current dataset includes 1,000 different entries, the structure supports future expansion with additional names, groups, and origins.
* The current version of the database does not support free-form notes or the creation of themed or curated lists.

## Representation

Entities are captured in SQLite tables with the following schema:

### Entities
To ensure the functionality of the database, all columns are subjected to the `NOT NULL` constraint. Primary and Foreign Key relationships will be specified as needed.
Please note that IDs use the `id_entity` naming pattern.

#### Origins
* `id_origin`, which specifies the unique ID for the origin as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied.
* `origin`, which specifies the language or region of origin as `TEXT`.

#### Groups
* `id_group`, which specifies the unique ID for the group/base name as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied.
* `base_name`, which specifies the root name associated with the group as `TEXT`.
* `id_origin`, which is the ID of the origin for the root name as an `INTEGER`. This column has the `FOREIGN KEY` constraint applied, referencing the `id_origin` column in the `origins` table.
* `meaning`, which stores the meaning of the root name as `TEXT`.

#### Names List
* `id_name`, which specifies the unique ID for each name as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied.
* `name`, which stores the name as `TEXT`.
* `gender`, which is the gender corresponding to each variant of the name as `TEXT`.
* `id_origin`, which is the ID of the origin for each name variation as an `INTEGER`. This column has the `FOREIGN KEY` constraint applied, referencing the `id_origin` column in the `origins` table.
* `id_group`, which is the ID of the root name as an `INTEGER`. This column has the `FOREIGN KEY` constraint applied, referencing the `id_group` column in the `groups` table.

### Relationships

The relationships among the entities in the database is presented in the following entity relationship diagram:

![ER Diagram](diagram.png)

As detailed by the diagram:

* Each root name (`groups`) is associated with a single origin (`origins`). At the same time, an origin can be linked to one or many root names. Origins not referenced by any name are not part of the data model.
* Each name variant (`names_list`) refers to a single root name (`groups`), whereas root names may have one or more associated variants.
* Each name variant is also linked to a single origin (`origins`), while each origin can be used by one or many name variants.

## Optimizations and Supplementary Structures

### Indexes
Based on the typical queries in `queries.sql`, the following indexes were created:
* `origins` table: `id_origin` and `origin` columns
* `groups` table: `id_group` column
* `names_list` table: `id_name` and `name` columns

### Views
* `full_version` joins all three tables. This supports the most basic common use of the database, by allowing for a comprehensive view of all the data associated with each name variant.
* `names_origins` joins the `names_list` and `origins` tables.
* `groups_origins` joins the `groups` and `origins` tables.

## Sample Data
To support testing and demonstration, the project includes three .csv data containing sample data for each table:

* `names_list.csv` - contains ~1000 individual name variants, with associated origins, group, and gender.
* `groups.csv` - includes the root names referenced on `names_list.csv`, with their meanings and origins.
* `origins.csv` - lists the linguistic or regional origin for the names listed on both `names.csv` and `groups.csv`.

Additionally, an `import.txt` file is included, with all the SQLite commands needed to create the required tables and import the sample data.
Please note that it includes a command to read `schema.sql`.

## Limitations

While the database is designed to support clarity, consistency, and future expansion, a few limitations are currently in place:
* The current schema does not support free-text or user-generated content. Information about names is limited to origin and meaning.
* There is currently no support for personalized grouping of names based on custom criteria (curated lists).
* All data comes from a single reference source (20000-names.com), and may reflect inconsistencies, gaps, or inaccuracies from the original material.
