CREATE DATABASE IF NOT EXISTS taxis;
USE taxis;

CREATE EXTERNAL TABLE IF NOT EXISTS taxi_descriptions
(
  id INT,
  borough STRING,
  zone STRING,
  service_zone STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '${hiveconf:input_dir4}'
TBLPROPERTIES ('skip.header.line.count'='1');


CREATE EXTERNAL TABLE IF NOT EXISTS customers_by_month (
  month STRING,
  location_id INT,
  total_passangers INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '${hiveconf:input_dir3}';

WITH top_boroughs AS (
  SELECT 
    c.month,
    t.borough,
    SUM(c.total_passangers) AS passengers,
    ROW_NUMBER() OVER (PARTITION BY c.month ORDER BY SUM(c.total_passangers) DESC) AS rn
  FROM customers_by_month c
  JOIN taxi_descriptions t
    ON c.location_id = t.id
  GROUP BY c.month, t.borough
),
top3 AS (
  SELECT month, borough, passengers
  FROM top_boroughs
  WHERE rn <= 3
),
json_data AS (
  SELECT CONCAT(
           '{',
           '\"month\":\"', month, '\", ',
           '\"borough\":\"', borough, '\", ',
           '\"passengers\":', passengers,
           '}'
         ) AS json_item
  FROM top3
)
INSERT OVERWRITE DIRECTORY '${hiveconf:output_dir6}'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\n'
SELECT CONCAT('[', concat_ws(',', collect_list(json_item)), ']') AS result_json
FROM json_data;