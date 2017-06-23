SELECT '===' AS "*start*", t1.tracker_item_id, t1.duplicate_of_tracker_item_id
FROM tracker_item_duplicate t1
INNER JOIN tracker_item t2 ON t1.tracker_item_id=t2.tracker_item_id
WHERE t2.tracker_id=677 