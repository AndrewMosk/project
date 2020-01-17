DO $$
BEGIN
DELETE FROM vac_free_pack WHERE pac_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_FREE_PACK' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_FREE_PACK' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;