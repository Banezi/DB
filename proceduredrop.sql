create or replace procedure PROC_DROP_TABLE(tableName varchar2)
is
   c int;
begin
   select count(*) into c from user_tables where table_name = upper(tableName);
   if c = 1 then
      execute immediate 'drop table '||tableName;
   end if;
end;
/