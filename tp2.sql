Create procedure createdept_bane(numero_dept, dept_name, localisation)
DECLARE 
	num_dept_exist := 0;
BEGIN
	SELECT deptno INTO num_dept_exist FROM Dept WHERE deptno = numero_dept;
	if(num_dept_exist != 0) THEN
		INSERT INTO Dept Values(numero_dept, dept_name, localisation);
COMMIT;
END;
/
	