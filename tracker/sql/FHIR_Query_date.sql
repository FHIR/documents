SELECT '===' AS "*start*", max(t1.change_date) AS last_date
FROM tracker_item t0 
INNER JOIN audit_trail t1 ON t0.tracker_item_id=t1.ref_id
WHERE t0.tracker_id=677