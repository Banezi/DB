--5
DECLARE
	trouve BOOLEAN := false;
	v_ename Emp.ename%type;
	v_empno Emp.empno%type;
	v_sal Emp.sal%type;
	v_mgr Emp.mgr%type;
	v_emp Emp.empno%type default 7902; 
BEGIN
	LOOP 
		SELECT empno, ename, mgr, sal INTO v_empno, v_ename, v_mgr, v_sal FROM Emp WHERE empno = v_emp;
		--dbms_output.put_line(v_empno || ' ' || v_mgr || ' ' || v_sal);
		IF v_sal > 4000 THEN
			trouve := true;
			dbms_output.put_line(v_sal || ' ' || v_ename);
			INSERT INTO Temp(num_col1, char_col) VALUES(v_sal, v_ename);
		ELSE
			v_emp := v_mgr;
		END IF;
		EXIT WHEN(trouve = true);
	END LOOP;
COMMIT;
END;
/