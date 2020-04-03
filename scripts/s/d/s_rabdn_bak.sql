DO $$
BEGIN
DELETE FROM s_rabdn_bak WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_RABDN_BAK' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_RABDN_BAK' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;