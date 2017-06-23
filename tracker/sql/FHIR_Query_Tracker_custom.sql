SELECT '===' AS "*start*", t1.tracker_item_id, t2.field_name, t2.field_type, t1.tracker_extra_field_id, CAST (t1.field_data AS text) AS field_data
FROM tracker_item t0 
INNER JOIN tracker_extra_field_data t1 ON t0.tracker_item_id=t1.tracker_item_id 
INNER JOIN tracker_extra_field t2 ON t1.tracker_extra_field_id=t2.tracker_extra_field_id
WHERE t0.tracker_id=677 ORDER BY t1.tracker_item_id, t2.field_order