DO $$
BEGIN
INSERT INTO
	vac_fair_cl ("r", "r_fair", "c_client", "pfakt", "date_rezu", "date_rez", "p_modi", "d_modi")
SELECT "r", "r_fair", "c_client", "pfakt", "date_rezu", "date_rez", "p_modi", "d_modi"
FROM ora_vac_fair_cl WHERE ora_vac_fair_cl.r = '%s' AND ora_vac_fair_cl.c_client is not null
ON CONFLICT ("r") DO UPDATE SET "r_fair" = EXCLUDED.r_fair, "c_client" = EXCLUDED.c_client, "pfakt" = EXCLUDED.pfakt, "date_rezu" = EXCLUDED.date_rezu, 
		"date_rez" = EXCLUDED.date_rez, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR_CL' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;