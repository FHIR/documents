SELECT '===' AS "*start*", t1.ref_id AS tracker_item_id, t1.change_date, t1.field_name, t1.old_value, t1.new_value, t1.user_id
FROM tracker_item t0 
INNER JOIN audit_trail t1 ON t0.tracker_item_id=t1.ref_id
WHERE t0.tracker_id=677 ORDER BY t1.ref_id, t1.change_date