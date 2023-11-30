USE data_scientist_project;

--  Calculating the number of students who watched a lecture in Q2 2021
SELECT 
    COUNT(DISTINCT student_id)
FROM
    student_video_watched
WHERE
    YEAR(date_watched) = 2021;
    
    
    
-- Calculating the number of students who watched a lecture in Q2 2022
SELECT 
    COUNT(DISTINCT student_id)
FROM
    student_video_watched
WHERE
    YEAR(date_watched) = 2022;
    
    
    
-- Calculating the number of students who watched a lecture in Q2 2021 and Q2 2022
SELECT 
    COUNT(DISTINCT student_id)
FROM
    (
    -- Subquery to get unique students who watched lectures in 2021
    SELECT DISTINCT
        student_id
    FROM
        student_video_watched
    WHERE
        YEAR(date_watched) = 2021) a -- Alias for the subquery results for 2021
	-- Join with another subquery to get students who also watched videos in 2022
	JOIN 
    (
    -- Subquery to get unique students who watched videos in 2022
    SELECT DISTINCT
        student_id
    FROM
        student_video_watched
    WHERE
        YEAR(date_watched) = 2022) b -- Alias for the subquery results for 2022
	-- Specify the common column (student_id) for joining the results of the two subqueries
	USING(student_id);
    
    
        
-- Calculating the total number of students who watched a lecture
SELECT 
    COUNT(DISTINCT student_id)
FROM
    student_video_watched;