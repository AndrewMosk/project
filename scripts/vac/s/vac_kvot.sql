DO $$
BEGIN
INSERT INTO
	vac_kvot ("pac_num", "typz", "c_client", "year", "month", "add_date", "send_date", "in_date", "note", "del_date", "emp_count", "empv_count", "kv_proc", 
		"empr_count", "kv_ras", "kv_rm", "kv_rmo", "kv_rm1", "kv_rm2", "kv_n", "kv_n1", "kv_n2", "kv_n3", "kv_p", "kv_p1", "kv_p2", "kv_p3", "kv_u", "kv_u1", "kv_u2", 
		"kv_u3", "kv_z", "kv_z1", "kv_z2", "kv_z3", "kv_zy", "kv_s", "kv_s1", "kv_s2", "kv_s3", "kv_free", "kv_1", "kv_2", "kv_vac", "status", "perr", "dolok", "fiook",
		"druk", "dok", "isp", "isptel", "noterez", "noteerr", "plc_cod", "p_modi", "d_modi")
SELECT "pac_num", "typz", "c_client", "year", "month", "add_date", "send_date", "in_date", "note", "del_date", "emp_count", "empv_count", "kv_proc", 
		"empr_count", "kv_ras", "kv_rm", "kv_rmo", "kv_rm1", "kv_rm2", "kv_n", "kv_n1", "kv_n2", "kv_n3", "kv_p", "kv_p1", "kv_p2", "kv_p3", "kv_u", "kv_u1", "kv_u2", 
		"kv_u3", "kv_z", "kv_z1", "kv_z2", "kv_z3", "kv_zy", "kv_s", "kv_s1", "kv_s2", "kv_s3", "kv_free", "kv_1", "kv_2", "kv_vac", "status", "perr", "dolok", "fiook",
		"druk", "dok", "isp", "isptel", "noterez", "noteerr", "plc_cod", "p_modi", "d_modi"
FROM ora_vac_kvot WHERE ora_vac_kvot.pac_num = '%s'
ON CONFLICT ("pac_num") DO UPDATE SET "typz" = EXCLUDED.typz,"c_client" = EXCLUDED.c_client,"year" = EXCLUDED.year,"month" = EXCLUDED.month,"add_date" = EXCLUDED.add_date, 
		"send_date" = EXCLUDED.send_date, "in_date" = EXCLUDED.in_date, "note" = EXCLUDED.note, "del_date" = EXCLUDED.del_date, "emp_count" = EXCLUDED.emp_count, 
		"empv_count" = EXCLUDED.empv_count, "kv_proc" = EXCLUDED.kv_proc, "empr_count" = EXCLUDED.empr_count, "kv_ras" = EXCLUDED.kv_ras, "kv_rm" = EXCLUDED.kv_rm, 
		"kv_rmo" = EXCLUDED.kv_rmo, "kv_rm1" = EXCLUDED.kv_rm1, "kv_rm2" = EXCLUDED.kv_rm2, "kv_n" = EXCLUDED.kv_n, "kv_n1" = EXCLUDED.kv_n1, "kv_n2" = EXCLUDED.kv_n2, 
		"kv_n3" = EXCLUDED.kv_n3, "kv_p" = EXCLUDED.kv_p, "kv_p1" = EXCLUDED.kv_p1, "kv_p2" = EXCLUDED.kv_p2, "kv_p3" = EXCLUDED.kv_p3, "kv_u" = EXCLUDED.kv_u, 
		"kv_u1" = EXCLUDED.kv_u1, "kv_u2" = EXCLUDED.kv_u2, "kv_u3" = EXCLUDED.kv_u3, "kv_z" = EXCLUDED.kv_z, "kv_z1" = EXCLUDED.kv_z1, "kv_z2" = EXCLUDED.kv_z2, 
		"kv_z3" = EXCLUDED.kv_z3, "kv_zy" = EXCLUDED.kv_zy, "kv_s" = EXCLUDED.kv_s, "kv_s1" = EXCLUDED.kv_s1, "kv_s2" = EXCLUDED.kv_s2, "kv_s3" = EXCLUDED.kv_s3, 
		"kv_free" = EXCLUDED.kv_free, "kv_1" = EXCLUDED.kv_1, "kv_2" = EXCLUDED.kv_2, "kv_vac" = EXCLUDED.kv_vac, "status" = EXCLUDED.status, "perr" = EXCLUDED.perr, 
		"dolok" = EXCLUDED.dolok, "fiook" = EXCLUDED.fiook, "druk" = EXCLUDED.druk, "dok" = EXCLUDED.dok, "isp" = EXCLUDED.isp, "isptel" = EXCLUDED.isptel, 
		"noterez" = EXCLUDED.noterez, "noteerr" = EXCLUDED.noteerr, "plc_cod" = EXCLUDED.plc_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_KVOT' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;