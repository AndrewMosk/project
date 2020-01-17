DO $$
BEGIN
DELETE FROM cl_mvnp WHERE c_client IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'CL_MVNP' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'CL_MVNP' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;