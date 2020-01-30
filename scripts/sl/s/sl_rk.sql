DO $$
BEGIN
INSERT INTO
	sl_rk ("rk_cod", "npp", "rk_name", "rk_reg", "rk_srok", "p_uv", "rk_priz", "nu_cod", "proc_cod", "comm", "bak", "pr", "rk_named", "prim", "rk_code", "docfile", 
		"gud_cod", "repfile", "rk_typ", "pr_typ", "rk_eais", "lmszid", "categoryid", "p_modi", "d_modi")
SELECT "rk_cod", "npp", "rk_name", "rk_reg", "rk_srok", "p_uv", "rk_priz", "nu_cod", "proc_cod", "comm", "bak", "pr", "rk_named", "prim", "rk_code", "docfile", 
		"gud_cod", "repfile", "rk_typ", "pr_typ", "rk_eais", "lmszid", "categoryid", "p_modi", "d_modi"
FROM ora_sl_rk WHERE ora_sl_rk.rk_cod = '%s'
ON CONFLICT ("rk_cod") DO UPDATE SET "npp" = EXCLUDED.npp, "rk_name" = EXCLUDED.rk_name, "rk_reg" = EXCLUDED.rk_reg, "rk_srok" = EXCLUDED.rk_srok, "p_uv" = EXCLUDED.p_uv, 
		"rk_priz" = EXCLUDED.rk_priz, "nu_cod" = EXCLUDED.nu_cod, "proc_cod" = EXCLUDED.proc_cod, "comm" = EXCLUDED.comm, "bak" = EXCLUDED.bak, 
		"pr" = EXCLUDED.pr, "rk_named" = EXCLUDED.rk_named, "prim" = EXCLUDED.prim, "rk_code" = EXCLUDED.rk_code, "docfile" = EXCLUDED.docfile, 
		"gud_cod" = EXCLUDED.gud_cod, "repfile" = EXCLUDED.repfile, "rk_typ" = EXCLUDED.rk_typ, "pr_typ" = EXCLUDED.pr_typ, "rk_eais" = EXCLUDED.rk_eais, 
		"lmszid" = EXCLUDED.lmszid, "categoryid" = EXCLUDED.categoryid, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_RK' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;