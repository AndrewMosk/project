DO $$
BEGIN
INSERT INTO
	prof_agr ("agr_cod", "cz_cod", "c_client", "agr_type", "agr_num", "agr_anum", "cod_kont_s", "cod_kont_a", "agr_beg", "agr_end", "agr_count", 
		"prof_agr_add", "agr_vid", "vid_ob", "vid_zan", "rem_text", "p_modi", "d_modi")
SELECT "agr_cod", "org_cod" AS "cz_cod", "c_client", "agr_type", "agr_num", "agr_anum", "cod_kont_s", "cod_kont_a", "agr_beg", "agr_end", "agr_count", 
		"prof_agr_add", "agr_vid", "vid_ob", "vid_zan", "rem_text", "p_modi", "d_modi"
FROM ora_prof_agrr WHERE ora_prof_agrr.agr_cod = '%s'
ON CONFLICT ("agr_cod") DO UPDATE SET "cz_cod" = EXCLUDED.cz_cod, "c_client" = EXCLUDED.c_client, "agr_type" = EXCLUDED.agr_type, 
		"agr_num" = EXCLUDED.agr_num, "agr_anum" = EXCLUDED.agr_anum, "cod_kont_s" = EXCLUDED.cod_kont_s, "cod_kont_a" = EXCLUDED.cod_kont_a, 
		"agr_beg" = EXCLUDED.agr_beg, "agr_end" = EXCLUDED.agr_end, "agr_count" = EXCLUDED.agr_count, "prof_agr_add" = EXCLUDED.prof_agr_add, 
		"agr_vid" = EXCLUDED.agr_vid, "vid_ob" = EXCLUDED.vid_ob, "vid_zan" = EXCLUDED.vid_zan, "rem_text" = EXCLUDED.rem_text, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi;
--удаляю обработанные строки из оракл		
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_AGR' AND "R_TABLE"  = '%s';
END;
$$ LANGUAGE plpgsql;