﻿INSERT INTO
	cl_mvnp ("c_client", "np", "p_modi", "d_modi")
SELECT "c_client", "np", "p_modi", "d_modi"
FROM ora_cl_mvnp WHERE ora_cl_mvnp.c_client  = '%s'
ON CONFLICT ("c_client") DO UPDATE SET "np" = EXCLUDED.np, "p_modi" = EXCLUDED.p_modi, "d_modi" = EXCLUDED.d_modi;