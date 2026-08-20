# Python Crash Course, Ch 4 — Working with Lists

Notes and practice from working through the chapter, plus a mini project applying
all of it to a price series.

## What the chapter covers

Looping through a list, `range()`, building lists from `range()`, simple statistics
(`min`, `max`, `sum`), list comprehensions, slicing, looping through a slice,
copying a list, and tuples.

## Things worth remembering

**A `for` loop reads one item at a time.** The loop variable is singular, the list
is plural — `for magician in magicians`. Everything indented under the `for` runs
once per item; anything unindented runs once, after the loop finishes.

**`range()` stops before the end value.** `range(1, 5)` gives 1, 2, 3, 4 — not 5.
A third argument is the step: `range(3, 17, 3)` gives 3, 6, 9, 12, 15.

**`range()` is not a list.** Wrap it in `list()` if you want an actual list:
`list(range(1, 7))`.

**List comprehensions collapse the build-a-list loop into one line.**

```python
squares = []                        # four lines
for value in range(1, 11):
    squares.append(value**2)

squares = [value**2 for value in range(1, 11)]   # one line, same result
```

**Slicing** — `players[0:3]` starts at index 0 and stops *before* index 3. Omit the
start to begin at the beginning, omit the end to run to the end. A negative start
counts from the end: `players[-3:]` is the last three.

**Copying a list needs a slice.** `friend_foods = my_foods[:]` makes an independent
copy. Plain assignment (`friend_foods = my_foods`) would point both names at the
*same* list, so appending to one would change both.

**Tuples are lists that can't be changed** — parentheses instead of brackets. You
can't modify an element, but you can reassign the whole variable to a new tuple.
Looping through one works exactly like a list.

## Practice

Ten exercises, themed around tickers and prices: looping, `range()` with a step,
`min`/`max`/`sum`, a list comprehension, slicing the middle of a list, an
independent copy, and tuple creation / looping / reassignment.

## Mini project — price series summary

Given ten days of closing prices:

1. Print each day's price as `Day 1: $182.52`
2. Slice out the most recent five days into `recent_week`
3. Print the min, max, and average of that window
4. Store the ticker and the window's max as a tuple, `best_day`

```python
prices = [182.52, 179.80, 191.20, 175.10, 188.90,
          190.15, 186.40, 193.75, 189.20, 195.60]

for i in range(len(prices)):
    price = prices[i]
    day_number = i + 1
    print(f"Day {day_number}: ${price} ")

recent_week = prices[5:]

print(min(recent_week))
print(max(recent_week))
print(sum(recent_week) / len(recent_week))

best_day = ('AAPL', max(recent_week))
```

Output is correct: min 186.40, max 195.60, average 191.02.

## What I'd do differently

**Format money to two decimal places.** The output drops trailing zeros, so prices
render inconsistently — `$179.8` next to `$182.52`. Currency should always show two:

```python
print(f"Day {day_number}: ${price:.2f}")
```

**Use `enumerate()` instead of `range(len(...))`.** The goal was the index and the
value together, which is exactly what `enumerate` is for. It also removes the manual
`i + 1`:

```python
for day, price in enumerate(prices, start=1):
    print(f"Day {day}: ${price:.2f}")
```

**Use `prices[-5:]`, not `prices[5:]`, for "the last five."** Both return the same
five items from a ten-item list, but only by coincidence. `[5:]` means "from index 5
onward" — add an eleventh day and it silently returns six items. `[-5:]` means "the
last five" regardless of length.

That last one is the pattern worth watching for: code that is correct for the
current data rather than correct for the intent. It doesn't error, it just quietly
returns something different once the inputs change.

## Where this is going

This mini project is the analysis layer of my north-star project in miniature: take
a price series, slice a window, compute summary statistics over it.

Scaling it up means replacing the hardcoded list with data pulled from an API and
stored in SQL, and replacing the single window with a rolling one — which turns
`min`/`max`/`average` into daily returns and rolling volatility. Same shape, real
data.

## Next

Python Crash Course Ch 5 — `if` statements.
