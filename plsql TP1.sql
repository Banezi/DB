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