DO $$
BEGIN
INSERT INTO
	sl_dgv ("rpu_code", "dgv_code", "dgv_name", "dop", "gr", "rc", "rd1", "ro1", "p_modi", "d_modi")
SELECT "rpu_code", "dgv_code", "dgv_name", "dop", "gr", "rc", "rd1", "ro1", "p_modi", "d_modi"
FROM ora_sl_dgv WHERE ora_sl_dgv.rpu_code  = '%s'
ON CONFLICT ("rpu_code") DO UPDATE SET "dgv_code" = EXCLUDED.dgv_code, "dgv_name" = EXCLUDED.dgv_name, "dop" = EXCLUDED.dop, "gr" = EXCLUDED.gr, "rc" = EXCLUDED.rc, 
		"rd1" = EXCLUDED.rd1, "ro1" = EXCLUDED.ro1, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_DVG' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;