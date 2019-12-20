INSERT INTO
	cl_address ("c_address", "pr_addr", "c_client", "c_post", "aoid_j", "houseid", "c_country", "c_town", "c_street", "home", "crp", "kv", "lit", "prim_addr", "txt_addr", 
		"p_modi", "d_modi")
SELECT "c_address", "pr_addr", "c_client", "c_post", "aoid_j", "houseid", "c_country", "c_town", "c_street", "home", "crp", "kv", "lit",	"prim_addr", "txt_addr", 
		"pers_modi" AS "p_modi", "d_modi"
FROM ora_cl_address WHERE ora_cl_address.c_address = '%s'
ON CONFLICT ("c_address") DO UPDATE SET "pr_addr" = EXCLUDED.pr_addr, "c_client" = EXCLUDED.c_client, "c_post" = EXCLUDED.c_post, "aoid_j" = EXCLUDED.aoid_j, 
		"houseid" = EXCLUDED.houseid, "c_country" = EXCLUDED.c_country, "c_town" = EXCLUDED.c_town, "c_street" = EXCLUDED.c_street, "home" = EXCLUDED.home, 
		"crp" = EXCLUDED.crp, "kv" = EXCLUDED.kv, "lit" = EXCLUDED.lit, "prim_addr" = EXCLUDED.prim_addr, "txt_addr" = EXCLUDED.txt_addr, "p_modi" = EXCLUDED.p_modi, 
		"d_modi" = EXCLUDED.d_modi