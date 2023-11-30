USE data_scientist_project;

SELECT 
    a.student_id,
    -- Calculate minutes watched; use 0 if seconds_watched is NULL (not present in the student_video_watched table)
    IF(w.seconds_watched IS NULL,
        0,
        ROUND(SUM(seconds_watched) / 60, 2)) AS minutes_watched,
    a.certificates_issued
FROM
    (
    -- Sub-query to get the number of certificates issued per student.
    SELECT 
        student_id, 
        COUNT(certificate_id) AS certificates_issued
    FROM
        student_certificates
    GROUP BY student_id) a
        LEFT JOIN -- Join on the student_id column, ensuring all students from 'a' are included.
    student_video_watched w ON a.student_id = w.student_id
GROUP BY student_id;