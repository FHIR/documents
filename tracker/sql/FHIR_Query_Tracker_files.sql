SELECT '===' AS "*start*", t2.tracker_item_id, t1.filesystem_id, t1.file_name_safe AS "file_name", t1.posted_by,
  (SELECT MAX(t4.open_date) FROM filesystem t3, tracker_item t4
  WHERE t3.ref_id = t4.tracker_item_id
    AND t3.section='trackeritem'
    AND t3.filesystem_id <= t1.filesystem_id) AS "created"
FROM filesystem t1, tracker_item t2
WHERE t1.ref_id = t2.tracker_item_id
  AND t1.section='trackeritem'
  AND t2.tracker_id=677
ORDER BY t1.filesystem_id ASC