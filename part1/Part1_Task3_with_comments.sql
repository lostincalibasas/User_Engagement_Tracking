USE data_scientist_project;

-- Drop the view 'purchases_info' if it already exists in the database
DROP VIEW IF EXISTS purchases_info;

-- Creating a new view named 'purchases_info'
CREATE VIEW purchases_info AS
SELECT
	*,
    -- Flag to indicate if the subscription was active during Q2 2021
    CASE 
		WHEN date_end < '2021-04-01' THEN 0 
		WHEN date_start > '2021-06-30' THEN 0 
		ELSE 1 
	END AS paid_q2_2021,
    -- Flag to indicate if the subscription was active during Q2 2022
	CASE 
		WHEN date_end < '2022-04-01' THEN 0 
		WHEN date_start > '2022-06-30' THEN 0 
		ELSE 1 
	END AS paid_q2_2022
FROM
(  -- Subquery begins
	SELECT 
		purchase_id,
		student_id,
		plan_id,
		date_start,
		IF(date_refunded IS NULL,  -- IF-ELSE construct to check if 'date_refunded' is NULL
			date_end,  -- If 'date_refunded' is NULL, then take 'date_end' as 'date_end'
			date_refunded) AS date_end  -- If 'date_refunded' is not NULL, then take 'date_refunded' as 'date_end'
	FROM
		(  -- Subquery begins
			SELECT 
				purchase_id,
				student_id,
				plan_id,
				date_purchased AS date_start,
				CASE  -- Start of CASE statement to handle different subscription plan durations
					WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)  -- If 'plan_id' is 0 (monthly subscription), then add one month to 'date_purchased' to calculate 'date_end'
					WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)  -- If 'plan_id' is 1 (quarterly subscription), then add three months to 'date_purchased' to calculate 'date_end'
					WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 12 MONTH)  -- If 'plan_id' is 2 (annual subscription), then add twelve months to 'date_purchased' to calculate 'date_end'
					WHEN plan_id = 3 THEN CURDATE()  -- If 'plan_id' is 3 (lifetime subscription), then 'date_end' is the current date
				END AS date_end,  -- End of CASE statement. The resulting column is aliased as 'date_end'
				date_refunded
		FROM
			student_purchases
		) a   -- Subquery ends and the result is aliased as 'a'
) b;   -- Subquery ends and the result is aliased as 'b'
