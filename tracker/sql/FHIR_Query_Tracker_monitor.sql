SELECT '===' AS "*start*", t2.tracker_item_id, t1.user_id FROM monitor t1, tracker_item t2
WHERE t1.section = 'trackeritem'
  AND t1.ref_id = t2.tracker_item_id
  AND t2.tracker_id = 677
ORDER BY 1,2