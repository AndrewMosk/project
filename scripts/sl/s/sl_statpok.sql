DO $$
BEGIN
INSERT INTO
	sl_statpok ("r_pok", "p_name1", "p_name2", "p_com", "type_pok", "p_modi", "d_modi")
SELECT "r_pok", "p_name1", "p_name2", "p_com", "type_pok", "pers_modi" AS "p_modi", "d_modi"
FROM ora_sl_statpok WHERE ora_sl_statpok.r_pok = '%s'
ON CONFLICT ("r_pok") DO UPDATE SET "p_name1" = EXCLUDED.p_name1, "p_name2" = EXCLUDED.p_name2, "p_com" = EXCLUDED.p_com, "type_pok" = EXCLUDED.type_pok, 
		"p_modi" = EXCLUDED.p_modi,	"d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_STATPOK' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;