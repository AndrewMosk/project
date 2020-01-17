DO $$
BEGIN
DELETE FROM cl_potrv WHERE vac_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_POTRV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_POTRV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;