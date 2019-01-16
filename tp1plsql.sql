DECLARE
	v_numCol1 Temp.num_col1%type;
	v_numCol2 Temp.num_col2%type;
	v_charCol Temp.char_col%type;
	
	
BEGIN
	FOR i IN 1..10 LOOP
		IF mod(i,2)=0 THEN
			INSERT INTO Temp Values(i, i*100, i || ' est paire');
		ELSE
			INSERT INTO Temp Values(i, i*100, i || ' est impair');
		END IF;
	END LOOP;
COMMIT;
END;
/