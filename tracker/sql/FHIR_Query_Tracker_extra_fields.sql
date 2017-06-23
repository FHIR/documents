SELECT DISTINCT '===' as "*start*", t1.field_name, COALESCE ((SELECT t2.field_name FROM tracker_extra_field t2 WHERE t2.tracker_id=677 AND ((TRIM(BOTH '0123456789s' FROM t2.alias)=TRIM(BOTH '0123456789s' FROM t1.field_name) 
	OR (t1.field_name='resourcename78' and TRIM(BOTH '0123456789' FROM t2.alias)='resources')
	OR (TRIM(BOTH '0123456789' FROM t1.field_name)='pagenamefromurl' and TRIM(BOTH '0123456789' FROM t2.alias)='htmlpages')
	))), TRIM(BOTH '0123456789' FROM t1.field_name)) AS new_name
FROM tracker_item t0 
INNER JOIN audit_trail t1 ON t0.tracker_item_id=t1.ref_id
WHERE t0.tracker_id=677 ORDER BY 2