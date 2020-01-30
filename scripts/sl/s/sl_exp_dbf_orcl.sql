DO $$
BEGIN
INSERT INTO
	sl_exp_dbf_orcl ("r", "r_parent", "n_parent", "pr_dbf_orcl", "pr_orcl_dbf", "c_group", "n_orcl", "n_dbf", "note", "pr_par", "ora_role", "fld_org")
SELECT "r", "r_parent", "n_parent", "pr_dbf_orcl", "pr_orcl_dbf", "c_group", "n_orcl", "n_dbf", "note", "pr_par", "ora_role", "org_cod" AS "fld_org"
FROM ora_sl_exp_dbf_orcl WHERE ora_sl_exp_dbf_orcl.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_parent" = EXCLUDED.r_parent, "n_parent" = EXCLUDED.n_parent, "pr_dbf_orcl" = EXCLUDED.pr_dbf_orcl, 
		"pr_orcl_dbf" = EXCLUDED.pr_orcl_dbf, "c_group" = EXCLUDED.c_group, "n_orcl" = EXCLUDED.n_orcl, "n_dbf" = EXCLUDED.n_dbf, "note" = EXCLUDED.note, 
		"pr_par" = EXCLUDED.pr_par, "ora_role" = EXCLUDED.ora_role, "fld_org" = EXCLUDED.fld_org;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_EXP_DBF_ORCL' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;