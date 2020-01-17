DO $$
BEGIN
INSERT INTO 
	prof_vac ("vac_num", "agr_cod", "c_client", "prof_name", "prof_cod", "price", "vacpl", "time_h", "time_w", "vtyp_cod",  "wara", "prof_add", "rem_text", "p_modi", "d_modi")
SELECT "vac_num", "agr_cod", "c_client", "prof_name", "prof_cod", "price", "vacpl", "time_h", "time_w", "vtyp_cod",  "wara", "prof_add", "rem_text", "p_modi", "d_modi"
FROM ora_prof_vac WHERE ora_prof_vac.vac_num  = '%s'
ON CONFLICT ("vac_num") DO UPDATE SET "agr_cod" = EXCLUDED.agr_cod, "c_client" = EXCLUDED.c_client, "prof_name" = EXCLUDED.prof_name, "prof_cod" = EXCLUDED.prof_cod, 
			"price" = EXCLUDED.price, "vacpl" = EXCLUDED.vacpl, "time_h" = EXCLUDED.time_h, "time_w" = EXCLUDED.time_w, "vtyp_cod" = EXCLUDED.vtyp_cod, 
			"wara" = EXCLUDED.wara, "prof_add" = EXCLUDED.prof_add, "rem_text" = EXCLUDED.rem_text, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_VAC' AND "R_TABLE"  = '%s';
END;
$$ LANGUAGE plpgsql;