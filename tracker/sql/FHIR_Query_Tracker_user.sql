SELECT '===' AS "*start*", t1.user_id, t1.firstname, t1.lastname, t1.email, t1.unix_name, 
 (SELECT t2.role_name 
  FROM role t2, role_setting t3, user_project_role t4, user_project t5
  WHERE t1.user_id = t5.user_id
    AND t2.role_id = t3.role_id
    AND t2.role_id = t4.role_id
    AND t4.user_project_id = t5.user_project_id
    AND t3.ref_id = 677
    AND t3.section = 'tracker') AS "role_name",
  (SELECT 'Y' 
   FROM monitor t6 
   WHERE t6.section = 'tracker'
     AND t6.ref_id = '677'
     AND t6.user_id = t1.user_id) AS "monitor"
FROM "user" t1