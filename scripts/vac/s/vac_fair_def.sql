DO $$
BEGIN
INSERT INTO
	vac_fair_def ("r", "r_fair", "def_cod", "p_modi", "d_modi")
SELECT "r", "r_fair", "def_cod", "p_modi", "d_modi"
FROM ora_vac_fair_def WHERE ora_vac_fair_def.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "r_fair" = EXCLUDED.r_fair, "def_cod" = EXCLUDED.def_cod, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FAIR_DEF' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;