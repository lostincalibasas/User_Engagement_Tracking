USE data_scientist_project;

SELECT 
  a.student_id, 
  a.minutes_watched, 
  IF(
    i.date_start IS NULL, -- Check if the student has a start date in purchases_info
    0, 
    MAX(i.paid_q2_2022) -- !!! Change to *_2021 or *_2022 depending on the year considered !!!
  ) AS paid_in_q2 
FROM 
  (
	-- Subquery to get total minutes watched by each student for a specific year
    SELECT 
      student_id, 
      
      -- Convert total seconds watched to minutes and round to 2 decimal places
      ROUND(
        SUM(seconds_watched) / 60, 
        2
      ) AS minutes_watched 
    FROM 
      student_video_watched 
    WHERE 
      YEAR(date_watched) = 2022 -- !!! Ensure consistency with paid_q2 year !!!
    GROUP BY 
      student_id
  ) a 
  LEFT JOIN purchases_info i ON a.student_id = i.student_id 
GROUP BY 
  student_id
HAVING paid_in_q2 = 0 -- !!! Change to 0 or 1 based on desired filter !!!;
