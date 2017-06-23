SELECT t1.tracker_item_id, t1.assignee
FROM tracker_item_assignee t1
INNER JOIN tracker_item t0 ON t1.tracker_item_id = t0.tracker_item_id
WHERE t0.tracker_id=677 AND t1.assignee<>100