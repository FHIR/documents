SELECT '===' AS "*start*", t1.element_id, t1.tracker_extra_field_id, t1.element_name
FROM tracker_extra_field_element t1 INNER JOIN tracker_extra_field t2 ON t1.tracker_extra_field_id = t2.tracker_extra_field_id 
WHERE t2.tracker_id=677
UNION
SELECT '===' AS "*start*", t3.frs_release_id, 3632, t3.release_name
FROM frs_release t3
WHERE t3.frs_package_id=236