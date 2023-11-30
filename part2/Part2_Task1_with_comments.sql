USE data_scientist_project;

SELECT 
    student_id,
    -- Convert total seconds watched to minutes and round to 2 decimal places
    ROUND(SUM(seconds_watched) / 60, 2) AS minutes_watched
FROM
    student_video_watched
WHERE
	-- !!! Change to 2021 or 2022 depending on the year considered !!!
    YEAR(date_watched) = 2021
-- Grouping results by each student to get aggregate minutes watched
GROUP BY student_id;