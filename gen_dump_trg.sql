set trimspool on
set feedback off
set pagesize 0
set linesize 256
set long 100000
column trigger_body format a4000
set serverout on
set verify off
set trimspool on
ACCEPT in_owner PROMPT "Enter the owner of the trigger source you would like to extract -->"
ACCEPT in_trigger PROMPT "Enter the name of the trigger source you would like to extract -->"
column in_trigger_lc new_value trg_filename
select lower('&in_trigger')||'.sql' in_trigger_lc from dual;
spool &trg_filename
select 'create or replace trigger '||description
      ,trigger_body
      ,'/'
from dba_triggers t
where t.trigger_name = upper('&in_trigger')
  and t.owner = upper('&in_owner')
/
spool off

set feedback on
set pagesize 40
set linesize 132
set verify on
