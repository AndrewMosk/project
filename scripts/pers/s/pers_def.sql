DO $$
BEGIN
INSERT INTO
	pers_def ("r", "reg_num", "def_cod", "d_beg", "d_end", "d_begfakt", "def_doc", "doc_date", "d_next", "rab1", "rab2", "rab3", "p_modi", "d_modi", "d_ins")
SELECT "r", "reg_num", "def_cod", "d_beg", "d_end", "d_begfakt", "def_doc", "doc_date", "d_next", "rab1", "rab2", "rab3", "p_modi", "d_modi", "d_ins"
FROM ora_pers_def WHERE ora_pers_def.r = '%s'
ON CONFLICT ("r") DO UPDATE SET "reg_num" = EXCLUDED.reg_num, "def_cod" = EXCLUDED.def_cod, "d_beg" = EXCLUDED.d_beg, "d_end" = EXCLUDED.d_end, 
		"d_begfakt" = EXCLUDED.d_begfakt, "def_doc" = EXCLUDED.def_doc,	"doc_date" = EXCLUDED.doc_date, "d_next" = EXCLUDED.d_next, "rab1" = EXCLUDED.rab1, 
		"rab2" = EXCLUDED.rab2, "rab3" = EXCLUDED.rab3, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi, "d_ins" = EXCLUDED.d_ins;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_DEF' AND "R_TABLE" = '%s';
END;
$$ LANGUAGE plpgsql;