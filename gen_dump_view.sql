set feedback off
set pagesize 0
set linesize 256
set long 100000
--column text format a100000
set serverout on
set verify off
ACCEPT in_owner PROMPT "Enter the owner of the view source you would like to extract -->"
ACCEPT in_view PROMPT "Enter the name of the view source you would like to extract -->"
spool dump_view_driver.sql
select *
from (
   select '@gen_dump_view_dba &&in_owner &&in_view' from all_objects where object_name = 'DBA_VIEWS' and object_type = 'VIEW'
   union all
   select '@gen_dump_view_all &&in_owner &&in_view' from all_objects where object_name = 'ALL_VIEWS' and object_type = 'VIEW'
)
where rownum = 1
/
spool off

@dump_view_driver &in_owner &in_view

ho del dump_view_driver.sql

set feedback on
set pagesize 40
set linesize 132
set verify on
