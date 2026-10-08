-- =====================================================================
-- Learning SQL, Ch 4 — Filtering
-- Practice queries against data/market_listings.db (table: listings)
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Equality / inequality
-- Companies whose last price is not exactly 50.
-- ---------------------------------------------------------------------
SELECT * FROM listings WHERE last_price <> 50;

-- `<>` is "not equal." `!=` also works in SQLite, but `<>` is the
-- standard SQL operator and the one to default to.


-- ---------------------------------------------------------------------
-- 2. Date comparison
-- Companies that IPO'd after Jan 1, 2020.
-- ---------------------------------------------------------------------
SELECT * FROM listings WHERE ipo_date > '2020-01-01';

-- SQLite has no real date type -- ipo_date is stored as text, so this
-- is a plain string comparison. It only gives the right answer because
-- the dates are stored ISO-8601 (YYYY-MM-DD), which happens to sort in
-- chronological order. A stray leading space inside the literal
-- (' 2020-01-01') silently matches every row instead of erroring --
-- caught this myself by comparing row counts.


-- ---------------------------------------------------------------------
-- 3. BETWEEN, numeric and date
-- Companies priced 20-50, and companies that IPO'd in a specific window.
-- ---------------------------------------------------------------------
SELECT * FROM listings WHERE last_price BETWEEN 20 AND 50;

SELECT company_name, ipo_date FROM listings
WHERE ipo_date BETWEEN '2005-06-04' AND '2007-06-16';

-- Inclusive on both ends. Low value must come first, or BETWEEN
-- silently returns zero rows.


-- ---------------------------------------------------------------------
-- 4. IN / NOT IN, and the NULL trap
-- Companies listed on NYSE or LSE, and the reverse.
-- ---------------------------------------------------------------------
SELECT COUNT(*) FROM listings WHERE exchange IN ('NYSE', 'LSE');       -- 60
SELECT COUNT(*) FROM listings WHERE exchange NOT IN ('NYSE', 'LSE');   -- 98

-- 60 + 98 = 158, not 180. The missing 22 rows have exchange = NULL.
-- NULL can't be judged "in" or "not in" a set -- it's unknown, so it
-- fails both checks and disappears from both results with no error.
-- To include it on purpose:
SELECT * FROM listings
WHERE exchange NOT IN ('NYSE', 'LSE') OR exchange IS NULL;             -- 120


-- ---------------------------------------------------------------------
-- 5. LIKE and wildcards
-- Company names starting with S, containing "Tech", and by ticker length.
-- ---------------------------------------------------------------------
SELECT * FROM listings WHERE company_name LIKE 'S%';
SELECT * FROM listings WHERE company_name LIKE '%Tech%';
SELECT * FROM listings WHERE ticker LIKE '__';    -- exactly 2 characters

-- `%` matches any number of characters, including zero.
-- `_` matches exactly one character. `LIKE '__'` only matches
-- 2-character tickers -- different from `%`, which has no length limit.


-- ---------------------------------------------------------------------
-- 6. NULL semantics
-- Companies with no recorded dividend yield.
-- ---------------------------------------------------------------------
SELECT company_name, dividend_yield FROM listings WHERE dividend_yield IS NULL;

-- `= NULL` never works, for any column, ever -- an expression can BE
-- NULL, but it can never be judged EQUAL to NULL, because NULL means
-- "unknown," and an unknown value can't be compared to anything,
-- including another unknown. That's why IS NULL / IS NOT NULL exist
-- as separate operators instead of just using `=`.
--
-- Confirmed this same "NULL breaks comparisons" rule independently
-- across every operator in this chapter: <, IN, NOT IN, and LIKE all
-- silently drop NULL rows from their results. None of them error.


-- ---------------------------------------------------------------------
-- 7. Compound conditions: AND / OR / NOT, and why parentheses matter
-- ---------------------------------------------------------------------
SELECT * FROM listings
WHERE (company_name = 'Redstone Freight Corp' OR sector = 'Communication Services')
  AND ipo_date > '2024-07-01';

-- AND binds tighter than OR. Without the parentheses, SQL reads this as
--   company_name = 'X' OR (sector = 'Y' AND ipo_date > 'Z')
-- which lets a company match on name alone, skipping the date filter
-- entirely -- even if its IPO was decades ago. Confirmed this by
-- running both versions against a pre-2024 company and watching it
-- appear in the un-parenthesized result.
