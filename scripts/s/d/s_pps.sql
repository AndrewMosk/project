DO $$
BEGIN
DELETE FROM s_pps WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_PPS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_PPS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;