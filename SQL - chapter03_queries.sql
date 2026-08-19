-- =====================================================================
-- Learning SQL, Ch 3 — Query Primer
-- Practice queries against data/space_explorers.db
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Multi-column sort
-- Every explorer's name, homeworld and height. Homeworld A-Z, and
-- within each homeworld the tallest first.
-- ---------------------------------------------------------------------
SELECT name, homeworld, height_cm
FROM explorers
ORDER BY homeworld, height_cm DESC;

-- Note: a second sort column goes after a comma, not in a new clause.
-- DESC binds to the column immediately before it, so homeworld stays
-- ascending here while height descends.


-- ---------------------------------------------------------------------
-- 2. WHERE and ORDER BY together, tie-breaking
-- Explorers from Nyx, by rank A-Z, ties broken by name A-Z.
-- ---------------------------------------------------------------------
SELECT name, rank, missions
FROM explorers
WHERE homeworld = 'Nyx'
ORDER BY rank, name;

-- Nyx has 9 Cadets. Without the second sort column their order is
-- arbitrary; `name` breaks the tie.


-- ---------------------------------------------------------------------
-- 3. Compound condition, mixed sort directions
-- Humans with more than 5 missions, most missions first, ties by name.
-- ---------------------------------------------------------------------
SELECT name, species, missions
FROM explorers
WHERE species = 'Human' AND missions > 5
ORDER BY missions DESC, name;

-- "more than 5" is > 5, not >= 5. The >= version returns 28 rows
-- instead of 20 — it quietly includes the 8 people with exactly 5.


-- ---------------------------------------------------------------------
-- 4. BETWEEN
-- Explorers weighing 60-80 kg, homeworld A-Z, heaviest first.
-- ---------------------------------------------------------------------
SELECT name, homeworld, weight_kg
FROM explorers
WHERE weight_kg BETWEEN 60 AND 80
ORDER BY homeworld, weight_kg DESC;

-- BETWEEN includes both endpoints. Equivalent long form:
--   WHERE weight_kg >= 60 AND weight_kg <= 80
-- Each condition needs the column named again; `>= 60 <= 80` is invalid.


-- ---------------------------------------------------------------------
-- 5. Column aliases
-- Titan Outpost crew, renamed columns, heaviest first.
-- ---------------------------------------------------------------------
SELECT name AS explorer_name, weight_kg AS weight
FROM explorers
WHERE homeworld = 'Titan Outpost'
ORDER BY weight DESC;

-- ORDER BY can reference the alias, because it runs after SELECT has
-- renamed things. Returns 25 rows, Quinn Dael (105.2) first.


-- ---------------------------------------------------------------------
-- 6. Sorting by numeric placeholder
-- Species and homeworld for explorers with more than 10 missions,
-- sorted by the second column in the SELECT list.
-- ---------------------------------------------------------------------
SELECT species, homeworld
FROM explorers
WHERE missions > 10
ORDER BY 2;

-- Fragile: adding a column to the SELECT list silently changes what
-- `2` refers to. Fine ad hoc, avoided in saved code.


-- ---------------------------------------------------------------------
-- 7. DISTINCT across multiple columns
-- Unique species/homeworld combinations among explorers with 0 missions.
-- ---------------------------------------------------------------------
SELECT DISTINCT species, homeworld
FROM explorers
WHERE missions = 0
ORDER BY species, homeworld;

-- DISTINCT applies to the whole row, not to one column: 23 rows collapse
-- to 16 unique pairs. 'Human' still appears 7 times, once per homeworld.
