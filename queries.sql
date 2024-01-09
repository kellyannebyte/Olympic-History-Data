-- TODO: write the task number and description followed by the query

-- Task 1: Find the names of all athletes who have won at least one gold medal.
CREATE VIEW medal_winners AS
SELECT ae.*, nr.region
FROM athlete_events ae
JOIN noc_regions nr
ON ae.noc = nr.noc
WHERE ae.medal IS NOT NULL;

-- Task 2: Show the top 3 ranked regions for each fencing 🤺 event based on the number of total gold medals 🥇 that region had for that fencing event:
SELECT COALESCE(nr.region, CASE WHEN ae.noc = 'SGP' THEN 'Singapore' ELSE ae.team END) AS region,
ae.event,
COUNT() AS gold_medals,
ROW_NUMBER() OVER (PARTITION BY ae.event ORDER BY COUNT() DESC) AS rank
FROM athlete_event ae
LEFT JOIN noc_region nr ON ae.noc = nr.noc
WHERE ae.medal = 'Gold' AND ae.sport = 'Fencing'
GROUP BY ae.event, region
HAVING COUNT(*) > 0
ORDER BY ae.event, rank
LIMIT 3 OFFSET 3;

-- Task 3: Show the rolling sum of medals per region, per year, and per medal type.
SELECT COALESCE(nr.region, CASE WHEN ae.noc = 'SGP' THEN 'Singapore' ELSE ae.team END) AS region,
ae.year,
ae.medal,
SUM() OVER (PARTITION BY COALESCE(nr.region, CASE WHEN ae.noc = 'SGP' THEN 'Singapore' ELSE ae.team END), ae.year ORDER BY ae.medal) AS rolling_sum
FROM athlete_event ae
LEFT JOIN noc_region nr ON ae.noc = nr.noc
WHERE ae.medal IS NOT NULL
ORDER BY region, year, medal;

-- Task 4: Show the height of every gold medalist for pole valut events, along with the height of the gold medalist for that same pole value event in the previous year.
SELECT ae1.event, ae1.year, ae1.height, LAG(ae1.height) OVER (PARTITION BY ae1.event ORDER BY ae1.year) AS previous_height
FROM athlete_events ae1
WHERE ae1.medal = 'Gold' AND ae1.event LIKE '%Pole Vault%'
ORDER BY ae1.event, ae1.year ASC;
