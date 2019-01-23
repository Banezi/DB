-- 1
DECLARE
	v_nom Emp.ename%type;
	v_salaire Emp.sal%type;
	v_commission Emp.comm%type;
	v_nomDepartement Dept.dname%type;
	
BEGIN
	SELECT Emp.ename, Emp.sal, Emp.comm, Dept.dname INTO v_nom, v_salaire, v_commission, v_nomDepartement
	FROM Emp, Dept
	WHERE Emp.deptno=Dept.deptno and Emp.ename='MILLER';
	dbms_output.put_line(v_nom || ' ' || v_salaire || ' ' || v_commission || ' ' || v_nomDepartement);
COMMIT;
END;
/

--2
DECLARE
	v_nom Emp.ename%type;
	v_salaire Emp.sal%type;
	v_commission Emp.comm%type;
	v_nomDepartement Dept.dname%type;
	
BEGIN
	SELECT Emp.ename, Emp.sal, Emp.comm, Dept.dname INTO v_nom, v_salaire, v_commission, v_nomDepartement
	FROM Emp, Dept
	WHERE Emp.deptno=Dept.deptno and Emp.ename='MILLER';
	dbms_output.put_line(v_nom || ' ' || v_salaire || ' ' || v_commission || ' ' || v_nomDepartement);
COMMIT;
END;
/

--3
DECLARE
	v_ename Emp.ename%type;
	v_empno Emp.empno%type;
	v_sal Emp.sal%type;
	Cursor curseur IS SELECT ename, empno, sal FROM emp ORDER BY sal DESC; -- Limit 5; ?
BEGIN
	OPEN curseur;
	FOR i IN 1..5 LOOP
		FETCH curseur INTO v_ename, v_empno, v_sal;
		dbms_output.put_line(v_ename || ' ' || v_empno || ' ' || v_sal);
		INSERT INTO Temp VALUES(v_sal, v_empno, v_ename);
	END LOOP;
COMMIT;
END;
/

--4
DECLARE
	v_ename Emp.ename%type;
	v_empno Emp.empno%type;
	v_sal Emp.sal%type;
	Cursor curseur IS SELECT ename, empno, sal FROM Emp WHERE nvl(sal,0)+nvl(comm,0) > 2000;
BEGIN
	OPEN curseur;
	LOOP 
		FETCH curseur INTO v_ename, v_empno, v_sal;
		EXIT WHEN(curseur%NOTFOUND);
		dbms_output.put_line(v_ename || ' ' || v_empno || ' ' || v_sal);
		INSERT INTO Temp VALUES(v_sal, v_empno, v_ename);
	END LOOP;
COMMIT;
END;
/

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