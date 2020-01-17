DO $$
BEGIN
INSERT INTO
	vac_kvot_doc ("r", "pac_num", "kv_rm", "typdoc", "notedoc", "p_modi", "d_modi")
SELECT "r", "pac_num", "kv_rm", "typdoc", "notedoc", "p_modi", "d_modi"
FROM ora_vac_kvot_doc WHERE ora_vac_kvot_doc.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "pac_num" = EXCLUDED.pac_num, "kv_rm" = EXCLUDED.kv_rm, "typdoc" = EXCLUDED.typdoc, "notedoc" = EXCLUDED.notedoc, 
		"p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT_DOC' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;