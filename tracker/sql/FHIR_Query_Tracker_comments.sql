SELECT '===' AS "*start*", t1.tracker_item_id, t1.adddate AS comment_date, t1.body AS comment, t1.submitted_by
FROM tracker_item t0
INNER JOIN tracker_item_message t1 ON t0.tracker_item_id=t1.tracker_item_id
WHERE t0.tracker_id=677 ORDER BY t1.tracker_item_id, t1.adddate