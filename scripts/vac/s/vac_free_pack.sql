DO $$
BEGIN
INSERT INTO
	vac_free_pack ("pac_num", "typz", "status", "c_client", "year", "month", "add_date", "send_date", "in_date", "del_date", "emp_count", "empi_count", "start_free", 
		"fakt_free", "is_gu", "note", "isp", "isptel", "perr", "plc_cod", "pers_num", "p_modi", "d_modi")
SELECT "pac_num", "typz", "status", "c_client", "year", "month", "add_date", "send_date", "in_date", "del_date", "emp_count", "empi_count", "start_free", 
		"fakt_free", "is_gu", "note", "isp", "isptel", "perr", "plc_cod", "pers_num", "p_modi", "d_modi"
FROM ora_vac_free_pack WHERE ora_vac_free_pack.pac_num = '%s'
ON CONFLICT ("pac_num") DO UPDATE SET "typz" = EXCLUDED.typz, "status" = EXCLUDED.status, "c_client" = EXCLUDED.c_client, "year" = EXCLUDED.year, 
		"month" = EXCLUDED.month, "add_date" = EXCLUDED.add_date, "send_date" = EXCLUDED.send_date, "in_date" = EXCLUDED.in_date, "del_date" = EXCLUDED.del_date, 
		"emp_count" = EXCLUDED.emp_count, "empi_count" = EXCLUDED.empi_count, "start_free" = EXCLUDED.start_free, "fakt_free" = EXCLUDED.fakt_free, 
		"is_gu" = EXCLUDED.is_gu, "note" = EXCLUDED.note, "isp" = EXCLUDED.isp, "isptel" = EXCLUDED.isptel, "perr" = EXCLUDED.perr, "plc_cod" = EXCLUDED.plc_cod, 
		"pers_num" = EXCLUDED.pers_num, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FREE_PACK' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;