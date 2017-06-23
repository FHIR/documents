SELECT '===' AS "*start*", t1.tracker_item_id, t1.priority, t1.open_date, t1.close_date, T1.summary, t1.details, t1.submitted_by, t1.last_modified_date, t1.last_modified_by
FROM tracker_item t1 
WHERE t1.tracker_id=677 ORDER BY t1.tracker_item_id