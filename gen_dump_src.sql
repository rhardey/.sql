set feedback off
set verify off
set pagesize 0

ACCEPT in_owner PROMPT "Enter the owner of the object source you would like to extract -->"
ACCEPT in_object PROMPT "Enter the name of the object source you would like to extract -->"

spool dump_src_driver.sql
select *
from (
   select '@gen_dump_src_dba &&in_owner &&in_object' from all_objects where object_name = 'DBA_TABLES' and object_type = 'VIEW'
   union all
   select '@gen_dump_src_all &&in_owner &&in_object' from all_objects where object_name = 'ALL_TABLES' and object_type = 'VIEW'
)
where rownum = 1
/
spool off

@dump_src_driver.sql

ho del dump_src_driver.sql

set feedback on
set verify on
set pagesize 40
