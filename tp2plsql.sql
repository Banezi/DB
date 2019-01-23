-- A-3
CREATE OR REPLACE PROCEDURE raisesalary_bane(numero_dept Dept.deptno%type, dept_name Dept.dname%type, localisation Dept.loc%type)
IS 
	num_dept_exist Dept.deptno%type default 0;
BEGIN
	SELECT deptno INTO num_dept_exist FROM Dept WHERE deptno = numero_dept;
	IF(num_dept_exist != 0) THEN
		dbms_output.put_line('Le departement ' || numero_dept || ' existe deja!');
	END IF;
EXCEPTION WHEN no_data_found THEN
	INSERT INTO Dept Values(numero_dept, dept_name, localisation);
COMMIT;
END;
/