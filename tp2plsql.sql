CREATE OR REPLACE FUNCTION salok_bane(p_job SalIntervalle_F2.job%type, salaire SalIntervalle_F2.lsal%type)
RETURN number
IS 
	trouve BOOLEAN := false;
	v_job SalIntervalle_F2.job%type;
BEGIN
	SELECT job INTO v_job FROM SalIntervalle_F2 WHERE lsal <= salaire or hsal >= salaire;
	dbms_output.put_line('Le salaire du job ' || p_job || ' est dans l''intervale du job ' || v_job);
	RETURN 1;
EXCEPTION WHEN no_data_found THEN
	dbms_output.put_line('Le salaire du job ' || p_job || ' n''est dans aucun intervale des job');
	RETURN 0;
COMMIT;
END;
/