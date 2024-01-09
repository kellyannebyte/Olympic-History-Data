-- TODO: use explain / analyze, create an index

-- 1. Drop an index if it exists
DROP INDEX IF EXISTS athlete_event_name_idx;

-- 2. Write a query to find all rows that contain the athlete "Michael Fred Phelps, II"
SELECT *
FROM athlete_event
WHERE name = 'Michael Fred Phelps, II';

-- 3. Using EXPLAIN ANALYZE, run the query and record the execution time
EXPLAIN ANALYZE
SELECT *
FROM athlete_event
WHERE name = 'Michael Fred Phelps, II';

-- Output:
-- Seq Scan on athlete_event (cost=0.00..7035.50 rows=1 width=133) (actual time=0.118..17.541 rows=30 loops=1)
-- Filter: ((name)::text = 'Michael Fred Phelps, II'::text)
-- Rows Removed by Filter: 271114
-- Planning Time: 0.091 ms
-- Execution Time: 17.581 ms

-- 4. Write a query to add an index to the name column of the athlete_event table
CREATE INDEX athlete_event_name_idx ON athlete_event (name);

-- 5. Verifying improved performance by repeating EXPLAIN ANALYZE query from 3
EXPLAIN ANALYZE
SELECT *
FROM athlete_event
WHERE name = "Michael Fred Phelps, II";

-- Output:
-- Index Scan using athlete_event_name_idx on athlete_event (cost=0.42..16.42 rows=3 width=133) (actual time=0.036..0.057 rows=30 loops=1)
-- Index Cond: ((name)::text = 'Michael Fred Phelps, II'::text)
-- Planning Time: 0.091 ms
-- Execution Time: 0.128 ms

-- 6. Ignoring an index, write a query using the name column in the where clause
EXPLAIN ANALYZE
SELECT *
FROM athlete_event
WHERE name LIKE '%Phelps%';