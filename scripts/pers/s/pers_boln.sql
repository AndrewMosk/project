DO $$
BEGIN
INSERT INTO
	pers_boln ("r", "reg_num", "num_bln", "bln_cod", "d_bln", "d_begin", "d_end", "d_predst", "p_modi", "d_modi")
SELECT "r", "reg_num", "num_bln", BLN.bln_cod, "d_begin" AS "d_bln", "d_begin", "d_end", "d_predst", "p_modi", "d_modi"  FROM (SELECT * 
	 FROM ora_pers_boln WHERE ora_pers_boln.r = '%s') AS ora_pers_boln_filter
		LEFT JOIN (SELECT sl_spar.par_cod AS bln_cod, sl_spar.par_code AS par_code FROM sl_spar	WHERE sl_spar.gpar_cod = '123') AS BLN
			ON ora_pers_boln_filter.p_bln = BLN.par_code
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "num_bln" = EXCLUDED.num_bln, "bln_cod" = EXCLUDED.bln_cod, "d_bln" = EXCLUDED.d_bln, 
		 	"d_begin" = EXCLUDED.d_begin, "d_end" = EXCLUDED.d_end, "d_predst" = EXCLUDED.d_predst, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_BOLN' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;