# Chapter 4 — Filtering

## What the chapter covers

Condition evaluation, parentheses, the NOT operator, condition types (equality,
inequality, range conditions, BETWEEN, string ranges), membership conditions (IN,
subqueries, NOT IN), matching conditions (LIKE, wildcards, regular expressions), and NULL.

Thirteen named topics, but they collapse into five real ideas: compare a column to a
value, a range, a set, a pattern, or check whether it's missing. Everything else is
just how those five get combined with AND / OR / NOT.

## Things worth remembering

**`<>` is "not equal."** Standard SQL. `!=` also works in SQLite but `<>` is the one
to default to.

**Parentheses control which condition groups apply to which.** `AND` binds tighter
than `OR`, so `WHERE a = 'x' OR b = 'y' AND c > 'z'` is read as
`a = 'x' OR (b = 'y' AND c > 'z')` -- the `c > 'z'` filter only applies to the second
branch. If the intent was "(a or b) and c," it needs explicit parentheses:
`WHERE (a = 'x' OR b = 'y') AND c > 'z'`.

**BETWEEN is inclusive on both ends**, and works on numbers, dates, and strings --
though string ranges are worth extra care (see below). The low value has to come
first; a reversed range (`BETWEEN 50 AND 20`) silently returns nothing, no error.

**String ranges don't mean what they look like they mean.** `company_name BETWEEN 'A'
AND 'C'` looks like "starts with A, B, or C." It isn't -- it's every string that sorts
between the literal characters "A" and "C". Since "Caldwell" sorts *after* "C" (it has
more characters), every company starting with C gets excluded. To actually catch every
C-name, the range needs to be `BETWEEN 'A' AND 'D'` -- which then also (harmlessly)
includes anything named exactly "D".

**IN and NOT IN take a comma-separated list in parentheses.** `WHERE col IN (a, b, c)`
matches any of them; `NOT IN` matches none. Multiple values are never separated by
doubling up quotes inside one string -- `'A''B'` is a single string containing an
escaped apostrophe, not two values.

**LIKE with wildcards:** `%` matches any number of characters, including zero.
`_` matches exactly one character. `'A%'` matches any length starting with A;
`'A_'` matches exactly two characters starting with A.

**NULL breaks every comparison operator, not just `=`.** An expression can *be* NULL,
but it can never be judged *equal* to NULL -- NULL means "unknown," and an unknown
value can't be compared to anything, including another unknown. That's why `IS NULL`
/ `IS NOT NULL` exist as their own operators.

The part that isn't obvious until you see it: this isn't a special case of `=`. Every
comparison operator -- `<`, `>`, `IN`, `NOT IN`, `LIKE` -- returns neither true nor
false when either side is NULL. The row just silently disappears from the result.
No error, no warning.

**`WHERE column IS NULL` only checks that one column**, not "does this row have a
NULL anywhere." Different columns being NULL means different things -- an unclassified
sector isn't the same situation as a still-trading company with no delisted date --
so SQL makes checking column-by-column the default, not an accident.

## Mistakes I made, and what actually caused them

| Mistake | Cause |
|---|---|
| `WHERE last_price IS <> 50` | Tried to combine `IS` and `<>`, two different ways of saying "not equal," into one. They don't stack -- `<>` alone is the whole answer. |
| `WHERE ipo_date > ' 2020-01-01'` returned all 180 rows instead of 24 | A leading space inside the string literal. Sorts before every real date, so the comparison came out true for everything. No error -- caught it by noticing the row count was suspiciously round. |
| `company_name = 'X''Y'` to try to match two names at once | Doubled single quotes inside a string literal escape to a single apostrophe, not a separator. Produced one garbled name, matched nothing. `IN ('X', 'Y')` is the actual way to check multiple values. |
| `WHERE ipo_date > 2024-01-02` (no quotes) | Without quotes, that's arithmetic: `2024 - 1 - 2 = 2021`. SQLite then compared the text dates against the number 2021 rather than a real date, which happened to behave roughly like a year filter -- close enough to look right, wrong enough to matter. |
| `LEFT(company_name, 1)`, `year(ipo_date)` | Both are MySQL functions. This book teaches MySQL; I'm running SQLite in DBeaver. Neither function exists in SQLite -- `SUBSTR(col, start, length)` and `strftime('%Y', col)` are the equivalents. |
| Wrote `DELETE FROM listings WHERE ...` before checking what it would remove | Caught before running it -- would have deleted 175 of 180 rows. `DELETE` has no undo. Now I write it as a `SELECT` first, confirm the row count is what I expect, and only then swap in `DELETE`. |

**The pattern across all of these:** almost none of them errored. SQL is permissive --
a quoting mistake, an unquoted date, a missing parenthesis all produce a clean-looking
result with a plausible row count. The dangerous version of a bug isn't the one that
crashes; it's the one that returns a number that looks fine.

## The habit this chapter earned

Before trusting a query's output: check if the row count is suspiciously round (all
rows, zero rows, exactly half), and if a comparison involves a column that can be
NULL, ask whether those rows are silently missing from the result. Both checks take
about ten seconds and would have caught every mistake in the table above before I ran
the query for real.

## Next

Chapter 5 -- Querying Multiple Tables (joins).
