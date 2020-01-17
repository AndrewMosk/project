DO $$
BEGIN
INSERT INTO
	vac_kvot_confirm ("r", "pac_num", "kv_rm", "title", "docdate", "docnumber", "p_modi", "d_modi")
SELECT "r", "pac_num", "kv_rm", "title", "docdate", "docnumber", "p_modi", "d_modi"
FROM ora_vac_kvot_confirm WHERE ora_vac_kvot_confirm.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "pac_num" = EXCLUDED.pac_num, "kv_rm" = EXCLUDED.kv_rm, "title" = EXCLUDED.title, "docdate" = EXCLUDED.docdate, 
		"docnumber" = EXCLUDED.docnumber, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT_CONFIRM' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;