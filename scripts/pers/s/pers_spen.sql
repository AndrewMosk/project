DO $$
BEGIN
INSERT INTO
	pers_spen ("r", "reg_num","cz_cod", "godr", "mesr", "dv", "sum_pn", "sum_pv", "sum_pp", "sum_pn1", "sum_pv1", "sum_pp1", "p_modi", "d_modi")
SELECT "r", "reg_num", "org_cod" AS "cz_cod", "godr", "mesr", "dv", "sum_pn", "sum_pv", "sum_pp", "sum_pn1", "sum_pv1", "sum_pp1", "p_modi", "d_modi"
FROM ora_pers_spen WHERE ora_pers_spen.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "cz_cod" = EXCLUDED.cz_cod, "godr" = EXCLUDED.godr, "mesr" = EXCLUDED.mesr, "dv" = EXCLUDED.dv, 
		"sum_pn" = EXCLUDED.sum_pn,	"sum_pv" = EXCLUDED.sum_pv, "sum_pp" = EXCLUDED.sum_pp, "sum_pn1" = EXCLUDED.sum_pn1, "sum_pv1" = EXCLUDED.sum_pv1, 
		"sum_pp1" = EXCLUDED.sum_pp1, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_SPEN' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;